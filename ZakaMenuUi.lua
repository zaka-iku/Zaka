-- Delta Executor: Ultimate OTG Touch-Blocker & True Lock Center Engine
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Clean GUI cũ
if LocalPlayer.PlayerGui:FindFirstChild("OTGDoorsNativeGUI") then
    LocalPlayer.PlayerGui.OTGDoorsNativeGUI:Destroy()
end

-- 1. SCREENGUI CHÍNH (DisplayOrder cao nhất để đè mọi GUI game)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OTGDoorsNativeGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 99999999
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 2. LỚP MÀNG CHẶN CHUỘT ẢO BẤM NHẦM VÀO MÀN HÌNH (TOUCH BLOCKER)
local TouchBlocker = Instance.new("TextButton")
TouchBlocker.Name = "TouchBlocker"
TouchBlocker.Size = UDim2.new(1, 0, 1, 0)
TouchBlocker.Position = UDim2.new(0, 0, 0, 0)
TouchBlocker.BackgroundTransparency = 1
TouchBlocker.Text = ""
TouchBlocker.Active = true
TouchBlocker.Visible = false
TouchBlocker.Parent = ScreenGui

-- 3. TÂM NGẮM NATIVE CROSSHAIR
local NativeCenterDot = Instance.new("Frame")
NativeCenterDot.Size = UDim2.new(0, 4, 0, 4)
NativeCenterDot.AnchorPoint = Vector2.new(0.5, 0.5)
NativeCenterDot.Position = UDim2.new(0.5, 0, 0.5, 0)
NativeCenterDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NativeCenterDot.BackgroundTransparency = 0
NativeCenterDot.Visible = true
NativeCenterDot.ZIndex = 10
NativeCenterDot.Parent = ScreenGui

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = NativeCenterDot

local dotStroke = Instance.new("UIStroke")
dotStroke.Color = Color3.fromRGB(0, 0, 0)
dotStroke.Transparency = 0.4
dotStroke.Thickness = 1
dotStroke.Parent = NativeCenterDot

-- 4. HÀM POPUP THÔNG BÁO
local function showNotif(text)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 250, 0, 35)
    notif.Position = UDim2.new(0.5, -125, 0.08, 0)
    notif.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    notif.BackgroundTransparency = 0.2
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.Text = text
    notif.Font = Enum.Font.SourceSansBold
    notif.TextSize = 15
    notif.ZIndex = 100
    notif.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif

    task.delay(1.2, function()
        local tween = TweenService:Create(notif, TweenInfo.new(0.4), {TextTransparency = 1, BackgroundTransparency = 1})
        tween:Play()
        tween.Completed:Connect(function() notif:Destroy() end)
    end)
end

-- 5. MENU TOGGLE (PHÍM P & NÚT)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 90, 0, 35)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.05, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.BackgroundTransparency = 0.3
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "MENU (P)"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 14
ToggleBtn.ZIndex = 100
ToggleBtn.Parent = ScreenGui

local tCorner = Instance.new("UICorner")
tCorner.CornerRadius = UDim.new(0, 6)
tCorner.Parent = ToggleBtn

-- 6. BẢNG MENU VÀ NÚT CHÍNH
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 300, 0, 180)
MainContainer.Position = UDim2.new(0.5, -150, 0.5, -90)
MainContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainContainer.BackgroundTransparency = 0.2
MainContainer.Visible = true
MainContainer.ZIndex = 100
MainContainer.Parent = ScreenGui

local mCorner = Instance.new("UICorner")
mCorner.CornerRadius = UDim.new(0, 10)
mCorner.Parent = MainContainer

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "ULTIMATE OTG LOCKER"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.ZIndex = 101
Title.Parent = MainContainer

local LockToggleBtn = Instance.new("TextButton")
LockToggleBtn.Size = UDim2.new(0, 260, 0, 50)
LockToggleBtn.Position = UDim2.new(0.5, -130, 0.45, 0)
LockToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
LockToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LockToggleBtn.Text = "TRUE LOCK: OFF"
LockToggleBtn.Font = Enum.Font.SourceSansBold
LockToggleBtn.TextSize = 16
LockToggleBtn.ZIndex = 101
LockToggleBtn.Parent = MainContainer

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = LockToggleBtn

-- LOGIC KHÓA CHUỘT BẰNG MA-TRẬN LẬP TRÌNH
local isLocked = false
local isMenuOpen = true
local lastMousePos = UserInputService:GetMouseLocation()
local sensitivity = 0.003
local pitch = 0
local yaw = 0

local function toggleMenu()
    MainContainer.Visible = not MainContainer.Visible
    isMenuOpen = MainContainer.Visible
    if isMenuOpen then
        showNotif("Menu Opened")
    else
        showNotif("Menu Hidden")
    end
end

ToggleBtn.MouseButton1Click:Connect(toggleMenu)

UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.P and not gpe then
        toggleMenu()
    end
end)

LockToggleBtn.MouseButton1Click:Connect(function()
    isLocked = not isLocked
    if isLocked then
        LockToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        LockToggleBtn.Text = "TRUE LOCK: ON"
        showNotif("Khóa tâm OTG Chuẩn PC: ĐÃ BẬT")
        
        local rx, ry, _ = Camera.CFrame:ToOrientation()
        pitch = rx
        yaw = ry
        lastMousePos = UserInputService:GetMouseLocation()
    else
        LockToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        LockToggleBtn.Text = "TRUE LOCK: OFF"
        showNotif("Khóa tâm: ĐÃ TẮT")
    end
end)

-- VÒNG LẶP CHÍNH (CORRECTING CAMERA & BLOCKING TOUCH)
RunService.RenderStepped:Connect(function()
    local isRobloxMenuOpen = GuiService:GetMenuIsOpen()

    -- Mở lại chuột khi mở Roblox Menu (Esc) hoặc Mở Menu Hack
    if isRobloxMenuOpen or isMenuOpen then
        TouchBlocker.Visible = false
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
        if Camera.CameraType == Enum.CameraType
