local Addon = select(2, ...) ---@type Addon

--- @class ActionTypes
local ActionTypes = Addon:GetModule("ActionTypes")

ActionTypes.RESET_ANCHOR_ALIGNMENT = "anchorAlignment/reset"
ActionTypes.RESET_ANCHOR_DIRECTION = "anchorDirection/reset"
ActionTypes.RESET_ANCHOR_POINT = "anchorPoint/reset"
ActionTypes.RESET_LOOT_PRICES = "lootPrices/reset"
ActionTypes.RESET_MAIN_WINDOW_POINT = "mainWindowPoint/reset"
ActionTypes.RESET_MONEY_NOTIFICATIONS = "moneyNotifications/reset"
ActionTypes.RESET_OWNED_ITEM_COUNTS = "ownedItemCounts/reset"
ActionTypes.SET_ANCHOR_ALIGNMENT = "anchorAlignment/set"
ActionTypes.SET_ANCHOR_DIRECTION = "anchorDirection/set"
ActionTypes.SET_ANCHOR_POINT = "anchorPoint/set"
ActionTypes.SET_MAIN_WINDOW_POINT = "mainWindowPoint/set"
ActionTypes.TOGGLE_LOOT_PRICES = "lootPrices/toggle"
ActionTypes.TOGGLE_MONEY_NOTIFICATIONS = "moneyNotifications/toggle"
ActionTypes.TOGGLE_OWNED_ITEM_COUNTS = "ownedItemCounts/toggle"
