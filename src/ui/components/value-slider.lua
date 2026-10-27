local Addon = select(2, ...) ---@type Addon
local Colors = Addon:GetModule("Colors")
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local Widgets = Addon:GetModule("Widgets")

--- @class ComponentFactory
local ComponentFactory = Addon:GetModule("ComponentFactory")

--- Height of the slider, which is the height of its thumb.
local SLIDER_HEIGHT = 14

--- Width of the thumb.
local THUMB_WIDTH = 8

--- Height of the track behind the thumb.
local TRACK_HEIGHT = 4

-- =============================================================================
-- LuaCATS Annotations
-- =============================================================================

--- @class ValueSliderComponentOptions
--- @field minValue integer
--- @field maxValue integer
--- @field step integer Distance between the values the slider stops at.
--- @field get fun(): integer Returns the value.
--- @field set fun(value: integer) Called with the new value while the slider is dragged.

-- =============================================================================
-- ComponentFactory - ValueSlider
-- =============================================================================

--- Creates a horizontal slider with its value shown to the right.
--- @param options ValueSliderComponentOptions
--- @return WaffleFlexComponent root
function ComponentFactory:ValueSlider(options)
  local slider = Widgets:Slider({
    orientation = "HORIZONTAL",
    height = SLIDER_HEIGHT,
    backdrop = false,
    minValue = options.minValue,
    maxValue = options.maxValue,
    valueStep = options.step
  })

  -- Thin dark line behind the thumb.
  local track = slider:CreateTexture("$parent_Track", "BACKGROUND")
  track:SetColorTexture(Colors.Black:GetRGBA(0.5))
  track:SetPoint("LEFT")
  track:SetPoint("RIGHT")
  track:SetHeight(TRACK_HEIGHT)

  -- Part of the track up to the thumb's center.
  local fill = slider:CreateTexture("$parent_Fill", "BORDER")
  fill:SetColorTexture(Colors.Purple:GetRGBA(0.8))
  fill:SetPoint("LEFT", track, "LEFT")
  fill:SetPoint("RIGHT", slider.texture, "CENTER")
  fill:SetHeight(TRACK_HEIGHT)

  slider.texture:SetSize(THUMB_WIDTH, SLIDER_HEIGHT)

  local isDragging = false

  --- Brightens the thumb while hovered, and colors it while dragged.
  local function refreshThumb()
    local color = Colors.Grey
    if isDragging then
      color = Colors.Purple
    elseif slider:GetEventValue("HOVERED") then
      color = Colors.White
    end

    slider.texture:SetColorTexture(color:GetRGBA())
  end

  slider:OnEvent("HOVERED", refreshThumb)
  slider:SetScript("OnMouseDown", function()
    isDragging = true
    refreshThumb()
  end)
  slider:SetScript("OnMouseUp", function()
    isDragging = false
    refreshThumb()
  end)
  refreshThumb()

  local root = Addon.Waffle:Flex({
    height = "AUTO",
    align = "CENTER",
    paddingTop = Widgets.CONTROL_PADDING,
    paddingBottom = Widgets.CONTROL_PADDING,
    gap = Widgets:Padding(),

    --- @param parent Frame
    frameFactory = function(parent)
      return Widgets:Frame({ parent = parent, backdrop = false })
    end
  })

  root:AddChild({ frame = slider, height = SLIDER_HEIGHT })

  --- @type TextComponent
  local valueText = root:AttachComponent(ComponentFactory:Text({
    width = 20,
    fontObject = Widgets.CONTROL_FONT,
    justifyH = "RIGHT",
    wordWrap = false
  }))

  --- Shows the value in the state.
  local function refresh()
    local value = options.get()
    if slider:GetValue() ~= value then slider:SetValue(value) end
    valueText:SetText(tostring(value))
  end

  slider:SetScript("OnValueChanged", function(_, value)
    value = math.floor(value + 0.5)
    if value ~= options.get() then options.set(value) end
  end)

  root:WhenFrameReady(function(frame)
    frame:HookScript("OnShow", refresh)
    EventManager:On(E.StateUpdated, refresh)
    refresh()
  end)

  return root
end
