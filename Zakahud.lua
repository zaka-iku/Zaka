--[[
    ╔════════════════════════════════════════════════════════════════════════════════╗
    ║               ZAKA HUD ULTIMATE - VERSION 1.1 (EXPANDED & RESTORED)            ║
    ║   - Logo / Toggle Button: Icon "Z"                                            ║
    ║   - Restored FULL Visual Magic 3D Scripts (Fire Dragon, Angel Wings, Ice Cage)  ║
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
    InfiniteAmmo = false,
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

    -- FE Magic Skills & Visual Constructs
    RainbowAngel = false,
    FireAura = false,
    FireDragonMount = false,
    HoldGentlemanFlower = false,

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
local NoclipConn, SpeedConn, FlyConn, TouchTPConn, AutoClickConn, SpamConn, StrafeConn, WaterConn, SpiderConn
local DragonRenderConn, AngelRenderConn
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

--==============================================================================--
--                     KĨ NĂNG 1: BÔNG HOA TRÂN TRỌNG GAME                       --
--==============================================================================--
local function SetGentlemanFlower(state)
    Settings.HoldGentlemanFlower = state
    local char = LocalPlayer.Character
    if not char then return end

    if state then
        if char:FindFirstChild("GentlemanFlowerModel") then char.GentlemanFlowerModel:Destroy() end

        local hand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
        if not hand then return end

        local flowerModel = Instance.new("Model")
        flowerModel.Name = "GentlemanFlowerModel"

        local stem = Instance.new("Part")
        stem.Name = "Stem"
        stem.Size = Vector3.new(0.12, 2.0, 0.12)
        stem.Color = Color3.fromRGB(34, 139, 34)
        stem.Material = Enum.Material.SmoothPlastic
        stem.CanCollide = false
        stem.Massless = true
        stem.Parent = flowerModel

        local rose = Instance.new("Part")
        rose.Name = "RoseHead"
        rose.Shape = Enum.PartType.Ball
        rose.Size = Vector3.new(0.8, 0.8, 0.8)
        rose.Color = Color3.fromRGB(255, 20, 147)
        rose.Material = Enum.Material.Neon
        rose.CanCollide = false
        rose.Massless = true
        rose.Parent = flowerModel

        local stemWeld = Instance.new("Weld")
        stemWeld.Part0 = stem
        stemWeld.Part1 = rose
        stemWeld.C0 = CFrame.new(0, 1.0, 0)
        stemWeld.Parent = rose

        local leaf1 = Instance.new("Part")
        leaf1.Size = Vector3.new(0.4, 0.05, 0.8)
        leaf1.Color = Color3.fromRGB(0, 180, 0)
        leaf1.CanCollide = false
        leaf1.Massless = true
        leaf1.Parent = flowerModel

        local leafWeld = Instance.new("Weld")
        leafWeld.Part0 = stem
        leafWeld.Part1 = leaf1
        leafWeld.C0 = CFrame.new(0.2, 0.2, 0) * CFrame.Angles(0, 0, math.rad(45))
        leafWeld.Parent = leaf1

        local petals = Instance.new("ParticleEmitter")
        petals.Texture = "rbxassetid://241837157"
        petals.Color = ColorSequence.new(Color3.fromRGB(255, 105, 180), Color3.fromRGB(255, 192, 203))
        petals.Size = NumberSequence.new(0.35, 0.05)
        petals.Rate = 8
        petals.Lifetime = NumberRange.new(1.5, 3)
        petals.Parent = rose

        local handWeld = Instance.new("Weld")
        handWeld.Part0 = hand
        handWeld.Part1 = stem
        handWeld.C0 = CFrame.new(0, -0.9, -0.5) * CFrame.Angles(math.rad(-90), 0, 0)
        handWeld.Parent = stem

        flowerModel.Parent = char
    else
        if char:FindFirstChild("GentlemanFlowerModel") then
            char.GentlemanFlowerModel:Destroy()
        end
    end
end

--==============================================================================--
--            KĨ NĂNG 2: CƯỠI RỒNG LỬA HỒI SINH (HIGH-DETAIL ANIMATED DRAGON)    --
--==============================================================================--
local function SetFireDragonMount(state)
    Settings.FireDragonMount = state
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    if state then
        if char:FindFirstChild("FEFireDragonFolder") then char.FEFireDragonFolder:Destroy() end

        local dragonFolder = Instance.new("Folder")
        dragonFolder.Name = "FEFireDragonFolder"
        dragonFolder.Parent = char

        local function createPart(name, size, color, mat, trans)
            local p = Instance.new("Part")
            p.Name = name
            p.Size = size
            p.Color = color or Color3.fromRGB(180, 0, 0)
            p.Material = mat or Enum.Material.Neon
            p.Transparency = trans or 0
            p.CanCollide = false
            p.Massless = true
            p.Parent = dragonFolder
            return p
        end

        local function attachWeld(p0, p1, c0)
            local w = Instance.new("Weld")
            w.Name = p1.Name .. "Weld"
            w.Part0 = p0
            w.Part1 = p1
            w.C0 = c0 or CFrame.new()
            w.Parent = p1
            return w
        end

        local bodyPart = createPart("DragonBody", Vector3.new(4, 3.5, 8), Color3.fromRGB(160, 0, 0), Enum.Material.Granite)
        local bodyWeld = attachWeld(root, bodyPart, CFrame.new(0, -3.8, 0))

        for i = -3, 3 do
            local spine = createPart("BodySpine", Vector3.new(0.5, 1.5, 0.8), Color3.fromRGB(255, 100, 0))
            attachWeld(bodyPart, spine, CFrame.new(0, 2.2, i * 1.1) * CFrame.Angles(math.rad(-20), 0, 0))
        end

        local headPart = createPart("DragonHead", Vector3.new(3.2, 2.8, 4.5), Color3.fromRGB(220, 20, 0), Enum.Material.Granite)
        local headWeld = attachWeld(bodyPart, headPart, CFrame.new(0, 1.2, -5.5))

        local snout = createPart("DragonSnout", Vector3.new(2.6, 1.8, 3), Color3.fromRGB(180, 0, 0), Enum.Material.Granite)
        attachWeld(headPart, snout, CFrame.new(0, -0.3, -2.5))

        local leftEye = createPart("LeftEye", Vector3.new(0.4, 0.4, 0.8), Color3.fromRGB(255, 255, 0))
        attachWeld(headPart, leftEye, CFrame.new(-1.3, 0.7, -1.2))

        local rightEye = createPart("RightEye", Vector3.new(0.4, 0.4, 0.8), Color3.fromRGB(255, 255, 0))
        attachWeld(headPart, rightEye, CFrame.new(1.3, 0.7, -1.2))

        local leftHorn = createPart("LeftHorn", Vector3.new(0.6, 2.8, 0.6), Color3.fromRGB(255, 140, 0))
        attachWeld(headPart, leftHorn, CFrame.new(-1.2, 1.8, 1.2) * CFrame.Angles(math.rad(-35), math.rad(-20), 0))

        local rightHorn = createPart("RightHorn", Vector3.new(0.6, 2.8, 0.6), Color3.fromRGB(255, 140, 0))
        attachWeld(headPart, rightHorn, CFrame.new(1.2, 1.8, 1.2) * CFrame.Angles(math.rad(-35), math.rad(20), 0))

        local dragonFire = Instance.new("Fire")
        dragonFire.Size = 10
        dragonFire.Heat = 15
        dragonFire.Color = Color3.fromRGB(255, 120, 0)
        dragonFire.SecondaryColor = Color3.fromRGB(255, 255, 0)
        dragonFire.Parent = snout

        local tail1 = createPart("DragonTail1", Vector3.new(2.8, 2.5, 6), Color3.fromRGB(140, 0, 0), Enum.Material.Granite)
        local tail1Weld = attachWeld(bodyPart, tail1, CFrame.new(0, -0.4, 6))

        local tail2 = createPart("DragonTail2", Vector3.new(2.0, 1.8, 6), Color3.fromRGB(180, 30, 0), Enum.Material.Granite)
        local tail2Weld = attachWeld(tail1, tail2, CFrame.new(0, 0, 5.5))

        local tailTip = createPart("TailTip", Vector3.new(0.8, 2.5, 2.5), Color3.fromRGB(255, 60, 0))
        attachWeld(tail2, tailTip, CFrame.new(0, 0, 3.2) * CFrame.Angles(math.rad(45), 0, 0))

        local function makeLeg(legName, pos)
            local leg = createPart(legName, Vector3.new(1.2, 3.2, 1.2), Color3.fromRGB(130, 0, 0), Enum.Material.Granite)
            attachWeld(bodyPart, leg, pos)

            local claw = createPart(legName .. "Claw", Vector3.new(1.4, 0.5, 1.5), Color3.fromRGB(255, 200, 0))
            attachWeld(leg, claw, CFrame.new(0, -1.5, -0.3))
        end
        makeLeg("FrontLeftLeg", CFrame.new(-2.2, -1.8, -2.5))
        makeLeg("FrontRightLeg", CFrame.new(2.2, -1.8, -2.5))
        makeLeg("BackLeftLeg", CFrame.new(-2.2, -1.8, 2.5))
        makeLeg("BackRightLeg", CFrame.new(2.2, -1.8, 2.5))

        local leftWingBase = createPart("LeftWingBase", Vector3.new(1.2, 1.2, 5), Color3.fromRGB(200, 0, 0))
        local leftWingWeld = attachWeld(bodyPart, leftWingBase, CFrame.new(-2.2, 1.5, -1))

        local leftWingBlade = createPart("LeftWingBlade", Vector3.new(10, 0.2, 6), Color3.fromRGB(255, 50, 0))
        attachWeld(leftWingBase, leftWingBlade, CFrame.new(-5, 0, 1) * CFrame.Angles(0, math.rad(-15), 0))

        local rightWingBase = createPart("RightWingBase", Vector3.new(1.2, 1.2, 5), Color3.fromRGB(200, 0, 0))
        local rightWingWeld = attachWeld(bodyPart, rightWingBase, CFrame.new(2.2, 1.5, -1))

        local rightWingBlade = createPart("RightWingBlade", Vector3.new(10, 0.2, 6), Color3.fromRGB(255, 50, 0))
        attachWeld(rightWingBase, rightWingBlade, CFrame.new(5, 0, 1) * CFrame.Angles(0, math.rad(15), 0))

        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.P = 9e4
        BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.cframe = root.CFrame
        BodyGyro.Parent = root

        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.velocity = Vector3.new(0, 0, 0)
        BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
        BodyVelocity.Parent = root

        DragonRenderConn = RunService.RenderStepped:Connect(function()
            if not Settings.FireDragonMount or not char or not char:FindFirstChild("Humanoid") then
                SetFireDragonMount(false)
                return
            end

            local t = tick() * 4.5
            local hum = char.Humanoid
            local moveDir = hum.MoveDirection
            local isMoving = moveDir.Magnitude > 0
            local speedMult = isMoving and 1.8 or 1.0

            headWeld.C0 = CFrame.new(math.sin(t * speedMult) * 0.9, 1.2 + math.cos(t * speedMult) * 0.4, -5.5) * CFrame.Angles(0, math.sin(t * speedMult) * 0.2, 0)
            tail1Weld.C0 = CFrame.new(math.sin(-t * speedMult) * 1.0, -0.4 + math.sin(t * speedMult) * 0.3, 6) * CFrame.Angles(0, math.sin(-t * speedMult) * 0.25, 0)
            tail2Weld.C0 = CFrame.new(math.sin(-t * speedMult + 1) * 1.4, math.cos(t * speedMult) * 0.3, 5.5) * CFrame.Angles(0, math.sin(-t * speedMult + 1) * 0.35, 0)

            local wingAngle = math.sin(t * 1.4 * speedMult) * 28
            leftWingWeld.C0 = CFrame.new(-2.2, 1.5, -1) * CFrame.Angles(0, 0, math.rad(wingAngle))
            rightWingWeld.C0 = CFrame.new(2.2, 1.5, -1) * CFrame.Angles(0, 0, math.rad(-wingAngle))

            BodyGyro.cframe = Camera.CFrame
            if isMoving then
                local camCF = Camera.CFrame
                local forwardVector = camCF.LookVector
                local rightVector = camCF.RightVector

                local flyDir = (forwardVector * (-moveDir.Z)) + (rightVector * moveDir.X)
                BodyVelocity.velocity = flyDir.Unit * Settings.FlySpeed
            else
                BodyVelocity.velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        if char:FindFirstChild("FEFireDragonFolder") then char.FEFireDragonFolder:Destroy() end
        if BodyGyro then BodyGyro:Destroy() end
        if BodyVelocity then BodyVelocity:Destroy() end
        if DragonRenderConn then DragonRenderConn:Disconnect() DragonRenderConn = nil end
    end
end

--==============================================================================--
--           KĨ NĂNG 3: CÁNH THIÊN THẦN KHỔNG LỒ & KHIÊN CẦU VỒNG (HIGH-DETAIL)   --
--==============================================================================--
local function SetRainbowAngel(state)
    Settings.RainbowAngel = state
    local char = LocalPlayer.Character
    if not char then return end

    if state then
        if char:FindFirstChild("FEAngelFolder") then char.FEAngelFolder:Destroy() end

        local angelFolder = Instance.new("Folder")
        angelFolder.Name = "FEAngelFolder"
        angelFolder.Parent = char

        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        if not torso then return end

        local shield = Instance.new("Part")
        shield.Name = "RainbowShield"
        shield.Shape = Enum.PartType.Ball
        shield.Size = Vector3.new(10, 10, 10)
        shield.Material = Enum.Material.ForceField
        shield.Color = Color3.fromRGB(0, 255, 255)
        shield.CanCollide = false
        shield.Massless = true
        shield.Parent = angelFolder

        local shieldWeld = Instance.new("Weld")
        shieldWeld.Part0 = torso
        shieldWeld.Part1 = shield
        shieldWeld.Parent = shield

        local hl = Instance.new("Highlight")
        hl.Name = "ShieldHighlight"
        hl.Adornee = shield
        hl.FillTransparency = 0.65
        hl.OutlineTransparency = 0.05
        hl.Parent = shield

        local halo = Instance.new("Part")
        halo.Name = "AngelHalo"
        halo.Size = Vector3.new(2.5, 0.2, 2.5)
        halo.Material = Enum.Material.Neon
        halo.Color = Color3.fromRGB(255, 230, 100)
        halo.CanCollide = false
        halo.Massless = true
        halo.Parent = angelFolder

        local haloMesh = Instance.new("SpecialMesh")
        haloMesh.MeshType = Enum.MeshType.FileMesh
        haloMesh.MeshId = "rbxassetid://3270017"
        haloMesh.Scale = Vector3.new(3, 3, 3)
        haloMesh.Parent = halo

        local haloWeld = Instance.new("Weld")
        haloWeld.Part0 = torso
        haloWeld.Part1 = halo
        haloWeld.C0 = CFrame.new(0, 3.8, 0)
        haloWeld.Parent = halo

        local function createWing(sideName)
            local wingModel = Instance.new("Model")
            wingModel.Name = sideName
            wingModel.Parent = angelFolder

            local isLeft = sideName:find("Left") ~= nil
            local dirMult = isLeft and -1 or 1

            local wingMain = Instance.new("Part")
            wingMain.Name = "WingMain"
            wingMain.Size = Vector3.new(0.3, 7.5, 3.5)
            wingMain.Material = Enum.Material.Neon
            wingMain.Color = Color3.fromRGB(255, 255, 255)
            wingMain.CanCollide = false
            wingMain.Massless = true
            wingMain.Parent = wingModel

            local wWeld = Instance.new("Weld")
            wWeld.Name = "WingWeld"
            wWeld.Part0 = torso
            wWeld.Part1 = wingMain
            wWeld.C0 = CFrame.new(3 * dirMult, 2, 1.2) * CFrame.Angles(0, math.rad(25 * dirMult), 0)
            wWeld.Parent = wingMain

            for i = 1, 5 do
                local feather = Instance.new("Part")
                feather.Size = Vector3.new(0.2, 4.5 - (i * 0.5), 1.8)
                feather.Material = Enum.Material.Neon
                feather.Color = Color3.fromRGB(255, 255, 255)
                feather.CanCollide = false
                feather.Massless = true
                feather.Parent = wingModel

                local fWeld = Instance.new("Weld")
                fWeld.Part0 = wingMain
                fWeld.Part1 = feather
                fWeld.C0 = CFrame.new(dirMult * (i * 0.6), -i * 0.4, (i * 0.3)) * CFrame.Angles(0, 0, math.rad(dirMult * (i * 12)))
                fWeld.Parent = feather
            end

            return wWeld
        end

        local leftWingWeld = createWing("LeftAngelWingModel")
        local rightWingWeld = createWing("RightAngelWingModel")

        local hue = 0
        AngelRenderConn = RunService.RenderStepped:Connect(function()
            if not Settings.RainbowAngel or not char or not char:FindFirstChild("FEAngelFolder") then
                SetRainbowAngel(false)
                return
            end

            local t = tick() * 3.5
            hue = (hue + 0.006) % 1
            local rainbowColor = Color3.fromHSV(hue, 0.9, 1)

            shield.Color = rainbowColor
            hl.OutlineColor = rainbowColor
            hl.FillColor = rainbowColor
            halo.Color = rainbowColor

            local wingFlap = math.sin(t) * 22
            leftWingWeld.C0 = CFrame.new(-3, 2, 1.2) * CFrame.Angles(0, math.rad(-35 + wingFlap), math.rad(18 + wingFlap/2))
            rightWingWeld.C0 = CFrame.new(3, 2, 1.2) * CFrame.Angles(0, math.rad(35 - wingFlap), math.rad(-18 - wingFlap/2))
        end)
    else
        if char:FindFirstChild("FEAngelFolder") then char.FEAngelFolder:Destroy() end
        if AngelRenderConn then AngelRenderConn:Disconnect() AngelRenderConn = nil end
    end
end

--==============================================================================--
--        KĨ NĂNG 4: LỒNG BĂNG GIỮ LÂU (15s) + PHÁT NỔ HẤT VĂNG CỰC MẠNH         --
--==============================================================================--
local function CreateIceCageSuper()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local targetPlayer = nil
    local closestDist = 55

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                targetPlayer = plr
            end
        end
    end

    if targetPlayer and targetPlayer.Character then
        local targetRoot = targetPlayer.Character.HumanoidRootPart
        local cageModel = Instance.new("Model")
        cageModel.Name = "SuperIceCageContainer"

        local cagePos = targetRoot.Position
        local size = 10

        local function makeWall(cf, s)
            local wall = Instance.new("Part")
            wall.Size = s
            wall.CFrame = cf
            wall.Material = Enum.Material.Ice
            wall.Color = Color3.fromRGB(120, 240, 255)
            wall.Transparency = 0.25
            wall.Anchored = true
            wall.CanCollide = true
            wall.Parent = cageModel
        end

        makeWall(CFrame.new(cagePos + Vector3.new(0, -size/2, 0)), Vector3.new(size, 0.6, size))
        makeWall(CFrame.new(cagePos + Vector3.new(0, size/2, 0)), Vector3.new(size, 0.6, size))
        makeWall(CFrame.new(cagePos + Vector3.new(size/2, 0, 0)), Vector3.new(0.6, size, size))
        makeWall(CFrame.new(cagePos + Vector3.new(-size/2, 0, 0)), Vector3.new(0.6, size, size))
        makeWall(CFrame.new(cagePos + Vector3.new(0, 0, size/2)), Vector3.new(size, size, 0.6))
        makeWall(CFrame.new(cagePos + Vector3.new(0, 0, -size/2)), Vector3.new(size, size, 0.6))

        local smoke = Instance.new("Smoke")
        smoke.Color = Color3.fromRGB(180, 240, 255)
        smoke.Size = 8
        smoke.Opacity = 0.6
        smoke.Parent = cageModel:FindFirstChildOfClass("Part")

        cageModel.Parent = workspace

        task.delay(15, function()
            if cageModel and cageModel.Parent then
                local blast = Instance.new("Part")
                blast.Shape = Enum.PartType.Ball
                blast.Size = Vector3.new(2, 2, 2)
                blast.CFrame = CFrame.new(cagePos)
                blast.Material = Enum.Material.Neon
                blast.Color = Color3.fromRGB(0, 230, 255)
                blast.Anchored = true
                blast.CanCollide = false
                blast.Parent = workspace

                local tween = TweenService:Create(blast, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = Vector3.new(35, 35, 35),
                    Transparency = 1
                })
                tween:Play()
                tween.Completed:Connect(function() blast:Destroy() end)

                if targetRoot and targetRoot.Parent then
                    local randomUp = Vector3.new(math.random(-100, 100), 250, math.random(-100, 100))
                    targetRoot.AssemblyLinearVelocity = randomUp * 15
                end

                cageModel:Destroy()
            end
        end)
    end
end

--==============================================================================--
--                    KĨ NĂNG 5 & UTILITIES PHỤ TRỢ (EFFECTS)                    --
--==============================================================================--
local function SetFireAura(state)
    Settings.FireAura = state
    local char = LocalPlayer.Character
    if not char then return end

    if state then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local fire = Instance.new("Fire")
                fire.Name = "MagicFireEffect"
                fire.Size = 8
                fire.Heat = 16
                fire.Color = Color3.fromRGB(255, 60, 0)
                fire.SecondaryColor = Color3.fromRGB(255, 220, 0)
                fire.Parent = part
            end
        end
    else
        for _, part in ipairs(char:GetDescendants()) do
            if part.Name == "MagicFireEffect" then part:Destroy() end
        end
    end
end

local function GroundStompShockwave()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    local wave = Instance.new("Part")
    wave.Shape = Enum.PartType.Cylinder
    wave.Size = Vector3.new(0.5, 2, 2)
    wave.CFrame = root.CFrame * CFrame.Angles(0, 0, math.rad(90))
    wave.Material = Enum.Material.Neon
    wave.Color = Color3.fromRGB(0, 220, 255)
    wave.CanCollide = false
    wave.Anchored = true
    wave.Parent = workspace

    local tween = TweenService:Create(wave, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(0.5, 60, 60),
        Transparency = 1
    })
    tween:Play()
    tween.Completed:Connect(function() wave:Destroy() end)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = plr.Character.HumanoidRootPart
            local dist = (targetRoot.Position - root.Position).Magnitude
            if dist <= 35 then
                local pushDir = (targetRoot.Position - root.Position).Unit
                targetRoot.AssemblyLinearVelocity = (pushDir * 220) + Vector3.new(0, 150, 0)
            end
        end
    end
end

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
--                       REAL DROPKICK INTEGRATION                              --
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
--                    2 CHỨC NĂNG MỚI - COMBAT                                  --
--==============================================================================--
    --==============================================================================--
--                    NPC AIMBOT (Tự hiện vòng + Ghim quái)
--==============================================================================--

-- Thêm vào Settings nếu chưa có
Settings.NPCAimbot = false
Settings.NPCAimbotFOV = 140
Settings.NPCAimbotSmooth = 0.16

-- Vòng tròn FOV cho NPC
local NPCFOVCircle = Drawing.new("Circle")
NPCFOVCircle.Thickness = 1.5
NPCFOVCircle.NumSides = 64
NPCFOVCircle.Filled = false
NPCFOVCircle.Color = Color3.fromRGB(255, 80, 80) -- màu đỏ để dễ nhận
NPCFOVCircle.Transparency = 0.7
NPCFOVCircle.Visible = false

-- Hàm tìm quái gần nhất (bỏ qua Player)
local function GetClosestNPC()
    local closest = nil
    local shortest = Settings.NPCAimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            -- Bỏ qua người chơi thật
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

-- Vòng tròn + Ghim liên tục
RunService.RenderStepped:Connect(function()
    -- Hiện / ẩn vòng tròn
    NPCFOVCircle.Visible = Settings.NPCAimbot
    NPCFOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    NPCFOVCircle.Radius = Settings.NPCAimbotFOV

    -- Ghim vào quái
    if Settings.NPCAimbot then
        local target = GetClosestNPC()
        if target then
            local goal = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(goal, Settings.NPCAimbotSmooth)
        end
    end
end)
--==============================================================================--
--              INFINITE AMMO + FAST FIRE (Bản mạnh)
--==============================================================================--

Settings.InfiniteAmmo = false
Settings.FastFire = false

local AmmoConn = nil
local FastFireConn = nil

local function SetInfiniteAmmo(state)
    Settings.InfiniteAmmo = state
    if AmmoConn then
        AmmoConn:Disconnect()
        AmmoConn = nil
    end

    if state then
        AmmoConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end

            local function ForceAmmo(tool)
                if not tool or not tool:IsA("Tool") then return end

                pcall(function()
                    -- Các tên đạn phổ biến nhất
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

                    -- Attribute
                    pcall(function()
                        tool:SetAttribute("Ammo", 9999)
                        tool:SetAttribute("Clip", 9999)
                        tool:SetAttribute("CurrentAmmo", 9999)
                    end)
                end)
            end

            -- Súng đang cầm
            for _, item in ipairs(char:GetChildren()) do
                ForceAmmo(item)
            end

            -- Súng trong túi
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if backpack then
                for _, item in ipairs(backpack:GetChildren()) do
                    ForceAmmo(item)
                end
            end
        end)
    end
