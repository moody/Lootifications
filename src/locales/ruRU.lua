if GetLocale() ~= "ruRU" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- Russian (Русский)
-- ============================================================================

L.ALIGNMENT_DESCRIPTION = "Определяет, как уведомления выравниваются относительно друг друга."
L.ALIGNMENT_TEXT = "Выравнивание"
L.ANCHOR = "Якорь"
L.ANCHOR_TOOLTIP = "Нажмите и перетащите эту рамку, чтобы переместить уведомления."
L.CENTER = "По центру"
L.DIRECTION_DESCRIPTION = "Уведомления растут вниз от верхнего края якоря или вверх от нижнего."
L.DIRECTION_TEXT = "Направление"
L.DOWN = "Вниз"
L.GROW = "Рост"
L.JUSTIFY = "Выключка"
L.LEFT = "Слева"
L.LOOT_PRICES_DESCRIPTION = "Добавляет цену продажи предметов торговцу в уведомления о добыче."
L.LOOT_PRICES_TEXT = "Цены добычи"
L.MONEY_NOTIFICATIONS_DESCRIPTION = "Показывает уведомление, когда вы получаете деньги."
L.MONEY_NOTIFICATIONS_TEXT = "Уведомления о деньгах"
L.OWNED_ITEM_COUNTS_DESCRIPTION = "Добавляет количество имеющихся у вас предметов в уведомления о добыче."
L.OWNED_ITEM_COUNTS_TEXT = "Количество предметов в наличии"
L.RESET_ANCHOR = "Сбросить якорь"
L.RESET_TO_DEFAULTS = "Сбросить настройки по умолчанию"
L.RIGHT = "Справа"
L.RIGHT_CLICK = "Правый клик"
L.UP = "Вверх"
