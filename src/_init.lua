local ADDON_NAME, Addon = ...

-- ============================================================================
-- Constants
-- ============================================================================

Addon.ICON = ("Interface\\AddOns\\%s\\assets\\icon"):format(ADDON_NAME)
Addon.MAX_NOTIFICATIONS_DEFAULT = 10
Addon.MAX_NOTIFICATIONS_MAX = 25
Addon.MAX_NOTIFICATIONS_MIN = 1
Addon.PLAYER_NAME = UnitName("Player")
Addon.TEXTURE_MESSAGE_FORMAT = "|T%s:0:0:0:0:16:16:1:15:1:15|t %s"

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
