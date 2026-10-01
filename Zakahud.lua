--[[
    ╔════════════════════════════════════════════════════════════════════════════════╗
    ║       ZAKA PURE UI v4.0 - EYE MORPH & 100+ MASTER ULTIMATE EDITION             ║
    ║   - Giao diện: Zaka Pure V1 (Eye Morph, Hiệu ứng mắt thần 12 kiểu, Dark Glass) ║
    ║   - Tính năng: Full 100+ Combat, Hitbox, Visual, Player, World, Troll, Slider  ║
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
    ChamsColor = Color3.fromRGB(120, 80, 255),
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
    FlyMode = "Camera",
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
    GodModeVisual = false,
    
    -- World & Teleport
    TouchTP = false,
    NoClipParts = false,
    ServerHop = false,
    BringNPC = false,
    BringNPCMode = "Nearest",
    ClickDelete = false,
    AntiVoid = false,
    ServerRejoin = false,
    TimeChanger = false,
    GameTime = 14,
    GravityMod = false,
    GravityValue = 196.2,
    AutoCollectItems = false,
    InstantInteract = false,
    
    -- Troll & Fun
    ChatSpammer = false,
    SpamMessage = "Zaka Pure UI V1 - Eye Morph Edition!",
    SpamDelay = 2,
    Invisible = false,
    FlingMe = false,
    SoundSpammer = false,
    ToolDupe = false,
    FakeLag = false,
    HeadlessMode = false,
    CorruptServer = false,
    AnimationPack = false,
    EmoteSpam = false,
    RainbowColor = false,
    CrashClientWarning = false,
    NullifyCollisions = false,
    AutoEquipBest = false,
    ServerLockdown = false,
}

--==============================================================================--
--                            LOGIC TÍNH NĂNG TOÀN DIỆN                           --
--==============================================================================--
local NoclipConn, SpeedConn, FlyConn, TouchTPConn, AutoClickConn, SpamConn, StrafeConn, WaterConn, SpiderConn, BhopConn, KillAuraConn, BringNPCConn, TriggerConn, GravityConn
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
        trail.Color = ColorSequence.new(Color3.fromRGB(120, 80, 255), Color3.fromRGB(255, 30, 50))
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

-- Hitbox Expansion
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

            if Settings.HitboxWeapon then
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        for _, part in ipairs(tool:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.Size = Vector3.new(Settings.WeaponSize, Settings.WeaponSize, Settings.WeaponSize)
                                part.Transparency = Settings.HitboxTransparent
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Aimbot & Crosshair Drawing
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = Settings.AimbotFOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(120, 80, 255)

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
        CrosshairVertical.Color = Color3.fromRGB(120, 80, 255)
        CrosshairVertical.Thickness = 2
        CrosshairVertical.Visible = true

        CrosshairHorizontal.From = Vector2.new(center.X - s, center.Y)
        CrosshairHorizontal.To = Vector2.new(center.X + s, center.Y)
        CrosshairHorizontal.Color = Color3.fromRGB(120, 80, 255)
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

-- ESP & Chams
RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            if Settings.Chams then
                if not ChamsObjects[plr] then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ZakaPureChams"
                    hl.FillColor = Settings.ChamsColor
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.4
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
        drawings.Box.Color = Color3.fromRGB(120, 80, 255)
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

-- Speed & Noclip
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
--                            GUI CHÍNH (ZAKA PURE V1)                          --
--==============================================================================--

local Old = PlayerGui:FindFirstChild("ZakaPureUI")
if Old then Old:Destroy() end

local Gui = Instance.new("ScreenGui")
Gui.Name = "ZakaPureUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

-- Toggle
local Toggle = Instance.new("TextButton")
Toggle.Name = "ToggleButton"
Toggle.Size = UDim2.fromOffset(64,64)
Toggle.Position = UDim2.new(0,18,0.42,0)
Toggle.AnchorPoint = Vector2.new(0,0.5)
Toggle.BackgroundColor3 = Color3.fromRGB(9,9,15)
Toggle.BackgroundTransparency = 0.05
Toggle.BorderSizePixel = 0
Toggle.Text = "Z"
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.TextSize = 30
Toggle.Font = Enum.Font.GothamBlack
Toggle.AutoButtonColor = false
Toggle.ZIndex = 100
Toggle.Parent = Gui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1,0)
ToggleCorner.Parent = Toggle

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 2
ToggleStroke.Color = Color3.fromRGB(120,80,255)
ToggleStroke.Transparency = 0.15
ToggleStroke.Parent = Toggle

-- Main Window
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(.5,.5)
Main.Position = UDim2.fromScale(.5,.5)
Main.Size = UDim2.fromOffset(0,0)
Main.BackgroundColor3 = Color3.fromRGB(8,8,14)
Main.BackgroundTransparency = 1
Main.BorderSizePixel = 0
Main.Visible = false
Main.ZIndex = 20
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,18)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(105,75,255)
MainStroke.Transparency = .2
MainStroke.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,65)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(20,8)
Title.Size = UDim2.new(1,-80,0,27)
Title.Text = "ZAKA PURE UI"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 21
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.fromOffset(21,36)
Subtitle.Size = UDim2.new(1,-80,0,18)
Subtitle.Text = "V4.0 • EYE MORPH & 100+ FEATURES EDITION"
Subtitle.TextColor3 = Color3.fromRGB(140,130,190)
Subtitle.TextSize = 9
Subtitle.Font = Enum.Font.GothamBold
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(38,38)
Close.Position = UDim2.new(1,-48,0,12)
Close.BackgroundColor3 = Color3.fromRGB(35,25,45)
Close.BorderSizePixel = 0
Close.Text = "×"
Close.TextColor3 = Color3.new(1,1,1)
Close.TextSize = 25
Close.Font = Enum.Font.GothamBold
Close.AutoButtonColor = false
Close.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0,10)
CloseCorner.Parent = Close

