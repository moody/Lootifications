if GetLocale() ~= "deDE" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- German (Deutsch)
-- ============================================================================

L.ALIGNMENT_DESCRIPTION = "Legt fest, wie die Benachrichtigungen zueinander ausgerichtet werden."
L.ALIGNMENT_TEXT = "Ausrichtung"
L.ANCHOR = "Anker"
L.ANCHOR_TOOLTIP = "Diesen Rahmen anklicken und ziehen, um die Benachrichtigungen zu verschieben."
L.CENTER = "Mitte"
L.DIRECTION_DESCRIPTION = "Lässt die Benachrichtigungen vom oberen Ankerrand nach unten oder vom unteren Ankerrand nach oben wachsen."
L.DIRECTION_TEXT = "Richtung"
L.DOWN = "Nach unten"
L.GROW = "Wachstum"
L.JUSTIFY = "Bündigkeit"
L.LEFT = "Links"
L.LOOT_PRICES_DESCRIPTION = "Zeigt den Händlerpreis von Gegenständen in Beutebenachrichtigungen an."
L.LOOT_PRICES_TEXT = "Beutepreise"
L.MONEY_NOTIFICATIONS_DESCRIPTION = "Zeigt eine Benachrichtigung an, wenn Geld erbeutet oder erhalten wird."
L.MONEY_NOTIFICATIONS_TEXT = "Geldbenachrichtigungen"
L.OWNED_ITEM_COUNTS_DESCRIPTION = "Zeigt die Anzahl der besessenen Gegenstände in Beutebenachrichtigungen an."
L.OWNED_ITEM_COUNTS_TEXT = "Anzahl im Besitz"
L.RESET_ANCHOR = "Anker zurücksetzen"
L.RESET_TO_DEFAULTS = "Auf Standard zurücksetzen"
L.RIGHT = "Rechts"
L.RIGHT_CLICK = "Rechtsklick"
L.UP = "Nach oben"
