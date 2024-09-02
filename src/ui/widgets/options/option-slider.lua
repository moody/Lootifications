local Addon = select(2, ...) ---@type Addon
local Colors = Addon:GetModule("Colors")

--- @class Widgets
local Widgets = Addon:GetModule("Widgets")

-- =============================================================================
-- LuaCATS Annotations
-- =============================================================================

--- @class OptionSliderWidgetOptions : FrameWidgetOptions
--- @field labelText string
--- @field tooltipText? string
--- @field minValue number
--- @field maxValue number
--- @field valueStep? number
--- @field get fun(): number
--- @field set fun(value: number)

-- =============================================================================
-- Widgets - Option Slider
-- =============================================================================

--- Creates a toggleable option slider.
--- @param options OptionSliderWidgetOptions
--- @return OptionSliderWidget frame
function Widgets:OptionSlider(options)
  -- Defaults.
  options.name = Addon:IfNil(options.name, Widgets:GetUniqueName("OptionSlider"))

  --- @class OptionSliderWidget : FrameWidget, Button
  local frame = self:Frame(options)
  frame:SetBackdropColor(Colors.DarkGrey:GetRGBA(0.25))
  frame:SetBackdropBorderColor(Colors.White:GetRGBA(0.25))

  -- Slider text.
  frame.sliderText = frame:CreateFontString("$parent_Label", "ARTWORK", "GameFontNormalLarge")
  frame.sliderText:SetTextColor(Colors.Yellow:GetRGB())
  frame.sliderText:SetPoint("RIGHT", frame, -Widgets:Padding(), 0)
  frame.sliderText:SetWordWrap(false)
  frame.sliderText:SetJustifyH("RIGHT")
  frame.sliderText:SetWidth(40)

  -- Slider.
  frame.slider = self:Slider({
    name = "$parent_Slider",
    parent = frame,
    orientation = "HORIZONTAL",
    points = { { "RIGHT", frame.sliderText, "LEFT", -Widgets:Padding(0.5), 0 } },
    width = 120,
    minValue = options.minValue,
    maxValue = options.maxValue,
    valueStep = options.valueStep,
    set = options.set
  })

  frame.slider:SetScript("OnValueChanged", function(self, value)
    frame.sliderText:SetText(tostring(value))
  end)

  -- Label text.
  frame.label = frame:CreateFontString("$parent_Label", "ARTWORK", "GameFontNormal")
  frame.label:SetText(Colors.White(options.labelText))
  frame.label:SetPoint("LEFT", frame, Widgets:Padding(), 0)
  frame.label:SetPoint("RIGHT", frame.slider, "LEFT", -Widgets:Padding(0.5), 0)
  frame.label:SetWordWrap(false)
  frame.label:SetJustifyH("LEFT")

  -- Tooltip hover frame.
  frame.tooltipArea = self:Frame({
    name = "$parent_TooltipArea",
    parent = frame,
    points = { { "TOPLEFT" }, { "BOTTOMLEFT" }, { "RIGHT", frame.label, 0, 0 } },
    onUpdateTooltip = options.tooltipText and function(self, tooltip)
      tooltip:SetOwner(frame, "ANCHOR_TOP")
      tooltip:SetText(options.labelText)
      tooltip:AddLine(options.tooltipText)
    end
  })
  frame.tooltipArea:SetBackdrop(nil)

  -- Set frame height.
  local labelHeight = frame.label:GetStringHeight()
  frame:SetHeight(labelHeight + Widgets:Padding(2))

  -- OnShow event.
  frame:SetScript("OnShow", function()
    local value = options.get()
    frame.slider:SetValue(value)
    frame.sliderText:SetText(tostring(value))
  end)

  return frame
end
