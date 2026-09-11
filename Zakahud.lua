--[[
    ZAKA HUD - Cat Mascot Edition (iOS Style)
    - Menu chắc chắn hiện
    - Nút đóng = hình mèo đen trắng
    - Mèo bám thành menu + đầu lắc lư
    - Animation mở/đóng mượt
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Language
local Lang = "VI"
local L = {
    VI = {
        Title = "ZAKA HUD", Combat = "Chiến Đấu", ESP = "ESP", Player = "Nhân Vật",
        Teleport = "Dịch Chuyển", Troll = "Troll", Utility = "Tiện Ích",
        Aimbot = "Aimbot", SilentAim = "Silent Aim", AutoClicker = "Tự Click",
        TargetStrafe = "Xoay Mục Tiêu", Hitbox = "Hitbox To", Fly = "Bay Superman",
        Speed = "Tăng Tốc", Noclip = "Xuyên Tường", InfJump = "Nhảy Vô Hạn",
        TouchTP = "Chạm Tele", BringAll = "Kéo Tất Cả", FlingAll = "Hất Văng",
        AntiAFK = "Chống AFK", Rejoin = "Vào Lại", ServerHop = "Đổi Server",
        Unload = "Tắt Script", Enabled = "Đã bật", Disabled = "Đã tắt"
    },
    EN = {
        Title = "ZAKA HUD", Combat = "Combat", ESP = "ESP", Player = "Player",
        Teleport = "Teleport", Troll = "Troll", Utility = "Utility",
        Aimbot = "Aimbot", SilentAim = "Silent Aim", AutoClicker = "Auto Clicker",
        TargetStrafe = "Target Strafe", Hitbox = "Hitbox", Fly = "Superman Fly",
        Speed = "Speed", Noclip = "Noclip", InfJump = "Infinite Jump",
        TouchTP = "Touch TP", BringAll = "Bring All", FlingAll = "Fling All",
        AntiAFK = "Anti AFK", Rejoin = "Rejoin", ServerHop = "Server Hop",
        Unload = "Unload", Enabled = "Enabled", Disabled = "Disabled"
    }
}
local function T(k) return L[Lang][k] or k end

-- Settings (rút gọn để ổn định)
local Settings = {
    Aimbot = false, AimbotFOV = 120, AimbotSmooth = 0.18, SilentAim = false,
    AutoClicker = false, TargetStrafe = false, StrafeDistance = 10, StrafeSpeed = 6,
    HitboxExpander = false, HitboxSize = 18,
    ESP = false, ESPBox = true, ESPName = true, ESPHealth = true, ESPDistance = true, ESPTracers = false, ESPMaxDist = 3000, Chams = false,
    Speed = false, SpeedValue = 28, Fly = false, FlySpeed = 70, Noclip = false, InfiniteJump = false,
    TouchTP = false, AntiAFK = true, ChatSpammer = false, SpamMessage = "Zaka HUD 🐱"
}

local Connections = {}
local function AddConn(n, c) if Connections[n] then pcall(function() Connections[n]:Disconnect() end) end Connections[n] = c end
local function ClearAll() for _,c in pairs(Connections) do pcall(function() c:Disconnect() end) end table.clear(Connections) end

local function Notify(t, m)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = t, Text = m, Duration = 2.2})
    end)
end

-- Anti AFK + Jump
LocalPlayer.Idled:Connect(function()
    if Settings.AntiAFK then VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new()) end
end)
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

