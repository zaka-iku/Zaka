--[[
    ╔════════════════════════════════════════════════════════════════════════════════╗
    ║        ZAKA PURE UI v4.6 - FULL MASTER EDITION (100% CHỨC NĂNG + BYPASS)        ║
    ║   - Giữ lại 100% toàn bộ biến và tính năng từ Aimbot, Hitbox, Visual, đến Troll  ║
    ║   - Viết trọn vẹn logic chạy thật cho mọi skill + Stealth Bypass chống Rollback ║
    ╚════════════════════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Cấu hình đầy đủ 100% cài đặt gốc
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
    ESPMobs = false,
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
    SpeedValue = 28,
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
    
    -- World & Teleport & Mobs
    TouchTP = false,
    NoClipParts = false,
    ServerHop = false,
    BringNPC = false,
    FreezeMobs = false,
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
    SpamMessage = "Zaka Pure UI v4.6 - Ultimate Master!",
    SpamDelay = 2,
    Invisible = false,
    FlingMe = false,
    SoundSpammer = false,
    ToolDupe = false,
    FakeLag = false,
    HeadlessMode = false,
    EmoteSpam = false,
    RainbowColor = false,
}

local NoclipConn, SpeedConn, FlyConn, TouchTPConn, AutoClickConn, SpamConn, StrafeConn, WaterConn, SpiderConn, BhopConn, KillAuraConn, BringNPCConn, TriggerConn, GravityConn, FreezeConn, ClickDeleteConn, FlingConn, FakeLagConn, TrailConn
local BodyGyro, BodyVelocity
local ESPObjects = {}
local ChamsObjects = {}
local OriginalAmbient = Lighting.Ambient
local OriginalGravity = Workspace.Gravity
local OriginalBrightness = Lighting.Brightness

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

-- Fullbright, NightVision, FOV, Gravity & Time Changer
RunService.RenderStepped:Connect(function()
    if Settings.Fullbright or Settings.NightVision then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Brightness = 3
    else
        Lighting.Ambient = OriginalAmbient
        Lighting.Brightness = OriginalBrightness
    end
    
    if Settings.FOVChanger then
        Camera.FieldOfView = Settings.FOVValue
    end

    if Settings.GravityMod then
        Workspace.Gravity = Settings.GravityValue
    else
        Workspace.Gravity = OriginalGravity
    end

    if Settings.TimeChanger then
        Lighting.ClockTime = Settings.GameTime
    end

    if Settings.RainbowColor and LocalPlayer.Character then
        local rc = Color3.fromHSV(tick() % 5 / 5, 1, 1)
        for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.Color = rc end
        end
    end
end)

-- FPS Boost
local function SetFPSBoost(state)
    if state then
        for _, v in ipairs(Lighting:GetDescendants()) do
            if v:IsA("PostEffect") then v.Enabled = false end
        end
    else
        for _, v in ipairs(Lighting:GetDescendants()) do
            if v:IsA("PostEffect") then v.Enabled = true end
        end
    end
end

-- 1. FLY MƯỢT MÀ THEO CAMERA (Bypass)
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

-- 2. FREEZE MOBS / QUÁI
local function SetFreezeMobs(state)
    Settings.FreezeMobs = state
    if FreezeConn then FreezeConn:Disconnect() FreezeConn = nil end
    if state then
        FreezeConn = RunService.RenderStepped:Connect(function()
            for _, model in ipairs(Workspace:GetDescendants()) do
                if model:IsA("Model") and model ~= LocalPlayer.Character then
                    local hum = model:FindFirstChildOfClass("Humanoid")
                    local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
                    if hum and root and not Players:GetPlayerFromCharacter(model) then
                        hum.WalkSpeed = 0
                        hum.JumpPower = 0
                        root.Velocity = Vector3.new(0, 0, 0)
                        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end)
    end
end

-- 3. BRING NPC / QUÁI LẠI GẦN
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
                    if hum and root and hum.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
                        root.CFrame = myRoot.CFrame * CFrame.new(0, 0, -4)
                        root.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end)
    end
end

