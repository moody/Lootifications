local ADDON_NAME = ... ---@type string

--- @class Addon
--- @field Waffle Waffle
--- @field Wux Wux
local Addon = select(2, ...)

-- ============================================================================
-- Constants
-- ============================================================================

Addon.ICON = ("Interface\\AddOns\\%s\\assets\\icon"):format(ADDON_NAME)
Addon.MAX_NOTIFICATIONS = 5
Addon.NOTIFICATION_ALPHA = 0.3
Addon.NOTIFICATION_FADE_IN = 0.25 -- Seconds.
Addon.NOTIFICATION_FADE_OUT = 0.2 -- Seconds.
Addon.NOTIFICATION_HOLD = 3       -- Seconds between fading in and fading out.
Addon.NOTIFICATION_SPACING = 4
Addon.NOTIFICATION_STAGGER = 0.15 -- Seconds between notifications showing.
Addon.PLAYER_NAME = UnitName("Player")
Addon.TEXTURE_MESSAGE_FORMAT = "|T%s:0:0:0:0:16:16:1:15:1:15|t %s"
Addon.VERSION = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version")

--@debug@
Addon.IS_DEBUG = false
--@end-debug@

-- ============================================================================
-- Functions
-- ============================================================================

-- Addon:GetModule()
do
  --- @type table<string, table>
  local modules = {}

  --- Gets or creates a module table for the given `key`.
  --- @generic T
  --- @param key `T`
  --- @return T
  function Addon:GetModule(key)
    --- @cast key +string
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

--- Prints the given arguments with debug formatting. Does nothing unless `Addon.IS_DEBUG` is `true`.
--- @param ... any
function Addon:Debug(...)
  if self.IS_DEBUG ~= true then return end
  print(date("%H:%M:%S"), self:GetModule("Colors").Red("[Debug]"), ...)
end

--- Dumps the given value. Does nothing unless `Addon.IS_DEBUG` is `true`.
--- @param value any
function Addon:Dump(value)
  if self.IS_DEBUG ~= true then return end
  DevTools_Dump(value)
end
