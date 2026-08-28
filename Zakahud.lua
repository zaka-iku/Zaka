--[[
    ╔════════════════════════════════════════════════════════════════════════════╗
    ║                    ZAKA HUD ULTIMATE v2 - PART 1                           ║
    ║         Core System + Superman Fly (with Cape) + Movement                  ║
    ║                     Mobile + PC Optimized                                  ║
    ╚════════════════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==============================================================================--
--                              SETTINGS
--==============================================================================--
local Settings = {
    -- Movement
    Speed = false,
    SpeedValue = 28,
    Fly = false,
    FlySpeed = 70,
    Noclip = false,
    InfiniteJump = false,
    HighJump = false,
    JumpPower = 60,
    ClickTP = false,

    -- Visual
    Fullbright = false,
    NoFog = false,

    -- Misc
    AntiAFK = true,
}

--==============================================================================--
--                              VARIABLES
--==============================================================================--
local Flying = false
local BodyVelocity, BodyGyro
local NoclipConn, SpeedConn
local CapeModel = nil
local CapeConn = nil

--==============================================================================--
--                              ANTI AFK
--==============================================================================--
LocalPlayer.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

--==============================================================================--
--                     SUPERMAN FLY + ÁO CHOÀNG
--==============================================================================--
local function CreateCape(character)
    if CapeModel then
        CapeModel:Destroy()
        CapeModel = nil
    end
    if CapeConn then
        CapeConn:Disconnect()
        CapeConn = nil
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    if not root or not torso then return end

    CapeModel = Instance.new("Model")
    CapeModel.Name = "ZakaSupermanCape"

    -- Phần chính của áo choàng
    local cape = Instance.new("Part")
    cape.Name = "CapeMain"
    cape.Size = Vector3.new(2.2, 3.4, 0.15)
    cape.Color = Color3.fromRGB(180, 20, 20)
    cape.Material = Enum.Material.Fabric
    cape.CanCollide = false
    cape.Massless = true
    cape.CastShadow = true
    cape.Parent = CapeModel

    -- Viền vàng
    local border = Instance.new("Part")
    border.Name = "CapeBorder"
    border.Size = Vector3.new(2.4, 3.6, 0.08)
    border.Color = Color3.fromRGB(255, 200, 50)
    border.Material = Enum.Material.Neon
    border.CanCollide = false
    border.Massless = true
    border.Transparency = 0.3
    border.Parent = CapeModel

    local borderWeld = Instance.new("Weld")
    borderWeld.Part0 = cape
    borderWeld.Part1 = border
    borderWeld.C0 = CFrame.new(0, 0, 0.02)
    borderWeld.Parent = border

    -- Logo "S" (đơn giản)
    local logo = Instance.new("Part")
    logo.Name = "CapeLogo"
    logo.Size = Vector3.new(0.9, 0.9, 0.12)
    logo.Color = Color3.fromRGB(255, 220, 50)
    logo.Material = Enum.Material.Neon
    logo.CanCollide = false
    logo.Massless = true
    logo.Shape = Enum.PartType.Ball
    logo.Parent = CapeModel

    local logoWeld = Instance.new("Weld")
    logoWeld.Part0 = cape
    logoWeld.Part1 = logo
    logoWeld.C0 = CFrame.new(0, 0.6, -0.08)
    logoWeld.Parent = logo

    -- Weld áo choàng vào lưng
    local capeWeld = Instance.new("Weld")
    capeWeld.Part0 = torso
    capeWeld.Part1 = cape
    capeWeld.C0 = CFrame.new(0, 0.3, 1.1) * CFrame.Angles(math.rad(8), 0, 0)
    capeWeld.Parent = cape

    CapeModel.Parent = character

    -- Hiệu ứng bay phần (áo choàng bay theo chuyển động)
    local baseC0 = capeWeld.C0
    CapeConn = RunService.RenderStepped:Connect(function()
        if not CapeModel or not cape or not cape.Parent then return end
        if Flying then
            local velocity = root.Velocity.Magnitude
            local sway = math.sin(tick() * 8) * 0.15
            local tilt = math.clamp(velocity / 80, 0, 0.6)
            capeWeld.C0 = baseC0 * CFrame.Angles(math.rad(-12 - tilt * 25), sway, 0)
        else
            local sway = math.sin(tick() * 2) * 0.08
            capeWeld.C0 = baseC0 * CFrame.Angles(math.rad(5), sway, 0)
        end
    end)
end

local function RemoveCape()
    if CapeConn then
        CapeConn:Disconnect()
        CapeConn = nil
    end
    if CapeModel then
        CapeModel:Destroy()
        CapeModel = nil
    end
end

local function StartSupermanFly()
    if Flying then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    Flying = true
    local root = char.HumanoidRootPart
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = true
    end

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Velocity = Vector3.zero
    BodyVelocity.Parent = root

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.P = 3e4
    BodyGyro.D = 1000
    BodyGyro.Parent = root

    -- Tạo áo choàng
    CreateCape(char)

    RunService:BindToRenderStep("ZakaSupermanFly", Enum.RenderPriority.Camera.Value, function()
        if not Flying or not root or not root.Parent then return end

        local cam = Camera.CFrame
        local moveDir = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end

        if moveDir.Magnitude > 0 then
            BodyVelocity.Velocity = moveDir.Unit * Settings.FlySpeed
        else
            BodyVelocity.Velocity = Vector3.zero
        end

        -- Hướng người theo camera (kiểu Superman)
        BodyGyro.CFrame = CFrame.new(root.Position, root.Position + cam.LookVector)
    end)
end

local function StopSupermanFly()
    Flying = false
    pcall(function()
        RunService:UnbindFromRenderStep("ZakaSupermanFly")
    end)

    if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
    if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end

    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end

    RemoveCape()
end

--==============================================================================--
--                              MOVEMENT
--==============================================================================--
local function SetSpeed(state)
    if SpeedConn then
        SpeedConn:Disconnect()
        SpeedConn = nil
    end
    if state then
        SpeedConn = RunService.Heartbeat:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = Settings.SpeedValue
            end
        end)
    else
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
        end
    end
end

local function SetNoclip(state)
    if NoclipConn then
        NoclipConn:Disconnect()
        NoclipConn = nil
    end
    if state then
        NoclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Click TP (hỗ trợ mobile)
UserInputService.TouchTap:Connect(function(positions, processed)
    if Settings.ClickTP and not processed and positions[1] then
        local unitRay = Camera:ViewportPointToRay(positions[1].X, positions[1].Y)
        local ray = Ray.new(unitRay.Origin, unitRay.Direction * 2000)
        local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
        if hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 4, 0))
        end
    end
