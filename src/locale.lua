local _, Addon = ...
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
L["COMMAND_DESCRIPTION_DELAY"] = "Set the delay time before notifications fade out (from %s to %s seconds)."
L["COMMAND_DESCRIPTION_HELP"] = "Display a list of commands."
L["COMMAND_DESCRIPTION_MAX"] = "Set the maximum number of displayed notifications (from %s to %s)."
L["COMMAND_DESCRIPTION_MONEY"] = "Toggle money notifications."
L["COMMAND_DESCRIPTION_TEST"] = "Test notifications."
L["COMMAND_EXAMPLE_USAGE"] = "Example Usage"
L["COMMAND_SUCCESS_ANCHOR_RESET"] = "The notifications anchor has been reset."
L["COMMAND_SUCCESS_DELAY"] = "Notification fade-out delay set to %s seconds."
L["COMMAND_SUCCESS_MAX"] = "Maximum number of displayed notifications set to %s."
L["MAXIMUM"] = "Maximum"
L["MINIMUM"] = "Minimum"
L["MONEY_NOTIFICATIONS_DISABLED"] = "Money notifications disabled."
L["MONEY_NOTIFICATIONS_ENABLED"] = "Money notifications enabled."

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
