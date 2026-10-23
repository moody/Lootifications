local Addon = select(2, ...) ---@type Addon
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")

--- @class HistoryLog
local HistoryLog = Addon:GetModule("HistoryLog")

--- Something that happened. What `payload` holds is determined by `source`.
--- @class HistoryEntry
--- @field source HistorySource The log that recorded it.
--- @field time integer When it happened, as Unix time.
--- @field payload any

--- A log of one kind of entry, such as `ItemLog`.
--- @class HistorySource
--- @field GetText fun(self: HistorySource, entry: any): string Returns the text of an entry it recorded.

--- Everything that happened this session, in the order it happened, whatever its source.
--- @type HistoryEntry[]
local entries = {}

--- The entries of each source, in the order they happened.
--- @type table<HistorySource, HistoryEntry[]>
local entriesBySource = {}

-- ============================================================================
-- Local Functions
-- ============================================================================

--- Returns the entries of the source. It is empty until the source records one.
--- @param source HistorySource
--- @return HistoryEntry[]
local function getSourceEntries(source)
  local sourceEntries = entriesBySource[source]
  if not sourceEntries then
    sourceEntries = {}
    entriesBySource[source] = sourceEntries
  end

  return sourceEntries
end

-- ============================================================================
-- HistoryLog
-- ============================================================================

--- Logs an entry from the source, stamped with the time, then fires `HistoryLogged` with it.
--- @param source HistorySource
--- @param payload any
function HistoryLog:Record(source, payload)
  local entry = { source = source, time = time(), payload = payload }
  entries[#entries + 1] = entry

  local sourceEntries = getSourceEntries(source)
  sourceEntries[#sourceEntries + 1] = entry

  EventManager:Fire(E.HistoryLogged, entry)
end

--- Returns everything that happened this session, oldest first, or only the entries of the source if given.
--- Callers must not modify it.
--- @param source? HistorySource
--- @return HistoryEntry[]
function HistoryLog:GetEntries(source)
  return source and getSourceEntries(source) or entries
end

--- Returns the text of the entry, from the source that recorded it. It can change between calls.
--- @param entry HistoryEntry
--- @return string
function HistoryLog:GetText(entry)
  return entry.source:GetText(entry)
end
