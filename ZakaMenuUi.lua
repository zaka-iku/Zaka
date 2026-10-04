-- Delta Executor: OTG Mouse Lock + Full Virtual Keyboard + Key Visualizer
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Xóa GUI cũ nếu tồn tại
if LocalPlayer.PlayerGui:FindFirstChild("OTGSystemGUI") then
    LocalPlayer.PlayerGui.OTGSystemGUI:Destroy()
end

-- 1. TẠO SCREENGUI CHÍNH
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OTGSystemGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 2. HÀM THÔNG BÁO POPUP
local function showNotif(text)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 220, 0, 35)
    notif.Position = UDim2.new(0.5, -110, 0.08, 0)
    notif.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    notif.TextColor3 = Color3.fromRGB(0, 255, 127)
    notif.Text = text
    notif.Font = Enum.Font.SourceSansBold
    notif.TextSize = 16
    notif.BackgroundTransparency = 0.2
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

-- 3. BẢNG HIỂN THỊ PHÍM BẮM ĐANG ẤN (KEY VISUALIZER IN SƯƠNG / TRONG SUỐT)
local VisFrame = Instance.new("Frame")
VisFrame.Size = UDim2.new(0, 250, 0, 50)
VisFrame.Position = UDim2.new(0.02, 0, 0.85, 0)
VisFrame.BackgroundTransparency = 1
VisFrame.Parent = ScreenGui

local VisLayout = Instance.new("UIListLayout")
VisLayout.FillDirection = Enum.FillDirection.Horizontal
VisLayout.SortOrder = Enum.SortOrder.LayoutOrder
VisLayout.Padding = UDim.new(0, 5)
VisLayout.Parent = VisFrame

local activeVisKeys = {}

local function showPressedKey(keyName)
    if activeVisKeys[keyName] then return end
    
    local keyLbl = Instance.new("TextLabel")
    keyLbl.Size = UDim2.new(0, 40, 0, 40)
    keyLbl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    keyLbl.BackgroundTransparency = 0.5 -- Trong suốt
    keyLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyLbl.TextTransparency = 0.2
    keyLbl.Text = keyName
    keyLbl.Font = Enum.Font.SourceSansBold
    keyLbl.TextSize = 14
    keyLbl.Parent = VisFrame

    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(0, 6)
    kCorner.Parent = keyLbl

    local kStroke = Instance.new("UIStroke")
    kStroke.Color = Color3.fromRGB(255, 255, 255)
    kStroke.Transparency = 0.6
    kStroke.Parent = keyLbl

    activeVisKeys[keyName] = keyLbl
end

local function hidePressedKey(keyName)
    if activeVisKeys[keyName] then
        activeVisKeys[keyName]:Destroy()
        activeVisKeys[keyName] = nil
    end
end

-- 4. NÚT TOGGLE MENU HỆ THỐNG
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 80, 0, 35)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.02, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "MENU"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 15
ToggleBtn.Parent = ScreenGui

local tCorner = Instance.new("UICorner")
tCorner.CornerRadius = UDim.new(0, 6)
tCorner.Parent = ToggleBtn

-- 5. CONTAINER CHÍNH CHIA LÀM 2 PHẦN
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 780, 0, 260)
MainContainer.Position = UDim2.new(0.5, -390, 0.5, -130)
MainContainer.BackgroundTransparency = 1
MainContainer.Visible = true
MainContainer.Parent = ScreenGui

-- PHẦN 1: BÀN PHÍM & CHUỘT ẢO (BÊN TRÁI)
local Part1_Keyboard = Instance.new("ScrollingFrame")
Part1_Keyboard.Size = UDim2.new(0, 540, 1, 0)
Part1_Keyboard.Position = UDim2.new(0, 0, 0, 0)
Part1_Keyboard.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Part1_Keyboard.BackgroundTransparency = 0.2
Part1_Keyboard.CanvasSize = UDim2.new(0, 750, 0, 240)
Part1_Keyboard.ScrollBarThickness = 5
Part1_Keyboard.Parent = MainContainer

local p1Corner = Instance.new("UICorner")
p1Corner.CornerRadius = UDim.new(0, 8)
p1Corner.Parent = Part1_Keyboard

-- PHẦN 2: KHÓA GÓC NHÌN & CÀI ĐẶT CAMERA (BÊN PHẢI)
local Part2_Camera = Instance.new("Frame")
Part2_Camera.Size = UDim2.new(0, 230, 1, 0)
Part2_Camera.Position = UDim2.new(0, 550, 0, 0)
Part2_Camera.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Part2_Camera.BackgroundTransparency = 0.2
Part2_Camera.Parent = MainContainer

local p2Corner = Instance.new("UICorner")
p2Corner.CornerRadius = UDim.new(0, 8)
p2Corner.Parent = Part2_Camera

local P2Title = Instance.new("TextLabel")
P2Title.Size = UDim2.new(1, 0, 0, 30)
P2Title.BackgroundTransparency = 1
P2Title.Text = "CÀI ĐẶT CHUỘT & CAMERA"
P2Title.TextColor3 = Color3.fromRGB(255, 200, 0)
P2Title.Font = Enum.Font.SourceSansBold
P2Title.TextSize = 14
P2Title.Parent = Part2_Camera

