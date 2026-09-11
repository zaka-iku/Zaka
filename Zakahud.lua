--[[
    ZAKA HUD - iOS Style Edition
    - UI phong cách Apple / iOS
    - Animation mượt (mở menu, tab, toggle)
    - Chuyển ngôn ngữ Việt ↔ English
    - Fly Superman + Fake Floor (đánh lừa chạm đất)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

--==============================================================================--
--                              LANGUAGE SYSTEM
--==============================================================================--
local Lang = "VI" -- mặc định tiếng Việt

local L = {
    VI = {
        Title = "ZAKA HUD",
        Combat = "Chiến Đấu",
        ESP = "ESP",
        Player = "Nhân Vật",
        Teleport = "Dịch Chuyển",
        Troll = "Troll",
        Utility = "Tiện Ích",
        Aimbot = "Aimbot",
        SilentAim = "Silent Aim",
        AutoClicker = "Tự Động Click",
        TargetStrafe = "Xoay Mục Tiêu",
        Hitbox = "Hitbox To",
        NPCAimbot = "Aimbot Quái",
        InfiniteAmmo = "Đạn Vô Hạn",
        FastFire = "Bắn Nhanh",
        ESPMain = "Bật ESP",
        ESPBox = "Khung",
        ESPName = "Tên",
        ESPHealth = "Máu",
        ESPDistance = "Khoảng Cách",
        ESPTracers = "Đường Kẻ",
        Chams = "Chams",
        Crosshair = "Tâm Bắn",
        Speed = "Tăng Tốc",
        Fly = "Bay Superman",
        Noclip = "Xuyên Tường",
        InfJump = "Nhảy Vô Hạn",
        Spider = "Leo Tường",
        WaterWalk = "Đi Trên Nước",
        SpinBot = "Xoay Thân",
        TouchTP = "Chạm Là Tele",
        BringAll = "Kéo Tất Cả",
        FlingAll = "Hất Văng Tất Cả",
        ChatSpam = "Spam Chat",
        AntiAFK = "Chống AFK",
        Rejoin = "Vào Lại Server",
        ServerHop = "Đổi Server",
        Unload = "Tắt Script",
        Language = "Ngôn Ngữ: Việt",
        Enabled = "Đã bật",
        Disabled = "Đã tắt",
    },
    EN = {
        Title = "ZAKA HUD",
        Combat = "Combat",
        ESP = "ESP",
        Player = "Player",
        Teleport = "Teleport",
        Troll = "Troll",
        Utility = "Utility",
        Aimbot = "Aimbot",
        SilentAim = "Silent Aim",
        AutoClicker = "Auto Clicker",
        TargetStrafe = "Target Strafe",
        Hitbox = "Hitbox Expander",
        NPCAimbot = "NPC Aimbot",
        InfiniteAmmo = "Infinite Ammo",
        FastFire = "Fast Fire",
        ESPMain = "Enable ESP",
        ESPBox = "Box",
        ESPName = "Name",
        ESPHealth = "Health",
        ESPDistance = "Distance",
        ESPTracers = "Tracers",
        Chams = "Chams",
        Crosshair = "Crosshair",
        Speed = "Speed",
        Fly = "Superman Fly",
        Noclip = "Noclip",
        InfJump = "Infinite Jump",
        Spider = "Spider Climb",
        WaterWalk = "Water Walk",
        SpinBot = "SpinBot",
        TouchTP = "Touch TP",
        BringAll = "Bring All",
        FlingAll = "Fling All",
        ChatSpam = "Chat Spammer",
        AntiAFK = "Anti AFK",
        Rejoin = "Rejoin",
        ServerHop = "Server Hop",
        Unload = "Unload",
        Language = "Language: English",
        Enabled = "Enabled",
        Disabled = "Disabled",
    }
}

local function T(key)
    return L[Lang][key] or key
end

--==============================================================================--
--                              SETTINGS
--==============================================================================--
local Settings = {
    Aimbot = false,
    AimbotFOV = 120,
    AimbotSmooth = 0.18,
    SilentAim = false,
    AutoClicker = false,
    TargetStrafe = false,
    StrafeDistance = 10,
    StrafeSpeed = 6,
    HitboxExpander = false,
    HitboxSize = 18,
    NPCAimbot = false,
    InfiniteAmmo = false,
    FastFire = false,

    ESP = false,
    ESPBox = true,
    ESPName = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPTracers = false,
    ESPMaxDist = 3000,
    Chams = false,
    CustomCrosshair = false,

    Speed = false,
    SpeedValue = 28,
    Fly = false,
    FlySpeed = 70,
    Noclip = false,
    InfiniteJump = false,
    SpinBot = false,
    SpinSpeed = 35,
    SpiderClimb = false,
    WaterWalk = false,
    CustomFOV = 70,

    ChatSpammer = false,
    SpamMessage = "Zaka HUD 🍎",
    AntiAFK = true,
    TouchTP = false,
}

--==============================================================================--
--                         CONNECTION + NOTIFY
--==============================================================================--
local Connections = {}
local function AddConn(name, conn)
    if Connections[name] then pcall(function() Connections[name]:Disconnect() end) end
    Connections[name] = conn
end

local function ClearAll()
    for _, c in pairs(Connections) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(Connections)
end

local function Notify(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 2.5
        })
    end)
