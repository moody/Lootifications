local ADDON_NAME = ... ---@type string
local Addon = select(2, ...) ---@type Addon
local AnchorFrame = Addon:GetModule("AnchorFrame")
local Colors = Addon:GetModule("Colors")
local L = Addon:GetModule("Locale")
local MainWindowOptions = Addon:GetModule("MainWindowOptions")
local Tester = Addon:GetModule("Tester")
local Widgets = Addon:GetModule("Widgets")

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
    height = 375,
    titleText = Colors.Purple(ADDON_NAME)
  })

  -- Version text.
  frame.versionText = frame.titleButton:CreateFontString("$parent_VersionText", "ARTWORK", "GameFontNormalSmall")
  frame.versionText:SetPoint("CENTER")
  frame.versionText:SetText(Colors.White(Addon.VERSION))
  frame.versionText:SetAlpha(0.5)

  -- Anchor button.
  frame.anchorButton = Widgets:Button({
    name = "$parent_AnchorButton",
    parent = frame,
    points = {
      { "BOTTOMLEFT", frame, Widgets:Padding(), Widgets:Padding() },
      { "BOTTOMRIGHT", frame, "BOTTOM", -Widgets:Padding(0.25), Widgets:Padding() }
    },
    labelText = L.TOGGLE_ANCHOR,
    labelColor = Colors.Yellow,
    onUpdateTooltip = function(self, tooltip)
      tooltip:AddDoubleLine(Addon:Concat("+", L.SHIFT_KEY, L.LEFT_CLICK), L.RESET_ANCHOR)
    end,
    onClick = function()
      if IsShiftKeyDown() then
        AnchorFrame:Reset()
      else
        AnchorFrame:Toggle()
      end
    end
  })

  -- Tester button.
  frame.testerButton = Widgets:Button({
    name = "$parent_TesterButton",
    parent = frame,
    points = {
      { "BOTTOMRIGHT", frame, -Widgets:Padding(), Widgets:Padding() },
      { "BOTTOMLEFT", frame, "BOTTOM", Widgets:Padding(0.25), Widgets:Padding() }
    },
    labelText = L.TEST_NOTIFICATIONS,
    labelColor = Colors.Green,
    onClick = function() Tester:Toggle() end
  })

  -- Options frame.
  frame.optionsFrame = Widgets:OptionsFrame({
    name = "$parent_OptionsFrame",
    parent = frame,
    points = {
      { "TOPLEFT", frame.titleButton, "BOTTOMLEFT", Widgets:Padding(), 0 },
      { "BOTTOMRIGHT", frame.testerButton, "TOPRIGHT", 0, Widgets:Padding(0.5) }
    },
    titleText = L.OPTIONS_TEXT
  })
  MainWindowOptions:Initialize(frame.optionsFrame)

  frame:HookScript("OnHide", function()
    AnchorFrame:Hide()
    Tester:Stop()
  end)

  return frame
end)()
