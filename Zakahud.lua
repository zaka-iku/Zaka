--[[
    ╔════════════════════════════════════════════════════════════════╗
    ║             ZAKA HUB UNIVERSAL - V4 TROLL ULTIMATE             ║
    ║   Merged Delta X Troll Menu + Hitbox 500 + Fly Fixed + ESP     ║
    ╚════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

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
    JumpPowerVal = 100,

    -- Misc & Troll
    Fullbright = false,
    AntiAFK = true,
    GodMode = false,
}

--==================== BIẾN HỆ THỐNG ====================--
local NoclipConn, SpeedConn, FlyConn, GodConn
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
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
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
    if state then
        StartFly()
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

local function TeleportTo(position)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
    end
end

--==================== TROLL MENU FUNCTIONS ====================--
local function KillAll()
    pcall(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                end
            end
        end
    end)
end

local function BringAll()
    pcall(function()
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CFrame = myRoot.CFrame + Vector3.new(3, 0, 3)
                    end
                end
            end
        end
    end)
end

local function SetGodMode(state)
    Settings.GodMode = state
    if GodConn then GodConn:Disconnect() GodConn = nil end
    if state then
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
                GodConn = hum.HealthChanged:Connect(function()
                    if Settings.GodMode and hum.Health < hum.MaxHealth then
                        hum.Health = hum.MaxHealth
                    end
                end)
            end
        end)
    end
end

--==================== HỆ THỐNG ESP ====================--
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

--==================== GIAO DIỆN ONE UI ====================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaHub_UI"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Nút Tròn Icon Toggle
local ToggleIcon = Instance.new("TextButton")
ToggleIcon.Name = "ZakaToggleIcon"
ToggleIcon.Size = UDim2.new(0, 42, 0, 42)
ToggleIcon.Position = UDim2.new(0, 15, 0.4, 0)
ToggleIcon.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
ToggleIcon.Text = "Z"
ToggleIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleIcon.Font = Enum.Font.GothamBold
ToggleIcon.TextSize = 20
ToggleIcon.Active = true
ToggleIcon.Draggable = true
ToggleIcon.Parent = ScreenGui

Instance.new("UICorner", ToggleIcon).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", ToggleIcon)
IconStroke.Color = Color3.fromRGB(255, 255, 255)
IconStroke.Thickness = 2
IconStroke.Transparency = 0.5

-- Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 330)
Main.Position = UDim2.new(0.5, -160, 0.5, -165)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

ToggleIcon.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -15, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "<b>ZAKA</b> <font color=\"#00A2FF\">HUB</font> <font color=\"#888888\">| Ultimate v4</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.Gotham
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Tab System
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, -12, 0, 28)
TabFrame.Position = UDim2.new(0, 6, 0, 42)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = Main

local Tabs = {"Combat", "ESP", "Player", "Troll", "Misc"}
local CurrentTab = "Combat"
local TabButtons, Pages = {}, {}

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -12, 1, -78)
    page.Position = UDim2.new(0, 6, 0, 74)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 162, 255)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = (name == CurrentTab)
    page.Parent = Main

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = page

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
    end)

    Pages[name] = page
    return page
end

for i, name in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1 / #Tabs, -3, 1, 0)
    btn.Position = UDim2.new((i - 1) / #Tabs, 2, 0, 0)
    btn.BackgroundColor3 = name == CurrentTab and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(28, 28, 36)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TabFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    TabButtons[name] = btn
    CreatePage(name)

    btn.MouseButton1Click:Connect(function()
        CurrentTab = name
        for n, b in pairs(TabButtons) do b.BackgroundColor3 = n == name and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(28, 28, 36) end
        for n, p in pairs(Pages) do p.Visible = (n == name) end
    end)
end

-- UI Helpers
local function CreateToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
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
        toggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(45, 45, 55)
        callback(enabled)
    end)
end

