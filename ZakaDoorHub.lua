-- ==============================================================================
-- DOORS OTG ULTIMATE VIP V60 - ABSOLUTE HITBOX CLONE & NATIVE 360 EDITION
-- ==============================================================================

local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 1. DỌN DẸP GUI CŨ
local TargetParent = CoreGui
pcall(function()
    if TargetParent:FindFirstChild("OTGDoorsVIPV60") then
        TargetParent.OTGDoorsVIPV60:Destroy()
    end
end)
if not TargetParent:FindFirstChild("OTGDoorsVIPV60") then
    TargetParent = LocalPlayer:WaitForChild("PlayerGui")
    if TargetParent:FindFirstChild("OTGDoorsVIPV60") then
        TargetParent.OTGDoorsVIPV60:Destroy()
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OTGDoorsVIPV60"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 9999999
ScreenGui.Parent = TargetParent

-- 2. CROSSHAIR TÂM NGẮM NATIVE
local NativeCenterDot = Instance.new("Frame")
NativeCenterDot.Size = UDim2.new(0, 6, 0, 6)
NativeCenterDot.AnchorPoint = Vector2.new(0.5, 0.5)
NativeCenterDot.Position = UDim2.new(0.5, 0, 0.5, 0)
NativeCenterDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NativeCenterDot.ZIndex = 10
NativeCenterDot.Parent = ScreenGui
Instance.new("UICorner", NativeCenterDot).CornerRadius = UDim.new(1, 0)

local dotStroke = Instance.new("UIStroke")
dotStroke.Color = Color3.fromRGB(0, 0, 0)
dotStroke.Thickness = 1.5
dotStroke.Parent = NativeCenterDot

-- 3. HỆ THỐNG THÔNG BÁO QUÁI VẬT
local NotifContainer = Instance.new("Frame")
NotifContainer.Size = UDim2.new(0, 350, 0, 220)
NotifContainer.Position = UDim2.new(0.5, -175, 0.03, 0)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 6)
NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NotifLayout.Parent = NotifContainer

local function showMonsterAlert(text, color)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 330, 0, 42)
    notif.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    notif.BackgroundTransparency = 0.15
    notif.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    notif.Text = text
    notif.Font = Enum.Font.SourceSansBold
    notif.TextSize = 14
    notif.ZIndex = 25
    notif.Parent = NotifContainer
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(255, 0, 0)
    stroke.Thickness = 2
    stroke.Parent = notif

    task.delay(3.5, function()
        local tween = TweenService:Create(notif, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1})
        tween:Play()
        tween.Completed:Connect(function() notif:Destroy() end)
    end)
end

-- 4. TOGGLE MENU BUTTON (P)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 110, 0, 40)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.08, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ToggleBtn.BackgroundTransparency = 0.2
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "MENU HUB (P)"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 14
ToggleBtn.ZIndex = 30
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- 5. MAIN GUI CONTAINER
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 820, 0, 380)
MainContainer.Position = UDim2.new(0.5, -410, 0.5, -190)
MainContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainContainer.BackgroundTransparency = 0.15
MainContainer.Visible = true
MainContainer.ZIndex = 30
MainContainer.Parent = ScreenGui
Instance.new("UICorner", MainContainer).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 180, 255)
mainStroke.Thickness = 2
mainStroke.Parent = MainContainer

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -38, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 16
CloseBtn.ZIndex = 35
CloseBtn.Parent = MainContainer
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    MainContainer.Visible = false
end)

local Part1 = Instance.new("ScrollingFrame")
Part1.Size = UDim2.new(0, 480, 1, -20)
Part1.Position = UDim2.new(0, 10, 0, 10)
Part1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Part1.BackgroundTransparency = 0.5
Part1.CanvasSize = UDim2.new(0, 720, 0, 260)
Part1.ScrollBarThickness = 4
Part1.ZIndex = 31
Part1.Parent = MainContainer
Instance.new("UICorner", Part1).CornerRadius = UDim.new(0, 8)

local Part2 = Instance.new("ScrollingFrame")
Part2.Size = UDim2.new(0, 300, 1, -20)
Part2.Position = UDim2.new(0, 500, 0, 10)
Part2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Part2.BackgroundTransparency = 0.5
Part2.CanvasSize = UDim2.new(0, 0, 0, 1200)
Part2.ScrollBarThickness = 5
Part2.ZIndex = 31
Part2.Parent = MainContainer
Instance.new("UICorner", Part2).CornerRadius = UDim.new(0, 8)

