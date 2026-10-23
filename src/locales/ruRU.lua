if GetLocale() ~= "ruRU" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- Russian (Русский)
-- ============================================================================

L.ANCHOR = "Якорь"
L.GENERAL = "Общие"
L.LEFT_CLICK = "Левый клик"
L.LOOT_PRICES_TEXT = "Цены добычи"
L.LOOT_PRICES_TOOLTIP = "Добавляет цену продажи предметов торговцу в уведомления о добыче."
L.MONEY_NOTIFICATIONS_TEXT = "Уведомления о деньгах"
L.MONEY_NOTIFICATIONS_TOOLTIP = "Показывает уведомление, когда вы получаете деньги."
L.OPTIONS_TEXT = "Настройки"
L.OWNED_ITEM_COUNTS_TEXT = "Количество предметов в наличии"
L.OWNED_ITEM_COUNTS_TOOLTIP = "Добавляет количество имеющихся у вас предметов в уведомления о добыче."
L.RESET_ANCHOR = "Сбросить якорь"
L.RIGHT_CLICK = "Правый клик"
L.SHIFT_KEY = "Shift"
L.TEST_NOTIFICATIONS = "Проверить уведомления"
L.TOGGLE_ANCHOR = "Показать/скрыть якорь"