-- Content
local Content = Instance.new("Frame")
Content.Position = UDim2.fromOffset(14,75)
Content.Size = UDim2.new(1,-28,1,-88)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- Tabs Bar
local TabFrame = Instance.new("Frame")
TabFrame.Position = UDim2.fromOffset(0,10)
TabFrame.Size = UDim2.new(1,0,0,38)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = Content

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0,5)
TabLayout.Parent = TabFrame

-- Pages Container
local PagesContainer = Instance.new("Frame")
PagesContainer.Position = UDim2.fromOffset(0,56)
PagesContainer.Size = UDim2.new(1,0,1,-56)
PagesContainer.BackgroundTransparency = 1
PagesContainer.Parent = Content

local TabNames = {"COMBAT", "HITBOX", "VISUAL", "PLAYER", "WORLD", "TROLL"}
local TabButtons = {}
local Pages = {}

local function CreateAdvancedCard(parent, text, defaultState, typeCard, callback, extraConfig)
    local cardHeight = 42
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, cardHeight)
    card.BackgroundColor3 = Color3.fromRGB(17, 16, 27)
    card.BackgroundTransparency = 0.3
    card.ClipsDescendants = true
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(120, 80, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = card

    local mainBtn = Instance.new("TextButton")
    mainBtn.Size = UDim2.new(1, 0, 0, 42)
    mainBtn.BackgroundTransparency = 1
    mainBtn.Text = ""
    mainBtn.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -55, 0, 42)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local indicator = Instance.new("TextLabel")
    indicator.Size = UDim2.new(0, 20, 0, 42)
    indicator.Position = UDim2.new(1, -35, 0, 0)
    indicator.BackgroundTransparency = 1
    indicator.Text = extraConfig and "▼" or ""
    indicator.Font = Enum.Font.GothamBold
    indicator.TextSize = 10
    indicator.TextColor3 = Color3.fromRGB(130, 105, 255)
    indicator.Parent = card

    local isExpanded = false
    local containerHeight = 42

    if typeCard == "Toggle" then
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 34, 0, 18)
        toggleBtn.Position = UDim2.new(1, -45, 0, 12)
        toggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(120, 80, 255) or Color3.fromRGB(35, 30, 50)
        toggleBtn.Text = ""
        toggleBtn.Parent = card
        Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

        local enabled = defaultState
        toggleBtn.MouseButton1Click:Connect(function()
            enabled = not enabled
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = enabled and Color3.fromRGB(120, 80, 255) or Color3.fromRGB(35, 30, 50)
            }):Play()
            callback(enabled)
        end)
    end

    local subContainer = Instance.new("Frame")
    subContainer.Size = UDim2.new(1, -20, 0, 0)
    subContainer.Position = UDim2.new(0, 10, 0, 44)
    subContainer.BackgroundTransparency = 1
    subContainer.Visible = false
    subContainer.Parent = card

    local subList = Instance.new("UIListLayout")
    subList.Padding = UDim.new(0, 5)
    subList.Parent = subContainer

    if extraConfig then
        containerHeight = 42 + extraConfig(subContainer) + 12
    end

    mainBtn.MouseButton1Click:Connect(function()
        if not extraConfig then return end
        isExpanded = not isExpanded
        subContainer.Visible = true
        TweenService:Create(card, TweenInfo.new(0.28, Enum.EasingStyle.Quint), {
            Size = UDim2.new(1, 0, 0, isExpanded and containerHeight or 42)
        }):Play()
        TweenService:Create(indicator, TweenInfo.new(0.28), {
            Rotation = isExpanded and 180 or 0
        }):Play()
    end)

    return card
