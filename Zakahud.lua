--[[
============================================================
        ZAKA PURE UI V1 + V3 FULL MERGED
        Giao diện Bản 1 + Toàn bộ chức năng Bản 2
============================================================
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local CollectionService = game:GetService("CollectionService")
local Debris = game:GetService("Debris")
local VirtualUser = game:GetService("VirtualUser")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Cleanup
for _, name in ipairs({"ZAKA_PURE_V1","ZAKA_PURE_V6","ZakaPureUI","ZakaNarutoUI"}) do
    local old = PlayerGui:FindFirstChild(name)
    if old then old:Destroy() end
end
for _, name in ipairs({"ZAKA_UI_BLUR_V1","ZAKA_GLOW_V1","ZAKA_NIGHT_VISION_V1"}) do
    local old = Lighting:FindFirstChild(name)
    if old then old:Destroy() end
end

--==========================================================
-- CONFIG + THEME
--==========================================================
local Config = {
    Theme = "Cyber",
    UITransparency = 0.28,
    UIScale = 1,
    Blur = 10,
    AnimationSpeed = 1,
    FPS = true,
    Coordinates = true,
    Velocity = true,
    WalkSpeed = 16,
    JumpPower = 50,
    Gravity = workspace.Gravity,
    FOV = 70,
    DoubleJump = false,
    Glide = false,
    Fly = false,
    FlySpeed = 80,
    FlyVertical = 60,
    Crosshair = false,
    CrosshairSize = 9,
    FOVCircle = false,
    FOVSize = 150,
    RainbowUI = false,
    UIGlow = true,
    NightVision = false,
    CameraShake = false,
    MenuPosition = UDim2.fromScale(.5,.5),
    OpenButtonPosition = UDim2.new(0,18,.5,-29),
    Open = false,
}

local Themes = {
    Cyber = {
        Background=Color3.fromRGB(7,11,20), Panel=Color3.fromRGB(12,18,30), Card=Color3.fromRGB(18,28,44),
        Accent=Color3.fromRGB(75,185,255), Accent2=Color3.fromRGB(150,235,255),
        Text=Color3.fromRGB(240,248,255), Sub=Color3.fromRGB(145,165,190), Border=Color3.fromRGB(75,175,230),
    },
    Purple = {
        Background=Color3.fromRGB(12,8,20), Panel=Color3.fromRGB(22,13,35), Card=Color3.fromRGB(34,20,52),
        Accent=Color3.fromRGB(185,110,255), Accent2=Color3.fromRGB(230,175,255),
        Text=Color3.fromRGB(248,240,255), Sub=Color3.fromRGB(180,150,205), Border=Color3.fromRGB(180,110,255),
    },
    Ice = {
        Background=Color3.fromRGB(6,15,22), Panel=Color3.fromRGB(10,27,37), Card=Color3.fromRGB(16,41,53),
        Accent=Color3.fromRGB(95,220,255), Accent2=Color3.fromRGB(190,250,255),
        Text=Color3.fromRGB(240,253,255), Sub=Color3.fromRGB(145,190,205), Border=Color3.fromRGB(95,205,240),
    },
}
local Theme = Themes[Config.Theme]

--==========================================================
-- SETTINGS (chức năng thật từ Bản 2)
--==========================================================
local Settings = {
    Aimbot = false, AimbotFOV = 120, AimbotSmooth = 0.25, SilentAim = false,
    AutoClicker = false, ClickDelay = 0.05, TargetStrafe = false,
    StrafeDistance = 12, StrafeSpeed = 6, SpinBot = false, SpinSpeed = 45,
    HitboxHead = false, HeadSize = 15, HitboxTorso = false,
    TorsoSize = Vector3.new(4,6,4), HitboxWeapon = false, WeaponSize = 5,
    HitboxTransparent = 0.5, HitboxLimb = false, LimbSize = 4,
    ESP = false, ESPBox = true, ESPName = true, ESPHealth = true,
    ESPDistance = true, ESPMaxDist = 3500, Chams = false,
    ChamsColor = Color3.fromRGB(0,200,255), CustomCrosshair = false,
    CrosshairSize = 12, GlowTrail = false, Fullbright = false,
    FOVChanger = false, FOVValue = 90,
    Speed = false, SpeedValue = 26, Fly = false, FlySpeed = 50,
    Noclip = false, InfiniteJump = false, HighJump = false, JumpPower = 100,
    Bhop = false, SpiderClimb = false, SpiderSpeed = 30, WaterWalk = false,
    TouchTP = false, BringNPC = false, GravityMod = false, GravityValue = 196.2,
    ChatSpammer = false, SpamMessage = "Zaka Pure UI Merged", SpamDelay = 2,
}

local NoclipConn, SpeedConn, FlyConn, TouchTPConn, AutoClickConn, SpamConn, StrafeConn, WaterConn, SpiderConn
local BodyGyro, BodyVelocity
local ESPObjects = {}
local ChamsObjects = {}
local OriginalAmbient = Lighting.Ambient
local OriginalGravity = Workspace.Gravity

--==========================================================
-- STATE / REGISTRY
--==========================================================
local Features = {}
local State = {}
local Connections = {}
local notify
local Runtime = {
    Crosshair=nil, FOVCircle=nil, FlyBV=nil, FlyBG=nil, FlyConnection=nil,
    Cards={}, TabButtons={}, Pages={}, CurrentTab="Combat", Combo=0, LastClick=0
}

local function connect(signal, fn)
    local c = signal:Connect(fn)
    table.insert(Connections, c)
    return c
end

local function getCharacter() return LocalPlayer.Character end
local function getHumanoid() local c=getCharacter() return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot() local c=getCharacter() return c and c:FindFirstChild("HumanoidRootPart") end

local function tween(obj, time, props, style, direction)
    local info = TweenInfo.new(time/math.max(Config.AnimationSpeed,.05), style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
    return c
end

local function stroke(obj, trans)
    local s = Instance.new("UIStroke")
    s.Color = Theme.Border
    s.Thickness = 1
    s.Transparency = trans or .5
    s.Parent = obj
    return s
end

local function label(parent, text, size, bold)
    local x = Instance.new("TextLabel")
    x.BackgroundTransparency = 1
    x.Text = text
    x.TextColor3 = Theme.Text
    x.TextSize = size
    x.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    x.TextXAlignment = Enum.TextXAlignment.Left
    x.Parent = parent
    return x
end

--==========================================================
-- GUI
--==========================================================
local Gui = Instance.new("ScreenGui")
Gui.Name = "ZAKA_PURE_V1"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local Blur = Instance.new("BlurEffect")
Blur.Name = "ZAKA_UI_BLUR_V1"
Blur.Size = 0
Blur.Parent = Lighting

local FX = Instance.new("Frame")
FX.Name = "FX"
FX.Size = UDim2.fromScale(1,1)
FX.BackgroundTransparency = 1
FX.ZIndex = 900
FX.Parent = Gui

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.fromOffset(64,64)
OpenButton.Position = Config.OpenButtonPosition
OpenButton.BackgroundColor3 = Theme.Panel
OpenButton.BackgroundTransparency = .04
OpenButton.Text = "Z"
OpenButton.TextColor3 = Theme.Text
OpenButton.TextSize = 28
OpenButton.Font = Enum.Font.GothamBlack
OpenButton.AutoButtonColor = false
OpenButton.ZIndex = 80
OpenButton.Parent = Gui
corner(OpenButton, 999)
stroke(OpenButton, .12)

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(.5,.5)
Main.Position = Config.MenuPosition
Main.Size = UDim2.fromOffset(0,0)
Main.BackgroundColor3 = Theme.Background
Main.BackgroundTransparency = Config.UITransparency
Main.Visible = false
Main.ClipsDescendants = true
Main.ZIndex = 20
Main.Parent = Gui
corner(Main, 24)
stroke(Main, .10)

local UIScale = Instance.new("UIScale")
UIScale.Scale = Config.UIScale
UIScale.Parent = Main

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1,0,0,72)
Top.BackgroundTransparency = 1
Top.Parent = Main

local Title = label(Top, "ZAKA PURE", 21, true)
Title.Position = UDim2.new(0,22,0,10)
Title.Size = UDim2.fromOffset(300,28)
Title.TextColor3 = Theme.Accent2

local Subtitle = label(Top, "V1 + V3 MERGED  •  GLASS  •  FULL FEATURES", 10, false)
Subtitle.Position = UDim2.new(0,23,0,40)
Subtitle.Size = UDim2.fromOffset(420,18)
Subtitle.TextColor3 = Theme.Sub

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(40,40)
Close.Position = UDim2.new(1,-56,0,16)
Close.BackgroundColor3 = Theme.Card
Close.BackgroundTransparency = .22
Close.Text = "×"
Close.TextColor3 = Theme.Text
Close.TextSize = 24
Close.Font = Enum.Font.GothamBold
Close.AutoButtonColor = false
Close.Parent = Top
corner(Close, 13)

local Body = Instance.new("Frame")
Body.Position = UDim2.new(0,10,0,72)
Body.Size = UDim2.new(1,-20,1,-82)
Body.BackgroundTransparency = 1
Body.Parent = Main

local Tabs = Instance.new("ScrollingFrame")
Tabs.Name = "Tabs"
Tabs.Size = UDim2.new(0,176,1,0)
Tabs.BackgroundColor3 = Theme.Panel
Tabs.BackgroundTransparency = .30
Tabs.BorderSizePixel = 0
Tabs.ScrollBarThickness = 0
Tabs.ScrollingDirection = Enum.ScrollingDirection.Y
Tabs.AutomaticCanvasSize = Enum.AutomaticSize.Y
Tabs.CanvasSize = UDim2.new()
Tabs.Parent = Body
corner(Tabs, 18)
stroke(Tabs, .55)

local TabContent = Instance.new("Frame")
TabContent.Size = UDim2.new(1,-4,0,0)
TabContent.BackgroundTransparency = 1
TabContent.Parent = Tabs

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0,7)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.Parent = TabContent

local PagesFrame = Instance.new("Frame")
PagesFrame.Position = UDim2.new(0,186,0,0)
PagesFrame.Size = UDim2.new(1,-186,1,0)
PagesFrame.BackgroundTransparency = 1
PagesFrame.Parent = Body

local Search = Instance.new("TextBox")
Search.Size = UDim2.new(1,-6,0,42)
Search.Position = UDim2.new(0,3,0,0)
Search.BackgroundColor3 = Theme.Panel
Search.BackgroundTransparency = .30
Search.BorderSizePixel = 0
Search.PlaceholderText = "🔎  Gõ vào đây để tìm kiếm kỹ năng"
Search.PlaceholderColor3 = Theme.Sub
Search.Text = ""
Search.TextColor3 = Theme.Text
Search.TextSize = 13
Search.Font = Enum.Font.Gotham
Search.ClearTextOnFocus = false
Search.Parent = PagesFrame
corner(Search, 14)
stroke(Search, .62)

local PageArea = Instance.new("Frame")
PageArea.Position = UDim2.new(0,0,0,50)
PageArea.Size = UDim2.new(1,0,1,-50)
PageArea.BackgroundTransparency = 1
PageArea.Parent = PagesFrame

local HUD = label(Gui, "", 11, false)
HUD.AnchorPoint = Vector2.new(1,0)
HUD.Position = UDim2.new(1,-16,0,16)
HUD.Size = UDim2.fromOffset(420,62)
HUD.TextXAlignment = Enum.TextXAlignment.Right
HUD.TextColor3 = Theme.Accent2
HUD.Font = Enum.Font.Code
HUD.ZIndex = 70

--==========================================================
-- TABS
--==========================================================
local TabData = {
    {"⚔","Combat"},
    {"🎯","Aim Training"},
    {"👁","ESP / Debug"},
    {"👤","Players"},
    {"🚀","Movement"},
    {"🪽","Fly & Glide"},
    {"🌎","World"},
    {"🌀","Server"},
    {"🎭","Troll / Admin"},
    {"✨","Effects"},
    {"📷","Camera"},
    {"🛠","Debug"},
    {"📊","Stats"},
    {"⚙","Settings"},
}

--==========================================================
-- FEATURE REGISTRY
--==========================================================
local function add(name, tab, icon, description, kind, default, minValue, maxValue, step, handler, keywords)
    local f = {
        Name=name, Tab=tab, Icon=icon or "◆", Description=description,
        Kind=kind or "Toggle", Default=default, Min=minValue, Max=maxValue,
        Step=step or 1, Handler=handler, Keywords=keywords or {}
    }
    table.insert(Features, f)
    State[name] = default
    return f
end

--==========================================================
-- CORE FUNCTIONS TỪ BẢN 2
--==========================================================
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump or Config.DoubleJump then
        local hum = getHumanoid()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.RenderStepped:Connect(function()
    local hum = getHumanoid()
    if hum and Settings.HighJump then hum.JumpPower = Settings.JumpPower end
    if Settings.Fullbright then
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = OriginalAmbient
    end
    if Settings.FOVChanger then Camera.FieldOfView = Settings.FOVValue end
    if Settings.GravityMod then Workspace.Gravity = Settings.GravityValue
    else Workspace.Gravity = OriginalGravity end
    if Settings.SpinBot and getRoot() then
        getRoot().CFrame = getRoot().CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
    end
    if Settings.Bhop then
        local h = getHumanoid()
        if h and h.FloorMaterial \~= Enum.Material.Air then
            h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local function SetTouchTP(state)
    Settings.TouchTP = state
    if TouchTPConn then TouchTPConn:Disconnect() TouchTPConn = nil end
    if state then
        TouchTPConn = UserInputService.InputBegan:Connect(function(input, gp)
            if not gp and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                if Settings.TouchTP and Mouse.Hit then
                    local root = getRoot()
                    if root then root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0,3.5,0)) end
                end
            end
        end)
    end
