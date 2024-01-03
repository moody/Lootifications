local ADDON_NAME, Addon = ...
local AnchorFrame = Addon:GetModule("AnchorFrame")
local Colors = Addon:GetModule("Colors")
local Commands = Addon:GetModule("Commands")
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local L = Addon:GetModule("Locale")
local SavedVariables = Addon:GetModule("SavedVariables")

-- ============================================================================
-- Events
-- ============================================================================

EventManager:Once(E.Wow.PlayerLogin, function()
  SLASH_LOOTIFICATIONS1 = "/lootifications"
  SlashCmdList.LOOTIFICATIONS = function(msg)
    msg = strlower(msg or "")

    -- Split message into args.
    local args = {}
    for arg in msg:gmatch("%S+") do args[#args + 1] = strlower(arg) end

    -- First arg is command name.
    local key = table.remove(args, 1)
    key = type(Commands[key]) == "function" and key or "help"
    Commands[key](SafeUnpack(args))
  end
end)

-- ============================================================================
-- Local Functions
-- ============================================================================

--- Attempts to parse the given value as an integer.
--- @param value string|number
--- @return integer|nil
local function tryParseInteger(value)
  local integer = tonumber(value)
  if integer and integer == math.floor(integer) then
    return integer
  else
    return nil
  end
end

-- ============================================================================
-- Commands
-- ============================================================================

function Commands.help()
  Addon:Print("|", Addon.VERSION)
  print(Colors.Gold("  /lootifications"), "-", L.COMMAND_DESCRIPTION_HELP)
  print(Colors.Gold("  /lootifications anchor"), "-", L.COMMAND_DESCRIPTION_ANCHOR)
  print(Colors.Gold("  /lootifications anchor reset"), "-", L.COMMAND_DESCRIPTION_ANCHOR_RESET)
  print(Colors.Gold("  /lootifications delay"), Colors.Yellow("<integer>"), "-", L.COMMAND_DESCRIPTION_DELAY:format(
    Colors.Yellow(Addon.NOTIFICATION_FADE_OUT_DELAY_MIN), Colors.Yellow(Addon.NOTIFICATION_FADE_OUT_DELAY_MAX)))
  print(Colors.Gold("  /lootifications delay reset"), "-", L.COMMAND_DESCRIPTION_DELAY_RESET)
  print(Colors.Gold("  /lootifications max"), Colors.Yellow("<integer>"), "-", L.COMMAND_DESCRIPTION_MAX:format(
    Colors.Yellow(Addon.MAX_NOTIFICATIONS_MIN), Colors.Yellow(Addon.MAX_NOTIFICATIONS_MAX)))
  print(Colors.Gold("  /lootifications max reset"), "-", L.COMMAND_DESCRIPTION_MAX_RESET)
  print(Colors.Gold("  /lootifications money"), "-", L.COMMAND_DESCRIPTION_MONEY)
  print(Colors.Gold("  /lootifications prices"), "-", L.COMMAND_DESCRIPTION_PRICES)
  print(Colors.Gold("  /lootifications test"), "-", L.COMMAND_DESCRIPTION_TEST)
end

function Commands.anchor(subcommand)
  if subcommand == "reset" then
    AnchorFrame:Reset()
    Addon:Print(L.COMMAND_SUCCESS_ANCHOR_RESET)
  else
    AnchorFrame:Toggle()
  end
end

function Commands.delay(value)
  local sv = SavedVariables:Get()

  if value == "reset" then
    sv.notificationFadeOutDelay = Addon.NOTIFICATION_FADE_OUT_DELAY_DEFAULT
    Addon:Print(L.COMMAND_SUCCESS_DELAY_RESET)
    return
  end

  value = tryParseInteger(value)
  if value and value >= Addon.NOTIFICATION_FADE_OUT_DELAY_MIN and value <= Addon.NOTIFICATION_FADE_OUT_DELAY_MAX then
    sv.notificationFadeOutDelay = value
    Addon:Print(L.COMMAND_SUCCESS_DELAY:format(Colors.Yellow(value)))
  else
    Addon:Print(L.COMMAND_EXAMPLE_USAGE .. ":")
    print(Colors.Gold("  /lootifications delay"), Colors.Yellow(Addon.NOTIFICATION_FADE_OUT_DELAY_MIN), "-", L.MINIMUM)
    print(Colors.Gold("  /lootifications delay"), Colors.Yellow(Addon.NOTIFICATION_FADE_OUT_DELAY_MAX), "-", L.MAXIMUM)
  end
end

function Commands.max(value)
  local sv = SavedVariables:Get()

  if value == "reset" then
    sv.maxNotifications = Addon.MAX_NOTIFICATIONS_DEFAULT
    Addon:Print(L.COMMAND_SUCCESS_MAX_RESET)
    return
  end

  value = tryParseInteger(value)
  if value and value >= Addon.MAX_NOTIFICATIONS_MIN and value <= Addon.MAX_NOTIFICATIONS_MAX then
    sv.maxNotifications = value
    Addon:Print(L.COMMAND_SUCCESS_MAX:format(Colors.Yellow(value)))
  else
    Addon:Print(L.COMMAND_EXAMPLE_USAGE .. ":")
    print(Colors.Gold("  /lootifications max"), Colors.Yellow(Addon.MAX_NOTIFICATIONS_MIN), "-", L.MINIMUM)
    print(Colors.Gold("  /lootifications max"), Colors.Yellow(Addon.MAX_NOTIFICATIONS_MAX), "-", L.MAXIMUM)
  end
end

function Commands.money()
  local sv = SavedVariables:Get()
  sv.moneyNotifications = not sv.moneyNotifications
  local message = sv.moneyNotifications and L.MONEY_NOTIFICATIONS_ENABLED or L.MONEY_NOTIFICATIONS_DISABLED
  Addon:Print(message)
end

function Commands.prices()
  local sv = SavedVariables:Get()
  sv.lootPrices = not sv.lootPrices
  local message = sv.lootPrices and L.LOOT_PRICES_ENABLED or L.LOOT_PRICES_DISABLED
  Addon:Print(message)
end

do -- Commands.test()
  local COLOR_CODES = {
    "FF9D9D9D",
    "FFFFFFFF",
    "FF1EFF00",
    "FF0070DD",
    "FFA335EE",
    "FFFF8000"
  }

  function Commands.test()
    local sv = SavedVariables:Get()
    for i = 1, sv.maxNotifications do
      local colorIndex = ((i - 1) % #COLOR_CODES) + 1
      local colorCode = COLOR_CODES[colorIndex]
      local text = WrapTextInColorCode(("[%s %s]"):format(ADDON_NAME, i), colorCode)
      local textureMessage = Addon.TEXTURE_MESSAGE_FORMAT:format(Addon.ICON, text)
      EventManager:Fire(E.TexturedLootMessage, textureMessage)
    end
  end
end