end)

--==============================================================================--
--                              VISUALS
--==============================================================================--
local function ToggleFullbright(state)
    if state then
        Lighting.Brightness = 2.5
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
    else
        Lighting.Brightness = 1
        Lighting.FogEnd = 1000
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end

--==============================================================================--
--                              UI (PART 1)
--==============================================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaHUD_v2"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Nút mở menu
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "ZakaOpen"
OpenBtn.Size = UDim2.new(0, 48, 0, 48)
OpenBtn.Position = UDim2.new(0, 15, 0.35, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
OpenBtn.Text = "Z"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.TextSize = 22
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 1.5
UIStroke.Parent = OpenBtn

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 340, 0, 420)
Main.Position = UDim2.new(0, 75, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Zaka HUD v2 | Part 1"
Title.TextColor3 = Color3.fromRGB(0, 180, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Drag
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -16, 1, -55)
Content.Position = UDim2.new(0, 8, 0, 50)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Color3.fromRGB(0, 160, 255)
Content.CanvasSize = UDim2.new(0, 0, 0, 500)
Content.Parent = Main

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 8)
ListLayout.Parent = Content

-- Toggle Creator
local function CreateToggle(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    frame.BorderSizePixel = 0
    frame.Parent = Content
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 44, 0, 24)
    btn.Position = UDim2.new(1, -54, 0.5, -12)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(50, 50, 60)
    btn.Text = ""
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.Position = default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.Parent = btn
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local enabled = default
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        local targetColor = enabled and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(50, 50, 60)
        local targetPos = enabled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        callback(enabled)
    end)
end

-- Toggles Part 1
CreateToggle("Superman Fly (Áo Choàng)", false, function(v)
    Settings.Fly = v
    if v then StartSupermanFly() else StopSupermanFly() end
end)

CreateToggle("Speed Hack", false, function(v)
    Settings.Speed = v
    SetSpeed(v)
end)

CreateToggle("Noclip", false, function(v)
    Settings.Noclip = v
    SetNoclip(v)
end)

CreateToggle("Infinite Jump", false, function(v)
    Settings.InfiniteJump = v
end)

CreateToggle("Click Teleport (Mobile)", false, function(v)
    Settings.ClickTP = v
end)

CreateToggle("Fullbright", false, function(v)
    Settings.Fullbright = v
    ToggleFullbright(v)
end)

CreateToggle("Anti AFK", true, function(v)
    Settings.AntiAFK = v
end)

-- Open / Close
OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)
CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

-- Respawn Support
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1.2)
    if Settings.Speed then SetSpeed(true) end
    if Settings.Fly then
        StartSupermanFly()
    end
    if Settings.Noclip then SetNoclip(true) end
end)

print("Zaka HUD v2 - Part 1 Loaded | Superman Fly Ready")
--==============================================================================--
--                    ZAKA HUD ULTIMATE v2 - PART 2
--                    ESP + Aimbot (High Quality)
--==============================================================================--

