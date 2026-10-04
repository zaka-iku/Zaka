-- Delta Executor: Fix FPS Lock Camera + Transparent Key Overlay
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Xóa GUI cũ nếu đã chạy
if LocalPlayer.PlayerGui:FindFirstChild("OTGFpsSystemGUI") then
    LocalPlayer.PlayerGui.OTGFpsSystemGUI:Destroy()
end

-- 1. SCREENGUI CHÍNH
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OTGFpsSystemGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 2. HÀM POPUP THÔNG BÁO
local function showNotif(text)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 240, 0, 35)
    notif.Position = UDim2.new(0.5, -120, 0.08, 0)
    notif.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    notif.BackgroundTransparency = 0.3
    notif.TextColor3 = Color3.fromRGB(0, 255, 150)
    notif.Text = text
    notif.Font = Enum.Font.SourceSansBold
    notif.TextSize = 15
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

-- 3. KEY VISUALIZER (TRONG SUỐT / SEMI-TRANSPARENT OVERLAY)
local VisFrame = Instance.new("Frame")
VisFrame.Size = UDim2.new(0, 300, 0, 50)
VisFrame.Position = UDim2.new(0.02, 0, 0.85, 0)
VisFrame.BackgroundTransparency = 1
VisFrame.Parent = ScreenGui

local VisLayout = Instance.new("UIListLayout")
VisLayout.FillDirection = Enum.FillDirection.Horizontal
VisLayout.SortOrder = Enum.SortOrder.LayoutOrder
VisLayout.Padding = UDim.new(0, 6)
VisLayout.Parent = VisFrame

local activeVisKeys = {}

local function showPressedKey(keyName)
    if activeVisKeys[keyName] then return end
    
    local keyLbl = Instance.new("TextLabel")
    keyLbl.Size = UDim2.new(0, 42, 0, 42)
    -- Nền đen mờ trong suốt
    keyLbl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    keyLbl.BackgroundTransparency = 0.65 
    keyLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyLbl.TextTransparency = 0.1
    keyLbl.Text = keyName
    keyLbl.Font = Enum.Font.SourceSansBold
    keyLbl.TextSize = 14
    keyLbl.Parent = VisFrame

    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(0, 8)
    kCorner.Parent = keyLbl

    -- Viền sáng trong suốt
    local kStroke = Instance.new("UIStroke")
    kStroke.Color = Color3.fromRGB(255, 255, 255)
    kStroke.Transparency = 0.5
    kStroke.Thickness = 1.5
    kStroke.Parent = keyLbl

    activeVisKeys[keyName] = keyLbl
end

local function hidePressedKey(keyName)
    if activeVisKeys[keyName] then
        activeVisKeys[keyName]:Destroy()
        activeVisKeys[keyName] = nil
    end
end

-- 4. NÚT TOGGLE MENU
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 80, 0, 35)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.02, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.BackgroundTransparency = 0.3
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "MENU"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 15
ToggleBtn.Parent = ScreenGui

local tCorner = Instance.new("UICorner")
tCorner.CornerRadius = UDim.new(0, 6)
tCorner.Parent = ToggleBtn

-- 5. CONTAINER MAIN MENU (CHIA 2 PHẦN)
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 760, 0, 250)
MainContainer.Position = UDim2.new(0.5, -380, 0.5, -125)
MainContainer.BackgroundTransparency = 1
MainContainer.Visible = true
MainContainer.Parent = ScreenGui

-- PHẦN 1: BÀN PHÍM & CHUỘT (TRÁI)
local Part1 = Instance.new("ScrollingFrame")
Part1.Size = UDim2.new(0, 520, 1, 0)
Part1.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Part1.BackgroundTransparency = 0.3
Part1.CanvasSize = UDim2.new(0, 700, 0, 230)
Part1.ScrollBarThickness = 4
Part1.Parent = MainContainer

local p1Corner = Instance.new("UICorner")
p1Corner.CornerRadius = UDim.new(0, 8)
p1Corner.Parent = Part1

-- PHẦN 2: CHUỘT & KHÓA FPS CAMERA (PHẢI)
local Part2 = Instance.new("Frame")
Part2.Size = UDim2.new(0, 225, 1, 0)
Part2.Position = UDim2.new(0, 535, 0, 0)
Part2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Part2.BackgroundTransparency = 0.3
Part2.Parent = MainContainer

local p2Corner = Instance.new("UICorner")
p2Corner.CornerRadius = UDim.new(0, 8)
p2Corner.Parent = Part2

local P2Title = Instance.new("TextLabel")
P2Title.Size = UDim2.new(1, 0, 0, 30)
P2Title.BackgroundTransparency = 1
P2Title.Text = "KHÓA CAMERA FPS (OTG)"
P2Title.TextColor3 = Color3.fromRGB(255, 215, 0)
P2Title.Font = Enum.Font.SourceSansBold
P2Title.TextSize = 13
P2Title.Parent = Part2

