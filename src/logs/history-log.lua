local Addon = select(2, ...) ---@type Addon
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")

--- @class HistoryLog
local HistoryLog = Addon:GetModule("HistoryLog")

--- Something that happened. Its `logger` determines what `payload` holds.
--- @class HistoryLogEntry
--- @field logger HistoryLogger The logger that recorded it.
--- @field time integer When it happened, as Unix time.
--- @field payload any

--- Logs one kind of entry, such as `ItemLogger`.
--- @class HistoryLogger
--- @field GetText fun(self: HistoryLogger, entry: any): string Returns the text of an entry it recorded.

--- Every entry this session, oldest first.
--- @type HistoryLogEntry[]
local entries = {}

--- Every entry this session, by logger, oldest first.
--- @type table<HistoryLogger, HistoryLogEntry[]>
local entriesByLogger = {}

-- ============================================================================
-- Local Functions
-- ============================================================================

--- Returns the logger's entries. The list is empty until it records one.
--- @param logger HistoryLogger
--- @return HistoryLogEntry[]
local function getLoggerEntries(logger)
  local loggerEntries = entriesByLogger[logger]
  if not loggerEntries then
    loggerEntries = {}
    entriesByLogger[logger] = loggerEntries
  end

  return loggerEntries
end

-- ============================================================================
-- HistoryLog
-- ============================================================================

--- Logs an entry from the logger, then fires `HistoryLogged` with it.
--- @param logger HistoryLogger
--- @param payload any
function HistoryLog:Record(logger, payload)
  local entry = { logger = logger, time = time(), payload = payload }
  entries[#entries + 1] = entry

  local loggerEntries = getLoggerEntries(logger)
  loggerEntries[#loggerEntries + 1] = entry

  EventManager:Fire(E.HistoryLogged, entry)
end

--- Returns every entry, oldest first, or only the logger's if given. Callers must not modify it.
--- @param logger? HistoryLogger
--- @return HistoryLogEntry[]
function HistoryLog:GetEntries(logger)
  return logger and getLoggerEntries(logger) or entries
end

--- Returns the entry's text, from its logger. It can change between calls.
--- @param entry HistoryLogEntry
--- @return string
function HistoryLog:GetText(entry)
  return entry.logger:GetText(entry)
end
