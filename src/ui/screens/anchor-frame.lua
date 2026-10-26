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
local Tooltip = Addon:GetModule("Tooltip")
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

--- Whether the anchor is being dragged. The example loop is paused meanwhile.
local isDragging = false

--- Counts the examples shown in the current loop. The first is the bottom slot.
local exampleSequence = 0

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
    frame:SetBackdropColor(0.5, 0.5, 0.5, 0.1)
    frame:SetBackdropBorderColor(Colors.Gold:GetRGBA())
  else
    frame:SetBackdropColor(0, 0, 0, 0)
    frame:SetBackdropBorderColor(0, 0, 0, 0)
  end

  frame:EnableMouse(isUnlocked)
end

--- Returns the entries of the examples in the order they appear: the bottom slot first.
--- @return HistoryLogEntry[]
local function getExampleEntries()
  local entries = {}
  for i = 1, Addon.MAX_NOTIFICATIONS do
    entries[i] = ExampleNotifications:GetEntry(Addon.MAX_NOTIFICATIONS + 1 - i)
  end

  return entries
end

--- Starts the examples over, hiding the ones that are showing.
local function restartExamples()
  Components.ExampleNotifications:Clear()
  Components.ExampleNotifications:SetEntries(getExampleEntries())
  exampleSequence = 0
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
      tooltipAnchor = "ANCHOR_CURSOR_RIGHT",
      onUpdateTooltip = function(_, tooltip)
        tooltip:SetText(ADDON_NAME)
        tooltip:AddLine(L.ANCHOR_TOOLTIP)
        tooltip:AddLine(" ")
        tooltip:AddDoubleLine(Colors.Purple(L.RIGHT_CLICK), Colors.White(L.RESET_ANCHOR))
      end
    })
    refreshFrame(frame)

    frame:SetMovable(true)
    frame:SetClampedToScreen(true)
    frame:RegisterForDrag("LeftButton")

    -- Show the examples without animation while dragging, since an animated one would glide from where the anchor was.
    frame:SetScript("OnDragStart", function(self)
      isDragging = true
      Tooltip:Hide()
      Components.ExampleNotifications:ShowAll(getExampleEntries())
      self:StartMoving()
    end)

    -- Pin the frame where it was dropped, and play the examples again.
    frame:SetScript("OnDragStop", function(self)
      isDragging = false
      self:StopMovingOrSizing()
      restartExamples()
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

-- Lay out the notifications.
TickerManager:NewTicker(1 / 30, function()
  Components.Root:Layout()
end)

-- ============================================================================
-- Screen Components - LiveNotifications
-- ============================================================================

--- The screen shown while locked: the notifications that come from loot.
--- @type NotificationStackComponent
Components.LiveNotifications = Components.Root:AttachComponent(ComponentFactory:NotificationStack())

-- Show a queued notification each stagger interval, while there is room for it.
Components.LiveNotifications:WhenFrameReady(function(frame)
  TickerManager:NewTicker(Addon.NOTIFICATION_STAGGER, function()
    if not Components.LiveNotifications:IsFull() then
      local entry = NotificationManager:Pop()
      if entry then
        Components.LiveNotifications:Show(entry, Addon:GetState().anchorDirection)
      end
    end
  end):BindFrame(frame)
end)

-- ============================================================================
-- Screen Components - ExampleNotifications
-- ============================================================================

--- The screen shown while unlocked: examples of the notifications, played in a loop.
--- @type NotificationStackComponent
Components.ExampleNotifications = Components.Root:AttachComponent(ComponentFactory:NotificationStack())
Components.ExampleNotifications:SetVisibility("GONE")

-- Play the examples in a loop while shown, bottom slot first, with a pause between loops.
Components.ExampleNotifications:WhenFrameReady(function(frame)
  local pause = 0
  TickerManager:NewTicker(Addon.NOTIFICATION_STAGGER, function()
    if isDragging then return end

    local entries = getExampleEntries()
    Components.ExampleNotifications:SetEntries(entries)

    if exampleSequence < Addon.MAX_NOTIFICATIONS then
      exampleSequence = exampleSequence + 1
      Components.ExampleNotifications:Show(entries[exampleSequence], Addon:GetState().anchorDirection)
    elseif Components.ExampleNotifications:IsShowing() then
      pause = 0
    else
      pause = pause + Addon.NOTIFICATION_STAGGER
      if pause >= 0.5 then -- Pause for 0.5 secs.
        pause = 0
        exampleSequence = 0
      end
    end
  end):BindFrame(frame)
end)

-- ============================================================================
-- AnchorFrame
-- ============================================================================

--- Returns whether the anchor is unlocked.
--- @return boolean
function AnchorFrame:IsUnlocked()
  return isUnlocked
end

--- Lets the anchor be dragged, and plays examples of the notifications in place of the live ones, which are dropped.
function AnchorFrame:Unlock()
  if isUnlocked then return end
  isUnlocked = true

  NotificationManager:Clear()
  Components.LiveNotifications:Clear()
  Components.LiveNotifications:SetVisibility("GONE")
  Components.ExampleNotifications:SetVisibility("VISIBLE")
  restartExamples()
  Components.Root:WhenFrameReady(refreshFrame)
end

--- Stops the anchor from being dragged, and shows the live notifications again.
function AnchorFrame:Lock()
  if not isUnlocked then return end
  isUnlocked = false

  Components.ExampleNotifications:Clear()
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

-- Listen for `StateUpdated` to stack and align the notifications, and to restart the examples.
EventManager:On(E.StateUpdated, function(state)
  for _, screen in ipairs({ Components.LiveNotifications, Components.ExampleNotifications }) do
    screen:SetDirection(DIRECTIONS[state.anchorDirection].direction)
    screen:SetAlign(ALIGNMENTS[state.anchorAlignment].align)
  end

  if isUnlocked then restartExamples() end
end)
