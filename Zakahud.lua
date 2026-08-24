--[[
    ╔═════════════════════════════════════════════════════════════════════════════════════════════════════╗
    ║                                   ZAKA HUD ULTIMATE V2.0 - SINGLE EDITION                           ║
    ║                                                                                                     ║
    ║   [ALL-IN-ONE CONSOLIDATED SCRIPT]                                                                  ║
    ║   CORE FRAMEWORK + AIMBOT + ESP MATRIX + ADVANCED PHYSICS + ULTRA DRAGON + RAINBOW WINGS + GUI      ║
    ╚═════════════════════════════════════════════════════════════════════════════════════════════════════╝
]]

--==============================================================================--
--                           1. SERVICES & ENGINE SETUP                         --
--==============================================================================--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--==============================================================================--
--                           2. SYSTEM CONFIGURATION                            --
--==============================================================================--
local ZakaConfig = {
    Combat = {
        AimbotEnabled = false,
        AimbotKey = Enum.UserInputType.MouseButton2,
        AimbotFOV = 150,
        AimbotSmoothness = 0.15,
        AimbotTargetPart = "Head",
        ShowFOVCircle = false,
        FOVCircleColor = Color3.fromRGB(0, 255, 230),
    },
    ESP = {
        Enabled = false,
        Boxes = true,
        BoxColor = Color3.fromRGB(0, 255, 120),
        Names = true,
        NameColor = Color3.fromRGB(255, 255, 255),
        Tracers = false,
        TracerColor = Color3.fromRGB(0, 162, 255),
        MaxDistance = 3000,
    },
    Movement = {
        SpeedHack = false,
        WalkSpeed = 32,
        FlyHack = false,
        FlySpeed = 50,
        Noclip = false,
        SpinBot = false,
        SpinSpeed = 30,
    },
    Magic = {
        UltraFireDragon = false,
        RainbowFeatherWings = false,
    }
}

--==============================================================================--
--                           3. NOTIFICATION SYSTEM                             --
--==============================================================================--
local function Notify(title, text, duration)
    duration = duration or 2.5
    local screenGui = CoreGui:FindFirstChild("ZakaNotifyGui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "ZakaNotifyGui"
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = CoreGui
    end

    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 260, 0, 60)
    notifFrame.Position = UDim2.new(1, 20, 1, -80)
    notifFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notifFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 50, 50)
    stroke.Thickness = 2
    stroke.Parent = notifFrame

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 0, 22)
    titleLbl.Position = UDim2.new(0, 10, 0, 4)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = notifFrame

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -20, 0, 30)
    descLbl.Position = UDim2.new(0, 10, 0, 24)
    descLbl.BackgroundTransparency = 1
    descLbl.Font = Enum.Font.Gotham
    descLbl.Text = text
    descLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    descLbl.TextSize = 11
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextWrapped = true
    descLbl.Parent = notifFrame

    notifFrame:TweenPosition(UDim2.new(1, -280, 1, -80), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)

    task.delay(duration, function()
        if notifFrame and notifFrame.Parent then
            notifFrame:TweenPosition(UDim2.new(1, 20, 1, -80), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
            task.wait(0.3)
            notifFrame:Destroy()
        end
    end)
end

--==============================================================================--
--                           4. AIMBOT & FOV SYSTEM                             --
--==============================================================================--
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Transparent = 1

local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = ZakaConfig.Combat.AimbotFOV
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local part = char:FindFirstChild(ZakaConfig.Combat.AimbotTargetPart)

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

RunService.RenderStepped:Connect(function()
    if ZakaConfig.Combat.ShowFOVCircle and ZakaConfig.Combat.AimbotEnabled then
        FOVCircle.Visible = true
        FOVCircle.Radius = ZakaConfig.Combat.AimbotFOV
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Color = ZakaConfig.Combat.FOVCircleColor
    else
        FOVCircle.Visible = false
    end

    if ZakaConfig.Combat.AimbotEnabled and UserInputService:IsMouseButtonPressed(ZakaConfig.Combat.AimbotKey) then
        local target = GetClosestPlayer()
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
--                           5. ESP ENGINE                                      --
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
    name.Size = 13
    name.Center = true
    name.Outline = true
    name.Visible = false

    ESPStorage[player] = { Box = box, Tracer = tracer, Name = name }
end

local function RemoveESPContainer(player)
    if ESPStorage[player] then
        for _, obj in pairs(ESPStorage[player]) do obj:Remove() end
        ESPStorage[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESPContainer(p) end end
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

                        if ZakaConfig.ESP.Boxes then
                            esp.Box.Size = Vector2.new(width, height)
                            esp.Box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
                            esp.Box.Color = ZakaConfig.ESP.BoxColor
                            esp.Box.Visible = true
                        else esp.Box.Visible = false end

                        if ZakaConfig.ESP.Names then
                            esp.Name.Text = string.format("%s [%dm]", plr.Name, math.floor(dist))
                            esp.Name.Position = Vector2.new(pos.X, pos.Y - height / 2 - 15)
                            esp.Name.Color = ZakaConfig.ESP.NameColor
                            esp.Name.Visible = true
                        else esp.Name.Visible = false end

                        if ZakaConfig.ESP.Tracers then
                            esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            esp.Tracer.To = Vector2.new(pos.X, pos.Y)
                            esp.Tracer.Color = ZakaConfig.ESP.TracerColor
                            esp.Tracer.Visible = true
                        else esp.Tracer.Visible = false end
                    else
                        esp.Box.Visible = false; esp.Tracer.Visible = false; esp.Name.Visible = false
                    end
                else
                    esp.Box.Visible = false; esp.Tracer.Visible = false; esp.Name.Visible = false
                end
            else
                esp.Box.Visible = false; esp.Tracer.Visible = false; esp.Name.Visible = false
            end
        else
            esp.Box.Visible = false; esp.Tracer.Visible = false; esp.Name.Visible = false
        end
    end
end)

--==============================================================================--
--                           6. MOVEMENT ENGINE                                 --
--==============================================================================--
local BodyGyro, BodyVelocity
local FlyConnection, NoclipConnection

local function ToggleFly(state)
    ZakaConfig.Movement.FlyHack = state
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    if state then
        BodyGyro = Instance.new("BodyGyro", root)
        BodyGyro.P = 9e4
        BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.cframe = root.CFrame

        BodyVelocity = Instance.new("BodyVelocity", root)
        BodyVelocity.velocity = Vector3.new(0, 0, 0)
        BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)

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
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end
end

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if hum and ZakaConfig.Movement.SpeedHack then hum.WalkSpeed = ZakaConfig.Movement.WalkSpeed end
        if root and ZakaConfig.Movement.SpinBot then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(ZakaConfig.Movement.SpinSpeed), 0) end
    end
