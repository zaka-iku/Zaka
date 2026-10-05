-- Delta Executor: Fix OTG Mouse Lock FPS Doors + Rainbow Transparent Overlay
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Clean GUI cũ
if LocalPlayer.PlayerGui:FindFirstChild("OTGFpsRainbowGUI") then
    LocalPlayer.PlayerGui.OTGFpsRainbowGUI:Destroy()
end

-- 1. TẠO SCREENGUI CHÍNH
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OTGFpsRainbowGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 2. HÀM POPUP THÔNG BÁO
local function showNotif(text)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 240, 0, 35)
    notif.Position = UDim2.new(0.5, -120, 0.08, 0)
    notif.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    notif.BackgroundTransparency = 0.2
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

-- 3. KEY VISUALIZER (TRONG SUỐT 100% + VIỀN & CHỮ CẦU VỒNG RGB)
local VisFrame = Instance.new("Frame")
VisFrame.Size = UDim2.new(0, 400, 0, 60)
VisFrame.Position = UDim2.new(0.02, 0, 0.82, 0)
VisFrame.BackgroundTransparency = 1
VisFrame.Parent = ScreenGui

local VisLayout = Instance.new("UIListLayout")
VisLayout.FillDirection = Enum.FillDirection.Horizontal
VisLayout.SortOrder = Enum.SortOrder.LayoutOrder
VisLayout.Padding = UDim.new(0, 8)
VisLayout.Parent = VisFrame

local activeVisKeys = {}
local rainbowObjects = {}

-- Vòng lặp đổi màu Cầu Vồng (RGB) cho các phím đang ấn
local hue = 0
RunService.RenderStepped:Connect(function(delta)
    hue = (hue + delta * 0.6) % 1
    local rainbowColor = Color3.fromHSV(hue, 1, 1)
    
    for _, item in pairs(rainbowObjects) do
        if item.Stroke then
            item.Stroke.Color = rainbowColor
        end
        if item.Label then
            item.Label.TextColor3 = rainbowColor
        end
    end
end)

local function showPressedKey(keyName)
    if activeVisKeys[keyName] then return end
    
    local keyLbl = Instance.new("TextLabel")
    keyLbl.Size = UDim2.new(0, 48, 0, 48)
    
    -- TRONG SUỐT 100% NỀN
    keyLbl.BackgroundTransparency = 1
    keyLbl.Text = keyName
    keyLbl.Font = Enum.Font.SourceSansBold
    keyLbl.TextSize = 16
    keyLbl.Parent = VisFrame

    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(0, 8)
    kCorner.Parent = keyLbl

    -- VIỀN ĐẬM CẦU VỒNG (RGB STROKE)
    local kStroke = Instance.new("UIStroke")
    kStroke.Thickness = 3.5 -- Viền sáng đậm
    kStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    kStroke.Parent = keyLbl

    activeVisKeys[keyName] = keyLbl
    table.insert(rainbowObjects, {Label = keyLbl, Stroke = kStroke})
end

local function hidePressedKey(keyName)
    if activeVisKeys[keyName] then
        local target = activeVisKeys[keyName]
        for i, item in ipairs(rainbowObjects) do
            if item.Label == target then
                table.remove(rainbowObjects, i)
                break
            end
        end
        target:Destroy()
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

-- 5. CONTAINER MENU CHÍNH
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 760, 0, 250)
MainContainer.Position = UDim2.new(0.5, -380, 0.5, -125)
MainContainer.BackgroundTransparency = 1
MainContainer.Visible = true
MainContainer.Parent = ScreenGui

-- PHẦN 1: BÀN PHÍMẢO (BÊN TRÁI)
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

-- PHẦN 2: CHUỘT & KHÓA FPS DOORS (BÊN PHẢI)
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
P2Title.Text = "KHÓA CHUỘT OTG (DOORS FPS)"
P2Title.TextColor3 = Color3.fromRGB(255, 215, 0)
P2Title.Font = Enum.Font.SourceSansBold
P2Title.TextSize = 12
P2Title.Parent = Part2

-- TẠO CÁC NÚT PHÍM ẢO TRONG MENU
local function createKey(text, posX, posY, sizeX, sizeY, keyCode, mouseEnum)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.Size = UDim2.new(0, sizeX, 0, sizeY)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BackgroundTransparency = 0.3
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

