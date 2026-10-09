-- ==============================================================================
-- DELTA EXECUTOR: DOORS ULTIMATE VIP HUB (3D HITBOX ESP + BYPASS SPEED)
-- ==============================================================================

local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local UserSettings = UserSettings():GetService("UserGameSettings")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ------------------------------------------------------------------------------
-- 1. BẢO VỆ GUI KHÔNG BỊ XÓA (COREGUI PROTECTOR)
-- ------------------------------------------------------------------------------
local TargetParent = CoreGui
pcall(function()
    if TargetParent:FindFirstChild("OTGDoorsVIPGUI") then
        TargetParent.OTGDoorsVIPGUI:Destroy()
    end
end)
if not TargetParent:FindFirstChild("OTGDoorsVIPGUI") then
    TargetParent = LocalPlayer:WaitForChild("PlayerGui")
    if TargetParent:FindFirstChild("OTGDoorsVIPGUI") then
        TargetParent.OTGDoorsVIPGUI:Destroy()
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OTGDoorsVIPGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 9999999
ScreenGui.Parent = TargetParent

-- ------------------------------------------------------------------------------
-- 2. TÂM NGẮM CHUẨN CROSSHAIR
-- ------------------------------------------------------------------------------
local NativeCenterDot = Instance.new("Frame")
NativeCenterDot.Size = UDim2.new(0, 5, 0, 5)
NativeCenterDot.AnchorPoint = Vector2.new(0.5, 0.5)
NativeCenterDot.Position = UDim2.new(0.5, 0, 0.5, 0)
NativeCenterDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NativeCenterDot.ZIndex = 10
NativeCenterDot.Parent = ScreenGui

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = NativeCenterDot

local dotStroke = Instance.new("UIStroke")
dotStroke.Color = Color3.fromRGB(0, 0, 0)
dotStroke.Thickness = 1.2
dotStroke.Parent = NativeCenterDot

-- ------------------------------------------------------------------------------
-- 3. HỆ THỐNG THÔNG BÁO CẢNH BÁO CỬA & QUÁI
-- ------------------------------------------------------------------------------
local NotifContainer = Instance.new("Frame")
NotifContainer.Size = UDim2.new(0, 300, 0, 200)
NotifContainer.Position = UDim2.new(0.5, -150, 0.05, 0)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 5)
NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NotifLayout.Parent = NotifContainer

local function showNotif(text, isWarning)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 280, 0, 35)
    notif.BackgroundColor3 = isWarning and Color3.fromRGB(180, 20, 20) or Color3.fromRGB(15, 15, 15)
    notif.BackgroundTransparency = 0.2
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.Text = text
    notif.Font = Enum.Font.SourceSansBold
    notif.TextSize = 14
    notif.ZIndex = 20
    notif.Parent = NotifContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif

    local stroke = Instance.new("UIStroke")
    stroke.Color = isWarning and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(0, 150, 255)
    stroke.Thickness = 1.5
    stroke.Parent = notif

    task.delay(2.5, function()
        local tween = TweenService:Create(notif, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1})
        tween:Play()
        tween.Completed:Connect(function() notif:Destroy() end)
    end)
end

-- ------------------------------------------------------------------------------
-- 4. BẢNG KEY VISUALIZER (RGB STROKE)
-- ------------------------------------------------------------------------------
local VisFrame = Instance.new("Frame")
VisFrame.Size = UDim2.new(0, 450, 0, 60)
VisFrame.Position = UDim2.new(0.02, 0, 0.82, 0)
VisFrame.BackgroundTransparency = 1
VisFrame.Parent = ScreenGui

local VisLayout = Instance.new("UIListLayout")
VisLayout.FillDirection = Enum.FillDirection.Horizontal
VisLayout.SortOrder = Enum.SortOrder.LayoutOrder
VisLayout.Padding = UDim.new(0, 8)
VisLayout.Parent = VisFrame

local activeVisKeys = {}
local rainbowStrokes = {}