end)

--==============================================================================--
--                           7. ULTRA DRAGON & ANGEL WINGS                       --
--==============================================================================--
local DragonRenderConnection = nil
local AngelRenderConnection = nil

local function ToggleUltraFireDragon(state)
    ZakaConfig.Magic.UltraFireDragon = state
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    if state then
        if char:FindFirstChild("ZakaUltraDragonModel") then char.ZakaUltraDragonModel:Destroy() end
        local DragonFolder = Instance.new("Folder", char)
        DragonFolder.Name = "ZakaUltraDragonModel"

        local function makePart(name, size, color, mat)
            local p = Instance.new("Part", DragonFolder)
            p.Name = name; p.Size = size; p.Color = color or Color3.fromRGB(160, 10, 10)
            p.Material = mat or Enum.Material.Neon; p.CanCollide = false; p.Massless = true
            return p
        end

        local function weld(p0, p1, c0)
            local w = Instance.new("Weld", p1)
            w.Part0 = p0; w.Part1 = p1; w.C0 = c0 or CFrame.new()
            return w
        end

        local body = makePart("DragonBody", Vector3.new(5, 4.5, 10), Color3.fromRGB(140, 0, 0), Enum.Material.Granite)
        weld(root, body, CFrame.new(0, -4.5, 0))

        local head = makePart("DragonHead", Vector3.new(3.8, 3.2, 5.5), Color3.fromRGB(200, 30, 0), Enum.Material.Granite)
        weld(body, head, CFrame.new(0, 2.8, -6.5))

        local jaw = makePart("Jaw", Vector3.new(3, 1.2, 3), Color3.fromRGB(120, 0, 0), Enum.Material.Granite)
        local jawWeld = weld(head, jaw, CFrame.new(0, -1.8, -1.5) * CFrame.Angles(math.rad(15), 0, 0))

        local fire = Instance.new("ParticleEmitter", head)
        fire.Texture = "rbxassetid://241837157"
        fire.Color = ColorSequence.new(Color3.fromRGB(255, 100, 0), Color3.fromRGB(255, 255, 0))
        fire.Size = NumberSequence.new(1.5, 6)
        fire.Rate = 60; fire.Speed = NumberRange.new(30, 50)

        local tail = makePart("Tail", Vector3.new(2.5, 2.5, 8), Color3.fromRGB(120, 0, 0), Enum.Material.Granite)
        local tailWeld = weld(body, tail, CFrame.new(0, -0.5, 7))

        local wingL = makePart("WingL", Vector3.new(12, 0.3, 7), Color3.fromRGB(255, 50, 0))
        local wingLWeld = weld(body, wingL, CFrame.new(-6, 2, 0))

        local wingR = makePart("WingR", Vector3.new(12, 0.3, 7), Color3.fromRGB(255, 50, 0))
        local wingRWeld = weld(body, wingR, CFrame.new(6, 2, 0))

        DragonRenderConnection = RunService.RenderStepped:Connect(function()
            if not ZakaConfig.Magic.UltraFireDragon or not char or not char:FindFirstChild("Humanoid") then
                ToggleUltraFireDragon(false)
                return
            end
            local t = tick() * 5
            jawWeld.C0 = CFrame.new(0, -1.8, -1.5) * CFrame.Angles(math.rad(15 + math.sin(t*2)*10), 0, 0)
            tailWeld.C0 = CFrame.new(math.sin(-t)*1.2, -0.5, 7) * CFrame.Angles(0, math.sin(-t)*0.3, 0)
            local flap = math.sin(t*1.5)*25
            wingLWeld.C0 = CFrame.new(-6, 2, 0) * CFrame.Angles(0, 0, math.rad(flap))
            wingRWeld.C0 = CFrame.new(6, 2, 0) * CFrame.Angles(0, 0, math.rad(-flap))
        end)
    else
        if char:FindFirstChild("ZakaUltraDragonModel") then char.ZakaUltraDragonModel:Destroy() end
        if DragonRenderConnection then DragonRenderConnection:Disconnect() end
    end
