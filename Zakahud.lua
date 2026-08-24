--[[
    ╔════════════════════════════════════════════════════════════════════════════════╗
    ║                 ZAKA HUD ULTIMATE - V1.1 (SMOOTH OVERHAUL)                     ║
    ║   - Smoother UI Animations & Clean Vertical Layout                             ║
    ║   - Enhanced Anti-Detection & Optimized Loops                                  ║
    ║   - High-Detail Visual Magic Skills (Dragon, Angel, Ice Cage & Shockwaves)     ║
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

print("========================================")
print(" ZakaHUD v1.1 Loaded Successfully!")
print(" Ngan hang ung ho: Vietcombank")
print(" Chu TK: VU DUC DAI | STK: 1067117291")
print("========================================")

--==============================================================================--
--                            CẤU HÌNH HỆ THỐNG (SETTINGS)                       --
--==============================================================================--
local Settings = {
    Aimbot = false,
    AimbotFOV = 120,
    AimbotSmooth = 0.25,
    HitboxExpander = false,
    HitboxSize = 20,

    ESP = false,
    ESPBox = true,
    ESPName = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPTracers = false,
    ESPMaxDist = 3000,

    Speed = false,
    SpeedValue = 28,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    InfiniteJump = false,
    SpinBot = false,
    SpinSpeed = 40,
    TouchTP = false,

    Dropkick = false,
    DropkickPower = 3500,

    RainbowAngel = false,
    FireAura = false,
    FireDragonMount = false,
    HoldGentlemanFlower = false,

    NoFog = false,
    NeonNight = false,
    GlowTrail = false,
    CustomFOV = 70,

    Fullbright = false,
    AntiAFK = true,
}

local NoclipConn, SpeedConn, FlyConn, DropkickConn, TouchTPConn
local DragonRenderConn, AngelRenderConn
local BodyGyro, BodyVelocity
local ESPObjects = {}
local OriginalFogEnd = Lighting.FogEnd

-- Chống AFK An Toàn
LocalPlayer.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Infinite Jump
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

--==============================================================================--
--                     KĨ NĂNG 1: BÔNG HOA TRÂN TRỌNG                            --
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
--            KĨ NĂNG 2: CƯỠI RỒNG LỬA HỒI SINH (OPTIMIZED & SMOOTH)            --
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

        local function createPart(name, size, color, mat)
            local p = Instance.new("Part")
            p.Name = name
            p.Size = size
            p.Color = color or Color3.fromRGB(180, 0, 0)
            p.Material = mat or Enum.Material.Neon
            p.Transparency = 0
            p.CanCollide = false
            p.Massless = true
            p.Parent = dragonFolder
            return p
        end

        local function attachWeld(p0, p1, c0)
            local w = Instance.new("Weld")
            w.Part0 = p0
            w.Part1 = p1
            w.C0 = c0 or CFrame.new()
            w.Parent = p1
            return w
        end

        local bodyPart = createPart("DragonBody", Vector3.new(4, 3.5, 8), Color3.fromRGB(160, 0, 0), Enum.Material.Granite)
        attachWeld(root, bodyPart, CFrame.new(0, -3.8, 0))

        local headPart = createPart("DragonHead", Vector3.new(3.2, 2.8, 4.5), Color3.fromRGB(220, 20, 0), Enum.Material.Granite)
        local headWeld = attachWeld(bodyPart, headPart, CFrame.new(0, 1.2, -5.5))

        local tail1 = createPart("DragonTail1", Vector3.new(2.8, 2.5, 6), Color3.fromRGB(140, 0, 0), Enum.Material.Granite)
        local tail1Weld = attachWeld(bodyPart, tail1, CFrame.new(0, -0.4, 6))

        local leftWingBase = createPart("LeftWingBase", Vector3.new(1.2, 1.2, 5), Color3.fromRGB(200, 0, 0))
        local leftWingWeld = attachWeld(bodyPart, leftWingBase, CFrame.new(-2.2, 1.5, -1))

        local rightWingBase = createPart("RightWingBase", Vector3.new(1.2, 1.2, 5), Color3.fromRGB(200, 0, 0))
        local rightWingWeld = attachWeld(bodyPart, rightWingBase, CFrame.new(2.2, 1.5, -1))

        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.P = 1e5
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

            local t = tick() * 5
            local hum = char.Humanoid
            local moveDir = hum.MoveDirection
            local isMoving = moveDir.Magnitude > 0

            headWeld.C0 = CFrame.new(0, 1.2 + math.sin(t) * 0.2, -5.5) * CFrame.Angles(0, math.sin(t * 0.5) * 0.15, 0)
            tail1Weld.C0 = CFrame.new(math.sin(t * 0.7) * 0.8, -0.4, 6) * CFrame.Angles(0, math.sin(t * 0.7) * 0.2, 0)

            local wingAngle = math.sin(t * 1.5) * 25
            leftWingWeld.C0 = CFrame.new(-2.2, 1.5, -1) * CFrame.Angles(0, 0, math.rad(wingAngle))
            rightWingWeld.C0 = CFrame.new(2.2, 1.5, -1) * CFrame.Angles(0, 0, math.rad(-wingAngle))

            BodyGyro.cframe = Camera.CFrame
            if isMoving then
                local camCF = Camera.CFrame
                local flyDir = (camCF.LookVector * (-moveDir.Z)) + (camCF.RightVector * moveDir.X)
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
--           KĨ NĂNG 3: CÁNH THIÊN THẦN + KHIÊN CẦU VỒNG                         --
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
        shield.Shape = Enum.PartType.Ball
        shield.Size = Vector3.new(10, 10, 10)
        shield.Material = Enum.Material.ForceField
        shield.CanCollide = false
        shield.Massless = true
        shield.Parent = angelFolder

        local shieldWeld = Instance.new("Weld")
        shieldWeld.Part0 = torso
        shieldWeld.Part1 = shield
        shieldWeld.Parent = shield

        local hl = Instance.new("Highlight")
        hl.Adornee = shield
        hl.FillTransparency = 0.7
        hl.OutlineTransparency = 0.1
        hl.Parent = shield

        local hue = 0
        AngelRenderConn = RunService.RenderStepped:Connect(function()
            if not Settings.RainbowAngel or not char or not char:FindFirstChild("FEAngelFolder") then
                SetRainbowAngel(false)
                return
            end
            hue = (hue + 0.005) % 1
            local col = Color3.fromHSV(hue, 0.9, 1)
            shield.Color = col
            hl.OutlineColor = col
            hl.FillColor = col
        end)
    else
        if char:FindFirstChild("FEAngelFolder") then char.FEAngelFolder:Destroy() end
        if AngelRenderConn then AngelRenderConn:Disconnect() AngelRenderConn = nil end
    end
end

--==============================================================================--
--        KĨ NĂNG 4: LỒNG BĂNG 15S + NỔ HẤT VĂNG                                --
--==============================================================================--
local function CreateIceCageSuper()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local targetPlayer, closestDist = nil, 60
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
        cageModel.Name = "SuperIceCage"

        local cagePos = targetRoot.Position
        local size = 10

        local function makeWall(cf, s)
            local wall = Instance.new("Part")
            wall.Size = s
            wall.CFrame = cf
            wall.Material = Enum.Material.Ice
            wall.Color = Color3.fromRGB(120, 240, 255)
            wall.Transparency = 0.2
            wall.Anchored = true
            wall.CanCollide = true
            wall.Parent = cageModel
        end

        makeWall(CFrame.new(cagePos + Vector3.new(0, -size/2, 0)), Vector3.new(size, 0.5, size))
        makeWall(CFrame.new(cagePos + Vector3.new(0, size/2, 0)), Vector3.new(size, 0.5, size))
        makeWall(CFrame.new(cagePos + Vector3.new(size/2, 0, 0)), Vector3.new(0.5, size, size))
        makeWall(CFrame.new(cagePos + Vector3.new(-size/2, 0, 0)), Vector3.new(0.5, size, size))
        makeWall(CFrame.new(cagePos + Vector3.new(0, 0, size/2)), Vector3.new(size, size, 0.5))
        makeWall(CFrame.new(cagePos + Vector3.new(0, 0, -size/2)), Vector3.new(size, size, 0.5))

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

                local tween = TweenService:Create(blast, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = Vector3.new(35, 35, 35),
                    Transparency = 1
                })
                tween:Play()
                tween.Completed:Connect(function() blast:Destroy() end)

                if targetRoot and targetRoot.Parent then
                    targetRoot.AssemblyLinearVelocity = Vector3.new(math.random(-120, 120), 280, math.random(-120, 120))
                end
                cageModel:Destroy()
            end
        end)
    end
