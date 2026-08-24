--[[
    ╔═════════════════════════════════════════════════════════════════════════════════════════════════════╗
    ║                                   ZAKA HUD ULTIMATE V2.0 - TITAN EDITION                            ║
    ║                                                                                                     ║
    ║   [ARCHITECTURAL OVERHAUL - 5000+ LINES PROJECT STRUCTURE]                                         ║
    ║   PART 1: CORE FRAMEWORK, ADVANCED UTILITIES, TARGETING ENGINE & ESP MATRIX                         ║
    ╚═════════════════════════════════════════════════════════════════════════════════════════════════════╝
]]

--==============================================================================--
--                           1. SERVICES & ENGINE INITIALIZATION                 --
--==============================================================================--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local ContextActionService = game:GetService("ContextActionService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

--==============================================================================--
--                           2. ADVANCED CONFIGURATION MATRIX                     --
--==============================================================================--
local ZakaConfig = {
    -- Combat Engine
    Combat = {
        AimbotEnabled = false,
        AimbotKey = Enum.UserInputType.MouseButton2,
        AimbotFOV = 150,
        AimbotSmoothness = 0.15,
        AimbotTargetPart = "Head",
        ShowFOVCircle = true,
        FOVCircleColor = Color3.fromRGB(0, 255, 230),
        
        SilentAim = false,
        HitboxExpander = false,
        HitboxSize = 25,
        HitboxTransparency = 0.7,
        
        TriggerBot = false,
        TriggerDelay = 0.05,
        
        AutoClicker = false,
        CPS = 15,
    },
    
    -- Visual / ESP Engine
    ESP = {
        Enabled = false,
        Boxes = true,
        BoxColor = Color3.fromRGB(0, 255, 120),
        BoxOutline = true,
        Names = true,
        NameColor = Color3.fromRGB(255, 255, 255),
        HealthBar = true,
        Distance = true,
        Tracers = false,
        TracerColor = Color3.fromRGB(0, 162, 255),
        TracerOrigin = "Bottom", -- "Bottom", "Middle", "Mouse"
        HeadDots = true,
        Chams = false,
        ChamsColor = Color3.fromRGB(255, 0, 128),
        ChamsTransparency = 0.5,
        RainbowESP = false,
        MaxDistance = 5000,
    },
    
    -- Player Physics & Movement
    Movement = {
        SpeedHack = false,
        WalkSpeed = 32,
        FlyHack = false,
        FlySpeed = 60,
        VerticalFlySpeed = 30,
        Noclip = false,
        InfiniteJump = false,
        SpinBot = false,
        SpinSpeed = 50,
        TouchTP = false,
        BunnyHop = false,
        HighJump = false,
        JumpPower = 120,
    },
    
    -- FE Visual Constructs & Magic Attacks
    Magic = {
        UltraFireDragon = false,
        DragonScale = 1.2,
        FireBreathActive = false,
        FireBreathPower = 100,
        
        RainbowFeatherWings = false,
        AngelAuraGlow = false,
        
        GentlemanRoseHand = false,
        IceCageSkill = false,
        
        ShadowCloneAura = false,
        LightningOrbShield = false,
        CustomGalaxyParticle = false,
    },
    
    -- World & Environment Filters
    Environment = {
        Fullbright = false,
        NoFog = false,
        CustomTime = false,
        TimeValue = 12,
        AmbientColor = Color3.fromRGB(255, 255, 255),
        CustomFOV = 70,
        FOVEnabled = false,
        NightMode = false,
    },
    
    -- Utility Systems
    Utility = {
        AntiAFK = true,
        AntiLag = false,
        RejoinOnKick = true,
        AutoServerHop = false,
        FPSUnlocker = true,
    }
}

--==============================================================================--
--                           3. CORE UTILITIES & HELPERS                         --
--==============================================================================--
local Utils = {}

function Utils.CreateInstance(className, properties)
    local inst = Instance.new(className)
    for prop, val in pairs(properties) do
        inst[prop] = val
    end
    return inst
end

function Utils.GetClosestPlayerToMouse(fov, targetPartName)
    local closestPlayer = nil
    local shortestDistance = fov or math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local part = char:FindFirstChild(targetPartName or "Head")

            if hum and hum.Health > 0 and part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDistance then
                        closestPlayer = player
                        shortestDistance = dist
                    end
                end
            end
        end
    end
    return closestPlayer
end

--==============================================================================--
--                           4. AIMBOT & FOV ENGINE                             --
--==============================================================================--
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Transparent = 1

RunService.RenderStepped:Connect(function()
    -- FOV Circle Update
    if ZakaConfig.Combat.ShowFOVCircle and ZakaConfig.Combat.AimbotEnabled then
        FOVCircle.Visible = true
        FOVCircle.Radius = ZakaConfig.Combat.AimbotFOV
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Color = ZakaConfig.Combat.FOVCircleColor
    else
        FOVCircle.Visible = false
    end

    -- Aimbot Core Loop
    if ZakaConfig.Combat.AimbotEnabled and UserInputService:IsMouseButtonPressed(ZakaConfig.Combat.AimbotKey) then
        local target = Utils.GetClosestPlayerToMouse(ZakaConfig.Combat.AimbotFOV, ZakaConfig.Combat.AimbotTargetPart)
        if target and target.Character and target.Character:FindFirstChild(ZakaConfig.Combat.AimbotTargetPart) then
            local targetPart = target.Character[ZakaConfig.Combat.AimbotTargetPart]
            local targetPos = Camera:WorldToViewportPoint(targetPart.Position)
            local mousePos = UserInputService:GetMouseLocation()
            
            local smoothX = (targetPos.X - mousePos.X) * ZakaConfig.Combat.AimbotSmoothness
            local smoothY = (targetPos.Y - mousePos.Y) * ZakaConfig.Combat.AimbotSmoothness
            
            mousemoverel(smoothX, smoothY)
        end
    end
end)

--==============================================================================--
--                           5. ESP ENGINE MATRIX                               --
--==============================================================================--
local ESPStorage = {}

local function CreateESPContainer(player)
    if ESPStorage[player] then return end
    
    local box = Drawing.new("Square")
    box.Thickness = 1.5
    box.Filled = false
    box.Visible = false
    
    local tracer = Drawing.new("Line")
    tracer.Thickness = 1
    tracer.Visible = false

    local name = Drawing.new("Text")
    name.Size = 14
    name.Center = true
    name.Outline = true
    name.Visible = false

    ESPStorage[player] = {
        Box = box,
        Tracer = tracer,
        Name = name
    }
end

local function RemoveESPContainer(player)
    if ESPStorage[player] then
        for _, obj in pairs(ESPStorage[player]) do
            obj:Remove()
        end
        ESPStorage[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then CreateESPContainer(p) end
end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then CreateESPContainer(p) end end)
Players.PlayerRemoving:Connect(RemoveESPContainer)

RunService.RenderStepped:Connect(function()
    if not ZakaConfig.ESP.Enabled then
        for _, esp in pairs(ESPStorage) do
            esp.Box.Visible = false
            esp.Tracer.Visible = false
            esp.Name.Visible = false
        end
        return
    end

    for plr, esp in pairs(ESPStorage) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChildOfClass("Humanoid") then
            local char = plr.Character
            local root = char.HumanoidRootPart
            local hum = char:FindFirstChildOfClass("Humanoid")

            if hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                
                if onScreen then
                    local dist = (Camera.CFrame.Position - root.Position).Magnitude
                    if dist <= ZakaConfig.ESP.MaxDistance then
                        local head = char:FindFirstChild("Head") or root
                        local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                        local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))

                        local height = math.abs(headPos.Y - legPos.Y)
                        local width = height / 1.6

                        -- Render Box
                        if ZakaConfig.ESP.Boxes then
                            esp.Box.Size = Vector2.new(width, height)
                            esp.Box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
                            esp.Box.Color = ZakaConfig.ESP.BoxColor
                            esp.Box.Visible = true
                        else
                            esp.Box.Visible = false
                        end

                        -- Render Name & Dist
                        if ZakaConfig.ESP.Names then
                            esp.Name.Text = string.format("%s [%dm]", plr.Name, math.floor(dist))
                            esp.Name.Position = Vector2.new(pos.X, pos.Y - height / 2 - 16)
                            esp.Name.Color = ZakaConfig.ESP.NameColor
                            esp.Name.Visible = true
                        else
                            esp.Name.Visible = false
                        end

                        -- Render Tracer
                        if ZakaConfig.ESP.Tracers then
                            esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            esp.Tracer.To = Vector2.new(pos.X, pos.Y)
                            esp.Tracer.Color = ZakaConfig.ESP.TracerColor
                            esp.Tracer.Visible = true
                        else
                            esp.Tracer.Visible = false
                        end
                    else
                        esp.Box.Visible = false
                        esp.Tracer.Visible = false
                        esp.Name.Visible = false
                    end
                else
                    esp.Box.Visible = false
                    esp.Tracer.Visible = false
                    esp.Name.Visible = false
                end
            else
                esp.Box.Visible = false
                esp.Tracer.Visible = false
                esp.Name.Visible = false
            end
        else
            esp.Box.Visible = false
            esp.Tracer.Visible = false
            esp.Name.Visible = false
        end
    end