-- Bổ sung Settings
Settings.Aimbot = false
Settings.AimbotFOV = 130
Settings.AimbotSmooth = 0.16
Settings.AimbotTeamCheck = true
Settings.AimbotWallCheck = true
Settings.SilentAim = false

Settings.ESP = false
Settings.ESPBox = true
Settings.ESPName = true
Settings.ESPHealth = true
Settings.ESPDistance = true
Settings.ESPTracer = false
Settings.ESPMaxDist = 2500
Settings.ESPTeamCheck = false
Settings.ESPSkeleton = false

--==============================================================================--
--                              AIMBOT ENGINE
--==============================================================================--
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = Settings.AimbotFOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(0, 180, 255)
FOVCircle.Transparency = 0.7

local function GetClosestPlayer()
    local closest = nil
    local shortest = Settings.AimbotFOV
    local mousePos = UserInputService:GetMouseLocation()
    local camPos = Camera.CFrame.Position

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            local head = plr.Character:FindFirstChild("Head")
            if humanoid and humanoid.Health > 0 and head then
                if Settings.AimbotTeamCheck and plr.Team and plr.Team == LocalPlayer.Team then
                    continue
                end

                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    if Settings.AimbotWallCheck then
                        local direction = (head.Position - camPos).Unit * 3000
                        local ray = Ray.new(camPos, direction)
                        local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, Camera})
                        if hit and not hit:IsDescendantOf(plr.Character) then
                            continue
                        end
                    end

                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
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

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Visible = Settings.Aimbot

    if Settings.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer()
        if target then
            local goal = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(goal, Settings.AimbotSmooth)
        end
    end
end)

--==============================================================================--
--                              ESP ENGINE
--==============================================================================--
local ESPObjects = {}

local function CreateESP(plr)
    if ESPObjects[plr] then return end

    local drawings = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
    }

    drawings.Box.Thickness = 1.2
    drawings.Box.Filled = false
    drawings.Box.Color = Color3.fromRGB(0, 200, 255)

    drawings.Name.Size = 14
    drawings.Name.Center = true
    drawings.Name.Outline = true
    drawings.Name.Color = Color3.fromRGB(255, 255, 255)
    drawings.Name.OutlineColor = Color3.fromRGB(0, 0, 0)

    drawings.Health.Size = 12
    drawings.Health.Center = true
    drawings.Health.Outline = true

    drawings.Distance.Size = 12
    drawings.Distance.Center = true
    drawings.Distance.Outline = true
    drawings.Distance.Color = Color3.fromRGB(200, 200, 200)

    drawings.Tracer.Thickness = 1.2
    drawings.Tracer.Color = Color3.fromRGB(0, 180, 255)

    ESPObjects[plr] = drawings
end

local function RemoveESP(plr)
    if ESPObjects[plr] then
        for _, d in pairs(ESPObjects[plr]) do
            pcall(function() d:Remove() end)
        end
        ESPObjects[plr] = nil
    end
end

Players.PlayerRemoving:Connect(RemoveESP)

RunService.RenderStepped:Connect(function()
    if not Settings.ESP then
        for _, drawings in pairs(ESPObjects) do
            for _, d in pairs(drawings) do
                d.Visible = false
            end
        end
        return
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end

        if Settings.ESPTeamCheck and plr.Team and plr.Team == LocalPlayer.Team then
            if ESPObjects[plr] then
                for _, d in pairs(ESPObjects[plr]) do d.Visible = false end
            end
            continue
        end

        CreateESP(plr)
        local drawings = ESPObjects[plr]
        local char = plr.Character

        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChildOfClass("Humanoid") then
            for _, d in pairs(drawings) do d.Visible = false end
            continue
        end

        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid.Health <= 0 then
            for _, d in pairs(drawings) do d.Visible = false end
            continue
        end

        local root = char.HumanoidRootPart
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local dist = (root.Position - Camera.CFrame.Position).Magnitude

        if not onScreen or dist > Settings.ESPMaxDist then
            for _, d in pairs(drawings) do d.Visible = false end
            continue
        end

        local scale = math.clamp(1000 / pos.Z, 0.3, 4)
        local size = Vector2.new(35 * scale, 55 * scale)

        -- Box
        drawings.Box.Size = size
        drawings.Box.Position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
        drawings.Box.Visible = Settings.ESPBox

        -- Name
        drawings.Name.Text = plr.DisplayName \~= plr.Name and (plr.DisplayName .. " (@" .. plr.Name .. ")") or plr.Name
        drawings.Name.Position = Vector2.new(pos.X, pos.Y - size.Y / 2 - 16)
        drawings.Name.Visible = Settings.ESPName

        -- Health
        local hpPercent = humanoid.Health / humanoid.MaxHealth
        drawings.Health.Text = math.floor(humanoid.Health) .. " HP"
        drawings.Health.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 2)
        drawings.Health.Color = Color3.fromRGB(255 - (hpPercent * 255), hpPercent * 255, 0)
        drawings.Health.Visible = Settings.ESPHealth

        -- Distance
        drawings.Distance.Text = math.floor(dist) .. "m"
        drawings.Distance.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 16)
        drawings.Distance.Visible = Settings.ESPDistance

        -- Tracer
        drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        drawings.Tracer.To = Vector2.new(pos.X, pos.Y + size.Y / 2)
        drawings.Tracer.Visible = Settings.ESPTracer
    end
