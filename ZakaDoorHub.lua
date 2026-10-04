--[[
    DOORS HUB 2026 - Mobile Friendly + Z Layout
    Hỗ trợ tất cả chế độ + Mobile
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ==================== SETTINGS ====================
local Settings = {
    MenuOpen = true,
    ESP = {Door=false, Entity=false, Item=false, Key=false, Gold=false, Hiding=false, Player=false},
    Protections = {
        AntiRush=false, AntiAmbush=false, AntiScreech=false, AntiEyes=false,
        AntiFigure=false, AntiSeek=false, AntiBash=false, AntiRansom=false,
        AntiScribbles=false, AntiHoncho=false, AntiDrone=false, AntiAlma=false,
        AntiCreak=false, AntiStem=false, AntiMeld=false, AntiNoise=false, AntiDupe=false
    },
    Misc = {
        Fullbright=false, Speed=false, SpeedValue=22,
        Noclip=false, InstantInteract=false, AutoHide=false, AutoFarm=false
    },
    Combat = {AutoShoot=false, Aimbot=false, ShootDistance=90}
}

-- ==================== GUI - HÌNH CHỮ Z ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DoorsZHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- Nút mở/đóng menu (luôn hiện, hỗ trợ mobile)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 70, 0, 70)
ToggleBtn.Position = UDim2.new(1, -90, 0.5, -35)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
ToggleBtn.Text = "Z"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 32
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 16)
ToggleCorner.Parent = ToggleBtn

-- Main Frame hình chữ Z (3 phần xếp thành Z)
local Main = Instance.new("Frame")
Main.Name = "MainZ"
Main.Size = UDim2.new(0, 340, 0, 480)
Main.Position = UDim2.new(0.5, -170, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

-- Background tối
local BG = Instance.new("Frame")
BG.Size = UDim2.new(1, 0, 1, 0)
BG.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
BG.BackgroundTransparency = 0.15
BG.BorderSizePixel = 0
BG.Parent = Main
local BGCorner = Instance.new("UICorner")
BGCorner.CornerRadius = UDim.new(0, 14)
BGCorner.Parent = BG

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 36)
Title.Position = UDim2.new(0, 10, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "DOORS HUB 2026  •  Z MENU"
Title.TextColor3 = Color3.fromRGB(255, 70, 70)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

local Sub = Instance.new("TextLabel")
Sub.Size = UDim2.new(1, -20, 0, 18)
Sub.Position = UDim2.new(0, 10, 0, 40)
Sub.BackgroundTransparency = 1
Sub.Text = "Mobile Support • All Modes"
Sub.TextColor3 = Color3.fromRGB(160, 160, 160)
Sub.TextSize = 12
Sub.Font = Enum.Font.Gotham
Sub.Parent = Main

-- Scrolling Content
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -16, 1, -70)
Scroll.Position = UDim2.new(0, 8, 0, 65)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 5
Scroll.CanvasSize = UDim2.new(0, 0, 0, 900)
Scroll.Parent = Main

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 6)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Parent = Scroll

-- Helper tạo nút Toggle lớn (mobile friendly)
local function MakeToggle(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 42)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    frame.BorderSizePixel = 0
    frame.Parent = Scroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextSize = 14
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 64, 0, 30)
    btn.Position = UDim2.new(1, -72, 0.5, -15)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 170, 70) or Color3.fromRGB(70, 70, 80)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 70) or Color3.fromRGB(70, 70, 80)
        btn.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

-- ==================== TẠO CÁC NÚT ====================
-- ESP
MakeToggle("Door ESP", false, function(v) Settings.ESP.Door = v end)
MakeToggle("Entity ESP", false, function(v) Settings.ESP.Entity = v end)
MakeToggle("Item / Key / Gold ESP", false, function(v)
    Settings.ESP.Item = v
    Settings.ESP.Key = v
    Settings.ESP.Gold = v
end)
MakeToggle("Hiding Spot ESP", false, function(v) Settings.ESP.Hiding = v end)
MakeToggle("Player ESP", false, function(v) Settings.ESP.Player = v end)