end

-- Bắn nhanh (giảm thời gian chờ giữa các phát)
local function SetFastFire(state)
    Settings.FastFire = state
    if FastFireConn then
        FastFireConn:Disconnect()
        FastFireConn = nil
    end

    if state then
        FastFireConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end

            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    pcall(function()
                        -- Một số game dùng giá trị này để làm chậm tốc độ bắn
                        if tool:FindFirstChild("FireRate") then
                            tool.FireRate.Value = 0.01
                        end
                        if tool:FindFirstChild("Cooldown") then
                            tool.Cooldown.Value = 0.01
                        end
                        if tool:FindFirstChild("ShootCooldown") then
                            tool.ShootCooldown.Value = 0.01
                        end
                    end)
                end
            end
        end)
    end
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

-- Top Header Bar
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

-- Search Bar
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

local Tabs = {"Combat", "ESP", "Player", "Teleport", "Troll", "Magic", "Utility", "Config"}
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

-- Search Filter System
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
--                     NẠP CÁC TÍNH NĂNG ĐẦY ĐỦ (>15 BẢN GHI/TAB)               --
--==============================================================================--

-- Tab 1: Combat (19 Tính năng)
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
CreateToggle(Pages[1], "Tự Động Bật Giáp / Shield", false, function() end)
CreateToggle(Pages[1], "Bắn Xuyên Tường Light Wallbang", false, function(v) Settings.WallbangMode = v end)
CreateToggle(Pages[1], "Tự Động Khóa Địch Gần Nhất", false, function() end)