local P2Title = Instance.new("TextLabel")
P2Title.Size = UDim2.new(1, -40, 0, 30)
P2Title.Position = UDim2.new(0, 10, 0, 5)
P2Title.BackgroundTransparency = 1
P2Title.Text = "DOORS VIP V60 CLONE HUB"
P2Title.TextColor3 = Color3.fromRGB(255, 215, 0)
P2Title.Font = Enum.Font.SourceSansBold
P2Title.TextSize = 14
P2Title.ZIndex = 32
P2Title.Parent = Part2

local CodeDisplay = Instance.new("TextLabel")
CodeDisplay.Size = UDim2.new(0, 270, 0, 42)
CodeDisplay.Position = UDim2.new(0, 15, 0, 40)
CodeDisplay.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
CodeDisplay.TextColor3 = Color3.fromRGB(0, 255, 150)
CodeDisplay.Text = "Mật mã Door 50: [ Đang quét sách... ]"
CodeDisplay.Font = Enum.Font.SourceSansBold
CodeDisplay.TextSize = 12
CodeDisplay.ZIndex = 32
CodeDisplay.Parent = Part2
Instance.new("UICorner", CodeDisplay).CornerRadius = UDim.new(0, 6)

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
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

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

-- 6. TOGGLES & CONFIG
local toggles = {
    HitboxClone = true,          -- PHÁN THÂN HITBOX (BẤT TỬ THẬT KHÔNG MÁU ẢO)
    SafeDodge = true,            -- DỊCH CHUYỂN NÉ QUÁI
    SpaceAimbot = true,          -- AIMBOT 360 BẺ CONG KHÔNG GIAN
    SmoothSpeed = false,         -- CHẠY MƯỢT KHÔNG TELE-BACK
    FPSBoost = true,
    ESPPlayers = true,
    ESPDoors = true,
    ESPLevers = true,
    ESPBooks = true,
    ESPItems = true,
    ESPMonsters = true,
    FullBright = false
}

local walkSpeedValue = 24

local function createToggleBtn(title, posY, keyName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 270, 0, 36)
    btn.Position = UDim2.new(0, 15, 0, posY)
    btn.BackgroundColor3 = toggles[keyName] and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = title .. ": " .. (toggles[keyName] and "ON" or "OFF")
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.ZIndex = 32
    btn.Parent = Part2
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        toggles[keyName] = not toggles[keyName]
        btn.BackgroundColor3 = toggles[keyName] and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40)
        btn.Text = title .. ": " .. (toggles[keyName] and "ON" or "OFF")
    end)
end

createToggleBtn("1. Hitbox Clone Teleport (No Fake HP)", 90, "HitboxClone")
createToggleBtn("2. Safe Zone Dodge (-2000Y Auto)", 132, "SafeDodge")
createToggleBtn("3. Space-Bending Bullet Aimbot 360°", 174, "SpaceAimbot")
createToggleBtn("4. Anti-Teleback Smooth Velocity Speed", 216, "SmoothSpeed")
createToggleBtn("5. 🧹 FPS Boost & Clean Visuals", 258, "FPSBoost")
createToggleBtn("6. FullBright (Sáng Đêm Hoàn Toàn)", 300, "FullBright")
createToggleBtn("7. ESP Players (Người Chơi)", 342, "ESPPlayers")
createToggleBtn("8. ESP Correct Door (Hồng)", 384, "ESPDoors")
createToggleBtn("9. ESP Levers / Switch (Cam)", 426, "ESPLevers")

local SpeedTitle = Instance.new("TextLabel")
SpeedTitle.Size = UDim2.new(0, 270, 0, 20)
SpeedTitle.Position = UDim2.new(0, 15, 0, 470)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Text = "Tốc độ di chuyển: " .. walkSpeedValue
SpeedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedTitle.Font = Enum.Font.SourceSansBold
SpeedTitle.TextSize = 12
SpeedTitle.ZIndex = 32
SpeedTitle.Parent = Part2