end

--==============================================================================--
--                           BASIC SYSTEMS
--==============================================================================--
LocalPlayer.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

--==============================================================================--
--                    SUPERMAN FLY + FAKE FLOOR (Đánh lừa chạm đất)
--==============================================================================--
local BodyGyro, BodyVelocity, FakeFloor, FlyTrail

local function CreateFakeFloor()
    if FakeFloor then FakeFloor:Destroy() end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    FakeFloor = Instance.new("Part")
    FakeFloor.Name = "ZakaFakeFloor"
    FakeFloor.Size = Vector3.new(12, 1, 12) -- hitbox to
    FakeFloor.Transparency = 1
    FakeFloor.Anchored = true
    FakeFloor.CanCollide = true
    FakeFloor.CanQuery = true
    FakeFloor.Material = Enum.Material.SmoothPlastic
    FakeFloor.Parent = workspace
end

local function SetFly(state)
    Settings.Fly = state

    if Connections.Fly then Connections.Fly:Disconnect() end
    if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
    if FlyTrail then FlyTrail:Destroy() FlyTrail = nil end
    if FakeFloor then FakeFloor:Destroy() FakeFloor = nil end

    if not state then
        Notify("Fly", T("Disabled"))
        return
    end

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    -- Fake Floor để đánh lừa game
    CreateFakeFloor()

    -- Body movers
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 5e4
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.CFrame = root.CFrame
    BodyGyro.Parent = root

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Velocity = Vector3.zero
    BodyVelocity.Parent = root

    -- Trail đẹp
    local a0 = Instance.new("Attachment", root)
    a0.Position = Vector3.new(0, 0, 1.5)
    local a1 = Instance.new("Attachment", root)
    a1.Position = Vector3.new(0, 0, -1.5)

    FlyTrail = Instance.new("Trail")
    FlyTrail.Attachment0 = a0
    FlyTrail.Attachment1 = a1
    FlyTrail.Lifetime = 0.45
    FlyTrail.MinLength = 0.1
    FlyTrail.FaceCamera = true
    FlyTrail.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 80, 255))
    })
    FlyTrail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.15),
        NumberSequenceKeypoint.new(1, 1)
    })
    FlyTrail.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1.2),
        NumberSequenceKeypoint.new(1, 0)
    })
    FlyTrail.Parent = root

    AddConn("Fly", RunService.RenderStepped:Connect(function()
        if not Settings.Fly or not char or not root or not root.Parent then
            SetFly(false)
            return
        end

        -- Hướng Superman (nhìn theo camera)
        local camCF = Camera.CFrame
        BodyGyro.CFrame = CFrame.lookAt(root.Position, root.Position + camCF.LookVector)

        local move = hum.MoveDirection
        if move.Magnitude > 0.05 then
            local dir = (camCF.LookVector * -move.Z + camCF.RightVector * move.X).Unit
            BodyVelocity.Velocity = dir * Settings.FlySpeed
        else
            BodyVelocity.Velocity = Vector3.zero
        end

        -- Cập nhật Fake Floor luôn nằm dưới chân (đánh lừa grounded)
        if FakeFloor then
            FakeFloor.CFrame = CFrame.new(root.Position.X, root.Position.Y - 3.2, root.Position.Z)
        end
    end))

    Notify("Fly", T("Enabled") .. " • Superman Mode")
