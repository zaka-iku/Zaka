-- ==============================================================================
-- DOORS OTG ULTIMATE VIP V14 - SMART MONSTER DODGE (EXCLUDE EYES/SEEK & FIGURE PROXIMITY)
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

-- 1. BẢO VỆ & DỌN DẸP GUI
local TargetParent = CoreGui
pcall(function()
    if TargetParent:FindFirstChild("OTGDoorsVIPV14") then
        TargetParent.OTGDoorsVIPV14:Destroy()
    end
end)
if not TargetParent:FindFirstChild("OTGDoorsVIPV14") then
    TargetParent = LocalPlayer:WaitForChild("PlayerGui")
    if TargetParent:FindFirstChild("OTGDoorsVIPV14") then
        TargetParent.OTGDoorsVIPV14:Destroy()
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OTGDoorsVIPV14"
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

-- 3. HỆ THỐNG THÔNG BÁO QUÁI VẬT
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

-- 5. GIAO DIỆN MENU CHÍNH
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 780, 0, 320)
MainContainer.Position = UDim2.new(0.5, -390, 0.5, -160)
MainContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainContainer.BackgroundTransparency = 0.25
MainContainer.Visible = true
MainContainer.ZIndex = 30
MainContainer.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = MainContainer

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 180, 255)
mainStroke.Thickness = 2
mainStroke.Parent = MainContainer

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 16
CloseBtn.ZIndex = 35
CloseBtn.Parent = MainContainer

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainContainer.Visible = false
end)

local Part1 = Instance.new("ScrollingFrame")
Part1.Size = UDim2.new(0, 460, 1, -20)
Part1.Position = UDim2.new(0, 10, 0, 10)
Part1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Part1.BackgroundTransparency = 0.5
Part1.CanvasSize = UDim2.new(0, 680, 0, 230)
Part1.ScrollBarThickness = 4
Part1.ZIndex = 31
Part1.Parent = MainContainer

local p1Corner = Instance.new("UICorner")
p1Corner.CornerRadius = UDim.new(0, 8)
p1Corner.Parent = Part1

local Part2 = Instance.new("ScrollingFrame")
Part2.Size = UDim2.new(0, 280, 1, -20)
Part2.Position = UDim2.new(0, 480, 0, 10)
Part2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Part2.BackgroundTransparency = 0.5
Part2.CanvasSize = UDim2.new(0, 0, 0, 850)
Part2.ScrollBarThickness = 5
Part2.ZIndex = 31
Part2.Parent = MainContainer

local p2Corner = Instance.new("UICorner")
p2Corner.CornerRadius = UDim.new(0, 8)
p2Corner.Parent = Part2

local P2Title = Instance.new("TextLabel")
P2Title.Size = UDim2.new(1, -40, 0, 30)
P2Title.Position = UDim2.new(0, 10, 0, 5)
P2Title.BackgroundTransparency = 1
P2Title.Text = "DOORS VIP V14 SMART DODGE"
P2Title.TextColor3 = Color3.fromRGB(255, 215, 0)
P2Title.Font = Enum.Font.SourceSansBold
P2Title.TextSize = 14
P2Title.ZIndex = 32
P2Title.Parent = Part2

local CodeDisplay = Instance.new("TextLabel")
CodeDisplay.Size = UDim2.new(0, 250, 0, 40)
CodeDisplay.Position = UDim2.new(0, 15, 0, 40)
CodeDisplay.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
CodeDisplay.TextColor3 = Color3.fromRGB(0, 255, 150)
CodeDisplay.Text = "Mật mã Door 50: [ Đang tìm sách... ]"
CodeDisplay.Font = Enum.Font.SourceSansBold
CodeDisplay.TextSize = 12
CodeDisplay.ZIndex = 32
CodeDisplay.Parent = Part2

local codeCorner = Instance.new("UICorner")
codeCorner.CornerRadius = UDim.new(0, 6)
codeCorner.Parent = CodeDisplay

