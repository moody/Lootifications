local _, Addon = ...
local Colors = Addon:GetModule("Colors")
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local NotificationManager = Addon:GetModule("NotificationManager")
local SavedVariables = Addon:GetModule("SavedVariables")

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
  local PRICE_FORMAT = Colors.Grey("(") .. "%s" .. Colors.Grey(")")

  local function getQuantityText(quantity)
    return (quantity > 1) and QUANTITY_FORMAT:format(quantity) or ""
  end

  local function getPriceText(price)
    local sv = SavedVariables:Get()
    if sv.lootPrices and price and price > 0 then
      return PRICE_FORMAT:format(GetCoinTextureString(price))
    end
    return ""
  end

  EventManager:On(E.LootReceived, function(link, quantity)
    pcall(function()
      local texture, price = select(10, GetItemInfo(link))
      local message = ("%s%s %s"):format(link, getQuantityText(quantity), getPriceText(price * quantity)):trim()
      NotificationManager:NotifyWithIcon(texture, message)
    end)
  end)
end