-- NÚT PHÍM MẪU
createKey("Chuột Trái", 5, 5, 70, 30, nil, "L")
createKey("Chuột Phải", 80, 5, 70, 30, nil, "R")
createKey("Esc", 155, 5, 35, 30, Enum.KeyCode.Escape)
createKey("Tab", 5, 40, 45, 30, Enum.KeyCode.Tab)
createKey("W", 105, 40, 35, 30, Enum.KeyCode.W)
createKey("E (Nhặt/Mở)", 145, 40, 85, 30, Enum.KeyCode.E)
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
    createKey(l, 240 + col*36, 5 + row*35, 33, 30, Enum.KeyCode[l])
end

-- ==========================================
-- CƠ CHẾ XOAY CAMERA BẰNG CHUỘT PHẢI / MOUSE LOCK DOORS FPS
-- ==========================================
local isOTGLocked = false
local isRightMouseDown = false
local lastMousePos = Vector2.new(0, 0)
local sensitivity = 0.35

local LockToggleBtn = Instance.new("TextButton")
LockToggleBtn.Size = UDim2.new(0, 195, 0, 45)
LockToggleBtn.Position = UDim2.new(0, 15, 0, 40)
LockToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
LockToggleBtn.BackgroundTransparency = 0.3
LockToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LockToggleBtn.Text = "Khóa Chuột OTG FPS: TẮT"
LockToggleBtn.Font = Enum.Font.SourceSansBold
LockToggleBtn.TextSize = 13
LockToggleBtn.Parent = Part2

local lCorner = Instance.new("UICorner")
lCorner.CornerRadius = UDim.new(0, 6)
lCorner.Parent = LockToggleBtn

-- Nhận diện rê chuột OTG khi bấm giữ Chuột Phải hoặc Bật Lock
UserInputService.InputBegan:Connect(function(input, gpe)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isRightMouseDown = true
        lastMousePos = UserInputService:GetMouseLocation()
        showPressedKey("Chuột Phải")
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        showPressedKey("Chuột Trái")
    elseif input.UserInputType == Enum.UserInputType.Keyboard then
        showPressedKey(input.KeyCode.Name)
    end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isRightMouseDown = false
        hidePressedKey("Chuột Phải")
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        hidePressedKey("Chuột Trái")
    elseif input.UserInputType == Enum.UserInputType.Keyboard then
        hidePressedKey(input.KeyCode.Name)
    end
end)

-- Thuật toán ép CFrame xoay Camera trực tiếp bằng Delta chuột OTG
RunService.RenderStepped:Connect(function()
    if isOTGLocked or isRightMouseDown then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
        local currentPos = UserInputService:GetMouseLocation()
        local delta = currentPos - lastMousePos
        lastMousePos = currentPos

        if delta.Magnitude > 0 then
            local xAngle = math.rad(-delta.X * sensitivity)
            local yAngle = math.rad(-delta.Y * sensitivity)
            
            local currentCFrame = Camera.CFrame
            local newCFrame = CFrame.new(currentCFrame.Position) 
                * CFrame.Angles(0, xAngle, 0) 
                * currentCFrame:ToWorldSpace(CFrame.Angles(yAngle, 0, 0)).Rotation
                
            Camera.CFrame = newCFrame
        end
    end
end)

LockToggleBtn.MouseButton1Click:Connect(function()
    isOTGLocked = not isOTGLocked
    if isOTGLocked then
        LockToggleBtn.Text = "Khóa Chuột OTG FPS: BẬT"
        LockToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        lastMousePos = UserInputService:GetMouseLocation()
        showNotif("Đã Khóa Chuột FPS (Xoay 360° DOORS)!")
    else
        LockToggleBtn.Text = "Khóa Chuột OTG FPS: TẮT"
        LockToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        showNotif("Đã Tắt Khóa Chuột!")
    end
end)

-- ẨN / HIỆN MENU
ToggleBtn.MouseButton1Click:Connect(function()
    MainContainer.Visible = not MainContainer.Visible
    if MainContainer.Visible then
        showNotif("Mở Menu Thành Công!")
    else
        showNotif("Ẩn Menu Thành Công!")
    end
end)

showNotif("Cập Nhật OTG FPS Rainbow Thành Công!")
