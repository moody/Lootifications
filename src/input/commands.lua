local Addon = select(2, ...) ---@type Addon
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local MainWindow = Addon:GetModule("MainWindow")

--- @class Commands
local Commands = Addon:GetModule("Commands")

-- ============================================================================
-- Events
-- ============================================================================

-- Register the `/lootifications` slash command on login.
EventManager:Once(E.Wow.PlayerLogin, function()
  SLASH_LOOTIFICATIONS1 = "/lootifications"
  SLASH_LOOTIFICATIONS2 = "/lootif"
  SlashCmdList.LOOTIFICATIONS = function()
    Commands.options()
  end
end)

-- ============================================================================
-- Commands
-- ============================================================================

--- Toggles the `MainWindow`.
function Commands.options()
  MainWindow:Toggle()
end
