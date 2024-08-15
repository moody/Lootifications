local Addon = select(2, ...) ---@type Addon
local Colors = Addon:GetModule("Colors") ---@type Colors
local L = Addon:GetModule("Locale") ---@type Locale

--- @class MainWindowOptions
local MainWindowOptions = Addon:GetModule("MainWindowOptions")

--- Initializes options for the given `optionsFrame`.
--- @param optionsFrame OptionsFrameWidget
function MainWindowOptions:Initialize(optionsFrame)
  -- ============================================================================
  -- General
  -- ============================================================================

  -- General heading.
  optionsFrame:AddOptionHeading({ headingText = L.GENERAL })

  -- Money notifications.
  optionsFrame:AddOptionButton({
    labelText = L.MONEY_NOTIFICATIONS_TEXT,
    tooltipText = L.MONEY_NOTIFICATIONS_TOOLTIP,
    get = function() return Addon:GetState().moneyNotifications end,
    set = function(value) Addon:GetStore():Dispatch({ type = "moneyNotifications/toggle" }) end
  })
end