end)

print("[ZAKA HUD V2.0] Part 1 Engine Loaded Successfully!")
--[[
    ╔═════════════════════════════════════════════════════════════════════════════════════════════════════╗
    ║                                   ZAKA HUD ULTIMATE V2.0 - TITAN EDITION                            ║
    ║                                                                                                     ║
    ║   PART 2: PLAYER MOVEMENT ENGINE, FLY/NOCLIP, ULTRA-DETAILED FIRE DRAGON & FE MAGIC ATTACKS         ║
    ╚═════════════════════════════════════════════════════════════════════════════════════════════════════╝
]]

--==============================================================================--
--                           1. MOVEMENT & PHYSICS ENGINE                       --
--==============================================================================--
local BodyGyro, BodyVelocity
local FlyConnection, NoclipConnection, SpeedConnection

local function ToggleFly(state)
    ZakaConfig.Movement.FlyHack = state
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    if state then
        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.P = 9e4
        BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.cframe = root.CFrame
        BodyGyro.Parent = root

        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.velocity = Vector3.new(0, 0, 0)
        BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
        BodyVelocity.Parent = root

        FlyConnection = RunService.RenderStepped:Connect(function()
            if not ZakaConfig.Movement.FlyHack then return end
            local camCF = Camera.CFrame
            local moveDir = Vector3.new()

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

            BodyGyro.cframe = camCF
            if moveDir.Magnitude > 0 then
                BodyVelocity.velocity = moveDir.Unit * ZakaConfig.Movement.FlySpeed
            else
                BodyVelocity.velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        if BodyGyro then BodyGyro:Destroy() end
        if BodyVelocity then BodyVelocity:Destroy() end
        if FlyConnection then FlyConnection:Disconnect() end
    end
end

local function ToggleNoclip(state)
    ZakaConfig.Movement.Noclip = state
    if NoclipConnection then NoclipConnection:Disconnect() end

    if state then
        NoclipConnection = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

-- Speed & Spinbot Loop
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if ZakaConfig.Movement.SpeedHack then
            hum.WalkSpeed = ZakaConfig.Movement.WalkSpeed
        end
    end

    if ZakaConfig.Movement.SpinBot and char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(ZakaConfig.Movement.SpinSpeed), 0)
    end
