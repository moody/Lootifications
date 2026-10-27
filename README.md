# Lootifications

Lootifications is an addon for World of Warcraft that shows notifications for loot and money, and keeps a log of them.

![Notifications](/.github/images/Lootifications.gif?raw=true)

## Features

- Notifications for items and money, with the item's icon and quantity
- Optional vendor price and bag count in item notifications
- Choose which way the notifications grow and how they line up, and drag them anywhere on the screen
- A log of the items and money looted this session, with totals
- A minimap icon and chat commands

### Options

The options are on the `Settings` tab of the main window. The window remembers where you move it, and Shift and right-click on it resets its position.

- **Money** — Show a notification when money is looted or received
- **Item Prices** — Include the vendor price of items in loot notifications
- **Bag Counts** — Include how many of the item are in your bags in loot notifications
- **Text Size** — The size of the notification text: small, medium, large, or huge
- **Background** — The background and border of the notifications:
  - `None`: no background or border
  - `Subtle`: a faint background and border, both 30% opaque
  - `High Contrast`: a 95% opaque background, and a solid border in the item's quality color, or the color of the largest coin for money
- **Direction** — Grow down from the anchor's top or up from its bottom
- **Alignment** — Line the notifications up to the left, center, or right
- **Minimap Icon** — Show an icon on the minimap

`Reset to Defaults` resets every option and the anchor's position.

![Settings](/.github/images/Settings.png?raw=true)

### Anchor

The anchor is where the notifications appear. While the `Settings` tab is open, it plays sample notifications in a loop. Drag it to move the notifications, and right-click it to reset its position. Loot notifications are not shown meanwhile, but the loot is still recorded in the log.

![Anchor](/.github/images/Anchor.png?raw=true)

### Log

The `Log` tab, which the main window starts on, lists the items and money looted this session, newest first.

- Each item shows its icon, link, quantity, and how long ago it was looted, and hovering it shows its tooltip
- A bar under the list shows the total number of items, counting each item in a stack, and the total money
- `Clear Log` empties the list and the totals
- The log is not saved between sessions

![Log](/.github/images/Log.png?raw=true)

### Minimap Icon

- Left-click toggles the `Log`
- Right-click toggles the `Settings`

The `Minimap Icon` option hides it.

## Chat Commands

`/lootif` can be used in place of `/lootifications`.

```bash
# Toggle the main window.
/lootifications

# Display a list of commands.
/lootifications help
```

## Credit

### Art

- [Card pickup icon](https://game-icons.net/1x1/quoting/card-pickup.html) by Quoting under [CC BY 3.0](http://creativecommons.org/licenses/by/3.0/).

### Libraries

- [CallbackHandler-1.0](https://www.wowace.com/projects/callbackhandler)
- [LibDataBroker-1.1](https://www.wowace.com/projects/libdatabroker-1-1)
- [LibDBIcon-1.0](https://www.wowace.com/projects/libdbicon-1-0)
- [LibStub](https://www.wowace.com/projects/libstub)
- [Waffle](https://github.com/moody/Waffle)
- [Wux](https://github.com/moody/Wux)

## License

[MIT](LICENSE)