end)

--==============================================================================--
--                    THÊM TOGGLE VÀO UI (PART 2)
--==============================================================================--
-- Bạn có thể dán các dòng CreateToggle này vào phần Content của Part 1

CreateToggle("Aimbot", false, function(v)
    Settings.Aimbot = v
end)

CreateToggle("Aimbot Team Check", true, function(v)
    Settings.AimbotTeamCheck = v
end)

CreateToggle("Aimbot Wall Check", true, function(v)
    Settings.AimbotWallCheck = v
end)

CreateToggle("ESP Enabled", false, function(v)
    Settings.ESP = v
end)

CreateToggle("ESP Box", true, function(v)
    Settings.ESPBox = v
end)

CreateToggle("ESP Name", true, function(v)
    Settings.ESPName = v
end)

CreateToggle("ESP Health", true, function(v)
    Settings.ESPHealth = v
end)

CreateToggle("ESP Distance", true, function(v)
    Settings.ESPDistance = v
end)

CreateToggle("ESP Tracer", false, function(v)
    Settings.ESPTracer = v
end)

print("Zaka HUD v2 - Part 2 Loaded | ESP + Aimbot Ready")
--==============================================================================--
--                    ZAKA HUD ULTIMATE v2 - PART 3
--                    Magic Effects (Chi tiết & Đẹp)
--==============================================================================--

-- Bổ sung Settings
Settings.FireAura = false
Settings.IceAura = false
Settings.RainbowTrail = false
Settings.AngelWings = false
Settings.DarkAura = false
Settings.ElectricAura = false

local MagicFolder = nil
local MagicConnections = {}

local function GetMagicFolder(char)
    if MagicFolder and MagicFolder.Parent == char then
        return MagicFolder
    end
    if MagicFolder then MagicFolder:Destroy() end

    MagicFolder = Instance.new("Folder")
    MagicFolder.Name = "ZakaMagicFX"
    MagicFolder.Parent = char
    return MagicFolder
end

local function ClearMagic(name)
    if MagicConnections[name] then
        MagicConnections[name]:Disconnect()
        MagicConnections[name] = nil
    end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("ZakaMagicFX") then
        local obj = char.ZakaMagicFX:FindFirstChild(name)
        if obj then obj:Destroy() end
    end
end

--==================== FIRE AURA ====================--
local function SetFireAura(state)
    Settings.FireAura = state
    ClearMagic("FireAura")

    if not state then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local folder = GetMagicFolder(char)
    local root = char.HumanoidRootPart

    local firePart = Instance.new("Part")
    firePart.Name = "FireAura"
    firePart.Size = Vector3.new(1, 1, 1)
    firePart.Transparency = 1
    firePart.CanCollide = false
    firePart.Massless = true
    firePart.Anchored = true
    firePart.Parent = folder

    local fire = Instance.new("Fire")
    fire.Size = 8
    fire.Heat = 12
    fire.Color = Color3.fromRGB(255, 120, 20)
    fire.SecondaryColor = Color3.fromRGB(255, 40, 0)
    fire.Parent = firePart

    local sparks = Instance.new("ParticleEmitter")
    sparks.Texture = "rbxassetid://243664672"
    sparks.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 0))
    })
    sparks.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.6),
        NumberSequenceKeypoint.new(1, 0)
    })
    sparks.Lifetime = NumberRange.new(0.4, 0.9)
    sparks.Rate = 45
    sparks.Speed = NumberRange.new(3, 8)
    sparks.SpreadAngle = Vector2.new(40, 40)
    sparks.Parent = firePart

    MagicConnections["FireAura"] = RunService.RenderStepped:Connect(function()
        if root and root.Parent then
            firePart.CFrame = root.CFrame
        end
    end)
end

--==================== ICE AURA ====================--
local function SetIceAura(state)
    Settings.IceAura = state
    ClearMagic("IceAura")

    if not state then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local folder = GetMagicFolder(char)
    local root = char.HumanoidRootPart

    local icePart = Instance.new("Part")
    icePart.Name = "IceAura"
    icePart.Size = Vector3.new(6, 0.3, 6)
    icePart.Color = Color3.fromRGB(150, 230, 255)
    icePart.Material = Enum.Material.Ice
    icePart.Transparency = 0.35
    icePart.CanCollide = false
    icePart.Massless = true
    icePart.Anchored = true
    icePart.Parent = folder

    local snow = Instance.new("ParticleEmitter")
    snow.Texture = "rbxassetid://243660364"
    snow.Color = ColorSequence.new(Color3.fromRGB(200, 240, 255))
    snow.Size = NumberSequence.new(0.25, 0.05)
    snow.Lifetime = NumberRange.new(1, 2)
    snow.Rate = 30
    snow.Speed = NumberRange.new(1, 3)
    snow.Parent = icePart

    MagicConnections["IceAura"] = RunService.RenderStepped:Connect(function()
        if root and root.Parent then
            icePart.CFrame = root.CFrame * CFrame.new(0, -2.8, 0) * CFrame.Angles(0, tick() * 1.5, 0)
        end
    end)
