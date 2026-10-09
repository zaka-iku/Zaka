-- ==============================================================================
-- DOORS OTG ULTIMATE VIP V3 - FIXED ESP, TRACERS & BYPASS SPEED
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

-- 1. BẢO VỆ GUI KHÔNG BỊ XÓA
local TargetParent = CoreGui
pcall(function()
    if TargetParent:FindFirstChild("OTGDoorsVIPV3") then
        TargetParent.OTGDoorsVIPV3:Destroy()
    end
end)
if not TargetParent:FindFirstChild("OTGDoorsVIPV3") then
    TargetParent = LocalPlayer:WaitForChild("PlayerGui")
    if TargetParent:FindFirstChild("OTGDoorsVIPV3") then
        TargetParent.OTGDoorsVIPV3:Destroy()
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OTGDoorsVIPV3"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 9999999
ScreenGui.Parent = TargetParent

-- 2. TÂM NGẮM CROSSHAIR
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

-- 3. HỆ THỐNG THÔNG BÁO QUÁI VẬT (NỀN ĐEN, CHỮ TRẮNG, VIỀN CẦU VỒNG)
local NotifContainer = Instance.new("Frame")
NotifContainer.Size = UDim2.new(0, 320, 0, 200)
NotifContainer.Position = UDim2.new(0.5, -160, 0.05, 0)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 6)
NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NotifLayout.Parent = NotifContainer

local rainbowStrokes = {}
local hue = 0
RunService.RenderStepped:Connect(function(delta)
    hue = (hue + delta * 0.8) % 1
    local rainbowColor = Color3.fromHSV(hue, 1, 1)
    for stroke, _ in pairs(rainbowStrokes) do
        if stroke and stroke.Parent then stroke.Color = rainbowColor end
    end
end)

local function showMonsterAlert(text)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 300, 0, 40)
    notif.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    notif.BackgroundTransparency = 0.15
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.Text = text
    notif.Font = Enum.Font.SourceSansBold
    notif.TextSize = 14
    notif.ZIndex = 25
    notif.Parent = NotifContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif

    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Thickness = 2.5
    rainbowStroke.Parent = notif
    rainbowStrokes[rainbowStroke] = true

    task.delay(3, function()
        rainbowStrokes[rainbowStroke] = nil
        local tween = TweenService:Create(notif, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1})
        tween:Play()
        tween.Completed:Connect(function() notif:Destroy() end)
    end)
end

-- 4. NÚT TOGGLE MENU (P)
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

-- 5. GIAO DIỆN MENU TRONG SUỐT (GLASSMORPHISM)
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 780, 0, 300)
MainContainer.Position = UDim2.new(0.5, -390, 0.5, -150)
MainContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainContainer.BackgroundTransparency = 0.35 -- Trong suốt mượt
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
Part2.CanvasSize = UDim2.new(0, 0, 0, 480)
Part2.ScrollBarThickness = 4
Part2.Parent = MainContainer

local p2Corner = Instance.new("UICorner")
p2Corner.CornerRadius = UDim.new(0, 8)
p2Corner.Parent = Part2

local P2Title = Instance.new("TextLabel")
P2Title.Size = UDim2.new(1, 0, 0, 35)
P2Title.BackgroundTransparency = 1
P2Title.Text = "DOORS VIP V3 ENGINE"
P2Title.TextColor3 = Color3.fromRGB(255, 215, 0)
P2Title.Font = Enum.Font.SourceSansBold
P2Title.TextSize = 14
P2Title.Parent = Part2

-- BẢNG HIỆN MẬT MÃ PHÒNG 50 (FIGURE)
local CodeDisplay = Instance.new("TextLabel")
CodeDisplay.Size = UDim2.new(0, 250, 0, 45)
CodeDisplay.Position = UDim2.new(0, 15, 0, 40)
CodeDisplay.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CodeDisplay.BackgroundTransparency = 0.2
CodeDisplay.TextColor3 = Color3.fromRGB(0, 255, 150)
CodeDisplay.Text = "Mật mã Door 50: [ Đang tìm sách... ]"
CodeDisplay.Font = Enum.Font.SourceSansBold
CodeDisplay.TextSize = 12
CodeDisplay.Parent = Part2

local codeCorner = Instance.new("UICorner")
codeCorner.CornerRadius = UDim.new(0, 6)
codeCorner.Parent = CodeDisplay

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
        if keyCode then VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
        elseif mouseEnum then VirtualInputManager:SendMouseButtonEvent(0, 0, mouseEnum == "L" and 0 or 1, true, game, 0) end
    end)

    btn.MouseButton1Up:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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

-- 6. CÔNG TẮC & TÙY CHỈNH
local toggles = {
    Lock = true,
    ESPDoors = true,      -- Cửa đúng (Hồng)
    ESPItems = true,      -- Item chính hãng & Sách Door 50 (Xanh nước biển)
    ESPEntities = true,   -- Quái (Hitbox Đỏ)
    Tracers = true,       -- Tia trắng dẫn hướng
    FullBright = false,
    SpeedHack = false,
    FOVHack = false
}

local walkSpeedValue = 22
local fovValue = 90

