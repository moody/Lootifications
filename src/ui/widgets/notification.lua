local _, Addon = ...
local Widgets = Addon:GetModule("Widgets")

--- @class NotificationOptions : FrameOptions
--- @field fontLayer? string
--- @field fontTemplate? string

--- Creates a frame with a font string and animations for displaying notifications.
--- @param options NotificationOptions
--- @return table frame
function Widgets:Notification(options)
  -- Defaults.
  options.frameType = "Frame"
  Addon:IfKeyNil(options, "fontLayer", "OVERLAY")
  Addon:IfKeyNil(options, "fontTemplate", "ErrorFont")

  -- Base frame.
  local frame = self:Frame(options)
  frame:SetBackdropColor(0, 0, 0, 0.3)
  frame:SetBackdropBorderColor(0, 0, 0, 0.3)

  -- Font string.
  frame.fontString = frame:CreateFontString("$parent_FontString", options.fontLayer, options.fontTemplate)
  frame.fontString:SetTextColor(1, 1, 1)
  frame.fontString:SetPoint("CENTER")

  -- Animations.
  frame.animationGroup = frame:CreateAnimationGroup()

  frame.animationGroup.fadeIn = frame.animationGroup:CreateAnimation("Alpha")
  frame.animationGroup.fadeIn:SetFromAlpha(0)
  frame.animationGroup.fadeIn:SetToAlpha(1)
  frame.animationGroup.fadeIn:SetDuration(0.1)
  frame.animationGroup.fadeIn:SetStartDelay(0)
  frame.animationGroup.fadeIn:SetSmoothing("IN")

  frame.animationGroup.fadeOut = frame.animationGroup:CreateAnimation("Alpha")
  frame.animationGroup.fadeOut:SetFromAlpha(1)
  frame.animationGroup.fadeOut:SetToAlpha(0)
  frame.animationGroup.fadeOut:SetDuration(1)
  frame.animationGroup.fadeOut:SetStartDelay(4)
  frame.animationGroup.fadeOut:SetSmoothing("OUT")

  frame.animationGroup:HookScript("OnPlay", function()
    frame:Show()
  end)

  frame.animationGroup:HookScript("OnFinished", function()
    frame:Hide()
    if frame.animationGroup.callback then
      frame.animationGroup.callback()
    end
  end)

  --- Sets the notification's font string text and plays its animation.
  --- @param text string
  function frame:Notify(text)
    self.fontString:SetText(text)
    self:SetWidth(self.fontString:GetWidth() + Widgets:Padding())
    self:SetHeight(self.fontString:GetHeight() + Widgets:Padding())
    self.animationGroup:Play()
  end

  --- Sets a callback to be executed once the notification's animation finishes.
  --- @param callback function
  function frame:SetCallback(callback)
    frame.animationGroup.callback = callback
  end

  return frame
end