local function createKey(text, posX, posY, sizeX, sizeY, keyCode, mouseEnum)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.Size = UDim2.new(0, sizeX, 0, sizeY)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.ZIndex = 32
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
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
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

-- 6. TOGGLES CHỨC NĂNG
local toggles = {
    Lock = true,
    AutoAimbot = true,
    SupremeGod = true,
    SmartDodge = true,   -- Né quái thông minh (Trừ Eyes, Seek & Chỉ né Figure khi tới sát mặt)
    MaxInventory = true,
    ESPPlayers = true,
    ESPDoors = true,
    ESPBooks = true,
    ESPItems = true,
    ESPEntities = true,
    Tracers = true,
    FullBright = false,
    SpeedHack = false,
    FOVHack = true
}

local walkSpeedValue = 22
local fovValue = 110

local function createToggleBtn(title, posY, keyName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 250, 0, 36)
    btn.Position = UDim2.new(0, 15, 0, posY)
    btn.BackgroundColor3 = toggles[keyName] and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = title .. ": " .. (toggles[keyName] and "ON" or "OFF")
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.ZIndex = 32
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

createToggleBtn("1. Smart PC Lock 360°", 90, "Lock")
createToggleBtn("2. Auto-Aimbot Cross-Map MAX", 132, "AutoAimbot")
createToggleBtn("3. Supreme GodMode (Bất Tử)", 174, "SupremeGod")
createToggleBtn("4. Smart Dodge (Loại Eyes/Seek)", 216, "SmartDodge")
createToggleBtn("5. Bypass Max Hold (99/99 Items)", 258, "MaxInventory")
createToggleBtn("6. ESP Players (Người Chơi)", 300, "ESPPlayers")
createToggleBtn("7. ESP Correct Door (Hồng)", 342, "ESPDoors")
createToggleBtn("8. ESP Sách Mật Mã Room 50 Only", 384, "ESPBooks")
createToggleBtn("9. ESP Items Deep Locker (Xanh)", 426, "ESPItems")
createToggleBtn("10. ESP Monsters All Modes (Đỏ)", 468, "ESPEntities")
createToggleBtn("11. Smooth Tracers (Tia Trắng)", 510, "Tracers")
createToggleBtn("12. FullBright (Sáng Đêm)", 552, "FullBright")

local SpeedTitle = Instance.new("TextLabel")
SpeedTitle.Size = UDim2.new(0, 250, 0, 20)
SpeedTitle.Position = UDim2.new(0, 15, 0, 595)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Text = "Tốc độ chạy: " .. walkSpeedValue
SpeedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedTitle.Font = Enum.Font.SourceSansBold
SpeedTitle.TextSize = 12
SpeedTitle.ZIndex = 32
SpeedTitle.Parent = Part2

local SpeedMinus = Instance.new("TextButton")
SpeedMinus.Size = UDim2.new(0, 120, 0, 28)
SpeedMinus.Position = UDim2.new(0, 15, 0, 618)
SpeedMinus.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedMinus.Text = "Giảm (-)"
SpeedMinus.Font = Enum.Font.SourceSansBold
SpeedMinus.TextSize = 12
SpeedMinus.ZIndex = 32
SpeedMinus.Parent = Part2
SpeedMinus.MouseButton1Click:Connect(function()
    walkSpeedValue = math.clamp(walkSpeedValue - 2, 16, 45)
    SpeedTitle.Text = "Tốc độ chạy: " .. walkSpeedValue
end)

local SpeedPlus = Instance.new("TextButton")
SpeedPlus.Size = UDim2.new(0, 120, 0, 28)
SpeedPlus.Position = UDim2.new(0, 145, 0, 618)
SpeedPlus.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedPlus.Text = "Tăng (+)"
SpeedPlus.Font = Enum.Font.SourceSansBold
SpeedPlus.TextSize = 12
SpeedPlus.ZIndex = 32
SpeedPlus.Parent = Part2
SpeedPlus.MouseButton1Click:Connect(function()
    walkSpeedValue = math.clamp(walkSpeedValue + 2, 16, 45)
    SpeedTitle.Text = "Tốc độ chạy: " .. walkSpeedValue
end)

