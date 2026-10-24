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
L.DIRECTION_DESCRIPTION = "讓通知從錨點頂部向下增長，或從錨點底部向上增長。"
L.DIRECTION_TEXT = "方向"
L.DOWN = "向下"
L.GROW = "增長"
L.JUSTIFY = "對齊方式"
L.LEFT = "靠左"
L.LOOT_PRICES_DESCRIPTION = "在拾取通知中顯示物品的商人出售價格。"
L.LOOT_PRICES_TEXT = "拾取價格"
L.MONEY_NOTIFICATIONS_DESCRIPTION = "拾取或收到金錢時顯示通知。"
L.MONEY_NOTIFICATIONS_TEXT = "金錢通知"
L.OWNED_ITEM_COUNTS_DESCRIPTION = "在拾取通知中顯示已擁有的物品數量。"
L.OWNED_ITEM_COUNTS_TEXT = "擁有數量"
L.RESET_ANCHOR = "重設錨點"
L.RESET_TO_DEFAULTS = "重設為預設值"
L.RIGHT = "靠右"
L.RIGHT_CLICK = "右鍵點擊"
L.UP = "向上"