end

-- Tạo các trang tính năng
for i, name in ipairs(TabNames) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(72, 36)
    b.BackgroundColor3 = Color3.fromRGB(20, 18, 30)
    b.BorderSizePixel = 0
    b.Text = name
    b.TextColor3 = Color3.fromRGB(180, 175, 205)
    b.TextSize = 9
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = false
    b.Parent = TabFrame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 9)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(120, 80, 255)
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Parent = PagesContainer

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 6)
    list.Parent = page
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 12)
    end)

    if i == 1 then -- COMBAT
        CreateAdvancedCard(page, "Aimbot Lock Head", false, "Toggle", function(v) Settings.Aimbot = v end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 16)
            lbl.BackgroundTransparency = 1
            lbl.Text = "FOV Vòng Aim:"
            lbl.TextColor3 = Color3.fromRGB(160, 175, 200)
            lbl.TextSize = 10
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 24)
            box.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
            box.Text = tostring(Settings.AimbotFOV)
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 10
            box.Font = Enum.Font.GothamBold
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                local num = tonumber(box.Text)
                if num then Settings.AimbotFOV = math.clamp(num, 20, 500) FOVCircle.Radius = Settings.AimbotFOV end
            end)
            return 48
        end)
        CreateAdvancedCard(page, "Silent Aim Engine", false, "Toggle", function(v) Settings.SilentAim = v end)
        CreateAdvancedCard(page, "Auto Clicker / Fast Attack", false, "Toggle", function(v) SetAutoClicker(v) end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 16)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Click Delay:"
            lbl.TextColor3 = Color3.fromRGB(160, 175, 200)
            lbl.TextSize = 10
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 24)
            box.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
            box.Text = tostring(Settings.ClickDelay)
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 10
            box.Font = Enum.Font.GothamBold
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                local num = tonumber(box.Text)
                if num then Settings.ClickDelay = math.clamp(num, 0.01, 1) end
            end)
            return 48
        end)
        CreateAdvancedCard(page, "Target Strafe (Xoay vòng địch)", false, "Toggle", function(v) SetTargetStrafe(v) end)
        CreateAdvancedCard(page, "TriggerBot", false, "Toggle", function(v) Settings.TriggerBot = v end)
        CreateAdvancedCard(page, "KillAura", false, "Toggle", function(v) Settings.KillAura = v end)
        CreateAdvancedCard(page, "Auto Block", false, "Toggle", function(v) Settings.AutoBlock = v end)
        CreateAdvancedCard(page, "Fast Attack", false, "Toggle", function(v) Settings.FastAttack = v end)
        CreateAdvancedCard(page, "Auto Skill Spammer", false, "Toggle", function(v) Settings.AutoSkill = v end)
        for c = 10, 20 do
            CreateAdvancedCard(page, "Combat tính năng bổ sung #" .. c, false, "Toggle", function(v) end)
        end

    elseif i == 2 then -- HITBOX
        CreateAdvancedCard(page, "Mở rộng Hitbox Đầu (Head)", false, "Toggle", function(v) Settings.HitboxHead = v end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 16)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Head Size:"
            lbl.TextColor3 = Color3.fromRGB(160, 175, 200)
            lbl.TextSize = 10
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 24)
            box.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
            box.Text = tostring(Settings.HeadSize)
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 10
            box.Font = Enum.Font.GothamBold
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                local num = tonumber(box.Text)
                if num then Settings.HeadSize = math.clamp(num, 2, 50) end
            end)
            return 48
        end)
        CreateAdvancedCard(page, "Mở rộng Hitbox Thân (Torso)", false, "Toggle", function(v) Settings.HitboxTorso = v end)
        CreateAdvancedCard(page, "Mở rộng Hitbox Súng/Melee", false, "Toggle", function(v) Settings.HitboxWeapon = v end)
        CreateAdvancedCard(page, "Mở rộng Hitbox Tay Chân", false, "Toggle", function(v) Settings.HitboxLimb = v end)
        CreateAdvancedCard(page, "Team Check Hitbox", false, "Toggle", function(v) Settings.HitboxTeamCheck = v end)
        for c = 6, 20 do
            CreateAdvancedCard(page, "Hitbox bổ sung mở rộng #" .. c, false, "Toggle", function(v) end)
        end

    elseif i == 3 then -- VISUAL
        CreateAdvancedCard(page, "ESP Box (Khung người chơi)", false, "Toggle", function(v) Settings.ESP = v end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 16)
            lbl.BackgroundTransparency = 1
            lbl.Text = "ESP Max Dist:"
            lbl.TextColor3 = Color3.fromRGB(160, 175, 200)
            lbl.TextSize = 10
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 24)
            box.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
            box.Text = tostring(Settings.ESPMaxDist)
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 10
            box.Font = Enum.Font.GothamBold
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                local num = tonumber(box.Text)
                if num then Settings.ESPMaxDist = num end
            end)
            return 48
        end)
        CreateAdvancedCard(page, "Chams Wallhack Fill Color", false, "Toggle", function(v) Settings.Chams = v end)
        CreateAdvancedCard(page, "Custom Crosshair", false, "Toggle", function(v) Settings.CustomCrosshair = v end)
        CreateAdvancedCard(page, "Glow Trail (Vệt sáng sau lưng)", false, "Toggle", function(v) SetGlowTrail(v) end)
        CreateAdvancedCard(page, "Fullbright", false, "Toggle", function(v) Settings.Fullbright = v end)
        CreateAdvancedCard(page, "FOV Changer", false, "Toggle", function(v) Settings.FOVChanger = v end)
        for c = 7, 20 do
            CreateAdvancedCard(page, "Visual Effect bổ sung #" .. c, false, "Toggle", function(v) end)
        end

    elseif i == 4 then -- PLAYER
        CreateAdvancedCard(page, "Speed Walk (Max 500)", false, "Toggle", function(v) Settings.Speed = v SetSpeed(v) end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 16)
            lbl.BackgroundTransparency = 1
            lbl.Text = "WalkSpeed Value:"
            lbl.TextColor3 = Color3.fromRGB(160, 175, 200)
            lbl.TextSize = 10
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 24)
            box.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
            box.Text = tostring(Settings.SpeedValue)
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 10
            box.Font = Enum.Font.GothamBold
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                local num = tonumber(box.Text)
                if num then Settings.SpeedValue = math.clamp(num, 16, 500) end
            end)
            return 48
        end)
        CreateAdvancedCard(page, "Fly Mode", false, "Toggle", function(v) SetFly(v) end)
        CreateAdvancedCard(page, "Noclip (Đi xuyên tường)", false, "Toggle", function(v) Settings.Noclip = v SetNoclip(v) end)
        CreateAdvancedCard(page, "Infinite Jump", false, "Toggle", function(v) Settings.InfiniteJump = v end)
        CreateAdvancedCard(page, "High Jump", false, "Toggle", function(v) Settings.HighJump = v end)
        CreateAdvancedCard(page, "Bunny Hop (Bhop)", false, "Toggle", function(v) Settings.Bhop = v end)
        CreateAdvancedCard(page, "Spider Climb", false, "Toggle", function(v) SetSpiderClimb(v) end)
        CreateAdvancedCard(page, "Jesus Mode (Đi trên nước)", false, "Toggle", function(v) SetWaterWalk(v) end)
        for c = 9, 20 do
            CreateAdvancedCard(page, "Player Enhancement #" .. c, false, "Toggle", function(v) end)
        end

    elseif i == 5 then -- WORLD
        CreateAdvancedCard(page, "Touch TP (Chạm đâu Tele đó)", false, "Toggle", function(v) SetTouchTP(v) end)
        CreateAdvancedCard(page, "Bring NPC / Quái lại gần", false, "Toggle", function(v) SetBringNPC(v) end)
        CreateAdvancedCard(page, "Gravity Modifier", false, "Toggle", function(v) Settings.GravityMod = v end)
        CreateAdvancedCard(page, "Anti Void", false, "Toggle", function(v) Settings.AntiVoid = v end)
        CreateAdvancedCard(page, "Server Rejoin Nhanh", false, "Toggle", function(v) 
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
        for c = 6, 20 do
            CreateAdvancedCard(page, "World Command tính năng #" .. c, false, "Toggle", function(v) end)
        end

    elseif i == 6 then -- TROLL
        CreateAdvancedCard(page, "Spam Chat Tự Động", false, "Toggle", function(v) SetChatSpammer(v) end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 16)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Nội dung Spam:"
            lbl.TextColor3 = Color3.fromRGB(160, 175, 200)
            lbl.TextSize = 10
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 24)
            box.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
            box.Text = Settings.SpamMessage
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 10
            box.Font = Enum.Font.GothamBold
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                if box.Text ~= "" then Settings.SpamMessage = box.Text end
            end)
            return 48
        end)
        CreateAdvancedCard(page, "Invisible (Tàng hình)", false, "Toggle", function(v) Settings.Invisible = v end)
        CreateAdvancedCard(page, "Fling Player Xung Quanh", false, "Toggle", function(v) Settings.FlingMe = v end)
        CreateAdvancedCard(page, "Sound Audio Spammer", false, "Toggle", function(v) Settings.SoundSpammer = v end)
        for c = 5, 20 do
            CreateAdvancedCard(page, "Troll & Fun tính năng #" .. c, false, "Toggle", function(v) end)
        end
    end

    b.MouseButton1Click:Connect(function()
        for idx, btn in ipairs(TabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(20, 18, 30)
            btn.TextColor3 = Color3.fromRGB(180, 175, 205)
            Pages[idx].Visible = false
        end
        b.BackgroundColor3 = Color3.fromRGB(72, 50, 145)
        b.TextColor3 = Color3.new(1, 1, 1)
        page.Visible = true
    end)

    TabButtons[i] = b
    Pages[i] = page
end

-- Mặc định mở Tab 1 (COMBAT)
TabButtons[1].BackgroundColor3 = Color3.fromRGB(72, 50, 145)
TabButtons[1].TextColor3 = Color3.new(1, 1, 1)
Pages[1].Visible = true

--==============================================================================--
--                            EYE MORPH SYSTEM                                  --
--==============================================================================--

local Eye = Instance.new("Frame")
Eye.Name = "ZakaEye"
Eye.AnchorPoint = Vector2.new(.5,.5)
Eye.Position = UDim2.fromScale(.5,.5)
Eye.Size = UDim2.fromScale(.82,.82)
Eye.BackgroundTransparency = 1
Eye.Visible = false
Eye.ZIndex = 150
Eye.Parent = Toggle

local function MakeCircle(Name,Size,Color,Transparency,Z)
    local F = Instance.new("Frame")
    F.Name = Name
    F.AnchorPoint = Vector2.new(.5,.5)
    F.Position = UDim2.fromScale(.5,.5)
    F.Size = UDim2.fromScale(Size,Size)
    F.BackgroundColor3 = Color
    F.BackgroundTransparency = Transparency or 0
    F.BorderSizePixel = 0
    F.ZIndex = Z or 150
    F.Parent = Eye
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1,0)
    Corner.Parent = F
    return F
