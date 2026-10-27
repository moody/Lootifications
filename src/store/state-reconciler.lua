local Addon = select(2, ...) ---@type Addon
local DefaultStates = Addon:GetModule("DefaultStates")
local Wux = Addon.Wux

--- @class StateReconciler
local StateReconciler = Addon:GetModule("StateReconciler")

-- ============================================================================
-- Local Functions
-- ============================================================================

--- Returns `value` with missing values backfilled from `default`, and values of the wrong type replaced with copies of
--- it. Tables with an empty `default` keep their contents, and keys without a default are kept. Mutates `value`.
--- @generic T
--- @param value any
--- @param default T
--- @return T
local function reconcile(value, default)
  if type(value) ~= type(default) then return Wux:DeepCopy(default) end
  if type(default) ~= "table" then return value end

  for key, defaultValue in pairs(default) do
    value[key] = reconcile(value[key], defaultValue)
  end
  return value
end

-- ============================================================================
-- StateReconciler
-- ============================================================================

--- Returns `state` in the current shape, without mutating the input. Missing values are backfilled from
--- `DefaultStates`, and values of the wrong type are replaced with copies of their defaults. Run after migrations,
--- which move old data first.
--- @param state LootificationsRootState
--- @return LootificationsRootState
function StateReconciler:Reconcile(state)
  state = Wux:DeepCopy(state)
  state.global = reconcile(state.global, DefaultStates.Global)
  return state
end
