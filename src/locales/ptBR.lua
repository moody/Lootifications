if GetLocale() ~= "ptBR" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- Brazilian Portuguese (Português do Brasil)
-- ============================================================================

L.ALIGNMENT_DESCRIPTION = "Define como as notificações se alinham entre si."
L.ALIGNMENT_TEXT = "Alinhamento"
L.ANCHOR = "Âncora"
L.ANCHOR_TOOLTIP = "Clique e arraste este quadro para mover as notificações."
L.CENTER = "Centro"
L.DIRECTION_DESCRIPTION = "Faz as notificações crescerem para baixo a partir do topo da âncora ou para cima a partir da base."
L.DIRECTION_TEXT = "Direção"
L.DOWN = "Para baixo"
L.GROW = "Crescimento"
L.JUSTIFY = "Justificação"
L.LEFT = "Esquerda"
L.LOOT_PRICES_DESCRIPTION = "Inclui o preço de venda dos itens nas notificações de saque."
L.LOOT_PRICES_TEXT = "Preços do saque"
L.MONEY_NOTIFICATIONS_DESCRIPTION = "Mostra uma notificação quando dinheiro é saqueado ou recebido."
L.MONEY_NOTIFICATIONS_TEXT = "Notificações de dinheiro"
L.OWNED_ITEM_COUNTS_DESCRIPTION = "Inclui a quantidade possuída do item nas notificações de saque."
L.OWNED_ITEM_COUNTS_TEXT = "Quantidade de itens possuídos"
L.RESET_ANCHOR = "Redefinir âncora"
L.RESET_TO_DEFAULTS = "Redefinir para os padrões"
L.RIGHT = "Direita"
L.RIGHT_CLICK = "Clique direito"
L.UP = "Para cima"
