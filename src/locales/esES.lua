if GetLocale() ~= "esES" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- Spanish (Español)
-- ============================================================================

L.ANCHOR = "Ancla"
L.GENERAL = "General"
L.LEFT_CLICK = "Clic izquierdo"
L.LOOT_PRICES_TEXT = "Precios del botín"
L.LOOT_PRICES_TOOLTIP = "Incluye el precio de venta a vendedores de los objetos en las notificaciones de botín."
L.MAX_NOTIFICATIONS_TEXT = "Máximo de notificaciones"
L.MAX_NOTIFICATIONS_TOOLTIP = "El número máximo de notificaciones mostradas."
L.MONEY_NOTIFICATIONS_TEXT = "Notificaciones de dinero"
L.MONEY_NOTIFICATIONS_TOOLTIP = "Muestra una notificación cuando se saquea o se recibe dinero."
L.NOTIFICATION_ALPHA_TEXT = "Alfa de las notificaciones"
L.NOTIFICATION_ALPHA_TOOLTIP = "La transparencia del fondo de las notificaciones."
L.NOTIFICATION_FADE_OUT_DELAY_TEXT = "Retraso de desvanecimiento de las notificaciones"
L.NOTIFICATION_FADE_OUT_DELAY_TOOLTIP = "El tiempo de espera antes de que las notificaciones se desvanezcan."
L.NOTIFICATION_SPACING_TEXT = "Espaciado de las notificaciones"
L.NOTIFICATION_SPACING_TOOLTIP = "La cantidad de espacio entre las notificaciones."
L.OPTIONS_TEXT = "Opciones"
L.OWNED_ITEM_COUNTS_TEXT = "Cantidad de objetos que posees"
L.OWNED_ITEM_COUNTS_TOOLTIP = "Incluye la cantidad que posees del objeto en las notificaciones de botín."
L.RESET_ANCHOR = "Restablecer ancla"
L.RIGHT_CLICK = "Clic derecho"
L.SHIFT_KEY = "Mayús"
L.TEST_NOTIFICATIONS = "Probar notificaciones"
L.TOGGLE_ANCHOR = "Mostrar u ocultar ancla"
