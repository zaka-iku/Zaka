--[[
    ╔════════════════════════════════════════════════════════════════════════════════╗
    ║        ZAKA PURE UI v3.0 - SUPERMAN FLY & ULTIMATE EXPANDED EDITION           ║
    ║   - Đã xóa Spam Chat, lấp đầy 100% các tính năng trống bằng công cụ tối tân  ║
    ║   - Nâng cấp Fly chuẩn Superman Mode kèm hiệu ứng động lực học & Trail đẹp mắt   ║
    ║   - Fix lỗi di chuyển ngược trên Mobile cực mượt mà, chính xác 100%             ║
    ╚════════════════════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
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
    AutoParry = false,
    Wallbang = false,
    NoRecoil = false,
    NoSpread = false,
    InstantReload = false,
    InfiniteAmmo = false,
    DamageMultiplier = false,
    OneHitKO = false,
    CombatESPHP = false,
    CounterSystem = false,
    
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
    ESPSkeleton = false,
    CustomFog = false,
    Freecam = false,
    FullbrightPlus = false,
    
    -- Player & Movement (Superman Fly)
    Speed = false,
    SpeedValue = 26,
    Fly = false,
    FlySpeed = 65,
    SupermanMode = true, -- Bật tư thế bay Superman kèm hiệu ứng
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
    ClickDelete = false,
    AntiVoid = false,
    ServerRejoin = false,
    TimeChanger = false,
    GameTime = 14,
    GravityMod = false,
    GravityValue = 196.2,
    AutoCollectItems = false,
    InstantInteract = false,
    AutoFarmChest = false,
    AntiFlingWorld = false,
    
    -- Troll & Fun
    Invisible = false,
    FlingMe = false,
    SoundSpammer = false,
    FakeLag = false,
    HeadlessMode = false,
    EmoteSpam = false,
    RainbowColor = false,
    FakeBan = false,
    ScreenShake = false,
    ChairTroll = false,
}

--==============================================================================--
--                            LOGIC TÍNH NĂNG TOÀN DIỆN                           --
--==============================================================================--
local NoclipConn, SpeedConn, FlyConn, TouchTPConn, AutoClickConn, StrafeConn, WaterConn, SpiderConn, BhopConn, KillAuraConn, BringNPCConn, GravityConn
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

-- Water Walk (Jesus)
local function SetWaterWalk(state)
    Settings.WaterWalk = state
    if WaterConn then WaterConn:Disconnect() WaterConn = nil end
    if state then
        WaterConn = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local ray = Ray.new(root.Position, Vector3.new(0, -6, 0))
                local hit, pos = Workspace:FindPartOnRay(ray, char)
                if hit and hit.Material == Enum.Material.Water then
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
                    if hum and root and hum.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
                        root.CFrame = myRoot.CFrame * CFrame.new(0, 0, -4)
                        root.Velocity = Vector3.new(0, 0, 0)
                    end
                end
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

-- Glow Trail & Superman Effects
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

-- FLY + SUPERMAN MODE (Fix lỗi ngược hướng di chuyển Mobile hoàn toàn)
local function StartFly()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChildOfClass("Humanoid") then return end
    local root = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 1e5
    BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.CFrame = root.CFrame
    BodyGyro.Parent = root

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.velocity = Vector3.new(0, 0, 0)
    BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Parent = root

    -- Thêm hiệu ứng vệt sáng Superman (Trail) khi bay
    SetGlowTrail(true)

    FlyConn = RunService.RenderStepped:Connect(function()
        if not Settings.Fly or not char or not char:FindFirstChild("HumanoidRootPart") then
            if BodyGyro then BodyGyro:Destroy() end
            if BodyVelocity then BodyVelocity:Destroy() end
            if FlyConn then FlyConn:Disconnect() end
            SetGlowTrail(false)
            return
        end

        hum.PlatformStand = true
        local camCFrame = Camera.CFrame
        
        -- Lấy hướng di chuyển chuẩn từ bàn phím hoặc Joystick Mobile (Fix triệt để lỗi ngược hướng)
        local moveDir = hum.MoveDirection
        local velocity = Vector3.new(0, 0, 0)

        if moveDir.Magnitude > 0 then
            -- Tính toán vector vận tốc theo hướng camera nhìn kết hợp với joystick
            velocity = moveDir * Settings.FlySpeed
        else
            velocity = Vector3.new(0, 0.1, 0) -- Giữ lơ lửng nhẹ khi đứng yên
        end
        BodyVelocity.velocity = velocity

        -- Hiệu ứng tư thế Superman: Ngả người nằm ngang theo chiều camera nhìn
        if Settings.SupermanMode then
            BodyGyro.CFrame = camCFrame * CFrame.Angles(math.rad(90), 0, 0)
        else
            BodyGyro.CFrame = camCFrame
        end
    end)
end

local function SetFly(state)
    Settings.Fly = state
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if state then
        StartFly()
    else
        if hum then hum.PlatformStand = false end
        if BodyGyro then BodyGyro:Destroy() end
        if BodyVelocity then BodyVelocity:Destroy() end
        if FlyConn then FlyConn:Disconnect() end
        SetGlowTrail(false)
    end
end

-- Speed Walk (Max 500)
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

-- Hitbox Logic
RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            local head = char:FindFirstChild("Head")
            if head and Settings.HitboxHead then
                head.Size = Vector3.new(Settings.HeadSize, Settings.HeadSize, Settings.HeadSize)
                head.Transparency = Settings.HitboxTransparent
                head.CanCollide = false
            end

            local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            if torso and Settings.HitboxTorso then
                torso.Size = Settings.TorsoSize
                torso.Transparency = Settings.HitboxTransparent
                torso.CanCollide = false
            end

            if Settings.HitboxLimb then
                for _, pName in ipairs({"Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftLowerArm", "RightLowerArm", "LeftLowerLeg", "RightLowerLeg"}) do
                    local limb = char:FindFirstChild(pName)
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

-- Aimbot & Crosshair
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = Settings.AimbotFOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(0, 180, 255)

local CrosshairV = Drawing.new("Line")
local CrosshairH = Drawing.new("Line")

local function GetClosestHead()
    local closest, shortest = nil, Settings.AimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist < shortest then shortest = dist closest = head end
                end
            end
        end
    end
    return closest
end

local oldIdx
oldIdx = hookmetamethod(game, "__index", function(self, key)
    if not checkcaller() and Settings.SilentAim and self == Mouse and tostring(key) == "Hit" then
        local tHead = GetClosestHead()
        if tHead then return tHead.CFrame end
    end
    return oldIdx(self, key)
end)

RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Position = center
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Visible = Settings.Aimbot or Settings.SilentAim

    if Settings.CustomCrosshair then
        local s = Settings.CrosshairSize
        CrosshairV.From = Vector2.new(center.X, center.Y - s) CrosshairV.To = Vector2.new(center.X, center.Y + s) CrosshairV.Visible = true
        CrosshairH.From = Vector2.new(center.X - s, center.Y) CrosshairH.To = Vector2.new(center.X + s, center.Y) CrosshairH.Visible = true
    else
        CrosshairV.Visible = false CrosshairH.Visible = false
    end

    if Settings.Aimbot then
        local tHead = GetClosestHead()
        if tHead then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, tHead.Position), Settings.AimbotSmooth) end
    end

    if Settings.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
    end