-- HÀM TẠO PHÍM BẤM ẢO TRONG SUỐT
local function createKey(text, posX, posY, sizeX, sizeY, keyCode, mouseEnum)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.Size = UDim2.new(0, sizeX, 0, sizeY)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BackgroundTransparency = 0.4 -- Trong suốt nhẹ
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.Parent = Part1

    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(0, 5)
    kCorner.Parent = btn

    btn.MouseButton1Down:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
        showPressedKey(text)
        if keyCode then
            VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
        elseif mouseEnum then
            VirtualInputManager:SendMouseButtonEvent(0, 0, mouseEnum == "L" and 0 or 1, true, game, 0)
        end
    end)

    btn.MouseButton1Up:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        hidePressedKey(text)
        if keyCode then
            VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
        elseif mouseEnum then
            VirtualInputManager:SendMouseButtonEvent(0, 0, mouseEnum == "L" and 0 or 1, false, game, 0)
        end
    end)
end

-- TẠO CÁC NÚT PHÍM BÀN PHÍM ẢO
createKey("L-Click", 5, 5, 55, 30, nil, "L")
createKey("R-Click", 65, 5, 55, 30, nil, "R")
createKey("Esc", 125, 5, 35, 30, Enum.KeyCode.Escape)
createKey("Tab", 5, 40, 45, 30, Enum.KeyCode.Tab)
createKey("W", 105, 40, 35, 30, Enum.KeyCode.W)
createKey("E (Mở/Dùng)", 145, 40, 80, 30, Enum.KeyCode.E)
createKey("A", 65, 75, 35, 30, Enum.KeyCode.A)
createKey("S", 105, 75, 35, 30, Enum.KeyCode.S)
createKey("D", 145, 75, 35, 30, Enum.KeyCode.D)
createKey("Shift", 5, 110, 55, 30, Enum.KeyCode.LeftShift)
createKey("C (Cúi)", 65, 110, 50, 30, Enum.KeyCode.C)
createKey("Space", 120, 110, 80, 30, Enum.KeyCode.Space)

local letters = {"Q","R","T","Y","U","I","O","P","F","G","H","J","K","L","Z","X","V","B","N","M"}
for i, l in ipairs(letters) do
    local row = math.floor((i-1)/5)
    local col = (i-1)%5
    createKey(l, 235 + col*36, 5 + row*35, 33, 30, Enum.KeyCode[l])
end

-- ==========================================
-- THUẬT TOÁN KHÓA CAMERA GÓC NHÌN THỨ NHẤT (FPS LOCK HOÀN HẢO)
-- ==========================================
local isFPSLocked = false
local sensitivity = 0.4 -- Độ nhạy xoay chuột OTG

local LockToggleBtn = Instance.new("TextButton")
LockToggleBtn.Size = UDim2.new(0, 195, 0, 45)
LockToggleBtn.Position = UDim2.new(0, 15, 0, 40)
LockToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
LockToggleBtn.BackgroundTransparency = 0.3
LockToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LockToggleBtn.Text = "Khóa Góc Nhìn FPS: TẮT"
LockToggleBtn.Font = Enum.Font.SourceSansBold
LockToggleBtn.TextSize = 13
LockToggleBtn.Parent = Part2

local lCorner = Instance.new("UICorner")
lCorner.CornerRadius = UDim.new(0, 6)
lCorner.Parent = LockToggleBtn

-- Tối ưu hóa việc xoay Camera trong FPS khi di chuột OTG
local pitch, yaw = 0, 0

UserInputService.InputChanged:Connect(function(input, gpe)
    if isFPSLocked and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Delta
        yaw = yaw - (delta.X * sensitivity)
        pitch = math.clamp(pitch - (delta.Y * sensitivity), -80, 80)
        
        -- Ép góc nhìn Camera xoay trực tiếp
        Camera.CFrame = CFrame.new(Camera.CFrame.Position) 
            * CFrame.Angles(0, math.rad(yaw), 0) 
            * CFrame.Angles(math.rad(pitch), 0, 0)
    end
end)

-- Vòng lặp khóa con trỏ nằm im chính giữa màn hình
RunService.RenderStepped:Connect(function()
    if isFPSLocked then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    end
end)

LockToggleBtn.MouseButton1Click:Connect(function()
    isFPSLocked = not isFPSLocked
    if isFPSLocked then
        LockToggleBtn.Text = "Khóa Góc Nhìn FPS: BẬT"
        LockToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        
        -- Khởi tạo lại hướng nhìn hiện tại
        local _, y, _ = Camera.CFrame:ToOrientation()
        yaw = math.deg(y)
        pitch = 0
        
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        showNotif("Đã Bật Khóa Góc Nhìn FPS!")
    else
        LockToggleBtn.Text = "Khóa Góc Nhìn FPS: TẮT"
        LockToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        showNotif("Đã Tắt Khóa Góc Nhìn!")
    end
end)

-- SỰ KIỆN BẮT PHÍM BẤM TRỰC TIẾP TỪ BÀN PHÍM VẬT LÝ / OTG
UserInputService.InputBegan:Connect(function(input, gpe)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        showPressedKey(input.KeyCode.Name)
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        showPressedKey("L-Click")
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        showPressedKey("R-Click")
    end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        hidePressedKey(input.KeyCode.Name)
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        hidePressedKey("L-Click")
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        hidePressedKey("R-Click")
    end
end)

-- NÚT BẬT / ẨN MENU
ToggleBtn.MouseButton1Click:Connect(function()
    MainContainer.Visible = not MainContainer.Visible
    if MainContainer.Visible then
        showNotif("Mở Menu Thành Công!")
    else
        showNotif("Ẩn Menu Thành Công!")
    end
end)

showNotif("Khởi Tạo OTG FPS Fix Thành Công!")
