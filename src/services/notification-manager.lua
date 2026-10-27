local Addon = select(2, ...) ---@type Addon
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local MoneyLogger = Addon:GetModule("MoneyLogger")
local StateManager = Addon:GetModule("StateManager")

--- Holds the notifications waiting to be shown, and queues one for each entry logged.
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

-- ============================================================================
-- Events
-- ============================================================================

-- Queue a notification for each entry logged, except money while its notifications are off.
EventManager:On(E.HistoryLogged, function(entry)
  if entry.logger ~= MoneyLogger or StateManager:GetGlobalState().notifications.money then
    NotificationManager:Notify(entry)
  end
end)

-- Clear any queued notifications when the log is cleared.
EventManager:On(E.HistoryCleared, function()
  NotificationManager:Clear()
end)
