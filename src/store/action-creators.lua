local Addon = select(2, ...) ---@type Addon
local ActionTypes = Addon:GetModule("ActionTypes")
local Wux = Addon.Wux

--- @class ActionCreators
local ActionCreators = Addon:GetModule("ActionCreators")

-- ============================================================================
-- LuaCATS Annotations
-- ============================================================================

--- @alias AnchorAlignment "LEFT" | "CENTER" | "RIGHT"
--- @alias AnchorDirection "DOWN" | "UP"

--- @class AnchorPointPayload
--- @field x number
--- @field y number

--- @class MinimapIconPayload
--- @field hide? boolean
--- @field minimapPos? number Position on the minimap, as an angle in degrees.

-- ============================================================================
-- ActionCreators
-- ============================================================================

--- Action creator for `ActionTypes.PATCH_MINIMAP_ICON`.
--- @type WuxActionCreator<MinimapIconPayload>
ActionCreators.patchMinimapIcon = Wux:CreateActionCreator(ActionTypes.PATCH_MINIMAP_ICON)

--- Action creator for `ActionTypes.RESET_ANCHOR_ALIGNMENT`.
--- @type WuxActionCreator<nil>
ActionCreators.resetAnchorAlignment = Wux:CreateActionCreator(ActionTypes.RESET_ANCHOR_ALIGNMENT)

--- Action creator for `ActionTypes.RESET_ANCHOR_DIRECTION`.
--- @type WuxActionCreator<nil>
ActionCreators.resetAnchorDirection = Wux:CreateActionCreator(ActionTypes.RESET_ANCHOR_DIRECTION)

--- Action creator for `ActionTypes.RESET_ANCHOR_POINT`.
--- @type WuxActionCreator<nil>
ActionCreators.resetAnchorPoint = Wux:CreateActionCreator(ActionTypes.RESET_ANCHOR_POINT)

--- Action creator for `ActionTypes.RESET_LOOT_PRICES`.
--- @type WuxActionCreator<nil>
ActionCreators.resetLootPrices = Wux:CreateActionCreator(ActionTypes.RESET_LOOT_PRICES)

--- Action creator for `ActionTypes.RESET_MAIN_WINDOW_POINT`.
--- @type WuxActionCreator<nil>
ActionCreators.resetMainWindowPoint = Wux:CreateActionCreator(ActionTypes.RESET_MAIN_WINDOW_POINT)

--- Action creator for `ActionTypes.RESET_MONEY_NOTIFICATIONS`.
--- @type WuxActionCreator<nil>
ActionCreators.resetMoneyNotifications = Wux:CreateActionCreator(ActionTypes.RESET_MONEY_NOTIFICATIONS)

--- Action creator for `ActionTypes.RESET_OWNED_ITEM_COUNTS`.
--- @type WuxActionCreator<nil>
ActionCreators.resetOwnedItemCounts = Wux:CreateActionCreator(ActionTypes.RESET_OWNED_ITEM_COUNTS)

--- Action creator for `ActionTypes.SET_ANCHOR_ALIGNMENT`.
--- @type WuxActionCreator<AnchorAlignment>
ActionCreators.setAnchorAlignment = Wux:CreateActionCreator(ActionTypes.SET_ANCHOR_ALIGNMENT)

--- Action creator for `ActionTypes.SET_ANCHOR_DIRECTION`.
--- @type WuxActionCreator<AnchorDirection>
ActionCreators.setAnchorDirection = Wux:CreateActionCreator(ActionTypes.SET_ANCHOR_DIRECTION)

--- Action creator for `ActionTypes.SET_ANCHOR_POINT`.
--- @type WuxActionCreator<AnchorPointPayload>
ActionCreators.setAnchorPoint = Wux:CreateActionCreator(ActionTypes.SET_ANCHOR_POINT)

--- Action creator for `ActionTypes.SET_MAIN_WINDOW_POINT`.
--- @type WuxActionCreator<table>
ActionCreators.setMainWindowPoint = Wux:CreateActionCreator(ActionTypes.SET_MAIN_WINDOW_POINT)

--- Action creator for `ActionTypes.TOGGLE_LOOT_PRICES`.
--- @type WuxActionCreator<nil>
ActionCreators.toggleLootPrices = Wux:CreateActionCreator(ActionTypes.TOGGLE_LOOT_PRICES)

--- Action creator for `ActionTypes.TOGGLE_MONEY_NOTIFICATIONS`.
--- @type WuxActionCreator<nil>
ActionCreators.toggleMoneyNotifications = Wux:CreateActionCreator(ActionTypes.TOGGLE_MONEY_NOTIFICATIONS)

--- Action creator for `ActionTypes.TOGGLE_OWNED_ITEM_COUNTS`.
--- @type WuxActionCreator<nil>
ActionCreators.toggleOwnedItemCounts = Wux:CreateActionCreator(ActionTypes.TOGGLE_OWNED_ITEM_COUNTS)
