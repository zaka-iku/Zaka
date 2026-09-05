--[[
    ZAKA HUD - STABLE VERSION (No Magic)
    Combat | ESP | Player | Teleport | Troll | Utility | Config
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

--==================== SETTINGS ====================--
local Settings = {
    Aimbot = false,
    AimbotFOV = 120,
    AimbotSmooth = 0.18,
    SilentAim = false,
    NPCAimbot = false,
    NPCAimbotFOV = 140,
    HitboxExpander = false,
    HitboxSize = 15,
    ESP = false,
    ESPBox = true,
    ESPName = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPTracers = false,
    ESPMaxDist = 2500,
    Chams = false,
    Speed = false,
    SpeedValue = 28,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    InfiniteJump = false,
    SpinBot = false,
    SpinSpeed = 35,
    TouchTP = false,
    AntiAFK = true,
    CustomFOV = 70,
}

local NoclipConn, SpeedConn, FlyConn, BodyGyro, BodyVelocity
local ESPObjects = {}
local ChamsObjects = {}
local OriginalFogEnd = Lighting.FogEnd

-- Anti-AFK
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

--==================== MOVEMENT ====================--
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

local function SetFly(state)
    Settings.Fly = state
    if FlyConn then FlyConn:Disconnect() FlyConn = nil end
    if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end

    if not state then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 9e4
    BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.CFrame = root.CFrame
    BodyGyro.Parent = root

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Velocity = Vector3.zero
    BodyVelocity.Parent = root

    FlyConn = RunService.RenderStepped:Connect(function()
        if not Settings.Fly or not char or not char.Parent then
            if BodyGyro then BodyGyro:Destroy() end
            if BodyVelocity then BodyVelocity:Destroy() end
            if FlyConn then FlyConn:Disconnect() end
            return
        end
        BodyGyro.CFrame = Camera.CFrame
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0 then
            local dir = (Camera.CFrame.LookVector * -hum.MoveDirection.Z) + (Camera.CFrame.RightVector * hum.MoveDirection.X)
            BodyVelocity.Velocity = dir.Unit * Settings.FlySpeed
        else
            BodyVelocity.Velocity = Vector3.zero
        end
    end)
end

local function SetNoclip(state)
    if NoclipConn then NoclipConn:Disconnect() NoclipConn = nil end
    if state then
        NoclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    end
end

local function SetTouchTP(state)
    Settings.TouchTP = state
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp or not Settings.TouchTP then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if Mouse.Hit then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end
    end
end)

--==================== AIMBOT ====================--
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(0, 162, 255)
FOVCircle.Visible = false

local NPCFOVCircle = Drawing.new("Circle")
NPCFOVCircle.Thickness = 1.5
NPCFOVCircle.NumSides = 64
NPCFOVCircle.Filled = false
NPCFOVCircle.Color = Color3.fromRGB(255, 80, 80)
NPCFOVCircle.Visible = false

local function GetClosestPlayerHead()
    local closest, shortest = nil, Settings.AimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local head = plr.Character:FindFirstChild("Head")
            if hum and hum.Health > 0 and head then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if d < shortest then shortest = d closest = head end
                end
            end
        end
    end
    return closest
end

local function GetClosestNPCHead()
    local closest, shortest = nil, Settings.NPCAimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local head = obj:FindFirstChild("Head") or obj:FindFirstChild("head")
            if hum and head and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if d < shortest then shortest = d closest = head end
                end
            end
        end
    end
    return closest
end

pcall(function()
    local old
    old = hookmetamethod(game, "__index", function(self, key)
        if not checkcaller() and Settings.SilentAim and self == Mouse and key == "Hit" then
            local t = GetClosestPlayerHead()
            if t then return t.CFrame end
        end
        return old(self, key)
    end)
end)

RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Position = center
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Visible = Settings.Aimbot or Settings.SilentAim

    NPCFOVCircle.Position = center
    NPCFOVCircle.Radius = Settings.NPCAimbotFOV
    NPCFOVCircle.Visible = Settings.NPCAimbot

    if Settings.Aimbot then
        local t = GetClosestPlayerHead()
        if t then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Position), Settings.AimbotSmooth)
        end
    end

    if Settings.NPCAimbot then
        local t = GetClosestNPCHead()
        if t then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Position), 0.16)
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
        if root then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
        end
    end

    Camera.FieldOfView = Settings.CustomFOV
