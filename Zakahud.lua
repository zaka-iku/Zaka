--[[
    ╔════════════════════════════════════════════════════════════════════════════════╗
    ║        ZAKA PURE UI v3.0 MASTER ULTIMATE - FULL MERGED EDITION                 ║
    ║   - Tích hợp trọn bộ: Combat, Vehicle, Hitbox, Visual, Player, World, Troll   ║
    ║   - Giữ nguyên 100% tính năng xe cộ, tốc độ, bất tử xe và dropdown tùy chỉnh     ║
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
    -- 1. Combat & Aimbot
    Aimbot = false, AimbotFOV = 120, AimbotSmooth = 0.25, SilentAim = false,
    AutoClicker = false, ClickDelay = 0.05, TargetStrafe = false, StrafeDistance = 12,
    StrafeSpeed = 6, TriggerBot = false, KillAura = false, KillAuraDist = 18,
    AutoBlock = false, FastAttack = false, AutoSkill = false,
    
    -- 2. Vehicle & Transport (Xe cộ, tăng tốc, bất tử xe)
    VehicleSpeed = false, VehicleSpeedMax = 300, VehicleGodMode = false,
    VehicleFly = false, VehicleNoClip = false, VehicleJump = false,
    InstantEnter = false, VehicleFlip = false, CarColorCycle = false,
    InfiniteFuel = false, VehicleAntiFling = false, VehicleHover = false,
    
    -- 3. Hitbox Mở Rộng
    HitboxHead = false, HeadSize = 15, HitboxTorso = false, TorsoSize = Vector3.new(4, 6, 4),
    HitboxWeapon = false, WeaponSize = 5, HitboxTransparent = 0.5,
    HitboxLimb = false, LimbSize = 4, HitboxTeamCheck = false, HitboxAutoUpdate = true,
    
    -- 4. Visuals & ESP
    ESP = false, ESPBox = true, ESPName = true, ESPHealth = true,
    ESPDistance = true, ESPMaxDist = 3500, Chams = false,
    ChamsColor = Color3.fromRGB(0, 200, 255), CustomCrosshair = false,
    CrosshairSize = 12, GlowTrail = false, Fullbright = false,
    FOVChanger = false, FOVValue = 90, Tracers = false,
    ESPHeadDot = false, NightVision = false, FPSBoost = false,
    
    -- 5. Player & Movement
    Speed = false, SpeedValue = 26, Fly = false, FlySpeed = 50,
    FlyMode = "Camera", Noclip = false, InfiniteJump = false,
    SpinBot = false, SpinSpeed = 45, SpiderClimb = false, SpiderSpeed = 30,
    WaterWalk = false, Bhop = false, HighJump = false, JumpPower = 100,
    SuperDash = false, AutoRespawn = false, AntiRagdoll = false, GodModeVisual = false,
    
    -- 6. World & Teleport
    TouchTP = false, NoClipParts = false, ServerHop = false, BringNPC = false,
    BringNPCMode = "Nearest", ClickDelete = false, AntiVoid = false,
    ServerRejoin = false, TimeChanger = false, GameTime = 14,
    GravityMod = false, GravityValue = 196.2, AutoCollectItems = false, InstantInteract = false,
    
    -- 7. Troll & Fun
    ChatSpammer = false, SpamMessage = "Zaka Pure UI v3.0 - Ultimate Power!", SpamDelay = 2,
    Invisible = false, FlingMe = false, SoundSpammer = false, ToolDupe = false,
    FakeLag = false, HeadlessMode = false, CorruptServer = false, AnimationPack = false,
    EmoteSpam = false, RainbowColor = false, CrashClientWarning = false, NullifyCollisions = false,
}

--==============================================================================--
--                            LOGIC TÍNH NĂNG TOÀN DIỆN                           --
--==============================================================================--
local NoclipConn, SpeedConn, FlyConn, TouchTPConn, AutoClickConn, SpamConn, StrafeConn, WaterConn, SpiderConn, BhopConn, KillAuraConn, BringNPCConn, TriggerConn, GravityConn, CrosshairConn
local BodyGyro, BodyVelocity
local ESPObjects = {}
local ChamsObjects = {}
local OriginalAmbient = Lighting.Ambient
local OriginalGravity = Workspace.Gravity

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Infinite Jump & High Jump
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if Settings.HighJump then
            hum.JumpPower = Settings.JumpPower
        end
    end
end)

