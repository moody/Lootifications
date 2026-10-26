local Addon = select(2, ...) ---@type Addon
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local Middlewares = Addon:GetModule("Middlewares")
local Migrations = Addon:GetModule("Migrations")
local RootReducer = Addon:GetModule("RootReducer")
local StateReconciler = Addon:GetModule("StateReconciler")
local Wux = Addon.Wux

--- @class StateManager
local StateManager = Addon:GetModule("StateManager")

local SAVED_VARIABLES_KEY = "__LOOTIFICATIONS_V2_SAVED_VARIABLES__"

-- ============================================================================
-- Store
-- ============================================================================

--- @type WuxStore<LootificationsRootState>
local Store

-- Create the store once the `Wow.PlayerLogin` event fires.
EventManager:Once(E.Wow.PlayerLogin, function()
  --- @type LootificationsRootState
  local initialState = Wux:ReadSavedVariables(SAVED_VARIABLES_KEY)
  initialState = Migrations:Migrate(initialState)
  initialState = StateReconciler:Reconcile(initialState)

  Store = Wux:CreateStore(RootReducer:Build(), initialState, Middlewares:Build())

  -- Update SavedVariables whenever the state changes.
  local function write(state)
    _G[SAVED_VARIABLES_KEY] = state
  end
  write(Store:GetState())
  Store:Subscribe(write)

  Store:Subscribe(function(state)
    EventManager:Fire(E.StateUpdated, state)
  end)

  EventManager:Fire(E.StoreInitialized, Store)
  EventManager:Fire(E.StateUpdated, Store:GetState())
end)

-- ============================================================================
-- StateManager
-- ============================================================================

--- Returns the underlying Wux store.
--- @return WuxStore<LootificationsRootState>
function StateManager:GetStore()
  return Store
end

--- Convenience method. Equivalent to `StateManager:GetStore():Dispatch()`.
--- @param action WuxAction
function StateManager:Dispatch(action)
  Store:Dispatch(action)
end

--- Returns the global state.
--- @return GlobalState
function StateManager:GetGlobalState()
  return Store:GetState().global
end
