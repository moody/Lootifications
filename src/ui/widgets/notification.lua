local Addon = select(2, ...) ---@type Addon

--- @class Widgets
local Widgets = Addon:GetModule("Widgets")

-- =============================================================================
-- LuaCATS Annotations
-- =============================================================================

--- @class NotificationWidgetOptions : FrameWidgetOptions
--- @field fontLayer? string
--- @field fontTemplate? string

-- =============================================================================
-- Widgets - Notification
-- =============================================================================

--- Creates a frame with a font string and animations for displaying notifications.
--- @param options NotificationWidgetOptions
--- @return NotificationWidget
function Widgets:Notification(options)
  -- Defaults.
  options.frameType = "Frame"
  Addon:IfKeyNil(options, "fontLayer", "OVERLAY")
  Addon:IfKeyNil(options, "fontTemplate", "ErrorFont")

  --- @class NotificationWidget : FrameWidget
  local frame = self:Frame(options)
  frame:SetBackdropColor(0, 0, 0, 0.3)
  frame:SetBackdropBorderColor(0, 0, 0, 0.3)

  -- Font string.
  frame.fontString = frame:CreateFontString("$parent_FontString", options.fontLayer, options.fontTemplate)
  frame.fontString:SetTextColor(1, 1, 1)
  frame.fontString:SetPoint("CENTER")

  --- @class NotificationAnimationGroup : AnimationGroup
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
  frame.animationGroup.fadeOut:SetDuration(0.25)
  frame.animationGroup.fadeOut:SetStartDelay(0)
  frame.animationGroup.fadeOut:SetSmoothing("OUT")

  frame.animationGroup:HookScript("OnPlay", function()
    frame:Show()
  end)

  frame.animationGroup:HookScript("OnFinished", function()
    if frame.animationGroup.callback then
      frame.animationGroup.callback()
      frame.animationGroup.callback = nil
    end

    frame:Hide()
  end)

  --- Sets the notification's properties and plays its animation.
  --- @param text string The text to be displayed by the notification.
  --- @param backdropAlpha number The backdrop alpha of the notification.
  --- @param fadeOutDelay number The amount of time before the notification fades out, in seconds.
  --- @param callback? function The callback to be executed once the notification's animation finishes.
  function frame:Notify(text, backdropAlpha, fadeOutDelay, callback)
    self.fontString:SetText(text)

    self:SetWidth(self.fontString:GetWidth() + Widgets:Padding())
    self:SetHeight(self.fontString:GetHeight() + Widgets:Padding())

    backdropAlpha = math.min(math.max(backdropAlpha, 0), 1)
    self:SetBackdropColor(0, 0, 0, backdropAlpha)
    self:SetBackdropBorderColor(0, 0, 0, backdropAlpha)

    self.animationGroup.fadeOut:SetStartDelay(fadeOutDelay)
    self.animationGroup.callback = callback
    self.animationGroup:Play()
  end

  --- Stops the notification's animation and hides it.
  function frame:Kill()
    self.animationGroup.callback = nil
    self.animationGroup:Stop()
    self:Hide()
  end

  return frame
end