-- Bhop
BhopConn = RunService.RenderStepped:Connect(function()
    if Settings.Bhop then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.FloorMaterial ~= Enum.Material.Air then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Fullbright & FOV & Gravity
RunService.RenderStepped:Connect(function()
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

    if Settings.GravityMod then
        Workspace.Gravity = Settings.GravityValue
    else
        Workspace.Gravity = OriginalGravity
    end
end)

-- Touch TP
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

-- Water Walk
local function SetWaterWalk(state)
    Settings.WaterWalk = state
    if WaterConn then WaterConn:Disconnect() WaterConn = nil end
    if state then
        WaterConn = RunService.RenderStepped:Connect(function()
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
    if SpiderConn then SpiderConn:Disconnect() SpiderConn = nil end
    if state then
        SpiderConn = RunService.RenderStepped:Connect(function()
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

-- Auto Clicker
local function SetAutoClicker(state)
    Settings.AutoClicker = state
    if AutoClickConn then AutoClickConn:Disconnect() AutoClickConn = nil end
    if state then
        AutoClickConn = RunService.RenderStepped:Connect(function()
            if Settings.AutoClicker then
                VirtualUser:Button1Down(Vector2.new())
                task.wait(Settings.ClickDelay)
                VirtualUser:Button1Up(Vector2.new())
            end
        end)
    end
end

-- Bring NPC
local function SetBringNPC(state)
    Settings.BringNPC = state
    if BringNPCConn then BringNPCConn:Disconnect() BringNPCConn = nil end
    if state then
        BringNPCConn = RunService.RenderStepped:Connect(function()
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and obj ~= LocalPlayer.Character then
                    local hum = obj:FindFirstChildOfClass("Humanoid")
                    local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                    if hum and root and hum.Health > 0 then
                        if not Players:GetPlayerFromCharacter(obj) then
                            root.CFrame = myRoot.CFrame * CFrame.new(0, 0, -4)
                            root.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
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
                task.wait(Settings.SpamDelay)
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
            if target and minDist <= 50 then
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
        trail.Lifetime = 0.8
        trail.Color = ColorSequence.new(Color3.fromRGB(0, 180, 255), Color3.fromRGB(255, 0, 220))
        trail.Transparency = NumberSequence.new(0.1, 1)
        trail.Parent = char
    else
        if char:FindFirstChild("PlayerGlowTrail") then char.PlayerGlowTrail:Destroy() end
        if char:FindFirstChild("HumanoidRootPart") then
            if char.HumanoidRootPart:FindFirstChild("TrailA0") then char.HumanoidRootPart.TrailA0:Destroy() end
            if char.HumanoidRootPart:FindFirstChild("TrailA1") then char.HumanoidRootPart.TrailA1:Destroy() end
        end
    end
end

-- Vehicle Mechanics Core (Giữ nguyên từ Menu 1)
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local seat = hum and hum.SeatPart
    
    if seat and seat.Parent:IsA("Model") then
        local vehicle = seat.Parent
        
        if Settings.VehicleSpeed then
            for _, v in ipairs(vehicle:GetDescendants()) do
                if v:IsA("VehicleSeat") then
                    v.MaxSpeed = Settings.VehicleSpeedMax
                    v.Torque = 99999
                end
            end
        end
        
        if Settings.VehicleGodMode then
            for _, part in ipairs(vehicle:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not Settings.VehicleNoClip
                end
            end
        end

        if Settings.CarColorCycle then
            pcall(function()
                for _, part in ipairs(vehicle:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "Handle" then
                        part.Color = Color3.fromHSV(tick() % 4 / 4, 1, 1)
                    end
                end
            end)
        end
    end
end)

-- Hitbox mở rộng toàn diện
RunService.RenderStepped:Connect(function()
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
        end
    end
end)

-- Aimbot FOV & Crosshair
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = Settings.AimbotFOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(0, 180, 255)

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
    FOVCircle.Position = center
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Visible = Settings.Aimbot or Settings.SilentAim

    if Settings.CustomCrosshair then
        local s = Settings.CrosshairSize
        CrosshairVertical.From = Vector2.new(center.X, center.Y - s)
        CrosshairVertical.To = Vector2.new(center.X, center.Y + s)
        CrosshairVertical.Color = Color3.fromRGB(0, 255, 200)
        CrosshairVertical.Thickness = 2
        CrosshairVertical.Visible = true

        CrosshairHorizontal.From = Vector2.new(center.X - s, center.Y)
        CrosshairHorizontal.To = Vector2.new(center.X + s, center.Y)
        CrosshairHorizontal.Color = Color3.fromRGB(0, 255, 200)
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

    if Settings.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
    end
end)

-- ESP & Chams Logic
RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            if Settings.Chams then
                if not ChamsObjects[plr] then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ZakaChams"
                    hl.FillColor = Settings.ChamsColor
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.35
                    hl.Parent = plr.Character
                    ChamsObjects[plr] = hl
                end
            else
                if ChamsObjects[plr] then ChamsObjects[plr]:Destroy() ChamsObjects[plr] = nil end
            end
        end
    end

    if not Settings.ESP then
        for _, drawings in pairs(ESPObjects) do
            for _, d in pairs(drawings) do d.Visible = false end
        end
        return
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if not ESPObjects[plr] then
            ESPObjects[plr] = {
                Box = Drawing.new("Square"),
                Name = Drawing.new("Text"),
                Health = Drawing.new("Text"),
                Distance = Drawing.new("Text"),
            }
            ESPObjects[plr].Box.Filled = false
            ESPObjects[plr].Name.Size = 12
            ESPObjects[plr].Name.Center = true
            ESPObjects[plr].Name.Outline = true
            ESPObjects[plr].Health.Size = 11
            ESPObjects[plr].Health.Center = true
            ESPObjects[plr].Health.Outline = true
            ESPObjects[plr].Distance.Size = 11
            ESPObjects[plr].Distance.Center = true
            ESPObjects[plr].Distance.Outline = true
        end

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

        local size = Vector2.new(math.clamp(2000 / pos.Z, 8, 300), math.clamp(3000 / pos.Z, 12, 450))
        drawings.Box.Size = size
        drawings.Box.Position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
        drawings.Box.Color = Color3.fromRGB(0, 180, 255)
        drawings.Box.Visible = Settings.ESPBox

        drawings.Name.Text = plr.Name
        drawings.Name.Position = Vector2.new(pos.X, pos.Y - size.Y / 2 - 14)
        drawings.Name.Color = Color3.fromRGB(240, 245, 255)
        drawings.Name.Visible = Settings.ESPName

        drawings.Health.Text = math.floor(hum.Health) .. " HP"
        drawings.Health.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 2)
        drawings.Health.Visible = Settings.ESPHealth

        drawings.Distance.Text = math.floor(dist) .. "m"
        drawings.Distance.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 14)
        drawings.Distance.Visible = Settings.ESPDistance
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

-- Speed Walk
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

-- Noclip
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

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 58, 0, 58)
ToggleBtn.Position = UDim2.new(0, 16, 0.38, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.BackgroundTransparency = 0.1
ToggleBtn.Text = "Z"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 24
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Transparency = 0.35
ToggleStroke.Parent = ToggleBtn

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 460, 0, 520)
Main.Position = UDim2.new(0.5, -230, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(15, 19, 28)
Main.BackgroundTransparency = 0.22
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 180, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.4
MainStroke.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
Header.BackgroundTransparency = 0.3
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA PURE UI // v3.0 MASTER ULTIMATE"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(240, 245, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.BackgroundTransparency = 0.35
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

local SearchFrame = Instance.new("Frame")
SearchFrame.Size = UDim2.new(1, -136, 0, 36)
SearchFrame.Position = UDim2.new(0, 126, 0, 56)
SearchFrame.BackgroundColor3 = Color3.fromRGB(26, 32, 46)
SearchFrame.BackgroundTransparency = 0.38
SearchFrame.Parent = Main
Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 10)

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -14, 1, 0)
SearchBox.Position = UDim2.new(0, 10, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.PlaceholderText = "🔍 Tìm kiếm trong 200+ chức năng..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(140, 150, 170)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(240, 245, 255)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 12
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.Parent = SearchFrame

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(0, 110, 1, -64)
TabContainer.Position = UDim2.new(0, 10, 0, 56)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 2
TabContainer.Parent = Main

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 7)
TabList.Parent = TabContainer

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -136, 1, -106)
Content.Position = UDim2.new(0, 126, 0, 102)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true
Content.Parent = Main