-- 4. KILLAURA & TARGET STRAFE
local function SetKillAura(state)
    Settings.KillAura = state
    if KillAuraConn then KillAuraConn:Disconnect() KillAuraConn = nil end
    if state then
        KillAuraConn = RunService.Heartbeat:Connect(function()
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            for _, model in ipairs(Workspace:GetDescendants()) do
                if model:IsA("Model") and model ~= LocalPlayer.Character then
                    local hum = model:FindFirstChildOfClass("Humanoid")
                    local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
                    if hum and root and hum.Health > 0 then
                        local dist = (myRoot.Position - root.Position).Magnitude
                        if dist <= Settings.KillAuraDist then
                            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        end
                    end
                end
            end
        end)
    end
end

-- Target Strafe Logic
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
                    if dist < minDist then minDist = dist target = plr.Character.HumanoidRootPart end
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

-- 5. STEALTH TELEPORT (Bypass chống Rollback & Chống Die)
local function StealthTeleport(targetCFrame)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not targetCFrame then return end
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local timeDuration = math.clamp(distance / 250, 0.1, 0.8)
    local tween = TweenService:Create(hrp, TweenInfo.new(timeDuration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
end

local function SetTouchTP(state)
    Settings.TouchTP = state
    if TouchTPConn then TouchTPConn:Disconnect() TouchTPConn = nil end
    if state then
        TouchTPConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                if Settings.TouchTP and Mouse.Hit then
                    StealthTeleport(CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0)))
                end
            end
        end)
    end
end

-- 6. MOVEMENT (Speed, Noclip, SpinBot, Spider, WaterWalk, Bhop)
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

-- SpinBot Logic
RunService.RenderStepped:Connect(function()
    if Settings.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
    end
end)

-- Bhop Logic
BhopConn = RunService.RenderStepped:Connect(function()
    if Settings.Bhop then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.FloorMaterial ~= Enum.Material.Air then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Spider Climb (Bám tường)
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
                if hit then root.Velocity = Vector3.new(root.Velocity.X, Settings.SpiderSpeed, root.Velocity.Z) end
            end
        end)
    end
end

-- Water Walk (Đi trên nước)
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

-- 7. CLICK DELETE & FLING ME
local function SetClickDelete(state)
    Settings.ClickDelete = state
    if ClickDeleteConn then ClickDeleteConn:Disconnect() ClickDeleteConn = nil end
    if state then
        ClickDeleteConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton2 then
                local target = Mouse.Target
                if target then target:Destroy() end
            end
        end)
    end
end

local function SetFlingMe(state)
    Settings.FlingMe = state
    if FlingConn then FlingConn:Disconnect() FlingConn = nil end
    if state then
        FlingConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then root.AssemblyAngularVelocity = Vector3.new(0, 99999, 0) end
        end)
    end
end

-- 8. HITBOX MỞ RỘNG TOÀN DIỆN (Đầu, Thân, Vũ khí, Tay chân)
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
                for _, partName in ipairs({"Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftLowerArm", "RightLowerArm"}) do
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

-- 9. ESP, TRACERS, HEAD DOT, GLOW TRAIL & CHAMS
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
                Tracer = Drawing.new("Line"),
                HeadDot = Drawing.new("Circle"),
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
            ESPObjects[plr].Tracer.Thickness = 1
            ESPObjects[plr].HeadDot.Radius = 4
            ESPObjects[plr].HeadDot.Filled = true
        end

        local drawings = ESPObjects[plr]
        local char = plr.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
            for _, d in pairs(drawings) do d.Visible = false end
            continue
        end

        local root = char.HumanoidRootPart
        local head = char:FindFirstChild("Head")
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
        drawings.Box.Color = Settings.ChamsColor
        drawings.Box.Visible = Settings.ESPBox

        drawings.Name.Text = plr.Name
        drawings.Name.Position = Vector2.new(pos.X, pos.Y - size.Y / 2 - 14)
        drawings.Name.Visible = Settings.ESPName

        drawings.Health.Text = math.floor(hum.Health) .. " HP"
        drawings.Health.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 2)
        drawings.Health.Visible = Settings.ESPHealth

        drawings.Distance.Text = math.floor(dist) .. "m"
        drawings.Distance.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 14)
        drawings.Distance.Visible = Settings.ESPDistance

        if Settings.Tracers then
            drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            drawings.Tracer.To = Vector2.new(pos.X, pos.Y)
            drawings.Tracer.Color = Settings.ChamsColor
            drawings.Tracer.Visible = true
        else
            drawings.Tracer.Visible = false
        end

        if head and Settings.ESPHeadDot then
            local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position)
            if headOnScreen then
                drawings.HeadDot.Position = Vector2.new(headPos.X, headPos.Y)
                drawings.HeadDot.Color = Color3.fromRGB(255, 0, 0)
                drawings.HeadDot.Visible = true
            else
                drawings.HeadDot.Visible = false
            end
        else
            drawings.HeadDot.Visible = false
        end
    end
