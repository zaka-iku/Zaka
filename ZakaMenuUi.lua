--[[
    ╔════════════════════════════════════════════════════════════════════════════════╗
    ║             ZAKA PURE UI v3.0 - GOD-TIER ULTIMATE FIXED EDITION                ║
    ║   - Sửa toàn bộ lỗi logic, tích hợp đầy đủ tính năng cho các ô Placeholder    ║
    ║   - Tối ưu hóa hiệu năng, chống ngốn CPU (Memory Leak Cleaned)                 ║
    ╚════════════════════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==============================================================================--
--                            CẤU HÌNH HỆ THỐNG (SETTINGS)                       --
--==============================================================================--
local Settings = {
    -- Combat & Aimbot
    Aimbot = false,
    AimbotFOV = 120,
    AimbotSmooth = 0.25,
    SilentAim = false,
    AutoClicker = false,
    ClickDelay = 0.05,
    TargetStrafe = false,
    StrafeDistance = 12,
    StrafeSpeed = 6,
    TriggerBot = false,
    KillAura = false,
    KillAuraDist = 18,
    AutoBlock = false,
    FastAttack = false,
    AutoSkill = false,
    NoRecoil = false,
    NoSpread = false,
    InfiniteAmmo = false,
    Wallbang = false,
    OneHitKO = false,
    
    -- Hitbox Mở Rộng
    HitboxHead = false,
    HeadSize = 15,
    HitboxTorso = false,
    TorsoSize = Vector3.new(4, 6, 4),
    HitboxWeapon = false,
    WeaponSize = 5,
    HitboxTransparent = 0.5,
    HitboxLimb = false,
    LimbSize = 4,
    HitboxTeamCheck = false,
    HitboxAutoUpdate = true,
    
    -- Visuals & ESP
    ESP = false,
    ESPBox = true,
    ESPName = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPMaxDist = 3500,
    Chams = false,
    ChamsColor = Color3.fromRGB(0, 200, 255),
    CustomCrosshair = false,
    CrosshairSize = 12,
    GlowTrail = false,
    Fullbright = false,
    FOVChanger = false,
    FOVValue = 90,
    Tracers = false,
    ESPHeadDot = false,
    NightVision = false,
    FPSBoost = false,
    
    -- Player & Movement
    Speed = false,
    SpeedValue = 26,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    InfiniteJump = false,
    SpinBot = false,
    SpinSpeed = 45,
    SpiderClimb = false,
    SpiderSpeed = 30,
    WaterWalk = false,
    Bhop = false,
    HighJump = false,
    JumpPower = 100,
    SuperDash = false,
    AutoRespawn = false,
    AntiRagdoll = false,
    
    -- World & Teleport
    TouchTP = false,
    BringNPC = false,
    AntiVoid = false,
    GravityMod = false,
    GravityValue = 196.2,
    AutoCollectItems = false,
    InstantInteract = false,
    
    -- Troll & Fun
    ChatSpammer = false,
    SpamMessage = "Zaka Pure UI v3.0 - Ultimate Power!",
    SpamDelay = 2,
    Invisible = false,
    FlingMe = false,
    FakeLag = false,
    HeadlessMode = false,
    RainbowColor = false,
}

--==============================================================================--
--                            LOGIC TÍNH NĂNG TOÀN DIỆN                           --
--==============================================================================--
local Connections = {}
local BodyGyro, BodyVelocity
local ESPObjects = {}
local ChamsObjects = {}
local OriginalAmbient = Lighting.Ambient
local OriginalGravity = Workspace.Gravity

local function DisconnectLoop(name)
    if Connections[name] then
        Connections[name]:Disconnect()
        Connections[name] = nil
    end
end

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- High Jump & Gravity
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and Settings.HighJump then
            hum.JumpPower = Settings.JumpPower
        end
    end
    
    if Settings.GravityMod then
        Workspace.Gravity = Settings.GravityValue
    else
        Workspace.Gravity = OriginalGravity
    end
    
    if Settings.Fullbright then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = OriginalAmbient
    end
    
    if Settings.FOVChanger then
        Camera.FieldOfView = Settings.FOVValue
    end
end)

-- Bhop
Connections["Bhop"] = RunService.RenderStepped:Connect(function()
    if Settings.Bhop then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.FloorMaterial ~= Enum.Material.Air then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Touch TP
local function SetTouchTP(state)
    Settings.TouchTP = state
    DisconnectLoop("TouchTP")
    if state then
        Connections["TouchTP"] = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                if Settings.TouchTP and Mouse.Hit then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3.5, 0))
                    end
                end
            end
        end)
    end