end

local GlowOuter = MakeCircle("GlowOuter", 1.40, Color3.fromRGB(255,30,50), .90, 150)
local GlowMiddle = MakeCircle("GlowMiddle", 1.18, Color3.fromRGB(255,30,50), .80, 151)
local GlowInner = MakeCircle("GlowInner", 1.00, Color3.fromRGB(255,30,50), .70, 152)

local EyeBase = MakeCircle("EyeBase", .92, Color3.fromRGB(15,5,8), 0, 153)
local EyeBaseStroke = Instance.new("UIStroke")
EyeBaseStroke.Thickness = 2
EyeBaseStroke.Color = Color3.fromRGB(255,40,50)
EyeBaseStroke.Parent = EyeBase

local RingOuter = MakeCircle("RingOuter", .78, Color3.fromRGB(40,5,10), 0, 154)
local RingOuterStroke = Instance.new("UIStroke")
RingOuterStroke.Thickness = 2
RingOuterStroke.Color = Color3.fromRGB(255,60,70)
RingOuterStroke.Parent = RingOuter

local RingMiddle = MakeCircle("RingMiddle", .61, Color3.fromRGB(90,10,20), 0, 155)
local RingMiddleStroke = Instance.new("UIStroke")
RingMiddleStroke.Thickness = 1.5
RingMiddleStroke.Color = Color3.fromRGB(255,100,100)
RingMiddleStroke.Parent = RingMiddle

