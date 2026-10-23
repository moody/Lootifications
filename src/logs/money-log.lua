local Addon = select(2, ...) ---@type Addon
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local GetCoinTextureString = C_CurrencyInfo.GetCoinTextureString or GetCoinTextureString
local HistoryLog = Addon:GetModule("HistoryLog")

--- Logs the money looted.
--- @class MoneyLog : HistorySource
local MoneyLog = Addon:GetModule("MoneyLog")

--- @class MoneyLogPayload
--- @field copper integer

--- @class MoneyLogEntry : HistoryEntry
--- @field payload MoneyLogPayload

local GOLD_AMOUNT = GOLD_AMOUNT:gsub("%%d", "(%%d+)")
local SILVER_AMOUNT = SILVER_AMOUNT:gsub("%%d", "(%%d+)")
local COPPER_AMOUNT = COPPER_AMOUNT:gsub("%%d", "(%%d+)")

-- ============================================================================
-- Local Functions
-- ============================================================================

--- Returns the amount of money in a loot message, in copper. It is `0` if the message has none.
--- @param message string
--- @return integer copper
local function parse(message)
  local goldAmount = tonumber(message:match(GOLD_AMOUNT) or 0) * COPPER_PER_GOLD
  local silverAmount = tonumber(message:match(SILVER_AMOUNT) or 0) * COPPER_PER_SILVER
  local copperAmount = tonumber(message:match(COPPER_AMOUNT) or 0)
  return goldAmount + silverAmount + copperAmount
end

-- ============================================================================
-- MoneyLog
-- ============================================================================

--- Logs money looted.
--- @param copper integer
function MoneyLog:Record(copper)
  HistoryLog:Record(self, { copper = copper })
end

--- Returns the money looted this session, oldest first. Callers must not modify it.
--- @return MoneyLogEntry[]
function MoneyLog:GetEntries()
  return HistoryLog:GetEntries(self)
end

--- Returns the text of the entry.
--- @param entry MoneyLogEntry
--- @return string
function MoneyLog:GetText(entry)
  return GetCoinTextureString(entry.payload.copper)
end

-- ============================================================================
-- Events
-- ============================================================================

-- Listen for `Wow.ChatMessageMoney` and log the money looted.
EventManager:On(E.Wow.ChatMessageMoney, function(message)
  local ok, copper = pcall(parse, message)
  if ok and copper > 0 then
    MoneyLog:Record(copper)
  end
end)