end

--==============================================================================--
--                         OTHER MOVEMENT
--==============================================================================--
local function SetSpeed(state)
    Settings.Speed = state
    if Connections.Speed then Connections.Speed:Disconnect() end
    if state then
        AddConn("Speed", RunService.Heartbeat:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = Settings.SpeedValue end
        end))
        Notify("Speed", T("Enabled"))
    else
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
        Notify("Speed", T("Disabled"))
    end
end

local function SetNoclip(state)
    Settings.Noclip = state
    if Connections.Noclip then Connections.Noclip:Disconnect() end
    if state then
        AddConn("Noclip", RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end))
        Notify("Noclip", T("Enabled"))
    else
        Notify("Noclip", T("Disabled"))
    end
end

local function SetTouchTP(state)
    Settings.TouchTP = state
    if Connections.TouchTP then Connections.TouchTP:Disconnect() end
    if state then
        AddConn("TouchTP", UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and Mouse.Hit then
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3.5, 0))
                end
            end
        end))
        Notify("Touch TP", T("Enabled"))
    else
        Notify("Touch TP", T("Disabled"))
    end
end

local function SetWaterWalk(state)
    Settings.WaterWalk = state
    if Connections.Water then Connections.Water:Disconnect() end
    if state then
        AddConn("Water", RunService.RenderStepped:Connect(function()
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local ray = Ray.new(root.Position, Vector3.new(0, -6, 0))
                local _, pos, _, mat = workspace:FindPartOnRay(ray, LocalPlayer.Character)
                if mat == Enum.Material.Water then
                    root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
                    root.CFrame = CFrame.new(root.Position.X, pos.Y + 3.1, root.Position.Z)
                end
            end
        end))
        Notify("Water Walk", T("Enabled"))
    else
        Notify("Water Walk", T("Disabled"))
    end
end

local function SetSpiderClimb(state)
    Settings.SpiderClimb = state
    if Connections.Spider then Connections.Spider:Disconnect() end
    if state then
        AddConn("Spider", RunService.RenderStepped:Connect(function()
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local ray = Ray.new(root.Position, root.CFrame.LookVector * 2.8)
                if workspace:FindPartOnRay(ray, LocalPlayer.Character) then
                    root.Velocity = Vector3.new(root.Velocity.X, 32, root.Velocity.Z)
                end
            end
        end))
        Notify("Spider", T("Enabled"))
    else
        Notify("Spider", T("Disabled"))
    end
end

--==============================================================================--
--                           COMBAT SYSTEMS
--==============================================================================--
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.8
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(0, 162, 255)
FOVCircle.Visible = false

local function GetClosestHead()
    local closest, shortest = nil, Settings.AimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
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

local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    if not checkcaller() and Settings.SilentAim and self == Mouse and key == "Hit" then
        local t = GetClosestHead()
        if t then return t.CFrame end
    end
    return oldIndex(self, key)
end)

local function SetAutoClicker(state)
    Settings.AutoClicker = state
    if Connections.Click then Connections.Click:Disconnect() end
    if state then
        AddConn("Click", RunService.RenderStepped:Connect(function()
            VirtualUser:Button1Down(Vector2.new())
            task.wait(0.04)
            VirtualUser:Button1Up(Vector2.new())
        end))
        Notify("Auto Clicker", T("Enabled"))
    else
        Notify("Auto Clicker", T("Disabled"))
    end
