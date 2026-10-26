# K5-HUB Anime Dice

K5-HUB frontend for an authorized Anime Dice-style experience. The UI uses the Airflow interface pattern already used in the owner's IronCodexFarm project and the K5-HUB logo.

## File
- `K5_AnimeDice.lua` — UI tabs, all feature toggles, backend status, and Stop All request.

## Feature groups
- Auto Farm: Auto Roll, Auto Collect, Auto Equip Best Units, Auto Level Up, Auto Level Target, Kaitun Full Auto
- Economy: Auto Buy Dice, Auto Equip Best Dice, Auto Buy Upgrades, Auto Sell, Auto Clear Storage, Auto Rebirth, Rebirth Stats
- Tower: Auto Tower, Auto Difficulty, Auto Reset Team
- Units: Auto Grade, Auto Trait, Auto Fuse, Auto Lock, Auto Gear
- Rewards: Redeem All Codes, Daily, Group, Offline Earnings, Quest Claim, Potion, Spin, Gamepass Items, Ticket Shop
- Utilities: Anti-AFK, Disable Cutscenes, Auto Rejoin, Rare Notifications, Discord Webhook Notifications

## Important: backend contract
Every toggle is wired to send a request to a server adapter at:
- `ReplicatedStorage.K5AnimeDiceRemotes.Request` (RemoteEvent)
- Optional status channel: `ReplicatedStorage.K5AnimeDiceRemotes.Status` (RemoteEvent)

Payload shape:
```lua
{
  feature = "AutoRoll",
  enabled = true,
  extra = {},
  client = "K5-HUB",
  version = 1
}
```

This repository currently contains the client UI only. A game-specific server controller must be written for an experience you own or are authorized to develop. The UI intentionally does not guess private remotes or claim gameplay automation is already implemented. Server code should validate every request, enforce cooldowns and player permissions, and never trust the client to grant currency, items, levels, or rewards.

## Use
Run the file in a compatible Roblox Lua environment for UI testing. Without the server adapter, the UI will still load and show that the backend is missing; gameplay toggles will notify you rather than silently pretending to work.