end

local function SetWaterWalk(state)
    Settings.WaterWalk = state
    if WaterConn then WaterConn:Disconnect() WaterConn = nil end
    if state then
        WaterConn = RunService.RenderStepped:Connect(function()
            local root = getRoot()
            if root then
                local ray = Ray.new(root.Position, Vector3.new(0,-6,0))
                local hit, pos, _, mat = Workspace:FindPartOnRay(ray, getCharacter())
                if mat == Enum.Material.Water then
                    root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
                    root.CFrame = CFrame.new(root.Position.X, pos.Y + 3.2, root.Position.Z)
                end
            end
        end)
    end
end

local function SetSpiderClimb(state)
    Settings.SpiderClimb = state
    if SpiderConn then SpiderConn:Disconnect() SpiderConn = nil end
    if state then
        SpiderConn = RunService.RenderStepped:Connect(function()
            local root = getRoot()
            if root then
                local ray = Ray.new(root.Position, root.CFrame.LookVector * 3)
                local hit = Workspace:FindPartOnRay(ray, getCharacter())
                if hit then
                    root.Velocity = Vector3.new(root.Velocity.X, Settings.SpiderSpeed, root.Velocity.Z)
                end
            end
        end)
    end
end

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

local function SetBringNPC(state)
    Settings.BringNPC = state
    if not state then return end
    task.spawn(function()
        while Settings.BringNPC do
            local myRoot = getRoot()
            if myRoot then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj \~= getCharacter() then
                        local hum = obj:FindFirstChildOfClass("Humanoid")
                        local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                        if hum and root and hum.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
                            root.CFrame = myRoot.CFrame * CFrame.new(0,0,-4)
                            root.Velocity = Vector3.zero
                        end
                    end
                end
            end
            task.wait(0.12)
        end
    end)
end

local function SetChatSpammer(state)
    Settings.ChatSpammer = state
    if SpamConn then pcall(task.cancel, SpamConn) SpamConn = nil end
    if state then
        SpamConn = task.spawn(function()
            while Settings.ChatSpammer do
                pcall(function()
                    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                        TextChatService.TextChannels.RBXGeneral:SendAsync(Settings.SpamMessage)
                    else
                        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Settings.SpamMessage, "All")
                    end
                end)
                task.wait(Settings.SpamDelay)
            end
        end)
    end
end

