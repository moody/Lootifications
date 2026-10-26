local Addon = select(2, ...) ---@type Addon

--- @class DefaultStates
local DefaultStates = Addon:GetModule("DefaultStates")

--- A point of a frame, as `SetPoint()` takes it.
--- @class PointState
--- @field point FramePoint
--- @field relativeTo? string Name of the frame that the point is relative to. Defaults to `UIParent`.
--- @field relativePoint FramePoint
--- @field offsetX number
--- @field offsetY number

--- The values that `anchorAlignment` accepts.
--- @enum AnchorAlignment
DefaultStates.ANCHOR_ALIGNMENTS = { LEFT = "LEFT", CENTER = "CENTER", RIGHT = "RIGHT" }

--- The values that `anchorDirection` accepts.
--- @enum AnchorDirection
DefaultStates.ANCHOR_DIRECTIONS = { DOWN = "DOWN", UP = "UP" }

--- The values that `notificationBackground` accepts.
--- @enum NotificationBackground
DefaultStates.NOTIFICATION_BACKGROUNDS = { NONE = "NONE", SUBTLE = "SUBTLE", HIGH_CONTRAST = "HIGH_CONTRAST" }

--- The state that a fresh profile starts with.
--- @class LootificationsState
DefaultStates.Root = {
  ------------------------------------------------------------
  -- General
  ------------------------------------------------------------

  --- @class MinimapIconState
  --- @field minimapPos? number Position on the minimap, as an angle in degrees.
  minimapIcon = { hide = false },

  ------------------------------------------------------------
  -- Content
  ------------------------------------------------------------

  moneyNotifications = true,
  lootPrices = false,
  ownedItemCounts = false,

  ------------------------------------------------------------
  -- Look & Feel
  ------------------------------------------------------------

  --- @type AnchorDirection
  anchorDirection = DefaultStates.ANCHOR_DIRECTIONS.DOWN,
  --- @type AnchorAlignment
  anchorAlignment = DefaultStates.ANCHOR_ALIGNMENTS.CENTER,
  --- @type NotificationBackground
  notificationBackground = DefaultStates.NOTIFICATION_BACKGROUNDS.SUBTLE,

  ------------------------------------------------------------
  -- Positions
  ------------------------------------------------------------

  --- @type PointState
  anchorPoint = { point = "TOP", relativeTo = "SubZoneTextString", relativePoint = "BOTTOM", offsetX = 0, offsetY = -8 },
  --- @type PointState
  mainWindowPoint = { point = "CENTER", relativePoint = "CENTER", offsetX = 0, offsetY = -40 }
}