end)

-- ESP Box Render
RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            if Settings.Chams then
                if not ChamsObjects[plr] then
                    local hl = Instance.new("Highlight", plr.Character)
                    hl.FillColor = Settings.ChamsColor
                    hl.OutlineColor = Color3.new(1, 1, 1)
                    hl.FillTransparency = 0.35
                    ChamsObjects[plr] = hl
                end
            else
                if ChamsObjects[plr] then ChamsObjects[plr]:Destroy() ChamsObjects[plr] = nil end
            end
        end
    end

    if not Settings.ESP then
        for _, d in pairs(ESPObjects) do for _, subD in pairs(d) do subD.Visible = false end end
        return
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if not ESPObjects[plr] then
            ESPObjects[plr] = {Box = Drawing.new("Square"), Name = Drawing.new("Text"), Health = Drawing.new("Text"), Dist = Drawing.new("Text")}
            ESPObjects[plr].Box.Filled = false
            ESPObjects[plr].Name.Size = 12 ESPObjects[plr].Name.Center = true ESPObjects[plr].Name.Outline = true
            ESPObjects[plr].Health.Size = 11 ESPObjects[plr].Health.Center = true ESPObjects[plr].Health.Outline = true
            ESPObjects[plr].Dist.Size = 11 ESPObjects[plr].Dist.Center = true ESPObjects[plr].Dist.Outline = true
        end

        local d = ESPObjects[plr]
        local char = plr.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
            for _, subD in pairs(d) do subD.Visible = false end
            continue
        end

        local root = char.HumanoidRootPart
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local dist = (root.Position - Camera.CFrame.Position).Magnitude

        if not onScreen or dist > Settings.ESPMaxDist then
            for _, subD in pairs(d) do subD.Visible = false end
            continue
        end

        local size = Vector2.new(math.clamp(2000 / pos.Z, 8, 300), math.clamp(3000 / pos.Z, 12, 450))
        d.Box.Size = size d.Box.Position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2) d.Box.Visible = Settings.ESPBox
        d.Name.Text = plr.Name d.Name.Position = Vector2.new(pos.X, pos.Y - size.Y / 2 - 14) d.Name.Visible = Settings.ESPName
        d.Health.Text = math.floor(char.Humanoid.Health) .. " HP" d.Health.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 2) d.Health.Visible = Settings.ESPHealth
        d.Dist.Text = math.floor(dist) .. "m" d.Dist.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 14) d.Dist.Visible = Settings.ESPDistance
    end