end)

--==================== ESP ====================--
local function CreateESP(plr)
    if ESPObjects[plr] then return end
    ESPObjects[plr] = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
    }
    local t = ESPObjects[plr]
    t.Box.Thickness = 1
    t.Box.Filled = false
    t.Name.Size = 13
    t.Name.Center = true
    t.Name.Outline = true
    t.Health.Size = 12
    t.Health.Center = true
    t.Health.Outline = true
    t.Distance.Size = 12
    t.Distance.Center = true
    t.Distance.Outline = true
    t.Tracer.Thickness = 1
    t.Tracer.Color = Color3.fromRGB(0, 162, 255)
end

Players.PlayerRemoving:Connect(function(plr)
    if ESPObjects[plr] then
        for _, d in pairs(ESPObjects[plr]) do pcall(function() d:Remove() end) end
        ESPObjects[plr] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    -- Chams
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character then
            if Settings.Chams then
                if not ChamsObjects[plr] then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = Color3.fromRGB(0, 162, 255)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.4
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

    if not Settings.ESP then
        for _, t in pairs(ESPObjects) do
            for _, d in pairs(t) do d.Visible = false end
        end
        return
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        CreateESP(plr)
        local t = ESPObjects[plr]
        local char = plr.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChildOfClass("Humanoid") or char.Humanoid.Health <= 0 then
            for _, d in pairs(t) do d.Visible = false end
            continue
        end

        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local dist = (root.Position - Camera.CFrame.Position).Magnitude

        if not onScreen or dist > Settings.ESPMaxDist then
            for _, d in pairs(t) do d.Visible = false end
            continue
        end

        local size = Vector2.new(math.clamp(1800/pos.Z, 8, 280), math.clamp(2800/pos.Z, 12, 400))
        t.Box.Size = size
        t.Box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
        t.Box.Color = Color3.fromRGB(0, 162, 255)
        t.Box.Visible = Settings.ESPBox

        t.Name.Text = plr.Name
        t.Name.Position = Vector2.new(pos.X, pos.Y - size.Y/2 - 14)
        t.Name.Color = Color3.fromRGB(0, 162, 255)
        t.Name.Visible = Settings.ESPName

        t.Health.Text = math.floor(hum.Health) .. " HP"
        t.Health.Position = Vector2.new(pos.X, pos.Y + size.Y/2 + 2)
        t.Health.Color = Color3.fromRGB(255 - (hum.Health/hum.MaxHealth)*255, (hum.Health/hum.MaxHealth)*255, 0)
        t.Health.Visible = Settings.ESPHealth

        t.Distance.Text = math.floor(dist) .. "m"
        t.Distance.Position = Vector2.new(pos.X, pos.Y + size.Y/2 + 15)
        t.Distance.Visible = Settings.ESPDistance

        if Settings.ESPTracers then
            t.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
            t.Tracer.To = Vector2.new(pos.X, pos.Y)
            t.Tracer.Visible = true
        else
            t.Tracer.Visible = false
        end
    end
end)

--==================== UI ====================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaHUD_Stable"
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
ToggleIcon.Parent = ScreenGui
Instance.new("UICorner", ToggleIcon).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 340, 0, 380)
Main.Position = UDim2.new(0.5, -170, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA HUD | Stable (No Magic)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, -12, 0, 28)
TabFrame.Position = UDim2.new(0, 6, 0, 42)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = Main

local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -12, 1, -80)
PageContainer.Position = UDim2.new(0, 6, 0, 76)
PageContainer.BackgroundTransparency = 1
PageContainer.ClipsDescendants = true
PageContainer.Parent = Main

local Tabs = {"Combat", "ESP", "Player", "Teleport", "Troll", "Utility"}
local Pages, TabButtons = {}, {}
local Current = 1

local function CreatePage(i)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Parent = PageContainer
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 5)
    lay.Parent = page
    lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y + 10)
    end)
    Pages[i] = page
end

