local Addon = select(2, ...) ---@type Addon

--- @class DefaultStates
local DefaultStates = Addon:GetModule("DefaultStates")

--- The state that a fresh profile starts with.
--- @class LootificationsState
DefaultStates.Root = {
  anchorAlignment = "CENTER",
  anchorDirection = "DOWN",
  anchorPoint = {},
  lootPrices = false,
  mainWindowPoint = { point = "CENTER", relativePoint = "CENTER", offsetX = 0, offsetY = -40 },
  minimapIcon = { hide = false },
  moneyNotifications = true,
  ownedItemCounts = false
}
