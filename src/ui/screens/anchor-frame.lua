local ADDON_NAME = ... ---@type string
local Addon = select(2, ...) ---@type Addon
local ActionCreators = Addon:GetModule("ActionCreators")
local Colors = Addon:GetModule("Colors")
local ComponentFactory = Addon:GetModule("ComponentFactory")
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local ExampleNotifications = Addon:GetModule("ExampleNotifications")
local L = Addon:GetModule("Locale")
local NotificationManager = Addon:GetModule("NotificationManager")
local TickerManager = Addon:GetModule("TickerManager")
local Widgets = Addon:GetModule("Widgets")
local Wux = Addon.Wux

--- Holds the notifications, stacked and aligned per the state and pinned at the matching point of the screen.
--- While locked it shows the live notifications, and while unlocked it shows examples of them and can be dragged.
--- @class AnchorFrame
local AnchorFrame = Addon:GetModule("AnchorFrame")

local Components = {}

--- The stacking direction and the pinned edge of each `anchorDirection`.
local DIRECTIONS = {
  DOWN = { direction = "COLUMN", edge = "TOP" },
  UP = { direction = "COLUMN_REVERSE", edge = "BOTTOM" }
}

--- The alignment and the pinned side of each `anchorAlignment`.
local ALIGNMENTS = {
  LEFT = { align = "START", side = "LEFT" },
  CENTER = { align = "CENTER", side = "" },
  RIGHT = { align = "END", side = "RIGHT" }
}

--- Whether the anchor can be dragged.
local isUnlocked = false

--- The live notifications, one for each that can be shown at once. One that is visible is being shown.
--- @type NotificationComponent[]
local notifications = {}

--- Counts the notifications shown, and starts over once none are. A newer notification gets a lower `order`, which
--- puts it closest to the pinned edge.
local sequence = 0

-- ============================================================================
-- Local Functions
-- ============================================================================

--- Returns the point of the screen that the anchor is pinned at.
--- @return FramePoint
local function getPoint()
  local state = Addon:GetState()
  return DIRECTIONS[state.anchorDirection].edge .. ALIGNMENTS[state.anchorAlignment].side
end

--- Pins the frame at its point, offset by `x` and `y` from the screen's edge.
--- @param frame AnchorFrameWidget
--- @param x number
--- @param y number
local function pinTo(frame, x, y)
  local point = getPoint()
  frame:ClearAllPoints()
  frame:SetPoint(point, UIParent, point, x, y)
end

--- Pins the frame below the zone text.
--- @param frame AnchorFrameWidget
local function pinToDefault(frame)
  frame:ClearAllPoints()
  frame:SetPoint("TOP", SubZoneTextString, "BOTTOM", 0, -Widgets:Padding())
end

--- Pins the frame at its point, in the place it is now, and saves the offsets from the screen's edge at that point.
--- @param frame AnchorFrameWidget
local function pinInPlace(frame)
  local point = getPoint()
  local x = frame:GetCenter() - (UIParent:GetLeft() + UIParent:GetWidth() * 0.5)
  if point:find("LEFT") then
    x = frame:GetLeft() - UIParent:GetLeft()
  elseif point:find("RIGHT") then
    x = frame:GetRight() - UIParent:GetRight()
  end

  local y = frame:GetBottom() - UIParent:GetBottom()
  if point:find("TOP") then
    y = frame:GetTop() - UIParent:GetTop()
  end

  pinTo(frame, x, y)
  Addon:GetStore():Dispatch(ActionCreators.setAnchorPoint({ x = x, y = y }))
end

--- Shows the frame as locked or unlocked: an unlocked frame has a background and a border, and takes the mouse.
--- @param frame AnchorFrameWidget
local function refreshFrame(frame)
  if isUnlocked then
    frame:SetBackdropColor(0, 0, 0, 0.6)
    frame:SetBackdropBorderColor(Colors.Gold:GetRGBA())
  else
    frame:SetBackdropColor(0, 0, 0, 0)
    frame:SetBackdropBorderColor(0, 0, 0, 0)
  end

  frame:EnableMouse(isUnlocked)
end

-- ============================================================================
-- Root Component
-- ============================================================================

--- @class AnchorFrameComponent : WaffleFlexComponent
Components.Root = Addon.Waffle:Flex({
  padding = Widgets:Padding(0.25),
  width = "AUTO",
  height = "AUTO",

  --- @param parent Frame
  defaultFrameFactory = function(parent)
    return CreateFrame("Frame", nil, parent)
  end,

  frameFactory = function()
    --- @class AnchorFrameWidget : FrameWidget
    local frame = Widgets:Frame({
      name = ADDON_NAME .. "_AnchorFrame",
      clipChildren = false,
      tooltipAnchor = "ANCHOR_CURSOR",
      onUpdateTooltip = function(_, tooltip)
        tooltip:SetText(("%s %s"):format(ADDON_NAME, L.ANCHOR))
        tooltip:AddLine(L.ANCHOR_TOOLTIP)
        tooltip:AddLine(" ")
        tooltip:AddDoubleLine(L.RIGHT_CLICK, L.RESET_ANCHOR)
      end
    })
    refreshFrame(frame)

    frame:SetMovable(true)
    frame:SetClampedToScreen(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)

    -- Pin the frame where it was dropped.
    frame:SetScript("OnDragStop", function(self)
      self:StopMovingOrSizing()
      pinInPlace(self)
    end)

    frame:SetScript("OnMouseDown", function(_, button)
      if button == "RightButton" then
        AnchorFrame:Reset()
      end
    end)

    return frame
  end
})