local hue = 0
RunService.RenderStepped:Connect(function(delta)
    hue = (hue + delta * 0.8) % 1
    local rainbowColor = Color3.fromHSV(hue, 1, 1)
    for stroke, _ in pairs(rainbowStrokes) do
        if stroke and stroke.Parent then stroke.Color = rainbowColor end
    end
end)

local function showPressedKey(keyName)
    if activeVisKeys[keyName] then return end
    local keyLbl = Instance.new("TextLabel")
    keyLbl.Size = UDim2.new(0, 45, 0, 45)
    keyLbl.BackgroundTransparency = 1
    keyLbl.Text = keyName
    keyLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyLbl.Font = Enum.Font.SourceSansBold
    keyLbl.TextSize = 15
    keyLbl.Parent = VisFrame

    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(0, 6)
    kCorner.Parent = keyLbl

    local outerRainbowStroke = Instance.new("UIStroke")
    outerRainbowStroke.Thickness = 3
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

-- ------------------------------------------------------------------------------
-- 5. NÚT MENU (TOGGLE BUTTON)
-- ------------------------------------------------------------------------------
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 100, 0, 38)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.08, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ToggleBtn.BackgroundTransparency = 0.2
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "MENU (P)"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 15
ToggleBtn.ZIndex = 30
ToggleBtn.Parent = ScreenGui

local tCorner = Instance.new("UICorner")
tCorner.CornerRadius = UDim.new(0, 8)
tCorner.Parent = ToggleBtn

-- ------------------------------------------------------------------------------
-- 6. GIAO DIỆN CHÍNH MENU IN-SUỐT (GLASSMORPHISM)
-- ------------------------------------------------------------------------------
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 780, 0, 280)
MainContainer.Position = UDim2.new(0.5, -390, 0.5, -140)
MainContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainContainer.BackgroundTransparency = 0.45 -- Trong suốt mượt mà
MainContainer.Visible = true
MainContainer.ZIndex = 30
MainContainer.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = MainContainer

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 180, 255)
mainStroke.Thickness = 1.8
mainStroke.Transparency = 0.3
mainStroke.Parent = MainContainer

local Part1 = Instance.new("ScrollingFrame")
Part1.Size = UDim2.new(0, 470, 1, -20)
Part1.Position = UDim2.new(0, 10, 0, 10)
Part1.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Part1.BackgroundTransparency = 0.5
Part1.CanvasSize = UDim2.new(0, 680, 0, 230)
Part1.ScrollBarThickness = 4
Part1.Parent = MainContainer

local p1Corner = Instance.new("UICorner")
p1Corner.CornerRadius = UDim.new(0, 8)
p1Corner.Parent = Part1

local Part2 = Instance.new("ScrollingFrame")
Part2.Size = UDim2.new(0, 280, 1, -20)
Part2.Position = UDim2.new(0, 490, 0, 10)
Part2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Part2.BackgroundTransparency = 0.5
Part2.CanvasSize = UDim2.new(0, 0, 0, 420)
Part2.ScrollBarThickness = 4
Part2.Parent = MainContainer

local p2Corner = Instance.new("UICorner")
p2Corner.CornerRadius = UDim.new(0, 8)
p2Corner.Parent = Part2

local P2Title = Instance.new("TextLabel")
P2Title.Size = UDim2.new(1, 0, 0, 35)
P2Title.BackgroundTransparency = 1
P2Title.Text = "DOORS VIP MENU ENGINE"
P2Title.TextColor3 = Color3.fromRGB(255, 215, 0)
P2Title.Font = Enum.Font.SourceSansBold
P2Title.TextSize = 14
P2Title.Parent = Part2

