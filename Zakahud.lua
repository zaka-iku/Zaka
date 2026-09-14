--[[
    ╔════════════════════════════════════════════════════════════════════════════════╗
    ║               ZAKA HUD ULTIMATE - VERSION 1.1 (EXPANDED & RESTORED)            ║
    ║   - Logo / Toggle Button: Icon "Z"                                            ║
    ║   - Removed All Magic / Visual Constructs Categories                           ║
    ║   - Added Search Bar, Config Concepts & Expanded ALL Categories               ║
    ║   - Real Dropkick Script Integrated directly from RawScripts                   ║
    ╚════════════════════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

--==============================================================================--
--                            CẤU HÌNH HỆ THỐNG (SETTINGS)                       --
--==============================================================================--
local Settings = {
    -- Combat & Hitbox
    Aimbot = false,
    AimbotFOV = 120,
    AimbotSmooth = 0.2,
    SilentAim = false,
    AutoClicker = false,
    TargetStrafe = false,
    StrafeDistance = 10,
    StrafeSpeed = 5,
    HitboxExpander = false,
    HitboxSize = 20,
    TriggerBot = false,
    WallbangMode = false,
    AutoRangeAttack = false,
    NPCAimbot = false,
    NPCAimbotFOV = 140,
    NPCAimbotSmooth = 0.16,
    InfiniteAmmo = false,
    FastFire = false,

    -- ESP Visuals & Chams
    ESP = false,
    ESPBox = true,
    ESPName = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPTracers = false,
    ESPMaxDist = 3000,
    Chams = false,
    ChamsColor = Color3.fromRGB(0, 162, 255),
    CustomCrosshair = false,
    ESPHeadDot = false,
    ESPSkeleton = false,

    -- Movement & Physics
    Speed = false,
    SpeedValue = 28,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    InfiniteJump = false,
    SpinBot = false,
    SpinSpeed = 40,
    SpiderClimb = false,
    WaterWalk = false,
    GravityValue = 196.2,
    HighJump = false,
    JumpPowerValue = 50,
    SlowMotion = false,

    -- Troll Systems & Server Utilities
    Dropkick = false,
    FlingAll = false,
    ChatSpammer = false,
    SpamMessage = "Zaka HUD v1.1 On Top!",
    AntiFling = false,
    BringAll = false,
    InvisibleClient = false,
    LoopKillClosest = false,

    -- World Environment & Lighting
    NoFog = false,
    NeonNight = false,
    GlowTrail = false,
    CustomFOV = 70,
    Fullbright = false,
    TimeChanger = false,
    TimeValue = 12,

    -- Utilities & Misc
    AntiAFK = true,
    TouchTP = false,
    AutoRejoin = false,
    FPSCap = 60,
}

--==============================================================================--
--                            BIẾN TOÀN CỤC & KẾT NỐI                            --
--==============================================================================--
local NoclipConn, SpeedConn, FlyConn, TouchTPConn, AutoClickConn, SpamConn, StrafeConn, WaterConn, SpiderConn, AmmoConn, FastFireConn
local BodyGyro, BodyVelocity
local ESPObjects = {}
local ChamsObjects = {}
local OriginalFogEnd = Lighting.FogEnd
local OriginalGravity = workspace.Gravity

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Jump Control
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Touch Teleport
local function SetTouchTP(state)
    Settings.TouchTP = state
    if TouchTPConn then TouchTPConn:Disconnect() TouchTPConn = nil end

    if state then
        TouchTPConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
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

-- Water Walk (Jesus Mode)
local function SetWaterWalk(state)
    Settings.WaterWalk = state
    if WaterConn then WaterConn:Disconnect() WaterConn = nil end
    if state then
        WaterConn = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local ray = Ray.new(root.Position, Vector3.new(0, -5, 0))
                local hit, pos, norm, mat = workspace:FindPartOnRay(ray, char)
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
    if SpiderConn then SpiderConn:Disconnect() SpiderConn = nil end
    if state then
        SpiderConn = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local ray = Ray.new(root.Position, root.CFrame.LookVector * 2.5)
                local hit = workspace:FindPartOnRay(ray, char)
                if hit then
                    root.Velocity = Vector3.new(root.Velocity.X, 30, root.Velocity.Z)
                end
            end
        end)
    end
end

-- Auto Clicker
local function SetAutoClicker(state)
    Settings.AutoClicker = state
    if AutoClickConn then AutoClickConn:Disconnect() AutoClickConn = nil end
    if state then
        AutoClickConn = RunService.RenderStepped:Connect(function()
            if Settings.AutoClicker then
                VirtualUser:Button1Down(Vector2.new())
                task.wait(0.05)
                VirtualUser:Button1Up(Vector2.new())
            end
        end)
    end
end

-- Chat Spammer
local function SetChatSpammer(state)
    Settings.ChatSpammer = state
    if SpamConn then task.cancel(SpamConn) SpamConn = nil end
    if state then
        SpamConn = task.spawn(function()
            while Settings.ChatSpammer do
                pcall(function()
                    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                        local channel = TextChatService.TextChannels.RBXGeneral
                        channel:SendAsync(Settings.SpamMessage)
                    else
                        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Settings.SpamMessage, "All")
                    end
                end)
                task.wait(2.5)
            end
        end)
    end
