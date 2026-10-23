local Addon = select(2, ...) ---@type Addon

--- @class Locale
local L = Addon:GetModule("Locale")

setmetatable(L, {
  __index = function(t, k)
    return rawget(t, k) or k
  end
})

-- ============================================================================
-- English
-- ============================================================================

L.ANCHOR = "Anchor"
L.GENERAL = "General"
L.LEFT_CLICK = "Left-Click"
L.LOOT_PRICES_TEXT = "Loot Prices"
L.LOOT_PRICES_TOOLTIP = "Include the vendor price of items in loot notifications."
L.MONEY_NOTIFICATIONS_TEXT = "Money Notifications"
L.MONEY_NOTIFICATIONS_TOOLTIP = "Show a notification when money is looted or received."
L.OPTIONS_TEXT = "Options"
L.OWNED_ITEM_COUNTS_TEXT = "Owned Item Counts"
L.OWNED_ITEM_COUNTS_TOOLTIP = "Include an owned item count in loot notifications."
L.RESET_ANCHOR = "Reset Anchor"
L.RIGHT_CLICK = "Right-Click"
L.SHIFT_KEY = "Shift"
L.TEST_NOTIFICATIONS = "Test Notifications"
L.TOGGLE_ANCHOR = "Toggle Anchor"
