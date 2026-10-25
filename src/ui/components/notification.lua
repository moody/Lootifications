local Addon = select(2, ...) ---@type Addon
local Colors = Addon:GetModule("Colors")
local HistoryLog = Addon:GetModule("HistoryLog")
local TickerManager = Addon:GetModule("TickerManager")
local Widgets = Addon:GetModule("Widgets")

--- @class ComponentFactory
local ComponentFactory = Addon:GetModule("ComponentFactory")

--- Pixels that a new notification slides in from, against the way the stack grows.
local SLIDE_DISTANCE = 10

--- Pixels that a notification drifts while it fades out, the way the stack grows.
local DRIFT_DISTANCE = 6

--- How quickly a displaced content settles into place. Higher is quicker.
local SETTLE_RATE = 16

--- Opacity of the background with the `HIGH_CONTRAST` style.
local HIGH_CONTRAST_ALPHA = 0.95

-- =============================================================================
-- Local Functions
-- =============================================================================

--- Returns the text of the frame's entry, or an empty string if it has none.
--- @param frame NotificationWidget
--- @return string
local function getText(frame)
  return frame.entry and HistoryLog:GetText(frame.entry) or ""
end

--- Shows the entry on the frame, and returns whether its text changed.
--- @param frame NotificationWidget
--- @param entry? HistoryLogEntry
--- @return boolean
local function setEntry(frame, entry)
  frame.entry = entry

  local text = getText(frame)
  if text == frame.content.fontString:GetText() then return false end

  frame.content.fontString:SetText(text)
  return true
end

--- Places the content `y` pixels above its place in the frame.
--- @param frame NotificationWidget
--- @param y number
local function setOffset(frame, y)
  frame.offsetY = y
  frame.content:ClearAllPoints()
  frame.content:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, y)
  frame.content:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, y)
end

--- Moves the content toward its place, and stops once it is there.
--- @param frame NotificationWidget
--- @param elapsed number
local function settle(frame, elapsed)
  local y = frame.offsetY * math.exp(-SETTLE_RATE * elapsed)
  if math.abs(y) < 0.1 then
    y = 0
    frame:SetScript("OnUpdate", nil)
  end

  setOffset(frame, y)
end

--- Places the content `y` pixels above its place, then settles it.
--- @param frame NotificationWidget
--- @param y number
local function displace(frame, y)
  setOffset(frame, y)
  frame:SetScript("OnUpdate", y ~= 0 and settle or nil)
end

-- =============================================================================
-- ComponentFactory - Notification
-- =============================================================================

