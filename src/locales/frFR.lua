if GetLocale() ~= "frFR" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- French (Français)
-- ============================================================================

L.ANCHOR = "Ancre"
L.GENERAL = "Général"
L.LEFT_CLICK = "Clic gauche"
L.LOOT_PRICES_TEXT = "Prix du butin"
L.LOOT_PRICES_TOOLTIP = "Inclut le prix de vente marchand des objets dans les notifications de butin."
L.MAX_NOTIFICATIONS_TEXT = "Notifications maximum"
L.MAX_NOTIFICATIONS_TOOLTIP = "Le nombre maximum de notifications affichées."
L.MONEY_NOTIFICATIONS_TEXT = "Notifications d'argent"
L.MONEY_NOTIFICATIONS_TOOLTIP = "Affiche une notification lorsque de l'argent est ramassé ou reçu."
L.NOTIFICATION_ALPHA_TEXT = "Alpha des notifications"
L.NOTIFICATION_ALPHA_TOOLTIP = "La transparence de l'arrière-plan des notifications."
L.NOTIFICATION_FADE_OUT_DELAY_TEXT = "Délai de disparition des notifications"
L.NOTIFICATION_FADE_OUT_DELAY_TOOLTIP = "Le délai avant que les notifications disparaissent."
L.NOTIFICATION_SPACING_TEXT = "Espacement des notifications"
L.NOTIFICATION_SPACING_TOOLTIP = "L'espace entre les notifications."
L.OPTIONS_TEXT = "Options"
L.OWNED_ITEM_COUNTS_TEXT = "Quantités possédées"
L.OWNED_ITEM_COUNTS_TOOLTIP = "Inclut la quantité possédée de l'objet dans les notifications de butin."
L.RESET_ANCHOR = "Réinitialiser l'ancre"
L.RIGHT_CLICK = "Clic droit"
L.SHIFT_KEY = "Maj"
L.TEST_NOTIFICATIONS = "Tester les notifications"
L.TOGGLE_ANCHOR = "Afficher/masquer l'ancre"
