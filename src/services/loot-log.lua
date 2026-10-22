local Addon = select(2, ...) ---@type Addon

--- @class LootLog
local LootLog = Addon:GetModule("LootLog")

-- ============================================================================
-- LuaCATS Annotations
-- ============================================================================

--- An item looted.
--- @class LootItemEntry
--- @field type "ITEM"
--- @field time integer When the item was looted, as Unix time.
--- @field link string
--- @field quantity integer

--- Money looted.
--- @class LootMoneyEntry
--- @field type "MONEY"
--- @field time integer When the money was looted, as Unix time.
--- @field copper integer

--- @alias LootEntry LootItemEntry | LootMoneyEntry

-- ============================================================================
-- LootLog
-- ============================================================================

--- @type LootEntry[]
local entries = {}

--- Records an item looted.
--- @param link string
--- @param quantity integer
function LootLog:AddItem(link, quantity)
  entries[#entries + 1] = { type = "ITEM", time = time(), link = link, quantity = quantity }
end

--- Records money looted.
--- @param copper integer
function LootLog:AddMoney(copper)
  entries[#entries + 1] = { type = "MONEY", time = time(), copper = copper }
end

--- Returns everything looted this session, oldest first.
--- @return LootEntry[]
function LootLog:GetEntries()
  return entries
end
