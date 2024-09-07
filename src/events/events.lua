local _, Addon = ...
local E = Addon:GetModule("Events") ---@class Events

-- ============================================================================
-- Addon Events
-- ============================================================================

E.LootReceived = "Lootifications_LootReceived"
E.MoneyReceived = "Lootifications_MoneyReceived"
E.StateUpdated = "Lootifications_StateUpdate"
E.StoreInitialized = "Lootifications_StoreInitialized"

-- ============================================================================
-- WoW Events
-- ============================================================================

E.Wow = {
  ChatMessageLoot = "CHAT_MSG_LOOT",
  ChatMessageMoney = "CHAT_MSG_MONEY",
  PlayerLogin = "PLAYER_LOGIN",
  PlayerLogout = "PLAYER_LOGOUT"
}