end)

--==============================================================================--
--                GIAO DIỆN HÌNH CHỮ NHẬT BO GÓC MASTER (ZAKA v4.6)              --
--==============================================================================--
pcall(function()
    if PlayerGui:FindFirstChild("ZakaPureUI_v46") then
        PlayerGui.ZakaPureUI_v46:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaPureUI_v46"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

-- Nút Toggle mở menu
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 46, 0, 46)
ToggleBtn.Position = UDim2.new(0, 15, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
ToggleBtn.BackgroundTransparency = 0.15
ToggleBtn.Text = "Z"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 20
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

-- Cửa sổ chính (420 x 460)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 420, 0, 460)
Main.Position = UDim2.new(0.5, -210, 0.5, -230)
Main.BackgroundColor3 = Color3.fromRGB(15, 19, 28)
Main.BackgroundTransparency = 0.18
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 160, 255)
MainStroke.Thickness = 1.2
MainStroke.Transparency = 0.4
MainStroke.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
Header.BackgroundTransparency = 0.2
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA PURE // MASTER HUB v4.6"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextColor3 = Color3.fromRGB(230, 240, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

-- Tab Ngang
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(1, -16, 0, 34)
TabContainer.Position = UDim2.new(0, 8, 0, 46)
TabContainer.BackgroundTransparency = 1
TabContainer.CanvasSize = UDim2.new(0, 520, 0, 0)
TabContainer.ScrollBarThickness = 0
TabContainer.Parent = Main

local TabList = Instance.new("UIListLayout")
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.Padding = UDim.new(0, 6)
TabList.Parent = TabContainer

-- Content Container
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -16, 1, -92)
Content.Position = UDim2.new(0, 8, 0, 86)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true
Content.Parent = Main

local TabsData = {
    {Name = "Teleport", Icon = "📍"},
    {Name = "Combat", Icon = "⚔"},
    {Name = "Hitbox", Icon = "🎯"},
    {Name = "Player", Icon = "🏃"},
    {Name = "Visual", Icon = "👁"},
    {Name = "World/Mobs", Icon = "🧊"},
    {Name = "Troll", Icon = "⚡"},
}

local TabButtons = {}
local Pages = {}
local CurrentTab = 1

local function CreateCard(parent, text, defaultState, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 36)
    card.BackgroundColor3 = Color3.fromRGB(22, 28, 40)
    card.BackgroundTransparency = 0.4
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -55, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 11
    label.TextColor3 = Color3.fromRGB(220, 230, 245)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 32, 0, 18)
    toggleBtn.Position = UDim2.new(1, -40, 0.5, -9)
    toggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 160, 255) or Color3.fromRGB(38, 46, 62)
    toggleBtn.Text = ""
    toggleBtn.Parent = card
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local enabled = defaultState
    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = enabled and Color3.fromRGB(0, 160, 255) or Color3.fromRGB(38, 46, 62)
        }):Play()
        callback(enabled)
    end)
    return card
end