createToggleBtn("13. SpeedHack Anti-TeleBack", 652, "SpeedHack")

local FOVTitle = Instance.new("TextLabel")
FOVTitle.Size = UDim2.new(0, 250, 0, 20)
FOVTitle.Position = UDim2.new(0, 15, 0, 695)
FOVTitle.BackgroundTransparency = 1
FOVTitle.Text = "Góc nhìn FOV: " .. fovValue
FOVTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVTitle.Font = Enum.Font.SourceSansBold
FOVTitle.TextSize = 12
FOVTitle.ZIndex = 32
FOVTitle.Parent = Part2

local FOVMinus = Instance.new("TextButton")
FOVMinus.Size = UDim2.new(0, 120, 0, 28)
FOVMinus.Position = UDim2.new(0, 15, 0, 718)
FOVMinus.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FOVMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVMinus.Text = "FOV Giảm (-)"
FOVMinus.Font = Enum.Font.SourceSansBold
FOVMinus.TextSize = 12
FOVMinus.ZIndex = 32
FOVMinus.Parent = Part2
FOVMinus.MouseButton1Click:Connect(function()
    fovValue = math.clamp(fovValue - 5, 70, 140)
    FOVTitle.Text = "Góc nhìn FOV: " .. fovValue
end)

local FOVPlus = Instance.new("TextButton")
FOVPlus.Size = UDim2.new(0, 120, 0, 28)
FOVPlus.Position = UDim2.new(0, 145, 0, 718)
FOVPlus.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FOVPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVPlus.Text = "FOV Tăng (+)"
FOVPlus.Font = Enum.Font.SourceSansBold
FOVPlus.TextSize = 12
FOVPlus.ZIndex = 32
FOVPlus.Parent = Part2
FOVPlus.MouseButton1Click:Connect(function()
    fovValue = math.clamp(fovValue + 5, 70, 140)
    FOVTitle.Text = "Góc nhìn FOV: " .. fovValue
end)

createToggleBtn("14. Mở rộng Góc nhìn FOV MAX", 752, "FOVHack")

local function toggleMenu()
    MainContainer.Visible = not MainContainer.Visible
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
    if isRobloxMenuOpen or MainContainer.Visible then
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

-- QUÁI CHẠY LƯỚT CẦN NÉ NGAY
local fastDodgeMonsters = {
    "rush", "ambush", "a60", "a90", "a120", "blitz", "dread", "depth", "silence", "halt", "screech"
}

-- 8. CORE ENGINE: SMART DODGE (KHÔNG DÍNH EYES / SEEK - CHI NÉ FIGURE KHI ĐẾN GẦN)
RunService.Stepped:Connect(function()
    if toggles.SpeedHack and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0 then hum.WalkSpeed = walkSpeedValue end
    elseif LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= 16 then hum.WalkSpeed = 16 end
    end

    if toggles.FullBright then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
    end

    if toggles.FOVHack then Camera.FieldOfView = fovValue end

    -- SUPREME GODMODE
    if toggles.SupremeGod and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = hum.MaxHealth
            pcall(function()
                for _, v in pairs(LocalPlayer.Character:GetChildren()) do
                    if v:IsA("Folder") or v:IsA("StringValue") then
                        if v.Name:lower():find("blind") or v.Name:lower():find("damage") or v.Name:lower():find("burn") then
                            v:Destroy()
                        end
                    end
                end
            end)
        end
    end

    -- BYPASS PROXIMITYPROMPT HOLD LIMIT (99/99 ITEMS)
    if toggles.MaxInventory then
        pcall(function()
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    prompt.HoldDuration = 0
                    prompt.RequiresLineOfSight = false
                    prompt.MaxActivationDistance = 15
                    prompt.Enabled = true
                end
            end
            for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
                if v:IsA("Tool") then v.MaxStack = 99 end
            end
        end)
    end

    -- SMART MONSTER DODGE ENGINE
    if toggles.SmartDodge and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local shouldDodge = false

        for _, folder in ipairs({workspace, Camera}) do
            for _, entity in pairs(folder:GetChildren()) do
                local eName = entity.Name:lower()

                -- HOÀN TOÀN BỎ QUA EYES VÀ SEEK (KHÔNG NÉ DƯỚI ĐẤT)
                if not eName:find("eyes") and not eName:find("seek") and not eName:find("lookman") then
                    local pPart = entity:IsA("BasePart") and entity or entity:FindFirstChildWhichIsA("BasePart")
                    if pPart then
                        local dist = (pPart.Position - hrp.Position).Magnitude

                        -- RIÊNG FIGURE: Chỉ né khi cách mặt dưới 12 mét (Sắp tóm)
                        if eName:find("figure") then
                            if dist <= 12 then
                                shouldDodge = true
                                break
                            end
                        else
                            -- Các quái chạy lướt khác (Rush, Ambush, A-60...): Né khi trong tầm 50m
                            for _, mName in ipairs(fastDodgeMonsters) do
                                if eName:find(mName) and dist <= 50 then
                                    shouldDodge = true
                                    break
                                end
                            end
                        end
                    end
                end
            end
            if shouldDodge then break end
        end

        if shouldDodge then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, -350, 0) -- Giấu Hitbox xuống dưới Map
        end
    end