end

--==================== RAINBOW TRAIL ====================--
local function SetRainbowTrail(state)
    Settings.RainbowTrail = state
    ClearMagic("RainbowTrail")

    if not state then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local folder = GetMagicFolder(char)
    local root = char.HumanoidRootPart

    local att0 = Instance.new("Attachment")
    att0.Name = "RainbowTrail"
    att0.Position = Vector3.new(0, 0, 0.5)
    att0.Parent = root

    local att1 = Instance.new("Attachment")
    att1.Position = Vector3.new(0, 0, -0.5)
    att1.Parent = root

    local trail = Instance.new("Trail")
    trail.Attachment0 = att0
    trail.Attachment1 = att1
    trail.Lifetime = 0.8
    trail.MinLength = 0.1
    trail.LightEmission = 0.7
    trail.WidthScale = NumberSequence.new(1, 0)
    trail.Parent = root

    MagicConnections["RainbowTrail"] = RunService.RenderStepped:Connect(function()
        if trail and trail.Parent then
            local hue = tick() % 5 / 5
            trail.Color = ColorSequence.new(Color3.fromHSV(hue, 1, 1))
        end
    end)
end

--==================== ANGEL WINGS ====================--
local function SetAngelWings(state)
    Settings.AngelWings = state
    ClearMagic("AngelWings")

    if not state then return end
    local char = LocalPlayer.Character
    if not char then return end

    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not torso then return end

    local folder = GetMagicFolder(char)

    local function CreateWing(side)
        local wing = Instance.new("Part")
        wing.Name = "AngelWings"
        wing.Size = Vector3.new(0.3, 2.8, 1.8)
        wing.Color = Color3.fromRGB(255, 255, 255)
        wing.Material = Enum.Material.SmoothPlastic
        wing.CanCollide = false
        wing.Massless = true
        wing.Transparency = 0.15
        wing.Parent = folder

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://94095775" -- wing-like shape fallback
        mesh.Scale = Vector3.new(1.2, 1.2, 1.2)
        mesh.Parent = wing

        local weld = Instance.new("Weld")
        weld.Part0 = torso
        weld.Part1 = wing
        if side == "Left" then
            weld.C0 = CFrame.new(-1.1, 0.4, 0.6) * CFrame.Angles(0, math.rad(20), math.rad(15))
        else
            weld.C0 = CFrame.new(1.1, 0.4, 0.6) * CFrame.Angles(0, math.rad(-20), math.rad(-15))
        end
        weld.Parent = wing

        local glow = Instance.new("ParticleEmitter")
        glow.Texture = "rbxassetid://241837157"
        glow.Color = ColorSequence.new(Color3.fromRGB(255, 255, 220))
        glow.Size = NumberSequence.new(0.3, 0)
        glow.Lifetime = NumberRange.new(0.5, 1)
        glow.Rate = 15
        glow.Parent = wing

        return wing, weld
    end

    local leftWing, leftWeld = CreateWing("Left")
    local rightWing, rightWeld = CreateWing("Right")

    local baseLeft = leftWeld.C0
    local baseRight = rightWeld.C0

    MagicConnections["AngelWings"] = RunService.RenderStepped:Connect(function()
        local t = tick() * 6
        local flap = math.sin(t) * 0.25
        leftWeld.C0 = baseLeft * CFrame.Angles(flap, 0, 0)
        rightWeld.C0 = baseRight * CFrame.Angles(flap, 0, 0)
    end)
end

--==================== DARK AURA ====================--
local function SetDarkAura(state)
    Settings.DarkAura = state
    ClearMagic("DarkAura")

    if not state then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local folder = GetMagicFolder(char)
    local root = char.HumanoidRootPart

    local darkPart = Instance.new("Part")
    darkPart.Name = "DarkAura"
    darkPart.Size = Vector3.new(1, 1, 1)
    darkPart.Transparency = 1
    darkPart.CanCollide = false
    darkPart.Anchored = true
    darkPart.Parent = folder

    local smoke = Instance.new("ParticleEmitter")
    smoke.Texture = "rbxassetid://243660364"
    smoke.Color = ColorSequence.new(Color3.fromRGB(30, 0, 50), Color3.fromRGB(10, 0, 20))
    smoke.Size = NumberSequence.new(1.2, 0)
    smoke.Lifetime = NumberRange.new(0.8, 1.5)
    smoke.Rate = 40
    smoke.Speed = NumberRange.new(2, 5)
    smoke.Parent = darkPart

    MagicConnections["DarkAura"] = RunService.RenderStepped:Connect(function()
        if root and root.Parent then
            darkPart.CFrame = root.CFrame
        end
    end)
