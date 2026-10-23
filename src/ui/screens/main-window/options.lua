local Addon = select(2, ...) ---@type Addon
local L = Addon:GetModule("Locale") ---@type Locale
local Widgets = Addon:GetModule("Widgets") ---@type Widgets

--- @class MainWindowOptions
local MainWindowOptions = Addon:GetModule("MainWindowOptions")

--- Initializes options for the given `optionsFrame`.
--- @param optionsFrame OptionsFrameWidget
function MainWindowOptions:Initialize(optionsFrame)
  -- ============================================================================
  -- General
  -- ============================================================================

  -- General heading.
  -- optionsFrame:AddChild(Widgets:OptionHeading({ headingText = L.GENERAL }))

  -- Money notifications.
  optionsFrame:AddChild(Widgets:OptionButton({
    labelText = L.MONEY_NOTIFICATIONS_TEXT,
    tooltipText = L.MONEY_NOTIFICATIONS_TOOLTIP,
    get = function() return Addon:GetState().moneyNotifications end,
    set = function() Addon:GetStore():Dispatch({ type = "moneyNotifications/toggle" }) end
  }))

  -- Loot prices.
  optionsFrame:AddChild(Widgets:OptionButton({
    labelText = L.LOOT_PRICES_TEXT,
    tooltipText = L.LOOT_PRICES_TOOLTIP,
    get = function() return Addon:GetState().lootPrices end,
    set = function() Addon:GetStore():Dispatch({ type = "lootPrices/toggle" }) end
  }))

  -- Owned item counts.
  optionsFrame:AddChild(Widgets:OptionButton({
    labelText = L.OWNED_ITEM_COUNTS_TEXT,
    tooltipText = L.OWNED_ITEM_COUNTS_TOOLTIP,
    get = function() return Addon:GetState().ownedItemCounts end,
    set = function() Addon:GetStore():Dispatch({ type = "ownedItemCounts/toggle" }) end
  }))
end
