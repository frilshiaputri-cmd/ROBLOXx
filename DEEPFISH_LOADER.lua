-- K5-HUB | DeepFish loader for ROBLOXx
local URL = "https://raw.githubusercontent.com/frilshiaputri-cmd/ROBLOXx/main/all%20map/K5_DeepFish.lua"
local ok, source = pcall(function() return game:HttpGet(URL) end)
if not ok or type(source) ~= "string" or source == "" then
    warn("[K5-HUB DeepFish Loader] Gagal mengambil K5_DeepFish.lua: " .. tostring(source))
    return
end
local compiled, chunk = pcall(loadstring, source)
if not compiled or type(chunk) ~= "function" then
    warn("[K5-HUB DeepFish Loader] Gagal compile: " .. tostring(chunk))
    return
end
local ran, err = pcall(chunk)
if not ran then warn("[K5-HUB DeepFish Loader] Runtime error: " .. tostring(err)) end