-- ============================================================================
-- Screen Components
-- ============================================================================

-- The screen shown while locked: the notifications that come from loot.
Components.LiveNotifications = Components.Root:AddChild({
  direction = "COLUMN",
  gap = Addon.NOTIFICATION_SPACING,
  width = "AUTO",
  height = "AUTO"
})

for i = 1, Addon.MAX_NOTIFICATIONS do
  notifications[i] = ComponentFactory:Notification()
  Components.LiveNotifications:AttachComponent(notifications[i])
end

-- The screen shown while unlocked: examples of the notifications, which stay until the anchor is locked.
Components.ExampleNotifications = Components.Root:AddChild({
  direction = "COLUMN",
  gap = Addon.NOTIFICATION_SPACING,
  width = "AUTO",
  height = "AUTO",
  visibility = "GONE"
})

for slot = 1, Addon.MAX_NOTIFICATIONS do
  local example = ComponentFactory:Notification({ animated = false })
  example:SetOrder(slot)
  example:Notify(function() return ExampleNotifications:GetText(slot) end)
  Components.ExampleNotifications:AttachComponent(example)
end

-- ============================================================================
-- AnchorFrame
-- ============================================================================

--- Returns whether the anchor is unlocked.
--- @return boolean
function AnchorFrame:IsUnlocked()
  return isUnlocked
end

--- Lets the anchor be dragged, and shows examples of the notifications in place of the live ones, which are dropped.
function AnchorFrame:Unlock()
  if isUnlocked then return end
  isUnlocked = true

  NotificationManager:Clear()
  for _, notification in ipairs(notifications) do
    notification:Kill()
  end

  Components.LiveNotifications:SetVisibility("GONE")
  Components.ExampleNotifications:SetVisibility("VISIBLE")
  Components.Root:WhenFrameReady(refreshFrame)
end

--- Stops the anchor from being dragged, and shows the live notifications again.
function AnchorFrame:Lock()
  if not isUnlocked then return end
  isUnlocked = false

  Components.ExampleNotifications:SetVisibility("GONE")
  Components.LiveNotifications:SetVisibility("VISIBLE")
  Components.Root:WhenFrameReady(refreshFrame)
end

--- Pins the anchor at the point from its direction and alignment, where it is now. Call it after either changes,
--- so that the notifications stay where they are.
function AnchorFrame:Pin()
  Components.Root:WhenFrameReady(pinInPlace)
end

--- Moves the anchor to its default position and resets its direction and alignment.
function AnchorFrame:Reset()
  Addon:GetStore():Dispatch({
    type = Wux.ActionTypes.Batch,
    payload = {
      ActionCreators.resetAnchorAlignment(),
      ActionCreators.resetAnchorDirection(),
      ActionCreators.resetAnchorPoint()
    }
  })

  Components.Root:WhenFrameReady(pinToDefault)
end

-- ============================================================================
-- Tickers
-- ============================================================================

-- Lay out the notifications.
TickerManager:NewTicker(1 / 30, function()
  Components.Root:Layout()
end)

-- Show a queued notification each stagger interval, while there is room for it.
TickerManager:NewTicker(Addon.NOTIFICATION_STAGGER, function()
  local shownCount, freeNotification = 0, nil
  for _, notification in ipairs(notifications) do
    if notification:IsVisible() then
      shownCount = shownCount + 1
    elseif not freeNotification then
      freeNotification = notification
    end
  end

  if shownCount == 0 then sequence = 0 end

  if freeNotification then
    local getText = NotificationManager:Pop()
    if getText then
      sequence = sequence + 1
      freeNotification:SetOrder(-sequence)
      freeNotification:Notify(getText)
    end
  end
end)

-- ============================================================================
-- Events
-- ============================================================================

-- Listen for `StoreInitialized` to pin the anchor to its saved position.
EventManager:Once(E.StoreInitialized, function(Store)
  local position = Store:GetState().anchorPoint

  Components.Root:WhenFrameReady(function(frame)
    --- @cast frame AnchorFrameWidget
    refreshFrame(frame)

    if type(position.x) == "number" and type(position.y) == "number" then
      pinTo(frame, position.x, position.y)
    else
      pinToDefault(frame)
    end
  end)
end)

-- Listen for `StateUpdated` to stack and align the notifications.
EventManager:On(E.StateUpdated, function(state)
  for _, screen in ipairs({ Components.LiveNotifications, Components.ExampleNotifications }) do
    screen:SetDirection(DIRECTIONS[state.anchorDirection].direction)
    screen:SetAlign(ALIGNMENTS[state.anchorAlignment].align)
  end
end)