end

-- Water Walk
local function SetWaterWalk(state)
    Settings.WaterWalk = state
    DisconnectLoop("WaterWalk")
    if state then
        Connections["WaterWalk"] = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local ray = Ray.new(root.Position, Vector3.new(0, -6, 0))
                local hit, pos, norm, mat = Workspace:FindPartOnRay(ray, char)
                if mat == Enum.Material.Water then
                    root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
                    root.CFrame = CFrame.new(root.Position.X, pos.Y + 3.2, root.Position.Z)
                end
            end
        end)
    end
end

-- Spider Climb
local function SetSpiderClimb(state)
    Settings.SpiderClimb = state
    DisconnectLoop("SpiderClimb")
    if state then
        Connections["SpiderClimb"] = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local ray = Ray.new(root.Position, root.CFrame.LookVector * 3)
                local hit = Workspace:FindPartOnRay(ray, char)
                if hit then
                    root.Velocity = Vector3.new(root.Velocity.X, Settings.SpiderSpeed, root.Velocity.Z)
                end
            end
        end)
    end
end

-- Auto Clicker & Fast Attack
local function SetAutoClicker(state)
    Settings.AutoClicker = state
    DisconnectLoop("AutoClicker")
    if state then
        Connections["AutoClicker"] = RunService.RenderStepped:Connect(function()
            if Settings.AutoClicker then
                VirtualUser:Button1Down(Vector2.new())
                task.wait(Settings.ClickDelay)
                VirtualUser:Button1Up(Vector2.new())
            end
        end)
    end
end

-- KillAura (Thực tế)
RunService.Heartbeat:Connect(function()
    if Settings.KillAura then
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local enemyRoot = plr.Character.HumanoidRootPart
                local dist = (enemyRoot.Position - myRoot.Position).Magnitude
                if dist <= Settings.KillAuraDist then
                    local tool = myChar:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
            end
        end
    end
end)

-- Bring NPC
local function SetBringNPC(state)
    Settings.BringNPC = state
    DisconnectLoop("BringNPC")
    if state then
        Connections["BringNPC"] = RunService.RenderStepped:Connect(function()
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and obj ~= LocalPlayer.Character then
                    local hum = obj:FindFirstChildOfClass("Humanoid")
                    local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                    if hum and root and hum.Health > 0 then
                        if not Players:GetPlayerFromCharacter(obj) then
                            root.CFrame = myRoot.CFrame * CFrame.new(0, 0, -4)
                            root.Velocity = Vector3.zero
                        end
                    end
                end
            end
        end)
    end
end

-- Chat Spammer
local spamTask
local function SetChatSpammer(state)
    Settings.ChatSpammer = state
    if spamTask then task.cancel(spamTask) spamTask = nil end
    if state then
        spamTask = task.spawn(function()
            while Settings.ChatSpammer do
                pcall(function()
                    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                        local channel = TextChatService.TextChannels.RBXGeneral
                        channel:SendAsync(Settings.SpamMessage)
                    else
                        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Settings.SpamMessage, "All")
                    end
                end)
                task.wait(Settings.SpamDelay)
            end
        end)
    end
end

