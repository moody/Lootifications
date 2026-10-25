local Addon = select(2, ...) ---@type Addon
local B = Addon:GetModule("Blizzard")
local ItemLogger = Addon:GetModule("ItemLogger")
local MoneyLogger = Addon:GetModule("MoneyLogger")

--- Provides the entries of the example notifications, which use real items.
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
--- @type table<integer, ExampleItemLogEntry>
local itemEntries = {}

-- ============================================================================
-- LuaCATS Annotations
-- ============================================================================

--- @class ExampleItemLogPayload : ItemLogPayload
--- @field ownedCount integer

--- @class ExampleItemLogEntry : ItemLogEntry
--- @field payload ExampleItemLogPayload

-- ============================================================================
-- ExampleItemLogger
-- ============================================================================

--- Gives the text of an example item, with the example's owned count instead of the number in the bags.
--- @class ExampleItemLogger : HistoryLogger
local ExampleItemLogger = {}

--- Returns the entry's text, with its owned count.
--- @param entry ExampleItemLogEntry
--- @return string
function ExampleItemLogger:GetText(entry)
  return ItemLogger:GetText(entry, entry.payload.ownedCount)
end

-- ============================================================================
-- ExampleNotifications
-- ============================================================================

--- Returns the entry of the example in the slot, or `nil` for an item that is not cached yet. The first slot is money
--- while its notifications are on, and the items move down a slot.
--- @param slot integer
--- @return HistoryLogEntry?
function ExampleNotifications:GetEntry(slot)
  local isMoneyOn = Addon:GetState().moneyNotifications
  if isMoneyOn and slot == 1 then return MONEY_ENTRY end

  local index = isMoneyOn and slot - 1 or slot
  local item = ITEMS[index]
  local entry = itemEntries[index]

  if item and not entry then
    local link = B.Items:GetInfo(item.itemID)
    if link then
      entry = {
        logger = ExampleItemLogger,
        time = 0,
        payload = { link = link, quantity = item.quantity, ownedCount = item.ownedCount }
      }
      itemEntries[index] = entry
    end
  end

  return entry
end
