local ADDON_NAME, Addon = ...
local AnchorFrame = Addon:GetModule("AnchorFrame")
local Colors = Addon:GetModule("Colors")
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local SavedVariables = Addon:GetModule("SavedVariables")
local Widgets = Addon:GetModule("Widgets")

-- ============================================================================
-- Create the frame.
-- ============================================================================

AnchorFrame.frame = (function()
  local frame = Widgets:Notification({ name = ADDON_NAME .. "_AnchorFrame" })
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")

  local text = Colors.Purple(("[%s Anchor]"):format(ADDON_NAME))
  frame:Notify(Addon.TEXTURE_MESSAGE_FORMAT:format(Addon.ICON, text))
  frame.animationGroup:Stop()

  frame:SetScript("OnDragStart", function(self)
    self:StartMoving()
  end)

  frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local sv = SavedVariables:Get()
    sv.anchorPoint = { self:GetPoint() }
  end)

  frame:Hide()
  return frame
end)()

-- ============================================================================
-- Functions
-- ============================================================================

function AnchorFrame:GetNotificationPoint()
  if not self.frame then
    return unpack(Addon.ANCHOR_POINT_DEFAULT)
  end

  if self.frame:IsShown() then
    return "TOP", self.frame, "BOTTOM", 0, 0
  else
    return "TOP", self.frame
  end
end

-- ============================================================================
-- Events
-- ============================================================================

-- Listen for `SavedVariablesLoaded` to create and position the frame.
EventManager:Once(E.SavedVariablesLoaded, function()
  local sv = SavedVariables:Get()

  -- Attempt to set the saved anchor point.
  local isAnchorPointSet = pcall(function()
    AnchorFrame.frame:ClearAllPoints()
    AnchorFrame.frame:SetPoint(unpack(sv.anchorPoint))
  end)

  -- If the saved anchor point couldn't be set, revert to the default anchor point.
  if not isAnchorPointSet then
    AnchorFrame.frame:ClearAllPoints()
    AnchorFrame.frame:SetPoint(unpack(Addon.ANCHOR_POINT_DEFAULT))
    sv.anchorPoint = Addon.ANCHOR_POINT_DEFAULT
  end
end)
