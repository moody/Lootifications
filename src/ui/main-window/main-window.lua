local ADDON_NAME = ... ---@type string
local Addon = select(2, ...) ---@type Addon
local Colors = Addon:GetModule("Colors") ---@type Colors
local Commands = Addon:GetModule("Commands") ---@type Commands
local L = Addon:GetModule("Locale") ---@type Locale
local MainWindowOptions = Addon:GetModule("MainWindowOptions") ---@type MainWindowOptions
local Widgets = Addon:GetModule("Widgets") ---@type Widgets

--- @class MainWindow
local MainWindow = Addon:GetModule("MainWindow")

-- ============================================================================
-- MainWindow
-- ============================================================================

function MainWindow:Show()
  self.frame:Show()
end

function MainWindow:Hide()
  self.frame:Hide()
end

function MainWindow:Toggle()
  if self.frame:IsShown() then
    self.frame:Hide()
  else
    self.frame:Show()
  end
end

-- ============================================================================
-- Initialize
-- ============================================================================

MainWindow.frame = (function()
  --- @class MainWindowWidget : WindowWidget
  local frame = Widgets:Window({
    name = ADDON_NAME .. "_MainWindow",
    width = 400,
    height = 335,
    titleText = Colors.Purple(ADDON_NAME),
  })

  -- Version text.
  frame.versionText = frame.titleButton:CreateFontString("$parent_VersionText", "ARTWORK", "GameFontNormalSmall")
  frame.versionText:SetPoint("CENTER")
  frame.versionText:SetText(Colors.White(Addon.VERSION))
  frame.versionText:SetAlpha(0.5)

  -- Bell button.
  frame.BellButton = Widgets:TitleFrameIconButton({
    name = "$parent_BellButton",
    parent = frame.titleButton,
    points = {
      { "TOPRIGHT",    frame.closeButton, "TOPLEFT",    0, 0 },
      { "BOTTOMRIGHT", frame.closeButton, "BOTTOMLEFT", 0, 0 }
    },
    texture = Addon:GetAsset("bell-icon"),
    textureSize = frame.title:GetStringHeight(),
    highlightColor = Colors.Purple,
    onClick = function(self, button)
      if button == "LeftButton" then
        Commands.anchor(IsShiftKeyDown() and "reset" or nil)
      else
        Commands.test()
      end
    end,
    onUpdateTooltip = function(self, tooltip)
      tooltip:SetText(Colors.Purple(ADDON_NAME))
      tooltip:AddDoubleLine(L.LEFT_CLICK, L.TOGGLE_ANCHOR)
      tooltip:AddDoubleLine(Addon:Concat("+", L.SHIFT_KEY, L.LEFT_CLICK), L.RESET_ANCHOR)
      tooltip:AddDoubleLine(L.RIGHT_CLICK, L.TEST_NOTIFICATIONS)
    end
  })

  -- Options frame.
  frame.optionsFrame = Widgets:OptionsFrame({
    name = "$parent_OptionsFrame",
    parent = frame,
    points = {
      { "TOPLEFT",     frame.titleButton, "BOTTOMLEFT",  Widgets:Padding(),  0 },
      { "BOTTOMRIGHT", frame,             "BOTTOMRIGHT", -Widgets:Padding(), Widgets:Padding() }
    },
    titleText = L.OPTIONS_TEXT
  })
  MainWindowOptions:Initialize(frame.optionsFrame)

  return frame
end)()
