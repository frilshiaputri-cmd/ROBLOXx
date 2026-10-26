-- K5-HUB | Anime Dice feature panel (authorized-game adapter)
-- UI is based on the Airflow interface already used in IronCodexFarm.
-- IMPORTANT: this client panel only sends requests to a server API owned by your game.
-- It does not guess or invoke private remotes from third-party games.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    error("[K5-HUB Anime Dice] LocalPlayer unavailable")
end

local AIRFLOW_URL = "https://raw.githubusercontent.com/joustingmatch/-3/refs/heads/main/Source.luau"
local LOGO = "rbxassetid://115820469332666"
local API_FOLDER_NAME = "K5AnimeDiceRemotes"
local REQUEST_EVENT_NAME = "Request"
local STATUS_EVENT_NAME = "Status"

local ok, Airflow = pcall(function()
    local source = game:HttpGet(AIRFLOW_URL)
    assert(type(source) == "string" and #source > 0, "Airflow source is empty")
    local loader, compileError = loadstring(source)
    assert(loader, compileError or "Airflow compile failed")
    return loader()
end)
if not ok or not Airflow then
    warn("[K5-HUB Anime Dice] UI failed to load:", Airflow)
    return
end

local Window = Airflow:CreateWindow({
    Name = "K5-HUB",
    LoadingSubtitle = "Anime Dice • Feature Controller",
    Icon = LOGO,
    ToggleUIKeybind = "RightShift",
    Backdrop = {Weather = "None", Tint = 0.45},
    AdaptiveSize = false,
    UIScale = 1,
    Density = "Default",
    Size = UDim2.fromOffset(700, 430),
    ConfigurationSaving = {Enabled = true, FolderName = "K5HUB_AnimeDice"},
})

local MainTab = Window:CreateTab({Name = "Main", Icon = "house"})
local FarmTab = Window:CreateTab({Name = "Auto Farm", Icon = "zap"})
local EconomyTab = Window:CreateTab({Name = "Economy", Icon = "coins"})
local TowerTab = Window:CreateTab({Name = "Tower", Icon = "castle"})
local UnitsTab = Window:CreateTab({Name = "Units", Icon = "users"})
local RewardsTab = Window:CreateTab({Name = "Rewards", Icon = "gift"})
local UtilityTab = Window:CreateTab({Name = "Utilities", Icon = "settings"})
local SettingsTab = Window:CreateTab({Name = "Settings", Icon = "sliders-horizontal"})

local StatusGroup = MainTab:CreateGroupbox({Name = "Connection Status", Side = "Left"})
local InfoGroup = MainTab:CreateGroupbox({Name = "About", Side = "Right"})
local statusLabel = StatusGroup:CreateLabel("Backend: checking...")
InfoGroup:CreateParagraph({
    Title = "K5-HUB Anime Dice",
    Content = "UI controls are connected to the K5AnimeDiceRemotes server adapter. For security, game actions only work when that adapter is implemented in an experience you own or are authorized to develop.",
})

local function notify(title, message)
    pcall(function()
        Window:Notify({Title = title, Content = tostring(message), Duration = 4})
    end)
end

local apiFolder = ReplicatedStorage:FindFirstChild(API_FOLDER_NAME)
local requestEvent = apiFolder and apiFolder:FindFirstChild(REQUEST_EVENT_NAME)
local statusEvent = apiFolder and apiFolder:FindFirstChild(STATUS_EVENT_NAME)

local function refreshStatus()
    apiFolder = ReplicatedStorage:FindFirstChild(API_FOLDER_NAME)
    requestEvent = apiFolder and apiFolder:FindFirstChild(REQUEST_EVENT_NAME)
    statusEvent = apiFolder and apiFolder:FindFirstChild(STATUS_EVENT_NAME)
    local connected = requestEvent and requestEvent:IsA("RemoteEvent")
    pcall(function()
        statusLabel:Set(connected and "Backend: connected" or "Backend: not installed")
    end)
    return connected == true
end

local function request(feature, enabled, extra)
    if not refreshStatus() then
        notify("Backend belum tersedia", "UI aktif, tetapi aksi game memerlukan K5AnimeDiceRemotes.Request pada game milikmu.")
        return false
    end
    local payload = {
        feature = feature,
        enabled = enabled == true,
        extra = extra or {},
        client = "K5-HUB",
        version = 1,
    }
    local sent, err = pcall(function()
        requestEvent:FireServer(payload)
    end)
    if not sent then
        warn("[K5-HUB Anime Dice] Request failed:", feature, err)
        notify("Request gagal", feature .. ": " .. tostring(err))
        return false
    end
    return true
end

if statusEvent and statusEvent:IsA("RemoteEvent") then
    statusEvent.OnClientEvent:Connect(function(message)
        if type(message) == "table" and message.message then
            notify("K5-HUB Status", tostring(message.message))
        elseif type(message) == "string" then
            notify("K5-HUB Status", message)
        end
    end)
end

local function addFeature(group, name, featureKey, description)
    group:CreateToggle({
        Name = name,
        Flag = "K5AD_" .. featureKey,
        Default = false,
        Callback = function(value)
            request(featureKey, value == true)
        end,
    })
end

local function addGroup(tab, name, side)
    return tab:CreateGroupbox({Name = name, Side = side or "Left"})
end

-- Auto Farm
local roll = addGroup(FarmTab, "Rolling", "Left")
addFeature(roll, "Auto Roll", "AutoRoll", "Request automatic rolling.")
addFeature(roll, "Auto Collect", "AutoCollect", "Request automatic collection.")
addFeature(roll, "Auto Equip Best Units", "AutoEquipBestUnits", "Request best-unit placement.")
addFeature(roll, "Auto Level Up", "AutoLevelUp", "Request automatic unit leveling.")
addFeature(roll, "Auto Level Target", "AutoLevelTarget", "Request target-level leveling.")
addFeature(roll, "Kaitun Full Auto", "Kaitun", "Request the combined farming routine.")

-- Economy and storage
local economy = addGroup(EconomyTab, "Economy", "Left")
addFeature(economy, "Auto Buy Dice", "AutoBuyDice")
addFeature(economy, "Auto Equip Best Dice", "AutoEquipBestDice")
addFeature(economy, "Auto Buy Upgrades", "AutoBuyUpgrades")
addFeature(economy, "Auto Sell by Filter", "AutoSell")
addFeature(economy, "Auto Clear Storage", "AutoClearStorage")
addFeature(economy, "Auto Rebirth", "AutoRebirth")
addFeature(economy, "Auto Spend Rebirth Stats", "AutoRebirthStats")

-- Tower
local tower = addGroup(TowerTab, "Tower Controller", "Left")
addFeature(tower, "Auto Tower", "AutoTower")
addFeature(tower, "Auto Difficulty", "AutoDifficulty")
addFeature(tower, "Auto Reset Team", "AutoResetTeam")

-- Unit development
local units = addGroup(UnitsTab, "Unit Development", "Left")
addFeature(units, "Auto Grade", "AutoGrade")
addFeature(units, "Auto Trait", "AutoTrait")
addFeature(units, "Auto Fuse", "AutoFuse")
addFeature(units, "Auto Lock Units", "AutoLock")
addFeature(units, "Auto Gear", "AutoGear")

-- Rewards
local rewards = addGroup(RewardsTab, "Rewards & Codes", "Left")
addFeature(rewards, "Redeem All Codes", "RedeemAllCodes")
addFeature(rewards, "Auto Daily Reward", "AutoDaily")
addFeature(rewards, "Auto Group Reward", "AutoGroupReward")
addFeature(rewards, "Auto Offline Earnings", "AutoOfflineEarnings")
addFeature(rewards, "Auto Claim Quests", "AutoQuestClaim")
addFeature(rewards, "Auto Potion", "AutoPotion")
addFeature(rewards, "Auto Spin", "AutoSpin")
addFeature(rewards, "Auto Use Gamepass Items", "AutoGamepassItems")
addFeature(rewards, "Auto Ticket Shop", "AutoTicketShop")

-- Utilities are requested through the same authorized server adapter so the server
-- can validate values and restore original state safely.
local utilities = addGroup(UtilityTab, "Player & Session", "Left")
addFeature(utilities, "Anti-AFK", "AntiAFK")
addFeature(utilities, "Disable Cutscenes", "DisableCutscenes")
addFeature(utilities, "Auto Rejoin", "AutoRejoin")
addFeature(utilities, "Rare Drop Notifications", "RareNotifications")
addFeature(utilities, "Discord Webhook Notifications", "DiscordWebhookNotifications")

local settings = addGroup(SettingsTab, "Connection", "Left")
settings:CreateButton({
    Name = "Check Backend",
    Callback = function()
        local connected = refreshStatus()
        notify("K5-HUB", connected and "Backend ditemukan." or "Backend belum terpasang.")
    end,
})
settings:CreateButton({
    Name = "Stop All Features",
    Callback = function()
        if not refreshStatus() then
            notify("K5-HUB", "Backend belum tersedia; tidak ada request yang dikirim.")
            return
        end
        requestEvent:FireServer({feature = "StopAll", enabled = false, extra = {}, client = "K5-HUB", version = 1})
        notify("K5-HUB", "Permintaan Stop All dikirim.")
    end,
})

refreshStatus()
print("[K5-HUB Anime Dice] UI loaded. Press RightShift to show/hide.")
