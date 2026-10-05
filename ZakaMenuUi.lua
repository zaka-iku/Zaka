-- Delta Executor: Fixed CameraScriptable 360 Lock for DOORS
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Clean GUI cũ
if LocalPlayer.PlayerGui:FindFirstChild("OTGDoorsFinalFixGUI") then
    LocalPlayer.PlayerGui.OTGDoorsFinalFixGUI:Destroy()
end

-- 1. SCREENGUI CHÍNH
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OTGDoorsFinalFixGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 2. TÂM NGẮM CHUẨN DOORS
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

-- 4. KEY VISUALIZER (TRONG SUỐT 100% + VIỀN CHỮ TRẮNG + VIỀN CẦU VỒNG RGB)
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
    
    for _, stroke in pairs(rainbowStrokes) do
        if stroke then
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
    table.insert(rainbowStrokes, outerRainbowStroke)
end

local function hidePressedKey(keyName)
    if activeVisKeys[keyName] then
        local target = activeVisKeys[keyName]
        for i, stroke in ipairs(rainbowStrokes) do
            if stroke.Parent == target then
                table.remove(rainbowStrokes, i)
                break
            end
        end
        target:Destroy()
        activeVisKeys[keyName] = nil
    end
end

-- 5. MENU TOGGLE
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 80, 0, 35)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.05, 0)
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

-- 6. MENU CONTAINER
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 780, 0, 260)
MainContainer.Position = UDim2.new(0.5, -390, 0.5, -130)
MainContainer.BackgroundTransparency = 1
MainContainer.Visible = true
MainContainer.Parent = ScreenGui

local Part1 = Instance.new("ScrollingFrame")
Part1.Size = UDim2.new(0, 510, 1, 0)
Part1.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Part1.BackgroundTransparency = 0.3
Part1.CanvasSize = UDim2.new(0, 680, 0, 230)
Part1.ScrollBarThickness = 4
Part1.Parent = MainContainer

local p1Corner = Instance.new("UICorner")
p1Corner.CornerRadius = UDim.new(0, 8)
p1Corner.Parent = Part1

local Part2 = Instance.new("Frame")
Part2.Size = UDim2.new(0, 255, 1, 0)
Part2.Position = UDim2.new(0, 525, 0, 0)
Part2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Part2.BackgroundTransparency = 0.3
Part2.Parent = MainContainer

local p2Corner = Instance.new("UICorner")
p2Corner.CornerRadius = UDim.new(0, 8)
p2Corner.Parent = Part2

local P2Title = Instance.new("TextLabel")
P2Title.Size = UDim2.new(1, 0, 0, 28)
P2Title.BackgroundTransparency = 1
P2Title.Text = "CAMERA CONTROL ENGINES"
P2Title.TextColor3 = Color3.fromRGB(255, 215, 0)
P2Title.Font = Enum.Font.SourceSansBold
P2Title.TextSize = 12
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
-- THUẬT TOÁN CAMERA OVERRIDE XOAY 360 TỰ DO
-- ==========================================
local isLockActive = false
local sensitivity = 0.35
local yaw, pitch = 0, 0

local function resetAngle()
    local _, y, _ = Camera.CFrame:ToOrientation()
    yaw = math.deg(y)
    pitch = 0
end

local LockToggleBtn = Instance.new("TextButton")
LockToggleBtn.Size = UDim2.new(0, 225, 0, 45)
LockToggleBtn.Position = UDim2.new(0, 15, 0, 40)
LockToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
LockToggleBtn.BackgroundTransparency = 0.3
LockToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LockToggleBtn.Text = "Khóa Chuột OTG 360°: TẮT"
LockToggleBtn.Font = Enum.Font.SourceSansBold
LockToggleBtn.TextSize = 13
LockToggleBtn.Parent = Part2

local lCorner = Instance.new("UICorner")
lCorner.CornerRadius = UDim.new(0, 6)
lCorner.Parent = LockToggleBtn

LockToggleBtn.MouseButton1Click:Connect(function()
    isLockActive = not isLockActive
    if isLockActive then
        LockToggleBtn.Text = "Khóa Chuột OTG 360°: BẬT"
        LockToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        
        -- Chuyển camera sang dạng Scriptable để ngắt hẳn sự can thiệp từ game DOORS
        Camera.CameraType = Enum.CameraType.Scriptable
        resetAngle()
        showNotif("Đã Bật Khóa Chuột 360°!")
    else
        LockToggleBtn.Text = "Khóa Chuột OTG 360°: TẮT"
        LockToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        
        -- Trả lại camera mặc định của game
        Camera.CameraType = Enum.CameraType.Custom
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        showNotif("Đã Tắt Khóa Chuột!")
    end
end)

-- Bắt sự kiện chuột di chuyển để tính góc quay
UserInputService.InputChanged:Connect(function(input, gpe)
    if isLockActive and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Delta
        yaw = yaw - (delta.X * sensitivity)
        pitch = math.clamp(pitch - (delta.Y * sensitivity), -85, 85)
    end
end)

-- RenderStepped ép CFrame liên tục theo vị trí đầu nhân vật
RunService.RenderStepped:Connect(function()
    if isLockActive then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("Head") then
            local headPos = character.Head.Position
            
            -- Cập nhật CFrame tự do không bị DOORS đè
            Camera.CFrame = CFrame.new(headPos) 
                * CFrame.Angles(0, math.rad(yaw), 0) 
                * CFrame.Angles(math.rad(pitch), 0, 0)
        end
    end
end)

-- Lắng nghe bấm phím
UserInputService.InputBegan:Connect(function(input, gpe)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        showPressedKey("[R-Mouse]")
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        showPressedKey("[L-Mouse]")
    elseif input.UserInputType == Enum.UserInputType.Keyboard then
        showPressedKey(input.KeyCode.Name)
    end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        hidePressedKey("[R-Mouse]")
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        hidePressedKey("[L-Mouse]")
    elseif input.UserInputType == Enum.UserInputType.Keyboard then
        hidePressedKey(input.KeyCode.Name)
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    MainContainer.Visible = not MainContainer.Visible
    if MainContainer.Visible then
        showNotif("Menu Opened")
    else
        showNotif("Menu Hidden")
    end
end)

showNotif("DOORS Fixed 360 Lock Ready!")