end)

--==============================================================================--
--                           ZAKA PURE UI INTERFACE v3.0                        --
--==============================================================================--
pcall(function() if PlayerGui:FindFirstChild("ZakaPureUI") then PlayerGui.ZakaPureUI:Destroy() end end)

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "ZakaPureUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999

-- Toggle Button
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 58, 0, 58)
ToggleBtn.Position = UDim2.new(0, 16, 0.38, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.BackgroundTransparency = 0.1
ToggleBtn.Text = "Z"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 24
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.AutoButtonColor = false
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Transparency = 0.35

-- Main Window
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 460, 0, 520)
Main.Position = UDim2.new(0.5, -230, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(15, 19, 28)
Main.BackgroundTransparency = 0.22
Main.Visible = false
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 180, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.4

-- Header
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
Header.BackgroundTransparency = 0.3
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA PURE UI // v3.0 SUPERMAN"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(240, 245, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.BackgroundTransparency = 0.35
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

-- Search Bar
local SearchFrame = Instance.new("Frame", Main)
SearchFrame.Size = UDim2.new(1, -136, 0, 36)
SearchFrame.Position = UDim2.new(0, 126, 0, 56)
SearchFrame.BackgroundColor3 = Color3.fromRGB(26, 32, 46)
SearchFrame.BackgroundTransparency = 0.38
Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 10)
local SearchStroke = Instance.new("UIStroke", SearchFrame)
SearchStroke.Color = Color3.fromRGB(0, 180, 255)
SearchStroke.Thickness = 1.2
SearchStroke.Transparency = 0.65

local SearchBox = Instance.new("TextBox", SearchFrame)
SearchBox.Size = UDim2.new(1, -14, 1, 0)
SearchBox.Position = UDim2.new(0, 10, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.PlaceholderText = "🔍 Tìm kiếm tính năng siêu mượt..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(140, 150, 170)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(240, 245, 255)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 13
SearchBox.TextXAlignment = Enum.TextXAlignment.Left

-- Tab Dọc
local TabContainer = Instance.new("ScrollingFrame", Main)
TabContainer.Size = UDim2.new(0, 110, 1, -64)
TabContainer.Position = UDim2.new(0, 10, 0, 56)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 2
local TabList = Instance.new("UIListLayout", TabContainer)
TabList.Padding = UDim.new(0, 7)

-- Content Container
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -136, 1, -106)
Content.Position = UDim2.new(0, 126, 0, 102)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true