end

-- Utils
local function SetFireAura(state)
    Settings.FireAura = state
    local char = LocalPlayer.Character
    if not char then return end
    if state then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local fire = Instance.new("Fire")
                fire.Name = "MagicFireEffect"
                fire.Size = 6
                fire.Color = Color3.fromRGB(255, 60, 0)
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

    local tween = TweenService:Create(wave, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(0.5, 50, 50),
        Transparency = 1
    })
    tween:Play()
    tween.Completed:Connect(function() wave:Destroy() end)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = plr.Character.HumanoidRootPart
            if (targetRoot.Position - root.Position).Magnitude <= 30 then
                local pushDir = (targetRoot.Position - root.Position).Unit
                targetRoot.AssemblyLinearVelocity = (pushDir * 200) + Vector3.new(0, 120, 0)
            end
        end
    end
end

-- Aimbot & Movement Engine
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Radius = Settings.AimbotFOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(0, 162, 255)

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Visible = Settings.Aimbot

    if Settings.Aimbot then
        local closestHead, shortestDist = nil, Settings.AimbotFOV
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
        if closestHead then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, closestHead.Position), Settings.AimbotSmooth)
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

local function SetSpeed(state)
    if SpeedConn then SpeedConn:Disconnect() SpeedConn = nil end
    if state then
        SpeedConn = RunService.Heartbeat:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = Settings.SpeedValue end
        end)
    else
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
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
--                        GIAO DIỆN MƯỢT MÀ (MODERN UI v1.1)                     --
--==============================================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaHub_UI_v1.1"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local ToggleIcon = Instance.new("TextButton")
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
Main.Size = UDim2.new(0, 360, 0, 380)
Main.Position = UDim2.new(0.5, -180, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 162, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.4

ToggleIcon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -15, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "<b>ZAKA</b> <font color=\"#00A2FF\">HUD</font> <font color=\"#888888\">| v1.1 Ultimate</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.Gotham
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Tab Buttons (Smooth Scrolling Menu Tab)
local TabBar = Instance.new("ScrollingFrame")
TabBar.Size = UDim2.new(1, -12, 0, 32)
TabBar.Position = UDim2.new(0, 6, 0, 46)
TabBar.BackgroundTransparency = 1
TabBar.CanvasSize = UDim2.new(0, 520, 0, 0)
TabBar.ScrollBarThickness = 0
TabBar.Parent = Main

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.Padding = UDim.new(0, 4)
TabListLayout.Parent = TabBar

local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -12, 1, -90)
PageContainer.Position = UDim2.new(0, 6, 0, 84)
PageContainer.BackgroundTransparency = 1
PageContainer.ClipsDescendants = true
PageContainer.Parent = Main