end)

-- 9. AUTO AIMBOT BULLET HOMING CROSS-MAP
local allMonsterKeywords = {
    "rush", "ambush", "seek", "figure", "eyes", "halt", "screech", "dupe", "hide", "jack", 
    "a60", "a90", "a120", "blitz", "dread", "depth", "silence", "lookman", "entity", "monster"
}

UserInputService.InputBegan:Connect(function(input, gpe)
    if not toggles.AutoAimbot then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        task.spawn(function()
            local targetMonster = nil
            local shortestDist = math.huge
            for _, folder in ipairs({workspace, Camera}) do
                for _, entity in pairs(folder:GetChildren()) do
                    local eName = entity.Name:lower()
                    for _, mName in ipairs(allMonsterKeywords) do
                        if eName:find(mName) then
                            local part = entity:IsA("BasePart") and entity or entity:FindFirstChildWhichIsA("BasePart")
                            if part then
                                local dist = (part.Position - Camera.CFrame.Position).Magnitude
                                if dist < shortestDist then
                                    shortestDist = dist
                                    targetMonster = part
                                end
                            end
                            break
                        end
                    end
                end
            end
            
            if targetMonster then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name:lower():find("bullet") or obj.Name:lower():find("projectile") or obj.Name:lower():find("shot") or obj.Name:lower():find("ammo")) then
                        obj.CFrame = CFrame.new(targetMonster.Position)
                        obj.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end)
    end
end)

-- 10. HỆ THỐNG ESP VIP V14
local espFolder = Instance.new("Folder")
espFolder.Name = "VIP_V14_ESP"
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

local function isShelfOrJunk(name)
    local n = name:lower()
    if n:find("bookshelf") or n:find("shelf") or n:find("rack") or n:find("furniture") or n:find("stand") or n:find("board") or n:find("paper") or n:find("painting") then
        return true
    end
    return false
end

local trueUsableItems = {
    "fuse", "battery", "key", "flashlight", "lighter", "lockpick", 
    "vitamins", "crucifix", "skeletonkey", "gun", "shotgun", "tablet", "shears", "medkit", "herb", "smoothie"
}

local detectedMonsters = {}
local collectedBooksCount = 0