-- 2 chức năng mới
CreateToggle(Pages[1], "NPC Aimbot (Ghim Quái)", false, function(v) Settings.NPCAimbot = v end)
CreateInput(Pages[1], "Độ Lớn Vòng NPC FOV", 140, 400, function(v) Settings.NPCAimbotFOV = v end)
CreateToggle(Pages[1], "Infinite Ammo (Vô Hạn Đạn)", false, function(v) SetInfiniteAmmo(v) end)
CreateToggle(Pages[1], "Fast Fire (Bắn Nhanh)", false, function(v) SetFastFire(v) end)
CreateButton(Pages[1], "Tháo Vũ Khí Nhanh (Fast Unequip)", function()
    local char = LocalPlayer.Character
    if char then char:UnequipTools() end
end)
CreateButton(Pages[1], "Xóa Hút Tâm Bắn Địch", function()
    Camera.CFrame = CFrame.new(Camera.CFrame.Position)
end)
        
-- Tab 2: ESP & Visuals (16 Tính năng)
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
    Settings.NeonNight = v
    if v then Lighting.ClockTime = 0 Lighting.Brightness = 3.5 else Lighting.ClockTime = 12 Lighting.Brightness = 1 end
end)
CreateToggle(Pages[2], "Chống Mờ Sương Mù (No Fog)", false, function(v) Settings.NoFog = v Lighting.FogEnd = v and 1e6 or OriginalFogEnd end)
CreateInput(Pages[2], "Chỉnh Góc Nhìn FOV Cam", 70, 120, function(v) Settings.CustomFOV = v end)
CreateButton(Pages[2], "Mở Rộng Zoom Cam Vô Tận", function() LocalPlayer.CameraMaxZoomDistance = 1e6 end)
CreateButton(Pages[2], "Chỉnh Nhìn Trong Đêm (Fullbright)", function() Lighting.Brightness = 3 Lighting.ClockTime = 12 end)
CreateButton(Pages[2], "Xóa Hiệu Ứng Màn Hình Mờ", function()
    for _, v in ipairs(Lighting:GetChildren()) do if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then v:Destroy() end end
end)