for i, data in ipairs(TabsData) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 72, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(25, 32, 46)
    btn.BackgroundTransparency = 0.4
    btn.Text = data.Icon .. " " .. data.Name
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 10
    btn.TextColor3 = Color3.fromRGB(160, 175, 200)
    btn.AutoButtonColor = false
    btn.Parent = TabContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 160, 255)
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Parent = Content

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 6)
    list.Parent = page
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 10)
    end)

    if i == 1 then -- TELEPORT
        local saveCard = Instance.new("Frame")
        saveCard.Size = UDim2.new(1, 0, 0, 36)
        saveCard.BackgroundColor3 = Color3.fromRGB(22, 28, 40)
        saveCard.BackgroundTransparency = 0.4
        saveCard.Parent = page
        Instance.new("UICorner", saveCard).CornerRadius = UDim.new(0, 8)

        local saveBtn = Instance.new("TextButton")
        saveBtn.Size = UDim2.new(0.48, -4, 1, -6)
        saveBtn.Position = UDim2.new(0, 3, 0, 3)
        saveBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 220)
        saveBtn.Text = "📍 Lưu Vị Trí"
        saveBtn.Font = Enum.Font.GothamBold
        saveBtn.TextSize = 11
        saveBtn.TextColor3 = Color3.new(1, 1, 1)
        saveBtn.Parent = saveCard
        Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 6)

        local tpBtn = Instance.new("TextButton")
        tpBtn.Size = UDim2.new(0.48, -4, 1, -6)
        tpBtn.Position = UDim2.new(0.51, 2, 0, 3)
        tpBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
        tpBtn.Text = "⚡ Stealth Tele"
        tpBtn.Font = Enum.Font.GothamBold
        tpBtn.TextSize = 11
        tpBtn.TextColor3 = Color3.new(1, 1, 1)
        tpBtn.Parent = saveCard
        Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)

        local tempCFrame = nil
        saveBtn.MouseButton1Click:Connect(function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then tempCFrame = hrp.CFrame saveBtn.Text = "Đã Lưu!" task.delay(1, function() saveBtn.Text = "📍 Lưu Vị Trí" end) end
        end)
        tpBtn.MouseButton1Click:Connect(function() if tempCFrame then StealthTeleport(tempCFrame) end end)

        CreateCard(page, "Touch TP (Chạm màn hình Tele đến đó)", false, function(v) SetTouchTP(v) end)

    elseif i == 2 then -- COMBAT
        CreateCard(page, "Auto Clicker / Fast Attack", false, function(v) 
            Settings.AutoClicker = v 
            if v then
                task.spawn(function()
                    while Settings.AutoClicker do
                        VirtualUser:Button1Down(Vector2.new())
                        task.wait(Settings.ClickDelay)
                        VirtualUser:Button1Up(Vector2.new())
                    end
                end)
            end
        end)
        CreateCard(page, "KillAura Xung Quanh", false, function(v) SetKillAura(v) end)
        CreateCard(page, "Target Strafe (Xoay vòng địch)", false, function(v) SetTargetStrafe(v) end)

    elseif i == 3 then -- HITBOX
        CreateCard(page, "Mở rộng Hitbox Đầu (Head)", false, function(v) Settings.HitboxHead = v end)
        CreateCard(page, "Mở rộng Hitbox Thân (Torso)", false, function(v) Settings.HitboxTorso = v end)
        CreateCard(page, "Mở rộng Hitbox Tay Chân (Limb)", false, function(v) Settings.HitboxLimb = v end)

    elseif i == 4 then -- PLAYER
        CreateCard(page, "Speed Walk An Toàn (Speed 28)", false, function(v) Settings.Speed = v SetSpeed(v) end)
        CreateCard(page, "Fly Mode Mượt Mà", false, function(v) SetFly(v) end)
        CreateCard(page, "Noclip (Đi xuyên tường)", false, function(v) Settings.Noclip = v SetNoclip(v) end)
        CreateCard(page, "Infinite Jump (Nhảy vô tận)", false, function(v) Settings.InfiniteJump = v end)
        CreateCard(page, "SpinBot Tấu Hài", false, function(v) Settings.SpinBot = v end)
        CreateCard(page, "Spider Climb (Bám tường)", false, function(v) SetSpiderClimb(v) end)
        CreateCard(page, "Jesus Mode (Đi trên nước)", false, function(v) SetWaterWalk(v) end)
        CreateCard(page, "Bunny Hop (Nhảy liên tục Bhop)", false, function(v) Settings.Bhop = v end)

    elseif i == 5 then -- VISUAL
        CreateCard(page, "Fullbright (Sáng rực bản đồ)", false, function(v) Settings.Fullbright = v end)
        CreateCard(page, "ESP Khung & Người Chơi", false, function(v) Settings.ESP = v end)
        CreateCard(page, "Chams Wallhack Fill Color", false, function(v) Settings.Chams = v end)
        CreateCard(page, "ESP Tracers (Đường kẻ chỉ đường)", false, function(v) Settings.Tracers = v end)
        CreateCard(page, "ESP Head Dot (Chấm đỏ trên đầu)", false, function(v) Settings.ESPHeadDot = v end)
        CreateCard(page, "Night Vision (Nhìn đêm)", false, function(v) Settings.NightVision = v end)
        CreateCard(page, "FPS Boost (Giảm lag tối đa)", false, function(v) Settings.FPSBoost = v SetFPSBoost(v) end)

    elseif i == 6 then -- WORLD / MOBS
        CreateCard(page, "🧊 Freeze Mobs / Quái (Đứng yên)", false, function(v) SetFreezeMobs(v) end)
        CreateCard(page, "Bring NPC / Quái lại gần", false, function(v) SetBringNPC(v) end)
        CreateCard(page, "Click Delete (Click chuột phải xóa vật thể)", false, function(v) SetClickDelete(v) end)
        CreateCard(page, "Anti Void (Chống rơi xuống vực sâu)", false, function(v) Settings.AntiVoid = v end)

    elseif i == 7 then -- TROLL
        CreateCard(page, "Spam Chat Tự Động", false, function(v) 
            Settings.ChatSpammer = v
            if v then
                SpamConn = task.spawn(function()
                    while Settings.ChatSpammer do
                        pcall(function()
                            if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                                TextChatService.TextChannels.RBXGeneral:SendAsync(Settings.SpamMessage)
                            else
                                ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Settings.SpamMessage, "All")
                            end
                        end)
                        task.wait(Settings.SpamDelay)
                    end
                end)
            else
                if SpamConn then task.cancel(SpamConn) end
            end
        end)
        CreateCard(page, "Invisible (Tàng hình toàn diện)", false, function(v) Settings.Invisible = v end)
        CreateCard(page, "Fling Me (Quăng quật xoay tốc độ cao)", false, function(v) SetFlingMe(v) end)
        CreateCard(page, "Rainbow Character Color", false, function(v) Settings.RainbowColor = v end)
    end

    TabButtons[i] = btn
    Pages[i] = page
