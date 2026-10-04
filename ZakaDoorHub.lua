-- ZakaDoorHub Full - Delta Mobile Optimized

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Xóa menu cũ
pcall(function()
    if PlayerGui:FindFirstChild("ZakaHub") then
        PlayerGui.ZakaHub:Destroy()
    end
end)

-- ==================== SETTINGS ====================
local S = {
    ESP = {Door=false, Entity=false, Item=false, Key=false, Gold=false, Hiding=false, Player=false},
    Anti = {
        Rush=false, Ambush=false, Screech=false, Eyes=false,
        Figure=false, Seek=false, Bash=false, Ransom=false,
        Scribbles=false, Honcho=false, Drone=false, Alma=false,
        Creak=false, Stem=false, Meld=false, Noise=false, Dupe=false
    },
    Misc = {
        Fullbright=false, Speed=false, SpeedValue=22,
        Noclip=false, Instant=false, AutoFarm=false
    },
    Combat = {Aimbot=false, AutoShoot=false, Dist=90}
}

-- ==================== ESP ====================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ZakaESP"
ESPFolder.Parent = PlayerGui

local function ClearESP()
    for _, v in pairs(ESPFolder:GetChildren()) do
        if v:IsA("BillboardGui") then v:Destroy() end
    end
end

local function AddESP(obj, text, color)
    if not obj then return end
    local part = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
    if not part or not part:IsA("BasePart") then return end

    local bb = Instance.new("BillboardGui")
    bb.Adornee = part
    bb.Size = UDim2.new(0, 140, 0, 32)
    bb.StudsOffset = Vector3.new(0, 2.2, 0)
    bb.AlwaysOnTop = true
    bb.Parent = ESPFolder

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color
    lbl.TextStrokeTransparency = 0.5
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.Parent = bb
end

local function UpdateESP()
    ClearESP()
    if not (S.ESP.Door or S.ESP.Entity or S.ESP.Item or S.ESP.Key or S.ESP.Gold or S.ESP.Hiding or S.ESP.Player) then return end

    for _, obj in pairs(workspace:GetDescendants()) do
        local n = obj.Name:lower()

        if S.ESP.Door and (n:find("door") or obj:FindFirstChild("DoorNumber") or obj:FindFirstChild("Sign")) then
            AddESP(obj, "Door", Color3.fromRGB(0, 255, 120))
        end

        if S.ESP.Entity then
            local list = {"rush","ambush","screech","eyes","figure","seek","halt","dupe","bash","ransom","scribble","honcho","drone","alma","creak","stem","meld","noise","giggle","gloombat"}
            for _, e in pairs(list) do
                if n:find(e) then
                    AddESP(obj, e:upper(), Color3.fromRGB(255, 50, 50))
                    break
                end
            end
        end

        if obj:IsA("BasePart") then
            if S.ESP.Key and (n:find("key") or n:find("lockpick")) then
                AddESP(obj, "Key", Color3.fromRGB(255, 215, 0))
            elseif S.ESP.Gold and n:find("gold") then
                AddESP(obj, "Gold", Color3.fromRGB(255, 200, 0))
            elseif S.ESP.Item and (n:find("battery") or n:find("flashlight") or n:find("candle") or n:find("vitamin") or n:find("scrap") or n:find("crucifix")) then
                AddESP(obj, obj.Name, Color3.fromRGB(100, 200, 255))
            end
        end

        if S.ESP.Hiding and (n:find("wardrobe") or n:find("closet") or n:find("bed") or n:find("locker")) then
            AddESP(obj, "Hide", Color3.fromRGB(160, 100, 255))
        end
    end

    if S.ESP.Player then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                AddESP(plr.Character.HumanoidRootPart, plr.Name, Color3.fromRGB(0, 200, 255))
            end
        end
    end
end

-- ==================== GUI ====================
local gui = Instance.new("ScreenGui")
gui.Name = "ZakaHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = PlayerGui

-- Nút Z
local zBtn = Instance.new("TextButton")
zBtn.Size = UDim2.new(0, 60, 0, 60)
zBtn.Position = UDim2.new(1, -75, 0.35, 0)
zBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
zBtn.Text = "Z"
zBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
zBtn.TextSize = 26
zBtn.Font = Enum.Font.GothamBlack
zBtn.Parent = gui
Instance.new("UICorner", zBtn).CornerRadius = UDim.new(0, 12)

-- Main Menu
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 270, 0, 400)
main.Position = UDim2.new(0.5, -135, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
main.BorderSizePixel = 0
main.Visible = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "ZakaDoorHub 2026"
title.TextColor3 = Color3.fromRGB(255, 70, 70)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = main

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -8, 1, -40)
scroll.Position = UDim2.new(0, 4, 0, 35)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.CanvasSize = UDim2.new(0, 0, 0, 780)
scroll.Parent = main

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 4)
list.Parent = scroll

-- Hàm tạo nút
local function Btn(text, default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 34)
    f.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    f.BorderSizePixel = 0
    f.Parent = scroll
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 54, 0, 24)
    b.Position = UDim2.new(1, -62, 0.5, -12)
    b.BackgroundColor3 = default and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(60, 60, 70)
    b.Text = default and "ON" or "OFF"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.Parent = f
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)

    local on = default
    b.MouseButton1Click:Connect(function()
        on = not on
        b.BackgroundColor3 = on and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(60, 60, 70)
        b.Text = on and "ON" or "OFF"
        callback(on)
    end)
end