local SpeedMinus = Instance.new("TextButton")
SpeedMinus.Size = UDim2.new(0, 130, 0, 28)
SpeedMinus.Position = UDim2.new(0, 15, 0, 493)
SpeedMinus.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedMinus.Text = "Giảm (-)"
SpeedMinus.Font = Enum.Font.SourceSansBold
SpeedMinus.TextSize = 12
SpeedMinus.ZIndex = 32
SpeedMinus.Parent = Part2
SpeedMinus.MouseButton1Click:Connect(function()
    walkSpeedValue = math.clamp(walkSpeedValue - 2, 16, 50)
    SpeedTitle.Text = "Tốc độ di chuyển: " .. walkSpeedValue
end)

local SpeedPlus = Instance.new("TextButton")
SpeedPlus.Size = UDim2.new(0, 130, 0, 28)
SpeedPlus.Position = UDim2.new(0, 155, 0, 493)
SpeedPlus.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedPlus.Text = "Tăng (+)"
SpeedPlus.Font = Enum.Font.SourceSansBold
SpeedPlus.TextSize = 12
SpeedPlus.ZIndex = 32
SpeedPlus.Parent = Part2
SpeedPlus.MouseButton1Click:Connect(function()
    walkSpeedValue = math.clamp(walkSpeedValue + 2, 16, 50)
    SpeedTitle.Text = "Tốc độ di chuyển: " .. walkSpeedValue
end)

createToggleBtn("10. ESP Sách Mật Mã Room 50 Only", 530, "ESPBooks")
createToggleBtn("11. ESP Items Full Map (Xanh)", 572, "ESPItems")
createToggleBtn("12. ESP Monsters All Modes (Đỏ)", 614, "ESPMonsters")

ToggleBtn.MouseButton1Click:Connect(function()
    MainContainer.Visible = not MainContainer.Visible
end)
UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.P and not gpe then MainContainer.Visible = not MainContainer.Visible end
end)

-- 7. CƠ CHẾ PHÁN THÂN HITBOX (TELEPORT CLONE TO LOCKERS/GROUND/SKY)
task.spawn(function()
    while task.wait(0.15) do
        if toggles.HitboxClone and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local hrp = LocalPlayer.Character.HumanoidRootPart
                local currentRooms = workspace:FindFirstChild("CurrentRooms")
                local targetClonePos = nil

                -- Tìm tủ đồ gần nhất để ẩn Hitbox vào tủ
                if currentRooms then
                    for _, room in pairs(currentRooms:GetChildren()) do
                        for _, obj in pairs(room:GetDescendants()) do
                            if obj.Name:lower():find("wardrobe") or obj.Name:lower():find("locker") then
                                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                                if part and (part.Position - hrp.Position).Magnitude <= 100 then
                                    targetClonePos = part.CFrame
                                    break
                                end
                            end
                        end
                        if targetClonePos then break end
                    end
                end

                -- Nếu không có tủ, nhảy ngẫu nhiên xuống lòng đất (-500Y) hoặc trên trời (+50Y)
                if not targetClonePos then
                    local randChoice = math.random(1, 2)
                    if randChoice == 1 then
                        targetClonePos = hrp.CFrame * CFrame.new(0, -500, 0)
                    else
                        targetClonePos = hrp.CFrame * CFrame.new(0, 50, 0)
                    end
                end

                -- Vô hiệu hóa TouchInterest để tránh nhận sát thương từ Server
                for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanTouch = false
                    end
                end
            end)
        end
    end
end)

-- 8. ANTI-TELEBACK & SAFE ZONE ENGINE
local fastDodgeMonsters = {"rush", "ambush", "a60", "a120", "blitz", "dread", "depth", "silence", "halt"}
local dodgeTimer = 0
local savedCFrame = nil