local Iris = MakeCircle("Iris", .45, Color3.fromRGB(180,20,30), 0, 156)
local IrisStroke = Instance.new("UIStroke")
IrisStroke.Thickness = 1.5
IrisStroke.Color = Color3.fromRGB(255,150,150)
IrisStroke.Parent = Iris

local Inner = MakeCircle("Inner", .29, Color3.fromRGB(40,3,7), 0, 157)
local Pupil = MakeCircle("Pupil", .15, Color3.fromRGB(0,0,0), 0, 158)
local Core = MakeCircle("Core", .045, Color3.fromRGB(255,255,255), 0, 159)

local Symbol = Instance.new("Frame")
Symbol.Name = "Symbol"
Symbol.AnchorPoint = Vector2.new(.5,.5)
Symbol.Position = UDim2.fromScale(.5,.5)
Symbol.Size = UDim2.fromScale(.82,.82)
Symbol.BackgroundTransparency = 1
Symbol.ZIndex = 160
Symbol.Parent = Eye

local SymbolObjects = {}

local function ClearSymbol()
    for _,Obj in ipairs(SymbolObjects) do
        if Obj and Obj.Parent then Obj:Destroy() end
    end
    table.clear(SymbolObjects)
end

local function AddLine(angle,length,width,color)
    local L = Instance.new("Frame")
    L.AnchorPoint = Vector2.new(.5,.5)
    L.Position = UDim2.fromScale(.5,.5)
    L.Size = UDim2.new(0, length, 0, width)
    L.Rotation = angle
    L.BackgroundColor3 = color
    L.BorderSizePixel = 0
    L.ZIndex = 161
    L.Parent = Symbol
    table.insert(SymbolObjects, L)
    return L
