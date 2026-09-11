-- =========================================================================
--   🍃 ZAKA HUB - FREE LOADER (NO KEY)
-- =========================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local TargetScriptUrl = "https://raw.githubusercontent.com/robvxs24/freemium/refs/heads/main/script.lua"

-- Load script gốc luôn (free, không key, không trial)
task.spawn(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet(TargetScriptUrl))()
    end)
    if not success then
        warn("[Zaka Hub] Lỗi load script: " .. tostring(err))
    else
        print("[Zaka Hub] Đã load thành công!")
    end
end)