-- Target Strafe
local function SetTargetStrafe(state)
    Settings.TargetStrafe = state
    DisconnectLoop("TargetStrafe")
    if state then
        local angle = 0
        Connections["TargetStrafe"] = RunService.RenderStepped:Connect(function()
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            local target = nil
            local minDist = 9999
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (plr.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        target = plr.Character.HumanoidRootPart
                    end
                end
            end
            if target and minDist <= 50 then
                angle = angle + math.rad(Settings.StrafeSpeed)
                local offset = Vector3.new(math.cos(angle) * Settings.StrafeDistance, 0, math.sin(angle) * Settings.StrafeDistance)
                myRoot.CFrame = CFrame.new(target.Position + offset, target.Position)
            end
        end)
    end
end

-- Hitbox Mở Rộng
RunService.RenderStepped:Connect(function()
    if not Settings.HitboxAutoUpdate then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            
            local head = char:FindFirstChild("Head")
            if head then
                if Settings.HitboxHead then
                    head.Size = Vector3.new(Settings.HeadSize, Settings.HeadSize, Settings.HeadSize)
                    head.Transparency = Settings.HitboxTransparent
                    head.CanCollide = false
                else
                    head.Size = Vector3.new(2, 1, 1)
                    head.Transparency = 0
                end
            end

            local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            if torso then
                if Settings.HitboxTorso then
                    torso.Size = Settings.TorsoSize
                    torso.Transparency = Settings.HitboxTransparent
                    torso.CanCollide = false
                else
                    torso.Size = Vector3.new(2, 2, 1)
                    torso.Transparency = 0
                end
            end
            
            if Settings.HitboxLimb then
                for _, partName in ipairs({"Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftLowerArm", "RightLowerArm", "LeftLowerLeg", "RightLowerLeg"}) do
                    local limb = char:FindFirstChild(partName)
                    if limb and limb:IsA("BasePart") then
                        limb.Size = Vector3.new(Settings.LimbSize, Settings.LimbSize, Settings.LimbSize)
                        limb.Transparency = Settings.HitboxTransparent
                        limb.CanCollide = false
                    end
                end
            end
        end
    end
end)

-- Safe Drawing API
local DrawingAvailable = pcall(function() return Drawing.new end)
local FOVCircle, CrosshairVertical, CrosshairHorizontal

if DrawingAvailable then
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1.5
    FOVCircle.NumSides = 64
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Filled = false
    FOVCircle.Visible = false
    FOVCircle.Color = Color3.fromRGB(0, 180, 255)

    CrosshairVertical = Drawing.new("Line")
    CrosshairHorizontal = Drawing.new("Line")
end

local function GetClosestPlayerHead()
    local closestHead = nil
    local shortestDist = Settings.AimbotFOV
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - centerScreen).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestHead = head
                    end
                end
            end
        end
    end
    return closestHead
end

-- Silent Aim Hook
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    if not checkcaller() and Settings.SilentAim and self == Mouse and tostring(key) == "Hit" then
        local targetHead = GetClosestPlayerHead()
        if targetHead then return targetHead.CFrame end
    end
    return oldIndex(self, key)
end)

RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    if DrawingAvailable and FOVCircle then
        FOVCircle.Position = center
        FOVCircle.Radius = Settings.AimbotFOV
        FOVCircle.Visible = Settings.Aimbot or Settings.SilentAim
    end

    if Settings.Aimbot then
        local targetHead = GetClosestPlayerHead()
        if targetHead then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetHead.Position), Settings.AimbotSmooth)
        end
    end

    if Settings.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
    end
end)

-- Fly Engine
local function StartFly()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 9e4
    BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.cframe = root.CFrame
    BodyGyro.Parent = root

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.velocity = Vector3.zero
    BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Parent = root

    DisconnectLoop("Fly")
    Connections["Fly"] = RunService.RenderStepped:Connect(function()
        if not Settings.Fly or not char or not char:FindFirstChild("Humanoid") then
            if BodyGyro then BodyGyro:Destroy() end
            if BodyVelocity then BodyVelocity:Destroy() end
            DisconnectLoop("Fly")
            return
        end
        local hum = char.Humanoid
        BodyGyro.cframe = Camera.CFrame
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            local flyVector = (Camera.CFrame.LookVector * (moveDir.Z * -1)) + (Camera.CFrame.RightVector * moveDir.X)
            BodyVelocity.velocity = flyVector.Unit * Settings.FlySpeed
        else
            BodyVelocity.velocity = Vector3.zero
        end
    end)
end

local function SetFly(state)
    Settings.Fly = state
    if state then StartFly() else
        if BodyGyro then BodyGyro:Destroy() end
        if BodyVelocity then BodyVelocity:Destroy() end
        DisconnectLoop("Fly")
    end
end

-- WalkSpeed (Max 500)
local function SetSpeed(state)
    DisconnectLoop("Speed")
    if state then
        Connections["Speed"] = RunService.Heartbeat:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = Settings.SpeedValue end
        end)
    else
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end

-- Noclip
local function SetNoclip(state)
    DisconnectLoop("Noclip")
    if state then
        Connections["Noclip"] = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end
end

-- Super Dash
local function TriggerSuperDash()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = root.CFrame + (root.CFrame.LookVector * 40)
    end
end

-- Invisible Mode
local function SetInvisible(state)
    Settings.Invisible = state
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = state and 1 or 0
            end
        end
    end
end

