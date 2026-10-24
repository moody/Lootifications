local ADDON_NAME = ... ---@type string
local Addon = select(2, ...) ---@type Addon
local AnchorFrame = Addon:GetModule("AnchorFrame")
local Colors = Addon:GetModule("Colors")
local L = Addon:GetModule("Locale")
local MainWindowOptions = Addon:GetModule("MainWindowOptions")
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

  -- Options frame.
  frame.optionsFrame = Widgets:OptionsFrame({
    name = "$parent_OptionsFrame",
    parent = frame,
    points = {
      { "TOPLEFT", frame.titleButton, "BOTTOMLEFT", Widgets:Padding(), 0 },
      { "BOTTOMRIGHT", frame, -Widgets:Padding(), Widgets:Padding() }
    },
    titleText = L.OPTIONS_TEXT
  })
  MainWindowOptions:Initialize(frame.optionsFrame)

  -- The anchor is unlocked while the window is shown.
  frame:HookScript("OnShow", function() AnchorFrame:Unlock() end)
  frame:HookScript("OnHide", function() AnchorFrame:Lock() end)

  return frame
end)()
