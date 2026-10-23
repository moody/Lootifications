local ADDON_NAME = ... ---@type string
local Addon = select(2, ...) ---@type Addon
local AnchorFrame = Addon:GetModule("AnchorFrame")
local ComponentFactory = Addon:GetModule("ComponentFactory")
local TickerManager = Addon:GetModule("TickerManager")
local Widgets = Addon:GetModule("Widgets")

--- @class NotificationManager
local NotificationManager = Addon:GetModule("NotificationManager")

--- Every notification. One that is visible is being shown.
--- @type NotificationComponent[]
local notifications = {}

--- Functions that return the text of notifications waiting to be shown, newest first.
--- @type table<integer, fun():string>
local getTextQueue = {}

--- Counts the notifications shown, and starts over once none are. A newer notification gets a lower
--- `order`, which puts it closest to the anchor.
local sequence = 0

-- ============================================================================
-- Local Functions
-- ============================================================================

--- Returns how many notifications are being shown.
--- @return integer
local function getShownCount()
  local count = 0
  for i = 1, #notifications do
    if notifications[i]:IsVisible() then count = count + 1 end
  end
  return count
end

--- Returns a notification that is not being shown, if there is one.
--- @return NotificationComponent?
local function getFreeNotification()
  for i = 1, #notifications do
    if not notifications[i]:IsVisible() then return notifications[i] end
  end
  return nil
end

-- ============================================================================
-- Stack Component
-- ============================================================================

--- Lays out the notifications in a column, anchored to the `AnchorFrame`.
--- @class NotificationStackComponent : WaffleFlexComponent
local Stack = Addon.Waffle:Flex({
  width = "AUTO",
  height = "AUTO",
  frameFactory = function()
    return Widgets:Frame({
      name = ADDON_NAME .. "_NotificationStack",
      backdrop = false,
      clipChildren = false
    })
  end
})

-- Create the notifications, one for each that can be shown at once.
for i = 1, Addon.MAX_NOTIFICATIONS do
  local notification = ComponentFactory:Notification()
  notifications[i] = notification
  Stack:AttachComponent(notification)
end

--- Points the stack at the anchor, and sets its direction and alignment.
function Stack:Refresh()
  local points = AnchorFrame:GetNotificationPoints()
  local isAnchorShown = AnchorFrame.frame:IsShown()

  self:SetDirection(points.direction)
  self:SetAlign(points.align)
  self:SetGap(Addon.NOTIFICATION_SPACING)

  --- @type FrameWidget
  local frame = self:GetFrame()
  if frame then
    frame:ClearAllPoints()
    frame:SetPoint(
      points.point,
      AnchorFrame.frame,
      isAnchorShown and points.relativePoint or points.point,
      0,
      isAnchorShown and AnchorFrame:GetNotificationSpacing(points) or 0
    )
  end
end

-- ============================================================================
-- NotificationManager
-- ============================================================================

--- Queues a notification to be shown once there is room for it.
--- @param getText fun(): string
function NotificationManager:Notify(getText)
  table.insert(getTextQueue, 1, getText)
end

--- Stops all active and pending notifications.
function NotificationManager:Clear()
  for k in pairs(getTextQueue) do getTextQueue[k] = nil end
  for i = 1, #notifications do notifications[i]:Kill() end
end

-- ============================================================================
-- Tickers
-- ============================================================================

-- Show a queued notification each stagger interval, while there is room for it.
TickerManager:NewTicker(Addon.NOTIFICATION_STAGGER, function()
  local notification = getFreeNotification()
  if not notification or getShownCount() >= Addon.MAX_NOTIFICATIONS then return end

  local getText = table.remove(getTextQueue)
  if type(getText) == "function" then
    sequence = sequence + 1
    notification:SetOrder(-sequence)
    notification:Notify(getText)
  end
end)

-- Lay out the notifications.
TickerManager:NewTicker(1 / 30, function()
  if getShownCount() > 0 then
    Stack:Refresh()
  else
    sequence = 0
  end

  Stack:Layout()
end)