local Tabs = {"Combat", "ESP", "Player", "Teleport", "Troll", "Magic", "Utility", "Misc", "Donate"}
local CurrentTabIndex = 1
local TabButtons, Pages = {}, {}

local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local function CreatePage(index)
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
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = page

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    Pages[index] = page
    return page
end

for i, name in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 54, 1, 0)
    btn.BackgroundColor3 = i == CurrentTabIndex and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(22, 22, 30)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    TabButtons[i] = btn
    CreatePage(i)

    btn.MouseButton1Click:Connect(function()
        CurrentTabIndex = i
        for idx, b in ipairs(TabButtons) do
            TweenService:Create(b, tweenInfo, {BackgroundColor3 = idx == i and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(22, 22, 30)}):Play()
        end
        for idx, p in ipairs(Pages) do
            TweenService:Create(p, tweenInfo, {Position = UDim2.new(idx - CurrentTabIndex, 0, 0, 0)}):Play()
        end
    end)
end

-- UI Component Helpers (Vertical Row Layout)
local function CreateToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.TextSize = 11.5
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 36, 0, 18)
    toggleBtn.Position = UDim2.new(1, -42, 0.5, -9)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(40, 40, 52)
    toggleBtn.Text = ""
    toggleBtn.Parent = frame
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local enabled = default
    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        TweenService:Create(toggleBtn, tweenInfo, {BackgroundColor3 = enabled and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(40, 40, 52)}):Play()
        callback(enabled)
    end)