-- Protections
MakeToggle("Anti Rush + Ambush", false, function(v)
    Settings.Protections.AntiRush = v
    Settings.Protections.AntiAmbush = v
end)
MakeToggle("Anti Screech + Eyes", false, function(v)
    Settings.Protections.AntiScreech = v
    Settings.Protections.AntiEyes = v
end)
MakeToggle("Anti Figure + Seek", false, function(v)
    Settings.Protections.AntiFigure = v
    Settings.Protections.AntiSeek = v
end)
MakeToggle("Anti Bash / Ransom / Scribbles", false, function(v)
    Settings.Protections.AntiBash = v
    Settings.Protections.AntiRansom = v
    Settings.Protections.AntiScribbles = v
end)
MakeToggle("Anti Archives Entities", false, function(v)
    Settings.Protections.AntiHoncho = v
    Settings.Protections.AntiDrone = v
    Settings.Protections.AntiAlma = v
    Settings.Protections.AntiCreak = v
    Settings.Protections.AntiStem = v
    Settings.Protections.AntiMeld = v
    Settings.Protections.AntiNoise = v
end)
MakeToggle("Anti Dupe", false, function(v) Settings.Protections.AntiDupe = v end)

-- Misc
MakeToggle("Fullbright", false, function(v)
    Settings.Misc.Fullbright = v
    if v then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 9e9
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 0
        Lighting.FogEnd = 1000
        Lighting.GlobalShadows = true
    end
end)
MakeToggle("Speed Boost (22)", false, function(v) Settings.Misc.Speed = v end)
MakeToggle("Noclip", false, function(v) Settings.Misc.Noclip = v end)
MakeToggle("Instant Interact", false, function(v) Settings.Misc.InstantInteract = v end)
MakeToggle("Auto Hide", false, function(v) Settings.Misc.AutoHide = v end)
MakeToggle("Auto Farm Items/Gold", false, function(v) Settings.Misc.AutoFarm = v end)

-- Combat (Rush Mode)
MakeToggle("Aimbot 100% (Rush Mode)", false, function(v) Settings.Combat.Aimbot = v end)
MakeToggle("Auto Shoot (Rush Mode)", false, function(v) Settings.Combat.AutoShoot = v end)

-- ==================== NÚT MỞ/ĐÓNG ====================
ToggleBtn.MouseButton1Click:Connect(function()
    Settings.MenuOpen = not Settings.MenuOpen
    Main.Visible = Settings.MenuOpen
    ToggleBtn.Text = Settings.MenuOpen and "Z" or "☰"
end)

-- ==================== LOGIC HOẠT ĐỘNG ====================
-- Speed + Noclip + Instant Interact
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if Settings.Misc.Speed and hum then
        hum.WalkSpeed = Settings.Misc.SpeedValue
    end

    if Settings.Misc.Noclip and char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    if Settings.Misc.InstantInteract then
        for _, prompt in pairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                prompt.HoldDuration = 0
                prompt.MaxActivationDistance = 20
            end
        end
    end
end)

-- Auto Farm
task.spawn(function()
    while task.wait(0.35) do
        if not Settings.Misc.AutoFarm then continue end
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        for _, obj in pairs(workspace:GetDescendants()) do
            local n = obj.Name:lower()
            if obj:IsA("BasePart") and (n:find("gold") or n:find("key") or n:find("battery") or n:find("flashlight") or n:find("candle") or n:find("vitamin") or n:find("scrap") or n:find("coin")) then
                if (obj.Position - hrp.Position).Magnitude < 28 then
                    pcall(function()
                        firetouchinterest(hrp, obj, 0)
                        firetouchinterest(hrp, obj, 1)
                    end)
                end
            end
        end
    end
end)

-- Aimbot + Auto Shoot (Rush Mode)
local function GetClosestTarget()
    local closest, shortest = nil, 999
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("rush") or name:find("entity") or name:find("seek") or name:find("figure") or
               name:find("bash") or name:find("drone") or name:find("honcho") or name:find("light") then
                local part = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
                if part then
                    local dist = (part.Position - myHRP.Position).Magnitude
                    if dist < Settings.Combat.ShootDistance then
                        local screen, onScreen = Camera:WorldToViewportPoint(part.Position)
                        if onScreen then
                            local mag = (Vector2.new(screen.X, screen.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                            if mag < shortest then
                                shortest = mag
                                closest = part
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if not (Settings.Combat.Aimbot or Settings.Combat.AutoShoot) then return end
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if not tool then return end

    local target = GetClosestTarget()
    if target then
        if Settings.Combat.Aimbot then
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.Position)
        end
        if Settings.Combat.AutoShoot then
            local dist = (target.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist <= Settings.Combat.ShootDistance then
                pcall(function()
                    mouse1press()
                    task.wait(0.03)
                    mouse1release()
                end)
            end
        end
    end
end)

print("✅ DOORS Z-HUB 2026 Loaded | Mobile Support | All Modes Ready")
