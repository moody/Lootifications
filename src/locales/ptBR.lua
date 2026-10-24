if GetLocale() ~= "ptBR" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- Brazilian Portuguese (Português do Brasil)
-- ============================================================================

L.ANCHOR = "Âncora"
L.ANCHOR_TOOLTIP = "Clique e arraste este quadro para mover as notificações."
L.LOOT_PRICES_TEXT = "Preços do saque"
L.LOOT_PRICES_TOOLTIP = "Inclui o preço de venda dos itens nas notificações de saque."
L.MONEY_NOTIFICATIONS_TEXT = "Notificações de dinheiro"
L.MONEY_NOTIFICATIONS_TOOLTIP = "Mostra uma notificação quando dinheiro é saqueado ou recebido."
L.OWNED_ITEM_COUNTS_TEXT = "Quantidade de itens possuídos"
L.OWNED_ITEM_COUNTS_TOOLTIP = "Inclui a quantidade possuída do item nas notificações de saque."
L.RESET_ANCHOR = "Redefinir âncora"
L.RIGHT_CLICK = "Clique direito"