--==================== SUPERMAN FLY + FAKE FLOOR ====================--
local BodyGyro, BodyVelocity, FakeFloor, FlyTrail
local function SetFly(state)
    Settings.Fly = state
    if Connections.Fly then Connections.Fly:Disconnect() end
    if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
    if FlyTrail then FlyTrail:Destroy() FlyTrail = nil end
    if FakeFloor then FakeFloor:Destroy() FakeFloor = nil end

    if not state then Notify("Fly", T("Disabled")) return end

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    FakeFloor = Instance.new("Part")
    FakeFloor.Name = "ZakaFakeFloor"
    FakeFloor.Size = Vector3.new(14, 1.2, 14)
    FakeFloor.Transparency = 1
    FakeFloor.Anchored = true
    FakeFloor.CanCollide = true
    FakeFloor.Parent = workspace

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 4e4
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.Parent = root

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Parent = root

    local a0 = Instance.new("Attachment", root) a0.Position = Vector3.new(0,0,1.8)
    local a1 = Instance.new("Attachment", root) a1.Position = Vector3.new(0,0,-1.8)
    FlyTrail = Instance.new("Trail")
    FlyTrail.Attachment0 = a0
    FlyTrail.Attachment1 = a1
    FlyTrail.Lifetime = 0.4
    FlyTrail.Color = ColorSequence.new(Color3.fromRGB(0,170,255), Color3.fromRGB(160,80,255))
    FlyTrail.Transparency = NumberSequence.new(0.2, 1)
    FlyTrail.WidthScale = NumberSequence.new(1.1, 0)
    FlyTrail.Parent = root

    AddConn("Fly", RunService.RenderStepped:Connect(function()
        if not Settings.Fly or not root or not root.Parent then SetFly(false) return end
        local cam = Camera.CFrame
        BodyGyro.CFrame = CFrame.lookAt(root.Position, root.Position + cam.LookVector)
        local move = hum.MoveDirection
        if move.Magnitude > 0.05 then
            local dir = (cam.LookVector * -move.Z + cam.RightVector * move.X).Unit
            BodyVelocity.Velocity = dir * Settings.FlySpeed
        else
            BodyVelocity.Velocity = Vector3.zero
        end
        if FakeFloor then
            FakeFloor.CFrame = CFrame.new(root.Position.X, root.Position.Y - 3.3, root.Position.Z)
        end
    end))
    Notify("Fly", T("Enabled") .. " • Superman + Fake Floor")
end

-- Speed / Noclip / TouchTP
local function SetSpeed(s)
    Settings.Speed = s
    if Connections.Speed then Connections.Speed:Disconnect() end
    if s then
        AddConn("Speed", RunService.Heartbeat:Connect(function()
            local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = Settings.SpeedValue end
        end))
        Notify("Speed", T("Enabled"))
    else
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 16 end
        Notify("Speed", T("Disabled"))
    end
end

local function SetNoclip(s)
    Settings.Noclip = s
    if Connections.Noclip then Connections.Noclip:Disconnect() end
    if s then
        AddConn("Noclip", RunService.Stepped:Connect(function()
            local c = LocalPlayer.Character
            if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        end))
        Notify("Noclip", T("Enabled"))
    else Notify("Noclip", T("Disabled")) end
end

local function SetTouchTP(s)
    Settings.TouchTP = s
    if Connections.TouchTP then Connections.TouchTP:Disconnect() end
    if s then
        AddConn("TouchTP", UserInputService.InputBegan:Connect(function(i, gp)
            if gp then return end
            if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) and Mouse.Hit then
                local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if r then r.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3.5, 0)) end
            end
        end))
        Notify("TouchTP", T("Enabled"))
    else Notify("TouchTP", T("Disabled")) end
end

-- Aimbot cơ bản
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.6
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(0, 162, 255)
FOVCircle.Visible = false

local function GetClosestHead()
    local closest, short = nil, Settings.AimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local pos, on = Camera:WorldToViewportPoint(head.Position)
                if on then
                    local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if d < short then short = d closest = head end
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

-- ESP đơn giản
local ESPObjects = {}
local function CreateESP(plr)
    if ESPObjects[plr] then return end
    local t = {Box = Drawing.new("Square"), Name = Drawing.new("Text"), Health = Drawing.new("Text"), Distance = Drawing.new("Text")}
    t.Box.Thickness = 1.4 t.Box.Filled = false
    t.Name.Size = 13 t.Name.Center = true t.Name.Outline = true
    t.Health.Size = 12 t.Health.Center = true t.Health.Outline = true
    t.Distance.Size = 12 t.Distance.Center = true t.Distance.Outline = true
    ESPObjects[plr] = t
end
Players.PlayerRemoving:Connect(function(plr)
    if ESPObjects[plr] then for _,d in pairs(ESPObjects[plr]) do pcall(function() d:Remove() end) end ESPObjects[plr] = nil end
end)

