if GetLocale() ~= "frFR" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- French (Français)
-- ============================================================================

L.ALIGNMENT_DESCRIPTION = "Définit comment les notifications sont alignées entre elles."
L.ALIGNMENT_TEXT = "Alignement"
L.ANCHOR = "Ancre"
L.ANCHOR_TOOLTIP = "Cliquez et faites glisser ce cadre pour déplacer les notifications."
L.CENTER = "Centre"
L.DIRECTION_DESCRIPTION = "Étend les notifications vers le bas depuis le haut de l'ancre, ou vers le haut depuis son bas."
L.DIRECTION_TEXT = "Direction"
L.DOWN = "Bas"
L.GROW = "Croissance"
L.JUSTIFY = "Justification"
L.LEFT = "Gauche"
L.LOOT_PRICES_DESCRIPTION = "Inclut le prix de vente marchand des objets dans les notifications de butin."
L.LOOT_PRICES_TEXT = "Prix du butin"
L.MONEY_NOTIFICATIONS_DESCRIPTION = "Affiche une notification lorsque de l'argent est ramassé ou reçu."
L.MONEY_NOTIFICATIONS_TEXT = "Notifications d'argent"
L.OWNED_ITEM_COUNTS_DESCRIPTION = "Inclut la quantité possédée de l'objet dans les notifications de butin."
L.OWNED_ITEM_COUNTS_TEXT = "Quantités possédées"
L.RESET_ANCHOR = "Réinitialiser l'ancre"
L.RESET_TO_DEFAULTS = "Réinitialiser les paramètres par défaut"
L.RIGHT = "Droite"
L.RIGHT_CLICK = "Clic droit"
L.UP = "Haut"
