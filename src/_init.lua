local ADDON_NAME = ... ---@type string

--- @class Addon
--- @field Wux Wux
local Addon = select(2, ...)

-- ============================================================================
-- Constants
-- ============================================================================

Addon.ICON = ("Interface\\AddOns\\%s\\assets\\icon"):format(ADDON_NAME)
Addon.MAX_NOTIFICATIONS_DEFAULT = 10
Addon.MAX_NOTIFICATIONS_MAX = 25
Addon.MAX_NOTIFICATIONS_MIN = 1
Addon.NOTIFICATION_ALPHA_DEFAULT = 30
Addon.NOTIFICATION_ALPHA_MAX = 100
Addon.NOTIFICATION_ALPHA_MIN = 0
Addon.NOTIFICATION_FADE_OUT_DELAY_DEFAULT = 3
Addon.NOTIFICATION_FADE_OUT_DELAY_MAX = 10
Addon.NOTIFICATION_FADE_OUT_DELAY_MIN = 1
Addon.NOTIFICATION_SPACING_DEFAULT = 4
Addon.NOTIFICATION_SPACING_MAX = 64
Addon.NOTIFICATION_SPACING_MIN = 0
Addon.PLAYER_NAME = UnitName("Player")
Addon.TEXTURE_MESSAGE_FORMAT = "|T%s:0:0:0:0:16:16:1:15:1:15|t %s"
Addon.VERSION = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version")

-- ============================================================================
-- Functions
-- ============================================================================

do -- Addon:GetModule()
  local modules = {}

  --- Returns a module using the given key.
  --- @param key string
  --- @return table
  function Addon:GetModule(key)
    key = key:upper()
    if type(modules[key]) ~= "table" then modules[key] = {} end
    return modules[key]
  end
end

--- Returns the full path to a file in the `/assets` folder.
--- @param fileName string
--- @return string
function Addon:GetAsset(fileName)
  return ("Interface\\AddOns\\%s\\assets\\%s"):format(ADDON_NAME, fileName)
end

-- Addon:Concat()
do
  local Colors = Addon:GetModule("Colors")
  local cache = {}

  --- Concatenates arguments with a given separator.
  --- @param sep string
  --- @param ... string|number
  --- @return string
  function Addon:Concat(sep, ...)
    for k in pairs(cache) do cache[k] = nil end
    for i = 1, select("#", ...) do cache[#cache + 1] = select(i, ...) end
    return table.concat(cache, Colors.Grey(sep))
  end
end

--- Returns `value` if it is not nil; otherwise, returns `default`.
--- @generic T1, T2
--- @param value? T1
--- @param default T2
--- @return T1|T2 value
function Addon:IfNil(value, default)
  if value == nil then return default end
  return value
end

--- Sets a default value for the given table and key, if the current value is nil.
--- @param t table
--- @param key string
--- @param default any
function Addon:IfKeyNil(t, key, default)
  if t[key] == nil then t[key] = default end
end

--- Prints values prefixed with addon's name.
--- @param ... any
function Addon:Print(...)
  print(self:GetModule("Colors").Purple("[" .. ADDON_NAME .. "]"), ...)
end

do -- Addon:RegisterIntervalCallback()
  local callbacks = {}

  CreateFrame("Frame"):SetScript("OnUpdate", function(_, elapsed)
    for _, callback in ipairs(callbacks) do callback(elapsed) end
  end)

  --- Registers a function to be called repeatedly at a specified interval (defined in seconds).
  --- @param interval number
  --- @param callback function
  function Addon:RegisterIntervalCallback(interval, callback)
    local timer = interval
    callbacks[#callbacks + 1] = function(elapsed)
      timer = timer + elapsed
      if timer >= interval then
        timer = 0
        callback()
      end
    end
  end
end
