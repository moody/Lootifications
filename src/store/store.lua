--- @class Addon
local Addon = select(2, ...)

local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local Wux = Addon.Wux

local SAVED_VARIABLES = "__LOOTIFICATIONS_V2_SAVED_VARIABLES__"

local ANCHOR_ALIGNMENTS = { LEFT = true, CENTER = true, RIGHT = true }
local ANCHOR_DIRECTIONS = { DOWN = true, UP = true }

-- ============================================================================
-- Default State
-- ============================================================================

--- @class AddonState
local DEFAULT_STATE = {
  anchorAlignment = "CENTER",
  anchorDirection = "DOWN",
  anchorPoint = {},
  lootPrices = false,
  moneyNotifications = true,
  ownedItemCounts = false
}

-- ============================================================================
-- Reducers
-- ============================================================================

--- @type WuxReducer<AddonState, any>
local rootReducer = Wux:CombineReducers({
  -- Anchor alignment.
  anchorAlignment = function(state, action)
    state = Wux:Coalesce(state, DEFAULT_STATE.anchorAlignment)

    if action.type == "anchorAlignment/set" then
      state = action.payload
    elseif action.type == "anchorAlignment/reset" then
      state = DEFAULT_STATE.anchorAlignment
    end

    return ANCHOR_ALIGNMENTS[state] and state or DEFAULT_STATE.anchorAlignment
  end,

  -- Anchor direction.
  anchorDirection = function(state, action)
    state = Wux:Coalesce(state, DEFAULT_STATE.anchorDirection)

    if action.type == "anchorDirection/set" then
      state = action.payload
    elseif action.type == "anchorDirection/reset" then
      state = DEFAULT_STATE.anchorDirection
    end

    return ANCHOR_DIRECTIONS[state] and state or DEFAULT_STATE.anchorDirection
  end,

  -- Anchor point.
  anchorPoint = function(state, action)
    state = Wux:Coalesce(state, DEFAULT_STATE.anchorPoint)

    if action.type == "anchorPoint/set" then
      state = action.payload
    elseif action.type == "anchorPoint/reset" then
      state = DEFAULT_STATE.anchorPoint
    end

    return state
  end,

  -- Loot prices.
  lootPrices = function(state, action)
    state = Wux:Coalesce(state, DEFAULT_STATE.lootPrices)

    if action.type == "lootPrices/toggle" then
      state = not state
    end

    return state
  end,

  -- Money notifications.
  moneyNotifications = function(state, action)
    state = Wux:Coalesce(state, DEFAULT_STATE.moneyNotifications)

    if action.type == "moneyNotifications/toggle" then
      state = not state
    end

    return state
  end,

  -- Owned item counts.
  ownedItemCounts = function(state, action)
    state = Wux:Coalesce(state, DEFAULT_STATE.ownedItemCounts)

    if action.type == "ownedItemCounts/toggle" then
      state = not state
    end

    return state
  end,
})

-- ============================================================================
-- Events
-- ============================================================================

EventManager:Once(E.Wow.PlayerLogin, function()
  local Store = Wux:CreateStore(rootReducer, _G[SAVED_VARIABLES])
  _G[SAVED_VARIABLES] = Store:GetState()

  -- Update SavedVariables whenever the state changes.
  Store:Subscribe(function(state)
    _G[SAVED_VARIABLES] = state
    EventManager:Fire(E.StateUpdated, state)
  end)

  --- Returns the underlying Wux store.
  --- @return WuxStore
  function Addon:GetStore()
    return Store
  end

  --- Returns the current state. Equivalent to `Addon:GetStore():GetState()`.
  --- @return AddonState
  function Addon:GetState()
    return Store:GetState()
  end

  EventManager:Fire(E.StoreInitialized, Store)
  EventManager:Fire(E.StateUpdated, Store:GetState())
end)