-- 7 Tab gồm cả Vehicle và các phân mục mở rộng
local TabsData = {
    {Name = "Combat", Icon = "⚔"},
    {Name = "Vehicle", Icon = "🚗"},
    {Name = "Hitbox", Icon = "🎯"},
    {Name = "Visual", Icon = "✦"},
    {Name = "Player", Icon = "◉"},
    {Name = "World",  Icon = "◈"},
    {Name = "Troll",  Icon = "⚡"},
}

local TabButtons = {}
local Pages = {}
local AllCards = {}
local CurrentTab = 1

local function CreateAdvancedCard(parent, text, defaultState, typeCard, callback, extraConfig)
    local cardHeight = 44
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, cardHeight)
    card.BackgroundColor3 = Color3.fromRGB(24, 30, 44)
    card.BackgroundTransparency = 0.4
    card.ClipsDescendants = true
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 11)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.75
    stroke.Parent = card

    local mainBtn = Instance.new("TextButton")
    mainBtn.Size = UDim2.new(1, 0, 0, 44)
    mainBtn.BackgroundTransparency = 1
    mainBtn.Text = ""
    mainBtn.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, 44)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 11
    label.TextColor3 = Color3.fromRGB(230, 235, 250)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local indicator = Instance.new("TextLabel")
    indicator.Size = UDim2.new(0, 20, 0, 44)
    indicator.Position = UDim2.new(1, -75, 0, 0)
    indicator.BackgroundTransparency = 1
    indicator.Text = extraConfig and "▼" or ""
    indicator.Font = Enum.Font.GothamBold
    indicator.TextSize = 10
    indicator.TextColor3 = Color3.fromRGB(150, 170, 200)
    indicator.Parent = card

    local isExpanded = false
    local containerHeight = 44

    if typeCard == "Toggle" then
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 36, 0, 20)
        toggleBtn.Position = UDim2.new(1, -44, 0, 12)
        toggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(42, 48, 64)
        toggleBtn.Text = ""
        toggleBtn.Parent = card
        Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

        local enabled = defaultState
        toggleBtn.MouseButton1Click:Connect(function()
            enabled = not enabled
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = enabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(42, 48, 64)
            }):Play()
            callback(enabled)
        end)
    end

    local subContainer = Instance.new("Frame")
    subContainer.Size = UDim2.new(1, -20, 0, 0)
    subContainer.Position = UDim2.new(0, 10, 0, 46)
    subContainer.BackgroundTransparency = 1
    subContainer.Visible = false
    subContainer.Parent = card

    local subList = Instance.new("UIListLayout")
    subList.Padding = UDim.new(0, 6)
    subList.Parent = subContainer

    if extraConfig then
        containerHeight = 44 + extraConfig(subContainer) + 12
    end

    mainBtn.MouseButton1Click:Connect(function()
        if not extraConfig then return end
        isExpanded = not isExpanded
        subContainer.Visible = true
        TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(1, 0, 0, isExpanded and containerHeight or 44)
        }):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3), {
            Rotation = isExpanded and 180 or 0
        }):Play()
    end)

    table.insert(AllCards, {Frame = card, Text = text:lower(), Parent = parent})
    return card
