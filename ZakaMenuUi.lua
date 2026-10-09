-- Delta Executor: Exact DOORS Native Center Crosshair + CoreGui Protected Menu
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 1. TỰ ĐỘNG CHỌN NƠI LƯU GUI BẢO VỆ KHÔNG BỊ XÓA (CoreGui hoặc PlayerGui)
local CoreGui = game:GetService("CoreGui")
local TargetParent = CoreGui
pcall(function()
    if TargetParent:FindFirstChild("OTGDoorsNativeGUI") then
        TargetParent.OTGDoorsNativeGUI:Destroy()
    end
end)
if not TargetParent:FindFirstChild("OTGDoorsNativeGUI") then
    TargetParent = LocalPlayer:WaitForChild("PlayerGui")
    if TargetParent:FindFirstChild("OTGDoorsNativeGUI") then
        TargetParent.OTGDoorsNativeGUI:Destroy()
    end
end

-- SCREENGUI CHÍNH
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OTGDoorsNativeGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999
ScreenGui.Parent = TargetParent

-- 2. TÂM NGẮM CHUẨN TÂM GỐC DOORS
local NativeCenterDot = Instance.new("Frame")
NativeCenterDot.Size = UDim2.new(0, 4, 0, 4)
NativeCenterDot.AnchorPoint = Vector2.new(0.5, 0.5)
NativeCenterDot.Position = UDim2.new(0.5, 0, 0.5, 0)
NativeCenterDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NativeCenterDot.BackgroundTransparency = 0
NativeCenterDot.Visible = true
NativeCenterDot.Parent = ScreenGui

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = NativeCenterDot

local dotStroke = Instance.new("UIStroke")
dotStroke.Color = Color3.fromRGB(0, 0, 0)
dotStroke.Transparency = 0.4
dotStroke.Thickness = 1
dotStroke.Parent = NativeCenterDot

-- 3. HÀM POPUP THÔNG BÁO
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

-- 4. BẢNG KEY VISUALIZER (CẬP NHẬT RGB)
local VisFrame = Instance.new("Frame")
VisFrame.Size = UDim2.new(0, 450, 0, 60)
VisFrame.Position = UDim2.new(0.02, 0, 0.82, 0)
VisFrame.BackgroundTransparency = 1
VisFrame.Parent = ScreenGui

local VisLayout = Instance.new("UIListLayout")
VisLayout.FillDirection = Enum.FillDirection.Horizontal
VisLayout.SortOrder = Enum.SortOrder.LayoutOrder
VisLayout.Padding = UDim.new(0, 10)
VisLayout.Parent = VisFrame

local activeVisKeys = {}
local rainbowStrokes = {}

local hue = 0
RunService.RenderStepped:Connect(function(delta)
    hue = (hue + delta * 0.8) % 1
    local rainbowColor = Color3.fromHSV(hue, 1, 1)
    
    for stroke, _ in pairs(rainbowStrokes) do
        if stroke and stroke.Parent then
            stroke.Color = rainbowColor
        end
    end
end)

local function showPressedKey(keyName)
    if activeVisKeys[keyName] then return end
    
    local keyLbl = Instance.new("TextLabel")
    keyLbl.Size = UDim2.new(0, 50, 0, 50)
    keyLbl.BackgroundTransparency = 1
    keyLbl.Text = keyName
    keyLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyLbl.Font = Enum.Font.SourceSansBold
    keyLbl.TextSize = 16
    keyLbl.Parent = VisFrame

    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(0, 8)
    kCorner.Parent = keyLbl

    local textStroke = Instance.new("UIStroke")
    textStroke.Color = Color3.fromRGB(255, 255, 255)
    textStroke.Transparency = 0.2
    textStroke.Thickness = 1.2
    textStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    textStroke.Parent = keyLbl

    local outerRainbowStroke = Instance.new("UIStroke")
    outerRainbowStroke.Thickness = 3.5
    outerRainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    outerRainbowStroke.Parent = keyLbl

    activeVisKeys[keyName] = keyLbl
    rainbowStrokes[outerRainbowStroke] = true
end

local function hidePressedKey(keyName)
    if activeVisKeys[keyName] then
        local target = activeVisKeys[keyName]
        for stroke, _ in pairs(rainbowStrokes) do
            if stroke.Parent == target then
                rainbowStrokes[stroke] = nil
                break
            end
        end
        target:Destroy()
        activeVisKeys[keyName] = nil
    end
end

-- 5. NÚT TOGGLE MENU MÀU NỔI BẬT NỐT TRÊN GÓC MÀN HÌNH
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 100, 0, 40)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.1, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ToggleBtn.BackgroundTransparency = 0.1
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "MENU (P)"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 15
ToggleBtn.Parent = ScreenGui

local tCorner = Instance.new("UICorner")
tCorner.CornerRadius = UDim.new(0, 8)
tCorner.Parent = ToggleBtn

-- 6. MENU CONTAINER CHÍNH
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 780, 0, 260)
MainContainer.Position = UDim2.new(0.5, -390, 0.5, -130)
MainContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainContainer.BackgroundTransparency = 0.1
MainContainer.Visible = true
MainContainer.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = MainContainer

local Part1 = Instance.new("ScrollingFrame")
Part1.Size = UDim2.new(0, 510, 1, -20)
Part1.Position = UDim2.new(0, 10, 0, 10)
Part1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Part1.BackgroundTransparency = 0.2
Part1.CanvasSize = UDim2.new(0, 680, 0, 230)
Part1.ScrollBarThickness = 4
Part1.Parent = MainContainer

local p1Corner = Instance.new("UICorner")
p1Corner.CornerRadius = UDim.new(0, 8)
p1Corner.Parent = Part1