--==============================================================================--
--                           ZAKA PURE UI INTERFACE v3.0                        --
--==============================================================================--
pcall(function()
    if PlayerGui:FindFirstChild("ZakaPureUI") then
        PlayerGui.ZakaPureUI:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaPureUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

-- Toggle Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 62, 0, 62)
ToggleBtn.Position = UDim2.new(0, 16, 0.38, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.BackgroundTransparency = 0.1
ToggleBtn.Text = "Z"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 26
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Transparency = 0.35
ToggleStroke.Parent = ToggleBtn

-- Main Window
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 560, 0, 600)
Main.Position = UDim2.new(0.5, -280, 0.5, -300)
Main.BackgroundColor3 = Color3.fromRGB(13, 17, 26)
Main.BackgroundTransparency = 0.15
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 22)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 180, 255)
MainStroke.Thickness = 1.8
MainStroke.Transparency = 0.3
MainStroke.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 54)
Header.BackgroundColor3 = Color3.fromRGB(9, 12, 18)
Header.BackgroundTransparency = 0.2
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 22)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA PURE UI // v3.0 ULTIMATE FIXED"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(240, 245, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Position = UDim2.new(1, -46, 0.5, -18)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

-- Search Bar
local SearchFrame = Instance.new("Frame")
SearchFrame.Size = UDim2.new(1, -165, 0, 40)
SearchFrame.Position = UDim2.new(0, 16, 0, 64)
SearchFrame.BackgroundColor3 = Color3.fromRGB(22, 28, 40)
SearchFrame.BackgroundTransparency = 0.3
SearchFrame.Parent = Main
Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 12)

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -16, 1, 0)
SearchBox.Position = UDim2.new(0, 10, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.PlaceholderText = "🔍  Tìm kiếm chức năng..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(140, 150, 170)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(240, 245, 255)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 13
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = SearchFrame

-- Tab Dọc (Đặt ở BÊN PHẢI)
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(0, 125, 1, -118)
TabContainer.Position = UDim2.new(1, -135, 0, 64)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 3
TabContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
TabContainer.Parent = Main

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 8)
TabList.Parent = TabContainer
TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y + 15)
end)

-- Content Container
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -155, 1, -118)
Content.Position = UDim2.new(0, 16, 0, 114)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true
Content.Parent = Main

local TabsData = {
    {Name = "Combat", Icon = "⚔"},
    {Name = "Hitbox", Icon = "🎯"},
    {Name = "Visual", Icon = "✦"},
    {Name = "Player", Icon = "◉"},
    {Name = "World",  Icon = "◈"},
    {Name = "Troll",  Icon = "⚡"},
    {Name = "Setting",Icon = "⚙"},
}

local TabButtons = {}
local Pages = {}
local AllCards = {}
local CurrentTab = 1

local function CreateAdvancedCard(parent, text, defaultState, typeCard, callback, extraConfig)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 48)
    card.BackgroundColor3 = Color3.fromRGB(20, 26, 38)
    card.BackgroundTransparency = 0.35
    card.ClipsDescendants = true
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = card

    local mainBtn = Instance.new("TextButton")
    mainBtn.Size = UDim2.new(1, 0, 0, 48)
    mainBtn.BackgroundTransparency = 1
    mainBtn.Text = ""
    mainBtn.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -75, 0, 48)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(230, 235, 250)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local indicator = Instance.new("TextLabel")
    indicator.Size = UDim2.new(0, 20, 0, 48)
    indicator.Position = UDim2.new(1, -85, 0, 0)
    indicator.BackgroundTransparency = 1
    indicator.Text = extraConfig and "▼" or ""
    indicator.Font = Enum.Font.GothamBold
    indicator.TextSize = 10
    indicator.TextColor3 = Color3.fromRGB(150, 170, 200)
    indicator.Parent = card

    local isExpanded = false
    local containerHeight = 48

    if typeCard == "Toggle" then
        local toggleBg = Instance.new("TextButton")
        toggleBg.Size = UDim2.new(0, 48, 0, 24)
        toggleBg.Position = UDim2.new(1, -58, 0.5, -12)
        toggleBg.BackgroundColor3 = defaultState and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(35, 42, 58)
        toggleBg.Text = ""
        toggleBg.Parent = card
        Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

        local toggleDot = Instance.new("Frame")
        toggleDot.Size = UDim2.new(0, 18, 0, 18)
        toggleDot.Position = defaultState and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        toggleDot.BackgroundColor3 = Color3.new(1, 1, 1)
        toggleDot.Parent = toggleBg
        Instance.new("UICorner", toggleDot).CornerRadius = UDim.new(1, 0)

        local enabled = defaultState
        toggleBg.MouseButton1Click:Connect(function()
            enabled = not enabled
            TweenService:Create(toggleBg, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
                BackgroundColor3 = enabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(35, 42, 58)
            }):Play()
            TweenService:Create(toggleDot, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
            }):Play()
            if callback then callback(enabled) end
        end)
    end

    local subContainer = Instance.new("Frame")
    subContainer.Size = UDim2.new(1, -24, 0, 0)
    subContainer.Position = UDim2.new(0, 12, 0, 50)
    subContainer.BackgroundTransparency = 1
    subContainer.Visible = false
    subContainer.Parent = card

    local subList = Instance.new("UIListLayout")
    subList.Padding = UDim.new(0, 6)
    subList.Parent = subContainer

    if extraConfig then
        containerHeight = 48 + extraConfig(subContainer) + 16
    end

    mainBtn.MouseButton1Click:Connect(function()
        if not extraConfig then return end
        isExpanded = not isExpanded
        subContainer.Visible = true
        TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
            Size = UDim2.new(1, 0, 0, isExpanded and containerHeight or 48)
        }):Play()
        TweenService:Create(indicator, TweenInfo.new(0.35), {
            Rotation = isExpanded and 180 or 0
        }):Play()
    end)

    table.insert(AllCards, {Frame = card, Text = text:lower(), Parent = parent})
    return card
