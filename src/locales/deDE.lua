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
L.COMMANDS = "Befehle"
L.COMMAND_DESCRIPTION_HELP = "Zeigt eine Liste der Befehle an."
L.COMMAND_DESCRIPTION_OPTIONS = "Schaltet das Hauptfenster um."
L.COMMAND_DESCRIPTION_TEST = "Zeigt ein paar Testbenachrichtigungen an."
L.DIRECTION_DESCRIPTION = "Lässt Benachrichtigungen vom oberen Ankerrand abwärts oder vom unteren aufwärts wachsen."
L.DIRECTION_TEXT = "Richtung"
L.DOWN = "Nach unten"
L.GROW = "Wachstum"
L.JUSTIFY = "Bündigkeit"
L.LAYOUT = "Anordnung"
L.LEFT = "Links"
L.LOOT_PRICES_DESCRIPTION = "Zeigt den Händlerpreis von Gegenständen in Beutebenachrichtigungen an."
L.LOOT_PRICES_TEXT = "Beutepreise"
L.MONEY = "Geld"
L.MONEY_NOTIFICATIONS_DESCRIPTION = "Zeigt eine Benachrichtigung an, wenn Geld erbeutet oder erhalten wird."
L.NOTIFICATIONS = "Benachrichtigungen"
L.OWNED_ITEM_COUNTS_DESCRIPTION = "Zeigt die Anzahl der besessenen Gegenstände in Beutebenachrichtigungen an."
L.OWNED_ITEM_COUNTS_TEXT = "Anzahl im Besitz"
L.RESET_ANCHOR = "Anker zurücksetzen"
L.RESET_TO_DEFAULTS = "Auf Standard zurücksetzen"
L.RIGHT = "Rechts"
L.RIGHT_CLICK = "Rechtsklick"
L.TEST_NOTIFICATIONS_HINT = "Mit %s werden ein paar Testbenachrichtigungen angezeigt."
L.UP = "Nach oben"
