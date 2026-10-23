local Addon = select(2, ...) ---@type Addon
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local HistoryLog = Addon:GetModule("HistoryLog")
local MoneyLog = Addon:GetModule("MoneyLog")
local NotificationManager = Addon:GetModule("NotificationManager")

--- Shows a notification for each history entry: one entry, one notification, in the order logged.
--- @class HistoryNotifications
local HistoryNotifications = Addon:GetModule("HistoryNotifications")

-- ============================================================================
-- HistoryNotifications
-- ============================================================================

--- Queues a notification for the entry. Its text updates while shown.
--- @param entry HistoryEntry
function HistoryNotifications:Show(entry)
  NotificationManager:Notify(function() return HistoryLog:GetText(entry) end)
end

-- ============================================================================
-- Events
-- ============================================================================

-- Show a notification for each entry logged, except money while its notifications are off.
EventManager:On(E.HistoryLogged, function(entry)
  if entry.type ~= MoneyLog.ENTRY_TYPE or Addon:GetState().moneyNotifications then
    HistoryNotifications:Show(entry)
  end
end)
