local Addon = select(2, ...) ---@type Addon
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")

--- @class HistoryLog
local HistoryLog = Addon:GetModule("HistoryLog")

--- Something that happened. What `payload` holds is determined by `type`.
--- @class HistoryEntry
--- @field type string
--- @field time integer When it happened, as Unix time.
--- @field payload any

--- The source of one type of entry, registered with `HistoryLog:Register()`.
--- @class HistorySource
--- @field ENTRY_TYPE string The `type` of the entries it provides.
--- @field GetText fun(self: HistorySource, entry: any): string Returns the text of an entry of its type.

--- The source of each type of entry, by type.
--- @type table<string, HistorySource>
local sources = {}

--- Everything that happened this session, in the order it happened, whatever its type.
--- @type HistoryEntry[]
local entries = {}

--- The entries of each type, by type, in the order they happened.
--- @type table<string, HistoryEntry[]>
local entriesByType = {}

-- ============================================================================
-- HistoryLog
-- ============================================================================

--- Registers the source of an entry type, which provides the text of its entries.
--- @param source HistorySource
function HistoryLog:Register(source)
  local entryType = source.ENTRY_TYPE
  assert(not sources[entryType], "history entry type already registered: " .. entryType)
  sources[entryType] = source
  entriesByType[entryType] = {}
end

--- Logs an entry of the type, stamped with the time, then fires `HistoryLogged` with it.
--- @param entryType string
--- @param payload any
function HistoryLog:Record(entryType, payload)
  local entry = { type = entryType, time = time(), payload = payload }
  entries[#entries + 1] = entry
  local typeEntries = entriesByType[entryType]
  typeEntries[#typeEntries + 1] = entry
  EventManager:Fire(E.HistoryLogged, entry)
end

--- Returns everything that happened this session, oldest first, or only the entries of the type if given.
--- Callers must not modify it.
--- @param entryType? string
--- @return HistoryEntry[]
function HistoryLog:GetEntries(entryType)
  if entryType then
    return entriesByType[entryType]
  end

  return entries
end

--- Returns the text of the entry, from the source of its type. It can change between calls. Throws an error
--- for an entry of a type that is not registered.
--- @param entry HistoryEntry
--- @return string
function HistoryLog:GetText(entry)
  local source = sources[entry.type]
  if source then
    return source:GetText(entry)
  end

  error("unknown history entry type: " .. tostring(entry.type))
end
