local ADDON_NAME = ... ---@type string
local Addon = select(2, ...) ---@type Addon
local B = Addon:GetModule("Blizzard")
local Colors = Addon:GetModule("Colors")
local TickerManager = Addon:GetModule("TickerManager")
local Widgets = Addon:GetModule("Widgets")

--- @class ComponentFactory
local ComponentFactory = Addon:GetModule("ComponentFactory")

-- =============================================================================
-- LuaCATS Annotations
-- =============================================================================

--- @class WindowComponentOptions
--- @field name string Used for the frame's name, gets prefixed with `Lootifications_`.
--- @field width integer
--- @field height integer
--- @field titleText string
--- @field frameStrata? FrameStrata Defaults to `HIGH`.
--- @field refresh? fun() Called repeatedly while the window is visible.
--- @field getPoint fun(): table Returns the point the window is placed at.
--- @field setPoint fun(point: table) Called with the new point when the window is dropped.
--- @field onResetPoint fun() Called when the window is Shift and right-clicked.

-- =============================================================================
-- ComponentFactory - Window
-- =============================================================================

--- Creates a draggable floating window with a title bar and close button. It is placed at the point from `getPoint`,
--- Shift and right-click resets that point, and ESC closes it.
--- @param options WindowComponentOptions
--- @return WindowComponent root
function ComponentFactory:Window(options)
  local root

  --- @class WindowComponent : WaffleFlexComponent
  --- @field TitleRow WaffleFlexComponent
  --- @field TitleText WaffleFlexComponent
  --- @field CloseButton WaffleFlexComponent
  root = Addon.Waffle:Flex({
    width = options.width,
    height = options.height,
    direction = "COLUMN",
    visibility = "GONE",

    defaultFrameFactory = function(parent)
      return Widgets:Frame({ parent = parent, backdrop = false, clipChildren = false })
    end,

    frameFactory = function()
      local frame = Widgets:Frame({
        name = ADDON_NAME .. "_" .. options.name,
        enableClickHandling = true,
        enableDragging = true,
        frameStrata = options.frameStrata or "HIGH"
      })

      frame:SetClickHandler("RightButton", "SHIFT", options.onResetPoint)

      Widgets:ConfigureForPointSync({
        frame = frame,
        getPoint = options.getPoint,
        setPoint = options.setPoint
      })

      -- Close on ESC.
      table.insert(UISpecialFrames, frame:GetName())

      frame:Hide()
      frame:HookScript("OnHide", function()
        root:SetVisibility("GONE")
      end)

      -- Bind the refresh callback to the root frame, if given.
      if options.refresh then
        TickerManager:NewTicker(1 / 30, options.refresh):BindFrame(frame)
      end

      return frame
    end
  })

  root.TitleRow = root:AddRow({
    height = 32,
    paddingLeft = Widgets:Padding(),
    frameFactory = function(parent)
      local frame = Widgets:Frame({ parent = parent })
      frame:SetBackdropColor(Colors.DarkGrey:GetRGB())
      return frame
    end
  })

  root.TitleText = root.TitleRow:AddChild({
    --- @param parent Frame
    frameFactory = function(parent)
      local fontString = parent:CreateFontString("$parent_TitleText", "ARTWORK", B.FontObjects.Large:GetName())
      fontString:SetWordWrap(false)
      fontString:SetJustifyH("LEFT")
      fontString:SetText(options.titleText)
      return fontString
    end
  })

  root.CloseButton = root.TitleRow:AttachComponent(
    ComponentFactory:IconButton({
      name = "$parent_CloseButton",
      icon = Addon:GetAsset("x-icon"),
      iconSize = 14,
      highlightColor = Colors.Red,
      onClick = function()
        root:SetVisibility("GONE")
        root:Layout()
      end
    })
  )

  return root
end