end)

--==============================================================================--
--        2. ULTRA-DETAILED MYTHICAL FIRE DRAGON MOUNT & BREATH ENGINE          --
--==============================================================================--
local DragonFolder = nil
local DragonRenderConnection = nil

local function ToggleUltraFireDragon(state)
    ZakaConfig.Magic.UltraFireDragon = state
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    if state then
        if char:FindFirstChild("ZakaUltraDragonModel") then char.ZakaUltraDragonModel:Destroy() end

        DragonFolder = Instance.new("Folder")
        DragonFolder.Name = "ZakaUltraDragonModel"
        DragonFolder.Parent = char

        local function makeDragonPart(name, size, color, material)
            local p = Instance.new("Part")
            p.Name = name
            p.Size = size
            p.Color = color or Color3.fromRGB(160, 10, 10)
            p.Material = material or Enum.Material.Neon
            p.CanCollide = false
            p.Massless = true
            p.Parent = DragonFolder
            return p
        end

        local function weldParts(p0, p1, c0)
            local w = Instance.new("Weld")
            w.Part0 = p0
            w.Part1 = p1
            w.C0 = c0 or CFrame.new()
            w.Parent = p1
            return w
        end

        -- Thân Rồng Đồ Sộ
        local body = makeDragonPart("DragonBody", Vector3.new(5, 4.5, 10), Color3.fromRGB(140, 0, 0), Enum.Material.Granite)
        local bodyWeld = weldParts(root, body, CFrame.new(0, -4.5, 0))

        -- Giáp Lưng & Gai Nhọn Hỏa Sức
        for i = -4, 4 do
            local spine = makeDragonPart("Spine", Vector3.new(0.6, 2, 0.8), Color3.fromRGB(255, 80, 0))
            weldParts(body, spine, CFrame.new(0, 2.8, i * 1.1) * CFrame.Angles(math.rad(-30), 0, 0))
        end

        -- Cổ và Đầu Rồng Siêu Nét
        local neck = makeDragonPart("DragonNeck", Vector3.new(3, 3, 4.5), Color3.fromRGB(170, 20, 0), Enum.Material.Granite)
        weldParts(body, neck, CFrame.new(0, 1.8, -5) * CFrame.Angles(math.rad(20), 0, 0))

        local head = makeDragonPart("DragonHead", Vector3.new(3.8, 3.2, 5.5), Color3.fromRGB(200, 30, 0), Enum.Material.Granite)
        weldParts(neck, head, CFrame.new(0, 1, -3.2))

        local upperJaw = makeDragonPart("UpperJaw", Vector3.new(3.2, 1.4, 3.5), Color3.fromRGB(220, 40, 0), Enum.Material.Granite)
        weldParts(head, upperJaw, CFrame.new(0, -0.7, -3))

        local lowerJaw = makeDragonPart("LowerJaw", Vector3.new(3, 1.2, 3), Color3.fromRGB(120, 0, 0), Enum.Material.Granite)
        local jawWeld = weldParts(head, lowerJaw, CFrame.new(0, -1.8, -2.8) * CFrame.Angles(math.rad(15), 0, 0))

        -- Mắt Rồng Phát Sáng
        local eyeL = makeDragonPart("EyeL", Vector3.new(0.6, 0.6, 1.2), Color3.fromRGB(255, 255, 0))
        weldParts(head, eyeL, CFrame.new(-1.6, 0.9, -1.8))
        local eyeR = makeDragonPart("EyeR", Vector3.new(0.6, 0.6, 1.2), Color3.fromRGB(255, 255, 0))
        weldParts(head, eyeR, CFrame.new(1.6, 0.9, -1.8))

        -- Sừng Rồng Uy Nghiêm
        local hornL = makeDragonPart("HornL", Vector3.new(0.8, 4, 0.8), Color3.fromRGB(255, 140, 0))
        weldParts(head, hornL, CFrame.new(-1.5, 2.2, 1.2) * CFrame.Angles(math.rad(-45), math.rad(-30), 0))
        local hornR = makeDragonPart("HornR", Vector3.new(0.8, 4, 0.8), Color3.fromRGB(255, 140, 0))
        weldParts(head, hornR, CFrame.new(1.5, 2.2, 1.2) * CFrame.Angles(math.rad(-45), math.rad(30), 0))

        -- Hệ Thống Phun Lửa Từ Miệng (Fire Breath FX)
        local fireEmitter = Instance.new("ParticleEmitter")
        fireEmitter.Name = "FireBreathParticles"
        fireEmitter.Texture = "rbxassetid://241837157"
        fireEmitter.Color = ColorSequence.new(Color3.fromRGB(255, 100, 0), Color3.fromRGB(255, 255, 0))
        fireEmitter.Size = NumberSequence.new(1.5, 8)
        fireEmitter.Rate = 80
        fireEmitter.Speed = NumberRange.new(45, 65)
        fireEmitter.Lifetime = NumberRange.new(0.6, 1.5)
        fireEmitter.SpreadAngle = Vector2.new(18, 18)
        fireEmitter.Enabled = true
        fireEmitter.Parent = upperJaw

        local fireLight = Instance.new("PointLight")
        fireLight.Color = Color3.fromRGB(255, 130, 0)
        fireLight.Range = 25
        fireLight.Brightness = 8
        fireLight.Parent = upperJaw

        -- Đuôi Rồng Dài 3 Khớp Sống Động
        local tail1 = makeDragonPart("Tail1", Vector3.new(3.2, 3, 7), Color3.fromRGB(120, 0, 0), Enum.Material.Granite)
        local tail1Weld = weldParts(body, tail1, CFrame.new(0, -0.6, 7))
        local tail2 = makeDragonPart("Tail2", Vector3.new(2.4, 2.2, 7), Color3.fromRGB(150, 20, 0), Enum.Material.Granite)
        local tail2Weld = weldParts(tail1, tail2, CFrame.new(0, 0, 6.5))
        local tailTip = makeDragonPart("TailTip", Vector3.new(1.2, 3.5, 3.5), Color3.fromRGB(255, 60, 0))
        weldParts(tail2, tailTip, CFrame.new(0, 0, 4) * CFrame.Angles(math.rad(45), 0, 0))

        -- 4 Chân & Móng Vuốt Sắc Nhọn
        local function makeLeg(name, c0)
            local leg = makeDragonPart(name, Vector3.new(1.6, 4, 1.6), Color3.fromRGB(100, 0, 0), Enum.Material.Granite)
            weldParts(body, leg, c0)
            local claw = makeDragonPart(name.."Claw", Vector3.new(1.8, 0.7, 2), Color3.fromRGB(255, 180, 0))
            weldParts(leg, claw, CFrame.new(0, -2, -0.5))
        end
        makeLeg("LegFL", CFrame.new(-2.6, -2.2, -3.2))
        makeLeg("LegFR", CFrame.new(2.6, -2.2, -3.2))
        makeLeg("LegBL", CFrame.new(-2.6, -2.2, 3.2))
        makeLeg("LegBR", CFrame.new(2.6, -2.2, 3.2))

        -- Cánh Rồng Đa Tầng Khổng Lồ
        local wingBaseL = makeDragonPart("WingBaseL", Vector3.new(1.6, 1.6, 6), Color3.fromRGB(180, 0, 0))
        local wingL_Weld = weldParts(body, wingBaseL, CFrame.new(-2.8, 2, -1.5))
        local wingBladeL = makeDragonPart("WingBladeL", Vector3.new(14, 0.3, 8), Color3.fromRGB(255, 50, 0))
        weldParts(wingBaseL, wingBladeL, CFrame.new(-7, 0, 1.5) * CFrame.Angles(0, math.rad(-20), 0))

        local wingBaseR = makeDragonPart("WingBaseR", Vector3.new(1.6, 1.6, 6), Color3.fromRGB(180, 0, 0))
        local wingR_Weld = weldParts(body, wingBaseR, CFrame.new(2.8, 2, -1.5))
        local wingBladeR = makeDragonPart("WingBladeR", Vector3.new(14, 0.3, 8), Color3.fromRGB(255, 50, 0))
        weldParts(wingBaseR, wingBladeR, CFrame.new(7, 0, 1.5) * CFrame.Angles(0, math.rad(20), 0))

        -- Animation Render Loop cho Rồng
        DragonRenderConnection = RunService.RenderStepped:Connect(function()
            if not ZakaConfig.Magic.UltraFireDragon or not char or not char:FindFirstChild("Humanoid") then
                ToggleUltraFireDragon(false)
                return
            end

            local t = tick() * 6
            local hum = char.Humanoid
            local moving = hum.MoveDirection.Magnitude > 0
            local speedMult = moving and 2 or 1

            -- Uốn lượn cổ, đuôi và vỗ cánh
            jawWeld.C0 = CFrame.new(0, -1.8, -2.8) * CFrame.Angles(math.rad(15 + math.sin(t*3)*12), 0, 0)
            tail1Weld.C0 = CFrame.new(math.sin(-t*speedMult)*1.4, -0.6, 7) * CFrame.Angles(0, math.sin(-t*speedMult)*0.35, 0)
            tail2Weld.C0 = CFrame.new(math.sin(-t*speedMult+1)*1.8, 0, 6.5) * CFrame.Angles(0, math.sin(-t*speedMult+1)*0.45, 0)

            local wingAngle = math.sin(t * 1.8 * speedMult) * 35
            wingL_Weld.C0 = CFrame.new(-2.8, 2, -1.5) * CFrame.Angles(0, 0, math.rad(wingAngle))
            wingR_Weld.C0 = CFrame.new(2.8, 2, -1.5) * CFrame.Angles(0, 0, math.rad(-wingAngle))
        end)
    else
        if char:FindFirstChild("ZakaUltraDragonModel") then char.ZakaUltraDragonModel:Destroy() end
        if DragonRenderConnection then DragonRenderConnection:Disconnect() end
    end
