# Changelog

## [2.0.0] - Unreleased

### Breaking

- Settings were reset.

### Added

- Added a Log tab to the options window, which starts on it. It lists the items and money looted this session, newest first, with each entry's quantity or amount and how long ago it was, and shows item and money totals. Hovering an item shows its tooltip, and Clear Log empties the log. The log is not saved between sessions.
- Added a minimap icon. Left-click toggles the Log and right-click toggles the Settings. The Minimap Icon option in the Settings hides it.
- Added Direction (down or up) and Alignment (left, center or right) options for the notifications, which were chosen by where the anchor was placed, and a Reset to Defaults button.
- Added a Text Size option for the notifications, a slider from 8 to 32 pixels.
- Added a Background option for the notifications: None, Subtle (as before), or High Contrast, which darkens the background and colors the border by item quality, or by the largest coin for money.
- The options window remembers where it was moved. Shift and right-click on it resets its position.
- Added the `/lootif` slash command as a short form of `/lootifications`.
- Added `/lootifications help`, which lists the commands.

### Changed

- Notifications show at most 5 at a time (was 10 by default) and are spaced to fit the text size, 6 pixels apart at the default size (was 4).
- Notifications fade in more slowly and appear 0.15 seconds apart. They slide in toward the stack, the others glide into their new places instead of jumping, and each drifts a little as it fades out.
- The notification anchor shows, with sample notifications that play in a loop, while the Settings tab is open, in place of the Toggle Anchor button. Right-click on the anchor resets its position instead of hiding it.
- Renamed the Money Notifications option to Money, Loot Prices to Item Prices, and Owned Item Counts to Bag Counts.

### Removed

- Removed the Max Notifications, Notification Alpha, Notification Fade-Out Delay, and Notification Spacing options.
- Removed the Toggle Anchor and Test Notifications buttons.
