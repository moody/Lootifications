local Addon = select(2, ...) ---@type Addon
local ActionCreators = Addon:GetModule("ActionCreators")
local AnchorFrame = Addon:GetModule("AnchorFrame")
local Colors = Addon:GetModule("Colors")
local ComponentFactory = Addon:GetModule("ComponentFactory")
local DefaultStates = Addon:GetModule("DefaultStates")
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
--- @param toggle WuxActionCreator<nil> Toggles the state.
local function addOptionCard(container, labelText, descriptionText, stateKey, toggle)
  addCard(container, {
    get = function() return Addon:GetState()[stateKey] end,
    set = function() Addon:GetStore():Dispatch(toggle()) end
  }, labelText, descriptionText)
end

--- Pins the anchor where it is, since its point depends on the direction and the alignment.
local function pinAnchor()
  AnchorFrame:Pin()
end

--- Adds a card with a line of chips below a divider, where exactly one is checked: the one whose value is in the
--- state. Clicking a chip selects its value, then calls `afterSelect`.
--- @param container WaffleFlexComponent
--- @param labelText string
--- @param descriptionText string
--- @param lineLabelText string Label to the left of the chips.
--- @param stateKey "anchorAlignment" | "anchorDirection" | "notificationBackground"
--- @param setValue WuxActionCreator<string> Sets the state.
--- @param choices { value: string, text: string }[]
--- @param afterSelect? fun()
local function addChoiceCard(container, labelText, descriptionText, lineLabelText, stateKey, setValue, choices,
                             afterSelect)
  local chips = {}

  for _, choice in ipairs(choices) do
    chips[#chips + 1] = {
      text = choice.text,
      get = function() return Addon:GetState()[stateKey] == choice.value end,
      set = function(checked)
        if checked then
          Addon:GetStore():Dispatch(setValue(choice.value))
          if afterSelect then afterSelect() end
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
  -- General.
  container:AttachComponent(ComponentFactory:Text({ text = L.GENERAL, fontObject = "GameFontNormalLarge" }))

  addCard(container, {
    get = function() return not Addon:GetState().minimapIcon.hide end,
    set = function(show) Addon:GetStore():Dispatch(ActionCreators.patchMinimapIcon({ hide = not show })) end
  }, L.MINIMAP_ICON_TEXT, L.MINIMAP_ICON_DESCRIPTION)

  addDivider(container)

  -- Content.
  container:AttachComponent(ComponentFactory:Text({ text = L.CONTENT, fontObject = "GameFontNormalLarge" }))

  addOptionCard(container, L.MONEY, L.MONEY_NOTIFICATIONS_DESCRIPTION, "moneyNotifications", ActionCreators.toggleMoneyNotifications)
  addOptionCard(container, L.LOOT_PRICES_TEXT, L.LOOT_PRICES_DESCRIPTION, "lootPrices", ActionCreators.toggleLootPrices)
  addOptionCard(container, L.OWNED_ITEM_COUNTS_TEXT, L.OWNED_ITEM_COUNTS_DESCRIPTION, "ownedItemCounts", ActionCreators.toggleOwnedItemCounts)

  addDivider(container)

  -- Layout.
  container:AttachComponent(ComponentFactory:Text({ text = L.LAYOUT, fontObject = "GameFontNormalLarge" }))

  addChoiceCard(container, L.DIRECTION_TEXT, L.DIRECTION_DESCRIPTION, L.GROW, "anchorDirection", ActionCreators.setAnchorDirection, {
    { value = "DOWN", text = L.DOWN },
    { value = "UP", text = L.UP }
  }, pinAnchor)

  addChoiceCard(container, L.ALIGNMENT_TEXT, L.ALIGNMENT_DESCRIPTION, L.JUSTIFY, "anchorAlignment", ActionCreators.setAnchorAlignment, {
    { value = "LEFT", text = L.LEFT },
    { value = "CENTER", text = L.CENTER },
    { value = "RIGHT", text = L.RIGHT }
  }, pinAnchor)

  addDivider(container)

  -- Style.
  container:AttachComponent(ComponentFactory:Text({ text = L.STYLE, fontObject = "GameFontNormalLarge" }))

  addChoiceCard(container, L.BACKGROUND_TEXT, L.BACKGROUND_DESCRIPTION, L.LOOK, "notificationBackground", ActionCreators.setNotificationBackground, {
    { value = "NONE", text = L.NONE },
    { value = "SUBTLE", text = L.SUBTLE },
    { value = "HIGH_CONTRAST", text = L.HIGH_CONTRAST }
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
              ActionCreators.resetLootPrices(),
              ActionCreators.resetMoneyNotifications(),
              ActionCreators.resetNotificationBackground(),
              ActionCreators.resetOwnedItemCounts(),
              ActionCreators.patchMinimapIcon({ hide = DefaultStates.Root.minimapIcon.hide })
            }
          })
          AnchorFrame:Reset()
        end
      })
    end
  })
end
