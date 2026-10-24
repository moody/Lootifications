if GetLocale() ~= "zhTW" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- Traditional Chinese (繁體中文)
-- ============================================================================

L.ANCHOR = "錨點"
L.ANCHOR_TOOLTIP = "點擊並拖曳此框架以移動通知。"
L.LOOT_PRICES_TEXT = "拾取價格"
L.LOOT_PRICES_TOOLTIP = "在拾取通知中顯示物品的商人出售價格。"
L.MONEY_NOTIFICATIONS_TEXT = "金錢通知"
L.MONEY_NOTIFICATIONS_TOOLTIP = "拾取或收到金錢時顯示通知。"
L.OWNED_ITEM_COUNTS_TEXT = "擁有數量"
L.OWNED_ITEM_COUNTS_TOOLTIP = "在拾取通知中顯示已擁有的物品數量。"
L.RESET_ANCHOR = "重設錨點"
L.RIGHT_CLICK = "右鍵點擊"
