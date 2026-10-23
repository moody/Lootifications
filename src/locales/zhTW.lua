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
L.MONEY_NOTIFICATIONS_TEXT = "金錢通知"
L.MONEY_NOTIFICATIONS_TOOLTIP = "拾取或收到金錢時顯示通知。"
L.OPTIONS_TEXT = "選項"
L.OWNED_ITEM_COUNTS_TEXT = "擁有數量"
L.OWNED_ITEM_COUNTS_TOOLTIP = "在拾取通知中顯示已擁有的物品數量。"
L.RESET_ANCHOR = "重設錨點"
L.RIGHT_CLICK = "右鍵點擊"
L.SHIFT_KEY = "Shift"
L.TEST_NOTIFICATIONS = "測試通知"
L.TOGGLE_ANCHOR = "顯示/隱藏錨點"