end

local function CreateInput(parent, text, default, maxVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.TextSize = 11.5
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 55, 0, 20)
    textBox.Position = UDim2.new(1, -62, 0.5, -10)
    textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
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
    btn.Size = UDim2.new(1, -4, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11.5
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

local function CreateInfoCard(parent, titleText, descText)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 120)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(0, 162, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.5

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -16, 0, 24)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = Color3.fromRGB(0, 162, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12.5
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -24, 1, -34)
    desc.Position = UDim2.new(0, 12, 0, 30)
    desc.BackgroundTransparency = 1
    desc.Text = descText
    desc.RichText = true
    desc.TextColor3 = Color3.fromRGB(220, 220, 230)
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 11.5
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = frame
end

--==============================================================================--
--                        KHỞI TẠO NỘI DUNG CÁC TABS                              --
--==============================================================================--

-- Tab 1: Combat
CreateToggle(Pages[1], "Aimbot Khóa Đầu", false, function(v) Settings.Aimbot = v end)
CreateInput(Pages[1], "Kích Thước FOV Aim", 120, 800, function(v) Settings.AimbotFOV = v end)
CreateToggle(Pages[1], "Hitbox Expander (Đầu To)", false, function(v) Settings.HitboxExpander = v end)
CreateInput(Pages[1], "Kích Thước Hitbox", 20, 500, function(v) Settings.HitboxSize = v end)

-- Tab 2: ESP
CreateToggle(Pages[2], "Bật Tổng ESP", false, function(v) Settings.ESP = v end)
CreateToggle(Pages[2], "Khung ESP (Box)", true, function(v) Settings.ESPBox = v end)
CreateToggle(Pages[2], "Tên Người Chơi", true, function(v) Settings.ESPName = v end)
CreateToggle(Pages[2], "Thanh Máu (HP)", true, function(v) Settings.ESPHealth = v end)
CreateToggle(Pages[2], "Khoảng Cách", true, function(v) Settings.ESPDistance = v end)
CreateToggle(Pages[2], "Đường Kẻ (Tracers)", false, function(v) Settings.ESPTracers = v end)

-- Tab 3: Player
CreateToggle(Pages[3], "Tăng Tốc Chạy (WalkSpeed)", false, function(v) Settings.Speed = v SetSpeed(v) end)
CreateInput(Pages[3], "Tốc Độ Chạy", 28, 500, function(v) Settings.SpeedValue = v end)
CreateToggle(Pages[3], "Bật Fly (Bay Mượt)", false, function(v) Settings.Fly = v if v then StartFly() end end)
CreateInput(Pages[3], "Tốc Độ Bay", 50, 500, function(v) Settings.FlySpeed = v end)
CreateToggle(Pages[3], "Nhảy Vô Hạn", false, function(v) Settings.InfiniteJump = v end)
CreateToggle(Pages[3], "SpinBot Xoay Vòng", false, function(v) Settings.SpinBot = v end)
CreateToggle(Pages[3], "Đi Xuyên Tường (Noclip)", false, function(v) Settings.Noclip = v SetNoclip(v) end)

