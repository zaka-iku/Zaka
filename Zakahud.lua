--[[
    ╔════════════════════════════════════════════════════════════════════════════════╗
    ║                 ZAKA HUD ULTIMATE - V1.0 (FIXED DROPKICK BUG)                  ║
    ║   - Fixed Dropkick Flinging Self Issue                                         ║
    ║   - Fixed Flight Controls (Inverted Flight Direction Fix)                      ║
    ║   - Highly Detailed Mythical Fire Dragon (Horns, Eyes, Spines, Claws, Wings)   ║
    ║   - Majestic Feathered Angel Wings & Rainbow Glow Aura                         ║
    ║   - Explosive Long-Duration Ice Cage (15s Lock + Shockwave Blast Out)          ║
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
    HitboxExpander = false,
    HitboxSize = 20,

    -- ESP Visuals
    ESP = false,
    ESPBox = true,
    ESPName = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPTracers = false,
    ESPMaxDist = 3000,

    -- Movement & Physics
    Speed = false,
    SpeedValue = 28,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    InfiniteJump = false,
    SpinBot = false,
    SpinSpeed = 40,
    TouchTP = false,

    -- Troll Systems
    Dropkick = false,
    DropkickPower = 3500,

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

    -- Utilities & Misc
    Fullbright = false,
    AntiAFK = true,
}

--==============================================================================--
--                            BIẾN TOÀN CỤC & KẾT NỐI                            --
--==============================================================================--
local NoclipConn, SpeedConn, FlyConn, DropkickConn, TouchTPConn
local DragonRenderConn, AngelRenderConn
local BodyGyro, BodyVelocity
local ESPObjects = {}
local OriginalFogEnd = Lighting.FogEnd

-- Chống AFK Tự Động
LocalPlayer.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Nhảy Vô Hạn (Infinite Jump)
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Dịch Chuyển Khi Chạm (Touch Teleport)
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

local function SetNoFog(state)
    Settings.NoFog = state
    Lighting.FogEnd = state and 1e6 or OriginalFogEnd
end

local function SetNeonNight(state)
    Settings.NeonNight = state
    if state then
        Lighting.ClockTime = 0
        Lighting.Brightness = 3.5
        Lighting.OutdoorAmbient = Color3.fromRGB(0, 160, 255)
    else
        Lighting.ClockTime = 12
        Lighting.Brightness = 1
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
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
--                            AIMBOT & HITBOX SYSTEM                             --
--==============================================================================--
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = Settings.AimbotFOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(0, 162, 255)

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

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Visible = Settings.Aimbot

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
--                       DROPKICK & TELEPORT FUNCTIONS (FIXED)                  --
--==============================================================================--
local function SetDropkick(state)
    Settings.Dropkick = state
    if DropkickConn then DropkickConn:Disconnect() DropkickConn = nil end

    if state then
        DropkickConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local root = char.HumanoidRootPart

            -- Tìm target gần nhất trong phạm vi
            local closestTarget = nil
            local shortestDist = 15 -- Bán kính kích hoạt dropkick (studs)

            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = plr.Character.HumanoidRootPart
                    local dist = (targetRoot.Position - root.Position).Magnitude
                    if dist <= shortestDist then
                        shortestDist = dist
                        closestTarget = targetRoot
                    end
                end
            end

            -- Nếu tìm thấy mục tiêu: Đẩy MỤC TIÊU văng đi, không tác dụng lực lên bản thân
            if closestTarget then
                local pushDir = (closestTarget.Position - root.Position).Unit
                local flingVelocity = pushDir * Settings.DropkickPower + Vector3.new(0, Settings.DropkickPower / 2, 0)
                
                -- Tạo lực đẩy trực tiếp lên mục tiêu
                closestTarget.AssemblyLinearVelocity = flingVelocity
                closestTarget.AssemblyAngularVelocity = Vector3.new(Settings.DropkickPower, Settings.DropkickPower, Settings.DropkickPower)
                
                -- Giữ bản thân ổn định không bị giật/văng
                root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0,0,0)
        end
    end
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

local function TeleportToPlayer()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            myRoot.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3.5)
            break
        end
    end
end

--==============================================================================--
--                            ESP ENGINE DRAWINGS                               --
--==============================================================================--
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
--                        GIAO DIỆN ONE UI ANIMATED ENGINE                       --
--==============================================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaHub_UI"
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
Main.Size = UDim2.new(0, 350, 0, 360)
Main.Position = UDim2.new(0.5, -175, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 162, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.5

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
Title.Text = "<b>ZAKA</b> <font color=\"#00A2FF\">HUD</font> <font color=\"#888888\">| ZakahudV1.0 OVERHAUL</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13.5
Title.Font = Enum.Font.Gotham
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -12, 1, -82)
PageContainer.Position = UDim2.new(0, 6, 0, 76)
PageContainer.BackgroundTransparency = 1
PageContainer.ClipsDescendants = true
PageContainer.Parent = Main

local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, -12, 0, 28)
TabFrame.Position = UDim2.new(0, 6, 0, 42)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = Main

local Tabs = {"Combat", "ESP", "Player", "Teleport", "Troll", "Magic", "Utility", "Misc"}
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
end

--==============================================================================--
--                        KHỞI TẠO MENU CÁC TABS ĐẦY ĐỦ                          --
--==============================================================================--

