local ADDON_NAME = ... ---@type string
local Addon = select(2, ...) ---@type Addon
local ActionCreators = Addon:GetModule("ActionCreators")
local AnchorFrame = Addon:GetModule("AnchorFrame")
local Colors = Addon:GetModule("Colors")
local ComponentFactory = Addon:GetModule("ComponentFactory")
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local GetCoinTextureString = C_CurrencyInfo.GetCoinTextureString or GetCoinTextureString
local HistoryLog = Addon:GetModule("HistoryLog")
local ItemLogger = Addon:GetModule("ItemLogger")
local L = Addon:GetModule("Locale")
local MainWindowOptions = Addon:GetModule("MainWindowOptions")
local MoneyLogger = Addon:GetModule("MoneyLogger")
local Widgets = Addon:GetModule("Widgets")

--- @class MainWindow
local MainWindow = Addon:GetModule("MainWindow")

local Components = {}

-- ============================================================================
-- Controller
-- ============================================================================

--- @alias MainWindowTabKey "LOG" | "SETTINGS"

--- @class MainWindowTabOptions
--- @field key MainWindowTabKey
--- @field labelText string Text of the tab.
--- @field createScreen fun(screen: WaffleFlexComponent) Fills the screen the tab shows.

local Controller = {
  --- Tabs and the screens they show.
  --- @type table<MainWindowTabKey, { tab: TabComponent, screen: WaffleFlexComponent }>
  tabs = {},

  --- Key of the selected tab.
  --- @type MainWindowTabKey?
  selectedTabKey = nil
}

--- Adds a tab that shows a screen. The screen is created hidden and filled by `options.createScreen`.
--- @param options MainWindowTabOptions
function Controller:AddTab(options)
  local screen = Components.ScreenArea:AddColumn({ gap = Widgets:Padding(0.5), visibility = "GONE" })
  options.createScreen(screen)

  self.tabs[options.key] = {
    screen = screen,
    tab = Components.TabRow:AttachComponent(ComponentFactory:Tab({
      labelText = options.labelText,
      onClick = function() self:SelectTab(options.key) end
    })) --[[@as TabComponent]]
  }
end

--- Selects the tab and shows its screen, hiding the previous one. The anchor is unlocked while the settings are shown.
--- @param key MainWindowTabKey
function Controller:SelectTab(key)
  if key == self.selectedTabKey then return end

  local previous = self.tabs[self.selectedTabKey]
  if previous then
    previous.tab:SetSelected(false)
    previous.screen:SetVisibility("GONE")
  end

  self.tabs[key].tab:SetSelected(true)
  self.tabs[key].screen:SetVisibility("VISIBLE")
  self.selectedTabKey = key

  if Components.Root:IsVisible() then
    if key == "SETTINGS" then
      AnchorFrame:Unlock()
    else
      AnchorFrame:Lock()
    end
  end
end

--- Shows every screen once so its frames are built now, then returns to the log.
function Controller:PreloadScreens()
  for key in pairs(self.tabs) do
    self:SelectTab(key)
    Components.Root:Layout()
  end

  self:SelectTab("LOG")
end

-- ============================================================================
-- Root Component
-- ============================================================================

Components.Root = ComponentFactory:Window({
  name = "MainWindow",
  width = 425,
  height = 465,
  titleText = "", -- unused; MainWindow builds its own title-bar content below
  getPoint = function() return Addon:GetState().mainWindowPoint end,
  setPoint = function(point) Addon:GetStore():Dispatch(ActionCreators.setMainWindowPoint(point)) end,
  onResetPoint = function() Addon:GetStore():Dispatch(ActionCreators.resetMainWindowPoint()) end,
  refresh = function() Components.Root:Layout() end
})

-- The anchor is locked while the window is hidden, and unlocked while it shows the settings.
Components.Root:WhenFrameReady(function(frame)
  frame:HookScript("OnShow", function()
    if Controller.selectedTabKey == "SETTINGS" then AnchorFrame:Unlock() end
  end)
  frame:HookScript("OnHide", function() AnchorFrame:Lock() end)
end)

-- Window()'s generic title text goes unused in favor of the title bar below.
Components.Root.TitleText:Detach()
Components.Root.TitleText = nil

-- ============================================================================
-- Title Bar Components
-- ============================================================================

Components.TitleBarNameText = Components.Root.TitleRow:AddRow()
Components.TitleBarNameText:AddChild({
  --- @param parent Frame
  frameFactory = function(parent)
    local fontString = parent:CreateFontString("$parent_TitleText", "ARTWORK", "GameFontNormalLarge")
    fontString:SetJustifyH("LEFT")
    fontString:SetText(Colors.Purple(ADDON_NAME))
    return fontString
  end
})

Components.TitleBarVersionText = Components.Root.TitleRow:AddRow({ justify = "CENTER" })
Components.TitleBarVersionText:AddChild({
  --- @param parent Frame
  frameFactory = function(parent)
    local fontString = parent:CreateFontString("$parent_VersionText", "ARTWORK", "GameFontNormalSmall")
    fontString:SetText(Colors.Grey(Addon.VERSION))
    return fontString
  end
})

Components.TitleBarButtonsRow = Components.Root.TitleRow:AddRow({ justify = "END" })

-- Reuse Window()'s close button, just moved into this row.
Components.TitleBarButtonsRow:AttachComponent(Components.Root.CloseButton:Detach())

-- ============================================================================
-- Content Components
-- ============================================================================

Components.Content = Components.Root:AddChild({
  direction = "COLUMN",
  padding = Widgets:Padding(),
  gap = Widgets:Padding(0.25)
})