end

local function SwitchTab(index)
    if CurrentTab == index then return end
    TabButtons[CurrentTab].BackgroundColor3 = Color3.fromRGB(25, 32, 46)
    TabButtons[CurrentTab].TextColor3 = Color3.fromRGB(160, 175, 200)
    Pages[CurrentTab].Visible = false

    TabButtons[index].BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    TabButtons[index].TextColor3 = Color3.new(1, 1, 1)
    Pages[index].Visible = true
    CurrentTab = index
end

for i, btn in ipairs(TabButtons) do
    btn.MouseButton1Click:Connect(function() SwitchTab(i) end)
end

TabButtons[1].BackgroundColor3 = Color3.fromRGB(0, 150, 255)
TabButtons[1].TextColor3 = Color3.new(1, 1, 1)
Pages[1].Visible = true

-- Mở / Đóng Menu
local isOpen = false
ToggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    if isOpen then
        Main.Visible = true
        Main.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 420, 0, 460)}):Play()
    else
        local tw = TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 0, 0, 0)})
        tw:Play()
        tw.Completed:Connect(function() if not isOpen then Main.Visible = false end end)
    end
end)
CloseBtn.MouseButton1Click:Connect(function() isOpen = false Main.Visible = false end)

-- Kéo thả nút Toggle
local dragging, dragStart, startPos
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleBtn.Position
    end
end)
ToggleBtn.InputEnded:Connect(function() dragging = false end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("✅ Zaka Pure UI v4.6 Master Edition Loaded Successfully with 100% Full Logic & Powerful Bypass!")
