local Addon = select(2, ...) ---@type Addon
local GetItemInfo = C_Item.GetItemInfo or GetItemInfo
local HistoryNotifications = Addon:GetModule("HistoryNotifications")
local ItemLogger = Addon:GetModule("ItemLogger")

--- @class Tester
local Tester = Addon:GetModule("Tester")

local TEST_ITEMS = {
  -- Poor.
  5329,  -- Cat Figurine.
  3300,  -- Rabbit's Foot.
  3402,  -- Soft Patch of Fur.
  -- Common.
  14047, -- Runecloth.
  17056, -- Light Feather.
  8170,  -- Rugged Leather.
  -- Uncommon.
  13926, -- Golden Pearl.
  13468, -- Black Lotus.
  12811, -- Righteous Orb.
  -- Rare.
  14344, -- Large Brilliant Shard.
  15410, -- Scale of Onyxia.
  -- Epic.
  18562, -- Elementium Ore.
  17203, -- Sulfuron Ingot.
  20725, -- Nexus Crystal.
  -- Legendary.
  17771, -- Elementium Bar.
  17204, -- Eye of Sulfuras.
}

-- ============================================================================
-- Tester
-- ============================================================================

--- Shows a notification for a few different test items, which are not recorded in the history.
function Tester:Run()
  local itemIDs = { unpack(TEST_ITEMS) }
  local shownCount = 0

  while shownCount < Addon.MAX_NOTIFICATIONS and #itemIDs > 0 do
    local _, link = GetItemInfo(table.remove(itemIDs, math.random(#itemIDs)))
    if link then
      --- @type ItemLogEntry
      local entry = { logger = ItemLogger, time = time(), payload = { link = link, quantity = math.random() < 0.5 and math.random(2, 5) or 1 } }
      HistoryNotifications:Show(entry)
      shownCount = shownCount + 1
    end
  end
end
