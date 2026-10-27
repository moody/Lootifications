local Addon = select(2, ...) ---@type Addon
local Colors = Addon:GetModule("Colors")
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local L = Addon:GetModule("Locale")
local MainWindow = Addon:GetModule("MainWindow")

--- @class Commands
local Commands = Addon:GetModule("Commands")

Commands.SLASH_COMMAND = "/lootif"

-- ============================================================================
-- Events
-- ============================================================================

-- Register the `/lootif` slash command, and `/lootifications` as its long form, on login.
EventManager:Once(E.Wow.PlayerLogin, function()
  SLASH_LOOTIFICATIONS1 = Commands.SLASH_COMMAND
  SLASH_LOOTIFICATIONS2 = "/lootifications"
  SlashCmdList.LOOTIFICATIONS = function(msg)
    -- Split message into args.
    local args = {}
    for arg in strlower(msg or ""):gmatch("%S+") do args[#args + 1] = arg end

    -- First arg is command name.
    local key = table.remove(args, 1) or "options"
    key = type(Commands[key]) == "function" and key or "help"
    Commands[key](SafeUnpack(args))
  end
end)

-- ============================================================================
-- Local Functions
-- ============================================================================

--- Prints a `/lootif <suffix>` line followed by its description.
--- @param suffix string
--- @param description string
local function printCommand(suffix, description)
  local cmd = suffix ~= "" and (Commands.SLASH_COMMAND .. " " .. suffix) or Commands.SLASH_COMMAND
  Addon:Print(Colors.Gold("  " .. cmd), Colors.Grey("-"), description)
end

-- ============================================================================
-- Commands
-- ============================================================================

--- Prints a list of commands.
function Commands.help()
  Addon:Print(L.COMMANDS .. ":")
  printCommand("", L.COMMAND_DESCRIPTION_OPTIONS)
  printCommand("help", L.COMMAND_DESCRIPTION_HELP)
end

--- Toggles the `MainWindow`.
function Commands.options()
  MainWindow:Toggle()
end