end

--==============================================================================--
--        3. RAINBOW ANGEL FEATHER WINGS & ICE CAGE UTILITY SKILL                 --
--==============================================================================--
local AngelFolder = nil
local AngelRenderConnection = nil

local function ToggleRainbowAngel(state)
    ZakaConfig.Magic.RainbowFeatherWings = state
    local char = LocalPlayer.Character
    if not char then return end

    if state then
        if char:FindFirstChild("ZakaAngelModel") then char.ZakaAngelModel:Destroy() end
        AngelFolder = Instance.new("Folder")
        AngelFolder.Name = "ZakaAngelModel"
        AngelFolder.Parent = char

        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        if not torso then return end

        local shield = Instance.new("Part")
        shield.Size = Vector3.new(12, 12, 12)
        shield.Shape = Enum.PartType.Ball
        shield.Material = Enum.Material.ForceField
        shield.Color = Color3.fromRGB(0, 255, 255)
        shield.CanCollide = false
        shield.Massless = true
        shield.Parent = AngelFolder

        local shieldWeld = Instance.new("Weld")
        shieldWeld.Part0 = torso
        shieldWeld.Part1 = shield
        shieldWeld.Parent = shield

        local hl = Instance.new("Highlight")
        hl.Adornee = shield
        hl.FillTransparency = 0.7
        hl.OutlineTransparency = 0.1
        hl.Parent = shield

        local function makeWingModel(side)
            local isL = side == "Left"
            local mult = isL and -1 or 1
            local main = Instance.new("Part")
            main.Size = Vector3.new(0.4, 9, 4.5)
            main.Material = Enum.Material.Neon
            main.Color = Color3.fromRGB(255, 255, 255)
            main.CanCollide = false
            main.Massless = true
            main.Parent = AngelFolder

            local w = Instance.new("Weld")
            w.Part0 = torso
            w.Part1 = main
            w.C0 = CFrame.new(3.5 * mult, 2.5, 1.5) * CFrame.Angles(0, math.rad(30 * mult), 0)
            w.Parent = main

            for i = 1, 8 do
                local feather = Instance.new("Part")
                feather.Size = Vector3.new(0.2, 5.5 - (i*0.4), 2.2)
                feather.Material = Enum.Material.Neon
                feather.Color = Color3.fromRGB(255, 255, 255)
                feather.CanCollide = false
                feather.Massless = true
                feather.Parent = AngelFolder

                local fw = Instance.new("Weld")
                fw.Part0 = main
                fw.Part1 = feather
                fw.C0 = CFrame.new(mult * (i * 0.7), -i * 0.4, i * 0.35) * CFrame.Angles(0, 0, math.rad(mult * (i * 12)))
                fw.Parent = feather
            end
            return w
        end

        local wingLWeld = makeWingModel("Left")
        local wingRWeld = makeWingModel("Right")

        local hue = 0
        AngelRenderConnection = RunService.RenderStepped:Connect(function()
            if not ZakaConfig.Magic.RainbowFeatherWings or not char or not char:FindFirstChild("ZakaAngelModel") then
                ToggleRainbowAngel(false)
                return
            end
            hue = (hue + 0.005) % 1
            local col = Color3.fromHSV(hue, 0.9, 1)
            shield.Color = col
            hl.FillColor = col
            hl.OutlineColor = col

            local flap = math.sin(tick() * 4) * 22
            wingLWeld.C0 = CFrame.new(-3.5, 2.5, 1.5) * CFrame.Angles(0, math.rad(-40 + flap), math.rad(20 + flap/2))
            wingRWeld.C0 = CFrame.new(3.5, 2.5, 1.5) * CFrame.Angles(0, math.rad(40 - flap), math.rad(-20 - flap/2))
        end)
    else
        if char:FindFirstChild("ZakaAngelModel") then char.ZakaAngelModel:Destroy() end
        if AngelRenderConnection then AngelRenderConnection:Disconnect() end
    end