local function createKey(text, posX, posY, sizeX, sizeY, keyCode, mouseEnum)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.Size = UDim2.new(0, sizeX, 0, sizeY)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
        if keyCode then VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
        elseif mouseEnum then VirtualInputManager:SendMouseButtonEvent(0, 0, mouseEnum == "L" and 0 or 1, true, game, 0) end
    end)

    btn.MouseButton1Up:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        hidePressedKey(text)
        if keyCode then VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
        elseif mouseEnum then VirtualInputManager:SendMouseButtonEvent(0, 0, mouseEnum == "L" and 0 or 1, false, game, 0) end
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
-- BẢNG CÔNG TẮC & TÙY CHỈNH CHỨC NĂNG
-- ==========================================
local toggles = {
    Lock = true,
    ESPDoors = true,      -- Cửa đúng (Màu Hồng)
    ESPItems = true,      -- Item quan trọng + Đồ trong tủ (Xanh Nước Biển)
    ESPEntities = true,   -- Quái vật (Đỏ Rực Hitbox)
    FullBright = false,   -- Nhìn đêm
    SpeedHack = false,    -- Tăng tốc
    FOVHack = false       -- Góc nhìn rộng
}

local walkSpeedValue = 22
local fovValue = 100

local function createToggleBtn(title, posY, keyName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 250, 0, 38)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = toggles[keyName] and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40)
    btn.BackgroundTransparency = 0.2
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = title .. ": " .. (toggles[keyName] and "ON" or "OFF")
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.Parent = Part2

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        toggles[keyName] = not toggles[keyName]
        btn.BackgroundColor3 = toggles[keyName] and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40)
        btn.Text = title .. ": " .. (toggles[keyName] and "ON" or "OFF")
        showNotif(title .. ": " .. (toggles[keyName] and "BẬT" or "TẮT"), false)
    end)
end

createToggleBtn("1. Smart PC Lock 360°", 40, "Lock")
createToggleBtn("2. ESP Correct Door (Hồng)", 85, "ESPDoors")
createToggleBtn("3. ESP Key/Item/In-Locker (Cyan)", 130, "ESPItems")
createToggleBtn("4. ESP Monsters Hitbox (Đỏ Rực)", 175, "ESPEntities")
createToggleBtn("5. FullBright (Sáng Màn Hình)", 220, "FullBright")
createToggleBtn("6. SpeedHack (Bypass Anti-Cheat)", 265, "SpeedHack")

-- Tăng giảm tốc độ
local SpeedAddBtn = Instance.new("TextButton")
SpeedAddBtn.Size = UDim2.new(0, 120, 0, 30)
SpeedAddBtn.Position = UDim2.new(0, 10, 0, 310)
SpeedAddBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedAddBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedAddBtn.Text = "Tốc độ: " .. walkSpeedValue
SpeedAddBtn.Font = Enum.Font.SourceSansBold
SpeedAddBtn.TextSize = 12
SpeedAddBtn.Parent = Part2

SpeedAddBtn.MouseButton1Click:Connect(function()
    walkSpeedValue = walkSpeedValue + 2
    if walkSpeedValue > 45 then walkSpeedValue = 16 end
    SpeedAddBtn.Text = "Tốc độ: " .. walkSpeedValue
end)

createToggleBtn("7. Tầm Nhìn Rộng (FOV 100)", 350, "FOVHack")

local isMenuOpen = true
local function toggleMenu()
    MainContainer.Visible = not MainContainer.Visible
    isMenuOpen = MainContainer.Visible
    showNotif(isMenuOpen and "Menu Opened" or "Menu Hidden", false)
end

ToggleBtn.MouseButton1Click:Connect(toggleMenu)

UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.P and not gpe then
        toggleMenu()
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then showPressedKey("[R-Mouse]")
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then showPressedKey("[L-Mouse]")
    elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.P then
        showPressedKey(input.KeyCode.Name)
    end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then hidePressedKey("[R-Mouse]")
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then hidePressedKey("[L-Mouse]")
    elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.P then
        hidePressedKey(input.KeyCode.Name)
    end
end)

-- ------------------------------------------------------------------------------
-- 7. KHÓA CHUỘT THÔNG MINH SIÊU MẠNH (360 DEGREE ENGINE)
-- ------------------------------------------------------------------------------
local cameraSens = 0.003
local pitch, yaw = 0, 0
local lastMousePos = UserInputService:GetMouseLocation()