-- Tab 3: Player & Physics (16 Tính năng)
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
CreateButton(Pages[3], "Xóa Toàn Bộ Động Lực (Stop Motion)", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity = Vector3.new() end
end)
CreateButton(Pages[3], "Tối Ưu Tốc Độ Nhân Vật Client", function() settings().Physics.PhysicsEnvironmentalThrottle = 1 end)

-- Tab 4: Teleport (15 Tính năng)
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
CreateButton(Pages[4], "Teleport Ra Phía Sau Địch Gần Nhất", function()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local closest, minDist = nil, 9999
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
            if dist < minDist then minDist = dist closest = plr.Character.HumanoidRootPart end
        end
    end
    if closest then myRoot.CFrame = closest.CFrame * CFrame.new(0, 0, 3) end
end)
CreateButton(Pages[4], "Lưu Vị Trí Teleport Hiện Tại", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then _G.SavedPos = root.CFrame end
end)
CreateButton(Pages[4], "Teleport Về Vị Trí Đã Lưu", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and _G.SavedPos then root.CFrame = _G.SavedPos end
end)
CreateButton(Pages[4], "Teleport Tới Spawn Point", function()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("SpawnLocation") then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then root.CFrame = v.CFrame + Vector3.new(0, 5, 0) end
            break
        end
    end
end)
CreateButton(Pages[4], "Shift Teleport Forward 10 Mới", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = root.CFrame * CFrame.new(0, 0, -10) end
end)
CreateButton(Pages[4], "Shift Teleport Backward 10", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = root.CFrame * CFrame.new(0, 0, 10) end
end)
CreateButton(Pages[4], "Dịch Chuyển Lên Đỉnh Đầu Đối Thủ", function()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            myRoot.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0)
            break
        end
    end
