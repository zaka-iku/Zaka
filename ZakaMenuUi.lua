-- ==============================================================================
-- DELTA EXECUTOR: DOORS ULTIMATE OTG ENGINE (TRUE 360 LOCK + ADVANCED ESP)
-- ==============================================================================

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local UserSettings = UserSettings():GetService("UserGameSettings")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ------------------------------------------------------------------------------
-- 1. BẢO VỆ GUI KHÔNG BỊ XÓA (COREGUI PROTECTOR)
-- ------------------------------------------------------------------------------
local TargetParent = CoreGui
pcall(function()
    if TargetParent:FindFirstChild("OTGDoorsUltimateV2") then
        TargetParent.OTGDoorsUltimateV2:Destroy()
    end
end)
if not TargetParent:FindFirstChild("OTGDoorsUltimateV2") then
    TargetParent = LocalPlayer:WaitForChild("PlayerGui")
    if TargetParent:FindFirstChild("OTGDoorsUltimateV2") then
        TargetParent.OTGDoorsUltimateV2:Destroy()
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OTGDoorsUltimateV2"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 9999999
ScreenGui.Parent = TargetParent

-- ------------------------------------------------------------------------------
-- 2. TÂM NGẮM CHUẨN GỐC (CROSSHAIR)
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
-- 3. HỆ THỐNG THÔNG BÁO & CẢNH BÁO QUÁI VẬT (ALERT NOTIFICATION)
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
    notif.BackgroundColor3 = isWarning and Color3.fromRGB(180, 20, 20) or Color3.fromRGB(20, 20, 20)
    notif.BackgroundTransparency = 0.1
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
    stroke.Color = isWarning and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(100, 100, 100)
    stroke.Thickness = 1.5
    stroke.Parent = notif

    task.delay(2.5, function()
        local tween = TweenService:Create(notif, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1})
        tween:Play()
        tween.Completed:Connect(function() notif:Destroy() end)
    end)
end

-- ------------------------------------------------------------------------------
-- 4. BẢNG KEY VISUALIZER (RGB BOARD)
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
-- 5. NÚT MỞ MENU (TOGGLE BUTTON)
-- ------------------------------------------------------------------------------
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 100, 0, 38)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.08, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
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
-- 6. GIAO DIỆN CHÍNH MENU CONTROL
-- ------------------------------------------------------------------------------
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 780, 0, 270)
MainContainer.Position = UDim2.new(0.5, -390, 0.5, -135)
MainContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainContainer.BackgroundTransparency = 0.05
MainContainer.Visible = true
MainContainer.ZIndex = 30
MainContainer.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = MainContainer

local Part1 = Instance.new("ScrollingFrame")
Part1.Size = UDim2.new(0, 480, 1, -20)
Part1.Position = UDim2.new(0, 10, 0, 10)
Part1.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Part1.CanvasSize = UDim2.new(0, 680, 0, 230)
Part1.ScrollBarThickness = 4
Part1.Parent = MainContainer

local p1Corner = Instance.new("UICorner")
p1Corner.CornerRadius = UDim.new(0, 8)
p1Corner.Parent = Part1

local Part2 = Instance.new("ScrollingFrame")
Part2.Size = UDim2.new(0, 270, 1, -20)
Part2.Position = UDim2.new(0, 500, 0, 10)
Part2.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Part2.CanvasSize = UDim2.new(0, 0, 0, 320)
Part2.ScrollBarThickness = 4
Part2.Parent = MainContainer

local p2Corner = Instance.new("UICorner")
p2Corner.CornerRadius = UDim.new(0, 8)
p2Corner.Parent = Part2

local P2Title = Instance.new("TextLabel")
P2Title.Size = UDim2.new(1, 0, 0, 35)
P2Title.BackgroundTransparency = 1
P2Title.Text = "DOORS ULTIMATE V2"
P2Title.TextColor3 = Color3.fromRGB(255, 215, 0)
P2Title.Font = Enum.Font.SourceSansBold
P2Title.TextSize = 14
P2Title.Parent = Part2

local function createKey(text, posX, posY, sizeX, sizeY, keyCode, mouseEnum)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.Size = UDim2.new(0, sizeX, 0, sizeY)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
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
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
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

-- BỎ BẢNG TẮT BẬT TÙY CHỌN 5 CHỨC NĂNG
local toggles = {
    Lock = true,
    ESPPlayers = true,
    ESPItems = true,
    ESPEntities = true,
    ESPDoors = true
}

