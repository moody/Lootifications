local ADDON_NAME = ... ---@type string
local Addon = select(2, ...) ---@type Addon
local AnchorFrame = Addon:GetModule("AnchorFrame")
local Widgets = Addon:GetModule("Widgets")

--- @class NotificationManager
local NotificationManager = Addon:GetModule("NotificationManager")

local notificationCount = 0

--- @type NotificationWidget[]
local activeNotifications = {}

--- @type table<NotificationWidget, boolean>
local notificationPool = {}

--- @type string[]
local notificationQueue = {}

-- ============================================================================
-- Local Functions
-- ============================================================================

local function getNotification()
  local notification = next(notificationPool)
  if notification then
    notificationPool[notification] = nil
  else
    notificationCount = notificationCount + 1
    notification = Widgets:Notification({
      name = ("%s_Notification%s"):format(ADDON_NAME, notificationCount)
    })
  end
  return notification
end

local function releaseNotification(notification)
  notificationPool[notification] = true
  for i = #activeNotifications, 1, -1 do
    if notification == activeNotifications[i] then
      table.remove(activeNotifications, i)
    end
  end
end

-- ============================================================================
-- Functions
-- ============================================================================

function NotificationManager:Notify(text)
  table.insert(notificationQueue, 1, text)
end

function NotificationManager:NotifyWithIcon(icon, text)
  self:Notify(Addon.TEXTURE_MESSAGE_FORMAT:format(icon, text))
end

--- Stops all active and pending notifications.
function NotificationManager:Clear()
  for k in pairs(notificationQueue) do notificationQueue[k] = nil end
  for i = #activeNotifications, 1, -1 do
    local notification = table.remove(activeNotifications, i)
    notificationPool[notification] = true
    notification:Kill()
  end
end

-- ============================================================================
-- Register callback to handle queued notifications.
-- ============================================================================

Addon:RegisterIntervalCallback(0.1, function()
  local state = Addon:GetStore():GetState()
  if #activeNotifications >= state.maxNotifications then return end

  local text = strtrim(table.remove(notificationQueue) or "")
  if text ~= "" then
    local notification = getNotification()
    activeNotifications[#activeNotifications + 1] = notification
    notification:Notify(
      text,
      state.notificationAlpha / Addon.NOTIFICATION_ALPHA_MAX,
      state.notificationFadeOutDelay,
      function()
        releaseNotification(notification)
      end)
  end
end)

-- ============================================================================
-- Register callback to reposition active notifications.
-- ============================================================================

Addon:RegisterIntervalCallback(0.01, function()
  local points = AnchorFrame:GetNotificationPoints()
  local spacing = AnchorFrame:GetNotificationSpacing(points)
  for i = #activeNotifications, 1, -1 do
    local notification = activeNotifications[i]
    notification:ClearAllPoints()
    if i == #activeNotifications then
      local relativePoint = AnchorFrame.frame:IsShown() and points.relativePoint or points.point
      local anchorSpacing = AnchorFrame.frame:IsShown() and spacing or 0
      notification:SetPoint(points.point, AnchorFrame.frame, relativePoint, 0, anchorSpacing)
    else
      notification:SetPoint(points.point, activeNotifications[i + 1], points.relativePoint, 0, spacing)
    end
  end
end)