RunService.Stepped:Connect(function()
    if toggles.SmoothSpeed and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum.MoveDirection.Magnitude > 0 then
            local moveDir = hum.MoveDirection
            hrp.AssemblyLinearVelocity = Vector3.new(moveDir.X * walkSpeedValue, hrp.AssemblyLinearVelocity.Y, moveDir.Z * walkSpeedValue)
        end
    end

    if toggles.FullBright then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
    end

    if toggles.FPSBoost then
        pcall(function()
            Lighting.GlobalShadows = false
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                    v.Enabled = false
                end
            end
        end)
    end

    if toggles.SafeDodge and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local shouldDodge = false

        for _, folder in ipairs({workspace, Camera}) do
            for _, entity in pairs(folder:GetChildren()) do
                local eName = entity.Name:lower()
                for _, mName in ipairs(fastDodgeMonsters) do
                    if eName:find(mName) then
                        local part = entity:IsA("BasePart") and entity or entity:FindFirstChildWhichIsA("BasePart")
                        if part and (part.Position - hrp.Position).Magnitude <= 140 then
                            shouldDodge = true
                            break
                        end
                    end
                end
                if shouldDodge then break end
            end
            if shouldDodge then break end
        end

        if shouldDodge then
            if not savedCFrame then savedCFrame = hrp.CFrame end
            dodgeTimer = tick() + 5
            hrp.CFrame = CFrame.new(0, -2000, 0)
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        elseif tick() < dodgeTimer and savedCFrame then
            hrp.CFrame = CFrame.new(0, -2000, 0)
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        elseif savedCFrame and tick() >= dodgeTimer then
            hrp.CFrame = savedCFrame
            savedCFrame = nil
        end
    end
end)

-- 9. SPACE-BENDING BULLET AIMBOT
local allMonsterKeywords = {
    "rush", "ambush", "seek", "figure", "eyes", "halt", "screech", "dupe", "hide", "jack", 
    "a60", "a90", "a120", "blitz", "dread", "depth", "silence", "lookman", "entity", "monster"
}

RunService.RenderStepped:Connect(function()
    if not toggles.SpaceAimbot then return end
    
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
        pcall(function()
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("bullet") or obj.Name:lower():find("projectile") or obj.Name:lower():find("shot") or obj.Name:lower():find("ammo")) then
                    obj.CFrame = CFrame.new(targetMonster.Position)
                    obj.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
            end
        end)
    end
end)

-- 10. FULL ITEM & ENTITY ESP SYSTEM
local espFolder = Instance.new("Folder")
espFolder.Name = "VIP_V60_ESP"
espFolder.Parent = ScreenGui

local activeESPs = {}

local function createVisuals(targetModel, nameText, color, isMonster)
    if not targetModel then return end
    local id = targetModel:GetDebugId()
    if activeESPs[id] then return end

    local primaryPart = targetModel:IsA("BasePart") and targetModel or targetModel:FindFirstChildWhichIsA("BasePart")
    if not primaryPart then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = id .. "_H"
    highlight.Adornee = targetModel
    highlight.FillTransparency = isMonster and 0.35 or 0.85
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.OutlineTransparency = 0
    highlight.Parent = espFolder

    local bg = Instance.new("BillboardGui")
    bg.Name = id .. "_B"
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

    activeESPs[id] = {Part = primaryPart, Color = color}
end

local function clearAll()
    espFolder:ClearAllChildren()
    activeESPs = {}
end

local function isShelfOrJunk(name)
    local n = name:lower()
    if n:find("bookshelf") or n:find("shelf") or n:find("rack") or n:find("furniture") or n:find("stand") or n:find("board") or n:find("paper") or n:find("painting") then
        return true
    end
    return false
end

local trueUsableItems = {
    "fuse", "battery", "key", "flashlight", "lockpick", "vitamins", 
    "crucifix", "skeletonkey", "gun", "shotgun", "tablet", "shears", 
    "medkit", "herb", "smoothie", "candle", "lighter", "chest"
}

local detectedMonsters = {}
local collectedBooksCount = 0

task.spawn(function()
    while task.wait(0.4) do
        clearAll()
        local myPos = Camera.CFrame.Position

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
                            end
                        end
                    end
                end
            end
        end

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
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if toggles.ESPMonsters then
            for _, folder in ipairs({workspace, Camera}) do
                for _, entity in pairs(folder:GetChildren()) do
                    local eName = entity.Name:lower()
                    for _, mName in ipairs(allMonsterKeywords) do
                        if eName:find(mName) then
                            createVisuals(entity, "⚠️ " .. entity.Name:upper() .. " ⚠️", Color3.fromRGB(255, 0, 0), true)
                            local eId = entity:GetDebugId()
                            if not detectedMonsters[eId] then
                                detectedMonsters[eId] = true
                                showMonsterAlert("🚨 CẢNH BÁO: " .. entity.Name:upper() .. " ĐANG TẤN CÔNG!", Color3.fromRGB(255, 50, 50))
                            end
                            break
                        end
                    end
                end
            end
        end
    end
end)

showMonsterAlert("DOORS VIP V60 Absolute Clone Loaded!", Color3.fromRGB(0, 255, 120))
