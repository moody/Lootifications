if GetLocale() ~= "zhCN" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- Simplified Chinese (简体中文)
-- ============================================================================

L.ANCHOR = "锚点"
L.GENERAL = "常规"
L.LEFT_CLICK = "左键点击"
L.LOOT_PRICES_TEXT = "拾取价格"
L.LOOT_PRICES_TOOLTIP = "在拾取通知中显示物品的商人出售价格。"
L.MAX_NOTIFICATIONS_TEXT = "最大通知数"
L.MAX_NOTIFICATIONS_TOOLTIP = "同时显示的通知的最大数量。"
L.MONEY_NOTIFICATIONS_TEXT = "金钱通知"
L.MONEY_NOTIFICATIONS_TOOLTIP = "拾取或收到金钱时显示通知。"
L.NOTIFICATION_ALPHA_TEXT = "通知 Alpha 值"
L.NOTIFICATION_ALPHA_TOOLTIP = "通知背景的透明度。"
L.NOTIFICATION_FADE_OUT_DELAY_TEXT = "通知消失延迟"
L.NOTIFICATION_FADE_OUT_DELAY_TOOLTIP = "通知消失前的等待时间。"
L.NOTIFICATION_SPACING_TEXT = "通知间距"
L.NOTIFICATION_SPACING_TOOLTIP = "通知之间的间距。"
L.OPTIONS_TEXT = "选项"
L.OWNED_ITEM_COUNTS_TEXT = "拥有数量"
L.OWNED_ITEM_COUNTS_TOOLTIP = "在拾取通知中显示已拥有的物品数量。"
L.RESET_ANCHOR = "重置锚点"
L.RIGHT_CLICK = "右键点击"
L.SHIFT_KEY = "Shift"
L.TEST_NOTIFICATIONS = "测试通知"
L.TOGGLE_ANCHOR = "显示/隐藏锚点"