-- Tabs, with no gap so their underlines form one line.
Components.TabRow = Components.Content:AddRow({ height = "AUTO" })

-- Screen area: shows the screen of the selected tab.
Components.ScreenArea = Components.Content:AddRow()

-- ============================================================================
-- Log Totals
-- ============================================================================

--- Shows the items and money looted this session in the totals of the log.
local function refreshLogTotals()
  Components.TotalItemsText:SetText(L.TOTAL_ITEMS:format(Colors.White(tostring(ItemLogger:GetTotal()))))
  Components.TotalMoneyText:SetText(L.TOTAL_MONEY:format(Colors.White(GetCoinTextureString(MoneyLogger:GetTotal()))))
end

EventManager:On(E.HistoryLogged, refreshLogTotals)
EventManager:On(E.HistoryCleared, refreshLogTotals)

-- ============================================================================
-- Tabs and Screens
-- ============================================================================

Controller:AddTab({
  key = "LOG",
  labelText = L.LOG,
  createScreen = function(screen)
    -- Holds the loot log and its totals, with the default backdrop and border around them.
    Components.LogPanel = screen:AddChild({
      direction = "COLUMN",
      padding = 1,

      --- @param parent Frame
      frameFactory = function(parent)
        return Widgets:Frame({ parent = parent })
      end
    })

    Components.LogPanel:AddColumn({ padding = Widgets:Padding() }):AttachComponent(ComponentFactory:LogList())

    -- Totals of the log, with a card-like fill and a line above it.
    local totals = Components.LogPanel:AddRow({
      height = "AUTO",
      padding = Widgets:Padding(),

      --- @param parent Frame
      frameFactory = function(parent)
        local frame = Widgets:Frame({ parent = parent, backdrop = false })

        local fill = frame:CreateTexture("$parent_Fill", "BACKGROUND")
        fill:SetAllPoints()
        fill:SetColorTexture(Colors.White:GetRGBA(0.03))

        local line = frame:CreateTexture("$parent_Line", "ARTWORK")
        line:SetHeight(1)
        line:SetPoint("TOPLEFT")
        line:SetPoint("TOPRIGHT")
        line:SetColorTexture(Colors.Black:GetRGBA(1))

        return frame
      end
    })

    Components.TotalItemsText = totals:AttachComponent(ComponentFactory:Text({ color = Colors.Grey, wordWrap = false })) --[[@as TextComponent]]
    Components.TotalMoneyText = totals:AttachComponent(ComponentFactory:Text({ color = Colors.Grey, wordWrap = false, justifyH = "RIGHT" })) --[[@as TextComponent]]
    refreshLogTotals()

    -- Wipes the log. Disabled while it is empty.
    screen:AddChild({
      height = 30,

      --- @param parent Frame
      frameFactory = function(parent)
        local button = Widgets:Button({
          parent = parent,
          labelText = L.CLEAR_LOG,
          labelColor = Colors.Red,
          onClick = function() HistoryLog:Clear() end
        })

        --- Enables the button while the log has entries.
        local function refresh()
          button:FireEvent("ENABLED", #HistoryLog:GetEntries() > 0)
        end

        EventManager:On(E.HistoryLogged, refresh)
        EventManager:On(E.HistoryCleared, refresh)
        refresh()

        return button
      end
    })
  end
})

Controller:AddTab({
  key = "SETTINGS",
  labelText = L.SETTINGS,
  createScreen = function(screen)
    -- Holds the scroll panel, with the default backdrop and border around it.
    Components.OptionsPanel = screen:AddChild({
      direction = "COLUMN",
      padding = Widgets:Padding(),

      --- @param parent Frame
      frameFactory = function(parent)
        return Widgets:Frame({ parent = parent })
      end
    })

    Components.ScrollPanel = Components.OptionsPanel:AttachComponent(ComponentFactory:ScrollPanel()) --[[@as ScrollPanelComponent]]
    Components.ScrollPanel.ScrollChild:SetGap(Widgets:Padding(0.5))

    MainWindowOptions:Initialize(Components.ScrollPanel.ScrollChild)

    -- Points to the `test` command.
    Components.TestHint = screen:AttachComponent(ComponentFactory:Text({
      text = L.TEST_NOTIFICATIONS_HINT:format(Colors.White("/lootif test")),
      color = Colors.Grey,
      justifyH = "CENTER"
    }))
    Components.TestHint:SetMarginTop(Widgets:Padding(0.25))
  end
})

-- ============================================================================
-- MainWindow
-- ============================================================================

--- Shows the main window, on the tab if one is given.
--- @param tabKey? MainWindowTabKey
function MainWindow:Show(tabKey)
  if tabKey then Controller:SelectTab(tabKey) end

  Components.Root:SetVisibility("VISIBLE")
  Components.Root:Layout()
end

--- Hides the main window.
function MainWindow:Hide()
  Components.Root:SetVisibility("GONE")
  Components.Root:Layout()
end

--- Hides the main window if it is shown, on the tab if one is given. Otherwise shows it, on that tab.
--- @param tabKey? MainWindowTabKey
function MainWindow:Toggle(tabKey)
  if Components.Root:IsVisible() and (not tabKey or tabKey == Controller.selectedTabKey) then
    self:Hide()
  else
    self:Show(tabKey)
  end
end

-- ============================================================================
-- Events
-- ============================================================================

-- Some elements of the UI do not appear correctly without an initial load, so we force one here once the store is
-- ready.
EventManager:Once(E.StoreInitialized, function()
  MainWindow:Show()
  Controller:PreloadScreens()
  MainWindow:Hide()
end)