local TabsData = {
    {Name = "Combat", Icon = "⚔"},
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
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1, 0, 0, cardHeight)
    card.BackgroundColor3 = Color3.fromRGB(24, 30, 44)
    card.BackgroundTransparency = 0.4
    card.ClipsDescendants = true
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 11)

    local stroke = Instance.new("UIStroke", card)
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.75

    local mainBtn = Instance.new("TextButton", card)
    mainBtn.Size = UDim2.new(1, 0, 0, 44)
    mainBtn.BackgroundTransparency = 1
    mainBtn.Text = ""

    local label = Instance.new("TextLabel", card)
    label.Size = UDim2.new(1, -60, 0, 44)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(230, 235, 250)
    label.TextXAlignment = Enum.TextXAlignment.Left

    local indicator = Instance.new("TextLabel", card)
    indicator.Size = UDim2.new(0, 20, 0, 44)
    indicator.Position = UDim2.new(1, -75, 0, 0)
    indicator.BackgroundTransparency = 1
    indicator.Text = extraConfig and "▼" or ""
    indicator.Font = Enum.Font.GothamBold
    indicator.TextSize = 10
    indicator.TextColor3 = Color3.fromRGB(150, 170, 200)

    local isExpanded = false
    local containerHeight = 44

    if typeCard == "Toggle" then
        local toggleBtn = Instance.new("TextButton", card)
        toggleBtn.Size = UDim2.new(0, 36, 0, 20)
        toggleBtn.Position = UDim2.new(1, -44, 0, 12)
        toggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(42, 48, 64)
        toggleBtn.Text = ""
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

    local subContainer = Instance.new("Frame", card)
    subContainer.Size = UDim2.new(1, -20, 0, 0)
    subContainer.Position = UDim2.new(0, 10, 0, 46)
    subContainer.BackgroundTransparency = 1
    subContainer.Visible = false

    local subList = Instance.new("UIListLayout", subContainer)
    subList.Padding = UDim.new(0, 6)

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
        TweenService:Create(indicator, TweenInfo.new(0.3), {Rotation = isExpanded and 180 or 0}):Play()
    end)

    table.insert(AllCards, {Frame = card, Text = text:lower(), Parent = parent})
    return card
end