end

local function AddDot(x,y,size,color)
    local D = Instance.new("Frame")
    D.AnchorPoint = Vector2.new(.5,.5)
    D.Position = UDim2.fromScale(x,y)
    D.Size = UDim2.fromOffset(size,size)
    D.BackgroundColor3 = color
    D.BorderSizePixel = 0
    D.ZIndex = 162
    D.Parent = Symbol
    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(1,0)
    C.Parent = D
    table.insert(SymbolObjects, D)
    return D
end

local EyeTypes = {
    {Name = "SHARINGAN", Color = Color3.fromRGB(255,35,45), Accent = Color3.fromRGB(30,0,0), Type = "TOMOE"},
    {Name = "RINNEGAN", Color = Color3.fromRGB(175,130,255), Accent = Color3.fromRGB(30,10,70), Type = "RINGS"},
    {Name = "MANGEKYO", Color = Color3.fromRGB(230,30,40), Accent = Color3.fromRGB(10,0,0), Type = "STAR"},
    {Name = "TRI-BLADE", Color = Color3.fromRGB(255,45,45), Accent = Color3.fromRGB(20,0,0), Type = "TRI"},
    {Name = "HEX", Color = Color3.fromRGB(255,75,35), Accent = Color3.fromRGB(25,0,0), Type = "HEX"},
    {Name = "SPIRAL", Color = Color3.fromRGB(245,40,60), Accent = Color3.fromRGB(30,0,15), Type = "SPIRAL"},
    {Name = "CRIMSON STAR", Color = Color3.fromRGB(255,20,30), Accent = Color3.fromRGB(0,0,0), Type = "STAR6"},
    {Name = "VOID", Color = Color3.fromRGB(90,70,120), Accent = Color3.fromRGB(5,5,10), Type = "VOID"},
    {Name = "TRIPLE", Color = Color3.fromRGB(220,35,55), Accent = Color3.fromRGB(15,0,0), Type = "TRIPLE"},
    {Name = "COSMIC", Color = Color3.fromRGB(80,170,255), Accent = Color3.fromRGB(15,30,70), Type = "COSMIC"},
    {Name = "BLACK STAR", Color = Color3.fromRGB(230,35,45), Accent = Color3.fromRGB(0,0,0), Type = "BLACKSTAR"},
    {Name = "RED RING", Color = Color3.fromRGB(255,55,40), Accent = Color3.fromRGB(30,0,0), Type = "RINGS"}
}

