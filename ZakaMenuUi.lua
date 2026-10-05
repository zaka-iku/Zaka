-- Delta Executor: Exact DOORS Native Center Crosshair + Virtual Touch Camera Engine
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Clean GUI cũ
if LocalPlayer.PlayerGui:FindFirstChild("OTGDoorsNativeGUI") then
    LocalPlayer.PlayerGui.OTGDoorsNativeGUI:Destroy()
end

-- 1. SCREENGUI CHÍNH (IgnoreGuiInset = true để chuẩn tâm màn hình gốc)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OTGDoorsNativeGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true -- Căn chuẩn tâm gốc Roblox/DOORS không bị lệch bởi dải thông báo trên
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 2. TÂM NGẮM CHUẨN TÂM GỐC DOORS (EXACT NATIVE CROSSHAIR)
local NativeCenterDot = Instance.new("Frame")
NativeCenterDot.Size = UDim2.new(0, 4, 0, 4)
NativeCenterDot.AnchorPoint = Vector2.new(0.5, 0.5) -- Neo đúng trung tâm 50% - 50%
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
    notif.Size = UDim2.new(0, 240, 0, 35)
    notif.Position = UDim2.new(0.5, -120, 0.08, 0)
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

-- 4. BẢNG KEY VISUALIZER (TRONG SUỐT 100% + VIỀN CHỮ TRẮNG + VIỀN NGOÀI CẦU VỒNG RGB)
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
P2Title.Text = "DOORS LOCK ENGINES"
P2Title.TextColor3 = Color3.fromRGB(255, 215, 0)
P2Title.Font = Enum.Font.SourceSansBold
P2Title.TextSize = 13
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
-- BỘ CHUYỂN ĐỔI LOCK ENGINES (CÓ CHẾ ĐỘ MÔ PHỎNG TOUCH SWIPE)
-- ==========================================
local currentLockEngine = 2 -- Mặc định dùng Engine 2 (CFrame Delta)
local lastMousePos = Vector2.new(0, 0)
local sensitivity = 0.35

local function createLockOptionBtn(text, engineId, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 225, 0, 36)
    btn.Position = UDim2.new(0, 15, 0, posY)
    btn.BackgroundColor3 = (engineId == currentLockEngine and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40))
    btn.BackgroundTransparency = 0.3
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.Parent = Part2

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if currentLockEngine == engineId then
            currentLockEngine = 0
            btn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            showNotif("Engine Disabled")
        else
            currentLockEngine = engineId
            for _, child in pairs(Part2:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
            lastMousePos = UserInputService:GetMouseLocation()
            showNotif("Activated: " .. text)
        end
    end)
end

createLockOptionBtn("Engine 1: LockCenter Native", 1, 35)
createLockOptionBtn("Engine 2: CFrame Angle Fix (FPS)", 2, 80)
createLockOptionBtn("Engine 3: Virtual Touch Swipe", 3, 125)
createLockOptionBtn("Engine 4: Hard Position Freeze", 4, 170)

local isRightMouseDown = false

UserInputService.InputBegan:Connect(function(input, gpe)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isRightMouseDown = true
        lastMousePos = UserInputService:GetMouseLocation()
        showPressedKey("[R-Mouse]")
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        showPressedKey("[L-Mouse]")
    elseif input.UserInputType == Enum.UserInputType.Keyboard then
        showPressedKey(input.KeyCode.Name)
    end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isRightMouseDown = false
        hidePressedKey("[R-Mouse]")
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        hidePressedKey("[L-Mouse]")
    elseif input.UserInputType == Enum.UserInputType.Keyboard then
        hidePressedKey(input.KeyCode.Name)
    end
end)

-- VÒNG LẶP KHÓA MẠNH MẼ KHÔNG LỆCH TÂM
RunService.RenderStepped:Connect(function()
    if isRightMouseDown or currentLockEngine > 0 then
        if currentLockEngine == 1 then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        elseif currentLockEngine == 2 or isRightMouseDown then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
            local currentPos = UserInputService:GetMouseLocation()
            local delta = currentPos - lastMousePos
            lastMousePos = currentPos

            if delta.Magnitude > 0 then
                local xAngle = math.rad(-delta.X * sensitivity)
                local yAngle = math.rad(-delta.Y * sensitivity)
                local curCFrame = Camera.CFrame
                Camera.CFrame = CFrame.new(curCFrame.Position) 
                    * CFrame.Angles(0, xAngle, 0) 
                    * curCFrame:ToWorldSpace(CFrame.Angles(yAngle, 0, 0)).Rotation
            end
        elseif currentLockEngine == 3 then
            -- Giả lập vuốt ngón tay nửa phải màn hình
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
            local currentPos = UserInputService:GetMouseLocation()
            local delta = currentPos - lastMousePos
            lastMousePos = currentPos
            
            if delta.Magnitude > 0 then
                VirtualInputManager:SendPanGestureEvent(
                    Vector2.new(Camera.ViewportSize.X * 0.75, Camera.ViewportSize.Y * 0.5),
                    delta * sensitivity,
                    0,
                    Enum.UserInputState.Change,
                    game
                )
            end
        elseif currentLockEngine == 4 then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        end
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

showNotif("DOORS Native Center Fixed")