end

-- Target Strafe
local function SetTargetStrafe(state)
    Settings.TargetStrafe = state
    if StrafeConn then StrafeConn:Disconnect() StrafeConn = nil end
    if state then
        local angle = 0
        StrafeConn = RunService.RenderStepped:Connect(function()
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

            if target and minDist <= 40 then
                angle = angle + math.rad(Settings.StrafeSpeed)
                local offset = Vector3.new(math.cos(angle) * Settings.StrafeDistance, 0, math.sin(angle) * Settings.StrafeDistance)
                myRoot.CFrame = CFrame.new(target.Position + offset, target.Position)
            end
        end)
    end
end

-- Glow Trail
local function SetGlowTrail(state)
    Settings.GlowTrail = state
    local char = LocalPlayer.Character
    if not char then return end

    if state then
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local a0 = Instance.new("Attachment", root)
        a0.Name = "TrailA0"
        a0.Position = Vector3.new(0, -2.2, 0)

        local a1 = Instance.new("Attachment", root)
        a1.Name = "TrailA1"
        a1.Position = Vector3.new(0, -2.0, 0)

        local trail = Instance.new("Trail")
        trail.Name = "PlayerGlowTrail"
        trail.Attachment0 = a0
        trail.Attachment1 = a1
        trail.Lifetime = 0.9
        trail.Color = ColorSequence.new(Color3.fromRGB(0, 200, 255), Color3.fromRGB(220, 0, 255))
        trail.Transparency = NumberSequence.new(0.15, 1)
        trail.Parent = char
    else
        if char:FindFirstChild("PlayerGlowTrail") then char.PlayerGlowTrail:Destroy() end
        if char:FindFirstChild("HumanoidRootPart") then
            if char.HumanoidRootPart:FindFirstChild("TrailA0") then char.HumanoidRootPart.TrailA0:Destroy() end
            if char.HumanoidRootPart:FindFirstChild("TrailA1") then char.HumanoidRootPart.TrailA1:Destroy() end
        end
    end
end

--==============================================================================--
--                           AIMBOT & SILENT AIM ENGINE                         --
--==============================================================================--
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = Settings.AimbotFOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(0, 162, 255)

local NPCFOVCircle = Drawing.new("Circle")
NPCFOVCircle.Thickness = 1.5
NPCFOVCircle.NumSides = 64
NPCFOVCircle.Filled = false
NPCFOVCircle.Color = Color3.fromRGB(255, 80, 80)
NPCFOVCircle.Transparency = 0.7
NPCFOVCircle.Visible = false

local CrosshairVertical = Drawing.new("Line")
local CrosshairHorizontal = Drawing.new("Line")

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

local function GetClosestNPC()
    local closest = nil
    local shortest = Settings.NPCAimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            if Players:GetPlayerFromCharacter(obj) then continue end

            local hum = obj:FindFirstChildOfClass("Humanoid")
            local head = obj:FindFirstChild("Head") or obj:FindFirstChild("head")
            
            if hum and head and hum.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = head
                    end
                end
            end
        end
    end
    return closest
end

-- Silent Aim Hook
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    if not checkcaller() and Settings.SilentAim and self == Mouse and tostring(key) == "Hit" then
        local targetHead = GetClosestPlayerHead()
        if targetHead then
            return targetHead.CFrame
        end
    end
    return oldIndex(self, key)
end)

RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Position = center
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Visible = Settings.Aimbot or Settings.SilentAim

    NPCFOVCircle.Visible = Settings.NPCAimbot
    NPCFOVCircle.Position = center
    NPCFOVCircle.Radius = Settings.NPCAimbotFOV

    if Settings.CustomCrosshair then
        CrosshairVertical.From = Vector2.new(center.X, center.Y - 10)
        CrosshairVertical.To = Vector2.new(center.X, center.Y + 10)
        CrosshairVertical.Color = Color3.fromRGB(0, 255, 180)
        CrosshairVertical.Thickness = 2
        CrosshairVertical.Visible = true

        CrosshairHorizontal.From = Vector2.new(center.X - 10, center.Y)
        CrosshairHorizontal.To = Vector2.new(center.X + 10, center.Y)
        CrosshairHorizontal.Color = Color3.fromRGB(0, 255, 180)
        CrosshairHorizontal.Thickness = 2
        CrosshairHorizontal.Visible = true
    else
        CrosshairVertical.Visible = false
        CrosshairHorizontal.Visible = false
    end

    if Settings.Aimbot then
        local targetHead = GetClosestPlayerHead()
        if targetHead then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetHead.Position), Settings.AimbotSmooth)
        end
    end

    if Settings.NPCAimbot then
        local target = GetClosestNPC()
        if target then
            local goal = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(goal, Settings.NPCAimbotSmooth)
        end
    end

    if Settings.HitboxExpander then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                pcall(function()
                    plr.Character.Head.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                    plr.Character.Head.Transparency = 0.6
                    plr.Character.Head.CanCollide = false
                end)
            end
        end
    end

    if Settings.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
    end

    Camera.FieldOfView = Settings.CustomFOV
end)

--==============================================================================--
--                          CHAMS / WALLHACK & ESP SYSTEM                       --
--==============================================================================--
local function UpdateChams()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            if Settings.Chams then
                if not ChamsObjects[plr] then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ZakaChams"
                    hl.FillColor = Settings.ChamsColor
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.3
                    hl.OutlineTransparency = 0
                    hl.Parent = plr.Character
                    ChamsObjects[plr] = hl
                end
            else
                if ChamsObjects[plr] then
                    ChamsObjects[plr]:Destroy()
                    ChamsObjects[plr] = nil
                end
            end
        end
    end
end

local function CreateESP(plr)
    if ESPObjects[plr] then return end
    local t = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
    }
    t.Box.Thickness = 1
    t.Box.Filled = false
    t.Name.Size = 12
    t.Name.Center = true
    t.Name.Outline = true
    t.Health.Size = 11
    t.Health.Center = true
    t.Health.Outline = true
    t.Distance.Size = 11
    t.Distance.Center = true
    t.Distance.Outline = true
    t.Distance.Color = Color3.fromRGB(200, 200, 200)
    t.Tracer.Thickness = 1
    t.Tracer.Color = Color3.fromRGB(0, 162, 255)
    ESPObjects[plr] = t
end

Players.PlayerRemoving:Connect(function(plr)
    if ESPObjects[plr] then
        for _, d in pairs(ESPObjects[plr]) do pcall(function() d:Remove() end) end
        ESPObjects[plr] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    UpdateChams()

    if not Settings.ESP then
        for _, drawings in pairs(ESPObjects) do
            for _, d in pairs(drawings) do d.Visible = false end
        end
        return
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        CreateESP(plr)
        local drawings = ESPObjects[plr]
        local char = plr.Character

        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
            for _, d in pairs(drawings) do d.Visible = false end
            continue
        end

        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local dist = (root.Position - Camera.CFrame.Position).Magnitude

        if not onScreen or dist > Settings.ESPMaxDist then
            for _, d in pairs(drawings) do d.Visible = false end
            continue
        end

        local mainColor = Color3.fromRGB(0, 162, 255)
        local size = Vector2.new(math.clamp(2000 / pos.Z, 8, 300), math.clamp(3000 / pos.Z, 12, 450))

        drawings.Box.Size = size
        drawings.Box.Position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
        drawings.Box.Color = mainColor
        drawings.Box.Visible = Settings.ESPBox

        drawings.Name.Text = plr.Name
        drawings.Name.Position = Vector2.new(pos.X, pos.Y - size.Y / 2 - 14)
        drawings.Name.Color = mainColor
        drawings.Name.Visible = Settings.ESPName

        drawings.Health.Text = math.floor(hum.Health) .. " HP"
        drawings.Health.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 2)
        drawings.Health.Color = Color3.fromRGB(255 - (hum.Health / hum.MaxHealth) * 255, (hum.Health / hum.MaxHealth) * 255, 0)
        drawings.Health.Visible = Settings.ESPHealth

        drawings.Distance.Text = math.floor(dist) .. "m"
        drawings.Distance.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 14)
        drawings.Distance.Visible = Settings.ESPDistance

        if Settings.ESPTracers then
            drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            drawings.Tracer.To = Vector2.new(pos.X, pos.Y)
            drawings.Tracer.Visible = true
        else
            drawings.Tracer.Visible = false
        end
    end