-- Main loop
AddConn("Main", RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Position = center
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Visible = Settings.Aimbot or Settings.SilentAim

    if Settings.Aimbot then
        local t = GetClosestHead()
        if t then Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, t.Position), Settings.AimbotSmooth) end
    end

    if Settings.HitboxExpander then
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                pcall(function()
                    plr.Character.Head.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                    plr.Character.Head.Transparency = 0.55
                    plr.Character.Head.CanCollide = false
                end)
            end
        end
    end

    -- ESP
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if not Settings.ESP then
            if ESPObjects[plr] then for _,d in pairs(ESPObjects[plr]) do d.Visible = false end end
            continue
        end
        CreateESP(plr)
        local d = ESPObjects[plr]
        local char = plr.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
            for _,v in pairs(d) do v.Visible = false end continue
        end
        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        local pos, on = Camera:WorldToViewportPoint(root.Position)
        local dist = (root.Position - Camera.CFrame.Position).Magnitude
        if not on or dist > Settings.ESPMaxDist then for _,v in pairs(d) do v.Visible = false end continue end

        local size = Vector2.new(math.clamp(1800/pos.Z, 10, 260), math.clamp(2700/pos.Z, 14, 400))
        local col = Color3.fromRGB(0, 162, 255)
        d.Box.Size = size
        d.Box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
        d.Box.Color = col
        d.Box.Visible = Settings.ESPBox
        d.Name.Text = plr.Name
        d.Name.Position = Vector2.new(pos.X, pos.Y - size.Y/2 - 15)
        d.Name.Color = col
        d.Name.Visible = Settings.ESPName
        d.Health.Text = math.floor(hum.Health).." HP"
        d.Health.Position = Vector2.new(pos.X, pos.Y + size.Y/2 + 3)
        d.Health.Color = Color3.fromRGB(255*(1-hum.Health/hum.MaxHealth), 255*(hum.Health/hum.MaxHealth), 40)
        d.Health.Visible = Settings.ESPHealth
        d.Distance.Text = math.floor(dist).."m"
        d.Distance.Position = Vector2.new(pos.X, pos.Y + size.Y/2 + 17)
        d.Distance.Visible = Settings.ESPDistance
    end
end))

--==================== UI + CAT MASCOT ====================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaCatHUD"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Nút mèo khi đóng menu (đen trắng)
local CatBtn = Instance.new("TextButton")
CatBtn.Name = "CatButton"
CatBtn.Size = UDim2.new(0, 58, 0, 58)
CatBtn.Position = UDim2.new(0, 16, 0.4, 0)
CatBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
CatBtn.Text = "🐱"
CatBtn.TextSize = 32
CatBtn.Font = Enum.Font.GothamBold
CatBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
CatBtn.AutoButtonColor = false
CatBtn.Parent = ScreenGui
Instance.new("UICorner", CatBtn).CornerRadius = UDim.new(1, 0)
local catStroke = Instance.new("UIStroke", CatBtn)
catStroke.Color = Color3.fromRGB(180, 180, 180)
catStroke.Thickness = 2

-- Main Menu
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 0, 0, 0) -- bắt đầu 0 để animation
Main.Position = UDim2.new(0.5, -175, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = false
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)
local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = Color3.fromRGB(70, 70, 75)
mainStroke.Thickness = 1.5

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 20)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🐱  " .. T("Title")
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- ===== CON MÈO BÁM THÀNH MENU (bên trái) =====
local CatHolder = Instance.new("Frame")
CatHolder.Name = "CatMascot"
CatHolder.Size = UDim2.new(0, 70, 0, 90)
CatHolder.Position = UDim2.new(0, -38, 0.5, -45) -- bám bên trái
CatHolder.BackgroundTransparency = 1
CatHolder.Parent = Main
CatHolder.ZIndex = 10

-- Thân mèo
local CatBody = Instance.new("TextLabel")
CatBody.Size = UDim2.new(0, 52, 0, 52)
CatBody.Position = UDim2.new(0, 10, 0, 28)
CatBody.BackgroundColor3 = Color3.fromRGB(40, 40, 42)
CatBody.Text = ""
CatBody.Parent = CatHolder
Instance.new("UICorner", CatBody).CornerRadius = UDim.new(1, 0)

-- Đầu mèo (sẽ lắc lư)
local CatHead = Instance.new("TextLabel")
CatHead.Name = "CatHead"
CatHead.Size = UDim2.new(0, 48, 0, 48)
CatHead.Position = UDim2.new(0, 12, 0, 0)
CatHead.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
CatHead.Text = "🐱"
CatHead.TextSize = 30
CatHead.Font = Enum.Font.GothamBold
CatHead.TextColor3 = Color3.fromRGB(245, 245, 245)
CatHead.Parent = CatHolder
Instance.new("UICorner", CatHead).CornerRadius = UDim.new(1, 0)

-- 2 chân bám
local Paw1 = Instance.new("Frame")
Paw1.Size = UDim2.new(0, 14, 0, 22)
Paw1.Position = UDim2.new(0, 48, 0, 38)
Paw1.BackgroundColor3 = Color3.fromRGB(50, 50, 52)
Paw1.Parent = CatHolder
Instance.new("UICorner", Paw1).CornerRadius = UDim.new(0, 6)