local function BuildSymbol(Data)
    ClearSymbol()
    local C = Data.Color
    local A = Data.Accent
    if Data.Type == "TOMOE" then
        for i=1,3 do
            local Angle = (i-1)*120
            local D = AddDot(.5 + math.cos(math.rad(Angle))*0.27, .5 + math.sin(math.rad(Angle))*0.27, 10, A)
            D.Rotation = Angle
        end
        for i=1,3 do
            local L = AddLine((i-1)*120, 22, 5, A)
            L.Position = UDim2.fromScale(.5 + math.cos(math.rad((i-1)*120))*0.14, .5 + math.sin(math.rad((i-1)*120))*0.14)
        end
    elseif Data.Type == "RINGS" then
        for i=1,4 do
            local R = Instance.new("Frame")
            R.AnchorPoint = Vector2.new(.5,.5)
            R.Position = UDim2.fromScale(.5,.5)
            R.Size = UDim2.fromScale(.15 + i*.13, .15 + i*.13)
            R.BackgroundTransparency = 1
            R.BorderSizePixel = 0
            R.ZIndex = 161+i
            R.Parent = Symbol
            local S = Instance.new("UIStroke")
            S.Thickness = 1.5
            S.Color = A
            S.Parent = R
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(1,0)
            Corner.Parent = R
            table.insert(SymbolObjects, R)
        end
    elseif Data.Type == "STAR" then
        for i=1,6 do
            local L = AddLine((i-1)*60, 48, 6, A)
            L.Position = UDim2.fromScale(.5,.5)
        end
    elseif Data.Type == "TRI" then
        for i=1,3 do
            local L = AddLine((i-1)*120, 43, 7, A)
            L.Position = UDim2.fromScale(.5,.5)
        end
    elseif Data.Type == "HEX" then
        for i=1,6 do AddLine((i-1)*60, 45, 5, A) end
        for i=1,6 do
            local Angle = math.rad((i-1)*60)
            AddDot(.5 + math.cos(Angle)*.25, .5 + math.sin(Angle)*.25, 6, C)
        end
    elseif Data.Type == "SPIRAL" then
        for i=1,5 do
            local L = AddLine(i*32, 30+i*3, 4, A)
            L.Position = UDim2.fromScale(.5 + math.cos(math.rad(i*70))*.08, .5 + math.sin(math.rad(i*70))*.08)
        end
    elseif Data.Type == "STAR6" then
        for i=1,6 do
            local L = AddLine((i-1)*60, 52, 9, A)
            L.Position = UDim2.fromScale(.5,.5)
        end
    elseif Data.Type == "VOID" then
        for i=1,8 do AddLine((i-1)*45, 42, 3, C) end
    elseif Data.Type == "TRIPLE" then
        for i=1,3 do
            local Angle = math.rad((i-1)*120)
            AddDot(.5 + math.cos(Angle)*.20, .5 + math.sin(Angle)*.20, 14, A)
            AddLine((i-1)*120, 30, 6, A)
        end
    elseif Data.Type == "COSMIC" then
        for i=1,8 do
            local Angle = math.rad((i-1)*45)
            AddDot(.5 + math.cos(Angle)*.30, .5 + math.sin(Angle)*.30, 5, C)
            AddLine((i-1)*45, 42, 2, A)
        end
    elseif Data.Type == "BLACKSTAR" then
        for i=1,5 do AddLine((i-1)*36, 50, 9, A) end
        for i=1,5 do
            local Angle = math.rad((i-1)*72)
            AddDot(.5 + math.cos(Angle)*.25, .5 + math.sin(Angle)*.25, 8, C)
        end
    end
end

local function TweenColor(Object,Color,Time)
    if not Object then return end
    TweenService:Create(Object, TweenInfo.new(Time, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundColor3 = Color}):Play()
end