end

--==================== ELECTRIC AURA ====================--
local function SetElectricAura(state)
    Settings.ElectricAura = state
    ClearMagic("ElectricAura")

    if not state then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local folder = GetMagicFolder(char)
    local root = char.HumanoidRootPart

    local elecPart = Instance.new("Part")
    elecPart.Name = "ElectricAura"
    elecPart.Size = Vector3.new(1, 1, 1)
    elecPart.Transparency = 1
    elecPart.CanCollide = false
    elecPart.Anchored = true
    elecPart.Parent = folder

    local sparks = Instance.new("ParticleEmitter")
    sparks.Texture = "rbxassetid://243664672"
    sparks.Color = ColorSequence.new(Color3.fromRGB(100, 180, 255), Color3.fromRGB(200, 240, 255))
    sparks.Size = NumberSequence.new(0.4, 0)
    sparks.Lifetime = NumberRange.new(0.15, 0.35)
    sparks.Rate = 60
    sparks.Speed = NumberRange.new(6, 14)
    sparks.SpreadAngle = Vector2.new(180, 180)
    sparks.Parent = elecPart

    MagicConnections["ElectricAura"] = RunService.RenderStepped:Connect(function()
        if root and root.Parent then
            elecPart.CFrame = root.CFrame
        end
    end)
end

--==============================================================================--
--                    THÊM TOGGLE MAGIC VÀO UI
--==============================================================================--
CreateToggle("Fire Aura (Lửa)", false, function(v) SetFireAura(v) end)
CreateToggle("Ice Aura (Băng)", false, function(v) SetIceAura(v) end)
CreateToggle("Rainbow Trail", false, function(v) SetRainbowTrail(v) end)
CreateToggle("Angel Wings (Cánh Thiên Thần)", false, function(v) SetAngelWings(v) end)
CreateToggle("Dark Aura (Bóng Tối)", false, function(v) SetDarkAura(v) end)
CreateToggle("Electric Aura (Điện)", false, function(v) SetElectricAura(v) end)

-- Xóa toàn bộ hiệu ứng
local function ClearAllMagic()
    for name, conn in pairs(MagicConnections) do
        if conn then conn:Disconnect() end
        MagicConnections[name] = nil
    end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("ZakaMagicFX") then
        char.ZakaMagicFX:Destroy()
    end
    MagicFolder = nil
end

-- Thêm nút xóa hiệu ứng (nếu muốn)
-- CreateToggle hoặc nút riêng để gọi ClearAllMagic()

print("Zaka HUD v2 - Part 3 Loaded | Magic Effects Ready")
--==============================================================================--
--                    ZAKA HUD ULTIMATE v2 - PART 5
--                    Hitbox + Triggerbot + Utility
--==============================================================================--

-- Bổ sung Settings
Settings.HitboxExpander = false
Settings.HitboxSize = 12
Settings.TriggerBot = false
Settings.TriggerDelay = 0.03
Settings.AutoClicker = false
Settings.ClickDelay = 0.05
Settings.NoClipVehicles = false
Settings.InfiniteJumpPower = false

local HitboxConn = nil
local TriggerConn = nil
local AutoClickConn = nil
local OriginalSizes = {}

--==============================================================================--
--                              HITBOX EXPANDER
--==============================================================================--
local function SetHitboxExpander(state)
    Settings.HitboxExpander = state

    if HitboxConn then
        HitboxConn:Disconnect()
        HitboxConn = nil
    end

    -- Khôi phục kích thước cũ
    for plr, data in pairs(OriginalSizes) do
        if plr.Character then
            for partName, size in pairs(data) do
                local part = plr.Character:FindFirstChild(partName)
                if part and part:IsA("BasePart") then
                    part.Size = size
                    part.Transparency = 0
                    part.CanCollide = true
                end
            end
        end
    end
    OriginalSizes = {}

    if state then
        HitboxConn = RunService.Heartbeat:Connect(function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr \~= LocalPlayer and plr.Character then
                    local char = plr.Character
                    if not OriginalSizes[plr] then
                        OriginalSizes[plr] = {}
                    end

                    for _, part in ipairs(char:GetChildren()) do
                        if part:IsA("BasePart") and (part.Name == "Head" or part.Name == "HumanoidRootPart" or part.Name == "UpperTorso" or part.Name == "Torso") then
                            if not OriginalSizes[plr][part.Name] then
                                OriginalSizes[plr][part.Name] = part.Size
                            end
                            part.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                            part.Transparency = 0.6
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    end
end

Players.PlayerRemoving:Connect(function(plr)
    OriginalSizes[plr] = nil
end)

--==============================================================================--
--                              TRIGGER BOT
--==============================================================================--
local function SetTriggerBot(state)
    Settings.TriggerBot = state
    if TriggerConn then
        TriggerConn:Disconnect()
        TriggerConn = nil
    end

    if state then
        TriggerConn = RunService.RenderStepped:Connect(function()
            if not Settings.TriggerBot then return end

            local mousePos = UserInputService:GetMouseLocation()
            local ray = Camera:ViewportPointToRay(mousePos.X, mousePos.Y)
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}

            local result = workspace:Raycast(ray.Origin, ray.Direction * 500, raycastParams)
            if result and result.Instance then
                local model = result.Instance:FindFirstAncestorOfClass("Model")
                if model then
                    local plr = Players:GetPlayerFromCharacter(model)
                    if plr and plr \~= LocalPlayer then
                        local humanoid = model:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            VirtualUser:Button1Down(Vector2.new())
                            task.wait(Settings.TriggerDelay)
                            VirtualUser:Button1Up(Vector2.new())
                        end
                    end
                end
            end
        end)
    end