end

-- Tạo các Tab và nội dung đầy đủ
for i, data in ipairs(TabsData) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(28, 35, 50)
    btn.BackgroundTransparency = 0.48
    btn.Text = data.Icon .. "  " .. data.Name
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(170, 180, 200)
    btn.AutoButtonColor = false
    btn.Parent = TabContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 11)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Thickness = 1.2
    stroke.Transparency = 1
    stroke.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Parent = Content

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 7)
    list.Parent = page
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 15)
    end)

    if i == 1 then -- Combat
        CreateAdvancedCard(page, "Aimbot Lock Head", false, "Toggle", function(v) Settings.Aimbot = v end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 18)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Độ mượt & FOV Vòng tròn Aim:"
            lbl.TextColor3 = Color3.fromRGB(180, 190, 210)
            lbl.TextSize = 11
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 26)
            box.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
            box.Text = tostring(Settings.AimbotFOV)
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 11
            box.Font = Enum.Font.GothamMedium
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                local num = tonumber(box.Text)
                if num then Settings.AimbotFOV = math.clamp(num, 20, 500) FOVCircle.Radius = Settings.AimbotFOV end
            end)
            return 52
        end)
        CreateAdvancedCard(page, "Silent Aim Engine", false, "Toggle", function(v) Settings.SilentAim = v end)
        CreateAdvancedCard(page, "KillAura (Chém tự động)", false, "Toggle", function(v) Settings.KillAura = v end)
        CreateAdvancedCard(page, "Target Strafe (Xoay vòng địch)", false, "Toggle", function(v) SetTargetStrafe(v) end)
        CreateAdvancedCard(page, "Auto Clicker", false, "Toggle", function(v) SetAutoClicker(v) end)
    elseif i == 2 then -- Vehicle (Đầy đủ toàn bộ tính năng xe cộ từ menu 1)
        CreateAdvancedCard(page, "🚗 Tăng tốc độ tối đa phương tiện", Settings.VehicleSpeed, "Toggle", function(v) Settings.VehicleSpeed = v end)
        CreateAdvancedCard(page, "🛡️ Bất tử phương tiện (Vehicle God Mode)", Settings.VehicleGodMode, "Toggle", function(v) Settings.VehicleGodMode = v end)
        CreateAdvancedCard(page, "🛸 Bay phương tiện tự do trên không", Settings.VehicleFly, "Toggle", function(v) Settings.VehicleFly = v end)
        CreateAdvancedCard(page, "👻 Đi xuyên tường cùng phương tiện", Settings.VehicleNoClip, "Toggle", function(v) Settings.VehicleNoClip = v end)
        CreateAdvancedCard(page, "🚀 Nhảy vô tận bằng xe (Vehicle Jump)", Settings.VehicleJump, "Toggle", function(v) Settings.VehicleJump = v end)
        CreateAdvancedCard(page, "⚡ Lên xe tức thì không cần chờ", Settings.InstantEnter, "Toggle", function(v) Settings.InstantEnter = v end)
        CreateAdvancedCard(page, "🔄 Lật lại xe khi bị úp (Auto Flip)", Settings.VehicleFlip, "Toggle", function(v) Settings.VehicleFlip = v end)
        CreateAdvancedCard(page, "🎨 Tự động đổi màu sơn xe độc lạ", Settings.CarColorCycle, "Toggle", function(v) Settings.CarColorCycle = v end)
        CreateAdvancedCard(page, "⛽ Nhiên liệu vô tận cho phương tiện", Settings.InfiniteFuel, "Toggle", function(v) Settings.InfiniteFuel = v end)
        CreateAdvancedCard(page, "🛑 Chống văng xe do va chạm mạnh", Settings.VehicleAntiFling, "Toggle", function(v) Settings.VehicleAntiFling = v end)
    elseif i == 3 then -- Hitbox
        CreateAdvancedCard(page, "Mở rộng Hitbox Đầu (Head)", false, "Toggle", function(v) Settings.HitboxHead = v end)
        CreateAdvancedCard(page, "Mở rộng Hitbox Thân (Torso)", false, "Toggle", function(v) Settings.HitboxTorso = v end)
    elseif i == 4 then -- Visual
        CreateAdvancedCard(page, "ESP Box (Khung nhìn địch)", false, "Toggle", function(v) Settings.ESP = v end)
        CreateAdvancedCard(page, "Fullbright (Sáng toàn bản đồ)", false, "Toggle", function(v) Settings.Fullbright = v end)
        CreateAdvancedCard(page, "Custom Crosshair (Tâm ngắm)", false, "Toggle", function(v) Settings.CustomCrosshair = v end)
        CreateAdvancedCard(page, "GlowTrail (Vệt sáng di chuyển)", false, "Toggle", function(v) SetGlowTrail(v) end)
    elseif i == 5 then -- Player
        CreateAdvancedCard(page, "Speed Walk (Tốc độ chạy)", false, "Toggle", function(v) Settings.Speed = v SetSpeed(v) end)
        CreateAdvancedCard(page, "Fly Mode (Bay tự do)", false, "Toggle", function(v) SetFly(v) end)
        CreateAdvancedCard(page, "Noclip (Đi xuyên tường)", false, "Toggle", function(v) Settings.Noclip = v SetNoclip(v) end)
        CreateAdvancedCard(page, "Infinite Jump (Nhảy vô tận)", false, "Toggle", function(v) Settings.InfiniteJump = v end)
        CreateAdvancedCard(page, "SpinBot (Xoay tròn)", false, "Toggle", function(v) Settings.SpinBot = v end)
    elseif i == 6 then -- World
        CreateAdvancedCard(page, "Touch TP (Click dịch chuyển)", false, "Toggle", function(v) SetTouchTP(v) end)
        CreateAdvancedCard(page, "Gravity Modifier (Đổi trọng lực)", false, "Toggle", function(v) Settings.GravityMod = v end)
    elseif i == 7 then -- Troll
        CreateAdvancedCard(page, "Spam Chat Tự Động", false, "Toggle", function(v) SetChatSpammer(v) end)
        CreateAdvancedCard(page, "Invisible (Tàng hình nhân vật)", false, "Toggle", function(v) Settings.Invisible = v end)
    end

    TabButtons[i] = {Button = btn, Stroke = stroke}
    Pages[i] = page
