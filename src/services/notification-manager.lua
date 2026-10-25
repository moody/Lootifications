local Addon = select(2, ...) ---@type Addon

--- Holds the notifications waiting to be shown.
--- @class NotificationManager
local NotificationManager = Addon:GetModule("NotificationManager")

--- Entries of the notifications waiting to be shown, newest first.
--- @type HistoryLogEntry[]
local queue = {}

-- ============================================================================
-- NotificationManager
-- ============================================================================

--- Queues a notification to be shown once there is room for it.
--- @param entry HistoryLogEntry
function NotificationManager:Notify(entry)
  table.insert(queue, 1, entry)
end

--- Removes and returns the entry of the notification that has waited longest, if there is one.
--- @return HistoryLogEntry?
function NotificationManager:Pop()
  return table.remove(queue)
end

--- Drops every queued notification.
function NotificationManager:Clear()
  for k in pairs(queue) do queue[k] = nil end
end
