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
  17056, -- Light Feather.
  16645, -- Shredder Operating Manual - Page 1.
  13874, -- Heavy Crate.
  -- Uncommon.
  -- Rare.
  -- Epic.
  -- Legendary.
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
    self.ticker = TickerManager:NewTicker(1, function()
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