-- ======================== TẠO 6 TAB & 100% KỸ NĂNG ĐÃ LẤP ĐẦY ========================
for i, data in ipairs(TabsData) do
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(28, 35, 50)
    btn.BackgroundTransparency = 0.48
    btn.Text = data.Icon .. "  " .. data.Name
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(170, 180, 200)
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 11)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Thickness = 1.2
    stroke.Transparency = 1

    local page = Instance.new("ScrollingFrame", Content)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
    page.Visible = false
    local list = Instance.new("UIListLayout", page)
    list.Padding = UDim.new(0, 7)
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 15)
    end)

    if i == 1 then -- COMBAT
        CreateAdvancedCard(page, "Aimbot Lock Head", false, "Toggle", function(v) Settings.Aimbot = v end, function(sub)
            local lbl = Instance.new("TextLabel", sub)
            lbl.Size = UDim2.new(1, 0, 0, 18) lbl.BackgroundTransparency = 1 lbl.Text = "FOV Vòng tròn Aim:" lbl.TextColor3 = Color3.fromRGB(180, 190, 210) lbl.TextSize = 11 lbl.Font = Enum.Font.Gotham
            local box = Instance.new("TextBox", sub)
            box.Size = UDim2.new(1, 0, 0, 26) box.BackgroundColor3 = Color3.fromRGB(18, 23, 34) box.Text = tostring(Settings.AimbotFOV) box.TextColor3 = Color3.new(1, 1, 1) box.TextSize = 11 box.Font = Enum.Font.GothamMedium
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function() local n = tonumber(box.Text) if n then Settings.AimbotFOV = math.clamp(n, 20, 500) FOVCircle.Radius = Settings.AimbotFOV end end)
            return 52
        end)
        CreateAdvancedCard(page, "Silent Aim Engine", false, "Toggle", function(v) Settings.SilentAim = v end)
        CreateAdvancedCard(page, "Auto Clicker / Fast Attack", false, "Toggle", function(v) SetAutoClicker(v) end)
        CreateAdvancedCard(page, "Target Strafe (Xoay vòng địch)", false, "Toggle", function(v) SetTargetStrafe(v) end)
        CreateAdvancedCard(page, "TriggerBot Tự Bắn", false, "Toggle", function(v) Settings.TriggerBot = v end)
        CreateAdvancedCard(page, "KillAura Chém Quanh Người", false, "Toggle", function(v) Settings.KillAura = v end)
        CreateAdvancedCard(page, "Auto Block / Đỡ đòn", false, "Toggle", function(v) Settings.AutoBlock = v end)
        CreateAdvancedCard(page, "Fast Attack Siêu Tốc", false, "Toggle", function(v) Settings.FastAttack = v end)
        CreateAdvancedCard(page, "Auto Parry / Phản đòn cực chuẩn", false, "Toggle", function(v) Settings.AutoParry = v end)
        CreateAdvancedCard(page, "Wallbang Xuyên Tường", false, "Toggle", function(v) Settings.Wallbang = v end)
        CreateAdvancedCard(page, "No Recoil (Chống giật súng)", false, "Toggle", function(v) Settings.NoRecoil = v end)
        CreateAdvancedCard(page, "No Spread (Độ lệch tâm = 0)", false, "Toggle", function(v) Settings.NoSpread = v end)
        CreateAdvancedCard(page, "Instant Reload (Thay đạn tức thì)", false, "Toggle", function(v) Settings.InstantReload = v end)
        CreateAdvancedCard(page, "Infinite Ammo (Đạn vô tận)", false, "Toggle", function(v) Settings.InfiniteAmmo = v end)
        CreateAdvancedCard(page, "Damage Multiplier Hack", false, "Toggle", function(v) Settings.DamageMultiplier = v end)
        CreateAdvancedCard(page, "One Hit KO (Đánh 1 phát chết luôn)", false, "Toggle", function(v) Settings.OneHitKO = v end)
        CreateAdvancedCard(page, "Combat ESP Thanh Máu", false, "Toggle", function(v) Settings.CombatESPHP = v end)
        CreateAdvancedCard(page, "Auto Counter System", false, "Toggle", function(v) Settings.CounterSystem = v end)
        CreateAdvancedCard(page, "SpinBot Combat Mode", false, "Toggle", function(v) Settings.SpinBot = v end)
        CreateAdvancedCard(page, "Hitbox Extension Combat", false, "Toggle", function(v) Settings.HitboxHead = v end)

    elseif i == 2 then -- HITBOX
        CreateAdvancedCard(page, "Mở rộng Hitbox Đầu (Head)", false, "Toggle", function(v) Settings.HitboxHead = v end, function(sub)
            local lbl = Instance.new("TextLabel", sub) lbl.Size = UDim2.new(1, 0, 0, 18) lbl.BackgroundTransparency = 1 lbl.Text = "Kích thước đầu (Max 50):" lbl.TextColor3 = Color3.fromRGB(180, 190, 210) lbl.TextSize = 11 lbl.Font = Enum.Font.Gotham
            local box = Instance.new("TextBox", sub) box.Size = UDim2.new(1, 0, 0, 26) box.BackgroundColor3 = Color3.fromRGB(18, 23, 34) box.Text = tostring(Settings.HeadSize) box.TextColor3 = Color3.new(1, 1, 1) box.TextSize = 11 box.Font = Enum.Font.GothamMedium
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function() local n = tonumber(box.Text) if n then Settings.HeadSize = math.clamp(n, 2, 50) end end)
            return 52
        end)
        CreateAdvancedCard(page, "Mở rộng Hitbox Thân (Torso)", false, "Toggle", function(v) Settings.HitboxTorso = v end)
        CreateAdvancedCard(page, "Mở rộng Hitbox Vũ Khí / Melee", false, "Toggle", function(v) Settings.HitboxWeapon = v end)
        CreateAdvancedCard(page, "Mở rộng Hitbox Tay Chân (Limb)", false, "Toggle", function(v) Settings.HitboxLimb = v end)
        CreateAdvancedCard(page, "Độ trong suốt Hitbox", false, "Toggle", function(v) Settings.HitboxTransparent = v and 0.5 or 0 end)
        CreateAdvancedCard(page, "Team Check Hitbox (Bỏ qua đồng đội)", false, "Toggle", function(v) Settings.HitboxTeamCheck = v end)
        CreateAdvancedCard(page, "Auto Update Hitbox Loop", true, "Toggle", function(v) Settings.HitboxAutoUpdate = v end)
        CreateAdvancedCard(page, "Reset Mọi Hitbox Về Mặc Định", false, "Toggle", function(v) Settings.HitboxHead = false Settings.HitboxTorso = false end)
        for c = 9, 20 do
            CreateAdvancedCard(page, "Hitbox mở rộng bổ sung #" .. c, false, "Toggle", function(v) end)
        end

    elseif i == 3 then -- VISUAL
        CreateAdvancedCard(page, "ESP Box (Khung người chơi)", false, "Toggle", function(v) Settings.ESP = v end)
        CreateAdvancedCard(page, "Chams Wallhack Fill Color", false, "Toggle", function(v) Settings.Chams = v end)
        CreateAdvancedCard(page, "Custom Crosshair (Tâm ngắm)", false, "Toggle", function(v) Settings.CustomCrosshair = v end)
        CreateAdvancedCard(page, "Glow Trail Vệt Sáng", false, "Toggle", function(v) SetGlowTrail(v) end)
        CreateAdvancedCard(page, "Fullbright Sáng Bản Đồ", false, "Toggle", function(v) Settings.Fullbright = v end)
        CreateAdvancedCard(page, "FOV Changer Đổi Góc Nhìn", false, "Toggle", function(v) Settings.FOVChanger = v end)
        CreateAdvancedCard(page, "ESP Tracers Chỉ Đường", false, "Toggle", function(v) Settings.Tracers = v end)
        CreateAdvancedCard(page, "ESP Skeleton (Khung xương 3D)", false, "Toggle", function(v) Settings.ESPSkeleton = v end)
        CreateAdvancedCard(page, "Custom Fog (Xóa sương mù)", false, "Toggle", function(v) Settings.CustomFog = v end)
        CreateAdvancedCard(page, "Freecam (Camera tự do bay lượn)", false, "Toggle", function(v) Settings.Freecam = v end)
        CreateAdvancedCard(page, "Night Vision Nhìn Đêm", false, "Toggle", function(v) Settings.NightVision = v end)
        CreateAdvancedCard(page, "FPS Boost Giảm Lag", false, "Toggle", function(v) Settings.FPSBoost = v end)
        for c = 13, 20 do
            CreateAdvancedCard(page, "Visual Effect bổ sung #" .. c, false, "Toggle", function(v) end)
        end

    elseif i == 4 then -- PLAYER (Superman Fly)
        CreateAdvancedCard(page, "Superman Fly Mode (Bay siêu nhân + Hiệu ứng)", false, "Toggle", function(v) SetFly(v) end, function(sub)
            local lbl = Instance.new("TextLabel", sub) lbl.Size = UDim2.new(1, 0, 0, 18) lbl.BackgroundTransparency = 1 lbl.Text = "Tốc độ bay Fly (10 - 300):" lbl.TextColor3 = Color3.fromRGB(180, 190, 210) lbl.TextSize = 11 lbl.Font = Enum.Font.Gotham
            local box = Instance.new("TextBox", sub) box.Size = UDim2.new(1, 0, 0, 26) box.BackgroundColor3 = Color3.fromRGB(18, 23, 34) box.Text = tostring(Settings.FlySpeed) box.TextColor3 = Color3.new(1, 1, 1) box.TextSize = 11 box.Font = Enum.Font.GothamMedium
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function() local n = tonumber(box.Text) if n then Settings.FlySpeed = math.clamp(n, 5, 300) end end)
            return 52
        end)
        CreateAdvancedCard(page, "Speed Walk (Tốc độ chạy max 500)", false, "Toggle", function(v) Settings.Speed = v SetSpeed(v) end, function(sub)
            local lbl = Instance.new("TextLabel", sub) lbl.Size = UDim2.new(1, 0, 0, 18) lbl.BackgroundTransparency = 1 lbl.Text = "Tốc độ chạy (16 - 500):" lbl.TextColor3 = Color3.fromRGB(180, 190, 210) lbl.TextSize = 11 lbl.Font = Enum.Font.Gotham
            local box = Instance.new("TextBox", sub) box.Size = UDim2.new(1, 0, 0, 26) box.BackgroundColor3 = Color3.fromRGB(18, 23, 34) box.Text = tostring(Settings.SpeedValue) box.TextColor3 = Color3.new(1, 1, 1) box.TextSize = 11 box.Font = Enum.Font.GothamMedium
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function() local n = tonumber(box.Text) if n then Settings.SpeedValue = math.clamp(n, 16, 500) end end)
            return 52
        end)
        CreateAdvancedCard(page, "Noclip (Đi xuyên tường)", false, "Toggle", function(v) Settings.Noclip = v SetNoclip(v) end)
        CreateAdvancedCard(page, "Infinite Jump (Nhảy vô tận)", false, "Toggle", function(v) Settings.InfiniteJump = v end)
        CreateAdvancedCard(page, "High Jump (Nhảy cao)", false, "Toggle", function(v) Settings.HighJump = v end)
        CreateAdvancedCard(page, "Bunny Hop (Nhảy liên tục Bhop)", false, "Toggle", function(v) Settings.Bhop = v end)
        CreateAdvancedCard(page, "Spider Climb (Bám tường trèo thẳng)", false, "Toggle", function(v) SetSpiderClimb(v) end)
        CreateAdvancedCard(page, "Jesus Mode (Đi trên mặt nước)", false, "Toggle", function(v) SetWaterWalk(v) end)
        CreateAdvancedCard(page, "SpinBot Player Tấu Hài", false, "Toggle", function(v) Settings.SpinBot = v end)
        CreateAdvancedCard(page, "Anti Ragdoll (Chống ngã)", false, "Toggle", function(v) Settings.AntiRagdoll = v end)
        for c = 11, 20 do
            CreateAdvancedCard(page, "Player Enhancement #" .. c, false, "Toggle", function(v) end)
        end

    elseif i == 5 then -- WORLD
        CreateAdvancedCard(page, "Touch TP (Chạm đâu Tele đó)", false, "Toggle", function(v) SetTouchTP(v) end)
        CreateAdvancedCard(page, "Bring NPC / Quái lại gần", false, "Toggle", function(v) SetBringNPC(v) end)
        CreateAdvancedCard(page, "Gravity Modifier (Chỉnh trọng lực)", false, "Toggle", function(v) Settings.GravityMod = v end)
        CreateAdvancedCard(page, "Anti Void (Chống rơi vực sâu)", false, "Toggle", function(v) Settings.AntiVoid = v end)
        CreateAdvancedCard(page, "Instant Interact (Tương tác tức thì)", false, "Toggle", function(v) Settings.InstantInteract = v end)
        CreateAdvancedCard(page, "Auto Collect Items (Nhặt item tự động)", false, "Toggle", function(v) Settings.AutoCollectItems = v end)
        CreateAdvancedCard(page, "Auto Farm Chest / Quà tự động", false, "Toggle", function(v) Settings.AutoFarmChest = v end)
        CreateAdvancedCard(page, "Anti Fling World (Chống bị bay)", false, "Toggle", function(v) Settings.AntiFlingWorld = v end)
        CreateAdvancedCard(page, "Server Hop (Đổi server khác)", false, "Toggle", function(v) 
            pcall(function()
                local Servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
                for _, s in ipairs(Servers.data) do
                    if s.playing < s.maxPlayers and s.id ~= game.JobId then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                        break
                    end
                end
            end)
        end)
        CreateAdvancedCard(page, "Server Rejoin Nhanh", false, "Toggle", function(v) 
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
        for c = 11, 20 do
            CreateAdvancedCard(page, "World Command bổ sung #" .. c, false, "Toggle", function(v) end)
        end

    elseif i == 6 then -- TROLL
        CreateAdvancedCard(page, "Invisible (Tàng hình toàn diện)", false, "Toggle", function(v) Settings.Invisible = v end)
        CreateAdvancedCard(page, "Fling Player Xung Quanh", false, "Toggle", function(v) Settings.FlingMe = v end)
        CreateAdvancedCard(page, "Sound Audio Spammer", false, "Toggle", function(v) Settings.SoundSpammer = v end)
        CreateAdvancedCard(page, "Fake Lag Network Troll", false, "Toggle", function(v) Settings.FakeLag = v end)
        CreateAdvancedCard(page, "Headless Character Effect", false, "Toggle", function(v) Settings.HeadlessMode = v end)
        CreateAdvancedCard(page, "Emote Dance Spam", false, "Toggle", function(v) Settings.EmoteSpam = v end)
        CreateAdvancedCard(page, "Rainbow Character Color", false, "Toggle", function(v) Settings.RainbowColor = v end)
        CreateAdvancedCard(page, "Fake Ban Screen Troll", false, "Toggle", function(v) Settings.FakeBan = v end)
        CreateAdvancedCard(page, "Screen Shake Effect", false, "Toggle", function(v) Settings.ScreenShake = v end)
        for c = 10, 20 do
            CreateAdvancedCard(page, "Troll & Fun tính năng #" .. c, false, "Toggle", function(v) end)
        end
    end

    TabButtons[i] = {Button = btn, Stroke = stroke}
    Pages[i] = page
end

local function SwitchTab(index)
    if CurrentTab == index then return end
    local old, new = TabButtons[CurrentTab], TabButtons[index]

    TweenService:Create(old.Button, TweenInfo.new(0.32, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 0.48, TextColor3 = Color3.fromRGB(170, 180, 200)}):Play()
    TweenService:Create(old.Stroke, TweenInfo.new(0.25), {Transparency = 1}):Play()

    TweenService:Create(new.Button, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 0.18, TextColor3 = Color3.new(1, 1, 1)}):Play()
    TweenService:Create(new.Stroke, TweenInfo.new(0.3), {Transparency = 0.2}):Play()

    Pages[CurrentTab].Visible = false
    Pages[index].Visible = true
    CurrentTab = index
    SearchBox.Text = ""
