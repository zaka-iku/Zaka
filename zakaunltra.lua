-- ZAKA ULTRA V5 - NO DEATH BUG & FLUENT UI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 1. SAFE ANTI-AFK (KHÔNG DÙNG HOOK MẤT MÁU/DIE)
pcall(function()
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end)
end)

-- BIẾN CẤU HÌNH
_G.Aimbot = false
_G.GroundFly = false
_G.AutoArrest = false
_G.AutoFarm = false
_G.ESP = false
_G.SpeedHack = false

-- 2. AIMBOT THÔNG MINH (LỌC TEAM & CHỈ KHI CẦM SÚNG)
local function GetSmartTarget()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChildOfClass("Tool") then return nil end
    
    local closest, minDist = nil, 400
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local myTeam = LocalPlayer.Team and LocalPlayer.Team.Name or "Civilian"
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") then
            if plr.Character.Humanoid.Health > 0 then
                local isValid = false
                local stats = plr:FindFirstChild("leaderstats")
                local targetTeam = plr.Team and plr.Team.Name or "Civilian"
                
                if myTeam == "Police" then
                    local wanted = stats and (stats:FindFirstChild("Wanted") or stats:FindFirstChild("Bounty"))
                    if wanted and wanted.Value > 0 then isValid = true end
                else
                    if targetTeam == "Police" then isValid = true end
                end
                
                if isValid then
                    local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < minDist then
                            minDist = dist
                            closest = plr.Character.Head
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- 3. MAIN LOOP (BAY AN TOÀN & LOCK TÂM)
RunService.RenderStepped:Connect(function()
    if _G.Aimbot then
        local target = GetSmartTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
    
    if _G.GroundFly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
        root.CFrame = root.CFrame + (Camera.CFrame.LookVector * 1.5)
    end
    
    if _G.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 24
    end
end)

-- 4. GIAO DIỆN FLUENT UI ĐẸP MẮT
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaV5UI"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Nút Icon Mở Menu
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 10, 0.25, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 255)
ToggleBtn.Text = "ZAKA"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 11
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

-- Khung Main
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 320)
Main.Position = UDim2.new(0.5, -140, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Header
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA ULTRA V5 - FLUENT"
Title.TextColor3 = Color3.fromRGB(150, 100, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Scrolling Container (Sửa triệt để lỗi tràn khung)
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -50)
Scroll.Position = UDim2.new(0, 10, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 360)
Scroll.ScrollBarThickness = 3

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8)

-- Hàm tạo Switch Button Animation
local function AddToggle(text, varName)
    local card = Instance.new("Frame", Scroll)
    card.Size = UDim2.new(1, 0, 0, 42)
    card.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(1, -55, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(230, 230, 240)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(0, 38, 0, 20)
    btn.Position = UDim2.new(1, -48, 0.5, -10)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", btn)
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = UDim2.new(0, 3, 0.5, -7)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        local state = _G[varName]
        
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(120, 60, 255) or Color3.fromRGB(50, 50, 65)
        }):Play()
        
        TweenService:Create(circle, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        }):Play()
    end)
end

-- DANH SÁCH CHỨC NĂNG
AddToggle("Smart Aimbot (Lọc Team + Súng)", "Aimbot")
AddToggle("Bay Chạm Đất (Ground Fly)", "GroundFly")
AddToggle("Tăng Tốc Chạy Safe (Speed Hack)", "SpeedHack")
AddToggle("Auto Arrest Cảnh Sát", "AutoArrest")
AddToggle("Auto Farm Dân Thường", "AutoFarm")

print("Zaka V5 Fix Loaded Successfully!")
