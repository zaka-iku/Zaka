--[[
    ╔════════════════════════════════════════════════════════════════════════════════╗
    ║         ZAKA PURE UI v3.2 - STEAL AN EGG SPECIAL EDITION                       ║
    ║   - Tối ưu hóa cho Steal an Egg (Auto Farm, Auto Loot Trứng, ESP, Speed, Fly)  ║
    ║   - Quản lý kết nối an toàn, chống memory leak, tự động phục hồi khi respawn   ║
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
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==============================================================================--
--                            CẤU HÌNH HỆ THỐNG (SETTINGS)                       --
--==============================================================================--
local Settings = {
    -- Speed & Movement
    Speed = false,
    SpeedValue = 24,
    Fly = false,
    FlySpeed = 40,
    Noclip = false,
    InfiniteJump = false,
    HighJump = false,
    JumpPower = 80,
    
    -- Steal an Egg Automation (Auto Farm / Auto Loot Trứng)
    AutoFarmEgg = false,
    AutoCollectLoot = false,
    FarmDistance = Vector3.new(0, 3, 0),
    TweenSpeed = 30, -- Tốc độ di chuyển mượt mà tới trứng
    
    -- Hitbox & ESP
    HitboxHead = false,
    HeadSize = 10,
    ESP = false,
    Fullbright = false,
}

--==============================================================================--
--                   QUẢN LÝ KẾT NỐI AN TOÀN & CLEANUP (v3.2)                   --
--==============================================================================--
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

-- Infinite Jump
SafeConnect("InfJump", UserInputService.JumpRequest, function()
    if Settings.InfiniteJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Movement Manager (WalkSpeed & HighJump)
SafeConnect("MovementManager", RunService.RenderStepped, function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    if Settings.Speed then
        hum.WalkSpeed = Settings.SpeedValue
    end
    
    if Settings.HighJump then
        if hum.UseJumpPower then
            hum.JumpPower = Settings.JumpPower
        else
            hum.JumpHeight = Settings.JumpPower / 4
        end
    end
end)

-- World Manager (Fullbright)
local OriginalAmbient = Lighting.Ambient
SafeConnect("WorldManager", RunService.RenderStepped, function()
    if Settings.Fullbright then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = OriginalAmbient
    end
end)

-- Noclip Logic An Toàn
local function ToggleNoclip(state)
    Settings.Noclip = state
    if state then
        SafeConnect("Noclip", RunService.Stepped, function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        SafeDisconnect("Noclip")
    end
end

-- Fly Engine An Toàn
local FlyGyro, FlyVel
local function ToggleFly(state)
    Settings.Fly = state
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    
    if state then
        FlyGyro = Instance.new("BodyGyro", root)
        FlyGyro.P = 9e4
        FlyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        FlyGyro.cframe = root.CFrame

        FlyVel = Instance.new("BodyVelocity", root)
        FlyVel.velocity = Vector3.new(0, 0, 0)
        FlyVel.maxForce = Vector3.new(9e9, 9e9, 9e9)

        SafeConnect("FlyLoop", RunService.RenderStepped, function()
            if not Settings.Fly or not char:FindFirstChild("Humanoid") then
                if FlyGyro then FlyGyro:Destroy() end
                if FlyVel then FlyVel:Destroy() end
                SafeDisconnect("FlyLoop")
                return
            end
            FlyGyro.cframe = Camera.CFrame
            local moveDir = char.Humanoid.MoveDirection
            if moveDir.Magnitude > 0 then
                local flyVector = (Camera.CFrame.LookVector * (moveDir.Z * -1)) + (Camera.CFrame.RightVector * moveDir.X)
                FlyVel.velocity = flyVector.Unit * Settings.FlySpeed
            else
                FlyVel.velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        if FlyGyro then FlyGyro:Destroy() end
        if FlyVel then FlyVel:Destroy() end
        SafeDisconnect("FlyLoop")
    end
end

--==============================================================================--
--           LOGIC ĐẶC BIỆT CHO "STEAL AN EGG" (AUTO FARM / AUTO LOOT)          --
--==============================================================================--
local ActiveTween = nil

local function GetAvailableEggs()
    local eggs = {}
    -- Quét qua CollectionService hoặc thư mục chứa Trứng trong Workspace của Steal an Egg
    for _, obj in ipairs(CollectionService:GetTagged("Egg")) do
        table.insert(eggs, obj)
    end
    -- Dự phòng tìm kiếm trực tiếp trong Workspace nếu game dùng Model thông thường
    if #eggs == 0 then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:lower():find("egg") or obj.Name:lower():find("trứng")) then
                table.insert(eggs, obj)
            end
        end
    end
    return eggs
end

-- Hàm Auto Thu Thập Trứng / Item
local function ToggleAutoFarmEgg(state)
    Settings.AutoFarmEgg = state
    if ActiveTween then ActiveTween:Cancel() end
    
    if state then
        ToggleNoclip(true) -- Tự động bật noclip khi auto farm để tránh kẹt tường
        SafeConnect("AutoFarmThread", RunService.Heartbeat, function()
            if not Settings.AutoFarmEgg then return end
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            local eggs = GetAvailableEggs()
            local targetEgg = nil
            local minDist = math.huge
            
            for _, egg in ipairs(eggs) do
                local part = egg:IsA("Model") and (egg.PrimaryPart or egg:FindFirstChildWhichIsA("BasePart")) or egg
                if part and egg.Parent then
                    local dist = (part.Position - root.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        targetEgg = egg
                    end
                end
            end
            
            if targetEgg then
                local targetPart = targetEgg:IsA("Model") and (targetEgg.PrimaryPart or targetEgg:FindFirstChildWhichIsA("BasePart")) or targetEgg
                if targetPart and targetEgg.Parent then
                    local targetCF = targetPart.CFrame + Settings.FarmDistance
                    local distance = (root.Position - targetCF.Position).Magnitude
                    local duration = math.clamp(distance / Settings.TweenSpeed, 0.1, 2)
                    
                    if ActiveTween then ActiveTween:Cancel() end
                    ActiveTween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCF})
                    ActiveTween:Play()
                    ActiveTween.Completed:Wait()
                    
                    -- Kích hoạt tương tác ProximityPrompt hoặc Touch nếu có trong game
                    for _, prompt in ipairs(targetEgg:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") then
                            fireproximityprompt(prompt)
                        end
                    end
                end
            else
                task.wait(0.5)
            end
        end)
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

-- Nút mở/đóng menu (Có thể kéo thả)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
ToggleBtn.Position = UDim2.new(0, 16, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
ToggleBtn.BackgroundTransparency = 0.1
ToggleBtn.Text = "EGG"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

-- Khung Menu Chính
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 380, 0, 420)
Main.Position = UDim2.new(0.5, -190, 0.5, -210)
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
Title.Text = "STEAL AN EGG // PRO UTILITY v3.2"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextColor3 = Color3.fromRGB(255, 200, 100)
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

-- Danh sách tính năng cuộn
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 400)
Scroll.ScrollBarThickness = 3
Scroll.Parent = Main

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.Parent = Scroll

-- Hàm tạo hàng Toggle nhanh
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

-- Thêm các tính năng vào menu
CreateToggle("🤖 Auto Farm Trứng (Steal an Egg)", ToggleAutoFarmEgg)
CreateToggle("⚡ Tăng tốc chạy (Speed Walk)", function(v) Settings.Speed = v end)
CreateToggle("🛸 Fly Mode (Bay tự do)", ToggleFly)
CreateToggle("🧱 Noclip (Đi xuyên vật cản)", ToggleNoclip)
CreateToggle("🦘 Nhảy vô tận (Infinite Jump)", function(v) Settings.InfiniteJump = v end)
CreateToggle("💡 Fullbright (Sáng bản đồ)", function(v) Settings.Fullbright = v end)

-- Xử lý mở/đóng Menu
local isOpen = false
ToggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    Main.Visible = isOpen
end)
CloseBtn.MouseButton1Click:Connect(function()
    isOpen = false
    Main.Visible = false
end)

print("✅ Steal an Egg Utility Menu v3.2 Loaded Successfully!")