local function createToggleBtn(title, posY, keyName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 240, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = toggles[keyName] and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40)
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
createToggleBtn("2. ESP Players", 90, "ESPPlayers")
createToggleBtn("3. ESP Items (Đồ vật)", 140, "ESPItems")
createToggleBtn("4. ESP Entities (Quái vật)", 190, "ESPEntities")
createToggleBtn("5. ESP Correct Door", 240, "ESPDoors")

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
-- 7. KHÓA CHUỘT THÔNG MINH SIÊU MẠNH (CONTEXT ACTION OVERRIDE)
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
        
        -- Dùng LockCenter ở cấp hệ thống để ẩn hoàn toàn con trỏ chuột OTG bên ngoài
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

        local currentPos = UserInputService:GetMouseLocation()
        local delta = currentPos - lastMousePos
        lastMousePos = currentPos

        -- Xử lý xoay 360 độ góc nhìn thứ 3 và thứ 1 mượt mà
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
-- 8. HỆ THỐNG ESP DOORS CHUYÊN SÂU (ITEMS, MONSTERS, DOORS, PLAYERS)
-- ------------------------------------------------------------------------------
local espFolder = Instance.new("Folder")
espFolder.Name = "DOORS_ESP_FOLDER"
espFolder.Parent = ScreenGui

local activeESPs = {}

local function createESPBox(part, text, color)
    if not part or not part:IsA("BasePart") then return end
    local id = part:GetDebugId()
    if activeESPs[id] then return end

    local bg = Instance.new("BillboardGui")
    bg.Name = id
    bg.Adornee = part
    bg.Size = UDim2.new(0, 140, 0, 30)
    bg.AlwaysOnTop = true
    bg.Parent = espFolder

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color
    lbl.TextStrokeTransparency = 0
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 13
    lbl.Parent = bg

    activeESPs[id] = bg
end

local function clearAllESP()
    espFolder:ClearAllChildren()
    activeESPs = {}
end

-- DANH SÁCH QUÁI VẬT TOÀN BỘ CÁC MODE DOORS
local monsterNames = {
    "rush", "ambush", "seek", "figure", "eyes", "halt", "screech", "dupe", 
    "hide", "jack", "dread", "a60", "a90", "a120", "depth", "silence", "blitz", "lookman"
}

-- DANH SÁCH ITEM TOÀN BỘ GAME DOORS
local itemKeywords = {
    "key", "flashlight", "lighter", "lockpick", "vitamins", "crucible", 
    "bandage", "skeletonkey", "battery", "gold", "knob", "book", "fuse", "candle"
}

local detectedMonsters = {}

task.spawn(function()
    while task.wait(0.3) do
        clearAllESP()

        -- 1. ESP PLAYERS
        if toggles.ESPPlayers then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    local dist = math.floor((hrp.Position - Camera.CFrame.Position).Magnitude)
                    createESPBox(hrp, p.Name .. " [" .. dist .. "m]", Color3.fromRGB(0, 255, 120))
                end
            end
        end

        -- 2. ESP ROOMS, DOORS & ITEMS
        local currentRooms = workspace:FindFirstChild("CurrentRooms")
        if currentRooms then
            for _, room in pairs(currentRooms:GetChildren()) do
                -- CỬA CHÍNH XÁC (CORRECT DOOR)
                if toggles.ESPDoors and room:FindFirstChild("Door") then
                    local door = room.Door
                    local doorPart = door:FindFirstChild("Door") or door:FindFirstChildWhichIsA("BasePart")
                    if doorPart then
                        createESPBox(doorPart, "🚪 Cửa " .. room.Name, Color3.fromRGB(255, 255, 0))
                    end
                end

                -- ESP ITEMS
                if toggles.ESPItems then
                    for _, obj in pairs(room:GetDescendants()) do
                        local oName = obj.Name:lower()
                        for _, key in ipairs(itemKeywords) do
                            if oName:find(key) then
                                local targetPart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                                if targetPart then
                                    createESPBox(targetPart, "📦 " .. obj.Name, Color3.fromRGB(0, 220, 255))
                                end
                                break
                            end
                        end
                    end
                end
            end
        end

        -- 3. ESP QUÁI VẬT TOÀN DIỆN & THÔNG BÁO GÓC MÀN HÌNH
        if toggles.ESPEntities then
            -- Quét cả Workspace và Camera (nơi chứa Screech/Eyes)
            local searchFolders = {workspace, Camera}
            for _, folder in ipairs(searchFolders) do
                for _, entity in pairs(folder:GetChildren()) do
                    local eName = entity.Name:lower()
                    for _, mName in ipairs(monsterNames) do
                        if eName:find(mName) then
                            local part = entity:IsA("BasePart") and entity or entity:FindFirstChildWhichIsA("BasePart")
                            if part then
                                createESPBox(part, "⚠️ " .. entity.Name:upper() .. " ⚠️", Color3.fromRGB(255, 30, 30))
                                
                                -- Thông báo góc màn hình nếu quái mới xuất hiện
                                local eId = entity:GetDebugId()
                                if not detectedMonsters[eId] then
                                    detectedMonsters[eId] = true
                                    showNotif("🚨 CẢNH BÁO: " .. entity.Name:upper() .. " XUẤT HIỆN!", true)
                                end
                            end
                            break
                        end
                    end
                end
            end
        end
    end
end)

showNotif("DOORS Ultimate V2 Ready! Bấm P hoặc nút MENU", false)
