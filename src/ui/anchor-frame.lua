local ADDON_NAME = ... ---@type string
local Addon = select(2, ...) ---@type Addon
local Colors = Addon:GetModule("Colors")
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local L = Addon:GetModule("Locale")
local Widgets = Addon:GetModule("Widgets")

--- @class AnchorFrame
local AnchorFrame = Addon:GetModule("AnchorFrame")

local NOTIFICATION_POINTS = {
  GROW_UP = {
    LEFT = { point = "BOTTOMLEFT", relativePoint = "TOPLEFT" },
    CENTER = { point = "BOTTOM", relativePoint = "TOP" },
    RIGHT = { point = "BOTTOMRIGHT", relativePoint = "TOPRIGHT" }
  },
  GROW_DOWN = {
    LEFT = { point = "TOPLEFT", relativePoint = "BOTTOMLEFT" },
    CENTER = { point = "TOP", relativePoint = "BOTTOM" },
    RIGHT = { point = "TOPRIGHT", relativePoint = "BOTTOMRIGHT" }
  }
}

-- ============================================================================
-- Create the frame.
-- ============================================================================

AnchorFrame.frame = (function()
  local frame = Widgets:Notification({ name = ADDON_NAME .. "_AnchorFrame" })
  frame:SetBackdropColor(0, 0, 0, 1)
  frame:SetBackdropBorderColor(Colors.Gold:GetRGBA())
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")

  frame:HookScript("OnShow", function(self)
    local text = Colors.Gold(("[%s %s]"):format(ADDON_NAME, L.ANCHOR))
    self.fontString:SetText(Addon.TEXTURE_MESSAGE_FORMAT:format(Addon.ICON, text))
    self:SetWidth(self.fontString:GetWidth() + Widgets:Padding(1.5))
    self:SetHeight(self.fontString:GetHeight() + Widgets:Padding(1.5))
  end)

  frame:SetScript("OnDragStart", function(self)
    self:StartMoving()
  end)

  frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local anchorPoint = { self:GetPoint() }
    Addon:GetStore():Dispatch({ type = "anchorPoint/set", payload = anchorPoint })
  end)

  frame:SetScript("OnMouseDown", function(self, button)
    if button == "RightButton" then
      self:Hide()
    end
  end)

  frame:Hide()
  return frame
end)()

-- ============================================================================
-- Functions
-- ============================================================================

function AnchorFrame:GetNotificationPoints()
  local SCREEN_WIDTH = GetScreenWidth() or 0
  local SCREEN_HEIGHT = GetScreenHeight() or 0
  local SCREEN_MID_X = SCREEN_WIDTH * 0.5
  local SCREEN_MID_Y = SCREEN_HEIGHT * 0.5
  local CENTER_THRESHOLD = SCREEN_WIDTH * 0.2

  local anchorX, anchorY = self.frame:GetCenter()
  anchorX = anchorX or 0
  anchorY = anchorY or 0

  -- Determine notification growth direction based on anchor position.
  -- Y-axis: 0 at the bottom, increases upwards.
  local isCloserToTop = anchorY >= SCREEN_MID_Y
  local growthDirection = isCloserToTop and NOTIFICATION_POINTS.GROW_DOWN or NOTIFICATION_POINTS.GROW_UP

  -- Return center points if within the treshold.
  if anchorX >= SCREEN_MID_X - CENTER_THRESHOLD and anchorX <= SCREEN_MID_X + CENTER_THRESHOLD then
    return growthDirection.CENTER
  end

  -- Return points based on if the anchor is to the left or right.
  local isToTheLeft = anchorX <= SCREEN_MID_X
  return isToTheLeft and growthDirection.LEFT or growthDirection.RIGHT
end

function AnchorFrame:GetNotificationSpacing(points)
  local state = Addon:GetStore():GetState()
  local spacing = state.notificationSpacing

  for _, v in pairs(NOTIFICATION_POINTS.GROW_UP) do
    if points == v then return spacing end
  end

  return -spacing
end

function AnchorFrame:Reset()
  self.frame:ClearAllPoints()
  self.frame:SetPoint("TOP", SubZoneTextString, "BOTTOM", 0, -Widgets:Padding())
  Addon:GetStore():Dispatch({ type = "anchorPoint/reset" })
end

function AnchorFrame:Show()
  self.frame:Show()
end

function AnchorFrame:Hide()
  self.frame:Hide()
end

function AnchorFrame:Toggle()
  if self.frame:IsShown() then
    self.frame:Hide()
  else
    self.frame:Show()
  end
end

-- ============================================================================
-- Events
-- ============================================================================

-- Listen for `StoreInitialized` to create and position the frame.
EventManager:Once(E.StoreInitialized, function(Store)
  local state = Store:GetState()

  -- Attempt to set the saved anchor point.
  local isAnchorPointSet = pcall(function()
    AnchorFrame.frame:ClearAllPoints()
    AnchorFrame.frame:SetPoint(unpack(state.anchorPoint))
  end)

  -- If the saved anchor point couldn't be set, revert to the default anchor point.
  if not isAnchorPointSet then
    AnchorFrame:Reset()
  end
end)
