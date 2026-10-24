local Addon = select(2, ...) ---@type Addon
local GetItemInfo = C_Item.GetItemInfo or GetItemInfo
local ItemLogger = Addon:GetModule("ItemLogger")
local MoneyLogger = Addon:GetModule("MoneyLogger")

--- Provides the text of the example notifications that show what the notifications will look like, using real items.
--- @class ExampleNotifications
local ExampleNotifications = Addon:GetModule("ExampleNotifications")

--- Items to show, of varied quality. Each `ownedCount` is shown instead of the number in the bags.
local ITEMS = {
  { itemID = 19019, quantity = 1, ownedCount = 1 },  -- Thunderfury, Blessed Blade of the Windseeker.
  { itemID = 14344, quantity = 2, ownedCount = 6 },  -- Large Brilliant Shard.
  { itemID = 13926, quantity = 1, ownedCount = 3 },  -- Golden Pearl.
  { itemID = 6948, quantity = 1, ownedCount = 1 },   -- Hearthstone.
  { itemID = 3300, quantity = 12, ownedCount = 24 }, -- Rabbit's Foot.
}

--- The money shown when money notifications are on.
--- @type MoneyLogEntry
local MONEY_ENTRY = { logger = MoneyLogger, time = 0, payload = { copper = 42069 } }

--- Each item's entry, once the item is cached.
--- @type table<integer, ItemLogEntry>
local itemEntries = {}

-- ============================================================================
-- ExampleNotifications
-- ============================================================================

--- Returns the text of the example in the slot. The first slot is money while its notifications are on, and the
--- items that follow move down a slot. It is empty for an item that is not cached yet.
--- @param slot integer
--- @return string
function ExampleNotifications:GetText(slot)
  local isMoneyOn = Addon:GetState().moneyNotifications
  local index = isMoneyOn and slot - 1 or slot
  local item = ITEMS[index]
  local entry = itemEntries[index]

  if item and not entry then
    local link = select(2, GetItemInfo(item.itemID))
    if link then
      entry = { logger = ItemLogger, time = 0, payload = { link = link, quantity = item.quantity } }
      itemEntries[index] = entry
    end
  end

  if isMoneyOn and slot == 1 then
    return MoneyLogger:GetText(MONEY_ENTRY)
  elseif entry then
    return ItemLogger:GetText(entry, item.ownedCount)
  end

  return ""
end
