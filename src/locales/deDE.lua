if GetLocale() ~= "deDE" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- German (Deutsch)
-- ============================================================================

L.ANCHOR = "Anker"
L.ANCHOR_TOOLTIP = "Diesen Rahmen anklicken und ziehen, um die Benachrichtigungen zu verschieben."
L.LOOT_PRICES_TEXT = "Beutepreise"
L.LOOT_PRICES_TOOLTIP = "Zeigt den Händlerpreis von Gegenständen in Beutebenachrichtigungen an."
L.MONEY_NOTIFICATIONS_TEXT = "Geldbenachrichtigungen"
L.MONEY_NOTIFICATIONS_TOOLTIP = "Zeigt eine Benachrichtigung an, wenn Geld erbeutet oder erhalten wird."
L.OWNED_ITEM_COUNTS_TEXT = "Anzahl im Besitz"
L.OWNED_ITEM_COUNTS_TOOLTIP = "Zeigt die Anzahl der besessenen Gegenstände in Beutebenachrichtigungen an."
L.RESET_ANCHOR = "Anker zurücksetzen"
L.RIGHT_CLICK = "Rechtsklick"