end

--==============================================================================--
--                              AUTO CLICKER
--==============================================================================--
local function SetAutoClicker(state)
    Settings.AutoClicker = state
    if AutoClickConn then
        AutoClickConn:Disconnect()
        AutoClickConn = nil
    end

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

--==============================================================================--
--                              UTILITY FUNCTIONS
--==============================================================================--
local function ServerHop()
    pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local data = HttpService:JSONDecode(game:HttpGet(url)).data
        for _, server in ipairs(data) do
            if server.id \~= game.JobId and server.playing < server.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                break
            end
        end
    end)
end

local function Rejoin()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end

local function ForceReset()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end
end

local function RemoveAllTools()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then tool:Destroy() end
        end
    end
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then tool:Destroy() end
        end
    end
end

--==============================================================================--
--                    THÊM VÀO UI
--==============================================================================--
CreateToggle("Hitbox Expander", false, function(v) SetHitboxExpander(v) end)
CreateToggle("Trigger Bot", false, function(v) SetTriggerBot(v) end)
CreateToggle("Auto Clicker", false, function(v) SetAutoClicker(v) end)

-- Buttons
local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(230, 230, 240)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.Parent = Content
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
end

CreateButton("Server Hop", ServerHop)
CreateButton("Rejoin Server", Rejoin)
CreateButton("Force Reset Character", ForceReset)
CreateButton("Remove All Tools", RemoveAllTools)

print("Zaka HUD v2 - Part 5 Loaded | Hitbox + Triggerbot + Utility Ready")
--==============================================================================--
--                    ZAKA HUD ULTIMATE v2 - PART 6 (BIG UPDATE)
--                    Nhiều chức năng hay + Hiệu ứng nâng cao
--==============================================================================--

--==================== SETTINGS BỔ SUNG ====================--
Settings.GodMode = false
Settings.InfiniteStamina = false
Settings.NoRagdoll = false
Settings.AutoSprint = false
Settings.ZoomFOV = false
Settings.CustomFOVValue = 100
Settings.BunnyHop = false
Settings.OrbitPlayers = false
Settings.OrbitSpeed = 4
Settings.OrbitDistance = 12
Settings.FreezePlayer = false
Settings.ESPHighlight = false
Settings.NameTagBig = false
Settings.TrailColorChange = false
Settings.BodyColorRainbow = false
Settings.HeadLight = false
Settings.NoJumpCooldown = false

local GodConn, OrbitConn, RainbowConn, HeadLightConn
local OrbitAngle = 0

--==============================================================================--
--                              GOD MODE (Client)
--==============================================================================--
local function SetGodMode(state)
    Settings.GodMode = state
    if GodConn then GodConn:Disconnect() GodConn = nil end

    if state then
        GodConn = RunService.Heartbeat:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
            end
        end)
    else
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.MaxHealth = 100
            hum.Health = 100
        end
    end
end

--==============================================================================--
--                              NO RAGDOLL
--==============================================================================--
local function SetNoRagdoll(state)
    Settings.NoRagdoll = state
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, not state)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not state)
        end
    end
end

