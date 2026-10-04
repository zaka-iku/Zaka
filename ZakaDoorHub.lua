--[[
    ZakaDoorHub.lua - Fixed & Improved
    Mobile Support + All Modes (Hotel, Mines, Archives, Stairwell, Rush Mode...)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ==================== SETTINGS ====================
local Settings = {
    MenuOpen = true,
    ESP = {
        Door = false, Entity = false, Item = false,
        Key = false, Gold = false, Hiding = false, Player = false
    },
    Protections = {
        AntiRush = false, AntiAmbush = false, AntiScreech = false, AntiEyes = false,
        AntiFigure = false, AntiSeek = false, AntiBash = false, AntiRansom = false,
        AntiScribbles = false, AntiHoncho = false, AntiDrone = false, AntiAlma = false,
        AntiCreak = false, AntiStem = false, AntiMeld = false, AntiNoise = false, AntiDupe = false
    },
    Misc = {
        Fullbright = false, Speed = false, SpeedValue = 22,
        Noclip = false, InstantInteract = false, AutoHide = false, AutoFarm = false
    },
    Combat = {AutoShoot = false, Aimbot = false, ShootDistance = 90}
}

-- ==================== ESP FOLDER ====================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ZakaESP"
ESPFolder.Parent = CoreGui

local function ClearESP()
    for _, v in pairs(ESPFolder:GetChildren()) do
        v:Destroy()
    end
end

local function CreateBillboard(adornee, text, color)
    if not adornee then return end
    local part = adornee:IsA("Model") and (adornee.PrimaryPart or adornee:FindFirstChildWhichIsA("BasePart")) or adornee
    if not part or not part:IsA("BasePart") then return end

    local bb = Instance.new("BillboardGui")
    bb.Adornee = part
    bb.Size = UDim2.new(0, 160, 0, 40)
    bb.StudsOffset = Vector3.new(0, 2.5, 0)
    bb.AlwaysOnTop = true
    bb.Parent = ESPFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextStrokeTransparency = 0.4
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.Parent = bb
end

local function UpdateESP()
    ClearESP()
    if not (Settings.ESP.Door or Settings.ESP.Entity or Settings.ESP.Item or Settings.ESP.Key or Settings.ESP.Gold or Settings.ESP.Hiding or Settings.ESP.Player) then
        return
    end

    for _, obj in pairs(workspace:GetDescendants()) do
        local name = obj.Name:lower()

        -- Door
        if Settings.ESP.Door and (name:find("door") or obj:FindFirstChild("DoorNumber") or obj:FindFirstChild("Sign")) then
            CreateBillboard(obj, "Door", Color3.fromRGB(0, 255, 120))
        end

        -- Entity
        if Settings.ESP.Entity then
            local entities = {"rush","ambush","screech","eyes","figure","seek","halt","dupe","snare","timothy",
                              "bash","ransom","scribbles","honcho","drone","alma","creak","stem","meld","noise",
                              "giggle","gloombat","blitz","lookman","haste"}
            for _, ent in pairs(entities) do
                if name:find(ent) then
                    CreateBillboard(obj, ent:upper(), Color3.fromRGB(255, 50, 50))
                    break
                end
            end
        end

        -- Item / Key / Gold
        if (Settings.ESP.Item or Settings.ESP.Key or Settings.ESP.Gold) and obj:IsA("BasePart") then
            if Settings.ESP.Key and (name:find("key") or name:find("lockpick")) then
                CreateBillboard(obj, "Key", Color3.fromRGB(255, 215, 0))
            elseif Settings.ESP.Gold and name:find("gold") then
                CreateBillboard(obj, "Gold", Color3.fromRGB(255, 200, 0))
            elseif Settings.ESP.Item and (name:find("battery") or name:find("flashlight") or name:find("candle") or name:find("vitamin") or name:find("scrap") or name:find("crucifix") or name:find("shears")) then
                CreateBillboard(obj, obj.Name, Color3.fromRGB(100, 200, 255))
            end
        end

        -- Hiding
        if Settings.ESP.Hiding and (name:find("wardrobe") or name:find("closet") or name:find("bed") or name:find("locker") or name:find("cabinet")) then
            CreateBillboard(obj, "Hide", Color3.fromRGB(160, 100, 255))
        end
    end

    -- Player ESP
    if Settings.ESP.Player then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                CreateBillboard(plr.Character.HumanoidRootPart, plr.Name, Color3.fromRGB(0, 200, 255))
            end
        end
    end
end

-- ==================== GUI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaDoorHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- Nút Z mở/đóng (Mobile)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 65, 0, 65)
ToggleBtn.Position = UDim2.new(1, -85, 0.5, -32)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
ToggleBtn.Text = "Z"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 28
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 14)