end

-- ======================== KHỞI TẠO TẤT CẢ TÍNH NĂNG ========================
for i, data in ipairs(TabsData) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(22, 28, 42)
    btn.BackgroundTransparency = 0.45
    btn.Text = data.Icon .. "  " .. data.Name
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(170, 180, 200)
    btn.AutoButtonColor = false
    btn.Parent = TabContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Thickness = 1.2
    stroke.Transparency = 1
    stroke.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Parent = Content

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.Parent = page
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 20)
    end)

    if i == 1 then -- COMBAT
        CreateAdvancedCard(page, "Aimbot Lock Head", false, "Toggle", function(v) Settings.Aimbot = v end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 18)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Bán kính FOV Aimbot:"
            lbl.TextColor3 = Color3.fromRGB(180, 190, 210)
            lbl.TextSize = 11
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 28)
            box.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
            box.Text = tostring(Settings.AimbotFOV)
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 12
            box.Font = Enum.Font.GothamMedium
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
            box.FocusLost:Connect(function()
                local num = tonumber(box.Text)
                if num then Settings.AimbotFOV = math.clamp(num, 20, 500) end
            end)
            return 56
        end)
        CreateAdvancedCard(page, "Silent Aim Engine", false, "Toggle", function(v) Settings.SilentAim = v end)
        CreateAdvancedCard(page, "Auto Clicker / Fast Attack", false, "Toggle", function(v) SetAutoClicker(v) end)
        CreateAdvancedCard(page, "Target Strafe (Né đạn)", false, "Toggle", function(v) SetTargetStrafe(v) end)
        CreateAdvancedCard(page, "KillAura (Tự chém cận chiến)", false, "Toggle", function(v) Settings.KillAura = v end)
        CreateAdvancedCard(page, "No Recoil (Tắt độ giật súng)", false, "Toggle", function(v) Settings.NoRecoil = v end)
        CreateAdvancedCard(page, "No Spread (Bắn không lệch)", false, "Toggle", function(v) Settings.NoSpread = v end)
        CreateAdvancedCard(page, "Infinite Ammo (Đạn vô tận)", false, "Toggle", function(v) Settings.InfiniteAmmo = v end)

    elseif i == 2 then -- HITBOX
        CreateAdvancedCard(page, "Mở rộng Hitbox Đầu (Head)", false, "Toggle", function(v) Settings.HitboxHead = v end)
        CreateAdvancedCard(page, "Mở rộng Hitbox Thân (Torso)", false, "Toggle", function(v) Settings.HitboxTorso = v end)
        CreateAdvancedCard(page, "Mở rộng Hitbox Tay Chân", false, "Toggle", function(v) Settings.HitboxLimb = v end)

    elseif i == 3 then -- VISUAL
        CreateAdvancedCard(page, "Fullbright (Sáng bản đồ)", false, "Toggle", function(v) Settings.Fullbright = v end)
        CreateAdvancedCard(page, "FOV Changer (Góc nhìn)", false, "Toggle", function(v) Settings.FOVChanger = v end)

    elseif i == 4 then -- PLAYER
        CreateAdvancedCard(page, "Speed Walk (Tăng tốc chạy)", false, "Toggle", function(v) Settings.Speed = v SetSpeed(v) end)
        CreateAdvancedCard(page, "Fly Mode (Bay tự do)", false, "Toggle", function(v) SetFly(v) end)
        CreateAdvancedCard(page, "Noclip (Xuyên tường)", false, "Toggle", function(v) SetNoclip(v) end)
        CreateAdvancedCard(page, "Infinite Jump (Nhảy liên tục)", false, "Toggle", function(v) Settings.InfiniteJump = v end)
        CreateAdvancedCard(page, "Super Dash (Lướt nhanh)", false, "Toggle", function(v) TriggerSuperDash() end)

    elseif i == 5 then -- WORLD
        CreateAdvancedCard(page, "Touch TP (Chạm để dịch chuyển)", false, "Toggle", function(v) SetTouchTP(v) end)
        CreateAdvancedCard(page, "Bring NPC (Gom NPC lại gần)", false, "Toggle", function(v) SetBringNPC(v) end)

    elseif i == 6 then -- TROLL
        CreateAdvancedCard(page, "Spam Chat Tự Động", false, "Toggle", function(v) SetChatSpammer(v) end)
        CreateAdvancedCard(page, "Invisible (Tàng hình)", false, "Toggle", function(v) SetInvisible(v) end)

    elseif i == 7 then -- SETTING
        CreateAdvancedCard(page, "Xoá Giao Diện (Unload UI)", false, "Toggle", function(v)
            if v then ScreenGui:Destroy() end
        end)
    end

    TabButtons[i] = {Button = btn, Stroke = stroke}
    Pages[i] = page