-- Tab 4: Teleport
CreateToggle(Pages[4], "Chạm Đâu Tele Đó", false, function(v) SetTouchTP(v) end)
CreateButton(Pages[4], "Teleport Tới Người Chơi Gần Nhất", function()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            myRoot.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            break
        end
    end
end)
CreateButton(Pages[4], "Kéo Tất Cả Lại Gần (Bring All)", function()
    pcall(function()
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = myRoot.CFrame + Vector3.new(2, 0, 2)
                end
            end
        end
    end)
end)

-- Tab 5: Troll
CreateToggle(Pages[5], "Bật Dropkick (Đá Văng)", false, function(v) Settings.Dropkick = v end)
CreateInput(Pages[5], "Lực Dropkick", 3500, 10000, function(v) Settings.DropkickPower = v end)

-- Tab 6: Magic (High Detail)
CreateToggle(Pages[6], "Cưỡi Rồng Lửa (Smooth Flight)", false, function(v) SetFireDragonMount(v) end)
CreateToggle(Pages[6], "Cánh Thiên Thần + Khiên Cầu Vồng", false, function(v) SetRainbowAngel(v) end)
CreateToggle(Pages[6], "Cầm Bông Hoa Trân Trọng", false, function(v) SetGentlemanFlower(v) end)
CreateToggle(Pages[6], "Hiệu Ứng Lửa Quanh Thân", false, function(v) SetFireAura(v) end)
CreateButton(Pages[6], "Lồng Băng 15s + Phát Nổ Hất Văng", function() CreateIceCageSuper() end)
CreateButton(Pages[6], "Sóng Xung Kích Giậm Chân", function() GroundStompShockwave() end)

-- Tab 7: Utility
CreateToggle(Pages[7], "Chống Mờ Sương Mù (No Fog)", false, function(v) Settings.NoFog = v Lighting.FogEnd = v and 1e6 or OriginalFogEnd end)
CreateToggle(Pages[7], "Chế Độ Ban Đêm Neon", false, function(v)
    if v then Lighting.ClockTime = 0 Lighting.Brightness = 3 else Lighting.ClockTime = 12 Lighting.Brightness = 1 end
end)
CreateToggle(Pages[7], "Vệt Sáng Bước Chân", false, function(v) Settings.GlowTrail = v end)
CreateInput(Pages[7], "Đổi Góc Nhìn FOV", 70, 120, function(v) Settings.CustomFOV = v end)

-- Tab 8: Misc
CreateToggle(Pages[8], "Nhìn Trong Đêm (Fullbright)", false, function(v) Lighting.Brightness = v and 2.5 or 1 end)
CreateToggle(Pages[8], "Chống AFK Tự Động", true, function(v) Settings.AntiAFK = v end)
CreateButton(Pages[8], "Vào Lại Server (Rejoin)", function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)

-- Tab 9: Donate
CreateInfoCard(Pages[9], "CẢM ƠN BẠN ĐÃ ỦNG HỘ ZAKAHUD!", 
    "<b>Mọi đóng góp giúp dự án phát triển tốt hơn!</b>\n\n" ..
    "<b>• Ngân hàng:</b> Vietcombank\n" ..
    "<b>• Chủ TK:</b> VU DUC DAI\n" ..
    "<b>• Số TK:</b> <font color=\"#00A2FF\">1067117291</font>"
)

print("ZakaHUD v1.1 Overhaul Successfully Initialized!")
