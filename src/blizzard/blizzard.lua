local Addon = select(2, ...) ---@type Addon

--- @class Blizzard
local B = Addon:GetModule("Blizzard")

-- =============================================================================
-- Local Functions
-- =============================================================================

--- Returns the game's global with the given `name`. Throws an error if the client does not have it.
--- @param name string
--- @return any
local function getGlobal(name)
  return _G[name] or error(("The game global `%s` does not exist on this client."):format(name), 2)
end

-- =============================================================================
-- Globals
-- =============================================================================

local GetCoinTextureString = C_CurrencyInfo.GetCoinTextureString or getGlobal("GetCoinTextureString")
local GetItemCount = C_Item.GetItemCount or getGlobal("GetItemCount")
local GetItemInfo = C_Item.GetItemInfo or getGlobal("GetItemInfo")

-- =============================================================================
-- Blizzard - Strings
-- =============================================================================

--- The game's own localized strings.
B.Strings = {
  --- Name of the Shift key.

  --- Format of an amount of gold. Takes the number.
  GOLD_AMOUNT_TEXT = getGlobal("GOLD_AMOUNT"),

  --- Format of an amount of silver. Takes the number.
  SILVER_AMOUNT_TEXT = getGlobal("SILVER_AMOUNT"),

  --- Format of an amount of copper. Takes the number.
  COPPER_AMOUNT_TEXT = getGlobal("COPPER_AMOUNT"),

  --- Format of a number of hours, abbreviated. Takes the number.
  HOURS_ABBREVIATED_TEXT = getGlobal("HOUR_ONELETTER_ABBR"),

  --- Format of a number of minutes, abbreviated. Takes the number.
  MINUTES_ABBREVIATED_TEXT = getGlobal("MINUTE_ONELETTER_ABBR"),

  --- Format of a number of seconds, abbreviated. Takes the number.
  SECONDS_ABBREVIATED_TEXT = getGlobal("SECOND_ONELETTER_ABBR"),
}

-- =============================================================================
-- Blizzard - Items
-- =============================================================================

--- Game functions for items.
B.Items = {}

--- Returns the link, quality, icon, and vendor price of an item, or nothing until it is cached.
--- @param item string | number Item ID, link, or name.
--- @return string? link
--- @return number? quality
--- @return number? texture Icon of the item.
--- @return number? price Of one item, in copper.
function B.Items:GetInfo(item)
  local _, link, quality, _, _, _, _, _, _, texture, price = GetItemInfo(item)
  return link, quality, texture, price
end

--- Returns how many of an item are in the player's bags. Does not count the bank.
--- @param item string | number Item ID or link.
--- @return number count
function B.Items:GetBagCount(item)
  return tonumber(GetItemCount(item) or 0)
end

-- =============================================================================
-- Blizzard - Money
-- =============================================================================

--- Game functions and constants for money.
B.Money = {
  --- Copper in a gold.
  COPPER_PER_GOLD = getGlobal("COPPER_PER_GOLD"),

  --- Copper in a silver.
  COPPER_PER_SILVER = getGlobal("COPPER_PER_SILVER"),
}

--- Returns the amount of copper as text with coin icons.
--- @param copper number
--- @return string
function B.Money:GetCoinText(copper)
  return GetCoinTextureString(copper)
end
