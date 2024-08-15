local ADDON_NAME = ... ---@type string
local Addon = select(2, ...) ---@type Addon
local AnchorFrame = Addon:GetModule("AnchorFrame")
local Colors = Addon:GetModule("Colors") ---@type Colors
local Commands = Addon:GetModule("Commands")
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local L = Addon:GetModule("Locale") ---@type Locale
local NotificationManager = Addon:GetModule("NotificationManager")

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
  print(Colors.Gold("  /lootifications alpha"), Colors.Yellow("<integer>"), "-", L.COMMAND_DESCRIPTION_ALPHA:format(
    Colors.Yellow(Addon.NOTIFICATION_ALPHA_MIN), Colors.Yellow(Addon.NOTIFICATION_ALPHA_MAX)))
  print(Colors.Gold("  /lootifications alpha reset"), "-", L.COMMAND_DESCRIPTION_ALPHA_RESET)
  print(Colors.Gold("  /lootifications anchor"), "-", L.COMMAND_DESCRIPTION_ANCHOR)
  print(Colors.Gold("  /lootifications anchor reset"), "-", L.COMMAND_DESCRIPTION_ANCHOR_RESET)
  print(Colors.Gold("  /lootifications delay"), Colors.Yellow("<integer>"), "-", L.COMMAND_DESCRIPTION_DELAY:format(
    Colors.Yellow(Addon.NOTIFICATION_FADE_OUT_DELAY_MIN), Colors.Yellow(Addon.NOTIFICATION_FADE_OUT_DELAY_MAX)))
  print(Colors.Gold("  /lootifications delay reset"), "-", L.COMMAND_DESCRIPTION_DELAY_RESET)
  print(Colors.Gold("  /lootifications max"), Colors.Yellow("<integer>"), "-", L.COMMAND_DESCRIPTION_MAX:format(
    Colors.Yellow(Addon.MAX_NOTIFICATIONS_MIN), Colors.Yellow(Addon.MAX_NOTIFICATIONS_MAX)))
  print(Colors.Gold("  /lootifications max reset"), "-", L.COMMAND_DESCRIPTION_MAX_RESET)
  print(Colors.Gold("  /lootifications money"), "-", L.COMMAND_DESCRIPTION_MONEY)
  print(Colors.Gold("  /lootifications owned"), "-", L.COMMAND_DESCRIPTION_OWNED)
  print(Colors.Gold("  /lootifications prices"), "-", L.COMMAND_DESCRIPTION_PRICES)
  print(Colors.Gold("  /lootifications space"), Colors.Yellow("<integer>"), "-", L.COMMAND_DESCRIPTION_SPACE:format(
    Colors.Yellow(Addon.NOTIFICATION_SPACING_MIN), Colors.Yellow(Addon.NOTIFICATION_SPACING_MAX)))
  print(Colors.Gold("  /lootifications space reset"), "-", L.COMMAND_DESCRIPTION_SPACE_RESET)
  print(Colors.Gold("  /lootifications test"), "-", L.COMMAND_DESCRIPTION_TEST)
end

function Commands.alpha(value)
  if value == "reset" then
    Addon:GetStore():Dispatch({ type = "notificationAlpha/reset" })
    Addon:Print(L.COMMAND_SUCCESS_ALPHA_RESET)
    return
  end

  value = tryParseInteger(value)
  if value and value >= Addon.NOTIFICATION_ALPHA_MIN and value <= Addon.NOTIFICATION_ALPHA_MAX then
    Addon:GetStore():Dispatch({ type = "notificationAlpha/set", payload = value })
    Addon:Print(L.COMMAND_SUCCESS_ALPHA:format(Colors.Yellow(value)))
  else
    Addon:Print(L.COMMAND_EXAMPLE_USAGE .. ":")
    print(Colors.Gold("  /lootifications alpha"), Colors.Yellow(Addon.NOTIFICATION_ALPHA_MIN), "-", L.MINIMUM)
    print(Colors.Gold("  /lootifications alpha"), Colors.Yellow(Addon.NOTIFICATION_ALPHA_MAX), "-", L.MAXIMUM)
  end
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
  if value == "reset" then
    Addon:GetStore():Dispatch({ type = "notificationFadeOutDelay/reset" })
    Addon:Print(L.COMMAND_SUCCESS_DELAY_RESET)
    return
  end

  value = tryParseInteger(value)
  if value and value >= Addon.NOTIFICATION_FADE_OUT_DELAY_MIN and value <= Addon.NOTIFICATION_FADE_OUT_DELAY_MAX then
    Addon:GetStore():Dispatch({ type = "notificationFadeOutDelay/set", payload = value })
    Addon:Print(L.COMMAND_SUCCESS_DELAY:format(Colors.Yellow(value)))
  else
    Addon:Print(L.COMMAND_EXAMPLE_USAGE .. ":")
    print(Colors.Gold("  /lootifications delay"), Colors.Yellow(Addon.NOTIFICATION_FADE_OUT_DELAY_MIN), "-", L.MINIMUM)
    print(Colors.Gold("  /lootifications delay"), Colors.Yellow(Addon.NOTIFICATION_FADE_OUT_DELAY_MAX), "-", L.MAXIMUM)
  end