-- Tab 1: Combat
CreateToggle(Pages[1], "Aimbot Lock Head (Khóa Đầu)", false, function(v) Settings.Aimbot = v end)
CreateInput(Pages[1], "Kích Thước FOV Aim", 120, 800, function(v) Settings.AimbotFOV = v end)
CreateToggle(Pages[1], "Hitbox Expander (Đầu To)", false, function(v) Settings.HitboxExpander = v end)
CreateInput(Pages[1], "Kích Thước Hitbox (Max 500)", 20, 500, function(v) Settings.HitboxSize = v end)

-- Tab 2: ESP
CreateToggle(Pages[2], "Bật ESP Tổng", false, function(v) Settings.ESP = v end)
CreateToggle(Pages[2], "Khung ESP (Box)", true, function(v) Settings.ESPBox = v end)
CreateToggle(Pages[2], "Tên Người Chơi", true, function(v) Settings.ESPName = v end)
CreateToggle(Pages[2], "Thanh Máu (HP)", true, function(v) Settings.ESPHealth = v end)
CreateToggle(Pages[2], "Khoảng Cách (Distance)", true, function(v) Settings.ESPDistance = v end)
CreateToggle(Pages[2], "Đường Kẻ (Tracers)", false, function(v) Settings.ESPTracers = v end)

-- Tab 3: Player
CreateToggle(Pages[3], "Bật Tăng Tốc Chạy", false, function(v) Settings.Speed = v SetSpeed(v) end)
CreateInput(Pages[3], "Tốc Độ Chạy (Max 500)", 28, 500, function(v) Settings.SpeedValue = v end)
CreateToggle(Pages[3], "Bật Fly (Bay chuẩn)", false, function(v) SetFly(v) end)
CreateInput(Pages[3], "Tốc Độ Bay (Max 500)", 50, 500, function(v) Settings.FlySpeed = v end)
CreateToggle(Pages[3], "Nhảy Không Giới Hạn (Inf Jump)", false, function(v) Settings.InfiniteJump = v end)
CreateToggle(Pages[3], "SpinBot (Xoay Nhân Vật)", false, function(v) Settings.SpinBot = v end)
CreateToggle(Pages[3], "Đi Xuyên Tường (Noclip)", false, function(v) Settings.Noclip = v SetNoclip(v) end)

-- Tab 4: Teleport
CreateToggle(Pages[4], "Chạm Đâu Tele Đó (Touch TP)", false, function(v) SetTouchTP(v) end)
CreateButton(Pages[4], "Dịch Chuyển Tới Người Chơi Ngẫu Nhiên", function() TeleportToPlayer() end)
CreateButton(Pages[4], "Bring All (Kéo Tất Cả Lại Gần)", function() BringAllPlayers() end)

-- Tab 5: Troll
CreateToggle(Pages[5], "Bật Dropkick (Đá Văng FE)", false, function(v) SetDropkick(v) end)
CreateInput(Pages[5], "Lực Dropkick (Max 10000)", 3500, 10000, function(v) Settings.DropkickPower = v end)

-- Tab 6: Magic (Chi Tiết Cao Cấp)
CreateToggle(Pages[6], "Rồng Lửa Cưỡi (Fixed Control + Detailed)", false, function(v) SetFireDragonMount(v) end)
CreateToggle(Pages[6], "Cánh Thiên Thần + Khiên Cầu Vồng (Feather)", false, function(v) SetRainbowAngel(v) end)
CreateToggle(Pages[6], "Cầm Bông Hoa Trân Trọng Game", false, function(v) SetGentlemanFlower(v) end)
CreateToggle(Pages[6], "Triệu Hồi Lửa Rồng Quanh Thân", false, function(v) SetFireAura(v) end)
CreateButton(Pages[6], "Lồng Băng Nhốt 15s + Phát Nổ Hất Văng", function() CreateIceCageSuper() end)
CreateButton(Pages[6], "Sóng Xung Kích Giậm Chân Rồng", function() GroundStompShockwave() end)

-- Tab 7: Utility
CreateToggle(Pages[7], "Chống Mờ Sương Mù (No Fog)", false, function(v) SetNoFog(v) end)
CreateToggle(Pages[7], "Chế Độ Ban Đêm Neon", false, function(v) SetNeonNight(v) end)
CreateToggle(Pages[7], "Vệt Sáng Bước Chân (Glow Trail)", false, function(v) SetGlowTrail(v) end)
CreateInput(Pages[7], "Chỉnh FOV Camera (Góc Nhìn)", 70, 120, function(v) Settings.CustomFOV = v end)
CreateButton(Pages[7], "Mở Rộng Zoom Camera Vô Tận", function() LocalPlayer.CameraMaxZoomDistance = 1e6 end)

-- Tab 8: Misc
CreateToggle(Pages[8], "Nhìn Trong Đêm (Fullbright)", false, function(v) 
    Lighting.Brightness = v and 2.5 or 1 
    Lighting.ClockTime = v and 14 or 12
end)
CreateToggle(Pages[8], "Tự Động Anti-AFK", true, function(v) Settings.AntiAFK = v end)
CreateButton(Pages[8], "Vào Lại Server (Rejoin)", function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
CreateButton(Pages[8], "Đổi Server Ngẫu Nhiên (Server Hop)", function()
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

print("Zaka Hud ZakahudV1.0 High-Detail Overhaul Fully Loaded & Fixed!")