local function SetTargetStrafe(state)
    Settings.TargetStrafe = state
    if StrafeConn then StrafeConn:Disconnect() StrafeConn = nil end
    if state then
        local angle = 0
        StrafeConn = RunService.RenderStepped:Connect(function()
            local myRoot = getRoot()
            if not myRoot then return end
            local target, minDist = nil, 9999
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (plr.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
                    if dist < minDist then minDist = dist target = plr.Character.HumanoidRootPart end
                end
            end
            if target and minDist <= 50 then
                angle = angle + math.rad(Settings.StrafeSpeed)
                local offset = Vector3.new(math.cos(angle)*Settings.StrafeDistance, 0, math.sin(angle)*Settings.StrafeDistance)
                myRoot.CFrame = CFrame.new(target.Position + offset, target.Position)
            end
        end)
    end
end

local function SetGlowTrail(state)
    Settings.GlowTrail = state
    local char = getCharacter()
    if not char then return end
    if state then
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local a0 = Instance.new("Attachment", root) a0.Name = "TrailA0" a0.Position = Vector3.new(0,-2.2,0)
        local a1 = Instance.new("Attachment", root) a1.Name = "TrailA1" a1.Position = Vector3.new(0,-2.0,0)
        local trail = Instance.new("Trail")
        trail.Name = "PlayerGlowTrail"
        trail.Attachment0 = a0 trail.Attachment1 = a1
        trail.Lifetime = 0.8
        trail.Color = ColorSequence.new(Theme.Accent, Theme.Accent2)
        trail.Transparency = NumberSequence.new(0.1, 1)
        trail.Parent = char
    else
        pcall(function()
            if char:FindFirstChild("PlayerGlowTrail") then char.PlayerGlowTrail:Destroy() end
            if char:FindFirstChild("HumanoidRootPart") then
                if char.HumanoidRootPart:FindFirstChild("TrailA0") then char.HumanoidRootPart.TrailA0:Destroy() end
                if char.HumanoidRootPart:FindFirstChild("TrailA1") then char.HumanoidRootPart.TrailA1:Destroy() end
            end
        end)
    end
end

-- Hitbox
RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character then
            local char = plr.Character
            local head = char:FindFirstChild("Head")
            if head then
                if Settings.HitboxHead then
                    head.Size = Vector3.new(Settings.HeadSize, Settings.HeadSize, Settings.HeadSize)
                    head.Transparency = Settings.HitboxTransparent
                    head.CanCollide = false
                else
                    head.Size = Vector3.new(2,1,1)
                    head.Transparency = 0
                end
            end
            local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            if torso then
                if Settings.HitboxTorso then
                    torso.Size = Settings.TorsoSize
                    torso.Transparency = Settings.HitboxTransparent
                    torso.CanCollide = false
                else
                    torso.Size = Vector3.new(2,2,1)
                    torso.Transparency = 0
                end
            end
            if Settings.HitboxLimb then
                for _, name in ipairs({"Left Arm","Right Arm","Left Leg","Right Leg","LeftLowerArm","RightLowerArm","LeftLowerLeg","RightLowerLeg"}) do
                    local limb = char:FindFirstChild(name)
                    if limb and limb:IsA("BasePart") then
                        limb.Size = Vector3.new(Settings.LimbSize, Settings.LimbSize, Settings.LimbSize)
                        limb.Transparency = Settings.HitboxTransparent
                        limb.CanCollide = false
                    end
                end
            end
            if Settings.HitboxWeapon then
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        for _, part in ipairs(tool:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.Size = Vector3.new(Settings.WeaponSize, Settings.WeaponSize, Settings.WeaponSize)
                                part.Transparency = Settings.HitboxTransparent
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Drawing
local DrawingSupported = false
local FOVCircle, CrosshairV, CrosshairH

pcall(function()
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1.5
    FOVCircle.NumSides = 64
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Filled = false
    FOVCircle.Visible = false
    FOVCircle.Color = Theme.Accent
    CrosshairV = Drawing.new("Line")
    CrosshairH = Drawing.new("Line")
    DrawingSupported = true
end)

local function GetClosestPlayerHead()
    local closest, shortest = nil, Settings.AimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
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

pcall(function()
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if not checkcaller() and Settings.SilentAim and self == Mouse and tostring(key) == "Hit" then
            local target = GetClosestPlayerHead()
            if target then return target.CFrame end
        end
        return oldIndex(self, key)
    end)
end)

RunService.RenderStepped:Connect(function()
    if not DrawingSupported then return end
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Position = center
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Visible = Settings.Aimbot or Settings.SilentAim
    if Settings.CustomCrosshair then
        local s = Settings.CrosshairSize
        CrosshairV.From = Vector2.new(center.X, center.Y - s)
        CrosshairV.To = Vector2.new(center.X, center.Y + s)
        CrosshairV.Color = Theme.Accent
        CrosshairV.Thickness = 2
        CrosshairV.Visible = true
        CrosshairH.From = Vector2.new(center.X - s, center.Y)
        CrosshairH.To = Vector2.new(center.X + s, center.Y)
        CrosshairH.Color = Theme.Accent
        CrosshairH.Thickness = 2
        CrosshairH.Visible = true
    else
        CrosshairV.Visible = false
        CrosshairH.Visible = false
    end
    if Settings.Aimbot then
        local target = GetClosestPlayerHead()
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), Settings.AimbotSmooth)
        end
    end
end)

-- ESP + Chams
RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character then
            if Settings.Chams then
                if not ChamsObjects[plr] then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ZakaChams"
                    hl.FillColor = Settings.ChamsColor
                    hl.OutlineColor = Color3.fromRGB(255,255,255)
                    hl.FillTransparency = 0.35
                    hl.Parent = plr.Character
                    ChamsObjects[plr] = hl
                end
            else
                if ChamsObjects[plr] then ChamsObjects[plr]:Destroy() ChamsObjects[plr] = nil end
            end
        end
    end
    if not Settings.ESP or not DrawingSupported then
        for _, drawings in pairs(ESPObjects) do
            for _, d in pairs(drawings) do pcall(function() d.Visible = false end) end
        end
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if not ESPObjects[plr] then
            local ok, box = pcall(Drawing.new, "Square")
            local ok2, name = pcall(Drawing.new, "Text")
            local ok3, health = pcall(Drawing.new, "Text")
            local ok4, dist = pcall(Drawing.new, "Text")
            if ok and ok2 and ok3 and ok4 then
                ESPObjects[plr] = {Box=box, Name=name, Health=health, Distance=dist}
                box.Filled = false
                name.Size = 12 name.Center = true name.Outline = true
                health.Size = 11 health.Center = true health.Outline = true
                dist.Size = 11 dist.Center = true dist.Outline = true
            end
        end
        local drawings = ESPObjects[plr]
        if not drawings then continue end
        local char = plr.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
            for _, d in pairs(drawings) do pcall(function() d.Visible = false end) end
            continue
        end
        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local dist = (root.Position - Camera.CFrame.Position).Magnitude
        if not onScreen or dist > Settings.ESPMaxDist then
            for _, d in pairs(drawings) do pcall(function() d.Visible = false end) end
            continue
        end
        local size = Vector2.new(math.clamp(2000/pos.Z, 8, 300), math.clamp(3000/pos.Z, 12, 450))
        drawings.Box.Size = size
        drawings.Box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
        drawings.Box.Color = Theme.Accent
        drawings.Box.Visible = Settings.ESPBox
        drawings.Name.Text = plr.Name
        drawings.Name.Position = Vector2.new(pos.X, pos.Y - size.Y/2 - 14)
        drawings.Name.Color = Color3.fromRGB(240,245,255)
        drawings.Name.Visible = Settings.ESPName
        drawings.Health.Text = math.floor(hum.Health) .. " HP"
        drawings.Health.Position = Vector2.new(pos.X, pos.Y + size.Y/2 + 2)
        drawings.Health.Visible = Settings.ESPHealth
        drawings.Distance.Text = math.floor(dist) .. "m"
        drawings.Distance.Position = Vector2.new(pos.X, pos.Y + size.Y/2 + 14)
        drawings.Distance.Visible = Settings.ESPDistance
    end
end)

-- Fly / Speed / Noclip
local function StartFly()
    local root = getRoot()
    if not root then return end
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 9e4
    BodyGyro.maxTorque = Vector3.new(9e9,9e9,9e9)
    BodyGyro.cframe = root.CFrame
    BodyGyro.Parent = root
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.velocity = Vector3.zero
    BodyVelocity.maxForce = Vector3.new(9e9,9e9,9e9)
    BodyVelocity.Parent = root
    FlyConn = RunService.RenderStepped:Connect(function()
        if not Settings.Fly or not getCharacter() or not getHumanoid() then
            if BodyGyro then BodyGyro:Destroy() end
            if BodyVelocity then BodyVelocity:Destroy() end
            if FlyConn then FlyConn:Disconnect() end
            return
        end
        BodyGyro.cframe = Camera.CFrame
        local moveDir = getHumanoid().MoveDirection
        if moveDir.Magnitude > 0 then
            local flyVector = (Camera.CFrame.LookVector * (moveDir.Z * -1)) + (Camera.CFrame.RightVector * moveDir.X)
            BodyVelocity.velocity = flyVector.Unit * Settings.FlySpeed
        else
            BodyVelocity.velocity = Vector3.zero
        end
    end)