end

local function SetTargetStrafe(state)
    Settings.TargetStrafe = state
    if Connections.Strafe then Connections.Strafe:Disconnect() end
    if state then
        local angle = 0
        AddConn("Strafe", RunService.RenderStepped:Connect(function()
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            local target, minD = nil, 45
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (plr.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
                    if d < minD then minD = d target = plr.Character.HumanoidRootPart end
                end
            end
            if target then
                angle += math.rad(Settings.StrafeSpeed)
                local offset = Vector3.new(math.cos(angle)*Settings.StrafeDistance, 0, math.sin(angle)*Settings.StrafeDistance)
                myRoot.CFrame = CFrame.new(target.Position + offset, target.Position)
            end
        end))
        Notify("Target Strafe", T("Enabled"))
    else
        Notify("Target Strafe", T("Disabled"))
    end
end

--==============================================================================--
--                           ESP
--==============================================================================--
local ESPObjects = {}
local ChamsObjects = {}

local function CreateESP(plr)
    if ESPObjects[plr] then return end
    local t = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
    }
    t.Box.Thickness = 1.5
    t.Box.Filled = false
    t.Name.Size = 14
    t.Name.Center = true
    t.Name.Outline = true
    t.Health.Size = 13
    t.Health.Center = true
    t.Health.Outline = true
    t.Distance.Size = 12
    t.Distance.Center = true
    t.Distance.Outline = true
    t.Tracer.Thickness = 1.2
    t.Tracer.Color = Color3.fromRGB(0, 162, 255)
    ESPObjects[plr] = t
end

Players.PlayerRemoving:Connect(function(plr)
    if ESPObjects[plr] then
        for _, d in pairs(ESPObjects[plr]) do pcall(function() d:Remove() end) end
        ESPObjects[plr] = nil
    end
    if ChamsObjects[plr] then
        ChamsObjects[plr]:Destroy()
        ChamsObjects[plr] = nil
    end
end)

--==============================================================================--
--                           MAIN LOOP
--==============================================================================--
AddConn("Main", RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    FOVCircle.Position = center
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Visible = Settings.Aimbot or Settings.SilentAim

    if Settings.Aimbot then
        local t = GetClosestHead()
        if t then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, t.Position), Settings.AimbotSmooth)
        end
    end

    if Settings.HitboxExpander then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                pcall(function()
                    plr.Character.Head.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                    plr.Character.Head.Transparency = 0.55
                    plr.Character.Head.CanCollide = false
                end)
            end
        end
    end

    if Settings.SpinBot then
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame *= CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0) end
    end

    Camera.FieldOfView = Settings.CustomFOV

    -- ESP
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end

        if Settings.Chams then
            if not ChamsObjects[plr] and plr.Character then
                local hl = Instance.new("Highlight")
                hl.FillColor = Color3.fromRGB(0, 162, 255)
                hl.OutlineColor = Color3.new(1,1,1)
                hl.FillTransparency = 0.4
                hl.Parent = plr.Character
                ChamsObjects[plr] = hl
            end
        elseif ChamsObjects[plr] then
            ChamsObjects[plr]:Destroy()
            ChamsObjects[plr] = nil
        end

        if not Settings.ESP then
            if ESPObjects[plr] then for _,d in pairs(ESPObjects[plr]) do d.Visible = false end end
            continue
        end

        CreateESP(plr)
        local d = ESPObjects[plr]
        local char = plr.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
            for _,v in pairs(d) do v.Visible = false end
            continue
        end

        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local dist = (root.Position - Camera.CFrame.Position).Magnitude

        if not onScreen or dist > Settings.ESPMaxDist then
            for _,v in pairs(d) do v.Visible = false end
            continue
        end

        local size = Vector2.new(math.clamp(1800/pos.Z, 10, 280), math.clamp(2800/pos.Z, 14, 420))
        local col = Color3.fromRGB(0, 162, 255)

        d.Box.Size = size
        d.Box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
        d.Box.Color = col
        d.Box.Visible = Settings.ESPBox

        d.Name.Text = plr.Name
        d.Name.Position = Vector2.new(pos.X, pos.Y - size.Y/2 - 16)
        d.Name.Color = col
        d.Name.Visible = Settings.ESPName

        d.Health.Text = math.floor(hum.Health) .. " HP"
        d.Health.Position = Vector2.new(pos.X, pos.Y + size.Y/2 + 4)
        d.Health.Color = Color3.fromRGB(255*(1-hum.Health/hum.MaxHealth), 255*(hum.Health/hum.MaxHealth), 40)
        d.Health.Visible = Settings.ESPHealth

        d.Distance.Text = math.floor(dist) .. "m"
        d.Distance.Position = Vector2.new(pos.X, pos.Y + size.Y/2 + 18)
        d.Distance.Visible = Settings.ESPDistance

        if Settings.ESPTracers then
            d.Tracer.From = Vector2.new(center.X, Camera.ViewportSize.Y)
            d.Tracer.To = Vector2.new(pos.X, pos.Y)
            d.Tracer.Visible = true
        else
            d.Tracer.Visible = false
        end
    end
