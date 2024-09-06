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
  optionsFrame:AddChild(Widgets:OptionHeading({ headingText = L.GENERAL }))

  -- Loot prices.
  optionsFrame:AddChild(Widgets:OptionButton({
    labelText = L.LOOT_PRICES_TEXT,
    tooltipText = L.LOOT_PRICES_TOOLTIP,
    get = function() return Addon:GetState().lootPrices end,
    set = function() Addon:GetStore():Dispatch({ type = "lootPrices/toggle" }) end
  }))

  -- Money notifications.
  optionsFrame:AddChild(Widgets:OptionButton({
    labelText = L.MONEY_NOTIFICATIONS_TEXT,
    tooltipText = L.MONEY_NOTIFICATIONS_TOOLTIP,
    get = function() return Addon:GetState().moneyNotifications end,
    set = function() Addon:GetStore():Dispatch({ type = "moneyNotifications/toggle" }) end
  }))

  -- Owned item counts.
  optionsFrame:AddChild(Widgets:OptionButton({
    labelText = L.OWNED_ITEM_COUNTS_TEXT,
    tooltipText = L.OWNED_ITEM_COUNTS_TOOLTIP,
    get = function() return Addon:GetState().ownedItemCounts end,
    set = function() Addon:GetStore():Dispatch({ type = "ownedItemCounts/toggle" }) end
  }))

  -- Notification alpha.
  optionsFrame:AddChild(Widgets:OptionSlider({
    labelText = L.NOTIFICATION_ALPHA_TEXT,
    tooltipText = L.NOTIFICATION_ALPHA_TOOLTIP,
    minValue = Addon.NOTIFICATION_ALPHA_MIN,
    maxValue = Addon.NOTIFICATION_ALPHA_MAX,
    valueStep = 5,
    get = function() return Addon:GetState().notificationAlpha end,
    set = function(value) Addon:GetStore():Dispatch({ type = "notificationAlpha/set", payload = value }) end
  }))

  -- Notification fade out delay.
  optionsFrame:AddChild(Widgets:OptionSlider({
    labelText = L.NOTIFICATION_FADE_OUT_DELAY_TEXT,
    tooltipText = L.NOTIFICATION_FADE_OUT_DELAY_TOOLTIP,
    minValue = Addon.NOTIFICATION_FADE_OUT_DELAY_MIN,
    maxValue = Addon.NOTIFICATION_FADE_OUT_DELAY_MAX,
    get = function() return Addon:GetState().notificationFadeOutDelay end,
    set = function(value) Addon:GetStore():Dispatch({ type = "notificationFadeOutDelay/set", payload = value }) end
  }))

  -- Max notifications.
  optionsFrame:AddChild(Widgets:OptionSlider({
    labelText = L.MAX_NOTIFICATIONS_TEXT,
    tooltipText = L.MAX_NOTIFICATIONS_TOOLTIP,
    minValue = Addon.MAX_NOTIFICATIONS_MIN,
    maxValue = Addon.MAX_NOTIFICATIONS_MAX,
    get = function() return Addon:GetState().maxNotifications end,
    set = function(value) Addon:GetStore():Dispatch({ type = "maxNotifications/set", payload = value }) end
  }))

  -- Notification spacing.
  optionsFrame:AddChild(Widgets:OptionSlider({
    labelText = L.NOTIFICATION_SPACING_TEXT,
    tooltipText = L.NOTIFICATION_SPACING_TOOLTIP,
    minValue = Addon.NOTIFICATION_SPACING_MIN,
    maxValue = Addon.NOTIFICATION_SPACING_MAX,
    valueStep = 4,
    get = function() return Addon:GetState().notificationSpacing end,
    set = function(value) Addon:GetStore():Dispatch({ type = "notificationSpacing/set", payload = value }) end
  }))
end
