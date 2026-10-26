-- K5-HUB | Unified stable loader
-- URL loader ini tetap: https://raw.githubusercontent.com/frilshiaputri-cmd/ROBLOXx/main/LOADER.lua
-- Deteksi Foresters melalui modul Lumber/Knit; selain itu muat panel Anime Dice.
-- Pastikan hanya digunakan di experience yang kamu miliki atau punya izin untuk mengembangkan.

local SOURCES = {
    Foresters = "https://raw.githubusercontent.com/frilshiaputri-cmd/Foresters/main/farm_hub.lua",
    AnimeDice = "https://raw.githubusercontent.com/frilshiaputri-cmd/ROBLOXx/main/all%20map/K5_AnimeDice.lua",
}

local function isForesters()
    local ok, result = pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        local modules = rs:FindFirstChild("Modules")
        local lumber = modules and modules:FindFirstChild("Lumber")
        local packages = rs:FindFirstChild("Packages")
        local knit = packages and packages:FindFirstChild("Knit")
        return lumber ~= nil and knit ~= nil
    end)
    return ok and result == true
end

local targetName = isForesters() and "Foresters" or "AnimeDice"
local targetUrl = SOURCES[targetName]

local ok, err = pcall(function()
    local source = game:HttpGet(targetUrl)
    assert(type(source) == "string" and #source > 0, targetName .. " raw script kosong atau tidak tersedia")

    local chunk, compileError = loadstring(source)
    assert(type(chunk) == "function", compileError or ("Gagal compile " .. targetName))

    chunk()
end)

if not ok then
    warn("[K5-HUB Unified Loader] " .. targetName .. " gagal dimuat: " .. tostring(err))
end
