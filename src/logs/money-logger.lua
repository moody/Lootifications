local Addon = select(2, ...) ---@type Addon
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local GetCoinTextureString = C_CurrencyInfo.GetCoinTextureString or GetCoinTextureString
local HistoryLog = Addon:GetModule("HistoryLog")

--- Logs the money looted.
--- @class MoneyLogger : HistoryLogger
local MoneyLogger = Addon:GetModule("MoneyLogger")

--- @class MoneyLogPayload
--- @field copper integer

--- @class MoneyLogEntry : HistoryLogEntry
--- @field payload MoneyLogPayload

local GOLD_AMOUNT = GOLD_AMOUNT:gsub("%%d", "(%%d+)")
local SILVER_AMOUNT = SILVER_AMOUNT:gsub("%%d", "(%%d+)")
local COPPER_AMOUNT = COPPER_AMOUNT:gsub("%%d", "(%%d+)")

-- ============================================================================
-- Local Functions
-- ============================================================================

--- Returns the copper in a loot message, or `0` if it has none.
--- @param message string
--- @return integer copper
local function parse(message)
  local goldAmount = tonumber(message:match(GOLD_AMOUNT) or 0) * COPPER_PER_GOLD
  local silverAmount = tonumber(message:match(SILVER_AMOUNT) or 0) * COPPER_PER_SILVER
  local copperAmount = tonumber(message:match(COPPER_AMOUNT) or 0)
  return goldAmount + silverAmount + copperAmount
end

-- ============================================================================
-- MoneyLogger
-- ============================================================================

--- Logs money looted.
--- @param copper integer
function MoneyLogger:Record(copper)
  HistoryLog:Record(self, { copper = copper })
end

--- Returns the money looted this session, oldest first. Callers must not modify it.
--- @return MoneyLogEntry[]
function MoneyLogger:GetEntries()
  return HistoryLog:GetEntries(self)
end

--- Returns the entry's text.
--- @param entry MoneyLogEntry
--- @return string
function MoneyLogger:GetText(entry)
  return GetCoinTextureString(entry.payload.copper)
end

-- ============================================================================
-- Events
-- ============================================================================

-- Listen for `Wow.ChatMessageMoney` and log the money looted.
EventManager:On(E.Wow.ChatMessageMoney, function(message)
  local ok, copper = pcall(parse, message)
  if ok and copper > 0 then
    MoneyLogger:Record(copper)
  end
end)