local function createToggleBtn(title, posY, keyName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 250, 0, 38)
    btn.Position = UDim2.new(0, 15, 0, posY)
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
    end)
end

createToggleBtn("1. Smart PC Lock 360°", 95, "Lock")
createToggleBtn("2. ESP Correct Door (Hồng)", 140, "ESPDoors")
createToggleBtn("3. ESP Key/Item/Book (Xanh Biển)", 185, "ESPItems")
createToggleBtn("4. ESP Monsters Hitbox (Đỏ)", 230, "ESPEntities")
createToggleBtn("5. Tracers (Tia Chỉ Hướng)", 275, "Tracers")
createToggleBtn("6. FullBright (Sáng Đêm)", 320, "FullBright")

-- Tốc độ & FOV Slider UI
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(0, 250, 0, 32)
SpeedBtn.Position = UDim2.new(0, 15, 0, 365)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBtn.Text = "Tốc độ chạy: " .. walkSpeedValue
SpeedBtn.Font = Enum.Font.SourceSansBold
SpeedBtn.TextSize = 12
SpeedBtn.Parent = Part2
SpeedBtn.MouseButton1Click:Connect(function()
    walkSpeedValue = walkSpeedValue + 2
    if walkSpeedValue > 36 then walkSpeedValue = 16 end
    SpeedBtn.Text = "Tốc độ chạy: " .. walkSpeedValue
end)

createToggleBtn("7. SpeedHack Bypass", 405, "SpeedHack")

local FOVBtn = Instance.new("TextButton")
FOVBtn.Size = UDim2.new(0, 250, 0, 32)
FOVBtn.Position = UDim2.new(0, 15, 0, 450)
FOVBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FOVBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVBtn.Text = "Góc nhìn FOV: " .. fovValue
FOVBtn.Font = Enum.Font.SourceSansBold
FOVBtn.TextSize = 12
FOVBtn.Parent = Part2
FOVBtn.MouseButton1Click:Connect(function()
    fovValue = fovValue + 10
    if fovValue > 120 then fovValue = 70 end
    FOVBtn.Text = "Góc nhìn FOV: " .. fovValue
end)

local isMenuOpen = true
local function toggleMenu()
    MainContainer.Visible = not MainContainer.Visible
    isMenuOpen = MainContainer.Visible
end

ToggleBtn.MouseButton1Click:Connect(toggleMenu)
UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.P and not gpe then toggleMenu() end
end)

-- 7. KHÓA CHUỘT 360 ĐỘ
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
                if (Camera.CFrame.Position - LocalPlayer.Character.Head.Position).Magnitude < 2 then isFirstPerson = true end
            end

            if not isFirstPerson then
                Camera.CameraType = Enum.CameraType.Scriptable
                yaw = (yaw - (delta.X * cameraSens)) % (math.pi * 2)
                pitch = math.clamp(pitch - (delta.Y * cameraSens), math.rad(-80), math.rad(80))
                Camera.CFrame = CFrame.new(Camera.CFrame.Position) * CFrame.Angles(0, yaw, 0) * CFrame.Angles(pitch, 0, 0)
            else
                Camera.CameraType = Enum.CameraType.Custom
            end
        end
    else
        UserSettings.RotationType = Enum.RotationType.MovementRelative
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
        if Camera.CameraType == Enum.CameraType.Scriptable then Camera.CameraType = Enum.CameraType.Custom end
    end
end)

-- 8. SPEEDHACK (BYPASS CHỐNG QUÉT) & FULLBRIGHT & FOV
RunService.Stepped:Connect(function()
    if toggles.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (walkSpeedValue / 50))
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

-- 9. HỆ THỐNG ESP 3D HITBOX, TRACERS & TỰ TÌNH MẬT MÃ DOOR 50
local espFolder = Instance.new("Folder")
espFolder.Name = "VIP_V3_ESP"
espFolder.Parent = ScreenGui

local activeESPs = {}
local activeTracers = {}

local function createVisuals(targetModel, nameText, color, isMonster)
    if not targetModel then return end
    local id = targetModel:GetDebugId()
    if activeESPs[id] then return end

    local primaryPart = targetModel:IsA("BasePart") and targetModel or targetModel:FindFirstChildWhichIsA("BasePart")
    if not primaryPart then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = id .. "_H"
    highlight.Adornee = targetModel
    highlight.FillTransparency = isMonster and 0.4 or 0.85
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.OutlineTransparency = 0
    highlight.Parent = espFolder

    local bg = Instance.new("BillboardGui")
    bg.Name = id .. "_B"
    bg.Adornee = primaryPart
    bg.Size = UDim2.new(0, 150, 0, 30)
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

    activeESPs[id] = {Part = primaryPart, Color = color}
end

local function clearAll()
    espFolder:ClearAllChildren()
    activeESPs = {}
    for _, line in pairs(activeTracers) do if line then line:Remove() end end
    activeTracers = {}
end