local function CreateInput(parent, text, default, maxVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
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

--==================== GÁN TÍNH NĂNG VÀO TABS ====================--

-- Tab Combat
CreateToggle(Pages["Combat"], "Aimbot Lock Head (Khóa Đầu)", false, function(v) Settings.Aimbot = v end)
CreateInput(Pages["Combat"], "Kích Thước FOV Aim", 120, 800, function(v) Settings.AimbotFOV = v end)
CreateToggle(Pages["Combat"], "Hitbox Expander (Đầu To)", false, function(v) Settings.HitboxExpander = v end)
CreateInput(Pages["Combat"], "Kích Thước Hitbox (Max 500)", 20, 500, function(v) Settings.HitboxSize = v end)

-- Tab ESP
CreateToggle(Pages["ESP"], "Bật ESP Tổng", false, function(v) Settings.ESP = v end)
CreateToggle(Pages["ESP"], "Khung ESP (Box)", true, function(v) Settings.ESPBox = v end)
CreateToggle(Pages["ESP"], "Tên Người Chơi", true, function(v) Settings.ESPName = v end)
CreateToggle(Pages["ESP"], "Thanh Máu (HP)", true, function(v) Settings.ESPHealth = v end)
CreateToggle(Pages["ESP"], "Khoảng Cách (Distance)", true, function(v) Settings.ESPDistance = v end)
CreateToggle(Pages["ESP"], "Đường Kẻ (Tracers)", false, function(v) Settings.ESPTracers = v end)

-- Tab Player
CreateToggle(Pages["Player"], "Bật Tăng Tốc Chạy", false, function(v) Settings.Speed = v SetSpeed(v) end)
CreateInput(Pages["Player"], "Tốc Độ Chạy (Max 500)", 28, 500, function(v) Settings.SpeedValue = v end)

CreateToggle(Pages["Player"], "Bật Fly (Bay chuẩn)", false, function(v) SetFly(v) end)
CreateInput(Pages["Player"], "Tốc Độ Bay (Max 500)", 50, 500, function(v) Settings.FlySpeed = v end)

CreateButton(Pages["Player"], "Chỉnh Jump Power: 100", function()
    pcall(function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = 100
        end
    end)
end)

CreateToggle(Pages["Player"], "Nhảy Không Giới Hạn (Inf Jump)", false, function(v) Settings.InfiniteJump = v end)
CreateToggle(Pages["Player"], "SpinBot (Xoay Nhân Vật)", false, function(v) Settings.SpinBot = v end)
CreateToggle(Pages["Player"], "Đi Xuyên Tường (Noclip)", false, function(v) Settings.Noclip = v SetNoclip(v) end)

-- Tab Troll (Thêm các tính năng từ Troll Menu)
CreateButton(Pages["Troll"], "Kill All (Tiêu diệt tất cả)", function()
    KillAll()
end)

CreateButton(Pages["Troll"], "Bring All (Kéo tất cả lại gần)", function()
    BringAll()
end)

CreateToggle(Pages["Troll"], "Bật God Mode (Client)", false, function(v)
    SetGodMode(v)
end)

CreateButton(Pages["Troll"], "Dịch Chuyển Tới Người Ngẫu Nhiên", function()
    local plrs = Players:GetPlayers()
    for _, target in ipairs(plrs) do
        if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            TeleportTo(target.Character.HumanoidRootPart.Position)
            break
        end
    end
end)

-- Tab Misc
CreateToggle(Pages["Misc"], "Nhìn Trong Đêm (Fullbright)", false, function(v) 
    Lighting.Brightness = v and 2 or 1 
    Lighting.ClockTime = v and 14 or 12
end)
CreateToggle(Pages["Misc"], "Tự Động Anti-AFK", true, function(v) Settings.AntiAFK = v end)

CreateButton(Pages["Misc"], "Vào Lại Server (Rejoin)", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

CreateButton(Pages["Misc"], "Đổi Server Ngẫu Nhiên (Server Hop)", function()
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

print("Zaka Hub Ultimate v4 Loaded Successfully!")
