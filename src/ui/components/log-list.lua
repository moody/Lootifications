local Addon = select(2, ...) ---@type Addon
local Colors = Addon:GetModule("Colors")
local HistoryLog = Addon:GetModule("HistoryLog")
local L = Addon:GetModule("Locale")
local TickerManager = Addon:GetModule("TickerManager")
local Widgets = Addon:GetModule("Widgets")

--- @class ComponentFactory
local ComponentFactory = Addon:GetModule("ComponentFactory")

--- Number of cards, which share the list's height. Older entries are reached by scrolling.
local CARD_COUNT = 7

-- =============================================================================
-- ComponentFactory - LogList
-- =============================================================================

--- Creates the list of logged entries, newest first, scrolled with the mouse wheel or a slider.
--- @return LogListComponent root
function ComponentFactory:LogList()
  local slider = Widgets:Slider({ orientation = "VERTICAL" })
  slider:Hide()

  --- Shown in the middle of the list while the log is empty.
  local emptyText ---@type FontString?

  --- Number of entries the last refresh saw.
  local lastCount = 0

  --- Cards, from the top.
  --- @type LogCardComponent[]
  local cards = {}

  --- @class LogListComponent : WaffleFlexComponent
  local root = Addon.Waffle:Flex({
    gap = Widgets:Padding(0.5),

    --- @param parent Frame
    frameFactory = function(parent)
      local frame = Widgets:Frame({ parent = parent, backdrop = false, clipChildren = false })
      frame:EnableMouseWheel(true)
      frame:SetScript("OnMouseWheel", function(_, delta)
        slider:SetValue(slider:GetValue() - delta)
      end)

      emptyText = frame:CreateFontString("$parent_EmptyText", "ARTWORK", "GameFontNormal")
      emptyText:SetPoint("CENTER")
      emptyText:SetTextColor(Colors.Grey:GetRGB())
      emptyText:SetText(L.NOTHING_LOOTED_YET)

      return frame
    end
  })

  -- Cards.
  local cardColumn = root:AddColumn({ gap = Widgets:Padding(0.5) })
  -- Slider, shown only while the list can scroll.
  local sliderColumn = root:AddColumn({ frame = slider, width = 12, visibility = "GONE" })

  for i = 1, CARD_COUNT do
    cards[i] = cardColumn:AttachComponent(ComponentFactory:LogCard())
  end

  --- Shows the entries from the scrolled position on the cards, and sizes the slider to the log.
  local function refresh()
    local entries = HistoryLog:GetEntries()
    local count = #entries
    emptyText:SetShown(count == 0)

    local maxOffset = math.max(count - CARD_COUNT, 0)
    local _, sliderMax = slider:GetMinMaxValues()
    if sliderMax ~= maxOffset then slider:SetMinMaxValues(0, maxOffset) end

    -- Scroll down with each new entry, so the entries being read stay still.
    local addedCount = count - lastCount
    lastCount = count
    if addedCount > 0 and slider:GetValue() > 0 then
      slider:SetValue(slider:GetValue() + addedCount)
    end

    local isScrollable = maxOffset > 0
    if isScrollable ~= sliderColumn:IsVisible() then
      sliderColumn:SetVisibility(isScrollable and "VISIBLE" or "GONE")
      if isScrollable then
        -- Re-show the slider a frame later, or its thumb stays invisible.
        TickerManager:After(0, function()
          if not slider:IsShown() then return end
          slider:Hide()
          slider:Show()
        end)
      end
    end

    local offset = math.floor(slider:GetValue() + 0.5)
    for i, card in ipairs(cards) do
      card:SetEntry(entries[count - offset - (i - 1)])
    end

    root:Layout()
  end

  slider:SetScript("OnValueChanged", refresh)

  root:WhenFrameReady(function(frame)
    frame:HookScript("OnShow", function()
      slider:SetValue(0)
      refresh()
    end)
    TickerManager:NewTicker(0.1, refresh):BindFrame(frame)
  end)

  return root
end
