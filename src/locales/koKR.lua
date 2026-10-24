if GetLocale() ~= "koKR" then return end
local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale")

-- ============================================================================
-- Korean (한국어)
-- ============================================================================

L.ALIGNMENT_DESCRIPTION = "알림이 서로 어떻게 정렬될지 정합니다."
L.ALIGNMENT_TEXT = "정렬"
L.ANCHOR = "앵커"
L.ANCHOR_TOOLTIP = "이 프레임을 클릭하고 드래그하여 알림을 이동합니다."
L.CENTER = "가운데"
L.COMMANDS = "명령"
L.COMMAND_DESCRIPTION_HELP = "명령 목록을 표시합니다."
L.COMMAND_DESCRIPTION_OPTIONS = "메인 창을 전환합니다."
L.COMMAND_DESCRIPTION_TEST = "테스트 알림을 몇 개 표시합니다."
L.DIRECTION_DESCRIPTION = "앵커 위쪽에서 아래로, 또는 아래쪽에서 위로 늘립니다."
L.DIRECTION_TEXT = "방향"
L.DOWN = "아래"
L.GROW = "확장"
L.JUSTIFY = "맞춤"
L.LAYOUT = "배치"
L.LEFT = "왼쪽"
L.LOOT_PRICES_DESCRIPTION = "전리품 알림에 아이템의 상점 판매 가격을 포함합니다."
L.LOOT_PRICES_TEXT = "전리품 가격"
L.MONEY = "돈"
L.MONEY_NOTIFICATIONS_DESCRIPTION = "돈을 획득하거나 받을 때 알림을 표시합니다."
L.NOTIFICATIONS = "알림"
L.OWNED_ITEM_COUNTS_DESCRIPTION = "전리품 알림에 보유 중인 아이템 수를 포함합니다."
L.OWNED_ITEM_COUNTS_TEXT = "보유 아이템 수"
L.RESET_ANCHOR = "앵커 초기화"
L.RESET_TO_DEFAULTS = "기본값으로 초기화"
L.RIGHT = "오른쪽"
L.RIGHT_CLICK = "오른쪽 클릭"
L.TEST_NOTIFICATIONS_HINT = "%s 명령으로 테스트 알림을 몇 개 표시합니다."
L.UP = "위"
