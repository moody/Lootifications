local ADDON_NAME, Addon = ...
local Colors = Addon:GetModule("Colors")
local Commands = Addon:GetModule("Commands")
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local L = Addon:GetModule("Locale")
local SavedVariables = Addon:GetModule("SavedVariables")

-- ============================================================================
-- Events
-- ============================================================================

EventManager:Once(E.Wow.PlayerLogin, function()
  SLASH_LOOTIFICATIONS1 = "/lootifications"
  SlashCmdList.LOOTIFICATIONS = function(msg)
    msg = strlower(msg or "")

    -- Split message into args.
    local args = {}
    for arg in msg:gmatch("%S+") do args[#args + 1] = strlower(arg) end

    -- First arg is command name.
    local key = table.remove(args, 1)
    key = type(Commands[key]) == "function" and key or "help"
    Commands[key](SafeUnpack(args))
  end
end)

-- ============================================================================
-- Commands
-- ============================================================================

function Commands.help()
  Addon:Print(L.COMMANDS .. ":")
  print(Colors.Gold("  /lootifications"), "-", L.COMMAND_DESCRIPTION_HELP)
  print(Colors.Gold("  /lootifications max"), Colors.Yellow("<integer>"), "-", L.COMMAND_DESCRIPTION_MAX)
  print(Colors.Gold("  /lootifications money"), "-", L.COMMAND_DESCRIPTION_MONEY)
  print(Colors.Gold("  /lootifications test"), "-", L.COMMAND_DESCRIPTION_TEST)
end

function Commands.max(value)
  local success, newMax = pcall(function()
    local num = tonumber(value)
    --- @diagnostic disable-next-line: param-type-mismatch
    return num == math.floor(num) and num or error()
  end)

  if success and newMax >= Addon.MAX_NOTIFICATIONS_MIN and newMax <= Addon.MAX_NOTIFICATIONS_MAX then
    local sv = SavedVariables:Get()
    sv.maxNotifications = newMax
    Addon:Print(L.COMMAND_SUCCESS_MAX:format(newMax))
  else
    Addon:Print(L.COMMAND_EXAMPLE_USAGE .. ":")
    print(Colors.Gold("  /lootifications max"), Colors.Yellow(math.random(1, 20)))
  end
end

function Commands.money()
  local sv = SavedVariables:Get()
  sv.moneyNotifications = not sv.moneyNotifications
  local message = sv.moneyNotifications and L.MONEY_NOTIFICATIONS_ENABLED or L.MONEY_NOTIFICATIONS_DISABLED
  Addon:Print(message)
end

do -- Commands.test()
  local COLOR_CODES = {
    "FF9D9D9D",
    "FFFFFFFF",
    "FF1EFF00",
    "FF0070DD",
    "FFA335EE",
    "FFFF8000"
  }

  function Commands.test()
    local sv = SavedVariables:Get()
    for i = 1, sv.maxNotifications do
      local colorIndex = ((i - 1) % #COLOR_CODES) + 1
      local colorCode = COLOR_CODES[colorIndex]
      local text = WrapTextInColorCode(("[%s %s]"):format(ADDON_NAME, i), colorCode)
      local textureMessage = Addon.TEXTURE_MESSAGE_FORMAT:format(Addon.ICON, text)
      EventManager:Fire(E.TexturedLootMessage, textureMessage)
    end
  end
end
