--[[
    ╔════════════════════════════════════════════════════════════════╗
    ║                 ZAKA HUB UNIVERSAL - ONE UI                    ║
    ║             Universal Support • Mobile + PC Compact            ║
    ╚════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================== CẤU HÌNH (SETTINGS) ====================--
local Settings = {
    -- Combat
    Aimbot = false,
    AimbotFOV = 120,
    AimbotSmooth = 0.15,
    HitboxExpander = false,
    HitboxSize = 5,

    -- ESP
    ESP = false,
    ESPBox = true,
    ESPName = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPMaxDist = 3000,

    -- Player
    Speed = false,
    SpeedValue = 28,
    Noclip = false,
    ClickTP = false,

    -- Misc
    Fullbright = false,
    AntiAFK = true,
}

--==================== BIẾN HỆ THỐNG ====================--
local NoclipConn, SpeedConn
local ESPObjects = {}

-- Chống AFK
LocalPlayer.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

--==================== TÍNH NĂNG COMBAT & AIMBOT ====================--
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = Settings.AimbotFOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(0, 162, 255)

local function GetClosestPlayer()
    local closest, shortest = nil, Settings.AimbotFOV
    local mousePos = UserInputService:GetMouseLocation()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
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
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), Settings.AimbotSmooth)
        end
    end

    if Settings.HitboxExpander then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                pcall(function()
                    plr.Character.Head.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                    plr.Character.Head.Transparency = 0.6
                end)
            end
        end
    end
end)

--==================== HỆ THỐNG ESP ====================--
local function CreateESP(plr)
    if ESPObjects[plr] then return end
    local t = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
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
    end
end)

--==================== MOVEMENT & TELEPORT ====================--
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

UserInputService.TouchTap:Connect(function(touchPositions, gameProcessed)
    if Settings.ClickTP and not gameProcessed and touchPositions[1] then
        local unitRay = Camera:ViewportPointToRay(touchPositions[1].X, touchPositions[1].Y)
        local ray = Ray.new(unitRay.Origin, unitRay.Direction * 2000)
        local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
        if hit then TeleportTo(position) end
    end
end)

--==================== GIAO DIỆN ZAKA HUB (ONE UI GỌN) ====================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaHub_Universal"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Nút Tròn Mở/Tắt Nhanh (One UI Toggle Icon)
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

-- Khung Chính (Main Menu gọn 310x320)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 310, 0, 320)
Main.Position = UDim2.new(0.5, -155, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

ToggleIcon.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Thanh Header
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -15, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "<b>ZAKA</b> <font color=\"#00A2FF\">HUB</font> <font color=\"#888888\">| Universal</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.Gotham
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Hệ Thống Tabs
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, -12, 0, 28)
TabFrame.Position = UDim2.new(0, 6, 0, 42)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = Main

local Tabs = {"Combat", "ESP", "Player", "Teleport", "Misc"}
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

-- UI Component Helpers
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

--==================== NẠP CHỨC NĂNG VÀO TABS ====================--

-- Tab Combat
CreateToggle(Pages["Combat"], "Aimbot Lock (Giữ Chuột Phải)", false, function(v) Settings.Aimbot = v end)
CreateToggle(Pages["Combat"], "Hitbox Expander (Đầu To)", false, function(v) Settings.HitboxExpander = v end)

-- Tab ESP
CreateToggle(Pages["ESP"], "Bật ESP Tổng", false, function(v) Settings.ESP = v end)
CreateToggle(Pages["ESP"], "Khung ESP (Box)", true, function(v) Settings.ESPBox = v end)
CreateToggle(Pages["ESP"], "Tên Người Chơi", true, function(v) Settings.ESPName = v end)
CreateToggle(Pages["ESP"], "Thanh Máu (HP)", true, function(v) Settings.ESPHealth = v end)
CreateToggle(Pages["ESP"], "Khoảng Cách (Distance)", true, function(v) Settings.ESPDistance = v end)

-- Tab Player
CreateToggle(Pages["Player"], "Tăng Tốc Chạy (Speed)", false, function(v) Settings.Speed = v SetSpeed(v) end)
CreateToggle(Pages["Player"], "Đi Xuyên Tường (Noclip)", false, function(v) Settings.Noclip = v SetNoclip(v) end)
CreateToggle(Pages["Player"], "Click TP (Chạm Để Dịch Chuyển)", false, function(v) Settings.ClickTP = v end)

-- Tab Teleport (Universal Player Teleport)
CreateButton(Pages["Teleport"], "Dịch Chuyển Tới Người Chơi Ngẫu Nhiên", function()
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

print("Zaka Hub Universal Loaded Successfully!")