-- LOGIC TẠO PHÍM BẤM BÀN PHÍM ẢO (PHẦN 1)
local function createKey(text, posX, posY, sizeX, sizeY, keyCode, mouseEnum)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.Size = UDim2.new(0, sizeX, 0, sizeY)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.Parent = Part1_Keyboard

    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(0, 4)
    kCorner.Parent = btn

    btn.MouseButton1Down:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        showPressedKey(text)
        if keyCode then
            VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
        elseif mouseEnum then
            VirtualInputManager:SendMouseButtonEvent(0, 0, mouseEnum == "L" and 0 or 1, true, game, 0)
        end
    end)

    btn.MouseButton1Up:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        hidePressedKey(text)
        if keyCode then
            VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
        elseif mouseEnum then
            VirtualInputManager:SendMouseButtonEvent(0, 0, mouseEnum == "L" and 0 or 1, false, game, 0)
        end
    end)
end

-- Nút Chuột Trái / Chuột Phải Ảo
createKey("L-Click", 5, 5, 60, 30, nil, "L")
createKey("R-Click", 70, 5, 60, 30, nil, "R")

-- Dải phím WASD / Thao tác chính
createKey("Esc", 140, 5, 35, 30, Enum.KeyCode.Escape)
createKey("Tab", 5, 40, 45, 30, Enum.KeyCode.Tab)
createKey("W", 115, 40, 35, 30, Enum.KeyCode.W)
createKey("E (Dùng)", 155, 40, 60, 30, Enum.KeyCode.E)
createKey("A", 75, 75, 35, 30, Enum.KeyCode.A)
createKey("S", 115, 75, 35, 30, Enum.KeyCode.S)
createKey("D", 155, 75, 35, 30, Enum.KeyCode.D)
createKey("Shift", 5, 110, 55, 30, Enum.KeyCode.LeftShift)
createKey("C (Cúi)", 65, 110, 50, 30, Enum.KeyCode.C)
createKey("Space (Nhảy)", 120, 110, 100, 30, Enum.KeyCode.Space)

-- Bảng phím Chữ A-Z mở rộng
local letters = {"Q","R","T","Y","U","I","O","P","F","G","H","J","K","L","Z","X","V","B","N","M"}
local startX, startY = 230, 5
for i, l in ipairs(letters) do
    local row = math.floor((i-1)/5)
    local col = (i-1)%5
    createKey(l, startX + col*38, startY + row*35, 35, 30, Enum.KeyCode[l])
end

-- ==========================================
-- LOGIC PHẦN 2: KHÓA GÓC NHÌN CHÍNH GIỮA (CENTER MOUSE LOCK)
-- ==========================================
local isMouseLocked = false
local LockToggleBtn = Instance.new("TextButton")
LockToggleBtn.Size = UDim2.new(0, 200, 0, 45)
LockToggleBtn.Position = UDim2.new(0, 15, 0, 40)
LockToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
LockToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LockToggleBtn.Text = "Khóa Góc Nhìn: TẮT"
LockToggleBtn.Font = Enum.Font.SourceSansBold
LockToggleBtn.TextSize = 14
LockToggleBtn.Parent = Part2_Camera

local lCorner = Instance.new("UICorner")
lCorner.CornerRadius = UDim.new(0, 6)
lCorner.Parent = LockToggleBtn

-- Nút giả lập xoay camera bằng phím
local RotateL = Instance.new("TextButton")
RotateL.Text = "◄ Xoay Trái"
RotateL.Size = UDim2.new(0, 95, 0, 35)
RotateL.Position = UDim2.new(0, 15, 0, 95)
RotateL.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
RotateL.TextColor3 = Color3.fromRGB(255, 255, 255)
RotateL.Font = Enum.Font.SourceSansBold
RotateL.Parent = Part2_Camera

local RotateR = Instance.new("TextButton")
RotateR.Text = "Xoay Phải ►"
RotateR.Size = UDim2.new(0, 95, 0, 35)
RotateR.Position = UDim2.new(0, 120, 0, 95)
RotateR.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
RotateR.TextColor3 = Color3.fromRGB(255, 255, 255)
RotateR.Font = Enum.Font.SourceSansBold
RotateR.Parent = Part2_Camera

local rotL, rotR = false, false
RotateL.MouseButton1Down:Connect(function() rotL = true end)
RotateL.MouseButton1Up:Connect(function() rotL = false end)
RotateR.MouseButton1Down:Connect(function() rotR = true end)
RotateR.MouseButton1Up:Connect(function() rotR = false end)

-- Vòng lặp khóa camera vào giữa màn hình khi bật Lock
RunService.RenderStepped:Connect(function()
    if isMouseLocked then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    end
    if rotL then
        Camera.CFrame = Camera.CFrame * CFrame.Angles(0, math.rad(2.5), 0)
    elseif rotR then
        Camera.CFrame = Camera.CFrame * CFrame.Angles(0, math.rad(-2.5), 0)
    end
end)

LockToggleBtn.MouseButton1Click:Connect(function()
    isMouseLocked = not isMouseLocked
    if isMouseLocked then
        LockToggleBtn.Text = "Khóa Góc Nhìn: BẬT"
        LockToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        showNotif("Đã Bật Khóa Góc Nhìn PC!")
    else
        LockToggleBtn.Text = "Khóa Góc Nhìn: TẮT"
        LockToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        showNotif("Đã Tắt Khóa Góc Nhìn!")
    end
end)

-- Bắt sự kiện phím vật lý để hiển thị Key Visualizer
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

-- NÚT TOGGLE ẨN/HIỆN MENU CHÍNH
ToggleBtn.MouseButton1Click:Connect(function()
    MainContainer.Visible = not MainContainer.Visible
    if MainContainer.Visible then
        showNotif("Mở Menu Thành Công!")
    else
        showNotif("Ẩn Menu Thành Công!")
    end
end)

showNotif("Khởi Tạo OTG Menu Thành Công!")