local Part2 = Instance.new("Frame")
Part2.Size = UDim2.new(0, 240, 1, -20)
Part2.Position = UDim2.new(0, 530, 0, 10)
Part2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Part2.BackgroundTransparency = 0.2
Part2.Parent = MainContainer

local p2Corner = Instance.new("UICorner")
p2Corner.CornerRadius = UDim.new(0, 8)
p2Corner.Parent = Part2

local P2Title = Instance.new("TextLabel")
P2Title.Size = UDim2.new(1, 0, 0, 40)
P2Title.BackgroundTransparency = 1
P2Title.Text = "SMART PC LOCK ENGINE"
P2Title.TextColor3 = Color3.fromRGB(255, 215, 0)
P2Title.Font = Enum.Font.SourceSansBold
P2Title.TextSize = 14
P2Title.Parent = Part2

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

createKey("[L-Mouse]", 5, 5, 75, 30, nil, "L")
createKey("[R-Mouse]", 85, 5, 75, 30, nil, "R")
createKey("Esc", 165, 5, 35, 30, Enum.KeyCode.Escape)
createKey("Tab", 5, 40, 45, 30, Enum.KeyCode.Tab)
createKey("W", 105, 40, 35, 30, Enum.KeyCode.W)
createKey("E", 145, 40, 45, 30, Enum.KeyCode.E)
createKey("A", 65, 75, 35, 30, Enum.KeyCode.A)
createKey("S", 105, 75, 35, 30, Enum.KeyCode.S)
createKey("D", 145, 75, 35, 30, Enum.KeyCode.D)
createKey("Shift", 5, 110, 55, 30, Enum.KeyCode.LeftShift)
createKey("C", 65, 110, 45, 30, Enum.KeyCode.C)
createKey("Space", 115, 110, 75, 30, Enum.KeyCode.Space)

local letters = {"Q","R","T","Y","U","I","O","P","F","G","H","J","K","L","Z","X","V","B","N","M"}
for i, l in ipairs(letters) do
    local row = math.floor((i-1)/5)
    local col = (i-1)%5
    createKey(l, 200 + col*36, 5 + row*35, 33, 30, Enum.KeyCode[l])
end

-- ==========================================
-- NÚT BẬT TẮT KHÓA CHUỘT DẠNG CÔNG TẮC CỰC NHẠY
-- ==========================================
local isPCLockActive = true
local isMenuOpen = true
local lastMousePos = UserInputService:GetMouseLocation()
local sensitivity = 0.003
local pitch = 0
local yaw = 0

local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(0, 210, 0, 55)
LockBtn.Position = UDim2.new(0, 15, 0, 90)
LockBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
LockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LockBtn.Text = "TRUE PC LOCK: ON"
LockBtn.Font = Enum.Font.SourceSansBold
LockBtn.TextSize = 14
LockBtn.Parent = Part2

local lCorner = Instance.new("UICorner")
lCorner.CornerRadius = UDim.new(0, 8)
lCorner.Parent = LockBtn

local function toggleMenu()
    MainContainer.Visible = not MainContainer.Visible
    isMenuOpen = MainContainer.Visible
    if isMenuOpen then
        showNotif("Menu Opened")
    else
        showNotif("Menu Hidden")
    end
end

-- Bấm nút MENU màu xanh trên góc màn hình
ToggleBtn.MouseButton1Click:Connect(toggleMenu)

-- Bấm phím P trên bàn phím
UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.P and not gpe then
        toggleMenu()
    end
end)

LockBtn.MouseButton1Click:Connect(function()
    isPCLockActive = not isPCLockActive
    if isPCLockActive then
        LockBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        LockBtn.Text = "TRUE PC LOCK: ON"
        showNotif("Khóa Chuột PC: ĐÃ BẬT")
        
        local rx, ry, _ = Camera.CFrame:ToOrientation()
        pitch = rx
        yaw = ry
        lastMousePos = UserInputService:GetMouseLocation()
    else
        LockBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        LockBtn.Text = "TRUE PC LOCK: OFF"
        showNotif("Khóa Chuột PC: ĐÃ TẮT")
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        showPressedKey("[R-Mouse]")
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        showPressedKey("[L-Mouse]")
    elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.P then
        showPressedKey(input.KeyCode.Name)
    end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        hidePressedKey("[R-Mouse]")
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        hidePressedKey("[L-Mouse]")
    elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.P then
        hidePressedKey(input.KeyCode.Name)
    end
end)

-- VÒNG LẶP XỬ LÝ
RunService.RenderStepped:Connect(function()
    local isRobloxMenuOpen = GuiService:GetMenuIsOpen()

    if isRobloxMenuOpen or isMenuOpen then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
        if Camera.CameraType == Enum.CameraType.Scriptable then
            Camera.CameraType = Enum.CameraType.Custom
        end
        return
    end

    if isPCLockActive then
        UserInputService.MouseIconEnabled = false
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
        Camera.CameraType = Enum.CameraType.Scriptable

        local currentPos = UserInputService:GetMouseLocation()
        local delta = currentPos - lastMousePos
        lastMousePos = currentPos

        if delta.Magnitude > 0 then
            yaw = (yaw - (delta.X * sensitivity)) % (math.pi * 2)
            pitch = math.clamp(pitch - (delta.Y * sensitivity), math.rad(-80), math.rad(80))

            Camera.CFrame = CFrame.new(Camera.CFrame.Position) 
                * CFrame.Angles(0, yaw, 0) 
                * CFrame.Angles(pitch, 0, 0)
        end
    else
        UserInputService.MouseIconEnabled = true
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        if Camera.CameraType == Enum.CameraType.Scriptable then
            Camera.CameraType = Enum.CameraType.Custom
        end
    end
end)

showNotif("DOORS OTG Loaded Successfully!")