local Paw2 = Instance.new("Frame")
Paw2.Size = UDim2.new(0, 14, 0, 22)
Paw2.Position = UDim2.new(0, 48, 0, 58)
Paw2.BackgroundColor3 = Color3.fromRGB(50, 50, 52)
Paw2.Parent = CatHolder
Instance.new("UICorner", Paw2).CornerRadius = UDim.new(0, 6)

-- Animation đầu mèo lắc lư
local headBob = true
task.spawn(function()
    while true do
        if not CatHead or not CatHead.Parent then break end
        local targetRot = headBob and 8 or -8
        TweenService:Create(CatHead, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Rotation = targetRot
        }):Play()
        headBob = not headBob
        task.wait(0.75)
    end
end)

-- Tab bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 34)
TabBar.Position = UDim2.new(0, 10, 0, 58)
TabBar.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
TabBar.Parent = Main
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 10)

local Tabs = {"Combat", "ESP", "Player", "Teleport", "Troll", "Utility"}
local TabButtons, Pages = {}, {}
local CurrentTab = 1

local PageHolder = Instance.new("Frame")
PageHolder.Size = UDim2.new(1, -20, 1, -110)
PageHolder.Position = UDim2.new(0, 10, 0, 100)
PageHolder.BackgroundTransparency = 1
PageHolder.ClipsDescendants = true
PageHolder.Parent = Main

for i, name in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#Tabs, -3, 1, -6)
    btn.Position = UDim2.new((i-1)/#Tabs, 1.5, 0, 3)
    btn.BackgroundColor3 = i==1 and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(48, 48, 52)
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
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.Parent = PageHolder
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 7)
    list.Parent = page
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0,0,0, list.AbsoluteContentSize.Y + 10)
    end)
    Pages[i] = page

    btn.MouseButton1Click:Connect(function()
        if CurrentTab == i then return end
        CurrentTab = i
        for idx,b in ipairs(TabButtons) do
            TweenService:Create(b, TweenInfo.new(0.25), {
                BackgroundColor3 = idx==i and Color3.fromRGB(0,122,255) or Color3.fromRGB(48,48,52)
            }):Play()
        end
        for idx,p in ipairs(Pages) do
            TweenService:Create(p, TweenInfo.new(0.32, Enum.EasingStyle.Quint), {
                Position = UDim2.new(idx - CurrentTab, 0, 0, 0)
            }):Play()
        end
    end)
end

-- Helper toggle iOS
local function CreateToggle(parent, key, default, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 42)
    f.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 11)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -65, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = T(key)
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 46, 0, 26)
    track.Position = UDim2.new(1, -56, 0.5, -13)
    track.BackgroundColor3 = default and Color3.fromRGB(52, 199, 89) or Color3.fromRGB(60, 60, 65)
    track.Parent = f
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 22, 0, 22)
    knob.Position = default and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local en = default
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,1,0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = f
    btn.MouseButton1Click:Connect(function()
        en = not en
        TweenService:Create(track, TweenInfo.new(0.22), {BackgroundColor3 = en and Color3.fromRGB(52,199,89) or Color3.fromRGB(60,60,65)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.22), {Position = en and UDim2.new(1,-24,0.5,-11) or UDim2.new(0,2,0.5,-11)}):Play()
        cb(en)
    end)
end

local function CreateBtn(parent, key, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 42)
    b.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
    b.Text = T(key)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 11)
    b.MouseButton1Click:Connect(cb)
end

-- Nội dung tab
CreateToggle(Pages[1], "Aimbot", false, function(v) Settings.Aimbot = v end)
CreateToggle(Pages[1], "SilentAim", false, function(v) Settings.SilentAim = v end)
CreateToggle(Pages[1], "AutoClicker", false, function(v)
    Settings.AutoClicker = v
    if Connections.Click then Connections.Click:Disconnect() end
    if v then
        AddConn("Click", RunService.RenderStepped:Connect(function()
            VirtualUser:Button1Down(Vector2.new()) task.wait(0.04) VirtualUser:Button1Up(Vector2.new())
        end))
    end
end)
CreateToggle(Pages[1], "TargetStrafe", false, function(v)
    Settings.TargetStrafe = v
    if Connections.Strafe then Connections.Strafe:Disconnect() end
    if v then
        local ang = 0
        AddConn("Strafe", RunService.RenderStepped:Connect(function()
            local my = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not my then return end
            local tg, md = nil, 40
            for _,p in ipairs(Players:GetPlayers()) do
                if p \~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (p.Character.HumanoidRootPart.Position - my.Position).Magnitude
                    if d < md then md = d tg = p.Character.HumanoidRootPart end
                end
            end
            if tg then
                ang = ang + math.rad(Settings.StrafeSpeed)
                my.CFrame = CFrame.new(tg.Position + Vector3.new(math.cos(ang)*Settings.StrafeDistance, 0, math.sin(ang)*Settings.StrafeDistance), tg.Position)
            end
        end))
    end
end)
CreateToggle(Pages[1], "Hitbox", false, function(v) Settings.HitboxExpander = v end)

