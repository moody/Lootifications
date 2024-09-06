local Addon = select(2, ...) ---@type Addon
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local MainWindow = Addon:GetModule("MainWindow")

EventManager:Once(E.Wow.PlayerLogin, function()
  SLASH_LOOTIFICATIONS1 = "/lootifications"
  SlashCmdList.LOOTIFICATIONS = function()
    MainWindow:Toggle()
  end
end)
