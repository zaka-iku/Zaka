--[[
    ╔════════════════════════════════════════════════════════════════════════════════╗
    ║       ZAKA PURE UI v3.4 - ADVANCED HIGH-SPEED BYPASS & AUTO SNATCHER           ║
    ║   - Tốc độ siêu nhanh trực diện tới trứng xịn nhất bản đồ                     ║
    ║   - Cơ chế Bypass Anti-Cheat nâng cao: Chia nhỏ vector, giả lập lực vật lý     ║
    ║   - Tự động nhặt, tự động bay đường vòng zíc-zắc về vùng an toàn an toàn        ║
    ╚════════════════════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==============================================================================--
--                            CẤU HÌNH NÂNG CAO (SETTINGS)                       --
--==============================================================================--
local Settings = {
    Speed = false,
    SpeedValue = 24,
    Noclip = false,
    InfiniteJump = false,
    
    -- Auto Farm Trứng Cực Nhanh & An Toàn
    AutoFarmEgg = false,
    SafeZonePosition = Vector3.new(0, 15, 0), -- Tọa độ vùng an toàn của bạn
    FlightSpeed = 120, -- Tốc độ bay siêu nhanh tới trứng xịn
}

local ActiveConnections = {}
local function SafeConnect(name, signal, handler)
    if ActiveConnections[name] then
        ActiveConnections[name]:Disconnect()
        ActiveConnections[name] = nil
    end
    ActiveConnections[name] = signal:Connect(handler)
end

local function SafeDisconnect(name)
    if ActiveConnections[name] then
        ActiveConnections[name]:Disconnect()
        ActiveConnections[name] = nil
    end
end

-- Anti-AFK
SafeConnect("AntiAFK", LocalPlayer.Idled, function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- WalkSpeed An Toàn
SafeConnect("MovementManager", RunService.RenderStepped, function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and Settings.Speed then
        hum.WalkSpeed = Settings.SpeedValue
    end
end)

-- Noclip Chống Kẹt
local function ToggleNoclip(state)
    Settings.Noclip = state
    if state then
        SafeConnect("NoclipLoop", RunService.Stepped, function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        SafeDisconnect("NoclipLoop")
    end
end

--==============================================================================--
--              THUẬT TOÁN TÌM TRỨNG XỊN NHẤT & BYPASS ANTI-CHEAT                 --
--==============================================================================--
local ActiveTween = nil

-- Hàm đánh giá độ hiếm cực chuẩn xác để ưu tiên trứng xịn nhất game
local function GetEggRarityScore(eggName)
    local name = eggName:lower()
    if name:find("mythical") or name:find("secret") or name:find("divine") or name:find("thần thoại") or name:find("tối thượng") then return 10
    elseif name:find("legendary") or name:find("huyền thoại") then return 8
    elseif name:find("epic") or name:find("sử thi") then return 6
    elseif name:find("rare") or name:find("hiếm") then return 4
    else return 2 end
end

local function GetAvailableEggs()
    local eggs = {}
    for _, obj in ipairs(CollectionService:GetTagged("Egg")) do
        table.insert(eggs, obj)
    end
    if #eggs == 0 then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:lower():find("egg") or obj.Name:lower():find("trứng")) then
                table.insert(eggs, obj)
            end
        end
    end
    return eggs
end

-- Hàm di chuyển tốc độ cao nhưng mô phỏng đường đi vật lý để tránh bị kick/ban
local function SafeHighSpeedFlight(rootPart, targetCFrame, duration)
    local startCF = rootPart.CFrame
    local startTime = tick()
    
    while tick() - startTime < duration do
        if not Settings.AutoFarmEgg or not rootPart.Parent then return false end
        local alpha = math.clamp((tick() - startTime) / duration, 0, 1)
        -- Sử dụng hàm cong nhẹ để lừa bộ lọc gia tốc của game
        local smoothedAlpha = alpha * alpha * (3 - 2 * alpha) 
        rootPart.CFrame = startCF:Lerp(targetCFrame, smoothedAlpha)
        RunService.Heartbeat:Wait()
    end
    rootPart.CFrame = targetCFrame
    return true
end

local function ToggleAutoFarmEgg(state)
    Settings.AutoFarmEgg = state
    if ActiveTween then ActiveTween:Cancel() end
    
    if state then
        ToggleNoclip(true)
        SafeConnect("AutoFarmThread", task.spawn(function()
            while Settings.AutoFarmEgg do
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not root then 
                    task.wait(0.5)
                    continue 
                end
                
                local eggs = GetAvailableEggs()
                if #eggs == 0 then
                    task.wait(1)
                    continue
                end
                
                -- Sắp xếp tìm quả trứng có điểm độ hiếm cao nhất (Trứng xịn nhất bản đồ)
                table.sort(eggs, function(a, b)
                    return GetEggRarityScore(a.Name) > GetEggRarityScore(b.Name)
                end)
                
                local targetEgg = eggs[1]
                local targetPart = targetEgg:IsA("Model") and (targetEgg.PrimaryPart or targetEgg:FindFirstChildWhichIsA("BasePart")) or targetEgg
                
                if targetPart and targetEgg.Parent then
                    local targetCF = targetPart.CFrame + Vector3.new(0, 3, 0)
                    local distance = (root.Position - targetCF.Position).Magnitude
                    local flightDuration = distance / Settings.FlightSpeed
                    
                    -- 1. Bay tốc độ cao trực diện đến quả trứng xịn nhất
                    local success = SafeHighSpeedFlight(root, targetCF, flightDuration)
                    if not success then break end
                    
                    -- 2. Tự động tương tác nhặt trứng
                    for _, prompt in ipairs(targetEgg:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") then
                            fireproximityprompt(prompt)
                        end
                    end
                    task.wait(0.15)
                    
                    -- 3. Tự động bay về vùng an toàn theo đường zíc-zắc chống quét anti-cheat
                    local safeCF = CFrame.new(Settings.SafeZonePosition)
                    local backDist = (root.Position - safeCF.Position).Magnitude
                    local backDuration = backDist / Settings.FlightSpeed
                    
                    -- Bay lượn trung gian 1 nhịp trên không rồi hạ cánh
                    local intermediateCF = CFrame.new(root.Position:Lerp(Settings.SafeZonePosition, 0.5) + Vector3.new(10, 20, 10))
                    SafeHighSpeedFlight(root, intermediateCF, backDuration / 2)
                    
                    -- Thả rơi chạm đất giả lập vật lý để reset trạng thái Anti-Cheat
                    root.Velocity = Vector3.new(0, -10, 0)
                    task.wait(0.2)
                    
                    -- Bay thẳng về vùng an toàn hoàn tất chu kỳ
                    SafeHighSpeedFlight(root, safeCF, backDuration / 2)
                end
                task.wait(0.2)
            end
        end))
    else
        SafeDisconnect("AutoFarmThread")
        ToggleNoclip(false)
        if ActiveTween then ActiveTween:Cancel() end
    end
end

--==============================================================================--
--                           GIAO DIỆN UI (ZAKA PURE UI)                        --
--==============================================================================--
pcall(function()
    if PlayerGui:FindFirstChild("ZakaStealAnEggUI") then
        PlayerGui.ZakaStealAnEggUI:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaStealAnEggUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
ToggleBtn.Position = UDim2.new(0, 16, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
ToggleBtn.BackgroundTransparency = 0.1
ToggleBtn.Text = "EGG"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 380, 0, 320)
Main.Position = UDim2.new(0.5, -190, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 19, 28)
Main.BackgroundTransparency = 0.15
Main.Visible = false
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "STEAL AN EGG // PRO BYPASS v3.4"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextColor3 = Color3.fromRGB(255, 150, 50)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 250)
Scroll.ScrollBarThickness = 3
Scroll.Parent = Main

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.Parent = Scroll

local function CreateToggle(name, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 40)
    card.BackgroundColor3 = Color3.fromRGB(24, 30, 44)
    card.Parent = Scroll
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextColor3 = Color3.fromRGB(230, 235, 250)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 24)
    btn.Position = UDim2.new(1, -60, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(45, 52, 70)
    btn.Text = "OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.Parent = card
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = active and "ON" or "OFF"
        btn.TextColor3 = active and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(45, 52, 70)
        callback(active)
    end)
end

CreateToggle("🚀 Auto Snatcher Trứng Xịn + Về Vùng An Toàn", ToggleAutoFarmEgg)
CreateToggle("⚡ Tăng Tốc Chạy Nhanh", function(v) Settings.Speed = v end)
CreateToggle("🧱 Noclip (Xuyên Tường)", ToggleNoclip)

ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

print("✅ Steal an Egg Pro Bypass v3.4 Loaded Successfully!")
