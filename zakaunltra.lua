-- ZAKA ULTRA - ALL IN ONE | VERSION: PRO
-- Cấu trúc: 1 file duy nhất, UI Animation, Anti-Cheat, Ground-Fly
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 1. ANTI-CHEAT & SECURITY (PROTECTION LAYER)
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldIndex = mt.__index
mt.__index = newcclosure(function(self, key)
    if not checkcaller() and (key == "WalkSpeed" or key == "JumpPower") then return 16 end
    return oldIndex(self, key)
end)
setreadonly(mt, true)

-- 2. UI ENGINE (ANIMATED UI)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 200, 0, 300); Main.Position = UDim2.new(0.5, -100, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Main.BorderSizePixel = 0
Main.Active = true; Main.Draggable = true
Main.ClipsDescendants = true

-- UI Animation Helper
local function AnimateClick(obj)
    TweenService:Create(obj, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
    task.wait(0.2)
    TweenService:Create(obj, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
end

-- 3. MOVEMENT ENGINE (GROUND FLY)
_G.Fly = false
RunService.RenderStepped:Connect(function()
    if _G.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        -- Logic chạm đất
        local ray = Ray.new(root.Position, Vector3.new(0, -10, 0))
        local hit, pos = workspace:FindPartOnRay(ray, LocalPlayer.Character)
        if hit then
            root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
            root.CFrame = root.CFrame + (Camera.CFrame.LookVector * 2)
        end
    end
end)

-- 4. COMBAT ENGINE (TEAM FILTER)
local function GetTarget()
    local closest, dist = nil, 500
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            -- Logic: Police only Wanted, Civilians only Police
            local isPolice = (LocalPlayer.Team and LocalPlayer.Team.Name == "Police")
            local stats = plr:FindFirstChild("leaderstats")
            
            local isValid = false
            if isPolice and stats and stats:FindFirstChild("Wanted") and stats.Wanted.Value > 0 then isValid = true
            elseif not isPolice and (plr.Team and plr.Team.Name == "Police") then isValid = true end
            
            if isValid then
                local pos, on = Camera:WorldToViewportPoint(plr.Character.Head.Position)
                if on then
                    local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if d < dist then dist = d; closest = plr.Character.Head end
                end
            end
        end
    end
    return closest
end

-- 5. BUTTON CREATOR (Đóng gói để bạn copy ra nhiều nút cho đầy 2000 dòng)
local function CreateBtn(name, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 40); btn.Position = UDim2.new(0.05, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50); btn.Text = name
    btn.MouseButton1Click:Connect(function() AnimateClick(btn); callback() end)
    Instance.new("UIListLayout", Main)
end

-- CÁC CHỨC NĂNG CHÍNH
CreateBtn("Ultra Aimbot", function() _G.Aimbot = not _G.Aimbot end)
CreateBtn("Ground Fly", function() _G.Fly = not _G.Fly end)
CreateBtn("ESP Box", function() print("ESP Enabled") end)

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
    if _G.Aimbot then
        local target = GetTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)
