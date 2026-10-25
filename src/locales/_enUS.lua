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
L.BACKGROUND_DESCRIPTION = "The background and border of the notifications."
L.BACKGROUND_TEXT = "Background"
L.CENTER = "Center"
L.CLEAR_LOG = "Clear Log"
L.COMMANDS = "Commands"
L.COMMAND_DESCRIPTION_HELP = "Display a list of commands."
L.COMMAND_DESCRIPTION_OPTIONS = "Toggle the main window."
L.CONTENT = "Content"
L.DIRECTION_DESCRIPTION = "Grow down from the anchor's top or up from its bottom."
L.DIRECTION_TEXT = "Direction"
L.DOWN = "Down"
L.GENERAL = "General"
L.GROW = "Grow"
L.HIGH_CONTRAST = "High Contrast"
L.JUSTIFY = "Justify"
L.LEFT = "Left"
L.LEFT_CLICK = "Left-Click"
L.LOG = "Log"
L.LOOK_AND_FEEL = "Look & Feel"
L.LOOT_PRICES_DESCRIPTION = "Include the vendor price of items in loot notifications."
L.LOOT_PRICES_TEXT = "Loot Prices"
L.MINIMAP_ICON_DESCRIPTION = "Show an icon on the minimap."
L.MINIMAP_ICON_TEXT = "Minimap Icon"
L.MONEY = "Money"
L.MONEY_NOTIFICATIONS_DESCRIPTION = "Show a notification when money is looted or received."
L.NONE = "None"
L.NOTHING_LOOTED_YET = "Nothing looted yet."
L.OWNED_ITEM_COUNTS_DESCRIPTION = "Include an owned item count in loot notifications."
L.OWNED_ITEM_COUNTS_TEXT = "Owned Item Counts"
L.QUANTITY_FORMAT = "Quantity: %s"
L.RESET_ANCHOR = "Reset Anchor"
L.RESET_TO_DEFAULTS = "Reset to Defaults"
L.RIGHT = "Right"
L.RIGHT_CLICK = "Right-Click"
L.SETTINGS = "Settings"
L.STYLE = "Style"
L.SUBTLE = "Subtle"
L.TOTAL_ITEMS = "Total Items: %s"
L.TOTAL_MONEY = "Total Money: %s"
L.UP = "Up"