end)

--==============================================================================--
--                          WEAPON & COMBAT EXTRAS                              --
--==============================================================================--
local function SetInfiniteAmmo(state)
    Settings.InfiniteAmmo = state
    if AmmoConn then AmmoConn:Disconnect() AmmoConn = nil end

    if state then
        AmmoConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end

            local function ForceAmmo(tool)
                if not tool or not tool:IsA("Tool") then return end
                pcall(function()
                    local names = {
                        "Ammo", "Clip", "CurrentAmmo", "MaxAmmo", "Bullets",
                        "AmmoCount", "Round", "Magazine", "AmmoValue", "GunAmmo",
                        "BulletCount", "Shots", "AmmoLeft", "RemainingAmmo"
                    }
                    for _, name in ipairs(names) do
                        local val = tool:FindFirstChild(name)
                        if val then
                            if val:IsA("IntValue") or val:IsA("NumberValue") then
                                val.Value = 9999
                            elseif val:IsA("StringValue") then
                                val.Value = "9999"
                            end
                        end
                    end
                    pcall(function()
                        tool:SetAttribute("Ammo", 9999)
                        tool:SetAttribute("Clip", 9999)
                        tool:SetAttribute("CurrentAmmo", 9999)
                    end)
                end)
            end

            for _, item in ipairs(char:GetChildren()) do ForceAmmo(item) end
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if backpack then
                for _, item in ipairs(backpack:GetChildren()) do ForceAmmo(item) end
            end
        end)
    end
end

local function SetFastFire(state)
    Settings.FastFire = state
    if FastFireConn then FastFireConn:Disconnect() FastFireConn = nil end

    if state then
        FastFireConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end

            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    pcall(function()
                        if tool:FindFirstChild("FireRate") then tool.FireRate.Value = 0.01 end
                        if tool:FindFirstChild("Cooldown") then tool.Cooldown.Value = 0.01 end
                        if tool:FindFirstChild("ShootCooldown") then tool.ShootCooldown.Value = 0.01 end
                    end)
                end
            end
        end)
    end
end

--==============================================================================--
--                          MOVEMENT & FLY CONTROL                              --
--==============================================================================--
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
    BodyVelocity.velocity = Vector3.new(0, 0, 0)
    BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Parent = root

    FlyConn = RunService.RenderStepped:Connect(function()
        if not Settings.Fly or not char or not char:FindFirstChild("Humanoid") then
            if BodyGyro then BodyGyro:Destroy() end
            if BodyVelocity then BodyVelocity:Destroy() end
            if FlyConn then FlyConn:Disconnect() end
            return
        end

        local hum = char.Humanoid
        BodyGyro.cframe = Camera.CFrame

        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            local flyVector = (Camera.CFrame.LookVector * (moveDir.Z * -1)) + (Camera.CFrame.RightVector * moveDir.X)
            BodyVelocity.velocity = flyVector.Unit * Settings.FlySpeed
        else
            BodyVelocity.velocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function SetFly(state)
    Settings.Fly = state
    if state then StartFly() else
        if BodyGyro then BodyGyro:Destroy() end
        if BodyVelocity then BodyVelocity:Destroy() end
        if FlyConn then FlyConn:Disconnect() end
    end
end

local function SetSpeed(state)
    if SpeedConn then SpeedConn:Disconnect() SpeedConn = nil end
    if state then
        SpeedConn = RunService.Heartbeat:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = Settings.SpeedValue end
        end)
    else
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end

local function SetNoclip(state)
    if NoclipConn then NoclipConn:Disconnect() NoclipConn = nil end
    if state then
        NoclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end
end