for i, name in ipairs(Tabs) do
    CreatePage(i)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#Tabs, -3, 1, 0)
    btn.Position = UDim2.new((i-1)/#Tabs, 1, 0, 0)
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(30, 30, 40)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TabFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    TabButtons[i] = btn
    btn.MouseButton1Click:Connect(function()
        Current = i
        for j, b in ipairs(TabButtons) do
            b.BackgroundColor3 = j == i and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(30, 30, 40)
        end
        for j, p in ipairs(Pages) do
            p.Visible = (j == i)
        end
    end)
    Pages[i].Visible = (i == 1)
end

local function AddToggle(page, text, default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, 32)
    f.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    f.Parent = page
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -50, 1, 0)
    l.Position = UDim2.new(0, 8, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(220, 220, 230)
    l.TextSize = 12
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 36, 0, 18)
    b.Position = UDim2.new(1, -42, 0.5, -9)
    b.BackgroundColor3 = default and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(50, 50, 60)
    b.Text = ""
    b.Parent = f
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)

    local on = default
    b.MouseButton1Click:Connect(function()
        on = not on
        b.BackgroundColor3 = on and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(50, 50, 60)
        callback(on)
    end)
end

local function AddBtn(page, text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -4, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 12
    b.Font = Enum.Font.Gotham
    b.Parent = page
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(callback)
end

-- Combat
AddToggle(Pages[1], "Aimbot", false, function(v) Settings.Aimbot = v end)
AddToggle(Pages[1], "Silent Aim", false, function(v) Settings.SilentAim = v end)
AddToggle(Pages[1], "NPC Aimbot", false, function(v) Settings.NPCAimbot = v end)
AddToggle(Pages[1], "Hitbox Expander", false, function(v) Settings.HitboxExpander = v end)

-- ESP
AddToggle(Pages[2], "ESP Main", false, function(v) Settings.ESP = v end)
AddToggle(Pages[2], "ESP Box", true, function(v) Settings.ESPBox = v end)
AddToggle(Pages[2], "ESP Name", true, function(v) Settings.ESPName = v end)
AddToggle(Pages[2], "ESP Health", true, function(v) Settings.ESPHealth = v end)
AddToggle(Pages[2], "ESP Distance", true, function(v) Settings.ESPDistance = v end)
AddToggle(Pages[2], "ESP Tracers", false, function(v) Settings.ESPTracers = v end)
AddToggle(Pages[2], "Chams", false, function(v) Settings.Chams = v end)

-- Player
AddToggle(Pages[3], "Speed", false, function(v) Settings.Speed = v SetSpeed(v) end)
AddToggle(Pages[3], "Fly", false, function(v) SetFly(v) end)
AddToggle(Pages[3], "Noclip", false, function(v) Settings.Noclip = v SetNoclip(v) end)
AddToggle(Pages[3], "Infinite Jump", false, function(v) Settings.InfiniteJump = v end)
AddToggle(Pages[3], "SpinBot", false, function(v) Settings.SpinBot = v end)
AddToggle(Pages[3], "Touch TP", false, function(v) SetTouchTP(v) end)

-- Teleport
AddBtn(Pages[4], "TP Random Player", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            root.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            break
        end
    end
end)
AddBtn(Pages[4], "TP Up 100", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = root.CFrame + Vector3.new(0, 100, 0) end
end)

-- Troll (local only - Bring không hoạt động thật)
AddBtn(Pages[5], "Fling Self (Spin)", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local bv = Instance.new("BodyAngularVelocity")
    bv.AngularVelocity = Vector3.new(0, 50, 0)
    bv.MaxTorque = Vector3.new(0, math.huge, 0)
    bv.Parent = root
    task.delay(2, function() bv:Destroy() end)
end)

-- Utility
AddToggle(Pages[6], "Anti AFK", true, function(v) Settings.AntiAFK = v end)
AddBtn(Pages[6], "Rejoin", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)
AddBtn(Pages[6], "Server Hop", function()
    pcall(function()
        local data = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=50")).data
        for _, s in ipairs(data) do
            if s.id \~= game.JobId and s.playing < s.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
                break
            end
        end
    end)
end)

ToggleIcon.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

print("Zaka HUD Stable Loaded")
