if GetLocale() ~= "itIT" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- Italian (Italiano)
-- ============================================================================

L.ALIGNMENT_DESCRIPTION = "Stabilisce come le notifiche si allineano tra loro."
L.ALIGNMENT_TEXT = "Allineamento"
L.ANCHOR = "Ancora"
L.ANCHOR_TOOLTIP = "Fai clic e trascina questo riquadro per spostare le notifiche."
L.CENTER = "Centro"
L.DIRECTION_DESCRIPTION = "Fa crescere le notifiche verso il basso dall'alto dell'ancora o verso l'alto dal basso."
L.DIRECTION_TEXT = "Direzione"
L.DOWN = "Giù"
L.GROW = "Crescita"
L.JUSTIFY = "Giustificazione"
L.LEFT = "Sinistra"
L.LOOT_PRICES_DESCRIPTION = "Include il prezzo di vendita degli oggetti nelle notifiche del bottino."
L.LOOT_PRICES_TEXT = "Prezzi del bottino"
L.MONEY_NOTIFICATIONS_DESCRIPTION = "Mostra una notifica quando si ottiene o si riceve denaro."
L.MONEY_NOTIFICATIONS_TEXT = "Notifiche di denaro"
L.OWNED_ITEM_COUNTS_DESCRIPTION = "Include la quantità posseduta dell'oggetto nelle notifiche del bottino."
L.OWNED_ITEM_COUNTS_TEXT = "Quantità di oggetti posseduti"
L.RESET_ANCHOR = "Reimposta ancora"
L.RESET_TO_DEFAULTS = "Reimposta valori predefiniti"
L.RIGHT = "Destra"
L.RIGHT_CLICK = "Clic destro"
L.UP = "Su"