end

local function SetFly(state)
    Settings.Fly = state
    if state then StartFly()
    else
        if BodyGyro then BodyGyro:Destroy() end
        if BodyVelocity then BodyVelocity:Destroy() end
        if FlyConn then FlyConn:Disconnect() end
    end
end

local function SetSpeed(state)
    if SpeedConn then SpeedConn:Disconnect() SpeedConn = nil end
    if state then
        SpeedConn = RunService.Heartbeat:Connect(function()
            local hum = getHumanoid()
            if hum then hum.WalkSpeed = Settings.SpeedValue end
        end)
    else
        local hum = getHumanoid()
        if hum then hum.WalkSpeed = 16 end
    end
end

local function SetNoclip(state)
    if NoclipConn then NoclipConn:Disconnect() NoclipConn = nil end
    if state then
        NoclipConn = RunService.Stepped:Connect(function()
            local char = getCharacter()
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end
end

--==========================================================
-- THÊM CHỨC NĂNG VÀO FEATURES
--==========================================================
add("Aimbot Lock Head","Combat","🎯","Khóa đầu người chơi gần nhất trong FOV.","Toggle",false,nil,nil,nil,function(v) Settings.Aimbot=v end,{"aimbot"})
add("Silent Aim","Combat","👁","Silent Aim qua metamethod.","Toggle",false,nil,nil,nil,function(v) Settings.SilentAim=v end,{"silent"})
add("Auto Clicker","Combat","🖱","Tự động click.","Toggle",false,nil,nil,nil,function(v) SetAutoClicker(v) end,{"clicker"})
add("Target Strafe","Combat","🔄","Xoay vòng quanh mục tiêu.","Toggle",false,nil,nil,nil,function(v) SetTargetStrafe(v) end,{"strafe"})
add("SpinBot","Combat","🌀","Xoay nhân vật liên tục.","Toggle",false,nil,nil,nil,function(v) Settings.SpinBot=v end,{"spin"})
add("Hitbox Head","Combat","🧠","Mở rộng hitbox đầu.","Toggle",false,nil,nil,nil,function(v) Settings.HitboxHead=v end,{"hitbox"})
add("Hitbox Torso","Combat","📦","Mở rộng hitbox thân.","Toggle",false,nil,nil,nil,function(v) Settings.HitboxTorso=v end,{"hitbox"})
add("Hitbox Limb","Combat","🦵","Mở rộng hitbox tay chân.","Toggle",false,nil,nil,nil,function(v) Settings.HitboxLimb=v end,{"hitbox"})
add("Hitbox Weapon","Combat","🗡","Mở rộng hitbox vũ khí.","Toggle",false,nil,nil,nil,function(v) Settings.HitboxWeapon=v end,{"hitbox"})

add("ESP Box","ESP / Debug","▣","Khung ESP người chơi.","Toggle",false,nil,nil,nil,function(v) Settings.ESP=v end,{"esp"})
add("Chams","ESP / Debug","✨","Highlight / Wallhack.","Toggle",false,nil,nil,nil,function(v) Settings.Chams=v end,{"chams"})
add("Custom Crosshair","Aim Training","⊕","Tâm ngắm tùy chỉnh.","Toggle",false,nil,nil,nil,function(v) Settings.CustomCrosshair=v end,{"crosshair"})
add("Glow Trail","Effects","💫","Vệt sáng sau lưng.","Toggle",false,nil,nil,nil,function(v) SetGlowTrail(v) end,{"trail"})
add("Fullbright","World","☀","Sáng toàn map.","Toggle",false,nil,nil,nil,function(v) Settings.Fullbright=v end,{"fullbright"})
add("FOV Changer","Camera","🔭","Đổi góc nhìn.","Toggle",false,nil,nil,nil,function(v) Settings.FOVChanger=v end,{"fov"})

add("Speed Walk","Movement","🏃","Tăng tốc chạy.","Toggle",false,nil,nil,nil,function(v) Settings.Speed=v SetSpeed(v) end,{"speed"})
add("Fly","Fly & Glide","🪽","Bay tự do.","Toggle",false,nil,nil,nil,function(v) SetFly(v) end,{"fly"})
add("Noclip","Movement","👻","ĐDưới đây là **bản gộp hoàn chỉnh** (UI Bản 1 + toàn bộ chức năng Bản 2).

Script đã được tối ưu để chạy ổn định trên Delta, có bảo vệ `pcall` cho Drawing và `hookmetamethod`.

```lua
--[[
============================================================
        ZAKA PURE UI - MERGED COMPLETE
        Giao diện Bản 1 (Glass + Eye + Carousel + Search)
        + Toàn bộ chức năng Bản 2 (Aimbot, ESP, Hitbox, Fly...)
============================================================
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local Debris = game:GetService("Debris")
local VirtualUser = game:GetService("VirtualUser")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Cleanup
pcall(function()
    for _, n in ipairs({"ZAKA_PURE_V1","ZAKA_PURE_V6","ZakaPureUI","ZakaNarutoUI"}) do
        local o = PlayerGui:FindFirstChild(n)
        if o then o:Destroy() end
    end
    for _, n in ipairs({"ZAKA_UI_BLUR_V1","ZAKA_GLOW_V1","ZAKA_NIGHT_VISION_V1"}) do
        local o = Lighting:FindFirstChild(n)
        if o then o:Destroy() end
    end
end)

--==========================================================
-- CONFIG + THEME
--==========================================================
local Config = {
    Theme = "Cyber",
    UITransparency = 0.28,
    UIScale = 1,
    Blur = 10,
    AnimationSpeed = 1,
    FPS = true,
    Coordinates = true,
    Velocity = true,
    MenuPosition = UDim2.fromScale(0.5, 0.5),
    OpenButtonPosition = UDim2.new(0, 18, 0.5, -32),
    Open = false,
}

local Themes = {
    Cyber = {
        Background = Color3.fromRGB(7,11,20),
        Panel = Color3.fromRGB(12,18,30),
        Card = Color3.fromRGB(18,28,44),
        Accent = Color3.fromRGB(75,185,255),
        Accent2 = Color3.fromRGB(150,235,255),
        Text = Color3.fromRGB(240,248,255),
        Sub = Color3.fromRGB(145,165,190),
        Border = Color3.fromRGB(75,175,230),
    },
    Purple = {
        Background = Color3.fromRGB(12,8,20),
        Panel = Color3.fromRGB(22,13,35),
        Card = Color3.fromRGB(34,20,52),
        Accent = Color3.fromRGB(185,110,255),
        Accent2 = Color3.fromRGB(230,175,255),
        Text = Color3.fromRGB(248,240,255),
        Sub = Color3.fromRGB(180,150,205),
        Border = Color3.fromRGB(180,110,255),
    },
    Ice = {
        Background = Color3.fromRGB(6,15,22),
        Panel = Color3.fromRGB(10,27,37),
        Card = Color3.fromRGB(16,41,53),
        Accent = Color3.fromRGB(95,220,255),
        Accent2 = Color3.fromRGB(190,250,255),
        Text = Color3.fromRGB(240,253,255),
        Sub = Color3.fromRGB(145,190,205),
        Border = Color3.fromRGB(95,205,240),
    },
}
local Theme = Themes[Config.Theme]

--==========================================================
-- SETTINGS (chức năng thật từ Bản 2)
--==========================================================
local Settings = {
    Aimbot = false, AimbotFOV = 120, AimbotSmooth = 0.25, SilentAim = false,
    AutoClicker = false, ClickDelay = 0.05, TargetStrafe = false,
    StrafeDistance = 12, StrafeSpeed = 6, SpinBot = false, SpinSpeed = 45,
    HitboxHead = false, HeadSize = 15, HitboxTorso = false,
    TorsoSize = Vector3.new(4,6,4), HitboxWeapon = false, WeaponSize = 5,
    HitboxTransparent = 0.5, HitboxLimb = false, LimbSize = 4,
    ESP = false, ESPBox = true, ESPName = true, ESPHealth = true,
    ESPDistance = true, ESPMaxDist = 3500, Chams = false,
    ChamsColor = Color3.fromRGB(0,200,255), CustomCrosshair = false,
    CrosshairSize = 12, GlowTrail = false, Fullbright = false,
    FOVChanger = false, FOVValue = 90,
    Speed = false, SpeedValue = 26, Fly = false, FlySpeed = 50,
    Noclip = false, InfiniteJump = false, HighJump = false, JumpPower = 100,
    Bhop = false, SpiderClimb = false, SpiderSpeed = 30, WaterWalk = false,
    TouchTP = false, BringNPC = false, GravityMod = false, GravityValue = 196.2,
    ChatSpammer = false, SpamMessage = "Zaka Pure UI Merged", SpamDelay = 2,
}

local NoclipConn, SpeedConn, FlyConn, TouchTPConn, AutoClickConn, SpamConn, StrafeConn, WaterConn, SpiderConn
local BodyGyro, BodyVelocity
local ESPObjects, ChamsObjects = {}, {}
local OriginalAmbient = Lighting.Ambient
local OriginalGravity = Workspace.Gravity

--==========================================================
-- HELPERS
--==========================================================
local Features, State, Connections = {}, {}, {}
local Runtime = {Cards = {}, TabButtons = {}, Pages = {}, CurrentTab = "Combat"}
local notify

local function connect(sig, fn)
    local c = sig:Connect(fn)
    table.insert(Connections, c)
    return c
end

local function getChar() return LocalPlayer.Character end
local function getHum() local c = getChar() return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot() local c = getChar() return c and c:FindFirstChild("HumanoidRootPart") end

local function tween(obj, t, props, style, dir)
    local info = TweenInfo.new(t / math.max(Config.AnimationSpeed, 0.05), style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
    return c
end

local function stroke(obj, trans)
    local s = Instance.new("UIStroke")
    s.Color = Theme.Border
    s.Thickness = 1
    s.Transparency = trans or 0.5
    s.Parent = obj
    return s
end

local function label(parent, text, size, bold)
    local x = Instance.new("TextLabel")
    x.BackgroundTransparency = 1
    x.Text = text
    x.TextColor3 = Theme.Text
    x.TextSize = size
    x.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    x.TextXAlignment = Enum.TextXAlignment.Left
    x.Parent = parent
    return x
end

--==========================================================
-- CORE FUNCTIONS
--==========================================================
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        local h = getHum()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.RenderStepped:Connect(function()
    local h = getHum()
    if h and Settings.HighJump then h.JumpPower = Settings.JumpPower end

    if Settings.Fullbright then
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = OriginalAmbient
    end

    if Settings.FOVChanger then Camera.FieldOfView = Settings.FOVValue end
    if Settings.GravityMod then Workspace.Gravity = Settings.GravityValue else Workspace.Gravity = OriginalGravity end

    if Settings.SpinBot and getRoot() then
        getRoot().CFrame = getRoot().CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
    end

    if Settings.Bhop then
        local hum = getHum()
        if hum and hum.FloorMaterial \~= Enum.Material.Air then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local function SetTouchTP(v)
    Settings.TouchTP = v
    if TouchTPConn then TouchTPConn:Disconnect() TouchTPConn = nil end
    if v then
        TouchTPConn = UserInputService.InputBegan:Connect(function(i, gp)
            if not gp and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
                if Settings.TouchTP and Mouse.Hit and getRoot() then
                    getRoot().CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3.5, 0))
                end
            end
        end)
    end
end

local function SetWaterWalk(v)
    Settings.WaterWalk = v
    if WaterConn then WaterConn:Disconnect() WaterConn = nil end
    if v then
        WaterConn = RunService.RenderStepped:Connect(function()
            local root = getRoot()
            if root then
                local ray = Ray.new(root.Position, Vector3.new(0, -6, 0))
                local _, pos, _, mat = Workspace:FindPartOnRay(ray, getChar())
                if mat == Enum.Material.Water then
                    root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
                    root.CFrame = CFrame.new(root.Position.X, pos.Y + 3.2, root.Position.Z)
                end
            end
        end)
    end
end

local function SetSpiderClimb(v)
    Settings.SpiderClimb = v
    if SpiderConn then SpiderConn:Disconnect() SpiderConn = nil end
    if v then
        SpiderConn = RunService.RenderStepped:Connect(function()
            local root = getRoot()
            if root then
                local ray = Ray.new(root.Position, root.CFrame.LookVector * 3)
                if Workspace:FindPartOnRay(ray, getChar()) then
                    root.Velocity = Vector3.new(root.Velocity.X, Settings.SpiderSpeed, root.Velocity.Z)
                end
            end
        end)
    end
end

local function SetAutoClicker(v)
    Settings.AutoClicker = v
    if AutoClickConn then AutoClickConn:Disconnect() AutoClickConn = nil end
    if v then
        AutoClickConn = RunService.RenderStepped:Connect(function()
            if Settings.AutoClicker then
                VirtualUser:Button1Down(Vector2.new())
                task.wait(Settings.ClickDelay)
                VirtualUser:Button1Up(Vector2.new())
            end
        end)
    end
end

local function SetBringNPC(v)
    Settings.BringNPC = v
    if not v then return end
    task.spawn(function()
        while Settings.BringNPC do
            local my = getRoot()
            if my then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj \~= getChar() then
                        local hum = obj:FindFirstChildOfClass("Humanoid")
                        local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                        if hum and root and hum.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
                            root.CFrame = my.CFrame * CFrame.new(0, 0, -4)
                            root.Velocity = Vector3.zero
                        end
                    end
                end
            end
            task.wait(0.12)
        end
    end)
end

local function SetChatSpammer(v)
    Settings.ChatSpammer = v
    if SpamConn then pcall(task.cancel, SpamConn) SpamConn = nil end
    if v then
        SpamConn = task.spawn(function()
            while Settings.ChatSpammer do
                pcall(function()
                    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                        TextChatService.TextChannels.RBXGeneral:SendAsync(Settings.SpamMessage)
                    else
                        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Settings.SpamMessage, "All")
                    end
                end)
                task.wait(Settings.SpamDelay)
            end
        end)
    end
end

local function SetTargetStrafe(v)
    Settings.TargetStrafe = v
    if StrafeConn then StrafeConn:Disconnect() StrafeConn = nil end
    if v then
        local angle = 0
        StrafeConn = RunService.RenderStepped:Connect(function()
            local my = getRoot()
            if not my then return end
            local target, minD = nil, 9999
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (plr.Character.HumanoidRootPart.Position - my.Position).Magnitude
                    if d < minD then minD = d target = plr.Character.HumanoidRootPart end
                end
            end
            if target and minD <= 50 then
                angle = angle + math.rad(Settings.StrafeSpeed)
                local off = Vector3.new(math.cos(angle) * Settings.StrafeDistance, 0, math.sin(angle) * Settings.StrafeDistance)
                my.CFrame = CFrame.new(target.Position + off, target.Position)
            end
        end)
    end
end

local function SetGlowTrail(v)
    Settings.GlowTrail = v
    local char = getChar()
    if not char then return end
    if v then
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local a0 = Instance.new("Attachment", root) a0.Name = "TrailA0" a0.Position = Vector3.new(0, -2.2, 0)
        local a1 = Instance.new("Attachment", root) a1.Name = "TrailA1" a1.Position = Vector3.new(0, -2.0, 0)
        local trail = Instance.new("Trail")
        trail.Name = "PlayerGlowTrail"
        trail.Attachment0 = a0
        trail.Attachment1 = a1
        trail.Lifetime = 0.8
        trail.Color = ColorSequence.new(Theme.Accent, Theme.Accent2)
        trail.Transparency = NumberSequence.new(0.1, 1)
        trail.Parent = char
    else
        pcall(function()
            if char:FindFirstChild("PlayerGlowTrail") then char.PlayerGlowTrail:Destroy() end
            if char:FindFirstChild("HumanoidRootPart") then
                if char.HumanoidRootPart:FindFirstChild("TrailA0") then char.HumanoidRootPart.TrailA0:Destroy() end
                if char.HumanoidRootPart:FindFirstChild("TrailA1") then char.HumanoidRootPart.TrailA1:Destroy() end
            end
        end)
    end
end

-- Hitbox
RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character then
            local char = plr.Character
            local head = char:FindFirstChild("Head")
            if head then
                if Settings.HitboxHead then
                    head.Size = Vector3.new(Settings.HeadSize, Settings.HeadSize, Settings.HeadSize)
                    head.Transparency = Settings.HitboxTransparent
                    head.CanCollide = false
                else
                    head.Size = Vector3.new(2, 1, 1)
                    head.Transparency = 0
                end
            end
            local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            if torso then
                if Settings.HitboxTorso then
                    torso.Size = Settings.TorsoSize
                    torso.Transparency = Settings.HitboxTransparent
                    torso.CanCollide = false
                else
                    torso.Size = Vector3.new(2, 2, 1)
                    torso.Transparency = 0
                end
            end
            if Settings.HitboxLimb then
                for _, n in ipairs({"Left Arm","Right Arm","Left Leg","Right Leg","LeftLowerArm","RightLowerArm","LeftLowerLeg","RightLowerLeg"}) do
                    local limb = char:FindFirstChild(n)
                    if limb and limb:IsA("BasePart") then
                        limb.Size = Vector3.new(Settings.LimbSize, Settings.LimbSize, Settings.LimbSize)
                        limb.Transparency = Settings.HitboxTransparent
                        limb.CanCollide = false
                    end
                end
            end
            if Settings.HitboxWeapon then
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        for _, p in ipairs(tool:GetDescendants()) do
                            if p:IsA("BasePart") then
                                p.Size = Vector3.new(Settings.WeaponSize, Settings.WeaponSize, Settings.WeaponSize)
                                p.Transparency = Settings.HitboxTransparent
                                p.CanCollide = false
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Drawing
local DrawingOK = false
local FOVCircle, CrossV, CrossH

pcall(function()
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1.5
    FOVCircle.NumSides = 64
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Filled = false
    FOVCircle.Visible = false
    FOVCircle.Color = Theme.Accent
    CrossV = Drawing.new("Line")
    CrossH = Drawing.new("Line")
    DrawingOK = true
end)

local function ClosestHead()
    local best, short = nil, Settings.AimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local sp, on = Camera:WorldToViewportPoint(head.Position)
                if on then
                    local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                    if d < short then short = d best = head end
                end
            end
        end
    end
    return best
end

pcall(function()
    local old
    old = hookmetamethod(game, "__index", function(self, key)
        if not checkcaller() and Settings.SilentAim and self == Mouse and tostring(key) == "Hit" then
            local t = ClosestHead()
            if t then return t.CFrame end
        end
        return old(self, key)
    end)
end)

RunService.RenderStepped:Connect(function()
    if not DrawingOK then return end
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Position = center
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Visible = Settings.Aimbot or Settings.SilentAim

    if Settings.CustomCrosshair then
        local s = Settings.CrosshairSize
        CrossV.From = Vector2.new(center.X, center.Y - s)
        CrossV.To = Vector2.new(center.X, center.Y + s)
        CrossV.Color = Theme.Accent
        CrossV.Thickness = 2
        CrossV.Visible = true
        CrossH.From = Vector2.new(center.X - s, center.Y)
        CrossH.To = Vector2.new(center.X + s, center.Y)
        CrossH.Color = Theme.Accent
        CrossH.Thickness = 2
        CrossH.Visible = true
    else
        CrossV.Visible = false
        CrossH.Visible = false
    end

    if Settings.Aimbot then
        local t = ClosestHead()
        if t then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Position), Settings.AimbotSmooth)
        end
    end
end)

-- ESP + Chams
RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character then
            if Settings.Chams then
                if not ChamsObjects[plr] then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ZakaChams"
                    hl.FillColor = Settings.ChamsColor
                    hl.OutlineColor = Color3.fromRGB(255,255,255)
                    hl.FillTransparency = 0.35
                    hl.Parent = plr.Character
                    ChamsObjects[plr] = hl
                end
            else
                if ChamsObjects[plr] then ChamsObjects[plr]:Destroy() ChamsObjects[plr] = nil end
            end
        end
    end

    if not Settings.ESP or not DrawingOK then
        for _, d in pairs(ESPObjects) do for _, x in pairs(d) do pcall(function() x.Visible = false end) end end
        return
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if not ESPObjects[plr] then
            local ok1, box = pcall(Drawing.new, "Square")
            local ok2, name = pcall(Drawing.new, "Text")
            local ok3, hp = pcall(Drawing.new, "Text")
            local ok4, dist = pcall(Drawing.new, "Text")
            if ok1 and ok2 and ok3 and ok4 then
                ESPObjects[plr] = {Box = box, Name = name, Health = hp, Distance = dist}
                box.Filled = false
                name.Size = 12 name.Center = true name.Outline = true
                hp.Size = 11 hp.Center = true hp.Outline = true
                dist.Size = 11 dist.Center = true dist.Outline = true
            end
        end
        local d = ESPObjects[plr]
        if not d then continue end
        local char = plr.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
            for _, x in pairs(d) do pcall(function() x.Visible = false end) end
            continue
        end
        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        local pos, on = Camera:WorldToViewportPoint(root.Position)
        local dist = (root.Position - Camera.CFrame.Position).Magnitude
        if not on or dist > Settings.ESPMaxDist then
            for _, x in pairs(d) do pcall(function() x.Visible = false end) end
            continue
        end
        local size = Vector2.new(math.clamp(2000/pos.Z, 8, 300), math.clamp(3000/pos.Z, 12, 450))
        d.Box.Size = size
        d.Box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
        d.Box.Color = Theme.Accent
        d.Box.Visible = Settings.ESPBox
        d.Name.Text = plr.Name
        d.Name.Position = Vector2.new(pos.X, pos.Y - size.Y/2 - 14)
        d.Name.Color = Color3.fromRGB(240,245,255)
        d.Name.Visible = Settings.ESPName
        d.Health.Text = math.floor(hum.Health) .. " HP"
        d.Health.Position = Vector2.new(pos.X, pos.Y + size.Y/2 + 2)
        d.Health.Visible = Settings.ESPHealth
        d.Distance.Text = math.floor(dist) .. "m"
        d.Distance.Position = Vector2.new(pos.X, pos.Y + size.Y/2 + 14)
        d.Distance.Visible = Settings.ESPDistance
    end
end)

-- Fly / Speed / Noclip
local function StartFly()
    local root = getRoot()
    if not root then return end
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 9e4
    BodyGyro.maxTorque = Vector3.new(9e9,9e9,9e9)
    BodyGyro.cframe = root.CFrame
    BodyGyro.Parent = root
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.velocity = Vector3.zero
    BodyVelocity.maxForce = Vector3.new(9e9,9e9,9e9)
    BodyVelocity.Parent = root
    FlyConn = RunService.RenderStepped:Connect(function()
        if not Settings.Fly or not getChar() or not getHum() then
            if BodyGyro then BodyGyro:Destroy() end
            if BodyVelocity then BodyVelocity:Destroy() end
            if FlyConn then FlyConn:Disconnect() end
            return
        end
        BodyGyro.cframe = Camera.CFrame
        local md = getHum().MoveDirection
        if md.Magnitude > 0 then
            local fv = (Camera.CFrame.LookVector * (md.Z * -1)) + (Camera.CFrame.RightVector * md.X)
            BodyVelocity.velocity = fv.Unit * Settings.FlySpeed
        else
            BodyVelocity.velocity = Vector3.zero
        end
    end)
end

local function SetFly(v)
    Settings.Fly = v
    if v then StartFly()
    else
        if BodyGyro then BodyGyro:Destroy() end
        if BodyVelocity then BodyVelocity:Destroy() end
        if FlyConn then FlyConn:Disconnect() end
    end
end

local function SetSpeed(v)
    if SpeedConn then SpeedConn:Disconnect() SpeedConn = nil end
    if v then
        SpeedConn = RunService.Heartbeat:Connect(function()
            local h = getHum()
            if h then h.WalkSpeed = Settings.SpeedValue end
        end)
    else
        local h = getHum()
        if h then h.WalkSpeed = 16 end
    end
end

local function SetNoclip(v)
    if NoclipConn then NoclipConn:Disconnect() NoclipConn = nil end
    if v then
        NoclipConn = RunService.Stepped:Connect(function()
            local char = getChar()
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    end
end

--==========================================================
-- FEATURE REGISTRY
--==========================================================
local function add(name, tab, icon, desc, kind, default, minV, maxV, step, handler, keys)
    local f = {Name = name, Tab = tab, Icon = icon or "◆", Description = desc, Kind = kind or "Toggle", Default = default, Min = minV, Max = maxV, Step = step or 1, Handler = handler, Keywords = keys or {}}
    table.insert(Features, f)
    State[name] = default
    return f
end

-- Combat
add("Aimbot Lock Head", "Combat", "🎯", "Khóa đầu người chơi trong FOV", "Toggle", false, nil, nil, nil, function(v) Settings.Aimbot = v end, {"aimbot"})
add("Silent Aim", "Combat", "👁", "Silent Aim qua metamethod", "Toggle", false, nil, nil, nil, function(v) Settings.SilentAim = v end, {"silent"})
add("Auto Clicker", "Combat", "🖱", "Tự động click", "Toggle", false, nil, nil, nil, function(v) SetAutoClicker(v) end, {"clicker"})
add("Target Strafe", "Combat", "🔄", "Xoay quanh mục tiêu", "Toggle", false, nil, nil, nil, function(v) SetTargetStrafe(v) end, {"strafe"})
add("SpinBot", "Combat", "🌀", "Xoay nhân vật", "Toggle", false, nil, nil, nil, function(v) Settings.SpinBot = v end, {"spin"})

-- Hitbox
add("Hitbox Head", "Combat", "🧠", "Mở rộng hitbox đầu", "Toggle", false, nil, nil, nil, function(v) Settings.HitboxHead = v end, {"hitbox"})
add("Hitbox Torso", "Combat", "📦", "Mở rộng hitbox thân", "Toggle", false, nil, nil, nil, function(v) Settings.HitboxTorso = v end, {"hitbox"})
add("Hitbox Limb", "Combat", "🦵", "Mở rộng hitbox tay chân", "Toggle", false, nil, nil, nil, function(v) Settings.HitboxLimb = v end, {"hitbox"})
add("Hitbox Weapon", "Combat", "🗡", "Mở rộng hitbox vũ khí", "Toggle", false, nil, nil, nil, function(v) Settings.HitboxWeapon = v end, {"hitbox"})

-- ESP
add("ESP Box", "ESP / Debug", "▣", "Khung ESP", "Toggle", false, nil, nil, nil, function(v) Settings.ESP = v end, {"esp"})
add("Chams", "ESP / Debug", "✨", "Highlight / Wallhack", "Toggle", false, nil, nil, nil, function(v) Settings.Chams = v end, {"chams"})
add("Custom Crosshair", "Aim Training", "⊕", "Tâm ngắm", "Toggle", false, nil, nil, nil, function(v) Settings.CustomCrosshair = v end, {"crosshair"})
add("Glow Trail", "Effects", "💫", "Vệt sáng", "Toggle", false, nil, nil, nil, function(v) SetGlowTrail(v) end, {"trail"})
add("Fullbright", "World", "☀", "Sáng map", "Toggle", false, nil, nil, nil, function(v) Settings.Fullbright = v end, {"fullbright"})
add("FOV Changer", "Camera", "🔭", "Đổi FOV", "Toggle", false, nil, nil, nil, function(v) Settings.FOVChanger = v end, {"fov"})

-- Movement
add("Speed Walk", "Movement", "🏃", "Tăng tốc", "Toggle", false, nil, nil, nil, function(v) Settings.Speed = v SetSpeed(v) end, {"speed"})
add("Fly", "Fly & Glide", "🪽", "Bay", "Toggle", false, nil, nil, nil, function(v) SetFly(v) end, {"fly"})
add("Noclip", "Movement", "👻", "Xuyên tường", "Toggle", false, nil, nil, nil, function(v) Settings.Noclip = v SetNoclip(v) end, {"noclip"})
add("Infinite Jump", "Movement", "🦘", "Nhảy vô tận", "Toggle", false, nil, nil, nil, function(v) Settings.InfiniteJump = v end, {"jump"})
add("High Jump", "Movement", "⬆", "Nhảy cao", "Toggle", false, nil, nil, nil, function(v) Settings.HighJump = v end, {"jump"})
add("Bunny Hop", "Movement", "🐰", "Bhop", "Toggle", false, nil, nil, nil, function(v) Settings.Bhop = v end, {"bhop"})
add("Spider Climb", "Movement", "🕷", "Bám tường", "Toggle", false, nil, nil, nil, function(v) SetSpiderClimb(v) end, {"spider"})
add("Water Walk", "Movement", "💧", "Đi trên nước", "Toggle", false, nil, nil, nil, function(v) SetWaterWalk(v) end, {"water"})

-- World
add("Touch TP", "World", "👆", "Chạm tele", "Toggle", false, nil, nil, nil, function(v) SetTouchTP(v) end, {"tp"})
add("Bring NPC", "World", "👹", "Kéo NPC", "Toggle", false, nil, nil, nil, function(v) SetBringNPC(v) end, {"bring"})
add("Gravity Mod", "World", "🌎", "Chỉnh trọng lực", "Toggle", false, nil, nil, nil, function(v) Settings.GravityMod = v end, {"gravity"})

-- Troll
add("Chat Spammer", "Troll / Admin", "💬", "Spam chat", "Toggle", false, nil, nil, nil, function(v) SetChatSpammer(v) end, {"spam"})

-- Settings
add("Cyber Theme", "Settings", "🔵", "Theme Cyber", "Button", false, nil, nil, nil, function() Config.Theme = "Cyber" end, {"theme"})
add("Purple Theme", "Settings", "🟣", "Theme Purple", "Button", false, nil, nil, nil, function() Config.Theme = "Purple" end, {"theme"})
add("Ice Theme", "Settings", "❄", "Theme Ice", "Button", false, nil, nil, nil, function() Config.Theme = "Ice" end, {"theme"})

--==========================================================
-- GUI
--==========================================================
local Gui = Instance.new("ScreenGui")
Gui.Name = "ZAKA_PURE_V1"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local Blur = Instance.new("BlurEffect")
Blur.Name = "ZAKA_UI_BLUR_V1"
Blur.Size = 0
Blur.Parent = Lighting

local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.fromOffset(64, 64)
OpenButton.Position = Config.OpenButtonPosition
OpenButton.BackgroundColor3 = Theme.Panel
OpenButton.BackgroundTransparency = 0.04
OpenButton.Text = "Z"
OpenButton.TextColor3 = Theme.Text
OpenButton.TextSize = 28
OpenButton.Font = Enum.Font.GothamBlack
OpenButton.AutoButtonColor = false
OpenButton.ZIndex = 80
OpenButton.Parent = Gui
corner(OpenButton, 999)
stroke(OpenButton, 0.12)

local Main = Instance.new("Frame")
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = Config.MenuPosition
Main.Size = UDim2.fromOffset(0, 0)
Main.BackgroundColor3 = Theme.Background
Main.BackgroundTransparency = Config.UITransparency
Main.Visible = false
Main.ClipsDescendants = true
Main.ZIndex = 20
Main.Parent = Gui
corner(Main, 24)
stroke(Main, 0.1)

local UIScale = Instance.new("UIScale")
UIScale.Scale = Config.UIScale
UIScale.Parent = Main

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 72)
Top.BackgroundTransparency = 1
Top.Parent = Main

local Title = label(Top, "ZAKA PURE", 21, true)
Title.Position = UDim2.new(0, 22, 0, 10)
Title.Size = UDim2.fromOffset(300, 28)
Title.TextColor3 = Theme.Accent2

local Subtitle = label(Top, "V1 + V3 MERGED  •  FULL FEATURES", 10, false)
Subtitle.Position = UDim2.new(0, 23, 0, 40)
Subtitle.Size = UDim2.fromOffset(400, 18)
Subtitle.TextColor3 = Theme.Sub

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(40, 40)
Close.Position = UDim2.new(1, -56, 0, 16)
Close.BackgroundColor3 = Theme.Card
Close.BackgroundTransparency = 0.22
Close.Text = "×"
Close.TextColor3 = Theme.Text
Close.TextSize = 24
Close.Font = Enum.Font.GothamBold
Close.AutoButtonColor = false
Close.Parent = Top
corner(Close, 13)

local Body = Instance.new("Frame")
Body.Position = UDim2.new(0, 10, 0, 72)
Body.Size = UDim2.new(1, -20, 1, -82)
Body.BackgroundTransparency = 1
Body.Parent = Main

local Tabs = Instance.new("ScrollingFrame")
Tabs.Size = UDim2.new(0, 176, 1, 0)
Tabs.BackgroundColor3 = Theme.Panel
Tabs.BackgroundTransparency = 0.3
Tabs.BorderSizePixel = 0
Tabs.ScrollBarThickness = 0
Tabs.AutomaticCanvasSize = Enum.AutomaticSize.Y
Tabs.Parent = Body
corner(Tabs, 18)
stroke(Tabs, 0.55)

local TabContent = Instance.new("Frame")
TabContent.Size = UDim2.new(1, -4, 0, 0)
TabContent.BackgroundTransparency = 1
TabContent.Parent = Tabs

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 7)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.Parent = TabContent

local PagesFrame = Instance.new("Frame")
PagesFrame.Position = UDim2.new(0, 186, 0, 0)
PagesFrame.Size = UDim2.new(1, -186, 1, 0)
PagesFrame.BackgroundTransparency = 1
PagesFrame.Parent = Body

local Search = Instance.new("TextBox")
Search.Size = UDim2.new(1, -6, 0, 42)
Search.Position = UDim2.new(0, 3, 0, 0)
Search.BackgroundColor3 = Theme.Panel
Search.BackgroundTransparency = 0.3
Search.PlaceholderText = "🔎  Gõ để tìm kỹ năng"
Search.PlaceholderColor3 = Theme.Sub
Search.Text = ""
Search.TextColor3 = Theme.Text
Search.TextSize = 13
Search.Font = Enum.Font.Gotham
Search.ClearTextOnFocus = false
Search.Parent = PagesFrame
corner(Search, 14)
stroke(Search, 0.62)

local PageArea = Instance.new("Frame")
PageArea.Position = UDim2.new(0, 0, 0, 50)
PageArea.Size = UDim2.new(1, 0, 1, -50)
PageArea.BackgroundTransparency = 1
PageArea.Parent = PagesFrame

local HUD = label(Gui, "", 11, false)
HUD.AnchorPoint = Vector2.new(1, 0)
HUD.Position = UDim2.new(1, -16, 0, 16)
HUD.Size = UDim2.fromOffset(420, 62)
HUD.TextXAlignment = Enum.TextXAlignment.Right
HUD.TextColor3 = Theme.Accent2
HUD.Font = Enum.Font.Code
HUD.ZIndex = 70

-- Tabs
local TabData = {
    {"⚔", "Combat"},
    {"🎯", "Aim Training"},
    {"👁", "ESP / Debug"},
    {"🚀", "Movement"},
    {"🪽", "Fly & Glide"},
    {"🌎", "World"},
    {"🎭", "Troll / Admin"},
    {"✨", "Effects"},
    {"📷", "Camera"},
    {"⚙", "Settings"},
}

-- Card system
local function makeToggle(parent, feature)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(58, 34)
    b.BackgroundColor3 = Theme.Panel
    b.BackgroundTransparency = 0.08
    b.Text = ""
    b.AutoButtonColor = false
    b.Parent = parent
    corner(b, 17)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(26, 26)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.BackgroundColor3 = Theme.Sub
    knob.Parent = b
    corner(knob, 13)
    local function refresh()
        local on = State[feature.Name]
        b.BackgroundColor3 = on and Theme.Accent or Theme.Panel
        knob.Position = UDim2.new(0, on and 40 or 18, 0.5, 0)
        knob.BackgroundColor3 = on and Theme.Accent2 or Theme.Sub
    end
    refresh()
    b.Activated:Connect(function()
        State[feature.Name] = not State[feature.Name]
        refresh()
        if feature.Handler then feature.Handler(State[feature.Name]) end
    end)
    return b
end

local function makeCard(parent, feature, index)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -4, 0, 82)
    card.BackgroundColor3 = Theme.Card
    card.BackgroundTransparency = 0.38
    card.BorderSizePixel = 0
    card.LayoutOrder = index
    card.Parent = parent
    corner(card, 16)
    stroke(card, 0.64)
    table.insert(Runtime.Cards, card)

    local icon = label(card, feature.Icon, 19, true)
    icon.Position = UDim2.new(0, 13, 0, 13)
    icon.Size = UDim2.fromOffset(40, 28)
    icon.TextXAlignment = Enum.TextXAlignment.Center

    local name = label(card, feature.Name, 13, true)
    name.Position = UDim2.new(0, 62, 0, 11)
    name.Size = UDim2.new(1, -160, 0, 22)

    local desc = label(card, feature.Description, 10, false)
    desc.Position = UDim2.new(0, 63, 0, 37)
    desc.Size = UDim2.new(1, -160, 0, 31)
    desc.TextColor3 = Theme.Sub
    desc.TextWrapped = true

    if feature.Kind == "Toggle" then
        local t = makeToggle(card, feature)
        t.Position = UDim2.new(1, -92, 0.5, -17)
    else
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(76, 38)
        btn.Position = UDim2.new(1, -92, 0.5, -19)
        btn.BackgroundColor3 = Theme.Panel
        btn.BackgroundTransparency = 0.1
        btn.Text = "THỰC HIỆN"
        btn.TextColor3 = Theme.Accent2
        btn.TextSize = 9
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        btn.Parent = card
        corner(btn, 13)
        stroke(btn, 0.65)
        btn.Activated:Connect(function()
            if feature.Handler then feature.Handler() end
        end)
    end
    return card
end

local function buildPage(tabName)
    if Runtime.Pages[tabName] then Runtime.Pages[tabName]:Destroy() end
    local page = Instance.new("ScrollingFrame")
    page.Name = "Page_" .. tabName
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Parent = PageArea
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 9)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page
    local i = 0
    for _, f in ipairs(Features) do
        if f.Tab == tabName then
            i = i + 1
            makeCard(page, f, i)
        end
    end
    Runtime.Pages[tabName] = page
    return page
end

local function showTab(tabName)
    Runtime.CurrentTab = tabName
    for _, p in pairs(Runtime.Pages) do p.Visible = false end
    local page = Runtime.Pages[tabName] or buildPage(tabName)
    page.Visible = true
end

for i, data in ipairs(TabData) do
    local icon, name = table.unpack(data)
    local b = Instance.new("TextButton")
    b.LayoutOrder = i
    b.Size = UDim2.new(1, -14, 0, 50)
    b.BackgroundColor3 = Theme.Card
    b.BackgroundTransparency = 0.2
    b.Text = icon .. "  " .. name
    b.TextColor3 = Theme.Text
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = false
    b.Parent = TabContent
    corner(b, 14)
    stroke(b, 0.55)
    b.Activated:Connect(function()
        Search.Text = ""
        showTab(name)
    end)
    table.insert(Runtime.TabButtons, b)
end

-- Open / Close
local function openMenu()
    if Config.Open then return end
    Config.Open = true
    Main.Visible = true
    Main.Size = UDim2.fromOffset(20, 20)
    Blur.Size = 0
    tween(Blur, 0.32, {Size = Config.Blur})
    tween(Main, 0.42, {Size = UDim2.fromOffset(math.min(920, Camera.ViewportSize.X * 0.74), math.min(650, Camera.ViewportSize.Y * 0.8))}, Enum.EasingStyle.Back)
end

local function closeMenu()
    if not Config.Open then return end
    Config.Open = false
    tween(Blur, 0.24, {Size = 0})
    local t = tween(Main, 0.3, {Size = UDim2.fromOffset(20, 20)}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    t.Completed:Connect(function()
        if not Config.Open then Main.Visible = false end
    end)
end

OpenButton.Activated:Connect(function()
    if Config.Open then closeMenu() else openMenu() end
end)
Close.Activated:Connect(closeMenu)

-- Drag
local function draggable(obj)
    local dragging, start, pos
    obj.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            start = i.Position
            pos = obj.Position
        end
    end)
    connect(UserInputService.InputChanged, function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - start
            obj.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)
        end
    end)
    connect(UserInputService.InputEnded, function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end
draggable(Top)
draggable(OpenButton)

-- HUD
connect(RunService.RenderStepped, function(dt)
    local lines = {}
    if Config.FPS then table.insert(lines, "FPS " .. math.floor(1 / math.max(dt, 0.001))) end
    local root = getRoot()
    if root and Config.Coordinates then
        local p = root.Position
        table.insert(lines, string.format("XYZ %.0f / %.0f / %.0f", p.X, p.Y, p.Z))
    end
    if root and Config.Velocity then
        table.insert(lines, string.format("VEL %.0f", root.AssemblyLinearVelocity.Magnitude))
    end
    HUD.Text = table.concat(lines, "  |  ")
end)

-- Init
showTab("Combat")
task.defer(function()
    task.wait(0.3)
    openMenu()
    print("✅ ZAKA PURE UI MERGED LOADED - UI Bản 1 + Functions Bản 2")
end)