-- Main Menu
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 460)
Main.Position = UDim2.new(0.5, -160, 0.5, -230)
Main.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -16, 0, 32)
Title.Position = UDim2.new(0, 8, 0, 6)
Title.BackgroundTransparency = 1
Title.Text = "ZakaDoorHub 2026"
Title.TextColor3 = Color3.fromRGB(255, 70, 70)
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

local Sub = Instance.new("TextLabel")
Sub.Size = UDim2.new(1, -16, 0, 16)
Sub.Position = UDim2.new(0, 8, 0, 34)
Sub.BackgroundTransparency = 1
Sub.Text = "Mobile • All Modes Supported"
Sub.TextColor3 = Color3.fromRGB(150, 150, 150)
Sub.TextSize = 11
Sub.Font = Enum.Font.Gotham
Sub.Parent = Main

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -12, 1, -60)
Scroll.Position = UDim2.new(0, 6, 0, 55)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
Scroll.CanvasSize = UDim2.new(0, 0, 0, 950)
Scroll.Parent = Main

local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0, 5)
List.Parent = Scroll

-- Toggle Helper
local function MakeToggle(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
    frame.BorderSizePixel = 0
    frame.Parent = Scroll
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -75, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(225, 225, 225)
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 58, 0, 26)
    btn.Position = UDim2.new(1, -66, 0.5, -13)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 160, 70) or Color3.fromRGB(65, 65, 75)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 160, 70) or Color3.fromRGB(65, 65, 75)
        btn.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

-- Toggles
MakeToggle("Door ESP", false, function(v) Settings.ESP.Door = v UpdateESP() end)
MakeToggle("Entity ESP", false, function(v) Settings.ESP.Entity = v UpdateESP() end)
MakeToggle("Item / Key / Gold ESP", false, function(v)
    Settings.ESP.Item = v Settings.ESP.Key = v Settings.ESP.Gold = v UpdateESP()
end)
MakeToggle("Hiding Spot ESP", false, function(v) Settings.ESP.Hiding = v UpdateESP() end)
MakeToggle("Player ESP", false, function(v) Settings.ESP.Player = v UpdateESP() end)

MakeToggle("Anti Rush + Ambush", false, function(v)
    Settings.Protections.AntiRush = v Settings.Protections.AntiAmbush = v
end)
MakeToggle("Anti Screech + Eyes", false, function(v)
    Settings.Protections.AntiScreech = v Settings.Protections.AntiEyes = v
end)
MakeToggle("Anti Figure + Seek", false, function(v)
    Settings.Protections.AntiFigure = v Settings.Protections.AntiSeek = v
end)
MakeToggle("Anti Bash / Ransom / Scribbles", false, function(v)
    Settings.Protections.AntiBash = v Settings.Protections.AntiRansom = v Settings.Protections.AntiScribbles = v
end)
MakeToggle("Anti Archives Entities", false, function(v)
    Settings.Protections.AntiHoncho = v Settings.Protections.AntiDrone = v
    Settings.Protections.AntiAlma = v Settings.Protections.AntiCreak = v
    Settings.Protections.AntiStem = v Settings.Protections.AntiMeld = v Settings.Protections.AntiNoise = v
end)
MakeToggle("Anti Dupe", false, function(v) Settings.Protections.AntiDupe = v end)

MakeToggle("Fullbright", false, function(v)
    Settings.Misc.Fullbright = v
    if v then
        Lighting.Brightness = 2 Lighting.ClockTime = 14 Lighting.FogEnd = 9e9 Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1 Lighting.ClockTime = 0 Lighting.FogEnd = 1000 Lighting.GlobalShadows = true
    end
end)
MakeToggle("Speed Boost", false, function(v) Settings.Misc.Speed = v end)
MakeToggle("Noclip", false, function(v) Settings.Misc.Noclip = v end)
MakeToggle("Instant Interact", false, function(v) Settings.Misc.InstantInteract = v end)
MakeToggle("Auto Hide", false, function(v) Settings.Misc.AutoHide = v end)
MakeToggle("Auto Farm Items/Gold", false, function(v) Settings.Misc.AutoFarm = v end)