--==============================================================================--
--                              BUNNY HOP
--==============================================================================--
UserInputService.JumpRequest:Connect(function()
    if Settings.BunnyHop then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum:GetState() \~= Enum.HumanoidStateType.Jumping then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

--==============================================================================--
--                              ORBIT PLAYERS
--==============================================================================--
local function SetOrbitPlayers(state)
    Settings.OrbitPlayers = state
    if OrbitConn then OrbitConn:Disconnect() OrbitConn = nil end

    if state then
        OrbitConn = RunService.RenderStepped:Connect(function()
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end

            local target = nil
            local shortest = 9999
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (plr.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
                    if dist < shortest then
                        shortest = dist
                        target = plr.Character.HumanoidRootPart
                    end
                end
            end

            if target then
                OrbitAngle = OrbitAngle + Settings.OrbitSpeed * 0.05
                local offset = Vector3.new(
                    math.cos(OrbitAngle) * Settings.OrbitDistance,
                    2,
                    math.sin(OrbitAngle) * Settings.OrbitDistance
                )
                myRoot.CFrame = CFrame.new(target.Position + offset, target.Position)
            end
        end)
    end
end

--==============================================================================--
--                              RAINBOW BODY
--==============================================================================--
local function SetBodyRainbow(state)
    Settings.BodyColorRainbow = state
    if RainbowConn then RainbowConn:Disconnect() RainbowConn = nil end

    if state then
        RainbowConn = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hue = tick() % 5 / 5
            local color = Color3.fromHSV(hue, 1, 1)
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name \~= "HumanoidRootPart" then
                    part.Color = color
                end
            end
        end)
    end
end

--==============================================================================--
--                              HEAD LIGHT
--==============================================================================--
local function SetHeadLight(state)
    Settings.HeadLight = state
    local char = LocalPlayer.Character
    if not char then return end

    local head = char:FindFirstChild("Head")
    if not head then return end

    local oldLight = head:FindFirstChild("ZakaHeadLight")
    if oldLight then oldLight:Destroy() end

    if state then
        local light = Instance.new("PointLight")
        light.Name = "ZakaHeadLight"
        light.Brightness = 3
        light.Range = 20
        light.Color = Color3.fromRGB(255, 255, 220)
        light.Parent = head
    end
end

--==============================================================================--
--                              CUSTOM FOV
--==============================================================================--
local function SetCustomFOV(state)
    Settings.ZoomFOV = state
    if state then
        Camera.FieldOfView = Settings.CustomFOVValue
    else
        Camera.FieldOfView = 70
    end
end

--==============================================================================--
--                              HIGHLIGHT ESP (Mobile Friendly)
--==============================================================================--
local HighlightObjects = {}

local function SetHighlightESP(state)
    Settings.ESPHighlight = state

    -- Xóa highlight cũ
    for plr, hl in pairs(HighlightObjects) do
        if hl then hl:Destroy() end
    end
    HighlightObjects = {}

    if state then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr \~= LocalPlayer and plr.Character then
                local hl = Instance.new("Highlight")
                hl.Name = "ZakaHighlight"
                hl.FillColor = Color3.fromRGB(0, 180, 255)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.6
                hl.OutlineTransparency = 0
                hl.Adornee = plr.Character
                hl.Parent = plr.Character
                HighlightObjects[plr] = hl
            end
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    if Settings.ESPHighlight then
        plr.CharacterAdded:Connect(function(char)
            task.wait(1)
            local hl = Instance.new("Highlight")
            hl.FillColor = Color3.fromRGB(0, 180, 255)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.6
            hl.Adornee = char
            hl.Parent = char
            HighlightObjects[plr] = hl
        end)
    end
end)

--==============================================================================--
--                              UTILITY NÂNG CAO
--==============================================================================--
local function BringAllTools()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local char = LocalPlayer.Character
    if backpack and char then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = char
            end
        end
    end
end

local function DropAllTools()
    local char = LocalPlayer.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = workspace
            end
        end
    end
end

local function Sit()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Sit = true end
end

local function UnSit()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Sit = false end
end

local function FullHeal()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Health = hum.MaxHealth
    end
end

--==============================================================================--
--                    THÊM TOGGLE + BUTTON VÀO UI
--==============================================================================--
CreateToggle("God Mode (Client)", false, function(v) SetGodMode(v) end)
CreateToggle("No Ragdoll", false, function(v) SetNoRagdoll(v) end)
CreateToggle("Bunny Hop", false, function(v) Settings.BunnyHop = v end)
CreateToggle("Orbit Closest Player", false, function(v) SetOrbitPlayers(v) end)
CreateToggle("Rainbow Body", false, function(v) SetBodyRainbow(v) end)
CreateToggle("Head Light", false, function(v) SetHeadLight(v) end)
CreateToggle("Custom FOV", false, function(v) SetCustomFOV(v) end)
CreateToggle("Highlight ESP (Mobile)", false, function(v) SetHighlightESP(v) end)

CreateButton("Bring All Tools", BringAllTools)
CreateButton("Drop All Tools", DropAllTools)
CreateButton("Sit", Sit)
CreateButton("Unsit", UnSit)
CreateButton("Full Heal", FullHeal)

-- Xóa toàn bộ hiệu ứng magic (từ Part 3)
CreateButton("Clear All Magic Effects", function()
    if ClearAllMagic then ClearAllMagic() end
end)

print("Zaka HUD v2 - Part 6 Loaded | Big Update Ready")
