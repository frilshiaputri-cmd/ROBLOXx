-- K5-HUB | DeepFish (Airflow UI)
-- UI/config scaffold only. Fishing automation is intentionally not connected.
-- The original AHK macro depends on Windows pixel capture and input injection;
-- those systems are not directly portable to Luau/Roblox.

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local AIRFLOW_URL = "https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"
local okLibrary, Airflow = pcall(function()
    return loadstring(game:HttpGet(AIRFLOW_URL))()
end)
if not okLibrary or type(Airflow) ~= "table" then
    warn("[K5-DeepFish] Airflow UI gagal dimuat: " .. tostring(Airflow))
    return
end

local previous = getgenv().__K5DeepFishWindow
if previous and type(previous.Destroy) == "function" then
    pcall(function() previous:Destroy() end)
end

local State = {
    Running = false,
    AutoFish = false,
    AutoCast = false,
    AutoShake = false,
    AutoReel = false,
    AutoSell = false,
    LowerGraphics = false,
    CameraHelper = false,
    UnstickHelper = false,
}
getgenv().__K5DeepFishState = State

local Window = Airflow:CreateWindow({
    Name = "K5-HUB",
    LoadingSubtitle = "DeepFish • Fisch",
    Icon = "rbxassetid://115820469332666",
    ToggleUIKeybind = "RightShift",
    Backdrop = {Weather = "None", Tint = 0.45},
    AdaptiveSize = false,
    UIScale = 1,
    Density = "Default",
    Size = UDim2.fromOffset(700, 430),
    ConfigurationSaving = {Enabled = true, FolderName = "K5DeepFish"},
})
getgenv().__K5DeepFishWindow = Window

local function addTab(name, icon)
    return Window:CreateTab({Name = name, Icon = icon})
end

local dashboard = addTab("Dashboard", "fish")
local general = addTab("General", "sliders-horizontal")
local minigame = addTab("Minigame", "gamepad-2")
local utilities = addTab("Utilities", "wrench")
local config = addTab("Config", "settings")
local about = addTab("About", "info")

local function section(tab, title)
    pcall(function() tab:Section({Name = title}) end)
end
local function paragraph(tab, title, body)
    pcall(function() tab:Paragraph({Name = title, Content = body}) end)
end
local function toggle(tab, title, key, desc)
    tab:Toggle({
        Name = title,
        Desc = desc,
        Flag = "DeepFish_" .. key,
        Default = State[key] == true,
        Callback = function(value)
            State[key] = value == true
        end,
    })
end

section(dashboard, "Fishing controls")
paragraph(dashboard, "Port status", "Airflow UI is connected. Toggles currently store local settings only; cast, shake, reel, and fish detection are not implemented in this Luau scaffold.")
toggle(dashboard, "Enable module", "Running", "Master UI switch; does not start an automation loop.")
toggle(dashboard, "Auto Fish", "AutoFish", "Placeholder until permitted game-state signals are verified.")
toggle(dashboard, "Auto Cast", "AutoCast", "Separate setting; does not enable other toggles.")
toggle(dashboard, "Auto Shake", "AutoShake", "Shake prompt detection is not connected.")
toggle(dashboard, "Auto Reel / Minigame", "AutoReel", "Minigame detection/controller is not connected.")

section(general, "General settings")
toggle(general, "Auto Sell", "AutoSell", "Placeholder; selling interaction is not connected.")
toggle(general, "Lower graphics", "LowerGraphics", "Setting only; no graphics changes are applied.")
toggle(general, "Camera helper", "CameraHelper", "Placeholder; no camera changes are applied.")
toggle(general, "Unstick helper", "UnstickHelper", "Placeholder; no movement recovery is applied.")
paragraph(general, "Compatibility", "This UI uses the same Airflow library source and window pattern as the Foresters repository.")

section(minigame, "Minigame controller")
paragraph(minigame, "Precision mode", "Not ported. The AHK version reads desktop pixels; this Luau file does not have that same desktop capture pipeline.")
paragraph(minigame, "Line mode", "Not connected. Requires a legitimate, verified in-game state interface.")
paragraph(minigame, "Color calibration", "No pixel sampling or mouse injection is performed by this scaffold.")

section(utilities, "Utilities")
paragraph(utilities, "Totem / Aquarium / Keeperbound", "Not ported. These actions require separate game-specific verification.")
paragraph(utilities, "Webhook", "Webhook support is omitted. Do not put private webhook URLs or tokens in a client-side script.")

section(config, "Configuration")
config:Button({
    Name = "Print config JSON",
    Callback = function()
        local snapshot = {Version = 1, Toggles = {}}
        for key, value in pairs(State) do
            if type(value) == "boolean" then snapshot.Toggles[key] = value end
        end
        print("[K5-DeepFish] Config:", HttpService:JSONEncode(snapshot))
    end,
})
config:Button({
    Name = "Copy config JSON",
    Callback = function()
        local snapshot = {Version = 1, Toggles = {}}
        for key, value in pairs(State) do
            if type(value) == "boolean" then snapshot.Toggles[key] = value end
        end
        local encoded = HttpService:JSONEncode(snapshot)
        if typeof(setclipboard) == "function" then
            local copied = pcall(setclipboard, encoded)
            if not copied then warn("[K5-DeepFish] Clipboard gagal; gunakan Print config JSON.") end
        else
            print("[K5-DeepFish] Config:", encoded)
        end
    end,
})

section(about, "About K5-HUB DeepFish")
paragraph(about, "Implemented", "Airflow window, tabs, toggles, and JSON config export.")
paragraph(about, "Not implemented", "Auto fishing, cast timing, shake detection, reel/minigame tracking, pixel capture, and special-rod routines.")
paragraph(about, "Usage note", "Use only in an experience you own or are authorized to develop. This file is a UI/configuration shell, not a working fishing bot.")

pcall(function() Window:Notify({Title = "K5-HUB", Content = "DeepFish Airflow UI loaded", Duration = 4}) end)
print("[K5-DeepFish] Airflow UI loaded; automation is not connected.")
