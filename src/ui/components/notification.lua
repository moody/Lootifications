local Addon = select(2, ...) ---@type Addon
local B = Addon:GetModule("Blizzard")
local Colors = Addon:GetModule("Colors")
local DefaultStates = Addon:GetModule("DefaultStates")
local HistoryLog = Addon:GetModule("HistoryLog")
local StateManager = Addon:GetModule("StateManager")
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

--- Opacity of the background and border with the `SUBTLE` style.
local SUBTLE_ALPHA = 0.3

--- Opacity of the background with the `HIGH_CONTRAST` style.
local HIGH_CONTRAST_ALPHA = 0.95

--- Seconds that a notification takes to fade in.
local FADE_IN_TIME = 0.25

--- Seconds that a notification takes to fade out.
local FADE_OUT_TIME = 0.2

--- Seconds between fading in and fading out.
local HOLD_TIME = 3

-- =============================================================================
-- Local Functions
-- =============================================================================

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

--- Puts the content in its place, and forgets where the frame was at the last layout.
--- @param frame NotificationWidget
local function resetGlide(frame)
  frame.lastTop = nil
  displace(frame, 0)
end

--- Creates the animation group of the content, which fades it in, then out after the hold, and a drift in the group
--- that moves it while it fades out. The caller sets the offset of the drift.
--- @param content NotificationContentWidget
--- @return AnimationGroup group
--- @return Animation drift
local function createAnimation(content)
  local group = content:CreateAnimationGroup()

  local fadeIn = group:CreateAnimation("Alpha")
  fadeIn:SetFromAlpha(0)
  fadeIn:SetToAlpha(1)
  fadeIn:SetDuration(FADE_IN_TIME)
  fadeIn:SetStartDelay(0)
  fadeIn:SetSmoothing("OUT")

  local fadeOut = group:CreateAnimation("Alpha")
  fadeOut:SetFromAlpha(1)
  fadeOut:SetToAlpha(0)
  fadeOut:SetDuration(FADE_OUT_TIME)
  fadeOut:SetStartDelay(HOLD_TIME)
  fadeOut:SetSmoothing("IN")

  local drift = group:CreateAnimation("Translation")
  drift:SetDuration(FADE_OUT_TIME)
  drift:SetStartDelay(HOLD_TIME)
  drift:SetSmoothing("IN")

  return group, drift
end

-- =============================================================================
-- ComponentFactory - Notification
-- =============================================================================

--- Creates a line of text on a backdrop that shows a history entry. It glides to its new place when the others around
--- it change. It is invisible, keeping its space, until `Show()` is called. `Animate()` makes it slide and fade in, then
--- fade out, after which it is invisible again.
--- @return NotificationComponent root
function ComponentFactory:Notification()
  local root

  --- Shows the text of the frame's entry at the text size, and resizes the notification if either changed.
  --- @param frame NotificationWidget
  local function refreshText(frame)
    local textSize = StateManager:GetGlobalState().notifications.textSize
    if textSize ~= frame.textSize then
      frame.textSize = textSize

      -- Typeface of the client's language.
      local typeface, _, flags = B.FontObjects.Normal:GetFont()
      frame.content.fontString:SetFont(typeface, textSize, flags)
      root:MarkDirty()
    end

    local text = frame.entry and HistoryLog:GetText(frame.entry) or ""
    if text ~= frame.content.fontString:GetText() then
      frame.content.fontString:SetText(text)
      root:MarkDirty()
    end
  end

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

      --- Text size last applied to the text, or `nil` before the first refresh.
      --- @type number?
      frame.textSize = nil

      --- Text shown on the notification.
      content.fontString = content:CreateFontString("$parent_FontString", "OVERLAY", B.FontObjects.Normal:GetName())
      content.fontString:SetTextColor(1, 1, 1)
      content.fontString:SetPoint("CENTER")

      --- Entry that the notification shows. Set by `Show()` and `SetEntry()`.
      --- @type HistoryLogEntry?
      frame.entry = nil

      --- Whether showing the frame plays the animation. Set by `Show()` and `Animate()`.
      frame.isAnimated = false

      --- Fades the notification in, then out after the hold. The drift moves the content while it fades out, and its
      --- offset is set by `Animate()`.
      content.animationGroup, frame.drift = createAnimation(content)

      -- Showing an animated frame starts the animation, and the notification hides once it finishes.
      frame:HookScript("OnShow", function()
        if frame.isAnimated then content.animationGroup:Play() end
      end)
      content.animationGroup:HookScript("OnFinished", function()
        frame:Hide()
        resetGlide(frame)
        root:SetVisibility("INVISIBLE")
      end)

      -- Re-read the text while shown.
      TickerManager:NewTicker(0.1, function() refreshText(frame) end):BindFrame(frame)

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

  --- Shows the entry at full opacity, until `Kill()` is called or the animation finishes.
  --- @param entry? HistoryLogEntry
  function root:Show(entry)
    self:WhenFrameReady(function(frame)
      --- @cast frame NotificationWidget
      frame.isAnimated = false
      frame.entry = entry
      refreshText(frame)

      -- Color the background and border before any animation starts, since the game reverts colors set while it plays.
      local style = StateManager:GetGlobalState().notifications.background
      local color = entry and HistoryLog:GetColor(entry)

      if style == DefaultStates.NOTIFICATION_BACKGROUNDS.NONE then
        frame.content:SetBackdropColor(0, 0, 0, 0)
        frame.content:SetBackdropBorderColor(0, 0, 0, 0)
      elseif style == DefaultStates.NOTIFICATION_BACKGROUNDS.HIGH_CONTRAST then
        frame.content:SetBackdropColor(0, 0, 0, HIGH_CONTRAST_ALPHA)
        frame.content:SetBackdropBorderColor((color or Colors.Black):GetRGBA(1))
      else
        frame.content:SetBackdropColor(0, 0, 0, SUBTLE_ALPHA)
        frame.content:SetBackdropBorderColor(0, 0, 0, SUBTLE_ALPHA)
      end

      resetGlide(frame)
    end)

    self:SetVisibility("VISIBLE")
  end

  --- Makes the notification slide and fade in when it shows, then fade out. Call it right after `Show()`.
  --- @param direction? AnchorDirection The way the stack grows. Defaults to `DOWN`.
  function root:Animate(direction)
    self:WhenFrameReady(function(frame)
      --- @cast frame NotificationWidget
      local growth = direction == DefaultStates.ANCHOR_DIRECTIONS.UP and 1 or -1
      frame.isAnimated = true
      displace(frame, -growth * SLIDE_DISTANCE)
      frame.drift:SetOffset(0, growth * DRIFT_DISTANCE)
    end)
  end

  --- Shows the entry in place of the one shown now.
  --- @param entry? HistoryLogEntry
  function root:SetEntry(entry)
    self:WhenFrameReady(function(frame)
      frame.entry = entry
      refreshText(frame)
    end)
  end

  --- Hides the notification, even while it is still animating. Does nothing if it is already invisible.
  function root:Kill()
    if not self:IsVisible() then return end

    self:WhenFrameReady(function(frame)
      --- @cast frame NotificationWidget
      frame.content.animationGroup:Stop()
      frame:Hide()
      resetGlide(frame)
    end)

    self:SetVisibility("INVISIBLE")
  end

  return root
end