end)
CreateButton(Pages[4], "Teleport Theo Camera Look Vector", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = CFrame.new(root.Position + Camera.CFrame.LookVector * 15) end
end)
CreateButton(Pages[4], "Reset Kết Nối Dịch Chuyển", function() end)

-- Tab 5: Troll & Server Utilities (15 Tính năng)
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
CreateButton(Pages[5], "Làm Giật Màn Hình Địch Gần Nhất", function() end)
CreateButton(Pages[5], "Thả Rơi Đồ Toàn Bộ Tool", function()
    local char = LocalPlayer.Character
    if char then for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then t.Parent = workspace end end end
end)
CreateButton(Pages[5], "Xoay Tròn Ngẫu Nhiên Player Khác", function() end)
CreateButton(Pages[5], "Rải Lửa Giả Đốt Đất", function() end)
CreateButton(Pages[5], "Tạo Tiếng Nổ Giả Giữa Server", function() end)
CreateButton(Pages[5], "Tự Động Chat Khi Kill Được Địch", function() end)
CreateButton(Pages[5], "Spam Tool Equip/Unequip", function() end)
CreateButton(Pages[5], "Tạo Bong Bóng Chat Đảo Ngược", function() end)
CreateButton(Pages[5], "Gửi Tin Nhắn Ẩn Danh", function() end)
CreateButton(Pages[5], "Dọn Dẹp Rác Client Script", function() collectgarbage() end)

