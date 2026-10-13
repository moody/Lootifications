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
L.MAX_NOTIFICATIONS_TEXT = "Notifiche massime"
L.MAX_NOTIFICATIONS_TOOLTIP = "Il numero massimo di notifiche visualizzate."
L.MONEY_NOTIFICATIONS_TEXT = "Notifiche di denaro"
L.MONEY_NOTIFICATIONS_TOOLTIP = "Mostra una notifica quando si ottiene o si riceve denaro."
L.NOTIFICATION_ALPHA_TEXT = "Alfa delle notifiche"
L.NOTIFICATION_ALPHA_TOOLTIP = "La trasparenza dello sfondo delle notifiche."
L.NOTIFICATION_FADE_OUT_DELAY_TEXT = "Ritardo di dissolvenza delle notifiche"
L.NOTIFICATION_FADE_OUT_DELAY_TOOLTIP = "Il tempo di attesa prima che le notifiche svaniscano."
L.NOTIFICATION_SPACING_TEXT = "Spaziatura delle notifiche"
L.NOTIFICATION_SPACING_TOOLTIP = "Lo spazio tra le notifiche."
L.OPTIONS_TEXT = "Opzioni"
L.OWNED_ITEM_COUNTS_TEXT = "Quantità di oggetti posseduti"
L.OWNED_ITEM_COUNTS_TOOLTIP = "Include la quantità posseduta dell'oggetto nelle notifiche del bottino."
L.RESET_ANCHOR = "Reimposta ancora"
L.RIGHT_CLICK = "Clic destro"
L.SHIFT_KEY = "Maiusc"
L.TEST_NOTIFICATIONS = "Prova le notifiche"
L.TOGGLE_ANCHOR = "Mostra/nascondi ancora"
