local Addon = select(2, ...) ---@type Addon

--- @class ActionTypes
local ActionTypes = Addon:GetModule("ActionTypes")

-- ============================================================================
-- ActionTypes - Global - Notifications
-- ============================================================================

ActionTypes.Notifications = {
  RESET_BACKGROUND = "global/notifications/background/reset",
  RESET_BAG_COUNTS = "global/notifications/bagCounts/reset",
  RESET_ITEM_PRICES = "global/notifications/itemPrices/reset",
  RESET_MONEY = "global/notifications/money/reset",
  RESET_TEXT_SIZE = "global/notifications/textSize/reset",
  SET_BACKGROUND = "global/notifications/background/set",
  SET_TEXT_SIZE = "global/notifications/textSize/set",
  TOGGLE_BAG_COUNTS = "global/notifications/bagCounts/toggle",
  TOGGLE_ITEM_PRICES = "global/notifications/itemPrices/toggle",
  TOGGLE_MONEY = "global/notifications/money/toggle",
}

-- ============================================================================
-- ActionTypes - Global - AnchorFrame
-- ============================================================================

ActionTypes.AnchorFrame = {
  RESET_ALIGNMENT = "global/anchorFrame/alignment/reset",
  RESET_DIRECTION = "global/anchorFrame/direction/reset",
  RESET_POINT = "global/anchorFrame/point/reset",
  SET_ALIGNMENT = "global/anchorFrame/alignment/set",
  SET_DIRECTION = "global/anchorFrame/direction/set",
  SET_POINT = "global/anchorFrame/point/set",
}

-- ============================================================================
-- ActionTypes - Global - MainWindow
-- ============================================================================

ActionTypes.MainWindow = {
  RESET_POINT = "global/mainWindow/point/reset",
  SET_POINT = "global/mainWindow/point/set",
}

-- ============================================================================
-- ActionTypes - Global - MinimapIcon
-- ============================================================================

ActionTypes.MinimapIcon = {
  PATCH = "global/minimapIcon/patch",
}
