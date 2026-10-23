if GetLocale() ~= "deDE" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- German (Deutsch)
-- ============================================================================

L.ANCHOR = "Anker"
L.GENERAL = "Allgemein"
L.LEFT_CLICK = "Linksklick"
L.LOOT_PRICES_TEXT = "Beutepreise"
L.LOOT_PRICES_TOOLTIP = "Zeigt den Händlerpreis von Gegenständen in Beutebenachrichtigungen an."
L.MONEY_NOTIFICATIONS_TEXT = "Geldbenachrichtigungen"
L.MONEY_NOTIFICATIONS_TOOLTIP = "Zeigt eine Benachrichtigung an, wenn Geld erbeutet oder erhalten wird."
L.OPTIONS_TEXT = "Optionen"
L.OWNED_ITEM_COUNTS_TEXT = "Anzahl im Besitz"
L.OWNED_ITEM_COUNTS_TOOLTIP = "Zeigt die Anzahl der besessenen Gegenstände in Beutebenachrichtigungen an."
L.RESET_ANCHOR = "Anker zurücksetzen"
L.RIGHT_CLICK = "Rechtsklick"
L.SHIFT_KEY = "Umschalt"
L.TEST_NOTIFICATIONS = "Benachrichtigungen testen"
L.TOGGLE_ANCHOR = "Anker ein-/ausblenden"