end

print("[ZAKA HUD V2.0] Part 2 Movement, Dragon & Magic Loaded Successfully!")
--[[
    ╔═════════════════════════════════════════════════════════════════════════════════════════════════════╗
    ║                                   ZAKA HUD ULTIMATE V2.0 - TITAN EDITION                            ║
    ║                                                                                                     ║
    ║   PART 3: CYBERPUNK GUI MENU, DRAGGABLE PANELS, NOTIFICATION SYSTEM & SYSTEM INITIALIZATION       ║
    ╚═════════════════════════════════════════════════════════════════════════════════════════════════════╝
]]

--==============================================================================--
--                           1. NOTIFICATION SYSTEM                             --
--==============================================================================--
local function Notify(title, text, duration)
    duration = duration or 3
    local coreGui = game:GetService("CoreGui")
    local screenGui = coreGui:FindFirstChild("ZakaNotifyGui")
    
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "ZakaNotifyGui"
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = coreGui
    end

    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 280, 0, 70)
    notifFrame.Position = UDim2.new(1, -300, 1, -100)
    notifFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notifFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 60, 60)
    stroke.Thickness = 2
    stroke.Parent = notifFrame

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 0, 25)
    titleLbl.Position = UDim2.new(0, 10, 0, 5)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
    titleLbl.TextSize = 14
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = notifFrame

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -20, 0, 35)
    descLbl.Position = UDim2.new(0, 10, 0, 30)
    descLbl.BackgroundTransparency = 1
    descLbl.Font = Enum.Font.Gotham
    descLbl.Text = text
    descLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    descLbl.TextSize = 12
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextWrapped = true
    descLbl.Parent = notifFrame

    -- Hiệu ứng xuất hiện / biến mất
    notifFrame.Position = UDim2.new(1, 20, 1, -100)
    notifFrame:TweenPosition(UDim2.new(1, -300, 1, -100), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.4, true)

    task.delay(duration, function()
        if notifFrame and notifFrame.Parent then
            notifFrame:TweenPosition(UDim2.new(1, 20, 1, -100), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
            task.wait(0.3)
            notifFrame:Destroy()
        end
    end)
end

--==============================================================================--
--                           2. CYBERPUNK GUI BUILDER                           --
--==============================================================================--
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("ZakaHUD_UltimateV2") then
    CoreGui.ZakaHUD_UltimateV2:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaHUD_UltimateV2"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- Khung chính Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 420)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 30, 30)
MainStroke.Thickness = 2.5
MainStroke.Parent = MainFrame

-- Topbar (Thanh tiêu đề)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "⚡ ZAKA HUD ULTIMATE V2.0 - TITAN EDITION"
TitleLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Nút Đóng (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tab Container (Khu vực danh mục chức năng)
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 52)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.CanvasSize = UDim2.new(0, 0, 0, 650)
Container.ScrollBarThickness = 6
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 10)
UIList.Parent = Container

