local Addon = select(2, ...) ---@type Addon
local ActionTypes = Addon:GetModule("ActionTypes")
local DefaultStates = Addon:GetModule("DefaultStates")
local Wux = Addon.Wux

--- @class RootReducer
local RootReducer = Addon:GetModule("RootReducer")

--- @class LootificationsRootState
--- @field version integer
--- @field global GlobalState

--- Builds the reducer of the whole state.
--- @return WuxReducer<LootificationsRootState, any>
function RootReducer:Build()
  local defaultState = DefaultStates.Global

  return Wux:CombineReducers({
    -- Not dispatched; `version` is set by `Migrations:Migrate()` before store creation.
    version = function(state)
      return Wux:Coalesce(state, DefaultStates.CURRENT_VERSION)
    end,

    --- @type WuxReducer<GlobalState, any>
    global = Wux:CombineReducers({
      --- @type WuxReducer<NotificationsState, any>
      notifications = Wux:CombineReducers({
        -- Money.
        money = function(state, action)
          state = Wux:Coalesce(state, defaultState.notifications.money)

          if action.type == ActionTypes.Notifications.TOGGLE_MONEY then
            state = not state
          elseif action.type == ActionTypes.Notifications.RESET_MONEY then
            state = defaultState.notifications.money
          end

          return state
        end,

        -- Item prices.
        itemPrices = function(state, action)
          state = Wux:Coalesce(state, defaultState.notifications.itemPrices)

          if action.type == ActionTypes.Notifications.TOGGLE_ITEM_PRICES then
            state = not state
          elseif action.type == ActionTypes.Notifications.RESET_ITEM_PRICES then
            state = defaultState.notifications.itemPrices
          end

          return state
        end,

        -- Bag counts.
        bagCounts = function(state, action)
          state = Wux:Coalesce(state, defaultState.notifications.bagCounts)

          if action.type == ActionTypes.Notifications.TOGGLE_BAG_COUNTS then
            state = not state
          elseif action.type == ActionTypes.Notifications.RESET_BAG_COUNTS then
            state = defaultState.notifications.bagCounts
          end

          return state
        end,

        -- Notification background.
        background = function(state, action)
          state = Wux:Coalesce(state, defaultState.notifications.background)

          if action.type == ActionTypes.Notifications.SET_BACKGROUND then
            state = action.payload
          elseif action.type == ActionTypes.Notifications.RESET_BACKGROUND then
            state = defaultState.notifications.background
          end

          return DefaultStates.NOTIFICATION_BACKGROUNDS[state] and state or defaultState.notifications.background
        end
      }),

      --- @type WuxReducer<AnchorFrameState, any>
      anchorFrame = Wux:CombineReducers({
        -- Anchor direction.
        direction = function(state, action)
          state = Wux:Coalesce(state, defaultState.anchorFrame.direction)

          if action.type == ActionTypes.AnchorFrame.SET_DIRECTION then
            state = action.payload
          elseif action.type == ActionTypes.AnchorFrame.RESET_DIRECTION then
            state = defaultState.anchorFrame.direction
          end

          return DefaultStates.ANCHOR_DIRECTIONS[state] and state or defaultState.anchorFrame.direction
        end,

        -- Anchor alignment.
        alignment = function(state, action)
          state = Wux:Coalesce(state, defaultState.anchorFrame.alignment)

          if action.type == ActionTypes.AnchorFrame.SET_ALIGNMENT then
            state = action.payload
          elseif action.type == ActionTypes.AnchorFrame.RESET_ALIGNMENT then
            state = defaultState.anchorFrame.alignment
          end

          return DefaultStates.ANCHOR_ALIGNMENTS[state] and state or defaultState.anchorFrame.alignment
        end,

        -- Anchor point.
        point = function(state, action)
          state = Wux:Coalesce(state, defaultState.anchorFrame.point)

          if action.type == ActionTypes.AnchorFrame.SET_POINT then
            state = action.payload
          elseif action.type == ActionTypes.AnchorFrame.RESET_POINT then
            state = defaultState.anchorFrame.point
          end

          return type(state) == "table" and state or defaultState.anchorFrame.point
        end
      }),

      --- @type WuxReducer<MainWindowState, any>
      mainWindow = Wux:CombineReducers({
        -- Main window point.
        point = function(state, action)
          state = Wux:Coalesce(state, defaultState.mainWindow.point)

          if action.type == ActionTypes.MainWindow.SET_POINT then
            state = action.payload
          elseif action.type == ActionTypes.MainWindow.RESET_POINT then
            state = defaultState.mainWindow.point
          end

          return type(state) == "table" and state or defaultState.mainWindow.point
        end
      }),

      -- Minimap icon.
      minimapIcon = Wux:CreatePatchReducer(ActionTypes.MinimapIcon.PATCH, defaultState.minimapIcon)
    })
  })
end
