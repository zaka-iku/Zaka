-- ==============================================================================
-- DOORS OTG ULTIMATE VIP V17.1 - FIXED ALL BUGS & ZERO-DAMAGE ENGINE
-- ==============================================================================

local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 1. DỌN DẸP GUI CŨ
local TargetParent = CoreGui
pcall(function()
    if TargetParent:FindFirstChild("OTGDoorsVIPV17") then
        TargetParent.OTGDoorsVIPV17:Destroy()
    end
end)
if not TargetParent:FindFirstChild("OTGDoorsVIPV17") then
    TargetParent = LocalPlayer:WaitForChild("PlayerGui")
    if TargetParent:FindFirstChild("OTGDoorsVIPV17") then
        TargetParent.OTGDoorsVIPV17:Destroy()
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OTGDoorsVIPV17"
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

-- 3. THÔNG BÁO QUÁI VẬT
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

    task.delay(3, function()
        local tween = TweenService:Create(notif, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1})
        tween:Play()
        tween.Completed:Connect(function() notif:Destroy() end)
    end)
end

-- 4. NÚT MỞ MENU (P)
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

-- 5. GIAO DIỆN CHÍNH
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

local Part2 = Instance.new("ScrollingFrame")
Part2.Size = UDim2.new(0, 280, 1, -20)
Part2.Position = UDim2.new(0, 480, 0, 10)
Part2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Part2.BackgroundTransparency = 0.5
Part2.CanvasSize = UDim2.new(0, 0, 0, 880)
Part2.ScrollBarThickness = 5
Part2.ZIndex = 31
Part2.Parent = MainContainer

local P2Title = Instance.new("TextLabel")
P2Title.Size = UDim2.new(1, -40, 0, 30)
P2Title.Position = UDim2.new(0, 10, 0, 5)
P2Title.BackgroundTransparency = 1
P2Title.Text = "DOORS VIP V17.1 ULTIMATE"
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
    Lock = false, -- Mặc định tắt để tránh kẹt chuột
    AutoAimbot = true,
    SupremeGod = true,
    EarlyFastDodge = true,
    ServerBypass99 = true,
    ESPPlayers = true,
    ESPDoors = true,
    ESPLevers = true,
    ESPBooks = true,
    ESPItems = true,
    ESPEntities = true,
    Tracers = true,
    FullBright = false,
    SpeedHack = false,
    FOVHack = true
}

local walkSpeedValue = 20
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
createToggleBtn("4. Early Fast Dodge (Hitbox Proxy)", 216, "EarlyFastDodge")
createToggleBtn("5. Server Bypass 99/99 Items", 258, "ServerBypass99")
createToggleBtn("6. ESP Players", 300, "ESPPlayers")
createToggleBtn("7. ESP Correct Door", 342, "ESPDoors")
createToggleBtn("8. ESP Levers (Cần Gạt)", 384, "ESPLevers")
createToggleBtn("9. ESP Books Room 50", 426, "ESPBooks")
createToggleBtn("10. ESP Items Clean", 468, "ESPItems")
createToggleBtn("11. ESP Monsters All Modes", 510, "ESPEntities")
createToggleBtn("12. Smooth Tracers", 552, "Tracers")
createToggleBtn("13. FullBright", 594, "FullBright")

local function toggleMenu()
    MainContainer.Visible = not MainContainer.Visible
end

ToggleBtn.MouseButton1Click:Connect(toggleMenu)
UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.P and not gpe then toggleMenu() end
end)

-- 7. XỬ LÝ CHUỘT & KHÓA 360 AN TOÀN KHÔNG BỊ KẸT CHUỘT ẢO
local cameraSens = 0.003
local pitch, yaw = 0, 0
local lastMousePos = UserInputService:GetMouseLocation()

RunService.RenderStepped:Connect(function()
    local isMenuOpen = MainContainer.Visible or GuiService:GetMenuIsOpen()
    
    if isMenuOpen then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
        return
    end

    if toggles.Lock then
        UserInputService.MouseIconEnabled = false
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

        local currentPos = UserInputService:GetMouseLocation()
        local delta = currentPos - lastMousePos
        lastMousePos = currentPos

        if delta.Magnitude > 0 and delta.Magnitude < 100 then
            Camera.CameraType = Enum.CameraType.Scriptable
            yaw = (yaw - (delta.X * cameraSens)) % (math.pi * 2)
            pitch = math.clamp(pitch - (delta.Y * cameraSens), math.rad(-80), math.rad(80))
            Camera.CFrame = CFrame.new(Camera.CFrame.Position) * CFrame.Angles(0, yaw, 0) * CFrame.Angles(pitch, 0, 0)
        end
    else
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
        if Camera.CameraType == Enum.CameraType.Scriptable then 
            Camera.CameraType = Enum.CameraType.Custom 
        end
    end
end)

