local Addon = select(2, ...) ---@type Addon
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local GetItemInfo = C_Item.GetItemInfo or GetItemInfo
local TickerManager = Addon:GetModule("TickerManager")

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

--- Toggles the Tester.
function Tester:Toggle()
  if not self.isTesting then
    self:Start()
  else
    self:Stop()
  end
end

--- Starts the Tester.
function Tester:Start()
  if self.isTesting then return end
  self.isTesting = true

  if not self.ticker then
    self.ticker = TickerManager:NewTicker(0.5, function()
      local _, link, _, _, _, _, _, stackCount = GetItemInfo(TEST_ITEMS[math.random(#TEST_ITEMS)])
      local quantity = math.random(stackCount or 1)
      if link then
        EventManager:Fire(E.LootReceived, link, quantity)
      end
    end)
  end

  self.ticker:Restart()
end

--- Stops the Tester.
function Tester:Stop()
  self.isTesting = false
  if self.ticker then self.ticker:Cancel() end
end
