-- K5-HUB | Stable loader
-- Keep this file at repository root so the loader raw URL stays unchanged.
local SCRIPT_URL = "https://raw.githubusercontent.com/frilshiaputri-cmd/ROBLOXx/main/all%20map/K5_AnimeDice.lua"

local ok, err = pcall(function()
    local source = game:HttpGet(SCRIPT_URL)
    assert(type(source) == "string" and #source > 0, "K5-HUB script is empty or unavailable")

    local chunk, compileError = loadstring(source)
    assert(type(chunk) == "function", compileError or "Could not compile K5-HUB script")

    chunk()
end)

if not ok then
    warn("[K5-HUB Loader] Failed to load:", tostring(err))
end
