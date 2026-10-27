local Addon = select(2, ...) ---@type Addon
local ActionCreators = Addon:GetModule("ActionCreators")
local AnchorFrame = Addon:GetModule("AnchorFrame")
local Colors = Addon:GetModule("Colors")
local Commands = Addon:GetModule("Commands")
local ComponentFactory = Addon:GetModule("ComponentFactory")
local DefaultStates = Addon:GetModule("DefaultStates")
local L = Addon:GetModule("Locale")
local StateManager = Addon:GetModule("StateManager")
local Widgets = Addon:GetModule("Widgets")
local Wux = Addon.Wux

--- @class MainWindowOptions
local MainWindowOptions = Addon:GetModule("MainWindowOptions")

-- ============================================================================
-- LuaCATS Annotations
-- ============================================================================

--- @class CardOptions : OptionCardOptions
--- @field label string
--- @field description string

--- @class ToggleCardOptions
--- @field label string
--- @field description string
--- @field stateKey "bagCounts" | "itemPrices" | "money" The notifications state that the card toggles.
--- @field toggle WuxActionCreator<nil> Toggles the state.

--- @class LineCardOptions
--- @field label string
--- @field description string
--- @field lineLabel string Label to the left of the control.

--- @class ChoiceCardOptions : LineCardOptions
--- @field getValue fun(state: GlobalState): string Returns the value in the state that the chips choose.
--- @field setValue WuxActionCreator<string> Sets the state.
--- @field choices { value: string, text: string }[]
--- @field afterSelect? fun() Called after a chip is selected.

--- @class SliderCardOptions : LineCardOptions
--- @field minValue integer
--- @field maxValue integer
--- @field step integer Distance between the values the slider stops at.
--- @field getValue fun(state: GlobalState): integer Returns the value in the state that the slider sets.
--- @field setValue WuxActionCreator<integer> Sets the state.

-- ============================================================================
-- Local Functions
-- ============================================================================

--- Adds a card to the container, with a label and a description.
--- @param container WaffleFlexComponent
--- @param options CardOptions
--- @return OptionCardComponent card
local function addCard(container, options)
  --- @type OptionCardComponent
  local card = container:AttachComponent(ComponentFactory:OptionCard(options))

  card.Content:AttachComponent(ComponentFactory:Text({ text = options.label }))
  card.Content:AttachComponent(ComponentFactory:Text({
    text = options.description,
    fontObject = "GameFontNormalSmall",
    color = Colors.Grey
  }))

  return card
end

--- Adds a card that toggles an option.
--- @param container WaffleFlexComponent
--- @param options ToggleCardOptions
local function addOptionCard(container, options)
  addCard(container, {
    label = options.label,
    description = options.description,
    get = function() return StateManager:GetGlobalState().notifications[options.stateKey] end,
    set = function() StateManager:Dispatch(options.toggle()) end
  })
end

--- Pins the anchor where it is, since its point depends on the direction and the alignment.
local function pinAnchor()
  AnchorFrame:Pin()
end

--- Adds a card with a labeled line below a divider, and returns the line for its control.
--- @param container WaffleFlexComponent
--- @param options LineCardOptions
--- @return WaffleFlexComponent line
local function addLineCard(container, options)
  local card = addCard(container, { label = options.label, description = options.description })

  local divider = card.Content:AttachComponent(ComponentFactory:Divider())
  divider:SetMarginTop(Widgets:Padding(0.25))

  --- @type SettingsBoxComponent
  local box = card.Content:AttachComponent(ComponentFactory:SettingsBox())
  box:SetMarginTop(Widgets:Padding(0.25))

  return box:AddLine(options.lineLabel)
end

--- Adds a card with a slider below a divider, which sets the state while it is dragged.
--- @param container WaffleFlexComponent
--- @param options SliderCardOptions
local function addSliderCard(container, options)
  addLineCard(container, options):AttachComponent(ComponentFactory:ValueSlider({
    minValue = options.minValue,
    maxValue = options.maxValue,
    step = options.step,
    get = function() return options.getValue(StateManager:GetGlobalState()) end,
    set = function(value) StateManager:Dispatch(options.setValue(value)) end
  }))
end

