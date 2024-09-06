local ADDON_NAME = ... ---@type string
local Addon = select(2, ...) ---@type Addon
local AnchorFrame = Addon:GetModule("AnchorFrame")
local Colors = Addon:GetModule("Colors")
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local L = Addon:GetModule("Locale")
local MainWindow = Addon:GetModule("MainWindow")
local NotificationManager = Addon:GetModule("NotificationManager")

--- @class Commands
local Commands = Addon:GetModule("Commands")

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
    local key = table.remove(args, 1) or "options"
    key = type(Commands[key]) == "function" and key or "help"
    Commands[key](SafeUnpack(args))
  end
end)

-- ============================================================================
-- Commands
-- ============================================================================

--- Toggles the `MainWindow`.
function Commands.options()
  MainWindow:Toggle()
end

--- Prints a list of commands.
function Commands.help()
  Addon:Print("|", Addon.VERSION)
  print(Colors.Gold("  /lootifications"), "-", L.COMMAND_DESCRIPTION_OPTIONS)
  print(Colors.Gold("  /lootifications help"), "-", L.COMMAND_DESCRIPTION_HELP)
  print(Colors.Gold("  /lootifications anchor"), "-", L.COMMAND_DESCRIPTION_ANCHOR)
  print(Colors.Gold("  /lootifications anchor reset"), "-", L.COMMAND_DESCRIPTION_ANCHOR_RESET)
  print(Colors.Gold("  /lootifications test"), "-", L.COMMAND_DESCRIPTION_TEST)
end

function Commands.anchor(subcommand)
  if subcommand == "reset" then
    AnchorFrame:Reset()
    Addon:Print(L.COMMAND_SUCCESS_ANCHOR_RESET)
  else
    AnchorFrame:Toggle()
  end
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
    local state = Addon:GetState()
    for i = 1, state.maxNotifications do
      local colorIndex = ((i - 1) % #COLOR_CODES) + 1
      local colorCode = COLOR_CODES[colorIndex]
      local text = WrapTextInColorCode(("[%s %s]"):format(ADDON_NAME, i), colorCode)
      NotificationManager:NotifyWithIcon(Addon.ICON, text)
    end
  end
end
