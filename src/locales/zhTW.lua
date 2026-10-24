if GetLocale() ~= "zhTW" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- Traditional Chinese (繁體中文)
-- ============================================================================

L.ALIGNMENT_DESCRIPTION = "決定通知之間如何對齊。"
L.ALIGNMENT_TEXT = "對齊"
L.ANCHOR = "錨點"
L.ANCHOR_TOOLTIP = "點擊並拖曳此框架以移動通知。"
L.CENTER = "置中"
L.CLEAR_LOG = "清除紀錄"
L.COMMANDS = "命令"
L.COMMAND_DESCRIPTION_HELP = "顯示命令清單。"
L.COMMAND_DESCRIPTION_OPTIONS = "切換主視窗。"
L.COMMAND_DESCRIPTION_TEST = "顯示幾則測試通知。"
L.DIRECTION_DESCRIPTION = "從錨點頂部向下增長，或從錨點底部向上增長。"
L.DIRECTION_TEXT = "方向"
L.DOWN = "向下"
L.GROW = "增長"
L.JUSTIFY = "對齊方式"
L.LAYOUT = "版面配置"
L.LEFT = "靠左"
L.LOG = "紀錄"
L.LOOT_PRICES_DESCRIPTION = "在拾取通知中顯示物品的商人出售價格。"
L.LOOT_PRICES_TEXT = "拾取價格"
L.MONEY = "金錢"
L.MONEY_NOTIFICATIONS_DESCRIPTION = "拾取或收到金錢時顯示通知。"
L.NOTIFICATIONS = "通知"
L.NO_LOOT = "沒有戰利品。"
L.OWNED_ITEM_COUNTS_DESCRIPTION = "在拾取通知中顯示已擁有的物品數量。"
L.OWNED_ITEM_COUNTS_TEXT = "擁有數量"
L.QUANTITY_FORMAT = "數量：%d"
L.RESET_ANCHOR = "重設錨點"
L.RESET_TO_DEFAULTS = "重設為預設值"
L.RIGHT = "靠右"
L.RIGHT_CLICK = "右鍵點擊"
L.SETTINGS = "設定"
L.TEST_NOTIFICATIONS_HINT = "使用 %s 顯示幾則測試通知。"
L.UP = "向上"