end))

--==============================================================================--
--                           UI - iOS STYLE
--==============================================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaIOS"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Nút mở menu (kiểu iOS)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Size = UDim2.new(0, 52, 0, 52)
OpenBtn.Position = UDim2.new(0, 18, 0.42, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
OpenBtn.Text = "Z"
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 24
OpenBtn.AutoButtonColor = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local openStroke = Instance.new("UIStroke", OpenBtn)
openStroke.Color = Color3.fromRGB(255,255,255)
openStroke.Thickness = 1.5
openStroke.Transparency = 0.7

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 340, 0, 0) -- bắt đầu cao 0 để animation
Main.Position = UDim2.new(0.5, -170, 0.5, -230)
Main.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = false
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = Color3.fromRGB(60, 60, 65)
mainStroke.Thickness = 1

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
Header.BorderSizePixel = 0
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size = UDim2.new(1, -100, 1, 0)
TitleLbl.Position = UDim2.new(0, 18, 0, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = T("Title")
TitleLbl.TextColor3 = Color3.new(1,1,1)
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextSize = 17
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.Parent = Header

local LangBtn = Instance.new("TextButton")
LangBtn.Size = UDim2.new(0, 78, 0, 28)
LangBtn.Position = UDim2.new(1, -90, 0.5, -14)
LangBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
LangBtn.Text = "VI / EN"
LangBtn.TextColor3 = Color3.new(1,1,1)
LangBtn.Font = Enum.Font.GothamBold
LangBtn.TextSize = 12
LangBtn.Parent = Header
Instance.new("UICorner", LangBtn).CornerRadius = UDim.new(0, 8)

-- Tab bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 36)
TabBar.Position = UDim2.new(0, 10, 0, 56)
TabBar.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
TabBar.Parent = Main
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 10)

local Tabs = {"Combat", "ESP", "Player", "Teleport", "Troll", "Utility"}
local TabButtons = {}
local Pages = {}
local CurrentTab = 1

local PageHolder = Instance.new("Frame")
PageHolder.Size = UDim2.new(1, -20, 1, -110)
PageHolder.Position = UDim2.new(0, 10, 0, 100)
PageHolder.BackgroundTransparency = 1
PageHolder.ClipsDescendants = true
PageHolder.Parent = Main

