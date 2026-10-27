local ADDON_NAME = ... ---@type string
local Addon = select(2, ...) ---@type Addon
local ActionCreators = Addon:GetModule("ActionCreators")
local Colors = Addon:GetModule("Colors")
local E = Addon:GetModule("Events")
local EventManager = Addon:GetModule("EventManager")
local L = Addon:GetModule("Locale")
local StateManager = Addon:GetModule("StateManager")
local LDB = Addon:GetLibrary("LibDataBroker-1.1")
local LDBIcon = Addon:GetLibrary("LibDBIcon-1.0")
local MainWindow = Addon:GetModule("MainWindow")
local TickerManager = Addon:GetModule("TickerManager")

-- ============================================================================
-- Local Functions
-- ============================================================================

--- Returns a tooltip line for a click and what it does.
--- @param click string
--- @param action string
--- @return string
local function getTooltipLine(click, action)
  return Colors.Grey("- %s: %s"):format(Colors.Gold(click), Colors.White(action))
end

-- ============================================================================
-- Events
-- ============================================================================

-- Register the minimap icon once the store exists, since LibDBIcon reads the saved table right away.
EventManager:Once(E.StoreInitialized, function()
  local logLine = getTooltipLine(L.LEFT_CLICK, L.LOG)
  local settingsLine = getTooltipLine(L.RIGHT_CLICK, L.SETTINGS)

  local object = LDB:NewDataObject(ADDON_NAME, {
    type = "data source",
    text = ADDON_NAME,
    icon = Addon.ICON,

    OnClick = function(_, button)
      if button == "LeftButton" then
        MainWindow:Toggle("LOG")
      elseif button == "RightButton" then
        MainWindow:Toggle("SETTINGS")
      end
    end,

    OnTooltipShow = function(tooltip)
      tooltip:AddDoubleLine(Colors.Purple(ADDON_NAME), Colors.Grey(Addon.VERSION))
      tooltip:AddLine(logLine)
      tooltip:AddLine(settingsLine)
    end
  })

  --- Changes waiting to be saved.
  local patch = {}

  local savePatch = TickerManager:NewDebouncer(0.2, function()
    StateManager:Dispatch(ActionCreators.MinimapIcon.patch(patch))
    for key in pairs(patch) do patch[key] = nil end
  end)

  -- LibDBIcon writes `minimapPos` on every frame while the icon is dragged, so the writes are debounced into one
  -- patch of the state.
  local db = setmetatable({}, {
    __index = function(_, key)
      return StateManager:GetGlobalState().minimapIcon[key]
    end,
    __newindex = function(_, key, value)
      patch[key] = value
      savePatch()
    end
  })

  LDBIcon:Register(ADDON_NAME, object, db)

  EventManager:On(E.StateUpdated, function()
    LDBIcon:Refresh(ADDON_NAME, db)
  end)
end)
