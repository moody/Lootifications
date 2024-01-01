local AddonName, Addon = ...
local E = Addon:GetModule("Events")

-- ============================================================================
-- Addon Events
-- ============================================================================

local events = {
  "LootReceived",
  "MoneyReceived",
  "SavedVariablesLoaded",
  "TexturedLootMessage"
}

for _, event in pairs(events) do
  E[event] = ("%s_%s"):format(AddonName, event)
end

-- ============================================================================
-- WoW Events
-- ============================================================================

E.Wow = {
  ChatMessageLoot = "CHAT_MSG_LOOT",
  ChatMessageMoney = "CHAT_MSG_MONEY",
  PlayerLogin = "PLAYER_LOGIN",
  PlayerLogout = "PLAYER_LOGOUT"
}
