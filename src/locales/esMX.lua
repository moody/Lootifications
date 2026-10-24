if GetLocale() ~= "esMX" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- Latin American Spanish (Español Latinoamericano)
-- ============================================================================

L.ALIGNMENT_DESCRIPTION = "Define cómo se alinean las notificaciones entre sí."
L.ALIGNMENT_TEXT = "Alineación"
L.ANCHOR = "Ancla"
L.ANCHOR_TOOLTIP = "Haz clic y arrastra este marco para mover las notificaciones."
L.CENTER = "Centro"
L.DIRECTION_DESCRIPTION = "Hace crecer las notificaciones hacia abajo desde la parte superior del ancla o hacia arriba desde la inferior."
L.DIRECTION_TEXT = "Dirección"
L.DOWN = "Abajo"
L.GROW = "Crecimiento"
L.JUSTIFY = "Justificación"
L.LEFT = "Izquierda"
L.LOOT_PRICES_DESCRIPTION = "Incluye el precio de venta a vendedores de los objetos en las notificaciones de botín."
L.LOOT_PRICES_TEXT = "Precios del botín"
L.MONEY_NOTIFICATIONS_DESCRIPTION = "Muestra una notificación cuando se saquea o se recibe dinero."
L.MONEY_NOTIFICATIONS_TEXT = "Notificaciones de dinero"
L.OWNED_ITEM_COUNTS_DESCRIPTION = "Incluye la cantidad que posees del objeto en las notificaciones de botín."
L.OWNED_ITEM_COUNTS_TEXT = "Cantidad de objetos que posees"
L.RESET_ANCHOR = "Restablecer ancla"
L.RESET_TO_DEFAULTS = "Restablecer valores predeterminados"
L.RIGHT = "Derecha"
L.RIGHT_CLICK = "Clic derecho"
L.UP = "Arriba"