MakeToggle("Aimbot 100% (Rush Mode)", false, function(v) Settings.Combat.Aimbot = v end)
MakeToggle("Auto Shoot (Rush Mode)", false, function(v) Settings.Combat.AutoShoot = v end)

-- Toggle Menu
ToggleBtn.MouseButton1Click:Connect(function()
    Settings.MenuOpen = not Settings.MenuOpen
    Main.Visible = Settings.MenuOpen
    ToggleBtn.Text = Settings.MenuOpen and "Z" or "☰"
end)

-- ==================== LOGIC ====================
-- Speed / Noclip / Instant Interact
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")

    if Settings.Misc.Speed and hum then
        hum.WalkSpeed = Settings.Misc.SpeedValue
    end

    if Settings.Misc.Noclip then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end

    if Settings.Misc.InstantInteract then
        for _, prompt in pairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                prompt.HoldDuration = 0
                prompt.MaxActivationDistance = 25
            end
        end
    end
end)

-- Auto Farm
task.spawn(function()
    while task.wait(0.3) do
        if not Settings.Misc.AutoFarm then continue end
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        for _, obj in pairs(workspace:GetDescendants()) do
            local n = obj.Name:lower()
            if obj:IsA("BasePart") and (n:find("gold") or n:find("key") or n:find("battery") or n:find("flashlight") or n:find("candle") or n:find("vitamin") or n:find("scrap") or n:find("coin")) then
                if (obj.Position - hrp.Position).Magnitude < 30 then
                    pcall(function()
                        firetouchinterest(hrp, obj, 0)
                        firetouchinterest(hrp, obj, 1)
                    end)
                end
            end
        end
    end
end)

-- Anti Entity (xóa entity)
task.spawn(function()
    while task.wait(0.4) do
        for _, obj in pairs(workspace:GetDescendants()) do
            local n = obj.Name:lower()
            local remove = false

            if Settings.Protections.AntiRush and n:find("rush") then remove = true end
            if Settings.Protections.AntiAmbush and n:find("ambush") then remove = true end
            if Settings.Protections.AntiScreech and n:find("screech") then remove = true end
            if Settings.Protections.AntiEyes and n:find("eyes") then remove = true end
            if Settings.Protections.AntiFigure and n:find("figure") then remove = true end
            if Settings.Protections.AntiSeek and n:find("seek") then remove = true end
            if Settings.Protections.AntiBash and n:find("bash") then remove = true end
            if Settings.Protections.AntiRansom and n:find("ransom") then remove = true end
            if Settings.Protections.AntiScribbles and n:find("scribble") then remove = true end
            if Settings.Protections.AntiHoncho and n:find("honcho") then remove = true end
            if Settings.Protections.AntiDrone and n:find("drone") then remove = true end
            if Settings.Protections.AntiAlma and n:find("alma") then remove = true end
            if Settings.Protections.AntiCreak and n:find("creak") then remove = true end
            if Settings.Protections.AntiStem and n:find("stem") then remove = true end
            if Settings.Protections.AntiMeld and n:find("meld") then remove = true end
            if Settings.Protections.AntiNoise and n:find("noise") then remove = true end
            if Settings.Protections.AntiDupe and n:find("dupe") then remove = true end

            if remove then
                pcall(function() obj:Destroy() end)
            end
        end
    end
end)

-- ESP Update
task.spawn(function()
    while task.wait(1.5) do
        UpdateESP()
    end
end)

-- Aimbot + Auto Shoot
local function GetClosestTarget()
    local closest, shortest = nil, 999
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end

    for _, obj in pairs(workspace:GetDescendants()) do
        local n = obj.Name:lower()
        if n:find("rush") or n:find("seek") or n:find("figure") or n:find("bash") or n:find("drone") or n:find("honcho") or n:find("light") then
            local part = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
            if part and part:IsA("BasePart") then
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
                    task.wait(0.04)
                    mouse1release()
                end)
            end
        end
    end
end)

print("✅ ZakaDoorHub Fixed Loaded | Mobile + All Modes")
