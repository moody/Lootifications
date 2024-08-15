local Addon = select(2, ...) ---@type Addon
local Colors = Addon:GetModule("Colors") ---@type Colors
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local GetCoinTextureString = C_CurrencyInfo.GetCoinTextureString or GetCoinTextureString
local GetItemCount = C_Item.GetItemCount or GetItemCount
local GetItemInfo = C_Item.GetItemInfo or GetItemInfo
local MessageBuilder = Addon:GetModule("MessageBuilder") ---@type MessageBuilder
local NotificationManager = Addon:GetModule("NotificationManager")

-- ============================================================================
-- Events
-- ============================================================================

do -- Listen for `Wow.ChatMessageLoot` and fire `LootReceived`.
  local ITEM_LINK_PATTERN = ".*(|c.+|r).*"
  local LOOT_QUANTITY_PATTERN = ".*x(%d+).*"

  EventManager:On(E.Wow.ChatMessageLoot, function(message, _, _, _, receiverName)
    if receiverName and receiverName:find(Addon.PLAYER_NAME) then
      pcall(function()
        local link = message:match(ITEM_LINK_PATTERN)
        local quantity = tonumber(message:match(LOOT_QUANTITY_PATTERN) or 1)
        if type(link) == "string" and type(quantity) == "number" then
          EventManager:Fire(E.LootReceived, link, quantity)
        end
      end)
    end
  end)
end

do -- Listen for `LootReceived` and display a notification.
  local QUANTITY_FORMAT = Colors.Grey("x") .. "%s"
  local PARENTHESES_FORMAT = Colors.Grey("(") .. "%s" .. Colors.Grey(")")

  local function getCountText(link)
    local state = Addon:GetState()
    if state.itemCount then
      local itemCount = tonumber(GetItemCount(link) or 0) + 1
      return PARENTHESES_FORMAT:format(itemCount)
    end
    return ""
  end

  local function getQuantityText(quantity)
    return (quantity > 1) and QUANTITY_FORMAT:format(quantity) or ""
  end

  local function getPriceText(price)
    local state = Addon:GetState()
    if state.lootPrices and price and price > 0 then
      return PARENTHESES_FORMAT:format(GetCoinTextureString(price))
    end
    return ""
  end

  local messageBuilder = MessageBuilder:New()

  EventManager:On(E.LootReceived, function(link, quantity)
    pcall(function()
      local texture, price = select(10, GetItemInfo(link))

      -- Build message.
      messageBuilder:Reset()
      messageBuilder:Append(link .. getQuantityText(quantity))
      messageBuilder:Append(getCountText(link))
      messageBuilder:Append(getPriceText(price * quantity))

      NotificationManager:NotifyWithIcon(texture, messageBuilder:Build())
    end)
  end)
end