end

local function ToggleRainbowAngel(state)
    ZakaConfig.Magic.RainbowFeatherWings = state
    local char = LocalPlayer.Character
    if not char then return end

    if state then
        if char:FindFirstChild("ZakaAngelModel") then char.ZakaAngelModel:Destroy() end
        local AngelFolder = Instance.new("Folder", char)
        AngelFolder.Name = "ZakaAngelModel"

        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        if not torso then return end

        local shield = Instance.new("Part", AngelFolder)
        shield.Size = Vector3.new(10, 10, 10)
        shield.Shape = Enum.PartType.Ball
        shield.Material = Enum.Material.ForceField
        shield.CanCollide = false; shield.Massless = true
        local shieldWeld = Instance.new("Weld", shield)
        shieldWeld.Part0 = torso; shieldWeld.Part1 = shield

        local hue = 0
        AngelRenderConnection = RunService.RenderStepped:Connect(function()
            if not ZakaConfig.Magic.RainbowFeatherWings or not char or not char:FindFirstChild("ZakaAngelModel") then
                ToggleRainbowAngel(false)
                return
            end
            hue = (hue + 0.005) % 1
            shield.Color = Color3.fromHSV(hue, 0.9, 1)
        end)
    else
        if char:FindFirstChild("ZakaAngelModel") then char.ZakaAngelModel:Destroy() end
        if AngelRenderConnection then AngelRenderConnection:Disconnect() end
    end
end

--==============================================================================--
--                           8. CYBERPUNK USER INTERFACE                        --
--==============================================================================--
if CoreGui:FindFirstChild("ZakaHUD_UltimateV2") then CoreGui.ZakaHUD_UltimateV2:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ZakaHUD_UltimateV2"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 380)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(255, 40, 40)
MainStroke.Thickness = 2

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)

local TopBarCorner = Instance.new("UICorner", TopBar)
TopBarCorner.CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "⚡ ZAKA HUD ULTIMATE V2.0 - SINGLE RUNNER"
TitleLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13
local CloseCorner = Instance.new("UICorner", CloseBtn)
CloseCorner.CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -16, 1, -50)
Container.Position = UDim2.new(0, 8, 0, 45)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 480)
Container.ScrollBarThickness = 5

local UIList = Instance.new("UIListLayout", Container)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)

local function CreateToggle(name, categoryKey, configKey, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)

    local ind = Instance.new("Frame", btn)
    ind.Size = UDim2.new(0, 16, 0, 16)
    ind.Position = UDim2.new(1, -26, 0.5, -8)
    ind.BackgroundColor3 = ZakaConfig[categoryKey][configKey] and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 40, 40)
    local indCorner = Instance.new("UICorner", ind)
    indCorner.CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        local state = not ZakaConfig[categoryKey][configKey]
        ZakaConfig[categoryKey][configKey] = state
        ind.BackgroundColor3 = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 40, 40)
        if callback then callback(state) end
        Notify("ZAKA HUD", name .. ": " .. (state and "BẬT 🟢" or "TẮT 🔴"))
    end)
end

-- Tạo danh sách tính năng
CreateToggle("Fly Hack (Bay tự do)", "Movement", "FlyHack", ToggleFly)
CreateToggle("Noclip (Xuyên tường)", "Movement", "Noclip", ToggleNoclip)
CreateToggle("Speed Hack (Tốc độ chạy)", "Movement", "SpeedHack")
CreateToggle("Spinbot (Xoay nhanh)", "Movement", "SpinBot")
CreateToggle("Ultra Fire Dragon Mount (Cưỡi Rồng Phun Lửa)", "Magic", "UltraFireDragon", ToggleUltraFireDragon)
CreateToggle("Rainbow Angel Shield (Giáp Thiên Thần 7 Màu)", "Magic", "RainbowFeatherWings", ToggleRainbowAngel)
CreateToggle("Aimbot Lock (Khóa mục tiêu)", "Combat", "AimbotEnabled")
CreateToggle("Aimbot Show FOV Circle (Vòng FOV)", "Combat", "ShowFOVCircle")
CreateToggle("ESP Wallhack (Xuyên tường Player)", "ESP", "Enabled")

-- Initial Notify
Notify("ZAKA HUD V2.0", "Đã khởi chạy bản gộp ổn định!", 3.5)
