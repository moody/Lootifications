local _, Addon = ...
local Widgets = Addon:GetModule("Widgets")

--- @class FrameOptions
--- @field name? string
--- @field frameType? string
--- @field parent? table
--- @field points? table[]
--- @field width? number
--- @field height? number

--- Creates a basic frame with a backdrop.
---@param options FrameOptions
---@return table frame
function Widgets:Frame(options)
  -- Defaults.
  Addon:IfKeyNil(options, "frameType", "Frame")
  Addon:IfKeyNil(options, "parent", UIParent)
  Addon:IfKeyNil(options, "width", 1)
  Addon:IfKeyNil(options, "height", 1)

  -- Base frame.
  local frame = CreateFrame(options.frameType, options.name, options.parent)
  frame:SetClipsChildren(true)

  -- Backdrop.
  Mixin(frame, BackdropTemplateMixin)
  frame:SetBackdrop(self.BORDER_BACKDROP)
  frame:SetBackdropColor(0, 0, 0, 0.75)
  frame:SetBackdropBorderColor(0, 0, 0, 1)

  -- Size.
  frame:SetWidth(options.width)
  frame:SetHeight(options.height)

  -- Points.
  if options.points then
    for _, point in ipairs(options.points) do
      frame:SetPoint(SafeUnpack(point))
    end
  end

  return frame
end
