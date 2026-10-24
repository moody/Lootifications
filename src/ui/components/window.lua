local ADDON_NAME = ... ---@type string
local Addon = select(2, ...) ---@type Addon
local Colors = Addon:GetModule("Colors")
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

-- =============================================================================
-- ComponentFactory - Window
-- =============================================================================

--- Creates a draggable floating window with a title bar and close button. It starts in the center of the screen,
--- and ESC closes it.
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
        enableDragging = true,
        frameStrata = options.frameStrata or "HIGH"
      })
      frame:SetPoint("CENTER")

      -- Close on ESC.
      table.insert(UISpecialFrames, frame:GetName())

      frame:Hide()
      frame:HookScript("OnHide", function()
        root:SetVisibility("GONE")
      end)

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
      local fontString = parent:CreateFontString("$parent_TitleText", "ARTWORK", "GameFontNormalLarge")
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