task.spawn(function()
    while task.wait(0.3) do
        clearAll()
        local myPos = Camera.CFrame.Position
        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        -- 1. ESP PLAYERS
        if toggles.ESPPlayers then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    local dist = math.floor((hrp.Position - myPos).Magnitude)
                    if dist <= 800 then
                        createVisuals(p.Character, "👤 " .. p.Name .. " [" .. dist .. "m]", Color3.fromRGB(0, 255, 100), false)
                    end
                end
            end
        end

        -- 2. ESP CỬA ĐÚNG
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

        -- 3. ESP SÁCH MẬT MÃ ROOM 50 ONLY (VÀNG)
        if toggles.ESPBooks then
            local currentRooms = workspace:FindFirstChild("CurrentRooms")
            if currentRooms then
                collectedBooksCount = 0
                for _, room in pairs(currentRooms:GetChildren()) do
                    for _, obj in pairs(room:GetDescendants()) do
                        if not isShelfOrJunk(obj.Name) then
                            local oName = obj.Name:lower()
                            if oName == "livehintbook" then
                                local tPart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                                if tPart then
                                    local dist = (tPart.Position - myPos).Magnitude
                                    if dist <= 500 then
                                        collectedBooksCount = collectedBooksCount + 1
                                        createVisuals(obj, "📖 Sách Mật Mã [" .. math.floor(dist) + 1 .. "m]", Color3.fromRGB(255, 215, 0), false)
                                        if toggles.Tracers then
                                            local sPos, onScr = Camera:WorldToViewportPoint(tPart.Position)
                                            if onScr then
                                                local line = Drawing.new("Line")
                                                line.From = screenCenter
                                                line.To = Vector2.new(sPos.X, sPos.Y)
                                                line.Color = Color3.fromRGB(255, 215, 0)
                                                line.Thickness = 1.2
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
                if collectedBooksCount >= 5 then CodeDisplay.Text = "Mật mã Door 50: ĐÃ ĐỦ SÁCH!"
                else CodeDisplay.Text = "Sách đã tìm: " .. collectedBooksCount .. " / 5" end
            end
        end

        -- 4. ESP ITEMS CHUẨN XUYÊN TỦ 100% (XANH BIỂN)
        if toggles.ESPItems then
            local currentRooms = workspace:FindFirstChild("CurrentRooms")
            if currentRooms then
                for _, room in pairs(currentRooms:GetChildren()) do
                    for _, obj in pairs(room:GetDescendants()) do
                        if not isShelfOrJunk(obj.Name) then
                            local oName = obj.Name:lower()
                            local isValid = false
                            for _, k in ipairs(trueUsableItems) do
                                if oName:find(k) then isValid = true break end
                            end

                            if isValid then
                                local tPart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                                if tPart then
                                    local dist = (tPart.Position - myPos).Magnitude
                                    if dist <= 500 then
                                        local isInLocker = false
                                        if obj:FindFirstAncestor("Wardrobe") or obj:FindFirstAncestor("Drawer") or obj:FindFirstAncestor("Chest") or obj:FindFirstAncestor("Locker") or obj:FindFirstAncestor("Cabinet") or obj:FindFirstAncestor("Desk") then
                                            isInLocker = true
                                        end
                                        local prefixTag = isInLocker and "[Trong Tủ] " or "[Item] "
                                        createVisuals(obj, prefixTag .. obj.Name .. " [" .. math.floor(dist) + 1 .. "m]", Color3.fromRGB(0, 220, 255), false)

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
                end
            end
        end

        -- 5. ESP QUÁI VẬT TẤT CẢ MODES & TIA TRẮNG
        if toggles.ESPEntities then
            for _, folder in ipairs({workspace, Camera}) do
                for _, entity in pairs(folder:GetChildren()) do
                    local eName = entity.Name:lower()
                    for _, mName in ipairs(allMonsterKeywords) do
                        if eName:find(mName) then
                            createVisuals(entity, "⚠️ " .. entity.Name:upper() .. " ⚠️", Color3.fromRGB(255, 0, 0), true)
                            local eId = entity:GetDebugId()
                            if not detectedMonsters[eId] then
                                detectedMonsters[eId] = true
                                showMonsterAlert("🚨 CẢNH BÁO: " .. entity.Name:upper() .. " ĐANG TẤN CÔNG!")
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

showMonsterAlert("DOORS VIP V14 Smart Dodge Loaded!")