--- Adds a card with a line of chips below a divider, where exactly one is checked: the one whose value is in the
--- state. Clicking a chip selects its value, then calls `afterSelect`.
--- @param container WaffleFlexComponent
--- @param options ChoiceCardOptions
local function addChoiceCard(container, options)
  local chips = {}

  for _, choice in ipairs(options.choices) do
    chips[#chips + 1] = {
      text = choice.text,
      get = function() return options.getValue(StateManager:GetGlobalState()) == choice.value end,
      set = function(checked)
        if checked then
          StateManager:Dispatch(options.setValue(choice.value))
          if options.afterSelect then options.afterSelect() end
        end
      end
    }
  end

  addLineCard(container, options):AttachComponent(ComponentFactory:CheckChipGroup({ chips = chips }))
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
  -- Notifications.
  container:AttachComponent(ComponentFactory:Text({ text = L.NOTIFICATIONS, fontObject = "GameFontNormalLarge" }))

  addOptionCard(container, {
    label = L.MONEY,
    description = L.MONEY_NOTIFICATIONS_DESCRIPTION,
    stateKey = "money",
    toggle = ActionCreators.Notifications.toggleMoney
  })

  addOptionCard(container, {
    label = L.ITEM_PRICES_TEXT,
    description = L.ITEM_PRICES_DESCRIPTION,
    stateKey = "itemPrices",
    toggle = ActionCreators.Notifications.toggleItemPrices
  })

  addOptionCard(container, {
    label = L.BAG_COUNTS_TEXT,
    description = L.BAG_COUNTS_DESCRIPTION,
    stateKey = "bagCounts",
    toggle = ActionCreators.Notifications.toggleBagCounts
  })

  addSliderCard(container, {
    label = L.TEXT_SIZE_TEXT,
    description = L.TEXT_SIZE_DESCRIPTION,
    lineLabel = L.SIZE,
    minValue = DefaultStates.NOTIFICATION_TEXT_SIZE.MIN,
    maxValue = DefaultStates.NOTIFICATION_TEXT_SIZE.MAX,
    step = DefaultStates.NOTIFICATION_TEXT_SIZE.STEP,
    getValue = function(state) return state.notifications.textSize end,
    setValue = ActionCreators.Notifications.setTextSize
  })

  addChoiceCard(container, {
    label = L.BACKGROUND_TEXT,
    description = L.BACKGROUND_DESCRIPTION,
    lineLabel = L.STYLE,
    getValue = function(state) return state.notifications.background end,
    setValue = ActionCreators.Notifications.setBackground,
    choices = {
      { value = DefaultStates.NOTIFICATION_BACKGROUNDS.NONE, text = L.NONE },
      { value = DefaultStates.NOTIFICATION_BACKGROUNDS.SUBTLE, text = L.SUBTLE },
      { value = DefaultStates.NOTIFICATION_BACKGROUNDS.HIGH_CONTRAST, text = L.HIGH_CONTRAST }
    }
  })

  addDivider(container)

  -- Anchor.
  container:AttachComponent(ComponentFactory:Text({ text = L.ANCHOR, fontObject = "GameFontNormalLarge" }))

  addChoiceCard(container, {
    label = L.DIRECTION_TEXT,
    description = L.DIRECTION_DESCRIPTION,
    lineLabel = L.GROW,
    getValue = function(state) return state.anchorFrame.direction end,
    setValue = ActionCreators.AnchorFrame.setDirection,
    choices = {
      { value = DefaultStates.ANCHOR_DIRECTIONS.DOWN, text = L.DOWN },
      { value = DefaultStates.ANCHOR_DIRECTIONS.UP, text = L.UP }
    },
    afterSelect = pinAnchor
  })

  addChoiceCard(container, {
    label = L.ALIGNMENT_TEXT,
    description = L.ALIGNMENT_DESCRIPTION,
    lineLabel = L.JUSTIFY,
    getValue = function(state) return state.anchorFrame.alignment end,
    setValue = ActionCreators.AnchorFrame.setAlignment,
    choices = {
      { value = DefaultStates.ANCHOR_ALIGNMENTS.LEFT, text = L.LEFT },
      { value = DefaultStates.ANCHOR_ALIGNMENTS.CENTER, text = L.CENTER },
      { value = DefaultStates.ANCHOR_ALIGNMENTS.RIGHT, text = L.RIGHT }
    },
    afterSelect = pinAnchor
  })

  addDivider(container)

  -- General.
  container:AttachComponent(ComponentFactory:Text({ text = L.GENERAL, fontObject = "GameFontNormalLarge" }))

  addCard(container, {
    label = L.MINIMAP_ICON_TEXT,
    description = L.MINIMAP_ICON_DESCRIPTION:format(Colors.Gold(Commands.SLASH_COMMAND)),
    get = function() return not StateManager:GetGlobalState().minimapIcon.hide end,
    set = function(show) StateManager:Dispatch(ActionCreators.MinimapIcon.patch({ hide = not show })) end
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
          StateManager:Dispatch({
            type = Wux.ActionTypes.Batch,
            payload = {
              ActionCreators.Notifications.resetBagCounts(),
              ActionCreators.Notifications.resetItemPrices(),
              ActionCreators.Notifications.resetMoney(),
              ActionCreators.Notifications.resetTextSize(),
              ActionCreators.Notifications.resetBackground(),
              ActionCreators.MinimapIcon.patch({ hide = DefaultStates.Global.minimapIcon.hide })
            }
          })
          AnchorFrame:Reset()
        end
      })
    end
  })
end