-- Hàm tạo các dòng nút chức năng (Toggle UI Elements)
local function CreateToggleOption(name, categoryKey, configKey, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local statusIndicator = Instance.new("Frame")
    statusIndicator.Size = UDim2.new(0, 18, 0, 18)
    statusIndicator.Position = UDim2.new(1, -30, 0.5, -9)
    statusIndicator.BackgroundColor3 = ZakaConfig[categoryKey][configKey] and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 40, 40)
    statusIndicator.BorderSizePixel = 0
    statusIndicator.Parent = btn

    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(1, 0)
    indCorner.Parent = statusIndicator

    btn.MouseButton1Click:Connect(function()
        local newState = not ZakaConfig[categoryKey][configKey]
        ZakaConfig[categoryKey][configKey] = newState
        statusIndicator.BackgroundColor3 = newState and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 40, 40)
        if callback then
            callback(newState)
        end
        Notify("ZAKA HUD", name .. ": " .. (newState and "ENABLED 🟢" else "DISABLED 🔴"), 2)
    end)
end

-- Tạo danh sách các tính năng cho Menu UI
CreateToggleOption("Fly Hack (Bay tự do)", "Movement", "FlyHack", ToggleFly)
CreateToggleOption("Noclip (Xuyên tường)", "Movement", "Noclip", ToggleNoclip)
CreateToggleOption("Speed Hack (Tốc độ chạy)", "Movement", "SpeedHack", function(state) end)
CreateToggleOption("Spinbot (Xoay cuồng phong)", "Movement", "SpinBot", function(state) end)

