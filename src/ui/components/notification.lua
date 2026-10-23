local Addon = select(2, ...) ---@type Addon
local TickerManager = Addon:GetModule("TickerManager")
local Widgets = Addon:GetModule("Widgets")

--- @class ComponentFactory
local ComponentFactory = Addon:GetModule("ComponentFactory")

-- =============================================================================
-- ComponentFactory - Notification
-- =============================================================================

--- Creates a line of text on a backdrop that fades in and out. It takes no space until `Notify()` is called,
--- and is no longer visible once it has faded out.
--- @return NotificationComponent root
function ComponentFactory:Notification()
  local root

  --- @class NotificationComponent : WaffleFlexComponent
  root = Addon.Waffle:Flex({
    width = "AUTO",
    height = "AUTO",
    visibility = "GONE",

    --- @param parent Frame
    frameFactory = function(parent)
      --- @class NotificationWidget : FrameWidget
      local frame = Widgets:Frame({ parent = parent })

      -- Hidden, so that the first `Show()` plays the animation.
      frame:Hide()

      --- Text shown on the notification.
      frame.fontString = frame:CreateFontString("$parent_FontString", "OVERLAY", "ErrorFont")
      frame.fontString:SetTextColor(1, 1, 1)
      frame.fontString:SetPoint("CENTER")

      --- Returns the text to show. Set by `Notify()`.
      frame.getText = function() return "" end

      frame.animationGroup = frame:CreateAnimationGroup()

      local fadeIn = frame.animationGroup:CreateAnimation("Alpha")
      fadeIn:SetFromAlpha(0)
      fadeIn:SetToAlpha(1)
      fadeIn:SetDuration(Addon.NOTIFICATION_FADE_IN)
      fadeIn:SetStartDelay(0)
      fadeIn:SetSmoothing("IN")

      frame.fadeOut = frame.animationGroup:CreateAnimation("Alpha")
      frame.fadeOut:SetFromAlpha(1)
      frame.fadeOut:SetToAlpha(0)
      frame.fadeOut:SetDuration(Addon.NOTIFICATION_FADE_OUT)
      frame.fadeOut:SetStartDelay(Addon.NOTIFICATION_HOLD)
      frame.fadeOut:SetSmoothing("OUT")

      -- Showing the frame starts the animation, and the notification hides once it finishes.
      frame:HookScript("OnShow", function() frame.animationGroup:Play() end)
      frame.animationGroup:HookScript("OnFinished", function()
        frame:Hide()
        root:SetVisibility("GONE")
      end)

      -- Re-read the text while shown, and resize the notification when it changes.
      TickerManager:NewTicker(0.1, function()
        local text = frame.getText()
        if text ~= frame.fontString:GetText() then
          frame.fontString:SetText(text)
          root:MarkDirty()
        end
      end):BindFrame(frame)

      return frame
    end,

    --- @param frame NotificationWidget
    onMeasure = function(frame)
      return frame.fontString:GetStringWidth() + Widgets:Padding(), frame.fontString:GetStringHeight() + Widgets:Padding()
    end
  })

  --- Shows the notification and plays its animation.
  --- @param getText fun(): string Returns the text to show.
  function root:Notify(getText)
    self:WhenFrameReady(function(frame)
      --- @cast frame NotificationWidget
      frame:SetBackdropColor(0, 0, 0, Addon.NOTIFICATION_ALPHA)
      frame:SetBackdropBorderColor(0, 0, 0, Addon.NOTIFICATION_ALPHA)
      frame.getText = getText
      frame.fontString:SetText(getText())
    end)

    self:SetVisibility("VISIBLE")
  end

  --- Hides the notification, even while it is still animating. Does nothing if it is already hidden.
  function root:Kill()
    if not self:IsVisible() then return end

    self:WhenFrameReady(function(frame)
      --- @cast frame NotificationWidget
      frame.animationGroup:Stop()
      frame:Hide()
    end)

    self:SetVisibility("GONE")
  end

  return root
end
