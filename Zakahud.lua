--[[
    ╔════════════════════════════════════════════════════════════════╗
    ║             ZAKA HUB UNIVERSAL - V6 SMOOTH & MAGIC             ║
    ║   Tab Sliding Animations + Fire / Cage / Shield / Shockwave    ║
    ╚════════════════════════════════════════════════════════════════╝
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

--==================== CẤU HÌNH (SETTINGS) ====================--
local Settings = {
    -- Combat
    Aimbot = false,
    AimbotFOV = 120,
    AimbotSmooth = 0.2,
    HitboxExpander = false,
    HitboxSize = 20,

    -- ESP
    ESP = false,
    ESPBox = true,
    ESPName = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPTracers = false,
    ESPMaxDist = 3000,

    -- Player & Movement
    Speed = false,
    SpeedValue = 28,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    InfiniteJump = false,
    SpinBot = false,
    SpinSpeed = 40,

    -- Troll & Dropkick
    Dropkick = false,
    DropkickPower = 3000,
    GodMode = false,

    -- Magic
    MagicAura = false,
    FireAura = false,
    Shield = false,

    -- Misc
    Fullbright = false,
    AntiAFK = true,
}

--==================== BIẾN HỆ THỐNG ====================--
local NoclipConn, SpeedConn, FlyConn, GodConn, DropkickConn
local BodyGyro, BodyVelocity
local ESPObjects = {}

-- Anti AFK
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

--==================== MOBILE AIMBOT & HITBOX ====================--
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
end)

--==================== MOVEMENT & FLY ====================--
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

--==================== DROPKICK & TROLL ====================--
local function SetDropkick(state)
    Settings.Dropkick = state
    if DropkickConn then DropkickConn:Disconnect() DropkickConn = nil end

    if state then
        DropkickConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local root = char.HumanoidRootPart

            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = plr.Character.HumanoidRootPart
                    local dist = (targetRoot.Position - root.Position).Magnitude
                    if dist <= 12 then
                        local flingVel = (targetRoot.Position - root.Position).Unit * Settings.DropkickPower
                        flingVel = Vector3.new(flingVel.X, Settings.DropkickPower / 2, flingVel.Z)
                        root.AssemblyLinearVelocity = flingVel
                        root.AssemblyAngularVelocity = Vector3.new(Settings.DropkickPower, Settings.DropkickPower, Settings.DropkickPower)
                    end
                end
            end
        end)
    else
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0,0,0)
        end
    end
end

--==================== HỆ THỐNG PHÉP THUẬT (MAGIC POWERS) ====================--

-- 1. Hào Quang Phép Thuật (Magic Aura)
local function SetMagicAura(state)
    Settings.MagicAura = state
    local char = LocalPlayer.Character
    if not char then return end

    if state then
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local ring = Instance.new("Part")
        ring.Name = "MagicAuraRing"
        ring.Size = Vector3.new(8, 0.2, 8)
        ring.Material = Enum.Material.Neon
        ring.Color = Color3.fromRGB(0, 162, 255)
        ring.CanCollide = false
        ring.Parent = char

        local weld = Instance.new("Weld")
        weld.Part0 = root
        weld.Part1 = ring
        weld.C0 = CFrame.new(0, -2.5, 0)
        weld.Parent = ring

        local particles = Instance.new("ParticleEmitter")
        particles.Texture = "rbxassetid://243660364"
        particles.Color = ColorSequence.new(Color3.fromRGB(0, 200, 255), Color3.fromRGB(150, 0, 255))
        particles.Size = NumberSequence.new(1.2, 0)
        particles.Lifetime = NumberRange.new(0.5, 1.2)
        particles.Rate = 35
        particles.Speed = NumberRange.new(2, 5)
        particles.Parent = ring
    else
        for _, p in ipairs(char:GetChildren()) do
            if p.Name == "MagicAuraRing" then p:Destroy() end
        end
    end
end

-- 2. Hỏa Thuật (Tạo Lửa Bao Quanh)
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
                fire.Heat = 12
                fire.Color = Color3.fromRGB(255, 100, 0)
                fire.SecondaryColor = Color3.fromRGB(255, 230, 0)
                fire.Parent = part
            end
        end
    else
        for _, part in ipairs(char:GetDescendants()) do
            if part.Name == "MagicFireEffect" then part:Destroy() end
        end
    end
end

-- 3. Khiên Phép Bảo Vệ (Magic Shield)
local function SetMagicShield(state)
    Settings.Shield = state
    local char = LocalPlayer.Character
    if not char then return end

    if state then
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local shield = Instance.new("Part")
        shield.Name = "MagicShieldSphere"
        shield.Shape = Enum.PartType.Ball
        shield.Size = Vector3.new(10, 10, 10)
        shield.Material = Enum.Material.ForceField
        shield.Color = Color3.fromRGB(0, 255, 200)
        shield.Transparency = 0.3
        shield.CanCollide = false
        shield.Parent = char

        local weld = Instance.new("Weld")
        weld.Part0 = root
        weld.Part1 = shield
        weld.C0 = CFrame.new(0, 0, 0)
        weld.Parent = shield
    else
        for _, p in ipairs(char:GetChildren()) do
            if p.Name == "MagicShieldSphere" then p:Destroy() end
        end
    end
end

