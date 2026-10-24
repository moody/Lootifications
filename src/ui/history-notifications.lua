local Addon = select(2, ...) ---@type Addon
local AnchorFrame = Addon:GetModule("AnchorFrame")
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local HistoryLog = Addon:GetModule("HistoryLog")
local MoneyLogger = Addon:GetModule("MoneyLogger")
local NotificationManager = Addon:GetModule("NotificationManager")

--- Shows one notification per history entry, in the order logged.
--- @class HistoryNotifications
local HistoryNotifications = Addon:GetModule("HistoryNotifications")

-- ============================================================================
-- HistoryNotifications
-- ============================================================================

--- Queues a notification for the entry, unless the `AnchorFrame` is unlocked. Its text updates while shown.
--- @param entry HistoryLogEntry
function HistoryNotifications:Show(entry)
  if not AnchorFrame:IsUnlocked() then
    NotificationManager:Notify(function() return HistoryLog:GetText(entry) end)
  end
end

-- ============================================================================
-- Events
-- ============================================================================

-- Show a notification for each entry logged, except money while its notifications are off.
EventManager:On(E.HistoryLogged, function(entry)
  if entry.logger ~= MoneyLogger or Addon:GetState().moneyNotifications then
    HistoryNotifications:Show(entry)
  end
end)
