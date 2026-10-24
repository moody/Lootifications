if GetLocale() ~= "zhCN" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- Simplified Chinese (简体中文)
-- ============================================================================

L.ALIGNMENT_DESCRIPTION = "决定通知之间如何对齐。"
L.ALIGNMENT_TEXT = "对齐"
L.ANCHOR = "锚点"
L.ANCHOR_TOOLTIP = "点击并拖动此框架以移动通知。"
L.CENTER = "居中"
L.COMMANDS = "命令"
L.COMMAND_DESCRIPTION_HELP = "显示命令列表。"
L.COMMAND_DESCRIPTION_OPTIONS = "切换主窗口。"
L.COMMAND_DESCRIPTION_TEST = "显示几条测试通知。"
L.DIRECTION_DESCRIPTION = "从锚点顶部向下增长，或从锚点底部向上增长。"
L.DIRECTION_TEXT = "方向"
L.DOWN = "向下"
L.GROW = "增长"
L.JUSTIFY = "对齐方式"
L.LAYOUT = "布局"
L.LEFT = "靠左"
L.LOG = "日志"
L.LOOT_PRICES_DESCRIPTION = "在拾取通知中显示物品的商人出售价格。"
L.LOOT_PRICES_TEXT = "拾取价格"
L.MONEY = "金钱"
L.MONEY_NOTIFICATIONS_DESCRIPTION = "拾取或收到金钱时显示通知。"
L.NOTIFICATIONS = "通知"
L.OWNED_ITEM_COUNTS_DESCRIPTION = "在拾取通知中显示已拥有的物品数量。"
L.OWNED_ITEM_COUNTS_TEXT = "拥有数量"
L.QUANTITY_FORMAT = "数量：%d"
L.RESET_ANCHOR = "重置锚点"
L.RESET_TO_DEFAULTS = "重置为默认设置"
L.RIGHT = "靠右"
L.RIGHT_CLICK = "右键点击"
L.SETTINGS = "设置"
L.TEST_NOTIFICATIONS_HINT = "使用 %s 显示几条测试通知。"
L.UP = "向上"
