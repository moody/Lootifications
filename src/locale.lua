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

L["ANCHOR"] = "Anchor"
L["COMMAND_DESCRIPTION_ANCHOR_RESET"] = "Reset the notifications anchor."
L["COMMAND_DESCRIPTION_ANCHOR"] = "Toggle the notifications anchor."
L["COMMAND_DESCRIPTION_HELP"] = "Display a list of commands."
L["COMMAND_DESCRIPTION_OPTIONS"] = "Toggle the user interface."
L["COMMAND_DESCRIPTION_TEST"] = "Test notifications."
L["COMMAND_SUCCESS_ANCHOR_RESET"] = "The notifications anchor has been reset."
L["GENERAL"] = "General"
L["LEFT_CLICK"] = "Left-Click"
L["LOOT_PRICES_TEXT"] = "Loot Prices"
L["LOOT_PRICES_TOOLTIP"] = "Include the vendor price of items in loot notifications."
L["MAX_NOTIFICATIONS_TEXT"] = "Max Notifications"
L["MAX_NOTIFICATIONS_TOOLTIP"] = "The maximum number of displayed notifications."
L["MONEY_NOTIFICATIONS_TEXT"] = "Money Notifications"
L["MONEY_NOTIFICATIONS_TOOLTIP"] = "Show a notification when money is looted or received."
L["NOTIFICATION_ALPHA_TEXT"] = "Notification Alpha"
L["NOTIFICATION_ALPHA_TOOLTIP"] = "The background transparency of notifications."
L["NOTIFICATION_FADE_OUT_DELAY_TEXT"] = "Notification Fade-Out Delay"
L["NOTIFICATION_FADE_OUT_DELAY_TOOLTIP"] = "The delay time before notifications fade out."
L["NOTIFICATION_SPACING_TEXT"] = "Notification Spacing"
L["NOTIFICATION_SPACING_TOOLTIP"] = "The amount of space between notifications."
L["OPTIONS_TEXT"] = "Options"
L["OWNED_ITEM_COUNTS_TEXT"] = "Owned Item Counts"
L["OWNED_ITEM_COUNTS_TOOLTIP"] = "Include an owned item count in loot notifications."
L["RESET_ANCHOR"] = "Reset Anchor"
L["RIGHT_CLICK"] = "Right-Click"
L["SHIFT_KEY"] = "Shift"
L["TEST_NOTIFICATIONS"] = "Test Notifications"
L["TOGGLE_ANCHOR"] = "Toggle Anchor"

-- ============================================================================
-- Others
-- ============================================================================

if GetLocale() == "deDE" then
  --@localization(locale="deDE", format="lua_additive_table", handle-unlocalized="ignore")@
end

if GetLocale() == "esES" then
  --@localization(locale="esES", format="lua_additive_table", handle-unlocalized="ignore")@
end

if GetLocale() == "esMX" then
  --@localization(locale="esMX", format="lua_additive_table", handle-unlocalized="ignore")@
end

if GetLocale() == "frFR" then
  --@localization(locale="frFR", format="lua_additive_table", handle-unlocalized="ignore")@
end

if GetLocale() == "itIT" then
  --@localization(locale="itIT", format="lua_additive_table", handle-unlocalized="ignore")@
end

if GetLocale() == "koKR" then
  --@localization(locale="koKR", format="lua_additive_table", handle-unlocalized="ignore")@
end

if GetLocale() == "ptBR" then
  --@localization(locale="ptBR", format="lua_additive_table", handle-unlocalized="ignore")@
end

if GetLocale() == "ruRU" then
  --@localization(locale="ruRU", format="lua_additive_table", handle-unlocalized="ignore")@
end

if GetLocale() == "zhCN" then
  --@localization(locale="zhCN", format="lua_additive_table", handle-unlocalized="ignore")@
end

if GetLocale() == "zhTW" then
  --@localization(locale="zhTW", format="lua_additive_table", handle-unlocalized="ignore")@
end