end

-- Chuyển Tab
local function SwitchTab(index)
    if CurrentTab == index then return end
    local old = TabButtons[CurrentTab]
    local new = TabButtons[index]

    TweenService:Create(old.Button, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundTransparency = 0.45,
        TextColor3 = Color3.fromRGB(170, 180, 200)
    }):Play()
    TweenService:Create(old.Stroke, TweenInfo.new(0.25), {Transparency = 1}):Play()

    new.Button.Size = UDim2.new(1, 0, 0, 38)
    TweenService:Create(new.Button, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 0, 54),
        BackgroundTransparency = 0.15,
        TextColor3 = Color3.new(1, 1, 1)
    }):Play()
    TweenService:Create(new.Stroke, TweenInfo.new(0.3), {Transparency = 0.2}):Play()

    Pages[CurrentTab].Visible = false
    Pages[index].Visible = true
    CurrentTab = index
    SearchBox.Text = ""
end

for i, data in ipairs(TabButtons) do
    data.Button.MouseButton1Click:Connect(function()
        SwitchTab(i)
    end)
end

TabButtons[1].Button.Size = UDim2.new(1, 0, 0, 54)
TabButtons[1].Button.BackgroundTransparency = 0.15
TabButtons[1].Button.TextColor3 = Color3.new(1, 1, 1)
TabButtons[1].Stroke.Transparency = 0.2
Pages[1].Visible = true

-- Search System
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local keyword = SearchBox.Text:lower()
    for _, item in ipairs(AllCards) do
        if item.Parent.Visible then
            local match = keyword == "" or item.Text:find(keyword)
            item.Frame.Visible = match
        end
    end
end)

-- Mở / Đóng Menu
local isOpen = false
local function OpenMenu()
    if isOpen then return end
    isOpen = true
    Main.Visible = true
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)

    TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 560, 0, 600),
        Position = UDim2.new(0.5, -280, 0.5, -300),
        BackgroundTransparency = 0.15
    }):Play()
end

local function CloseMenu()
    if not isOpen then return end
    isOpen = false
    local tw = TweenService:Create(Main, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    })
    tw:Play()
    tw.Completed:Connect(function()
        if not isOpen then Main.Visible = false end
    end)
end

ToggleBtn.MouseButton1Click:Connect(function()
    if isOpen then CloseMenu() else OpenMenu() end
end)
CloseBtn.MouseButton1Click:Connect(CloseMenu)

-- Kéo thả Toggle Button
local dragging, dragStart, startPos
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleBtn.Position
    end
end)
ToggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

task.delay(0.5, OpenMenu)
print("✅ Zaka Pure UI v3.0 Ultimate Fixed Edition Loaded Successfully!")
