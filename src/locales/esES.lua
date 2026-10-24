if GetLocale() ~= "esES" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- Spanish (Español)
-- ============================================================================

L.ANCHOR = "Ancla"
L.ANCHOR_TOOLTIP = "Haz clic y arrastra este marco para mover las notificaciones."
L.GENERAL = "General"
L.LOOT_PRICES_TEXT = "Precios del botín"
L.LOOT_PRICES_TOOLTIP = "Incluye el precio de venta a vendedores de los objetos en las notificaciones de botín."
L.MONEY_NOTIFICATIONS_TEXT = "Notificaciones de dinero"
L.MONEY_NOTIFICATIONS_TOOLTIP = "Muestra una notificación cuando se saquea o se recibe dinero."
L.OPTIONS_TEXT = "Opciones"
L.OWNED_ITEM_COUNTS_TEXT = "Cantidad de objetos que posees"
L.OWNED_ITEM_COUNTS_TOOLTIP = "Incluye la cantidad que posees del objeto en las notificaciones de botín."
L.RESET_ANCHOR = "Restablecer ancla"
L.RIGHT_CLICK = "Clic derecho"
