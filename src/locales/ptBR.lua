if GetLocale() ~= "ptBR" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- Brazilian Portuguese (Português do Brasil)
-- ============================================================================

L.ANCHOR = "Âncora"
L.GENERAL = "Geral"
L.LEFT_CLICK = "Clique esquerdo"
L.LOOT_PRICES_TEXT = "Preços do saque"
L.LOOT_PRICES_TOOLTIP = "Inclui o preço de venda dos itens nas notificações de saque."
L.MAX_NOTIFICATIONS_TEXT = "Máximo de notificações"
L.MAX_NOTIFICATIONS_TOOLTIP = "O número máximo de notificações exibidas."
L.MONEY_NOTIFICATIONS_TEXT = "Notificações de dinheiro"
L.MONEY_NOTIFICATIONS_TOOLTIP = "Mostra uma notificação quando dinheiro é saqueado ou recebido."
L.NOTIFICATION_ALPHA_TEXT = "Alfa das notificações"
L.NOTIFICATION_ALPHA_TOOLTIP = "A transparência do fundo das notificações."
L.NOTIFICATION_FADE_OUT_DELAY_TEXT = "Atraso do desaparecimento das notificações"
L.NOTIFICATION_FADE_OUT_DELAY_TOOLTIP = "O tempo de espera antes de as notificações desaparecerem."
L.NOTIFICATION_SPACING_TEXT = "Espaçamento das notificações"
L.NOTIFICATION_SPACING_TOOLTIP = "O espaço entre as notificações."
L.OPTIONS_TEXT = "Opções"
L.OWNED_ITEM_COUNTS_TEXT = "Quantidade de itens possuídos"
L.OWNED_ITEM_COUNTS_TOOLTIP = "Inclui a quantidade possuída do item nas notificações de saque."
L.RESET_ANCHOR = "Redefinir âncora"
L.RIGHT_CLICK = "Clique direito"
L.SHIFT_KEY = "Shift"
L.TEST_NOTIFICATIONS = "Testar notificações"
L.TOGGLE_ANCHOR = "Mostrar/ocultar âncora"