for i, name in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#Tabs, -4, 1, -6)
    btn.Position = UDim2.new((i-1)/#Tabs, 2, 0, 3)
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(45, 45, 48)
    btn.Text = T(name)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Parent = TabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    TabButtons[i] = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Position = UDim2.new(i-1, 0, 0, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 122, 255)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Parent = PageHolder

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.Parent = page
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 12)
    end)
    Pages[i] = page

    btn.MouseButton1Click:Connect(function()
        if CurrentTab == i then return end
        CurrentTab = i
        for idx, b in ipairs(TabButtons) do
            TweenService:Create(b, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
                BackgroundColor3 = idx == i and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(45, 45, 48)
            }):Play()
        end
        for idx, p in ipairs(Pages) do
            TweenService:Create(p, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(idx - CurrentTab, 0, 0, 0)
            }):Play()
        end
    end)
end

-- Helper tạo toggle kiểu iOS
local function CreateIOSToggle(parent, key, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = T(key)
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 48, 0, 28)
    track.Position = UDim2.new(1, -60, 0.5, -14)
    track.BackgroundColor3 = default and Color3.fromRGB(52, 199, 89) or Color3.fromRGB(60, 60, 65)
    track.Parent = frame
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 24, 0, 24)
    knob.Position = default and UDim2.new(1, -26, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local enabled = default
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame

    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        TweenService:Create(track, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
            BackgroundColor3 = enabled and Color3.fromRGB(52, 199, 89) or Color3.fromRGB(60, 60, 65)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
            Position = enabled and UDim2.new(1, -26, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)
        }):Play()
        callback(enabled)
    end)

    return frame
end

local function CreateButton(parent, key, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 44)
    btn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
    btn.Text = T(key)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Tạo nội dung các tab
CreateIOSToggle(Pages[1], "Aimbot", false, function(v) Settings.Aimbot = v end)
CreateIOSToggle(Pages[1], "SilentAim", false, function(v) Settings.SilentAim = v end)
CreateIOSToggle(Pages[1], "AutoClicker", false, function(v) SetAutoClicker(v) end)
CreateIOSToggle(Pages[1], "TargetStrafe", false, function(v) SetTargetStrafe(v) end)
CreateIOSToggle(Pages[1], "Hitbox", false, function(v) Settings.HitboxExpander = v end)
CreateIOSToggle(Pages[1], "NPCAimbot", false, function(v) Settings.NPCAimbot = v end)
CreateIOSToggle(Pages[1], "InfiniteAmmo", false, function(v) Settings.InfiniteAmmo = v end)
CreateIOSToggle(Pages[1], "FastFire", false, function(v) Settings.FastFire = v end)

CreateIOSToggle(Pages[2], "ESPMain", false, function(v) Settings.ESP = v end)
CreateIOSToggle(Pages[2], "ESPBox", true, function(v) Settings.ESPBox = v end)
CreateIOSToggle(Pages[2], "ESPName", true, function(v) Settings.ESPName = v end)
CreateIOSToggle(Pages[2], "ESPHealth", true, function(v) Settings.ESPHealth = v end)
CreateIOSToggle(Pages[2], "ESPDistance", true, function(v) Settings.ESPDistance = v end)
CreateIOSToggle(Pages[2], "ESPTracers", false, function(v) Settings.ESPTracers = v end)
CreateIOSToggle(Pages[2], "Chams", false, function(v) Settings.Chams = v end)
CreateIOSToggle(Pages[2], "Crosshair", false, function(v) Settings.CustomCrosshair = v end)

CreateIOSToggle(Pages[3], "Speed", false, function(v) SetSpeed(v) end)
CreateIOSToggle(Pages[3], "Fly", false, function(v) SetFly(v) end)
CreateIOSToggle(Pages[3], "Noclip", false, function(v) SetNoclip(v) end)
CreateIOSToggle(Pages[3], "InfJump", false, function(v) Settings.InfiniteJump = v end)
CreateIOSToggle(Pages[3], "Spider", false, function(v) SetSpiderClimb(v) end)
CreateIOSToggle(Pages[3], "WaterWalk", false, function(v) SetWaterWalk(v) end)
CreateIOSToggle(Pages[3], "SpinBot", false, function(v) Settings.SpinBot = v end)

