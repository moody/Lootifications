if GetLocale() ~= "itIT" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- Italian (Italiano)
-- ============================================================================

L.ANCHOR = "Ancora"
L.GENERAL = "Generale"
L.LEFT_CLICK = "Clic sinistro"
L.LOOT_PRICES_TEXT = "Prezzi del bottino"
L.LOOT_PRICES_TOOLTIP = "Include il prezzo di vendita degli oggetti nelle notifiche del bottino."
L.MONEY_NOTIFICATIONS_TEXT = "Notifiche di denaro"
L.MONEY_NOTIFICATIONS_TOOLTIP = "Mostra una notifica quando si ottiene o si riceve denaro."
L.OPTIONS_TEXT = "Opzioni"
L.OWNED_ITEM_COUNTS_TEXT = "Quantità di oggetti posseduti"
L.OWNED_ITEM_COUNTS_TOOLTIP = "Include la quantità posseduta dell'oggetto nelle notifiche del bottino."
L.RESET_ANCHOR = "Reimposta ancora"
L.RIGHT_CLICK = "Clic destro"
L.SHIFT_KEY = "Maiusc"
L.TEST_NOTIFICATIONS = "Prova le notifiche"
L.TOGGLE_ANCHOR = "Mostra/nascondi ancora"