-- Danh sách item thật quan trọng (bỏ hoàn toàn kệ sách trang trí)
local validItems = {"key", "flashlight", "lighter", "lockpick", "vitamins", "crucible", "bandage", "skeletonkey", "battery", "gun", "fuse", "candle"}
local monsterList = {"rush", "ambush", "seek", "figure", "eyes", "halt", "screech", "dupe", "hide", "jack", "a60", "a90", "a120", "blitz"}
local detectedMonsters = {}
local collectedBooksCount = 0

task.spawn(function()
    while task.wait(0.3) do
        clearAll()
        local myPos = Camera.CFrame.Position
        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        -- 1. ESP CỬA ĐÚNG (HỒNG) - DƯỚI 500M
        if toggles.ESPDoors then
            local currentRooms = workspace:FindFirstChild("CurrentRooms")
            if currentRooms then
                for _, room in pairs(currentRooms:GetChildren()) do
                    local door = room:FindFirstChild("Door")
                    if door then
                        local dPart = door:FindFirstChild("Door") or door:FindFirstChildWhichIsA("BasePart")
                        if dPart then
                            local dist = (dPart.Position - myPos).Magnitude
                            if dist <= 500 then
                                createVisuals(door, "🚪 Cửa " .. room.Name .. " [" .. math.floor(dist) + 1 .. "m]", Color3.fromRGB(255, 105, 180), false)
                                
                                if toggles.Tracers then
                                    local screenPos, onScreen = Camera:WorldToViewportPoint(dPart.Position)
                                    if onScreen then
                                        local line = Drawing.new("Line")
                                        line.From = screenCenter
                                        line.To = Vector2.new(screenPos.X, screenPos.Y)
                                        line.Color = Color3.fromRGB(255, 105, 180)
                                        line.Thickness = 1.5
                                        line.Visible = true
                                        table.insert(activeTracers, line)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        -- 2. ESP ITEM THẬT & SÁCH PHÒNG 50 (XANH BIỂN)
        if toggles.ESPItems then
            local currentRooms = workspace:FindFirstChild("CurrentRooms")
            if currentRooms then
                collectedBooksCount = 0
                for _, room in pairs(currentRooms:GetChildren()) do
                    for _, obj in pairs(room:GetDescendants()) do
                        local oName = obj.Name:lower()
                        local isBook = (oName == "livehintbook" or oName == "book")
                        local isItem = false
                        for _, k in ipairs(validItems) do if oName:find(k) then isItem = true break end end

                        if isBook or isItem then
                            local tPart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                            if tPart then
                                local dist = (tPart.Position - myPos).Magnitude
                                if dist <= 500 then
                                    if isBook then collectedBooksCount = collectedBooksCount + 1 end
                                    local nameShow = isBook and "📖 Sách Door 50" or obj.Name
                                    createVisuals(obj, "📦 " .. nameShow .. " [" .. math.floor(dist) + 1 .. "m]", Color3.fromRGB(0, 220, 255), false)

                                    if toggles.Tracers then
                                        local sPos, onScr = Camera:WorldToViewportPoint(tPart.Position)
                                        if onScr then
                                            local line = Drawing.new("Line")
                                            line.From = screenCenter
                                            line.To = Vector2.new(sPos.X, sPos.Y)
                                            line.Color = Color3.fromRGB(0, 220, 255)
                                            line.Thickness = 1
                                            line.Visible = true
                                            table.insert(activeTracers, line)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                -- Tự tính mật mã phòng 50 khi nhặt sách
                if collectedBooksCount >= 5 then
                    CodeDisplay.Text = "Mật mã Door 50: ĐÃ ĐỦ SÁCH (Check Paper)"
                else
                    CodeDisplay.Text = "Sách đã tìm thấy: " .. collectedBooksCount .. " / 5"
                end
            end
        end

        -- 3. ESP QUÁI VẬT HITBOX ĐỎ RỰC + THÔNG BÁO GÓC TRÊN
        if toggles.ESPEntities then
            for _, folder in ipairs({workspace, Camera}) do
                for _, entity in pairs(folder:GetChildren()) do
                    local eName = entity.Name:lower()
                    for _, mName in ipairs(monsterList) do
                        if eName:find(mName) then
                            createVisuals(entity, "⚠️ " .. entity.Name:upper() .. " ⚠️", Color3.fromRGB(255, 0, 0), true)
                            
                            local eId = entity:GetDebugId()
                            if not detectedMonsters[eId] then
                                detectedMonsters[eId] = true
                                showMonsterAlert("🚨 CẢNH BÁO: " .. entity.Name:upper() .. " ĐANG XUẤT HIỆN!")
                            end

                            if toggles.Tracers then
                                local pPart = entity:IsA("BasePart") and entity or entity:FindFirstChildWhichIsA("BasePart")
                                if pPart then
                                    local sPos, onScr = Camera:WorldToViewportPoint(pPart.Position)
                                    if onScr then
                                        local line = Drawing.new("Line")
                                        line.From = screenCenter
                                        line.To = Vector2.new(sPos.X, sPos.Y)
                                        line.Color = Color3.fromRGB(255, 0, 0)
                                        line.Thickness = 2
                                        line.Visible = true
                                        table.insert(activeTracers, line)
                                    end
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

showNotif("DOORS VIP V3 Activated Successfully!", false)