CreateToggle(Pages[2], "ESP", false, function(v) Settings.ESP = v end)
CreateToggle(Pages[2], "ESPBox", true, function(v) Settings.ESPBox = v end)
CreateToggle(Pages[2], "ESPName", true, function(v) Settings.ESPName = v end)
CreateToggle(Pages[2], "ESPHealth", true, function(v) Settings.ESPHealth = v end)
CreateToggle(Pages[2], "ESPDistance", true, function(v) Settings.ESPDistance = v end)

CreateToggle(Pages[3], "Speed", false, function(v) SetSpeed(v) end)
CreateToggle(Pages[3], "Fly", false, function(v) SetFly(v) end)
CreateToggle(Pages[3], "Noclip", false, function(v) SetNoclip(v) end)
CreateToggle(Pages[3], "InfJump", false, function(v) Settings.InfiniteJump = v end)

CreateToggle(Pages[4], "TouchTP", false, function(v) SetTouchTP(v) end)
CreateBtn(Pages[4], "BringAll", function()
    local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if r then
        for _,p in ipairs(Players:GetPlayers()) do
            if p \~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.CFrame = r.CFrame + Vector3.new(2.5,0,0)
            end
        end
        Notify("Bring", "Done")
    end
end)

CreateBtn(Pages[5], "FlingAll", function()
    local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not r then return end
    local orig = r.CFrame
    local bav = Instance.new("BodyAngularVelocity")
    bav.AngularVelocity = Vector3.new(0, 99999, 0)
    bav.MaxTorque = Vector3.new(0, math.huge, 0)
    bav.Parent = r
    for _,p in ipairs(Players:GetPlayers()) do
        if p \~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            for _=1,5 do r.CFrame = p.Character.HumanoidRootPart.CFrame task.wait(0.03) end
        end
    end
    bav:Destroy()
    r.CFrame = orig
    Notify("Fling", "Done")
end)

CreateToggle(Pages[6], "AntiAFK", true, function(v) Settings.AntiAFK = v end)
CreateBtn(Pages[6], "Rejoin", function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
CreateBtn(Pages[6], "ServerHop", function()
    pcall(function()
        local data = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
        for _,s in ipairs(data) do
            if s.id \~= game.JobId and s.playing < s.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                break
            end
        end
    end)
end)
CreateBtn(Pages[6], "Unload", function()
    ClearAll()
    if FakeFloor then FakeFloor:Destroy() end
    for _,t in pairs(ESPObjects) do for _,d in pairs(t) do pcall(function() d:Remove() end) end end
    FOVCircle:Remove()
    ScreenGui:Destroy()
    Notify("Zaka", "Unloaded")
end)

-- Animation mở / đóng
local menuOpen = false
local function ToggleMenu()
    menuOpen = not menuOpen
    if menuOpen then
        Main.Visible = true
        Main.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(Main, TweenInfo.new(0.48, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 350, 0, 480)
        }):Play()
        TweenService:Create(CatBtn, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(255, 70, 70),
            Text = "✕"
        }):Play()
    else
        local tw = TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        })
        tw:Play()
        tw.Completed:Wait()
        Main.Visible = false
        TweenService:Create(CatBtn, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 32),
            Text = "🐱"
        }):Play()
    end
end

CatBtn.MouseButton1Click:Connect(ToggleMenu)

-- ===== ÉP MENU HIỆN NGAY KHI LOAD =====
task.defer(function()
    task.wait(0.6)
    if not menuOpen then
        ToggleMenu() -- tự mở 1 lần để bạn thấy chắc chắn
    end
end)

print("✅ Zaka HUD Cat Edition loaded! Menu đã được ép hiện.")
Notify("Zaka HUD", "Mèo đã sẵn sàng 🐱")