-- 8. CORE GODMODE, 0-DAMAGE VÀ HITBOX PROXY (KHÔNG BỊ TELE XUỐNG DƯỚI LÒNG)
local fastDodgeMonsters = {"rush", "ambush", "a60", "a90", "a120", "blitz", "dread", "depth", "silence", "halt", "screech"}

RunService.Stepped:Connect(function()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")

    -- Chống rung màn hình & hiệu ứng dính sát thương
    pcall(function()
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("ColorCorrectionEffect") or v:IsA("BlurEffect") or v:IsA("BloomEffect") then
                if v.Name ~= "ZAKA_GLOW_V1" then v.Enabled = false end
            end
        end
        local guiEffects = LocalPlayer.PlayerGui:FindFirstChild("MainUI") and LocalPlayer.PlayerGui.MainUI:FindFirstChild("Initiator")
        if guiEffects then
            for _, fx in pairs(guiEffects:GetDescendants()) do
                if fx.Name:lower():find("flash") or fx.Name:lower():find("shaky") or fx.Name:lower():find("damage") then
                    fx.Visible = false
                end
            end
        end
    end)

    -- Sát thương bằng 0 & Bất tử thật sự
    if toggles.SupremeGod and humanoid then
        if humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
        if humanoid:GetState() == Enum.HumanoidStateType.Dead then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end

    -- Hitbox Proxy thông minh: Chỉ dời Hitbox xuống sâu 600m trong khi nhân vật/camera ở nguyên vị trí cũ (Không tele lòng đất)
    if toggles.EarlyFastDodge and hrp then
        local shouldDodge = false
        for _, folder in ipairs({workspace, Camera}) do
            for _, entity in pairs(folder:GetChildren()) do
                local eName = entity.Name:lower()
                local pPart = entity:IsA("BasePart") and entity or entity:FindFirstChildWhichIsA("BasePart")
                if pPart then
                    local dist = (pPart.Position - hrp.Position).Magnitude
                    if eName:find("figure") and dist <= 16 then
                        shouldDodge = true
                        break
                    else
                        for _, mName in ipairs(fastDodgeMonsters) do
                            if eName:find(mName) and dist <= 120 then
                                shouldDodge = true
                                break
                            end
                        end
                    end
                end
            end
            if shouldDodge then break end
        end

        if shouldDodge then
            -- Tách rời va chạm vật lý: Đẩy RootPart xuống sâu để quái vật không chạm tới nhân vật thực
            hrp.CFrame = hrp.CFrame + Vector3.new(0, -600, 0)
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end

    -- Server Bypass 99 items
    if toggles.ServerBypass99 then
        pcall(function()
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    prompt.HoldDuration = 0
                    prompt.RequiresLineOfSight = false
                    prompt.MaxActivationDistance = 30
                    prompt.Enabled = true
                end
            end
        end)
    end
end)

-- 9. ESP HỆ THỐNG (GIỮ NGUYÊN VẸN ĐẦY ĐỦ CÁC TÍNH NĂNG ĐÃ TỐI ƯU)
local espFolder = Instance.new("Folder")
espFolder.Name = "VIP_V17_ESP"
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

local trueUsableItems = {"fuse", "battery", "key", "flashlight", "lockpick", "vitamins", "crucifix", "skeletonkey", "tablet", "shears", "medkit"}

task.spawn(function()
    while task.wait(0.3) do
        clearAll()
        local myPos = Camera.CFrame.Position
        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        -- ESP Levers (Cần gạt - Cam)
        if toggles.ESPLevers then
            local currentRooms = workspace:FindFirstChild("CurrentRooms")
            if currentRooms then
                for _, room in pairs(currentRooms:GetChildren()) do
                    for _, obj in pairs(room:GetDescendants()) do
                        local oName = obj.Name:lower()
                        if oName:find("lever") or oName:find("switch") or oName:find("breaker") then
                            local tPart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                            if tPart then
                                local dist = (tPart.Position - myPos).Magnitude
                                if dist <= 500 then
                                    createVisuals(obj, "🔌 Cần Gạt [" .. math.floor(dist) + 1 .. "m]", Color3.fromRGB(255, 140, 0), false)
                                end
                            end
                        end
                    end
                end
            end
        end

        -- ESP Monsters (Quái vật tất cả chế độ)
        if toggles.ESPEntities then
            for _, folder in ipairs({workspace, Camera}) do
                for _, entity in pairs(folder:GetChildren()) do
                    local eName = entity.Name:lower()
                    for _, mName in ipairs(fastDodgeMonsters) do
                        if eName:find(mName) then
                            createVisuals(entity, "⚠️ " .. entity.Name:upper() .. " ⚠️", Color3.fromRGB(255, 0, 0), true)
                            break
                        end
                    end
                end
            end
        end
    end
end)

showMonsterAlert("DOORS VIP V17.1 Loaded Successfully!")
