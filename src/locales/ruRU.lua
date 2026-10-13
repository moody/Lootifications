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
L.MAX_NOTIFICATIONS_TEXT = "Максимум уведомлений"
L.MAX_NOTIFICATIONS_TOOLTIP = "Максимальное количество отображаемых уведомлений."
L.MONEY_NOTIFICATIONS_TEXT = "Уведомления о деньгах"
L.MONEY_NOTIFICATIONS_TOOLTIP = "Показывает уведомление, когда вы получаете деньги."
L.NOTIFICATION_ALPHA_TEXT = "Альфа уведомлений"
L.NOTIFICATION_ALPHA_TOOLTIP = "Прозрачность фона уведомлений."
L.NOTIFICATION_FADE_OUT_DELAY_TEXT = "Задержка исчезновения уведомлений"
L.NOTIFICATION_FADE_OUT_DELAY_TOOLTIP = "Время ожидания перед исчезновением уведомлений."
L.NOTIFICATION_SPACING_TEXT = "Интервал между уведомлениями"
L.NOTIFICATION_SPACING_TOOLTIP = "Расстояние между уведомлениями."
L.OPTIONS_TEXT = "Настройки"
L.OWNED_ITEM_COUNTS_TEXT = "Количество предметов в наличии"
L.OWNED_ITEM_COUNTS_TOOLTIP = "Добавляет количество имеющихся у вас предметов в уведомления о добыче."
L.RESET_ANCHOR = "Сбросить якорь"
L.RIGHT_CLICK = "Правый клик"
L.SHIFT_KEY = "Shift"
L.TEST_NOTIFICATIONS = "Проверить уведомления"
L.TOGGLE_ANCHOR = "Показать/скрыть якорь"
