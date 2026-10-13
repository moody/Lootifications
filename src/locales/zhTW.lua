if GetLocale() ~= "zhTW" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- Traditional Chinese (繁體中文)
-- ============================================================================

L.ANCHOR = "錨點"
L.GENERAL = "一般"
L.LEFT_CLICK = "左鍵點擊"
L.LOOT_PRICES_TEXT = "拾取價格"
L.LOOT_PRICES_TOOLTIP = "在拾取通知中顯示物品的商人出售價格。"
L.MAX_NOTIFICATIONS_TEXT = "最大通知數"
L.MAX_NOTIFICATIONS_TOOLTIP = "同時顯示的通知最大數量。"
L.MONEY_NOTIFICATIONS_TEXT = "金錢通知"
L.MONEY_NOTIFICATIONS_TOOLTIP = "拾取或收到金錢時顯示通知。"
L.NOTIFICATION_ALPHA_TEXT = "通知 Alpha 值"
L.NOTIFICATION_ALPHA_TOOLTIP = "通知背景的透明度。"
L.NOTIFICATION_FADE_OUT_DELAY_TEXT = "通知消失延遲"
L.NOTIFICATION_FADE_OUT_DELAY_TOOLTIP = "通知消失前的等待時間。"
L.NOTIFICATION_SPACING_TEXT = "通知間距"
L.NOTIFICATION_SPACING_TOOLTIP = "通知之間的間距。"
L.OPTIONS_TEXT = "選項"
L.OWNED_ITEM_COUNTS_TEXT = "擁有數量"
L.OWNED_ITEM_COUNTS_TOOLTIP = "在拾取通知中顯示已擁有的物品數量。"
L.RESET_ANCHOR = "重設錨點"
L.RIGHT_CLICK = "右鍵點擊"
L.SHIFT_KEY = "Shift"
L.TEST_NOTIFICATIONS = "測試通知"
L.TOGGLE_ANCHOR = "顯示/隱藏錨點"