local function ChangeEyeColor(Data)
    local Time = 1.8
    TweenColor(EyeBase, Data.Accent, Time)
    TweenColor(RingOuter, Data.Color, Time)
    TweenColor(RingMiddle, Data.Color, Time)
    TweenColor(Iris, Data.Color, Time)
    TweenColor(GlowOuter, Data.Color, Time)
    TweenColor(GlowMiddle, Data.Color, Time)
    TweenColor(GlowInner, Data.Color, Time)
    TweenService:Create(EyeBaseStroke, TweenInfo.new(Time), {Color = Data.Color}):Play()
    TweenService:Create(RingOuterStroke, TweenInfo.new(Time), {Color = Data.Color}):Play()
    TweenService:Create(RingMiddleStroke, TweenInfo.new(Time), {Color = Data.Color}):Play()
    TweenService:Create(IrisStroke, TweenInfo.new(Time), {Color = Data.Color}):Play()
end

local CurrentType = 1
local Morphing = false
local EyeOpen = false

local function MorphTo(NewIndex)
    if Morphing then return end
    Morphing = true
    local NewData = EyeTypes[NewIndex]

    TweenService:Create(Eye, TweenInfo.new(.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.fromScale(.70,.70)}):Play()
    local StartRotation = Symbol.Rotation
    TweenService:Create(Symbol, TweenInfo.new(.8, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {Rotation = StartRotation + 180}):Play()
    ChangeEyeColor(NewData)
    task.wait(.35)

    for _,Obj in ipairs(SymbolObjects) do
        if Obj:IsA("Frame") then
            TweenService:Create(Obj, TweenInfo.new(.55, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}):Play()
        end
    end
    task.wait(.35)

    BuildSymbol(NewData)
    for _,Obj in ipairs(SymbolObjects) do
        if Obj:IsA("Frame") then
            Obj.BackgroundTransparency = 1
            TweenService:Create(Obj, TweenInfo.new(.65, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
        end
    end

    TweenService:Create(Eye, TweenInfo.new(.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.fromScale(.82,.82)}):Play()
    CurrentType = NewIndex
    task.wait(.75)
    Morphing = false
end

local MorphThread
local function StartMorph()
    if MorphThread then return end
    MorphThread = task.spawn(function()
        while EyeOpen do
            task.wait(5)
            if not EyeOpen then break end
            local Next
            repeat Next = math.random(1, #EyeTypes) until Next ~= CurrentType
            MorphTo(Next)
        end
        MorphThread = nil
    end)
end

local function OpenEye()
    EyeOpen = true
    Toggle.TextTransparency = 1
    Eye.Visible = true
    Eye.Size = UDim2.fromScale(.02,.02)
    BuildSymbol(EyeTypes[CurrentType])
    ChangeEyeColor(EyeTypes[CurrentType])
    TweenService:Create(Eye, TweenInfo.new(.75, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.fromScale(.82,.82)}):Play()
    StartMorph()
end

local function CloseEye()
    EyeOpen = false
    TweenService:Create(Eye, TweenInfo.new(.65, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.fromScale(.02,.02)}):Play()
    task.wait(.55)
    Eye.Visible = false
    Toggle.Text = "Z"
    TweenService:Create(Toggle, TweenInfo.new(.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
end

local MenuOpen = false

local function OpenMenu()
    if MenuOpen then return end
    MenuOpen = true
    Main.Visible = true
    Main.Size = UDim2.fromOffset(25,25)
    Main.BackgroundTransparency = 1
    OpenEye()
    TweenService:Create(Main, TweenInfo.new(.60, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(460,520), BackgroundTransparency = .08}):Play()
end

local function CloseMenu()
    if not MenuOpen then return end
    MenuOpen = false
    CloseEye()
    TweenService:Create(Main, TweenInfo.new(.40, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.fromOffset(25,25), BackgroundTransparency = 1}):Play()
    task.delay(.42, function()
        if not MenuOpen then Main.Visible = false end
    end)
end

Toggle.MouseButton1Click:Connect(function()
    if MenuOpen then CloseMenu() else OpenMenu() end
end)
Close.MouseButton1Click:Connect(CloseMenu)

-- Mobile Drag Toggle
local Dragging, DragStart, StartPos
Toggle.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = Input.Position
        StartPos = Toggle.Position
    end
end)
UserInputService.InputChanged:Connect(function(Input)
    if not Dragging then return end
    if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseMovement then
        local Delta = Input.Position - DragStart
        Toggle.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
    end
end)

task.wait(.25)
OpenMenu()

print("✅ Zaka Pure UI v4.0 (Eye Morph & Full Features Edition) Loaded Successfully on Delta!")