-- 4. Lồng Nhốt Người Chơi Gần Nhất (Magic Cage)
local function CreateMagicCage()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local targetPlayer = nil
    local closestDist = 40

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
        cageModel.Name = "MagicCageContainer"

        local cagePos = targetRoot.Position
        local size = 8

        local function makeWall(cf, s)
            local wall = Instance.new("Part")
            wall.Size = s
            wall.CFrame = cf
            wall.Material = Enum.Material.Neon
            wall.Color = Color3.fromRGB(180, 0, 255)
            wall.Transparency = 0.4
            wall.Anchored = true
            wall.CanCollide = true
            wall.Parent = cageModel
        end

        makeWall(CFrame.new(cagePos + Vector3.new(0, -size/2, 0)), Vector3.new(size, 0.5, size)) -- Sàn
        makeWall(CFrame.new(cagePos + Vector3.new(0, size/2, 0)), Vector3.new(size, 0.5, size))  -- Trần
        makeWall(CFrame.new(cagePos + Vector3.new(size/2, 0, 0)), Vector3.new(0.5, size, size))  -- Tường 1
        makeWall(CFrame.new(cagePos + Vector3.new(-size/2, 0, 0)), Vector3.new(0.5, size, size)) -- Tường 2
        makeWall(CFrame.new(cagePos + Vector3.new(0, 0, size/2)), Vector3.new(size, size, 0.5))  -- Tường 3
        makeWall(CFrame.new(cagePos + Vector3.new(0, 0, -size/2)), Vector3.new(size, size, 0.5)) -- Tường 4

        cageModel.Parent = workspace
        task.delay(10, function() cageModel:Destroy() end)
    end
end

-- 5. Giậm Chân Sóng Xung Kích
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

    local tween = TweenService:Create(wave, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(0.5, 50, 50),
        Transparency = 1
    })
    tween:Play()
    tween.Completed:Connect(function() wave:Destroy() end)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = plr.Character.HumanoidRootPart
            local dist = (targetRoot.Position - root.Position).Magnitude
            if dist <= 30 then
                local pushDir = (targetRoot.Position - root.Position).Unit
                targetRoot.AssemblyLinearVelocity = (pushDir * 180) + Vector3.new(0, 120, 0)
            end
        end
    end
end

--==================== ESP SYSTEM ====================--
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

--==================== GIAO DIỆN ONE UI ANIMATED ====================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaHub_UI"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Nút Icon Toggle
local ToggleIcon = Instance.new("TextButton")
ToggleIcon.Name = "ZakaToggleIcon"
ToggleIcon.Size = UDim2.new(0, 44, 0, 44)
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

local IconStroke = Instance.new("UIStroke", ToggleIcon)
IconStroke.Color = Color3.fromRGB(255, 255, 255)
IconStroke.Thickness = 2
IconStroke.Transparency = 0.4

-- Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 335, 0, 345)
Main.Position = UDim2.new(0.5, -167, 0.5, -172)
Main.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 162, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.6

ToggleIcon.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -15, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "<b>ZAKA</b> <font color=\"#00A2FF\">HUB</font> <font color=\"#888888\">| Ultimate v6</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.Gotham
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Container Cho Slide Animation
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -12, 1, -82)
PageContainer.Position = UDim2.new(0, 6, 0, 76)
PageContainer.BackgroundTransparency = 1
PageContainer.ClipsDescendants = true
PageContainer.Parent = Main

-- Tab System
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, -12, 0, 28)
TabFrame.Position = UDim2.new(0, 6, 0, 42)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = Main

local Tabs = {"Combat", "ESP", "Player", "Troll", "Magic", "Misc"}
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
    btn.Size = UDim2.new(1 / #Tabs, -3, 1, 0)
    btn.Position = UDim2.new((i - 1) / #Tabs, 2, 0, 0)
    btn.BackgroundColor3 = i == CurrentTabIndex and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(25, 25, 34)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TabFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
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

-- UI Component Helpers
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

--==================== THIẾT LẬP MENU CÁC TABS ====================--

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

-- Tab 4: Troll
CreateToggle(Pages[4], "Bật Dropkick (Đá Văng FE)", false, function(v) SetDropkick(v) end)
CreateInput(Pages[4], "Lực Dropkick (Max 10000)", 3000, 10000, function(v) Settings.DropkickPower = v end)
CreateButton(Pages[4], "Tải Dropkick RawScript Phủ Khắp", function()
    pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-THE-REAL-dropkick-177199"))() end)
end)
CreateButton(Pages[4], "Kill All (Tiêu diệt tất cả)", function()
    pcall(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                player.Character:FindFirstChildOfClass("Humanoid").Health = 0
            end
        end
    end)
end)

-- Tab 5: Magic
CreateToggle(Pages[5], "Hào Quang Ma Thuật (Magic Aura)", false, function(v) SetMagicAura(v) end)
CreateToggle(Pages[5], "Triệu Hồi Lửa Quanh Thân (Fire)", false, function(v) SetFireAura(v) end)
CreateToggle(Pages[5], "Khiên Phép Bảo Vệ (Shield)", false, function(v) SetMagicShield(v) end)
CreateButton(Pages[5], "Tạo Lồng Nhốt Người Gần Nhất", function() CreateMagicCage() end)
CreateButton(Pages[5], "Sóng Xung Kích Giậm Chân", function() GroundStompShockwave() end)

-- Tab 6: Misc
CreateToggle(Pages[6], "Nhìn Trong Đêm (Fullbright)", false, function(v) 
    Lighting.Brightness = v and 2 or 1 
    Lighting.ClockTime = v and 14 or 12
end)
CreateToggle(Pages[6], "Tự Động Anti-AFK", true, function(v) Settings.AntiAFK = v end)
CreateButton(Pages[6], "Vào Lại Server (Rejoin)", function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
CreateButton(Pages[6], "Đổi Server Ngẫu Nhiên (Server Hop)", function()
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

print("Zaka Hub Ultimate v6 Smooth & Magic Loaded!")