RunService.RenderStepped:Connect(function()
    local isRobloxMenuOpen = GuiService:GetMenuIsOpen()

    if isRobloxMenuOpen or isMenuOpen then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
        UserSettings.RotationType = Enum.RotationType.MovementRelative
        return
    end

    if toggles.Lock then
        UserInputService.MouseIconEnabled = false
        UserSettings.RotationType = Enum.RotationType.CameraRelative
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

        local currentPos = UserInputService:GetMouseLocation()
        local delta = currentPos - lastMousePos
        lastMousePos = currentPos

        if delta.Magnitude > 0 and delta.Magnitude < 100 then
            local isFirstPerson = false
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                local dist = (Camera.CFrame.Position - LocalPlayer.Character.Head.Position).Magnitude
                if dist < 2 then isFirstPerson = true end
            end

            if not isFirstPerson then
                Camera.CameraType = Enum.CameraType.Scriptable
                yaw = (yaw - (delta.X * cameraSens)) % (math.pi * 2)
                pitch = math.clamp(pitch - (delta.Y * cameraSens), math.rad(-80), math.rad(80))

                Camera.CFrame = CFrame.new(Camera.CFrame.Position) 
                    * CFrame.Angles(0, yaw, 0) 
                    * CFrame.Angles(pitch, 0, 0)
            else
                Camera.CameraType = Enum.CameraType.Custom
            end
        end
    else
        UserSettings.RotationType = Enum.RotationType.MovementRelative
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
        if Camera.CameraType == Enum.CameraType.Scriptable then
            Camera.CameraType = Enum.CameraType.Custom
        end
    end
end)

-- ------------------------------------------------------------------------------
-- 8. SPEEDHACK (BYPASS ANTI-CHEAT VỚI ASSEMBLY VELOCITY) & FULLBRIGHT & FOV
-- ------------------------------------------------------------------------------
RunService.Stepped:Connect(function()
    if toggles.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0 then
            hrp.AssemblyLinearVelocity = Vector3.new(
                hum.MoveDirection.X * walkSpeedValue,
                hrp.AssemblyLinearVelocity.Y,
                hum.MoveDirection.Z * walkSpeedValue
            )
        end
    end

    if toggles.FullBright then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
    end

    if toggles.FOVHack then
        Camera.FieldOfView = fovValue
    end
end)

-- ------------------------------------------------------------------------------
-- 9. HỆ THỐNG 3D HITBOX BOX ESP (CỬA HỒNG, ITEM XANH, QUÁI ĐỎ) + 500M LIMIT
-- ------------------------------------------------------------------------------
local espFolder = Instance.new("Folder")
espFolder.Name = "VIP_3D_HITBOX_ESP"
espFolder.Parent = ScreenGui

local activeESPs = {}

-- Hàm tạo ESP 3D Hitbox Viền
local function create3DHitboxESP(targetModel, nameText, color, isMonster)
    if not targetModel then return end
    local id = targetModel:GetDebugId()
    if activeESPs[id] then return end

    local primaryPart = targetModel:IsA("BasePart") and targetModel or targetModel:FindFirstChildWhichIsA("BasePart")
    if not primaryPart then return end

    -- Tạo 3D Highlight Viền (Hitbox)
    local highlight = Instance.new("Highlight")
    highlight.Name = id .. "_Highlight"
    highlight.Adornee = targetModel
    highlight.FillTransparency = isMonster and 0.4 or 0.8
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.OutlineTransparency = 0
    highlight.Parent = espFolder

    -- Tạo Billboard Name
    local bg = Instance.new("BillboardGui")
    bg.Name = id .. "_Billboard"
    bg.Adornee = primaryPart
    bg.Size = UDim2.new(0, 160, 0, 30)
    bg.AlwaysOnTop = true
    bg.Parent = espFolder

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = nameText
    lbl.TextColor3 = color
    lbl.TextStrokeTransparency = 0
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 13
    lbl.Parent = bg

    activeESPs[id] = {Highlight = highlight, Billboard = bg, Part = primaryPart}
end

local function clearAllESP()
    espFolder:ClearAllChildren()
    activeESPs = {}