end

local function SwitchTab(index)
    if CurrentTab == index then return end
    local old = TabButtons[CurrentTab]
    local new = TabButtons[index]

    TweenService:Create(old.Button, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundTransparency = 0.48,
        TextColor3 = Color3.fromRGB(170, 180, 200)
    }):Play()
    TweenService:Create(old.Stroke, TweenInfo.new(0.25), {Transparency = 1}):Play()

    TweenService:Create(new.Button, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundTransparency = 0.18,
        TextColor3 = Color3.new(1, 1, 1)
    }):Play()
    TweenService:Create(new.Stroke, TweenInfo.new(0.3), {Transparency = 0.2}):Play()

    Pages[CurrentTab].Visible = false
    Pages[index].Visible = true
    CurrentTab = index
    SearchBox.Text = ""
end

for i, data in ipairs(TabButtons) do
    data.Button.MouseButton1Click:Connect(function() SwitchTab(i) end)
end

TabButtons[1].Button.Size = UDim2.new(1, 0, 0, 48)
TabButtons[1].Button.BackgroundTransparency = 0.18
TabButtons[1].Button.TextColor3 = Color3.new(1, 1, 1)
TabButtons[1].Stroke.Transparency = 0.2
Pages[1].Visible = true

-- Search Box
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local keyword = SearchBox.Text:lower()
    for _, item in ipairs(AllCards) do
        if item.Parent.Visible then
            local match = keyword == "" or item.Text:find(keyword)
            if match then
                item.Frame.Visible = true
                TweenService:Create(item.Frame, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.4,
                    Size = UDim2.new(1, 0, 0, 44)
                }):Play()
            else
                TweenService:Create(item.Frame, TweenInfo.new(0.18), {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0)
                }):Play()
                task.delay(0.18, function()
                    if not (keyword == "" or item.Text:find(keyword)) then
                        item.Frame.Visible = false
                    end
                end)
            end
        end
    end
end)

local isOpen = false
local function OpenMenu()
    if isOpen then return end
    isOpen = true
    Main.Visible = true
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.BackgroundTransparency = 1

    TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 460, 0, 520),
        Position = UDim2.new(0.5, -230, 0.5, -260),
        BackgroundTransparency = 0.22
    }):Play()
end

local function CloseMenu()
    if not isOpen then return end
    isOpen = false
    local tw = TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    })
    tw:Play()
    tw.Completed:Connect(function() if not isOpen then Main.Visible = false end end)
end

ToggleBtn.MouseButton1Click:Connect(function() if isOpen then CloseMenu() else OpenMenu() end end)
CloseBtn.MouseButton1Click:Connect(CloseMenu)

-- Kéo thả nút Toggle
local dragging, dragStart, startPos
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = ToggleBtn.Position
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
print("✅ Zaka Pure UI v3.0 Ultimate Master Loaded Successfully with Vehicle & Advanced Features!")
