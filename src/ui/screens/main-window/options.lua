local Addon = select(2, ...) ---@type Addon
local AnchorFrame = Addon:GetModule("AnchorFrame")
local Colors = Addon:GetModule("Colors")
local ComponentFactory = Addon:GetModule("ComponentFactory")
local L = Addon:GetModule("Locale")
local Widgets = Addon:GetModule("Widgets")

--- @class MainWindowOptions
local MainWindowOptions = Addon:GetModule("MainWindowOptions")

-- ============================================================================
-- Local Functions
-- ============================================================================

--- Adds a card to the container, with a label and a description.
--- @param container WaffleFlexComponent
--- @param options OptionCardOptions
--- @param labelText string
--- @param descriptionText string
--- @return OptionCardComponent card
local function addCard(container, options, labelText, descriptionText)
  local card = container:AttachComponent(ComponentFactory:OptionCard(options)) --[[@as OptionCardComponent]]

  card.Content:AttachComponent(ComponentFactory:Text({ text = labelText }))
  card.Content:AttachComponent(ComponentFactory:Text({
    text = descriptionText,
    fontObject = "GameFontNormalSmall",
    color = Colors.Grey
  }))

  return card
end

--- Adds a card that toggles an option.
--- @param container WaffleFlexComponent
--- @param labelText string
--- @param descriptionText string
--- @param stateKey "lootPrices" | "moneyNotifications" | "ownedItemCounts" The state that the card toggles.
local function addOptionCard(container, labelText, descriptionText, stateKey)
  addCard(container, {
    get = function() return Addon:GetState()[stateKey] end,
    set = function() Addon:GetStore():Dispatch({ type = stateKey .. "/toggle" }) end
  }, labelText, descriptionText)
end

--- Adds a card with a line of chips below a divider, where exactly one is checked: the one whose value is in the
--- state. Clicking a chip selects its value, and pins the anchor where it is, since its point depends on the choice.
--- @param container WaffleFlexComponent
--- @param labelText string
--- @param descriptionText string
--- @param lineLabelText string Label to the left of the chips.
--- @param stateKey "anchorAlignment" | "anchorDirection"
--- @param choices { value: string, text: string }[]
local function addChoiceCard(container, labelText, descriptionText, lineLabelText, stateKey, choices)
  local chips = {}

  for _, choice in ipairs(choices) do
    chips[#chips + 1] = {
      text = choice.text,
      get = function() return Addon:GetState()[stateKey] == choice.value end,
      set = function(checked)
        if checked then
          Addon:GetStore():Dispatch({ type = stateKey .. "/set", payload = choice.value })
          AnchorFrame:Pin()
        end
      end
    }
  end

  local card = addCard(container, {}, labelText, descriptionText)

  local divider = card.Content:AttachComponent(ComponentFactory:Divider())
  divider:SetMarginTop(Widgets:Padding(0.25))

  local box = card.Content:AttachComponent(ComponentFactory:SettingsBox()) --[[@as SettingsBoxComponent]]
  box:SetMarginTop(Widgets:Padding(0.25))
  box:AddLine(lineLabelText):AttachComponent(ComponentFactory:CheckChipGroup({ chips = chips }))
end

-- ============================================================================
-- MainWindowOptions
-- ============================================================================

--- Adds the options to the container.
--- @param container WaffleFlexComponent
function MainWindowOptions:Initialize(container)
  addOptionCard(container, L.MONEY_NOTIFICATIONS_TEXT, L.MONEY_NOTIFICATIONS_DESCRIPTION, "moneyNotifications")
  addOptionCard(container, L.LOOT_PRICES_TEXT, L.LOOT_PRICES_DESCRIPTION, "lootPrices")
  addOptionCard(container, L.OWNED_ITEM_COUNTS_TEXT, L.OWNED_ITEM_COUNTS_DESCRIPTION, "ownedItemCounts")

  addChoiceCard(container, L.GROWTH_DIRECTION_TEXT, L.GROWTH_DIRECTION_DESCRIPTION, L.DIRECTION, "anchorDirection", {
    { value = "DOWN", text = L.DOWN },
    { value = "UP", text = L.UP }
  })
  addChoiceCard(container, L.ALIGNMENT_TEXT, L.ALIGNMENT_DESCRIPTION, L.ALIGNMENT_TEXT, "anchorAlignment", {
    { value = "LEFT", text = L.LEFT },
    { value = "CENTER", text = L.CENTER },
    { value = "RIGHT", text = L.RIGHT }
  })
end
