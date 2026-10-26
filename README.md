# K5-HUB Anime Dice

K5-HUB frontend for an authorized Anime Dice-style experience. Uses the Airflow UI pattern and K5-HUB logo.

## Files
- `LOADER.lua` — stable loader in the repository root.
- `all map/K5_AnimeDice.lua` — main UI and feature controls.

## Raw links
- Stable loader: https://raw.githubusercontent.com/frilshiaputri-cmd/ROBLOXx/main/LOADER.lua
- Main script: https://raw.githubusercontent.com/frilshiaputri-cmd/ROBLOXx/main/all%20map/K5_AnimeDice.lua

## Feature groups
- Auto Farm: Auto Roll, Auto Collect, Auto Equip Best Units, Auto Level Up, Auto Level Target, Kaitun Full Auto
- Economy: Auto Buy Dice, Auto Equip Best Dice, Auto Buy Upgrades, Auto Sell, Auto Clear Storage, Auto Rebirth, Rebirth Stats
- Tower: Auto Tower, Auto Difficulty, Auto Reset Team
- Units: Auto Grade, Auto Trait, Auto Fuse, Auto Lock, Auto Gear
- Rewards: Redeem All Codes, Daily, Group, Offline Earnings, Quest Claim, Potion, Spin, Gamepass Items, Ticket Shop
- Utilities: Anti-AFK, Disable Cutscenes, Auto Rejoin, Rare Notifications, Discord Webhook Notifications

## Backend contract
The UI sends feature requests to:
- `ReplicatedStorage.K5AnimeDiceRemotes.Request` (RemoteEvent)
- Optional status channel: `ReplicatedStorage.K5AnimeDiceRemotes.Status` (RemoteEvent)

Payload example:
```lua
{
  feature = "AutoRoll",
  enabled = true,
  extra = {},
  client = "K5-HUB",
  version = 1
}
```

This repository contains the client UI and loader. A game-specific server controller is still required for an experience you own or are authorized to develop. The UI does not guess private remotes or claim gameplay automation is already implemented. Server code must validate requests, enforce cooldowns and permissions, and never trust the client to grant currency, items, levels, or rewards.

Without the backend adapter, the UI loads but reports that the backend is missing.
