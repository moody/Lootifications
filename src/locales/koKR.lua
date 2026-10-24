if GetLocale() ~= "koKR" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- Korean (한국어)
-- ============================================================================

L.ANCHOR = "앵커"
L.ANCHOR_TOOLTIP = "이 프레임을 클릭하고 드래그하여 알림을 이동합니다."
L.GENERAL = "일반"
L.LOOT_PRICES_TEXT = "전리품 가격"
L.LOOT_PRICES_TOOLTIP = "전리품 알림에 아이템의 상점 판매 가격을 포함합니다."
L.MONEY_NOTIFICATIONS_TEXT = "금전 알림"
L.MONEY_NOTIFICATIONS_TOOLTIP = "돈을 획득하거나 받을 때 알림을 표시합니다."
L.OPTIONS_TEXT = "설정"
L.OWNED_ITEM_COUNTS_TEXT = "보유 아이템 수"
L.OWNED_ITEM_COUNTS_TOOLTIP = "전리품 알림에 보유 중인 아이템 수를 포함합니다."
L.RESET_ANCHOR = "앵커 초기화"
L.RIGHT_CLICK = "오른쪽 클릭"
