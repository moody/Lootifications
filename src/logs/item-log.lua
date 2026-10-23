local Addon = select(2, ...) ---@type Addon
local Colors = Addon:GetModule("Colors")
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local GetCoinTextureString = C_CurrencyInfo.GetCoinTextureString or GetCoinTextureString
local GetItemCount = C_Item.GetItemCount or GetItemCount
local GetItemInfo = C_Item.GetItemInfo or GetItemInfo
local HistoryLog = Addon:GetModule("HistoryLog")
local MessageBuilder = Addon:GetModule("MessageBuilder")

--- Logs the items looted.
--- @class ItemLog : HistorySource
local ItemLog = Addon:GetModule("ItemLog")

--- @class ItemLogPayload
--- @field link string
--- @field quantity integer

--- @class ItemLogEntry : HistoryEntry
--- @field payload ItemLogPayload

--- The `type` of the entries it records.
ItemLog.ENTRY_TYPE = "ItemLogEntry"

local ITEM_LINK_PATTERN = ".*(|c.+|r).*"
local LOOT_QUANTITY_PATTERN = ".*x(%d+).*"
local QUANTITY_FORMAT = Colors.Grey("x") .. "%s"
local PARENTHESES_FORMAT = Colors.Grey("(") .. "%s" .. Colors.Grey(")")

local messageBuilder = MessageBuilder:New()

-- ============================================================================
-- Local Functions
-- ============================================================================

--- Returns the item link and quantity in a loot message, or `nil` if it has none.
--- @param message string
--- @return string? link
--- @return integer? quantity
local function parse(message)
  local link = message:match(ITEM_LINK_PATTERN)
  local quantity = tonumber(message:match(LOOT_QUANTITY_PATTERN) or 1)
  if link and quantity then
    return link, quantity
  end

  return nil
end

--- Returns the quantity of an item, or an empty string for one.
--- @param quantity integer
--- @return string
local function getQuantityText(quantity)
  return (quantity > 1) and QUANTITY_FORMAT:format(quantity) or ""
end

--- Returns how many of the item are owned, if that option is on.
--- @param link string
--- @return string
local function getCountText(link)
  if Addon:GetState().ownedItemCounts then
    local itemCount = tonumber(GetItemCount(link) or 0)
    if itemCount > 0 then
      return PARENTHESES_FORMAT:format(itemCount)
    end
  end

  return ""
end

--- Returns the vendor price of the items, if that option is on and the price is known.
--- @param price? integer Vendor price of one item, `nil` until the item is cached.
--- @param quantity integer
--- @return string
local function getPriceText(price, quantity)
  if Addon:GetState().lootPrices and price and price > 0 then
    return PARENTHESES_FORMAT:format(GetCoinTextureString(price * quantity))
  end

  return ""
end

-- ============================================================================
-- ItemLog
-- ============================================================================

--- Logs an item looted.
--- @param link string
--- @param quantity integer
function ItemLog:Record(link, quantity)
  HistoryLog:Record(self.ENTRY_TYPE, { link = link, quantity = quantity })
end

--- Returns the items looted this session, oldest first. Callers must not modify it.
--- @return ItemLogEntry[]
function ItemLog:GetEntries()
  return HistoryLog:GetEntries(self.ENTRY_TYPE)
end

--- Returns the text of the entry, with the item's icon once it is cached. It can change between calls, such
--- as when the item becomes cached or the owned count changes.
--- @param entry ItemLogEntry
--- @return string
function ItemLog:GetText(entry)
  local payload = entry.payload
  local texture, price = select(10, GetItemInfo(payload.link))

  messageBuilder:Reset()
  messageBuilder:Append(payload.link .. getQuantityText(payload.quantity))
  messageBuilder:Append(getCountText(payload.link))
  messageBuilder:Append(getPriceText(price, payload.quantity))
  local text = messageBuilder:Build()

  if texture then
    return Addon.TEXTURE_MESSAGE_FORMAT:format(texture, text)
  end

  return text
end

-- ============================================================================
-- Events
-- ============================================================================

-- Listen for `Wow.ChatMessageLoot` and log the item looted.
EventManager:On(E.Wow.ChatMessageLoot, function(message, _, _, _, receiverName)
  if receiverName and receiverName:find(Addon.PLAYER_NAME) then
    local ok, link, quantity = pcall(parse, message)
    if ok and link then
      ItemLog:Record(link, quantity)
    end
  end
end)

HistoryLog:Register(ItemLog)
