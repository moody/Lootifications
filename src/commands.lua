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
  Addon:Print(Colors.Gold("  /lootifications"), "-", L.COMMAND_DESCRIPTION_HELP)
  Addon:Print(Colors.Gold("  /lootifications money"), "-", L.COMMAND_DESCRIPTION_MONEY)
  Addon:Print(Colors.Gold("  /lootifications test"), "-", L.COMMAND_DESCRIPTION_TEST)
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
    for i, colorCode in ipairs(COLOR_CODES) do
      local text = WrapTextInColorCode(("[%s %s]"):format(ADDON_NAME, i), colorCode)
      local textureMessage = Addon.TEXTURE_MESSAGE_FORMAT:format(Addon.ICON, text)
      EventManager:Fire(E.TexturedLootMessage, textureMessage)
    end

    EventManager:Fire(E.MoneyReceived, 42069)
  end
end
