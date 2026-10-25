local Addon = select(2, ...) ---@type Addon
local B = Addon:GetModule("Blizzard")
local Colors = Addon:GetModule("Colors")
local HistoryLog = Addon:GetModule("HistoryLog")
local ItemLogger = Addon:GetModule("ItemLogger")
local L = Addon:GetModule("Locale")
local MoneyLogger = Addon:GetModule("MoneyLogger")
local Widgets = Addon:GetModule("Widgets")

--- @class ComponentFactory
local ComponentFactory = Addon:GetModule("ComponentFactory")

--- Width of the accent strip on the card's left edge.
local ACCENT_WIDTH = 3

-- =============================================================================
-- Local Functions
-- =============================================================================

--- Returns how long ago something was, as the largest whole unit: hours, minutes, or seconds.
--- @param seconds number Time elapsed.
--- @return string
local function getAgeText(seconds)
  seconds = math.max(math.floor(seconds), 0)
  if seconds >= 3600 then return B.Strings.HOURS_ABBREVIATED_TEXT:format(math.floor(seconds / 3600)) end
  if seconds >= 60 then return B.Strings.MINUTES_ABBREVIATED_TEXT:format(math.floor(seconds / 60)) end
  return B.Strings.SECONDS_ABBREVIATED_TEXT:format(seconds)
end

--- Returns the title, the details, and the icon of the entry.
--- @param entry HistoryLogEntry
--- @return string title
--- @return string details
--- @return (string | number)? icon
local function getContent(entry)
  if entry.logger == ItemLogger then
    local payload = entry.payload
    local _, _, texture = B.Items:GetInfo(payload.link)
    return payload.link, L.QUANTITY_FORMAT:format(Colors.White(payload.quantity)),
        texture or "Interface\\Icons\\INV_Misc_QuestionMark"
  elseif entry.logger == MoneyLogger then
    return B.Money:GetCoinText(entry.payload.copper), L.MONEY
  end

  return "", ""
end

--- Shows an item's tooltip, or the amount for money.
--- @param tooltip Tooltip
--- @param entry HistoryLogEntry
local function showTooltip(tooltip, entry)
  if entry.logger == ItemLogger then
    tooltip:SetHyperlink(entry.payload.link)
  elseif entry.logger == MoneyLogger then
    tooltip:SetText(B.Money:GetCoinText(entry.payload.copper))
  end
end

-- =============================================================================
-- ComponentFactory - LogCard
-- =============================================================================

--- Creates a card that shows a history entry: a one-line title, then a grey line with details and the age. Hovering
--- highlights it and shows a tooltip. It is not visible until it has an entry.
--- @return LogCardComponent root
function ComponentFactory:LogCard()
  local frame ---@type FrameWidget?
  local accent ---@type Texture?
  local icon ---@type Texture?
  local entry ---@type HistoryLogEntry?
  local accentR, accentG, accentB = 1, 1, 1
  local iconTexture ---@type (string | number)?

  --- Brightens the card while hovered, if it has an entry.
  local function refreshBackdrop()
    if not frame then return end

    local isHighlighted = entry and frame:GetEventValue("HOVERED")
    frame:SetBackdropColor(Colors.White:GetRGBA(isHighlighted and 0.06 or 0.03))
  end

  --- @class LogCardComponent : WaffleFlexComponent
  local root = Addon.Waffle:Flex({
    align = "CENTER",
    paddingLeft = ACCENT_WIDTH,
    visibility = "INVISIBLE",

    --- @param parent Frame
    frameFactory = function(parent)
      frame = Widgets:Frame({
        parent = parent,
        frameType = "Button",

        --- @param tooltip Tooltip
        onUpdateTooltip = function(_, tooltip)
          if entry then
            showTooltip(tooltip, entry)
          else
            tooltip:Hide()
          end
        end
      })
      frame:SetBackdropBorderColor(0, 0, 0, 0)
      frame:OnEvent("HOVERED", refreshBackdrop)
      refreshBackdrop()

      accent = frame:CreateTexture("$parent_Accent", "ARTWORK")
      accent:SetWidth(ACCENT_WIDTH)
      accent:SetPoint("TOPLEFT")
      accent:SetPoint("BOTTOMLEFT")
      accent:SetColorTexture(accentR, accentG, accentB)

      return frame
    end
  })

  -- Content, beside the accent strip.
  local content = root:AddRow({
    height = "AUTO",
    align = "CENTER",
    gap = Widgets:Padding(),
    padding = Widgets:Padding()
  })

  -- Icon, which takes no space while there is none.
  local iconNode = content:AddChild({
    width = 32,
    height = 32,
    visibility = "GONE",

    --- @param parent Frame
    frameFactory = function(parent)
      icon = parent:CreateTexture(nil, "ARTWORK")
      icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
      icon:SetTexture(iconTexture)
      return icon
    end
  })

  -- Title above the details.
  local lines = content:AddColumn({ height = "AUTO", gap = Widgets:Padding(0.25) })

  -- Title.
  local title = lines:AttachComponent(ComponentFactory:Text({
    fontObject = "GameFontNormalLarge",
    wordWrap = false,
    truncationTooltip = false
  })) --[[@as TextComponent]]

  -- Details and age.
  local details = lines:AddRow({ height = "AUTO", gap = Widgets:Padding() })

  -- Details.
  local detail = details:AttachComponent(ComponentFactory:Text({
    fontObject = "GameFontNormalSmall",
    color = Colors.Grey,
    wordWrap = false,
    truncationTooltip = false
  })) --[[@as TextComponent]]

  -- Age.
  local age = details:AttachComponent(ComponentFactory:Text({
    fontObject = "GameFontNormalSmall",
    color = Colors.Grey,
    justifyH = "RIGHT",
    width = "AUTO"
  })) --[[@as TextComponent]]

  --- Shows the entry, or hides the card if it has none or it is not an item or money. Call it again to refresh the
  --- text.
  --- @param newEntry? HistoryLogEntry
  function root:SetEntry(newEntry)
    if not (newEntry and (newEntry.logger == ItemLogger or newEntry.logger == MoneyLogger)) then
      entry = nil
      root:SetVisibility("INVISIBLE")
      refreshBackdrop()
      return
    end

    local entryChanged = newEntry ~= entry
    entry = newEntry
    root:SetVisibility("VISIBLE")
    refreshBackdrop()

    local titleText, detailText, texture = getContent(newEntry)
    title:SetText(titleText)
    detail:SetText(detailText)
    age:SetText(getAgeText(time() - newEntry.time))

    -- Icon, if there is one.
    iconTexture = texture
    if icon then icon:SetTexture(texture) end
    iconNode:SetVisibility(texture and "VISIBLE" or "GONE")

    -- Accent strip.
    accentR, accentG, accentB = (HistoryLog:GetColor(newEntry) or Colors.QualityCommon):GetRGB()
    if accent then accent:SetColorTexture(accentR, accentG, accentB) end

    -- A card under the mouse gets no new enter event when its entry changes, so refresh its tooltip.
    if entryChanged and frame and frame:IsVisible() and frame:IsMouseOver() then frame:UpdateTooltip() end
  end

  return root
end
