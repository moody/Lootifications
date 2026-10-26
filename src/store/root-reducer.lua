local Addon = select(2, ...) ---@type Addon
local ActionTypes = Addon:GetModule("ActionTypes")
local DefaultStates = Addon:GetModule("DefaultStates")
local Wux = Addon.Wux

--- @class RootReducer
local RootReducer = Addon:GetModule("RootReducer")

--- Builds the reducer of the whole state.
--- @return WuxReducer<LootificationsState, any>
function RootReducer:Build()
  local defaultState = DefaultStates.Root

  return Wux:CombineReducers({
    -- Anchor alignment.
    anchorAlignment = function(state, action)
      state = Wux:Coalesce(state, defaultState.anchorAlignment)

      if action.type == ActionTypes.SET_ANCHOR_ALIGNMENT then
        state = action.payload
      elseif action.type == ActionTypes.RESET_ANCHOR_ALIGNMENT then
        state = defaultState.anchorAlignment
      end

      return DefaultStates.ANCHOR_ALIGNMENTS[state] and state or defaultState.anchorAlignment
    end,

    -- Anchor direction.
    anchorDirection = function(state, action)
      state = Wux:Coalesce(state, defaultState.anchorDirection)

      if action.type == ActionTypes.SET_ANCHOR_DIRECTION then
        state = action.payload
      elseif action.type == ActionTypes.RESET_ANCHOR_DIRECTION then
        state = defaultState.anchorDirection
      end

      return DefaultStates.ANCHOR_DIRECTIONS[state] and state or defaultState.anchorDirection
    end,

    -- Anchor point.
    anchorPoint = function(state, action)
      state = Wux:Coalesce(state, defaultState.anchorPoint)

      if action.type == ActionTypes.SET_ANCHOR_POINT then
        state = action.payload
      elseif action.type == ActionTypes.RESET_ANCHOR_POINT then
        state = defaultState.anchorPoint
      end

      return type(state) == "table" and state or defaultState.anchorPoint
    end,

    -- Loot prices.
    lootPrices = function(state, action)
      state = Wux:Coalesce(state, defaultState.lootPrices)

      if action.type == ActionTypes.TOGGLE_LOOT_PRICES then
        state = not state
      elseif action.type == ActionTypes.RESET_LOOT_PRICES then
        state = defaultState.lootPrices
      end

      return state
    end,

    -- Main window point.
    mainWindowPoint = function(state, action)
      state = Wux:Coalesce(state, defaultState.mainWindowPoint)

      if action.type == ActionTypes.SET_MAIN_WINDOW_POINT then
        state = action.payload
      elseif action.type == ActionTypes.RESET_MAIN_WINDOW_POINT then
        state = defaultState.mainWindowPoint
      end

      return type(state) == "table" and state or defaultState.mainWindowPoint
    end,

    -- Minimap icon.
    minimapIcon = Wux:CreatePatchReducer(ActionTypes.PATCH_MINIMAP_ICON, defaultState.minimapIcon),

    -- Money notifications.
    moneyNotifications = function(state, action)
      state = Wux:Coalesce(state, defaultState.moneyNotifications)

      if action.type == ActionTypes.TOGGLE_MONEY_NOTIFICATIONS then
        state = not state
      elseif action.type == ActionTypes.RESET_MONEY_NOTIFICATIONS then
        state = defaultState.moneyNotifications
      end

      return state
    end,

    -- Notification background.
    notificationBackground = function(state, action)
      state = Wux:Coalesce(state, defaultState.notificationBackground)

      if action.type == ActionTypes.SET_NOTIFICATION_BACKGROUND then
        state = action.payload
      elseif action.type == ActionTypes.RESET_NOTIFICATION_BACKGROUND then
        state = defaultState.notificationBackground
      end

      return DefaultStates.NOTIFICATION_BACKGROUNDS[state] and state or defaultState.notificationBackground
    end,

    -- Owned item counts.
    ownedItemCounts = function(state, action)
      state = Wux:Coalesce(state, defaultState.ownedItemCounts)

      if action.type == ActionTypes.TOGGLE_OWNED_ITEM_COUNTS then
        state = not state
      elseif action.type == ActionTypes.RESET_OWNED_ITEM_COUNTS then
        state = defaultState.ownedItemCounts
      end

      return state
    end,
  })
end
