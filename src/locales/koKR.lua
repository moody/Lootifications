if GetLocale() ~= "koKR" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- Korean (한국어)
-- ============================================================================

L.ANCHOR = "앵커"
L.GENERAL = "일반"
L.LEFT_CLICK = "왼쪽 클릭"
L.LOOT_PRICES_TEXT = "전리품 가격"
L.LOOT_PRICES_TOOLTIP = "전리품 알림에 아이템의 상점 판매 가격을 포함합니다."
L.MAX_NOTIFICATIONS_TEXT = "최대 알림 수"
L.MAX_NOTIFICATIONS_TOOLTIP = "표시되는 알림의 최대 개수입니다."
L.MONEY_NOTIFICATIONS_TEXT = "금전 알림"
L.MONEY_NOTIFICATIONS_TOOLTIP = "돈을 획득하거나 받을 때 알림을 표시합니다."
L.NOTIFICATION_ALPHA_TEXT = "알림 알파"
L.NOTIFICATION_ALPHA_TOOLTIP = "알림 배경의 투명도입니다."
L.NOTIFICATION_FADE_OUT_DELAY_TEXT = "알림 사라짐 지연 시간"
L.NOTIFICATION_FADE_OUT_DELAY_TOOLTIP = "알림이 사라지기 전까지의 대기 시간입니다."
L.NOTIFICATION_SPACING_TEXT = "알림 간격"
L.NOTIFICATION_SPACING_TOOLTIP = "알림 사이의 간격입니다."
L.OPTIONS_TEXT = "설정"
L.OWNED_ITEM_COUNTS_TEXT = "보유 아이템 수"
L.OWNED_ITEM_COUNTS_TOOLTIP = "전리품 알림에 보유 중인 아이템 수를 포함합니다."
L.RESET_ANCHOR = "앵커 초기화"
L.RIGHT_CLICK = "오른쪽 클릭"
L.SHIFT_KEY = "Shift"
L.TEST_NOTIFICATIONS = "알림 테스트"
L.TOGGLE_ANCHOR = "앵커 표시/숨김"