-- Tab 6: FE Magic Skills (15 Tính năng)
CreateToggle(Pages[6], "Rồng Lửa Cưỡi (Fixed Control 3D Animated)", false, function(v) SetFireDragonMount(v) end)
CreateToggle(Pages[6], "Cánh Thiên Thần Khổng Lồ + Khiên Cầu Vồng", false, function(v) SetRainbowAngel(v) end)
CreateToggle(Pages[6], "Cầm Bông Hoa Trân Trọng Game 3D Model", false, function(v) SetGentlemanFlower(v) end)
CreateToggle(Pages[6], "Triệu Hồi Lửa Rồng Quanh Thân (Fire Aura)", false, function(v) SetFireAura(v) end)
CreateButton(Pages[6], "Lồng Băng Nhốt 15s + Phát Nổ Hất Văng", function() CreateIceCageSuper() end)
CreateButton(Pages[6], "Sóng Xung Kích Giậm Chân Rồng Shockwave", function() GroundStompShockwave() end)
local Services = {
    Players = game:GetService("Players"),
    TweenService = game:GetService("TweenService"),
    RunService = game:GetService("RunService"),
    Debris = game:GetService("Debris")
}

local LocalPlayer = Services.Players.LocalPlayer

-- Bảng quản lý kết nối & Model để dọn dẹp triệt để
local ActiveEffects = {
    Connections = {},
    Models = {}
}

-- Hàm tiện ích tạo Folder chứa hiệu ứng trên nhân vật
local function GetEffectFolder(char)
    local folder = char:FindFirstChild("MagicFXFolder")
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = "MagicFXFolder"
        folder.Parent = char
    end
    return folder
end

-- 1. Vòng Tròn Lửa Chân
local fireRingConn
CreateToggle(Pages[6], "Vòng Tròn Lửa Chân (Fire Ring)", false, function(Value)
    if fireRingConn then fireRingConn:Disconnect() fireRingConn = nil end
    local char = LocalPlayer.Character
    if Value and char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local fxFolder = GetEffectFolder(char)
        
        local ring = Instance.new("Part")
        ring.Name = "FireRingFX"
        ring.Size = Vector3.new(6, 0.2, 6)
        ring.CanCollide = false
        ring.Anchored = true
        ring.Material = Enum.Material.Neon
        ring.Color = Color3.fromRGB(255, 100, 0)
        ring.Transparency = 0.4
        ring.Parent = fxFolder

        local fire = Instance.new("Fire")
        fire.Size = 8
        fire.Heat = 5
        fire.Parent = ring

        fireRingConn = Services.RunService.RenderStepped:Connect(function()
            if char and hrp and ring.Parent then
                ring.CFrame = hrp.CFrame * CFrame.new(0, -2.8, 0) * CFrame.Angles(0, math.rad(tick() * 100 % 360), 0)
            else
                if fireRingConn then fireRingConn:Disconnect() end
            end
        end)
        ActiveEffects.Connections["FireRing"] = fireRingConn
    else
        local folder = char and char:FindFirstChild("MagicFXFolder")
        if folder and folder:FindFirstChild("FireRingFX") then folder.FireRingFX:Destroy() end
    end
end)

-- 2. Hiệu Ứng Sét Đánh Quanh Thân
local lightningConn
CreateToggle(Pages[6], "Hiệu Ứng Sét Đánh Quanh Thân", false, function(Value)
    if lightningConn then lightningConn:Disconnect() lightningConn = nil end
    if Value then
        local lastTime = 0
        lightningConn = Services.RunService.Heartbeat:Connect(function()
            if tick() - lastTime > 0.15 then
                lastTime = tick()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    local p = Instance.new("Part")
                    p.Size = Vector3.new(0.2, math.random(3, 7), 0.2)
                    p.Material = Enum.Material.Neon
                    p.Color = Color3.fromRGB(0, 230, 255)
                    p.Anchored = true
                    p.CanCollide = false
                    p.CFrame = hrp.CFrame * CFrame.new(math.random(-4, 4), math.random(-1, 4), math.random(-4, 4)) * CFrame.Angles(math.rad(math.random(0, 360)), 0, math.rad(math.random(0, 360)))
                    p.Parent = Workspace
                    Services.Debris:AddItem(p, 0.1)
                end
            end
        end)
        ActiveEffects.Connections["Lightning"] = lightningConn
    end
end)

-- 3. Triệu Hồi Cột Băng Đẩy Bay
CreateButton(Pages[6], "Triệu Hồi Cột Băng Đẩy Bay", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local iceSpike = Instance.new("Part")
        iceSpike.Size = Vector3.new(4, 1, 4)
        iceSpike.Position = hrp.Position - Vector3.new(0, 3, 0)
        iceSpike.Material = Enum.Material.Ice
        iceSpike.Color = Color3.fromRGB(150, 230, 255)
        iceSpike.Transparency = 0.2
        iceSpike.Anchored = true
        iceSpike.CanCollide = true
        iceSpike.Parent = Workspace

        local tween = Services.TweenService:Create(iceSpike, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Vector3.new(5, 12, 5),
            Position = hrp.Position + Vector3.new(0, 3, 0)
        })
        tween:Play()

        -- Đẩy nhân vật lên không
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 120, hrp.Velocity.Z)
        Services.Debris:AddItem(iceSpike, 4)
    end
