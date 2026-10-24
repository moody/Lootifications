local Addon = select(2, ...) ---@type Addon
local AnchorFrame = Addon:GetModule("AnchorFrame")
local Colors = Addon:GetModule("Colors")
local ComponentFactory = Addon:GetModule("ComponentFactory")
local L = Addon:GetModule("Locale")
local Widgets = Addon:GetModule("Widgets")
local Wux = Addon.Wux

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

--- Adds a divider with space around it to the container.
--- @param container WaffleFlexComponent
local function addDivider(container)
  local divider = container:AttachComponent(ComponentFactory:Divider())
  divider:SetMarginTop(Widgets:Padding(0.5))
  divider:SetMarginBottom(Widgets:Padding(0.5))
end

-- ============================================================================
-- MainWindowOptions
-- ============================================================================

--- Adds the options to the container.
--- @param container WaffleFlexComponent
function MainWindowOptions:Initialize(container)
  container:AttachComponent(ComponentFactory:Text({ text = L.NOTIFICATIONS, fontObject = "GameFontNormalLarge" }))

  addOptionCard(container, L.MONEY, L.MONEY_NOTIFICATIONS_DESCRIPTION, "moneyNotifications")
  addOptionCard(container, L.LOOT_PRICES_TEXT, L.LOOT_PRICES_DESCRIPTION, "lootPrices")
  addOptionCard(container, L.OWNED_ITEM_COUNTS_TEXT, L.OWNED_ITEM_COUNTS_DESCRIPTION, "ownedItemCounts")

  addDivider(container)
  container:AttachComponent(ComponentFactory:Text({ text = L.LAYOUT, fontObject = "GameFontNormalLarge" }))

  addChoiceCard(container, L.DIRECTION_TEXT, L.DIRECTION_DESCRIPTION, L.GROW, "anchorDirection", {
    { value = "DOWN", text = L.DOWN },
    { value = "UP", text = L.UP }
  })
  addChoiceCard(container, L.ALIGNMENT_TEXT, L.ALIGNMENT_DESCRIPTION, L.JUSTIFY, "anchorAlignment", {
    { value = "LEFT", text = L.LEFT },
    { value = "CENTER", text = L.CENTER },
    { value = "RIGHT", text = L.RIGHT }
  })

  addDivider(container)

  -- Resets every option and the anchor's position.
  container:AddChild({
    height = 30,
    frameFactory = function()
      return Widgets:Button({
        name = "$parent_ResetToDefaultsButton",
        labelText = L.RESET_TO_DEFAULTS,
        labelColor = Colors.Red,
        onClick = function()
          Addon:GetStore():Dispatch({
            type = Wux.ActionTypes.Batch,
            payload = {
              { type = "lootPrices/reset" },
              { type = "moneyNotifications/reset" },
              { type = "ownedItemCounts/reset" }
            }
          })
          AnchorFrame:Reset()
        end
      })
    end
  })
end