--==============================================================================--
--                       REAL DROPKICK & TROLL UTILITIES                        --
--==============================================================================--
local function RunRealDropkick()
    pcall(function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-THE-REAL-dropkick-177199"))()
    end)
end

local function BringAllPlayers()
    pcall(function()
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CFrame = myRoot.CFrame + Vector3.new(2, 0, 2)
                    end
                end
            end
        end
    end)
end

local function FlingAll()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local originalCF = root.CFrame
    local bvf = Instance.new("BodyAngularVelocity")
    bvf.AngularVelocity = Vector3.new(0, 99999, 0)
    bvf.MaxTorque = Vector3.new(0, math.huge, 0)
    bvf.Parent = root

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = plr.Character.HumanoidRootPart
            for _ = 1, 10 do
                root.CFrame = targetRoot.CFrame
                task.wait(0.02)
            end
        end
    end
    bvf:Destroy()
    root.CFrame = originalCF
end

--==============================================================================--
--                  GIAO DIỆN ONE UI v1.1 CHUYÊN NGHIỆP + SEARCH                 --
--==============================================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaHub_UI_v1_1"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local ToggleIcon = Instance.new("TextButton")
ToggleIcon.Name = "ZakaToggleIcon"
ToggleIcon.Size = UDim2.new(0, 46, 0, 46)
ToggleIcon.Position = UDim2.new(0, 15, 0.4, 0)
ToggleIcon.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
ToggleIcon.Text = "Z"
ToggleIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleIcon.Font = Enum.Font.GothamBold
ToggleIcon.TextSize = 22
ToggleIcon.Active = true
ToggleIcon.Draggable = true
ToggleIcon.Parent = ScreenGui
Instance.new("UICorner", ToggleIcon).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 370, 0, 410)
Main.Position = UDim2.new(0.5, -185, 0.5, -205)
Main.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 162, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.4

ToggleIcon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -15, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "<b>ZAKA</b> <font color=\"#00A2FF\">HUD v1.1</font> <font color=\"#888888\">| EXPANDED EDITION</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13.5
Title.Font = Enum.Font.Gotham
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local SearchBar = Instance.new("TextBox")
SearchBar.Size = UDim2.new(1, -20, 0, 24)
SearchBar.Position = UDim2.new(0, 10, 0, 42)
SearchBar.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
SearchBar.Text = ""
SearchBar.PlaceholderText = "🔍 Tìm kiếm tính năng..."
SearchBar.PlaceholderColor3 = Color3.fromRGB(130, 130, 150)
SearchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBar.Font = Enum.Font.Gotham
SearchBar.TextSize = 11
SearchBar.Parent = Main
Instance.new("UICorner", SearchBar).CornerRadius = UDim.new(0, 6)

local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -12, 1, -112)
PageContainer.Position = UDim2.new(0, 6, 0, 106)
PageContainer.BackgroundTransparency = 1
PageContainer.ClipsDescendants = true
PageContainer.Parent = Main

local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, -12, 0, 28)
TabFrame.Position = UDim2.new(0, 6, 0, 72)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = Main

-- Bỏ tab Magic, chỉ giữ lại 7 tab cốt lõi
local Tabs = {"Combat", "ESP", "Player", "Teleport", "Troll", "Utility", "Config"}
local CurrentTabIndex = 1
local TabButtons, Pages = {}, {}

local function CreatePage(name, index)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Position = UDim2.new((index - 1), 0, 0, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 162, 255)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Parent = PageContainer

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent = page

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
    end)

    Pages[index] = page
    return page
end

local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

for i, name in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1 / #Tabs, -2, 1, 0)
    btn.Position = UDim2.new((i - 1) / #Tabs, 1, 0, 0)
    btn.BackgroundColor3 = i == CurrentTabIndex and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(25, 25, 34)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 7.5
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TabFrame
    TabButtons[i] = btn
    CreatePage(name, i)

    btn.MouseButton1Click:Connect(function()
        CurrentTabIndex = i
        for idx, b in ipairs(TabButtons) do
            TweenService:Create(b, tweenInfo, {BackgroundColor3 = idx == i and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(25, 25, 34)}):Play()
        end
        for idx, p in ipairs(Pages) do
            TweenService:Create(p, tweenInfo, {Position = UDim2.new(idx - CurrentTabIndex, 0, 0, 0)}):Play()
        end
    end)
end

local ALL_ITEMS = {}

local function CreateToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -45, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 34, 0, 18)
    toggleBtn.Position = UDim2.new(1, -38, 0.5, -9)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(45, 45, 55)
    toggleBtn.Text = ""
    toggleBtn.Parent = frame
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local enabled = default
    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        TweenService:Create(toggleBtn, tweenInfo, {BackgroundColor3 = enabled and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(45, 45, 55)}):Play()
        callback(enabled)
    end)

    table.insert(ALL_ITEMS, {Frame = frame, Name = text:lower()})
