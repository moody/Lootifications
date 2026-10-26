local Addon = select(2, ...) ---@type Addon

--- @class ComponentFactory
local ComponentFactory = Addon:GetModule("ComponentFactory")

-- =============================================================================
-- ComponentFactory - NotificationStack
-- =============================================================================

--- Creates a column of notifications, one for each that can be shown at once. A newer notification is closer to the
--- pinned edge, and one that is not showing keeps its space.
--- @return NotificationStackComponent root
function ComponentFactory:NotificationStack()
  --- @type NotificationComponent[]
  local notifications = {}

  --- Counts the notifications shown, and starts over once none are. A newer notification gets a lower `order`, which
  --- puts it closest to the pinned edge.
  local sequence = 0

  --- @class NotificationStackComponent : WaffleFlexComponent
  local root = Addon.Waffle:Flex({
    direction = "COLUMN",
    gap = 6,
    width = "AUTO",
    height = "AUTO"
  })

  --- The most notifications that the stack shows at once.
  root.MAX_NOTIFICATIONS = 5

  for i = 1, root.MAX_NOTIFICATIONS do
    notifications[i] = root:AttachComponent(ComponentFactory:Notification())
  end

  --- Returns whether a notification is showing.
  --- @return boolean
  function root:IsShowing()
    for _, notification in ipairs(notifications) do
      if notification:IsVisible() then return true end
    end

    return false
  end

  --- Returns whether every notification is showing.
  --- @return boolean
  function root:IsFull()
    for _, notification in ipairs(notifications) do
      if not notification:IsVisible() then return false end
    end

    return true
  end

  --- Shows the entry on a notification that is not showing, and does nothing if there is none.
  --- @param entry HistoryLogEntry?
  --- @param direction AnchorDirection The way the stack grows.
  function root:Show(entry, direction)
    if not self:IsShowing() then sequence = 0 end

    -- A notification that is not showing sorts after the ones that are, which have a negative `order`.
    local freeNotification
    for _, notification in ipairs(notifications) do
      if not notification:IsVisible() then
        notification:SetOrder(0)
        freeNotification = freeNotification or notification
      end
    end

    if freeNotification then
      sequence = sequence + 1
      freeNotification:SetOrder(-sequence)
      freeNotification:Show(entry)
      freeNotification:Animate(direction)
    end
  end

  --- Gives each notification that is not showing the entry at its index, so the stack keeps the size of its rows. Pass
  --- the entries in the order `Show()` will receive them. An index with no entry clears that notification.
  --- @param entries HistoryLogEntry[]
  function root:SetEntries(entries)
    for i, notification in ipairs(notifications) do
      if not notification:IsVisible() then notification:SetEntry(entries[i]) end
    end
  end

  --- Replaces the notifications with the entry at each index, shown without animation until `Clear()` is called. Pass
  --- the entries in the order `Show()` will receive them, so each is placed as it would be.
  --- @param entries HistoryLogEntry[]
  function root:ShowAll(entries)
    self:Clear()

    for i, notification in ipairs(notifications) do
      notification:SetOrder(-i)
      notification:Show(entries[i])
    end
  end

  --- Hides every notification, even while they are animating.
  function root:Clear()
    for _, notification in ipairs(notifications) do
      notification:Kill()
    end
  end

  return root
end
