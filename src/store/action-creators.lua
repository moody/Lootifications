local Addon = select(2, ...) ---@type Addon
local ActionTypes = Addon:GetModule("ActionTypes")
local Wux = Addon.Wux

--- @class ActionCreators
local ActionCreators = Addon:GetModule("ActionCreators")

-- ============================================================================
-- ActionCreators - Global - Notifications
-- ============================================================================

ActionCreators.Notifications = {
  --- Action creator for `ActionTypes.Notifications.RESET_BACKGROUND`.
  --- @type WuxActionCreator<nil>
  resetBackground = Wux:CreateActionCreator(ActionTypes.Notifications.RESET_BACKGROUND),

  --- Action creator for `ActionTypes.Notifications.RESET_BAG_COUNTS`.
  --- @type WuxActionCreator<nil>
  resetBagCounts = Wux:CreateActionCreator(ActionTypes.Notifications.RESET_BAG_COUNTS),

  --- Action creator for `ActionTypes.Notifications.RESET_ITEM_PRICES`.
  --- @type WuxActionCreator<nil>
  resetItemPrices = Wux:CreateActionCreator(ActionTypes.Notifications.RESET_ITEM_PRICES),

  --- Action creator for `ActionTypes.Notifications.RESET_MONEY`.
  --- @type WuxActionCreator<nil>
  resetMoney = Wux:CreateActionCreator(ActionTypes.Notifications.RESET_MONEY),

  --- Action creator for `ActionTypes.Notifications.SET_BACKGROUND`.
  --- @type WuxActionCreator<NotificationBackground>
  setBackground = Wux:CreateActionCreator(ActionTypes.Notifications.SET_BACKGROUND),

  --- Action creator for `ActionTypes.Notifications.TOGGLE_BAG_COUNTS`.
  --- @type WuxActionCreator<nil>
  toggleBagCounts = Wux:CreateActionCreator(ActionTypes.Notifications.TOGGLE_BAG_COUNTS),

  --- Action creator for `ActionTypes.Notifications.TOGGLE_ITEM_PRICES`.
  --- @type WuxActionCreator<nil>
  toggleItemPrices = Wux:CreateActionCreator(ActionTypes.Notifications.TOGGLE_ITEM_PRICES),

  --- Action creator for `ActionTypes.Notifications.TOGGLE_MONEY`.
  --- @type WuxActionCreator<nil>
  toggleMoney = Wux:CreateActionCreator(ActionTypes.Notifications.TOGGLE_MONEY),
}

-- ============================================================================
-- ActionCreators - Global - AnchorFrame
-- ============================================================================

ActionCreators.AnchorFrame = {
  --- Action creator for `ActionTypes.AnchorFrame.RESET_ALIGNMENT`.
  --- @type WuxActionCreator<nil>
  resetAlignment = Wux:CreateActionCreator(ActionTypes.AnchorFrame.RESET_ALIGNMENT),

  --- Action creator for `ActionTypes.AnchorFrame.RESET_DIRECTION`.
  --- @type WuxActionCreator<nil>
  resetDirection = Wux:CreateActionCreator(ActionTypes.AnchorFrame.RESET_DIRECTION),

  --- Action creator for `ActionTypes.AnchorFrame.RESET_POINT`.
  --- @type WuxActionCreator<nil>
  resetPoint = Wux:CreateActionCreator(ActionTypes.AnchorFrame.RESET_POINT),

  --- Action creator for `ActionTypes.AnchorFrame.SET_ALIGNMENT`.
  --- @type WuxActionCreator<AnchorAlignment>
  setAlignment = Wux:CreateActionCreator(ActionTypes.AnchorFrame.SET_ALIGNMENT),

  --- Action creator for `ActionTypes.AnchorFrame.SET_DIRECTION`.
  --- @type WuxActionCreator<AnchorDirection>
  setDirection = Wux:CreateActionCreator(ActionTypes.AnchorFrame.SET_DIRECTION),

  --- Action creator for `ActionTypes.AnchorFrame.SET_POINT`.
  --- @type WuxActionCreator<PointState>
  setPoint = Wux:CreateActionCreator(ActionTypes.AnchorFrame.SET_POINT),
}

-- ============================================================================
-- ActionCreators - Global - MainWindow
-- ============================================================================

ActionCreators.MainWindow = {
  --- Action creator for `ActionTypes.MainWindow.RESET_POINT`.
  --- @type WuxActionCreator<nil>
  resetPoint = Wux:CreateActionCreator(ActionTypes.MainWindow.RESET_POINT),

  --- Action creator for `ActionTypes.MainWindow.SET_POINT`.
  --- @type WuxActionCreator<PointState>
  setPoint = Wux:CreateActionCreator(ActionTypes.MainWindow.SET_POINT),
}

-- ============================================================================
-- ActionCreators - Global - MinimapIcon
-- ============================================================================

ActionCreators.MinimapIcon = {
  --- Action creator for `ActionTypes.MinimapIcon.PATCH`.
  --- @type WuxActionCreator<MinimapIconState>
  patch = Wux:CreateActionCreator(ActionTypes.MinimapIcon.PATCH),
}