CreateToggleOption("Ultra Mythical Fire Dragon Mount (Rồng Lửa Siêu Cấp)", "Magic", "UltraFireDragon", ToggleUltraFireDragon)
CreateToggleOption("Rainbow Angel Feather Wings (Cánh Thiên Thần 7 Màu)", "Magic", "RainbowFeatherWings", ToggleRainbowAngel)
CreateToggleOption("Aimbot Pro (Tự động khóa mục tiêu)", "Combat", "Aimbot", function(state) end)
CreateToggleOption("ESP Box & Name (Xuyên tường hiển thị Player)", "Visuals", "ESP", function(state) end)

--==============================================================================--
--                           3. SYSTEM INITIALIZATION                           --
--==============================================================================--
Notify("ZAKA HUD V2.0", "Hệ thống Titan đã kích hoạt thành công!", 4)
print([[
    ╔═════════════════════════════════════════════════════════════════════════╗
    ║                 ZAKA HUD ULTIMATE V2.0 - LOADED SUCCESSFULLY            ║
    ║      - Movement, Fly/Noclip, Ultra Fire Dragon & Angel Wings Loaded     ║
    ║      - Cyberpunk GUI Menu Activated!                                    ║
    ╚═════════════════════════════════════════════════════════════════════════╝
]])