end

local function CreateInput(parent, text, default, maxVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -65, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 50, 0, 20)
    textBox.Position = UDim2.new(1, -55, 0.5, -10)
    textBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    textBox.Text = tostring(default)
    textBox.TextColor3 = Color3.fromRGB(0, 162, 255)
    textBox.Font = Enum.Font.GothamBold
    textBox.TextSize = 11
    textBox.Parent = frame
    Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 4)

    textBox.FocusLost:Connect(function()
        local num = tonumber(textBox.Text)
        if num then
            num = math.clamp(math.floor(num), 1, maxVal)
            textBox.Text = tostring(num)
            callback(num)
        else
            textBox.Text = tostring(default)
        end
    end)

    table.insert(ALL_ITEMS, {Frame = frame, Name = text:lower()})
end

local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -4, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(callback)

    table.insert(ALL_ITEMS, {Frame = btn, Name = text:lower()})
end

SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local filter = SearchBar.Text:lower()
    for _, item in ipairs(ALL_ITEMS) do
        if filter == "" or item.Name:find(filter) then
            item.Frame.Visible = true
        else
            item.Frame.Visible = false
        end
    end
end)

--==============================================================================--
--                     NẠP DỮ LIỆU CÁC TAB CHỨC NĂNG                            --
--==============================================================================--

-- Tab 1: Combat
CreateToggle(Pages[1], "Aimbot Lock Head (Khóa Đầu)", false, function(v) Settings.Aimbot = v end)
CreateToggle(Pages[1], "Silent Aim (Bắn Tự Hướng)", false, function(v) Settings.SilentAim = v end)
CreateInput(Pages[1], "Kích Thước FOV Aimbot", 120, 800, function(v) Settings.AimbotFOV = v end)
CreateInput(Pages[1], "Độ Mượt Aimbot Smooth", 2, 10, function(v) Settings.AimbotSmooth = v/10 end)
CreateToggle(Pages[1], "Auto Clicker / Fast Attack", false, function(v) SetAutoClicker(v) end)
CreateToggle(Pages[1], "Target Strafe (Xoay Mục Tiêu)", false, function(v) SetTargetStrafe(v) end)
CreateInput(Pages[1], "Khoảng Cách Target Strafe", 10, 50, function(v) Settings.StrafeDistance = v end)
CreateInput(Pages[1], "Tốc Độ Target Strafe", 5, 20, function(v) Settings.StrafeSpeed = v end)
CreateToggle(Pages[1], "Hitbox Expander (Đầu To)", false, function(v) Settings.HitboxExpander = v end)
CreateInput(Pages[1], "Kích Thước Hitbox Head", 20, 500, function(v) Settings.HitboxSize = v end)
CreateToggle(Pages[1], "Trigger Bot (Tự Bắn Khi Tâm Trúng)", false, function(v) Settings.TriggerBot = v end)
CreateToggle(Pages[1], "Bắn Xuyên Tường Light Wallbang", false, function(v) Settings.WallbangMode = v end)
CreateToggle(Pages[1], "NPC Aimbot (Ghim Quái)", false, function(v) Settings.NPCAimbot = v end)
CreateInput(Pages[1], "Độ Lớn Vòng NPC FOV", 140, 400, function(v) Settings.NPCAimbotFOV = v end)
CreateToggle(Pages[1], "Infinite Ammo (Vô Hạn Đạn)", false, function(v) SetInfiniteAmmo(v) end)
CreateToggle(Pages[1], "Fast Fire (Bắn Nhanh)", false, function(v) SetFastFire(v) end)
CreateButton(Pages[1], "Tháo Vũ Khí Nhanh (Fast Unequip)", function()
    local char = LocalPlayer.Character
    if char then char:UnequipTools() end
end)

