local ADDON_NAME, Addon = ...
local NotificationManager = Addon:GetModule("NotificationManager")
local Widgets = Addon:GetModule("Widgets")

local activeNotifications = {}
local notificationCount = 0
local notificationPool = {}
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

-- ============================================================================
-- Ticker to delay the display of queued notifications.
-- ============================================================================

C_Timer.NewTicker(0.1, function()
  local text = strtrim(table.remove(notificationQueue) or "")
  if text ~= "" then
    local notification = getNotification()
    notification:Notify(text)
    notification:SetCallback(function() releaseNotification(notification) end)
    activeNotifications[#activeNotifications + 1] = notification
  end
end)

-- ============================================================================
-- Ticker to dynamically position active notifications.
-- ============================================================================

C_Timer.NewTicker(0.01, function()
  for i = #activeNotifications, 1, -1 do
    local notification = activeNotifications[i]
    notification:ClearAllPoints()
    if i == #activeNotifications then
      notification:SetPoint("TOP", SubZoneTextString, "BOTTOM", 0, -Widgets:Padding())
    else
      notification:SetPoint("TOP", activeNotifications[i + 1], "BOTTOM", 0, -Widgets:Padding(0.5))
    end
  end
end)
