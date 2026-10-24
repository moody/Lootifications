--- @class Addon
local Addon = select(2, ...)

local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local Middlewares = Addon:GetModule("Middlewares")
local RootReducer = Addon:GetModule("RootReducer")
local Wux = Addon.Wux

local SAVED_VARIABLES = "__LOOTIFICATIONS_V2_SAVED_VARIABLES__"

-- ============================================================================
-- Events
-- ============================================================================

EventManager:Once(E.Wow.PlayerLogin, function()
  local Store = Wux:CreateStore(RootReducer:Build(), _G[SAVED_VARIABLES], Middlewares:Build())
  _G[SAVED_VARIABLES] = Store:GetState()

  -- Update SavedVariables whenever the state changes.
  Store:Subscribe(function(state)
    _G[SAVED_VARIABLES] = state
    EventManager:Fire(E.StateUpdated, state)
  end)

  --- Returns the underlying Wux store.
  --- @return WuxStore<LootificationsState>
  function Addon:GetStore()
    return Store
  end

  --- Returns the current state. Equivalent to `Addon:GetStore():GetState()`.
  --- @return LootificationsState
  function Addon:GetState()
    return Store:GetState()
  end

  EventManager:Fire(E.StoreInitialized, Store)
  EventManager:Fire(E.StateUpdated, Store:GetState())
end)
