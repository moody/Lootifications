# Changelog

## [2.0.0] - Unreleased

### Breaking

- Settings were reset.

### Added

- Added the `/lootif` slash command as a short form of `/lootifications`.
- Added `/lootifications test`, which shows a few test notifications, and `/lootifications help`, which lists the commands.
- Added Direction (down or up) and Alignment (left, center or right) options for the notifications, and a Reset to Defaults button.
- Added a Log tab to the options window. It lists the items and money looted this session, newest first, with each entry's quantity and age. Hovering an item shows its tooltip. The log is not saved between sessions.
- Added item and money totals to the Log tab, and a Clear Log button that empties the log.

### Changed

- Notifications use fixed values: at most 5 at a time (was 10 by default), 3 seconds before fading, 4 pixels apart, and 30% background opacity.
- Notifications fade in more slowly and appear 0.15 seconds apart.
- The options window has Log and Settings tabs, and opens on the Log tab.
- The notification anchor shows, with sample notifications, while the Settings tab of the options window is open. Drag it to move the notifications, and right-click it to reset its position.

### Removed

- Removed the Max Notifications, Notification Alpha, Notification Fade-Out Delay, and Notification Spacing options.
- Removed the Toggle Anchor and Test Notifications buttons.
