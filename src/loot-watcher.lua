local _, Addon = ...
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local NotificationManager = Addon:GetModule("NotificationManager")

-- ============================================================================
-- Events
-- ============================================================================

do -- Listen for `Wow.ChatMessageLoot` and fire `LootReceived`.
  local ITEM_LINK_PATTERN = ".*(|c.+|r).*"
  local LOOT_QUANTITY_PATTERN = ".*x(%d+).*"

  EventManager:On(E.Wow.ChatMessageLoot, function(message, _, _, _, receiverName)
    if receiverName ~= UnitName("Player") then return end
    pcall(function()
      local link = message:match(ITEM_LINK_PATTERN)
      local quantity = tonumber(message:match(LOOT_QUANTITY_PATTERN) or 1)
      if type(link) == "string" and type(quantity) == "number" then
        EventManager:Fire(E.LootReceived, link, quantity)
      end
    end)
  end)
end

do -- Listen for `LootReceived` and fire `TexturedLootMessage`.
  local QUANTITY_FORMAT = "|cFF9D9D9Dx|r%s"
  local TEXTURE_MESSAGE_FORMAT = "|T%s:0:0:0:0:16:16:2:14:2:14|t %s"

  EventManager:On(E.LootReceived, function(link, quantity)
    pcall(function()
      local texture = select(10, GetItemInfo(link))
      local quantityText = (quantity > 1) and QUANTITY_FORMAT:format(quantity) or ""
      local message = TEXTURE_MESSAGE_FORMAT:format(texture, link .. quantityText)
      EventManager:Fire(E.TexturedLootMessage, message)
    end)
  end)
end

-- Listen for `TexturedLootMessage` and display a notification.
EventManager:On(E.TexturedLootMessage, function(message)
  NotificationManager:Notify(message)
end)
