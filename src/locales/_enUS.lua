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

L.ALIGNMENT_DESCRIPTION = "How the notifications line up with each other."
L.ALIGNMENT_TEXT = "Alignment"
L.ANCHOR = "Anchor"
L.ANCHOR_TOOLTIP = "Click and drag this frame to move the notifications."
L.CENTER = "Center"
L.DIRECTION_DESCRIPTION = "Grow notifications down from the anchor's top or up from its bottom."
L.DIRECTION_TEXT = "Direction"
L.DOWN = "Down"
L.GROW = "Grow"
L.JUSTIFY = "Justify"
L.LEFT = "Left"
L.LOOT_PRICES_DESCRIPTION = "Include the vendor price of items in loot notifications."
L.LOOT_PRICES_TEXT = "Loot Prices"
L.MONEY_NOTIFICATIONS_DESCRIPTION = "Show a notification when money is looted or received."
L.MONEY_NOTIFICATIONS_TEXT = "Money Notifications"
L.OWNED_ITEM_COUNTS_DESCRIPTION = "Include an owned item count in loot notifications."
L.OWNED_ITEM_COUNTS_TEXT = "Owned Item Counts"
L.RESET_ANCHOR = "Reset Anchor"
L.RESET_TO_DEFAULTS = "Reset to Defaults"
L.RIGHT = "Right"
L.RIGHT_CLICK = "Right-Click"
L.UP = "Up"