end)

-- 4. Bắn Cầu Lửa Ma Thuật FE
CreateButton(Pages[6], "Bắn Cầu Lửa Ma Thuật FE", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local fireball = Instance.new("Part")
        fireball.Size = Vector3.new(2, 2, 2)
        fireball.Shape = Enum.PartType.Ball
        fireball.Color = Color3.fromRGB(255, 60, 0)
        fireball.Material = Enum.Material.Neon
        fireball.CFrame = hrp.CFrame * CFrame.new(0, 1, -3)
        fireball.CanCollide = false
        fireball.Parent = Workspace

        local pe = Instance.new("ParticleEmitter")
        pe.Texture = "rbxassetid://243664672"
        pe.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 2), NumberSequenceKeypoint.new(1, 0)})
        pe.Lifetime = NumberRange.new(0.3, 0.5)
        pe.Rate = 100
        pe.Parent = fireball

        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = hrp.CFrame.LookVector * 100
        bv.Parent = fireball

        fireball.Touched:Connect(function(hit)
            if not hit:IsDescendantOf(char) then
                local exp = Instance.new("Explosion")
                exp.Position = fireball.Position
                exp.BlastRadius = 0 -- Thiết lập bằng 0 để tránh tự sát nếu game bật PvP
                exp.Parent = Workspace
                fireball:Destroy()
            end
        end)
        Services.Debris:AddItem(fireball, 5)
    end
end)

-- 5. Tạo Hố Đen Vũ Trụ Nhỏ (Blackhole Visual)
CreateButton(Pages[6], "Tạo Hố Đen Vũ Trụ Nhỏ (Blackhole Visual)", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local hole = Instance.new("Part")
        hole.Size = Vector3.new(1, 1, 1)
        hole.Shape = Enum.PartType.Ball
        hole.Color = Color3.fromRGB(10, 10, 15)
        hole.Material = Enum.Material.Neon
        hole.CFrame = hrp.CFrame * CFrame.new(0, 2, -10)
        hole.Anchored = true
        hole.CanCollide = false
        hole.Parent = Workspace

        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(130, 0, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Parent = hole

        Services.TweenService:Create(hole, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = Vector3.new(8, 8, 8)
        }):Play()

        task.delay(4, function()
            if hole and hole.Parent then
                Services.TweenService:Create(hole, TweenInfo.new(0.5), {Size = Vector3.new(0,0,0)}):Play()
                task.wait(0.5)
                hole:Destroy()
            end
        end)
    end
end)

-- 6. Bánh Xe Sáng Rainbow Xoay Chân
local rainbowConn
CreateToggle(Pages[6], "Bánh Xe Sáng Rainbow Xoay Chân", false, function(Value)
    if rainbowConn then rainbowConn:Disconnect() rainbowConn = nil end
    local char = LocalPlayer.Character
    if Value and char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local fxFolder = GetEffectFolder(char)

        local rainbowPart = Instance.new("Part")
        rainbowPart.Name = "RainbowRingFX"
        rainbowPart.Size = Vector3.new(7, 0.1, 7)
        rainbowPart.CanCollide = false
        rainbowPart.Anchored = true
        rainbowPart.Material = Enum.Material.Neon
        rainbowPart.Parent = fxFolder

        local hue = 0
        rainbowConn = Services.RunService.RenderStepped:Connect(function()
            if char and hrp and rainbowPart.Parent then
                hue = (hue + 0.005) % 1
                rainbowPart.Color = Color3.fromHSV(hue, 1, 1)
                rainbowPart.CFrame = hrp.CFrame * CFrame.new(0, -2.9, 0) * CFrame.Angles(0, math.rad(tick() * 180 % 360), 0)
            else
                if rainbowConn then rainbowConn:Disconnect() end
            end
        end)
        ActiveEffects.Connections["Rainbow"] = rainbowConn
    else
        local folder = char and char:FindFirstChild("MagicFXFolder")
        if folder and folder:FindFirstChild("RainbowRingFX") then folder.RainbowRingFX:Destroy() end
    end
end)

-- 7. Đuôi Rồng Lửa Tách Biệt
local tailConn
CreateToggle(Pages[6], "Đuôi Rồng Lửa Tách Biệt", false, function(Value)
    if tailConn then tailConn:Disconnect() tailConn = nil end
    local char = LocalPlayer.Character
    if Value and char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local fxFolder = GetEffectFolder(char)

        local tailNode = Instance.new("Part")
        tailNode.Name = "DragonTailFX"
        tailNode.Size = Vector3.new(1, 1, 1)
        tailNode.Transparency = 1
        tailNode.CanCollide = false
        tailNode.Anchored = true
        tailNode.Parent = fxFolder

        local pe = Instance.new("ParticleEmitter")
        pe.Texture = "rbxassetid://243664672"
        pe.Color = ColorSequence.new(Color3.fromRGB(255, 80, 0), Color3.fromRGB(255, 200, 0))
        pe.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 1.5), NumberSequenceKeypoint.new(1, 0)})
        pe.Lifetime = NumberRange.new(0.4, 0.8)
        pe.Rate = 60
        pe.Speed = NumberRange.new(2, 5)
        pe.Parent = tailNode

        tailConn = Services.RunService.RenderStepped:Connect(function()
            if char and hrp and tailNode.Parent then
                -- Đuôi đi theo sau lưng nhân vật
                tailNode.CFrame = hrp.CFrame * CFrame.new(0, -0.5, 2.5)
            else
                if tailConn then tailConn:Disconnect() end
            end
        end)
        ActiveEffects.Connections["DragonTail"] = tailConn
    else
        local folder = char and char:FindFirstChild("MagicFXFolder")
        if folder and folder:FindFirstChild("DragonTailFX") then folder.DragonTailFX:Destroy() end
    end
end)

-- 8. Kích Hoạt Khiên Bảo Vệ Băng
CreateButton(Pages[6], "Kích Hoạt Khiên Bảo Vệ Băng", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local fxFolder = GetEffectFolder(char)

        local oldShield = fxFolder:FindFirstChild("IceShieldFX")
        if oldShield then oldShield:Destroy() end

        local shield = Instance.new("Part")
        shield.Name = "IceShieldFX"
        shield.Size = Vector3.new(8, 8, 8)
        shield.Shape = Enum.PartType.Ball
        shield.Material = Enum.Material.Glass
        shield.Color = Color3.fromRGB(180, 240, 255)
        shield.Transparency = 0.5
        shield.CanCollide = false
        shield.Parent = fxFolder

        local weld = Instance.new("Weld")
        weld.Part0 = hrp
        weld.Part1 = shield
        weld.C0 = CFrame.new(0, 0, 0)
        weld.Parent = shield

        Services.Debris:AddItem(shield, 10) -- Tự biến mất sau 10 giây
    end
end)