end

-- TỪ KHÓA ITEM QUAN TRỌNG (GỒM CẢ ĐỒ TRONG TỦ & SÁCH PHÒNG 50)
local vipItems = {
    "key", "flashlight", "lighter", "lockpick", "vitamins", 
    "crucible", "bandage", "skeletonkey", "battery", "gun", "book", "fuse", "candle"
}

-- DANH SÁCH QUÁI VẬT TOÀN BỘ DOORS
local monsterList = {
    "rush", "ambush", "seek", "figure", "eyes", "halt", "screech", 
    "dupe", "hide", "jack", "dread", "a60", "a90", "a120", "blitz", "lookman"
}

local detectedMonsters = {}

task.spawn(function()
    while task.wait(0.35) do
        clearAllESP()
        local myPos = Camera.CFrame.Position

        -- 1. ESP CỬA ĐÚNG (MÀU HỒNG - PINK) - GIỚI HẠN 500M
        if toggles.ESPDoors then
            local currentRooms = workspace:FindFirstChild("CurrentRooms")
            if currentRooms then
                for _, room in pairs(currentRooms:GetChildren()) do
                    local door = room:FindFirstChild("Door")
                    if door then
                        local doorPart = door:FindFirstChild("Door") or door:FindFirstChildWhichIsA("BasePart")
                        if doorPart then
                            local dist = (doorPart.Position - myPos).Magnitude
                            -- Giới hạn 500m để đỡ lag
                            if dist <= 500 then
                                create3DHitboxESP(door, "🚪 Cửa " .. room.Name .. " [" .. math.floor(dist) .. "m]", Color3.fromRGB(255, 105, 180), false)
                            end
                        end
                    end
                end
            end
        end

        -- 2. ESP ITEM QUAN TRỌNG & ĐỒ TRONG TỦ (MÀU XANH NƯỚC BIỂN - CYAN) - GIỚI HẠN 500M
        if toggles.ESPItems then
            local currentRooms = workspace:FindFirstChild("CurrentRooms")
            if currentRooms then
                for _, room in pairs(currentRooms:GetChildren()) do
                    for _, obj in pairs(room:GetDescendants()) do
                        local oName = obj.Name:lower()
                        for _, itemKey in ipairs(vipItems) do
                            if oName:find(itemKey) then
                                local targetPart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                                if targetPart then
                                    local dist = (targetPart.Position - myPos).Magnitude
                                    if dist <= 500 then
                                        local isInLocker = false
                                        if obj:FindFirstAncestor("Wardrobe") or obj:FindFirstAncestor("Drawer") or obj:FindFirstAncestor("Chest") then
                                            isInLocker = true
                                        end
                                        local labelText = (isInLocker and "[Tủ] " or "[Item] ") .. obj.Name .. " [" .. math.floor(dist) .. "m]"
                                        create3DHitboxESP(obj, labelText, Color3.fromRGB(0, 220, 255), false)
                                    end
                                end
                                break
                            end
                        end
                    end
                end
            end
        end

        -- 3. ESP QUÁI VẬT HITBOX 3D (MÀU ĐỎ RỰC - RED)
        if toggles.ESPEntities then
            local searchFolders = {workspace, Camera}
            for _, folder in ipairs(searchFolders) do
                for _, entity in pairs(folder:GetChildren()) do
                    local eName = entity.Name:lower()
                    for _, mName in ipairs(monsterList) do
                        if eName:find(mName) then
                            create3DHitboxESP(entity, "⚠️ " .. entity.Name:upper() .. " ⚠️", Color3.fromRGB(255, 0, 0), true)
                            
                            local eId = entity:GetDebugId()
                            if not detectedMonsters[eId] then
                                detectedMonsters[eId] = true
                                showNotif("🚨 CẢNH BÁO: " .. entity.Name:upper() .. " ĐANG ĐẾN!", true)
                            end
                            break
                        end
                    end
                end
            end
        end
    end
end)

showNotif("DOORS VIP Hub Loaded Successfully!", false)
