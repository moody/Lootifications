local ADDON_NAME = ... ---@type string
local Addon = select(2, ...) ---@type Addon
local AnchorFrame = Addon:GetModule("AnchorFrame")
local Colors = Addon:GetModule("Colors")
local ComponentFactory = Addon:GetModule("ComponentFactory")
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local L = Addon:GetModule("Locale")
local MainWindowOptions = Addon:GetModule("MainWindowOptions")
local Widgets = Addon:GetModule("Widgets")
local Wux = Addon.Wux

--- @class MainWindow
local MainWindow = Addon:GetModule("MainWindow")

local Components = {}

-- ============================================================================
-- Root Component
-- ============================================================================

Components.Root = ComponentFactory:Window({
  name = "MainWindow",
  width = 475,
  height = 380,
  titleText = "" -- unused; MainWindow builds its own title-bar content below
})

-- The anchor is unlocked while the window is shown.
Components.Root:WhenFrameReady(function(frame)
  frame:HookScript("OnShow", function() AnchorFrame:Unlock() end)
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
  gap = Widgets:Padding(0.5)
})

-- Holds the scroll panel, with the default backdrop and border around it.
Components.OptionsPanel = Components.Content:AddChild({
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

-- Resets every option and the anchor's position.
Components.ResetButton = Components.Content:AddChild({
  height = 30,
  frameFactory = function()
    return Widgets:Button({
      name = "$parent_ResetToDefaultsButton",
      labelText = L.RESET_TO_DEFAULTS,
      labelColor = Colors.Yellow,
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

-- ============================================================================
-- MainWindow
-- ============================================================================

--- Shows the main window.
function MainWindow:Show()
  Components.Root:SetVisibility("VISIBLE")
  Components.Root:Layout()
end

--- Hides the main window.
function MainWindow:Hide()
  Components.Root:SetVisibility("GONE")
  Components.Root:Layout()
end

--- Shows the main window if it is hidden, and hides it if it is shown.
function MainWindow:Toggle()
  if Components.Root:IsVisible() then
    self:Hide()
  else
    self:Show()
  end
end

-- ============================================================================
-- Events
-- ============================================================================

-- Some elements of the UI do not appear correctly without an initial load, so we force one here once the store is
-- ready.
EventManager:Once(E.StoreInitialized, function()
  MainWindow:Show()
  MainWindow:Hide()
end)