--- Creates a line of text on a backdrop that shows a history entry. It slides and fades in, then fades out, and glides
--- to its new place when the others around it change. It is invisible, keeping its space, until `Notify()` is called
--- and once it has faded out.
--- @return NotificationComponent root
function ComponentFactory:Notification()
  local root

  --- @class NotificationComponent : WaffleFlexComponent
  root = Addon.Waffle:Flex({
    width = "AUTO",
    height = "AUTO",
    visibility = "INVISIBLE",

    --- @param parent Frame
    frameFactory = function(parent)
      --- @class NotificationWidget : FrameWidget
      local frame = Widgets:Frame({ parent = parent, backdrop = false, clipChildren = false })

      -- Hidden, so that the first `Show()` plays the animation.
      frame:Hide()

      --- Offset of the content above its place, in pixels.
      frame.offsetY = 0

      --- Screen top of the frame at the last layout, or `nil` before the first one.
      frame.lastTop = nil

      --- Holds the backdrop and the text, and moves within the frame.
      --- @class NotificationContentWidget : FrameWidget
      local content = Widgets:Frame({ parent = frame })
      content:SetPoint("TOPLEFT")
      content:SetPoint("BOTTOMRIGHT")
      frame.content = content

      --- Text shown on the notification.
      content.fontString = content:CreateFontString("$parent_FontString", "OVERLAY", "ErrorFont")
      content.fontString:SetTextColor(1, 1, 1)
      content.fontString:SetPoint("CENTER")

      --- Entry that the notification shows. Set by `Notify()` and `SetEntry()`.
      --- @type HistoryLogEntry?
      frame.entry = nil

      --- Fades the notification in, then out after the hold.
      content.animationGroup = content:CreateAnimationGroup()

      local fadeIn = content.animationGroup:CreateAnimation("Alpha")
      fadeIn:SetFromAlpha(0)
      fadeIn:SetToAlpha(1)
      fadeIn:SetDuration(Addon.NOTIFICATION_FADE_IN)
      fadeIn:SetStartDelay(0)
      fadeIn:SetSmoothing("OUT")

      local fadeOut = content.animationGroup:CreateAnimation("Alpha")
      fadeOut:SetFromAlpha(1)
      fadeOut:SetToAlpha(0)
      fadeOut:SetDuration(Addon.NOTIFICATION_FADE_OUT)
      fadeOut:SetStartDelay(Addon.NOTIFICATION_HOLD)
      fadeOut:SetSmoothing("IN")

      --- Drifts the content while it fades out. Its offset is set by `Notify()`.
      frame.drift = content.animationGroup:CreateAnimation("Translation")
      frame.drift:SetDuration(Addon.NOTIFICATION_FADE_OUT)
      frame.drift:SetStartDelay(Addon.NOTIFICATION_HOLD)
      frame.drift:SetSmoothing("IN")

      -- Showing the frame starts the animation, and the notification hides once it finishes.
      frame:HookScript("OnShow", function() content.animationGroup:Play() end)
      content.animationGroup:HookScript("OnFinished", function()
        frame:Hide()
        displace(frame, 0)
        frame.lastTop = nil
        root:SetVisibility("INVISIBLE")
      end)

      -- Re-read the text while shown, and resize the notification when it changes.
      TickerManager:NewTicker(0.1, function()
        local text = getText(frame)
        if text ~= frame.content.fontString:GetText() then
          frame.content.fontString:SetText(text)
          root:MarkDirty()
        end
      end):BindFrame(frame)

      return frame
    end,

    --- @param frame NotificationWidget
    onMeasure = function(frame)
      local fontString = frame.content.fontString
      return fontString:GetStringWidth() + Widgets:Padding(), fontString:GetStringHeight() + Widgets:Padding()
    end,

    --- Glides the content from where it was when the layout moves the notification.
    --- @param frame NotificationWidget
    onLayout = function(frame)
      local top = frame:GetTop()
      if not top then return end

      if frame.lastTop and top ~= frame.lastTop then
        displace(frame, frame.offsetY + frame.lastTop - top)
      end

      frame.lastTop = top
    end
  })

  --- Shows the notification with the entry, and plays its animation.
  --- @param entry? HistoryLogEntry
  --- @param direction? AnchorDirection The way the stack grows. Defaults to `DOWN`.
  function root:Notify(entry, direction)
    self:WhenFrameReady(function(frame)
      --- @cast frame NotificationWidget
      setEntry(frame, entry)

      -- Color the background and border before the animation starts, since the game reverts colors set while it plays.
      local style = Addon:GetState().notificationBackground
      local color = entry and HistoryLog:GetColor(entry)

      if style == "NONE" then
        frame.content:SetBackdropColor(0, 0, 0, 0)
        frame.content:SetBackdropBorderColor(0, 0, 0, 0)
      elseif style == "HIGH_CONTRAST" then
        frame.content:SetBackdropColor(0, 0, 0, HIGH_CONTRAST_ALPHA)
        frame.content:SetBackdropBorderColor((color or Colors.Black):GetRGBA(1))
      else
        frame.content:SetBackdropColor(0, 0, 0, Addon.NOTIFICATION_ALPHA)
        frame.content:SetBackdropBorderColor(0, 0, 0, Addon.NOTIFICATION_ALPHA)
      end

      local growth = direction == "UP" and 1 or -1
      frame.lastTop = nil
      displace(frame, -growth * SLIDE_DISTANCE)
      frame.drift:SetOffset(0, growth * DRIFT_DISTANCE)
    end)

    self:SetVisibility("VISIBLE")
  end

  --- Shows the entry in place of the one shown now.
  --- @param entry? HistoryLogEntry
  function root:SetEntry(entry)
    self:WhenFrameReady(function(frame)
      if setEntry(frame, entry) then self:MarkDirty() end
    end)
  end

  --- Hides the notification, even while it is still animating. Does nothing if it is already invisible.
  function root:Kill()
    if not self:IsVisible() then return end

    self:WhenFrameReady(function(frame)
      --- @cast frame NotificationWidget
      frame.content.animationGroup:Stop()
      frame:Hide()
      displace(frame, 0)
      frame.lastTop = nil
    end)

    self:SetVisibility("INVISIBLE")
  end

  return root
end