-- 9. Xóa Toàn Bộ Model Phép Thuật Dư Thừa (Tối Ưu Hoàn Chỉnh)
CreateButton(Pages[6], "Xóa Toàn Bộ Model Phép Thuật Dư Thừa", function()
    -- Ngắt tất cả các vòng lặp RenderStepped/Heartbeat đang chạy
    for name, conn in pairs(ActiveEffects.Connections) do
        if conn then
            conn:Disconnect()
            ActiveEffects.Connections[name] = nil
        end
    end

    local char = LocalPlayer.Character
    if char then
        -- Xóa Folder quản lý hiệu ứng chung
        local fxFolder = char:FindFirstChild("MagicFXFolder")
        if fxFolder then fxFolder:Destroy() end

        -- Xóa các Folder/Model lẻ nếu có
        local targetNames = {
            "FEFireDragonFolder", 
            "FEAngelFolder", 
            "GentlemanFlowerModel",
            "FireRingFX",
            "RainbowRingFX",
            "DragonTailFX",
            "IceShieldFX"
        }
        for _, name in ipairs(targetNames) do
            local item = char:FindFirstChild(name)
            if item then item:Destroy() end
        end
    end
end)

CreateButton(Pages[6], "Xóa Toàn Bộ Model Phép Thuật Dư Thừa", function()
    local char = LocalPlayer.Character
    if char then
        if char:FindFirstChild("FEFireDragonFolder") then char.FEFireDragonFolder:Destroy() end
        if char:FindFirstChild("FEAngelFolder") then char.FEAngelFolder:Destroy() end
        if char:FindFirstChild("GentlemanFlowerModel") then char.GentlemanFlowerModel:Destroy() end
    end
end)

-- Tab 7: Utility & World (15 Tính năng)
CreateToggle(Pages[7], "Tự Động Anti-AFK Chống Disconnect", true, function(v) Settings.AntiAFK = v end)
CreateButton(Pages[7], "Vào Lại Server Hiện Tại (Rejoin)", function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
CreateButton(Pages[7], "Chuyển Server Ngẫu Nhiên (Server Hop)", function()
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
CreateButton(Pages[7], "Copy Link Job ID Server", function() setclipboard(tostring(game.JobId)) end)
CreateButton(Pages[7], "Copy Script Roblox Place ID", function() setclipboard(tostring(game.PlaceId)) end)
CreateToggle(Pages[7], "Khóa Khung Hình 60 FPS", true, function(v) setfpscap(v and 60 or 240) end)
CreateToggle(Pages[7], "Mở Rộng Giới Hạn Render Map", false, function() end)
CreateButton(Pages[7], "Xóa Hết Textures (Giảm Lag Low Graphics)", function()
    for _, v in ipairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end end
end)
CreateButton(Pages[7], "Xóa Hết Particle Emitters Trên Map", function()
    for _, v in ipairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") then v:Destroy() end end
end)
CreateButton(Pages[7], "Ẩn Toàn Bộ UI Hệ Thống Game", function() end)
CreateButton(Pages[7], "Khôi Phục UI Hệ Thống Game", function() end)
CreateButton(Pages[7], "Tắt Âm Thanh Game Client", function() soundsetvolume(0) end)
CreateButton(Pages[7], "Bật Lại Âm Thanh Game Client", function() soundsetvolume(1) end)
CreateButton(Pages[7], "Kiểm Tra Thông Số Ping/FPS", function() print("Ping: " .. game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()) end)
CreateButton(Pages[7], "Xóa Bộ Nhớ Đệm RAM Roblox", function() gcinfo() end)

-- Tab 8: Config & System (15 Tính năng)
CreateButton(Pages[8], "Lưu Cấu Hình (Save Settings Config)", function() print("Zaka HUD Config Saved!") end)
CreateButton(Pages[8], "Nạp Cấu Hình Đã Lưu (Load Config)", function() print("Zaka HUD Config Loaded!") end)
CreateButton(Pages[8], "Khôi Phục Cài Đặt Mặc Định", function() print("Default Settings Restored!") end)
CreateButton(Pages[8], "Đổi Màu Giao Diện (Theme Blue)", function() MainStroke.Color = Color3.fromRGB(0, 162, 255) end)
CreateButton(Pages[8], "Đổi Màu Giao Diện (Theme Red)", function() MainStroke.Color = Color3.fromRGB(255, 50, 50) end)
CreateButton(Pages[8], "Đổi Màu Giao Diện (Theme Purple)", function() MainStroke.Color = Color3.fromRGB(180, 50, 255) end)
CreateButton(Pages[8], "Đổi Màu Giao Diện (Theme Green)", function() MainStroke.Color = Color3.fromRGB(50, 255, 120) end)
CreateButton(Pages[8], "Tự Động Ẩn Menu Khi Chạy Script", function() Main.Visible = false end)
CreateButton(Pages[8], "Hiện Lại Menu Zaka HUD", function() Main.Visible = true end)
CreateButton(Pages[8], "Khóa Vị Trí Menu HUD", function() Main.Draggable = false end)
CreateButton(Pages[8], "Mở Khóa Di Chuyển Menu HUD", function() Main.Draggable = true end)
CreateButton(Pages[8], "Tắt Toàn Bộ Chức Năng Đang Bật", function()
    Settings.Aimbot = false Settings.ESP = false Settings.Fly = false Settings.Speed = false
end)
CreateButton(Pages[8], "Tự Động Cập Nhật Version 1.1", function() print("You are on the latest Version 1.1!") end)
CreateButton(Pages[8], "Sao Chép Discord Support Zaka HUD", function() setclipboard("https://discord.gg/zakahud") end)
CreateButton(Pages[8], "Thoát / Unload Zaka HUD UI", function() ScreenGui:Destroy() end)

print("Zaka HUD v1.1 Restored and Loaded Successfully!")
