local Addon = select(2, ...) ---@type Addon
local Colors = Addon:GetModule("Colors")
local ComponentFactory = Addon:GetModule("ComponentFactory")
local L = Addon:GetModule("Locale")

--- @class MainWindowOptions
local MainWindowOptions = Addon:GetModule("MainWindowOptions")

-- ============================================================================
-- Local Functions
-- ============================================================================

--- Adds an option card with a label and a description to the container.
--- @param container WaffleFlexComponent
--- @param labelText string
--- @param descriptionText string
--- @param stateKey "lootPrices" | "moneyNotifications" | "ownedItemCounts" The state that the card toggles.
local function addOptionCard(container, labelText, descriptionText, stateKey)
  local card = container:AttachComponent(ComponentFactory:OptionCard({
    get = function() return Addon:GetState()[stateKey] end,
    set = function() Addon:GetStore():Dispatch({ type = stateKey .. "/toggle" }) end
  })) --[[@as OptionCardComponent]]

  card.Content:AttachComponent(ComponentFactory:Text({ text = labelText }))
  card.Content:AttachComponent(ComponentFactory:Text({
    text = descriptionText,
    fontObject = "GameFontNormalSmall",
    color = Colors.Grey
  }))
end

-- ============================================================================
-- MainWindowOptions
-- ============================================================================

--- Adds the options to the container.
--- @param container WaffleFlexComponent
function MainWindowOptions:Initialize(container)
  addOptionCard(container, L.MONEY_NOTIFICATIONS_TEXT, L.MONEY_NOTIFICATIONS_TOOLTIP, "moneyNotifications")
  addOptionCard(container, L.LOOT_PRICES_TEXT, L.LOOT_PRICES_TOOLTIP, "lootPrices")
  addOptionCard(container, L.OWNED_ITEM_COUNTS_TEXT, L.OWNED_ITEM_COUNTS_TOOLTIP, "ownedItemCounts")
end
