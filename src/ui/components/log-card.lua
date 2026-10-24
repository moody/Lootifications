local Addon = select(2, ...) ---@type Addon
local Colors = Addon:GetModule("Colors")
local Widgets = Addon:GetModule("Widgets")

--- @class ComponentFactory
local ComponentFactory = Addon:GetModule("ComponentFactory")

--- Width of the accent strip on the card's left edge.
local ACCENT_WIDTH = 3

-- =============================================================================
-- ComponentFactory - LogCard
-- =============================================================================

--- Creates a card for one log entry: a one-line title, then a grey line with details and the age. Hovering a card
--- that has a link highlights it and shows the item's tooltip.
--- @return LogCardComponent root
function ComponentFactory:LogCard()
  local frame ---@type FrameWidget?
  local accent ---@type Texture?
  local icon ---@type Texture?
  local link ---@type string?
  local accentR, accentG, accentB = 1, 1, 1
  local iconTexture ---@type (string | number)?

  --- Brightens the card while hovered, if it has a link.
  local function refreshBackdrop()
    if not frame then return end

    local isHighlighted = link and frame:GetEventValue("HOVERED")
    frame:SetBackdropColor(Colors.White:GetRGBA(isHighlighted and 0.06 or 0.03))
  end

  --- @class LogCardComponent : WaffleFlexComponent
  local root = Addon.Waffle:Flex({
    align = "CENTER",
    paddingLeft = ACCENT_WIDTH,

    --- @param parent Frame
    frameFactory = function(parent)
      frame = Widgets:Frame({
        parent = parent,
        frameType = "Button",

        --- @param tooltip Tooltip
        onUpdateTooltip = function(_, tooltip)
          if link then
            tooltip:SetHyperlink(link)
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

  -- Icon, which takes no space while it is not set.
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

  --- Sets the card's content.
  --- @param titleText string Shown on one line, truncated if long.
  --- @param detailText string Grey text on the left of the second line.
  --- @param ageText string Grey text on the right of the second line.
  --- @param itemLink? string Item shown in the tooltip.
  function root:Set(titleText, detailText, ageText, itemLink)
    title:SetText(titleText)
    detail:SetText(detailText)
    age:SetText(ageText)
    link = itemLink
    refreshBackdrop()
  end

  --- Sets the icon shown before the title and details, or removes it with `nil`.
  --- @param texture? string | number
  function root:SetIcon(texture)
    iconTexture = texture
    if icon then icon:SetTexture(texture) end
    iconNode:SetVisibility(texture and "VISIBLE" or "GONE")
  end

  --- Sets the color of the strip on the card's left edge.
  --- @param r number
  --- @param g number
  --- @param b number
  function root:SetAccentColor(r, g, b)
    accentR, accentG, accentB = r, g, b
    if accent then accent:SetColorTexture(r, g, b) end
  end

  return root
end
