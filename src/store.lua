--- @class Addon
local Addon = select(2, ...)

local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local Wux = Addon.Wux

local GLOBAL_SV = "__LOOTIFICATIONS_ADDON_GLOBAL_SAVED_VARIABLES__"

-- ============================================================================
-- Default State
-- ============================================================================

--- @class AddonState
local DEFAULT_STATE = {
  anchorPoint = {},
  lootPrices = false,
  maxNotifications = Addon.MAX_NOTIFICATIONS_DEFAULT,
  moneyNotifications = true,
  notificationAlpha = Addon.NOTIFICATION_ALPHA_DEFAULT,
  notificationFadeOutDelay = Addon.NOTIFICATION_FADE_OUT_DELAY_DEFAULT,
  notificationSpacing = Addon.NOTIFICATION_SPACING_DEFAULT,
  ownedItemCounts = false
}

-- ============================================================================
-- Reducers
-- ============================================================================

--- @type WuxReducer<AddonState>
local rootReducer = Wux:CombineReducers({
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

  -- Max notifications.
  maxNotifications = function(state, action)
    state = Wux:Coalesce(state, DEFAULT_STATE.maxNotifications)

    if action.type == "maxNotifications/set" then
      state = action.payload
    elseif action.type == "maxNotifications/reset" then
      state = DEFAULT_STATE.maxNotifications
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

  -- Notification alpha.
  notificationAlpha = function(state, action)
    state = Wux:Coalesce(state, DEFAULT_STATE.notificationAlpha)

    if action.type == "notificationAlpha/set" then
      state = action.payload
    elseif action.type == "notificationAlpha/reset" then
      state = DEFAULT_STATE.notificationAlpha
    end

    return state
  end,

  -- Notification fade-out delay.
  notificationFadeOutDelay = function(state, action)
    state = Wux:Coalesce(state, DEFAULT_STATE.notificationFadeOutDelay)

    if action.type == "notificationFadeOutDelay/set" then
      state = action.payload
    elseif action.type == "notificationFadeOutDelay/reset" then
      state = DEFAULT_STATE.notificationFadeOutDelay
    end

    return state
  end,

  -- Notification spacing.
  notificationSpacing = function(state, action)
    state = Wux:Coalesce(state, DEFAULT_STATE.notificationSpacing)

    if action.type == "notificationSpacing/set" then
      state = action.payload
    elseif action.type == "notificationSpacing/reset" then
      state = DEFAULT_STATE.notificationSpacing
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
  local Store = Wux:CreateStore(rootReducer, _G[GLOBAL_SV])
  _G[GLOBAL_SV] = Store:GetState()

  -- Update SavedVariables whenever the state changes.
  Store:Subscribe(function(state)
    _G[GLOBAL_SV] = state
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
end)
