local _, Addon = ...
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local SavedVariables = Addon:GetModule("SavedVariables")

local GLOBAL_SV = "__LOOTIFICATIONS_ADDON_GLOBAL_SAVED_VARIABLES__"

-- ============================================================================
-- Local Functions
-- ============================================================================

local function globalDefaults()
  return {
    moneyNotifications = false
  }
end

local function populate(t, defaults)
  for k, v in pairs(defaults) do
    if type(v) == "table" then
      if type(t[k]) ~= "table" then t[k] = {} end
      populate(t[k], v)
    else
      if type(t[k]) ~= type(v) then t[k] = v end
    end
  end
end

local function depopulate(t, defaults)
  for k, v in pairs(t) do
    if type(v) == "table" and type(defaults[k]) == "table" then
      depopulate(v, defaults[k])
      if next(v) == nil then t[k] = nil end
    elseif defaults[k] == v then
      t[k] = nil
    end
  end
end

-- ============================================================================
-- Events
-- ============================================================================

-- Initialize.
EventManager:Once(E.Wow.PlayerLogin, function()
  if type(_G[GLOBAL_SV]) ~= "table" then _G[GLOBAL_SV] = {} end
  populate(_G[GLOBAL_SV], globalDefaults())
  local global = _G[GLOBAL_SV]

  function SavedVariables:Get()
    return global
  end
end)

-- Deinitialize.
EventManager:On(E.Wow.PlayerLogout, function()
  depopulate(_G[GLOBAL_SV], globalDefaults())
end)
