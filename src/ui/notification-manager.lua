local ADDON_NAME, Addon = ...
local AnchorFrame = Addon:GetModule("AnchorFrame")
local NotificationManager = Addon:GetModule("NotificationManager")
local SavedVariables = Addon:GetModule("SavedVariables")
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
-- Register callback to handle queued notifications.
-- ============================================================================

Addon:RegisterIntervalCallback(0.1, function()
  local sv = SavedVariables:Get()
  if #activeNotifications >= sv.maxNotifications then return end

  local text = strtrim(table.remove(notificationQueue) or "")
  if text ~= "" then
    local notification = getNotification()
    notification:Notify(text)
    notification:SetCallback(function() releaseNotification(notification) end)
    activeNotifications[#activeNotifications + 1] = notification
  end
end)

-- ============================================================================
-- Register callback to reposition active notifications.
-- ============================================================================

Addon:RegisterIntervalCallback(0.01, function()
  for i = #activeNotifications, 1, -1 do
    local notification = activeNotifications[i]
    notification:ClearAllPoints()
    if i == #activeNotifications then
      notification:SetPoint(AnchorFrame:GetNotificationPoint())
    else
      notification:SetPoint("TOP", activeNotifications[i + 1], "BOTTOM", 0, 0)
    end
  end
end)
