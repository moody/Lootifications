local ADDON_NAME = ... ---@type string
local Addon = select(2, ...) ---@type Addon
local MainWindow = Addon:GetModule("MainWindow")

if AddonCompartmentFrame then
  AddonCompartmentFrame:RegisterAddon({
    text = ADDON_NAME,
    icon = Addon:GetAsset("icon"),
    notCheckable = true,
    func = function() MainWindow:Toggle() end
  })
end