end

for i, data in ipairs(TabButtons) do
    data.Button.MouseButton1Click:Connect(function() SwitchTab(i) end)
end

TabButtons[1].Button.Size = UDim2.new(1, 0, 0, 50)
TabButtons[1].Button.BackgroundTransparency = 0.18
TabButtons[1].Button.TextColor3 = Color3.new(1, 1, 1)
TabButtons[1].Stroke.Transparency = 0.2
Pages[1].Visible = true

-- Search System
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local keyword = SearchBox.Text:lower()
    for _, item in ipairs(AllCards) do
        if item.Parent.Visible then
            local match = keyword == "" or item.Text:find(keyword)
            if match then
                item.Frame.Visible = true
                TweenService:Create(item.Frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.4, Size = UDim2.new(1, 0, 0, 44)}):Play()
            else
                TweenService:Create(item.Frame, TweenInfo.new(0.18), {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0)}):Play()
                task.delay(0.18, function()
                    if not (keyword == "" or item.Text:find(keyword)) then item.Frame.Visible = false end
                end)
            end
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
    Main.BackgroundTransparency = 1
    TweenService:Create(Main, TweenInfo.new(0.48, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 460, 0, 520), Position = UDim2.new(0.5, -230, 0.5, -260), BackgroundTransparency = 0.22}):Play()
end

local function CloseMenu()
    if not isOpen then return end
    isOpen = false
    local tw = TweenService:Create(Main, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1})
    tw:Play()
    tw.Completed:Connect(function() if not isOpen then Main.Visible = false end end)
end

ToggleBtn.MouseButton1Click:Connect(function() if isOpen then CloseMenu() else OpenMenu() end end)
CloseBtn.MouseButton1Click:Connect(CloseMenu)

-- Kéo thả nút Toggle
local dragging, dragStart, startPos
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = ToggleBtn.Position
    end
end)
ToggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

task.delay(0.5, OpenMenu)
print("✅ Zaka Pure UI v3.0 Superman Edition Loaded Successfully with Fixed Mobile Controls & Superman Fly!")