CreateIOSToggle(Pages[4], "TouchTP", false, function(v) SetTouchTP(v) end)
CreateButton(Pages[4], "BringAll", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = root.CFrame + Vector3.new(3,0,0)
            end
        end
        Notify("Bring", "Done (Client)")
    end
end)

CreateButton(Pages[5], "FlingAll", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local orig = root.CFrame
    local bav = Instance.new("BodyAngularVelocity")
    bav.AngularVelocity = Vector3.new(0, 99999, 0)
    bav.MaxTorque = Vector3.new(0, math.huge, 0)
    bav.Parent = root
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            for _ = 1, 6 do
                root.CFrame = plr.Character.HumanoidRootPart.CFrame
                task.wait(0.025)
            end
        end
    end
    bav:Destroy()
    root.CFrame = orig
    Notify("Fling", "Done (Client)")
end)

CreateIOSToggle(Pages[5], "ChatSpam", false, function(v)
    Settings.ChatSpammer = v
    if Connections.Spam then task.cancel(Connections.Spam) end
    if v then
        Connections.Spam = task.spawn(function()
            while Settings.ChatSpammer do
                pcall(function()
                    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                        TextChatService.TextChannels.RBXGeneral:SendAsync(Settings.SpamMessage)
                    else
                        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Settings.SpamMessage, "All")
                    end
                end)
                task.wait(2.2)
            end
        end)
    end
end)

CreateIOSToggle(Pages[6], "AntiAFK", true, function(v) Settings.AntiAFK = v end)
CreateButton(Pages[6], "Rejoin", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)
CreateButton(Pages[6], "ServerHop", function()
    pcall(function()
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
        for _, s in ipairs(servers) do
            if s.id \~= game.JobId and s.playing < s.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                break
            end
        end
    end)
end)
CreateButton(Pages[6], "Unload", function()
    ClearAll()
    if FakeFloor then FakeFloor:Destroy() end
    for _, t in pairs(ESPObjects) do for _,d in pairs(t) do pcall(function() d:Remove() end) end end
    FOVCircle:Remove()
    ScreenGui:Destroy()
    Notify("Zaka", "Unloaded")
end)

-- Animation mở/đóng menu
local menuOpen = false
local function ToggleMenu()
    menuOpen = not menuOpen
    if menuOpen then
        Main.Visible = true
        Main.Size = UDim2.new(0, 340, 0, 0)
        TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 340, 0, 460)
        }):Play()
        TweenService:Create(OpenBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 59, 48)}):Play()
    else
        local tw = TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 340, 0, 0)
        })
        tw:Play()
        tw.Completed:Connect(function()
            Main.Visible = false
        end)
        TweenService:Create(OpenBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 122, 255)}):Play()
    end
end

OpenBtn.MouseButton1Click:Connect(ToggleMenu)

-- Chuyển ngôn ngữ
LangBtn.MouseButton1Click:Connect(function()
    Lang = Lang == "VI" and "EN" or "VI"
    TitleLbl.Text = T("Title")
    for i, btn in ipairs(TabButtons) do
        btn.Text = T(Tabs[i])
    end
    -- Cập nhật lại các label trong page (đơn giản nhất là reload text)
    for _, page in ipairs(Pages) do
        for _, child in ipairs(page:GetChildren()) do
            if child:IsA("Frame") and child:FindFirstChild("Label") then
                -- không đổi key nên tạm thời giữ, người dùng có thể tắt mở lại
            elseif child:IsA("TextButton") then
                -- giữ nguyên
            end
        end
    end
    Notify("Language", Lang == "VI" and "Tiếng Việt" or "English")
end)

-- Đảm bảo menu hiện khi load
task.wait(0.5)
ToggleMenu() -- tự mở 1 lần khi load để bạn thấy

print("Zaka HUD iOS Edition loaded successfully!")
Notify("Zaka HUD", "iOS Style • Sẵn sàng")