-- ===== ESP =====
Btn("Door ESP", false, function(v) S.ESP.Door = v UpdateESP() end)
Btn("Entity ESP", false, function(v) S.ESP.Entity = v UpdateESP() end)
Btn("Item / Key / Gold ESP", false, function(v)
    S.ESP.Item = v S.ESP.Key = v S.ESP.Gold = v UpdateESP()
end)
Btn("Hiding Spot ESP", false, function(v) S.ESP.Hiding = v UpdateESP() end)
Btn("Player ESP", false, function(v) S.ESP.Player = v UpdateESP() end)

-- ===== Anti =====
Btn("Anti Rush + Ambush", false, function(v) S.Anti.Rush = v S.Anti.Ambush = v end)
Btn("Anti Screech + Eyes", false, function(v) S.Anti.Screech = v S.Anti.Eyes = v end)
Btn("Anti Figure + Seek", false, function(v) S.Anti.Figure = v S.Anti.Seek = v end)
Btn("Anti Bash / Ransom / Scribbles", false, function(v)
    S.Anti.Bash = v S.Anti.Ransom = v S.Anti.Scribbles = v
end)
Btn("Anti Archives Entities", false, function(v)
    S.Anti.Honcho = v S.Anti.Drone = v S.Anti.Alma = v
    S.Anti.Creak = v S.Anti.Stem = v S.Anti.Meld = v S.Anti.Noise = v
end)
Btn("Anti Dupe", false, function(v) S.Anti.Dupe = v end)

-- ===== Misc =====
Btn("Fullbright", false, function(v)
    S.Misc.Fullbright = v
    if v then
        Lighting.Brightness = 2 Lighting.ClockTime = 14
        Lighting.FogEnd = 9e9 Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1 Lighting.ClockTime = 0
        Lighting.FogEnd = 1000 Lighting.GlobalShadows = true
    end
end)
Btn("Speed Boost", false, function(v) S.Misc.Speed = v end)
Btn("Noclip", false, function(v) S.Misc.Noclip = v end)
Btn("Instant Interact", false, function(v) S.Misc.Instant = v end)
Btn("Auto Farm Items/Gold", false, function(v) S.Misc.AutoFarm = v end)

-- ===== Combat =====
Btn("Aimbot 100% (Rush Mode)", false, function(v) S.Combat.Aimbot = v end)
Btn("Auto Shoot (Rush Mode)", false, function(v) S.Combat.AutoShoot = v end)

-- Mở/Đóng
zBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- ==================== LOGIC ====================
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")

    if S.Misc.Speed and hum then
        hum.WalkSpeed = S.Misc.SpeedValue
    end

    if S.Misc.Noclip then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end

    if S.Misc.Instant then
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("ProximityPrompt") then
                p.HoldDuration = 0
                p.MaxActivationDistance = 25
            end
        end
    end
end)

-- Auto Farm
task.spawn(function()
    while task.wait(0.3) do
        if not S.Misc.AutoFarm then continue end
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

-- Anti Entity
task.spawn(function()
    while task.wait(0.45) do
        for _, obj in pairs(workspace:GetDescendants()) do
            local n = obj.Name:lower()
            local del = false
            if S.Anti.Rush and n:find("rush") then del = true end
            if S.Anti.Ambush and n:find("ambush") then del = true end
            if S.Anti.Screech and n:find("screech") then del = true end
            if S.Anti.Eyes and n:find("eyes") then del = true end
            if S.Anti.Figure and n:find("figure") then del = true end
            if S.Anti.Seek and n:find("seek") then del = true end
            if S.Anti.Bash and n:find("bash") then del = true end
            if S.Anti.Ransom and n:find("ransom") then del = true end
            if S.Anti.Scribbles and n:find("scribble") then del = true end
            if S.Anti.Honcho and n:find("honcho") then del = true end
            if S.Anti.Drone and n:find("drone") then del = true end
            if S.Anti.Alma and n:find("alma") then del = true end
            if S.Anti.Creak and n:find("creak") then del = true end
            if S.Anti.Stem and n:find("stem") then del = true end
            if S.Anti.Meld and n:find("meld") then del = true end
            if S.Anti.Noise and n:find("noise") then del = true end
            if S.Anti.Dupe and n:find("dupe") then del = true end
            if del then pcall(function() obj:Destroy() end) end
        end
    end
end)

-- ESP Loop
task.spawn(function()
    while task.wait(1.6) do
        UpdateESP()
    end
end)

-- Aimbot + Auto Shoot
local function GetTarget()
    local closest, short = nil, 999
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    for _, obj in pairs(workspace:GetDescendants()) do
        local n = obj.Name:lower()
        if n:find("rush") or n:find("seek") or n:find("figure") or n:find("bash") or n:find("drone") or n:find("honcho") or n:find("light") then
            local part = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
            if part and part:IsA("BasePart") then
                local dist = (part.Position - hrp.Position).Magnitude
                if dist < S.Combat.Dist then
                    local pos, on = Camera:WorldToViewportPoint(part.Position)
                    if on then
                        local m = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                        if m < short then
                            short = m
                            closest = part
                        end
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if not (S.Combat.Aimbot or S.Combat.AutoShoot) then return end
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if not tool then return end
    local t = GetTarget()
    if t then
        if S.Combat.Aimbot then
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, t.Position)
        end
        if S.Combat.AutoShoot then
            local dist = (t.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist <= S.Combat.Dist then
                pcall(function()
                    mouse1press()
                    task.wait(0.04)
                    mouse1release()
                end)
            end
        end
    end
end)

print("✅ ZakaDoorHub Full loaded on Delta Mobile")
