local Addon = select(2, ...) ---@type Addon

--- @class DefaultStates
local DefaultStates = Addon:GetModule("DefaultStates")

--- Bump whenever a state change requires a migration.
DefaultStates.CURRENT_VERSION = 1

--- A point of a frame, as `SetPoint()` takes it.
--- @class PointState
--- @field point FramePoint
--- @field relativeTo? string Name of the frame that the point is relative to. Defaults to `UIParent`.
--- @field relativePoint FramePoint
--- @field offsetX number
--- @field offsetY number

--- The values that `anchorFrame.alignment` accepts.
--- @enum AnchorAlignment
DefaultStates.ANCHOR_ALIGNMENTS = { LEFT = "LEFT", CENTER = "CENTER", RIGHT = "RIGHT" }

--- The values that `anchorFrame.direction` accepts.
--- @enum AnchorDirection
DefaultStates.ANCHOR_DIRECTIONS = { DOWN = "DOWN", UP = "UP" }

--- The values that `notifications.background` accepts.
--- @enum NotificationBackground
DefaultStates.NOTIFICATION_BACKGROUNDS = { NONE = "NONE", SUBTLE = "SUBTLE", HIGH_CONTRAST = "HIGH_CONTRAST" }

--- The range and step of `notifications.textSize`, in pixels.
DefaultStates.NOTIFICATION_TEXT_SIZE = { MIN = 12, MAX = 32, STEP = 2 }

--- The state that a fresh profile starts with. Each key holds everything saved about one part of the addon.
--- @class GlobalState
DefaultStates.Global = {
  --- What the notifications show and how they look.
  --- @class NotificationsState
  notifications = {
    --- Whether looted or received money shows a notification.
    money = true,

    --- Whether item notifications include the vendor price.
    itemPrices = false,

    --- Whether item notifications include how many of the item are in the bags.
    bagCounts = false,

    --- The height of the notification text, in pixels.
    textSize = 16,

    --- The background and border style of each notification.
    --- @type NotificationBackground
    background = DefaultStates.NOTIFICATION_BACKGROUNDS.SUBTLE
  },

  --- The frame that holds the notifications.
  --- @class AnchorFrameState
  anchorFrame = {
    --- The way the notifications stack.
    --- @type AnchorDirection
    direction = DefaultStates.ANCHOR_DIRECTIONS.DOWN,

    --- How the notifications line up horizontally.
    --- @type AnchorAlignment
    alignment = DefaultStates.ANCHOR_ALIGNMENTS.CENTER,

    --- Where the anchor is pinned. The point follows from the direction and alignment.
    --- @type PointState
    point = { point = "TOP", relativeTo = "SubZoneTextString", relativePoint = "BOTTOM", offsetX = 0, offsetY = -8 }
  },

  --- @class MainWindowState
  mainWindow = {
    --- Where the main window is pinned.
    --- @type PointState
    point = { point = "CENTER", relativePoint = "CENTER", offsetX = 0, offsetY = -40 }
  },

  --- The minimap icon library reads and writes this table, so its keys are the library's.
  --- @class MinimapIconState
  --- @field minimapPos? number Position on the minimap, as an angle in degrees.
  minimapIcon = { hide = false }
}
