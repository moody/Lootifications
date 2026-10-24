local Addon = select(2, ...) ---@type Addon
local B = Addon:GetModule("Blizzard")
local Colors = Addon:GetModule("Colors")
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local HistoryLog = Addon:GetModule("HistoryLog")
local MessageBuilder = Addon:GetModule("MessageBuilder")

--- Logs the items looted.
--- @class ItemLogger : HistoryLogger
local ItemLogger = Addon:GetModule("ItemLogger")

--- @class ItemLogPayload
--- @field link string
--- @field quantity integer

--- @class ItemLogEntry : HistoryLogEntry
--- @field payload ItemLogPayload

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

--- Returns the quantity text, or an empty string for one item.
--- @param quantity integer
--- @return string
local function getQuantityText(quantity)
  return (quantity > 1) and QUANTITY_FORMAT:format(quantity) or ""
end

--- Returns the owned count text, if that option is on and any are owned.
--- @param link string
--- @param ownedCount? integer Used instead of the number in the bags.
--- @return string
local function getCountText(link, ownedCount)
  if Addon:GetState().ownedItemCounts then
    local itemCount = ownedCount or B.Items:GetBagCount(link)
    if itemCount > 0 then
      return PARENTHESES_FORMAT:format(itemCount)
    end
  end

  return ""
end

--- Returns the total vendor price text, if that option is on and the price is known.
--- @param price? integer Vendor price of one item, `nil` until the item is cached.
--- @param quantity integer
--- @return string
local function getPriceText(price, quantity)
  if Addon:GetState().lootPrices and price and price > 0 then
    return PARENTHESES_FORMAT:format(B.Money:GetCoinText(price * quantity))
  end

  return ""
end

-- ============================================================================
-- ItemLogger
-- ============================================================================

--- Logs an item looted.
--- @param link string
--- @param quantity integer
function ItemLogger:Record(link, quantity)
  HistoryLog:Record(self, { link = link, quantity = quantity })
end

--- Returns the items looted this session, oldest first. Callers must not modify it.
--- @return ItemLogEntry[]
function ItemLogger:GetEntries()
  return HistoryLog:GetEntries(self)
end

--- Returns the number of items looted this session, counting each item in a stack.
--- @return integer
function ItemLogger:GetTotal()
  local total = 0
  for _, entry in ipairs(self:GetEntries()) do
    total = total + entry.payload.quantity
  end

  return total
end

--- Returns the entry's text, with the item's icon once cached. It changes when the item is cached or the
--- owned count changes.
--- @param entry ItemLogEntry
--- @param ownedCount? integer Shown as the owned count instead of the number in the bags.
--- @return string
function ItemLogger:GetText(entry, ownedCount)
  local payload = entry.payload
  local _, _, texture, price = B.Items:GetInfo(payload.link)

  messageBuilder:Reset()
  messageBuilder:Append(payload.link .. getQuantityText(payload.quantity))
  messageBuilder:Append(getCountText(payload.link, ownedCount))
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
      ItemLogger:Record(link, quantity)
    end
  end
end)
