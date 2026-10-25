local Addon = select(2, ...) ---@type Addon
local B = Addon:GetModule("Blizzard")
local Colors = Addon:GetModule("Colors")
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local HistoryLog = Addon:GetModule("HistoryLog")

--- Logs the money looted.
--- @class MoneyLogger : HistoryLogger
local MoneyLogger = Addon:GetModule("MoneyLogger")

--- @class MoneyLogPayload
--- @field copper integer

--- @class MoneyLogEntry : HistoryLogEntry
--- @field payload MoneyLogPayload

local GOLD_AMOUNT = B.Strings.GOLD_AMOUNT_TEXT:gsub("%%d", "(%%d+)")
local SILVER_AMOUNT = B.Strings.SILVER_AMOUNT_TEXT:gsub("%%d", "(%%d+)")
local COPPER_AMOUNT = B.Strings.COPPER_AMOUNT_TEXT:gsub("%%d", "(%%d+)")

-- ============================================================================
-- Local Functions
-- ============================================================================

--- Returns the copper in a loot message, or `0` if it has none.
--- @param message string
--- @return integer copper
local function parse(message)
  local goldAmount = tonumber(message:match(GOLD_AMOUNT) or 0) * B.Money.COPPER_PER_GOLD
  local silverAmount = tonumber(message:match(SILVER_AMOUNT) or 0) * B.Money.COPPER_PER_SILVER
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

--- Returns the copper looted this session.
--- @return integer
function MoneyLogger:GetTotal()
  local total = 0
  for _, entry in ipairs(self:GetEntries()) do
    total = total + entry.payload.copper
  end

  return total
end

--- Returns the entry's text.
--- @param entry MoneyLogEntry
--- @return string
function MoneyLogger:GetText(entry)
  return B.Money:GetCoinText(entry.payload.copper)
end

--- Returns the color of the largest coin in the amount.
--- @param entry MoneyLogEntry
--- @return Color
function MoneyLogger:GetColor(entry)
  local copper = entry.payload.copper
  if copper >= B.Money.COPPER_PER_GOLD then return Colors.Gold end
  if copper >= B.Money.COPPER_PER_SILVER then return Colors.Silver end
  return Colors.Copper
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