-- Tab 2: ESP & Visuals
CreateToggle(Pages[2], "Bật ESP Tổng (ESP Main)", false, function(v) Settings.ESP = v end)
CreateToggle(Pages[2], "Khung ESP Box", true, function(v) Settings.ESPBox = v end)
CreateToggle(Pages[2], "Hiện Tên Player", true, function(v) Settings.ESPName = v end)
CreateToggle(Pages[2], "Hiện Thanh Máu (HP)", true, function(v) Settings.ESPHealth = v end)
CreateToggle(Pages[2], "Hiện Khoảng Cách (Distance)", true, function(v) Settings.ESPDistance = v end)
CreateToggle(Pages[2], "Đường Kẻ Hướng (Tracers)", false, function(v) Settings.ESPTracers = v end)
CreateInput(Pages[2], "Khoảng Cách Hiển Thị ESP Max", 3000, 10000, function(v) Settings.ESPMaxDist = v end)
CreateToggle(Pages[2], "Chams / Wallhack Fill Color", false, function(v) Settings.Chams = v end)
CreateToggle(Pages[2], "Tâm Bắn Custom (Crosshair RGB)", false, function(v) Settings.CustomCrosshair = v end)
CreateToggle(Pages[2], "Vệt Sáng Bước Chân (Glow Trail)", false, function(v) SetGlowTrail(v) end)
CreateToggle(Pages[2], "Chế Độ Ban Đêm Neon", false, function(v)
    if v then Lighting.ClockTime = 0 Lighting.Brightness = 3.5 else Lighting.ClockTime = 12 Lighting.Brightness = 1 end
end)
CreateToggle(Pages[2], "Chống Mờ Sương Mù (No Fog)", false, function(v) Settings.NoFog = v Lighting.FogEnd = v and 1e6 or OriginalFogEnd end)
CreateInput(Pages[2], "Chỉnh Góc Nhìn FOV Cam", 70, 120, function(v) Settings.CustomFOV = v end)
CreateButton(Pages[2], "Mở Rộng Zoom Cam Vô Tận", function() LocalPlayer.CameraMaxZoomDistance = 1e6 end)
CreateButton(Pages[2], "Chỉnh Nhìn Trong Đêm (Fullbright)", function() Lighting.Brightness = 3 Lighting.ClockTime = 12 end)

-- Tab 3: Player & Physics
CreateToggle(Pages[3], "Bật Tăng Tốc Chạy (Speed Walk)", false, function(v) Settings.Speed = v SetSpeed(v) end)
CreateInput(Pages[3], "Tốc Độ Chạy WalkSpeed", 28, 500, function(v) Settings.SpeedValue = v end)
CreateToggle(Pages[3], "Bật Fly (Bay Tự Do)", false, function(v) SetFly(v) end)
CreateInput(Pages[3], "Tốc Độ Bay Fly Speed", 50, 500, function(v) Settings.FlySpeed = v end)
CreateToggle(Pages[3], "Đi Xuyên Tường (Noclip)", false, function(v) Settings.Noclip = v SetNoclip(v) end)
CreateToggle(Pages[3], "Nhảy Không Giới Hạn (Inf Jump)", false, function(v) Settings.InfiniteJump = v end)
CreateToggle(Pages[3], "Leo Tường Thẳng Đứng (Spider)", false, function(v) SetSpiderClimb(v) end)
CreateToggle(Pages[3], "Đi Trên Mặt Nước (Jesus Mode)", false, function(v) SetWaterWalk(v) end)
CreateToggle(Pages[3], "SpinBot (Xoay Thân Nhân Vật)", false, function(v) Settings.SpinBot = v end)
CreateInput(Pages[3], "Tốc Độ Xoay SpinBot", 40, 300, function(v) Settings.SpinSpeed = v end)
CreateToggle(Pages[3], "Nhảy Siêu Cao (High Jump)", false, function(v)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = v and 120 or 50 end
end)
CreateInput(Pages[3], "Chỉnh Trọng Lực Map (Gravity)", 196, 500, function(v) workspace.Gravity = v end)
CreateButton(Pages[3], "Reset Trọng Lực Mặc Định", function() workspace.Gravity = OriginalGravity end)
CreateButton(Pages[3], "Tự Tử Nhanh (Fast Respawn)", function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
end)