end

function Commands.max(value)
  if value == "reset" then
    Addon:GetStore():Dispatch({ type = "maxNotifications/reset" })
    Addon:Print(L.COMMAND_SUCCESS_MAX_RESET)
    return
  end

  value = tryParseInteger(value)
  if value and value >= Addon.MAX_NOTIFICATIONS_MIN and value <= Addon.MAX_NOTIFICATIONS_MAX then
    Addon:GetStore():Dispatch({ type = "maxNotifications/set", payload = value })
    Addon:Print(L.COMMAND_SUCCESS_MAX:format(Colors.Yellow(value)))
  else
    Addon:Print(L.COMMAND_EXAMPLE_USAGE .. ":")
    print(Colors.Gold("  /lootifications max"), Colors.Yellow(Addon.MAX_NOTIFICATIONS_MIN), "-", L.MINIMUM)
    print(Colors.Gold("  /lootifications max"), Colors.Yellow(Addon.MAX_NOTIFICATIONS_MAX), "-", L.MAXIMUM)
  end
end

function Commands.money()
  Addon:GetStore():Dispatch({ type = "moneyNotifications/toggle" })
  local state = Addon:GetState()
  local message = state.moneyNotifications and L.MONEY_NOTIFICATIONS_ENABLED or L.MONEY_NOTIFICATIONS_DISABLED
  Addon:Print(message)
end

function Commands.owned()
  Addon:GetStore():Dispatch({ type = "ownedItemCounts/toggle" })
  local state = Addon:GetState()
  local message = state.ownedItemCounts and L.OWNED_ITEM_COUNTS_ENABLED or L.OWNED_ITEM_COUNTS_DISABLED
  Addon:Print(message)
end

function Commands.prices()
  Addon:GetStore():Dispatch({ type = "lootPrices/toggle" })
  local state = Addon:GetState()
  local message = state.lootPrices and L.LOOT_PRICES_ENABLED or L.LOOT_PRICES_DISABLED
  Addon:Print(message)
end

function Commands.space(value)
  if value == "reset" then
    Addon:GetStore():Dispatch({ type = "notificationSpacing/reset" })
    Addon:Print(L.COMMAND_SUCCESS_SPACE_RESET)
    return
  end

  value = tryParseInteger(value)
  if value and value >= Addon.NOTIFICATION_SPACING_MIN and value <= Addon.NOTIFICATION_SPACING_MAX then
    Addon:GetStore():Dispatch({ type = "notificationSpacing/set", payload = value })
    Addon:Print(L.COMMAND_SUCCESS_SPACE:format(Colors.Yellow(value)))
  else
    Addon:Print(L.COMMAND_EXAMPLE_USAGE .. ":")
    print(Colors.Gold("  /lootifications space"), Colors.Yellow(Addon.NOTIFICATION_SPACING_MIN), "-", L.MINIMUM)
    print(Colors.Gold("  /lootifications space"), Colors.Yellow(Addon.NOTIFICATION_SPACING_MAX), "-", L.MAXIMUM)
  end
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
    local state = Addon:GetState()
    for i = 1, state.maxNotifications do
      local colorIndex = ((i - 1) % #COLOR_CODES) + 1
      local colorCode = COLOR_CODES[colorIndex]
      local text = WrapTextInColorCode(("[%s %s]"):format(ADDON_NAME, i), colorCode)
      NotificationManager:NotifyWithIcon(Addon.ICON, text)
    end
  end
end
