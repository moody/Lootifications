# Changelog

## [2.0.0] - Unreleased

### Breaking

- Settings were reset.

### Added

- Added a Log tab to the options window, which now opens on it. It lists the items and money looted this session, newest first, with each entry's quantity or amount and how long ago it was. Hovering an item shows its tooltip. The log is not saved between sessions.
- Added item and money totals to the Log tab, and a Clear Log button that empties the log.
- Added a minimap icon. Left-click toggles the Log, right-click toggles the Settings, and Shift and right-click shows test notifications. The Minimap Icon option in the Settings hides it.
- Added Direction (down or up) and Alignment (left, center or right) options for the notifications, which were chosen by where the anchor was placed, and a Reset to Defaults button.
- The options window remembers where it was moved. Shift and right-click on it resets its position.
- Added the `/lootif` slash command as a short form of `/lootifications`.
- Added `/lootifications test`, which shows a few test notifications, and `/lootifications help`, which lists the commands.

### Changed

- Notifications use fixed values: at most 5 at a time (was 10 by default), 3 seconds before fading, 4 pixels apart, and 30% background opacity.
- Notifications fade in more slowly and appear 0.15 seconds apart. They slide in toward the stack, the others glide into their new places instead of jumping, and each drifts a little as it fades out.
- The notification anchor shows, with sample notifications, while the Settings tab is open, in place of the Toggle Anchor button. Drag it to move the notifications, and right-click it to reset its position.
- Renamed the Money Notifications option to Money.

### Removed

- Removed the Max Notifications, Notification Alpha, Notification Fade-Out Delay, and Notification Spacing options.
- Removed the Toggle Anchor and Test Notifications buttons.
