local Addon = select(2, ...) ---@type Addon

--- Holds the notifications waiting to be shown.
--- @class NotificationManager
local NotificationManager = Addon:GetModule("NotificationManager")

--- Functions that return the text of notifications waiting to be shown, newest first.
--- @type table<integer, fun():string>
local getTextQueue = {}

-- ============================================================================
-- NotificationManager
-- ============================================================================

--- Queues a notification to be shown once there is room for it.
--- @param getText fun(): string
function NotificationManager:Notify(getText)
  table.insert(getTextQueue, 1, getText)
end

--- Removes and returns the text function of the notification that has waited longest, if there is one.
--- @return (fun(): string)?
function NotificationManager:Pop()
  return table.remove(getTextQueue)
end

--- Drops every queued notification.
function NotificationManager:Clear()
  for k in pairs(getTextQueue) do getTextQueue[k] = nil end
end