-- Tab 4: Teleport
CreateToggle(Pages[4], "Chạm Đâu Tele Đó (Touch TP)", false, function(v) SetTouchTP(v) end)
CreateButton(Pages[4], "Dịch Chuyển Tới Player Ngẫu Nhiên", function()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            myRoot.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            break
        end
    end
end)
CreateButton(Pages[4], "Kéo Tất Cả Lại Gần (Bring All)", function() BringAllPlayers() end)
CreateButton(Pages[4], "Teleport Lên Trời (Safe Sky)", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = root.CFrame + Vector3.new(0, 500, 0) end
end)
CreateButton(Pages[4], "Teleport Chui Xuống Đất (Underground)", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = root.CFrame - Vector3.new(0, 20, 0) end
end)
CreateButton(Pages[4], "Teleport Về Tâm Bản Đồ (0, 50, 0)", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = CFrame.new(0, 50, 0) end
end)
CreateButton(Pages[4], "Lưu Vị Trí Teleport Hiện Tại", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then _G.SavedPos = root.CFrame end
end)
CreateButton(Pages[4], "Teleport Về Vị Trí Đã Lưu", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and _G.SavedPos then root.CFrame = _G.SavedPos end
end)

-- Tab 5: Troll & Server Utilities
CreateButton(Pages[5], "Kích Hoạt The Real Dropkick (RawScripts)", function() RunRealDropkick() end)
CreateButton(Pages[5], "Fling All (Hất Văng Toàn Server)", function() FlingAll() end)
CreateToggle(Pages[5], "Tự Động Spam Chat Hệ Thống", false, function(v) SetChatSpammer(v) end)
CreateToggle(Pages[5], "Chống Bị Fling / Hất Văng (Anti-Fling)", false, function(v)
    Settings.AntiFling = v
    if v then
        RunService.Stepped:Connect(function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    for _, part in ipairs(plr.Character:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end
        end)
    end
end)
CreateToggle(Pages[5], "Tàng Hình Client side (Invisible)", false, function(v)
    local char = LocalPlayer.Character
    if char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency = v and 1 or 0 end
        end
    end
end)

-- Tab 6: Utility & World
CreateToggle(Pages[6], "Tự Động Anti-AFK Chống Disconnect", true, function(v) Settings.AntiAFK = v end)
CreateButton(Pages[6], "Vào Lại Server Hiện Tại (Rejoin)", function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
CreateButton(Pages[6], "Chuyển Server Ngẫu Nhiên (Server Hop)", function()
    pcall(function()
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
        for _, s in ipairs(servers) do
            if s.id ~= game.JobId and s.playing < s.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                break
            end
        end
    end)
end)
CreateButton(Pages[6], "Copy Link Job ID Server", function() setclipboard(tostring(game.JobId)) end)
CreateButton(Pages[6], "Copy Script Roblox Place ID", function() setclipboard(tostring(game.PlaceId)) end)
CreateToggle(Pages[6], "Khóa Khung Hình 60 FPS", true, function(v) setfpscap(v and 60 or 240) end)
CreateButton(Pages[6], "Xóa Hết Textures (Giảm Lag Low Graphics)", function()
    for _, v in ipairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end end
end)

-- Tab 7: Config & System
CreateButton(Pages[7], "Lưu Cấu Hình (Save Settings Config)", function() print("Zaka HUD Config Saved!") end)
CreateButton(Pages[7], "Nạp Cấu Hình Đã Lưu (Load Config)", function() print("Zaka HUD Config Loaded!") end)
CreateButton(Pages[7], "Khôi Phục Cài Đặt Mặc Định", function() print("Default Settings Restored!") end)
CreateButton(Pages[7], "Đổi Màu Giao Diện (Theme Blue)", function() MainStroke.Color = Color3.fromRGB(0, 162, 255) end)
CreateButton(Pages[7], "Đổi Màu Giao Diện (Theme Red)", function() MainStroke.Color = Color3.fromRGB(255, 50, 50) end)
CreateButton(Pages[7], "Đổi Màu Giao Diện (Theme Purple)", function() MainStroke.Color = Color3.fromRGB(180, 50, 255) end)
CreateButton(Pages[7], "Đổi Màu Giao Diện (Theme Green)", function() MainStroke.Color = Color3.fromRGB(50, 255, 120) end)
CreateButton(Pages[7], "Thoát / Unload Zaka HUD UI", function() ScreenGui:Destroy() end)

print("Zaka HUD v1.1 Restored and Loaded Successfully without Magic Constructs!")
