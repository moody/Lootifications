local _, Addon = ...
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local GetCoinTextureString = C_CurrencyInfo.GetCoinTextureString or GetCoinTextureString
local NotificationManager = Addon:GetModule("NotificationManager")

-- ============================================================================
-- Events
-- ============================================================================

do -- Listen for `Wow.ChatMessageMoney` and fire `MoneyReceived`.
  local GOLD_AMOUNT = GOLD_AMOUNT:gsub("%%d", "(%%d+)")
  local SILVER_AMOUNT = SILVER_AMOUNT:gsub("%%d", "(%%d+)")
  local COPPER_AMOUNT = COPPER_AMOUNT:gsub("%%d", "(%%d+)")

  EventManager:On(E.Wow.ChatMessageMoney, function(message)
    pcall(function()
      local goldAmount = tonumber(message:match(GOLD_AMOUNT) or 0) * COPPER_PER_GOLD
      local silverAmount = tonumber(message:match(SILVER_AMOUNT) or 0) * COPPER_PER_SILVER
      local copperAmount = tonumber(message:match(COPPER_AMOUNT) or 0)
      local total = goldAmount + silverAmount + copperAmount
      EventManager:Fire(E.MoneyReceived, total)
    end)
  end)
end

-- Listen for `MoneyReceived` and display a notification.
EventManager:On(E.MoneyReceived, function(amount)
  local state = Addon:GetStore():GetState()
  if amount > 0 and state.moneyNotifications then
    NotificationManager:Notify(GetCoinTextureString(amount))
  end
end)
