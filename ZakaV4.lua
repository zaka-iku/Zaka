-- Zaka V4 Pro Ultimate Edition - Clean & Optimized
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Config = {Faction = "Civilian", AutoArrest = false, AutoTrade = false, AutoBank = false, Aimbot = false}

-- HÀM BYPASS ANTI-CHEAT (Tránh bị kéo về chỗ cũ)
local function BypassMoveTo(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local tween = game:GetService("TweenService"):Create(char.HumanoidRootPart, TweenInfo.new(1), {CFrame = targetCFrame})
    tween:Play()
end

-- LOGIC CƠ BẢN ĐỂ SCRIPT CHẠY
task.spawn(function()
    while task.wait(1) do
        -- Logic cảnh sát bắt tội phạm
        if Config.Faction == "Police" and Config.AutoArrest then
            -- Tự động tìm tội phạm quanh map (Tùy biến dựa trên leaderstats của game)
            print("Đang quét tội phạm...")
        end
        -- Logic auto farm dân thường
        if Config.Faction == "Civilian" and Config.AutoTrade then
             print("Đang chạy auto trade...")
        end
    end
end)

print("Zaka V4 Pro đã nạp thành công!")
-- Thêm UI ở đây...
--[[
    ╔════════════════════════════════════════════════════════════════╗
    ║                 ZAKA V4 PRO ULTIMATE EDITION                   ║
    ║   Combat • Auto Farm • Police Auto Arrest • Anti-Cheat Bypass  ║
    ╚════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================== CẤU HÌNH HỆ THỐNG ====================--
local Config = {
    Faction = "Civilian", -- "Civilian" hoặc "Police"
    
    -- Combat
    Aimbot = false,
    AimbotFOV = 120,
    AimbotSmooth = 0.15,
    ESP = false,

    -- Auto Farm (Dân thường)
    AutoBank = false,
    AutoTrade = false,
    AutoBoat = false,

    -- Police Features (Cảnh sát)
    AutoArrest = false,
    ArrestRange = 15,

    -- Character Modifier
    WalkSpeed = 24,
    EnableSpeed = false,
    Noclip = false
}

--==================== BYPASS ANTI-CHEAT (SAFE MOVE) ====================--
local function BypassMoveTo(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    -- Bật Noclip tạm thời để không bị giật do va chạm vật cản
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end

    local distance = (root.Position - targetCFrame.Position).Magnitude
    local speed = 120 -- Tốc độ an toàn tránh Anti-cheat kéo về chỗ cũ (Rubber-banding)
    local duration = math.clamp(distance / speed, 0.3, 4)

    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

--==================== AIMBOT CỐ ĐỊNH TÂM ====================--
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = Config.AimbotFOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(0, 255, 150)

RunService.RenderStepped:Connect(function()
    local viewportSize = Camera.ViewportSize
    local centerScreen = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    
    FOVCircle.Position = centerScreen
    FOVCircle.Radius = Config.AimbotFOV
    FOVCircle.Visible = Config.Aimbot

    if Config.Aimbot then
        local closestTarget = nil
        local shortestDistance = Config.AimbotFOV

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local isEnemy = true
                -- Kiểm tra phe nếu chọn Cảnh Sát
                if Config.Faction == "Police" and plr.Team == LocalPlayer.Team then
                    isEnemy = false
                end

                if isEnemy and plr.Character.Humanoid.Health > 0 then
                    local head = plr.Character.Head
                    local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - centerScreen).Magnitude
                        if dist < shortestDistance then
                            shortestDistance = dist
                            closestTarget = head
                        end
                    end
                end
            end
        end

        if closestTarget then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, closestTarget.Position), Config.AimbotSmooth)
        end
    end
end)

--==================== HE THONG CANH SAT (AUTO ARREST) ====================--
task.spawn(function()
    while task.wait(0.5) do
        if Config.Faction == "Police" and Config.AutoArrest then
            pcall(function()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        -- Kiểm tra nếu người chơi có mức nã (Wanted) hoặc là Dân Thường/Tội Phạm
                        local isCriminal = plr:FindFirstChild("leaderstats") and plr.leaderstats:FindFirstChild("Wanted") and plr.leaderstats.Wanted.Value > 0
                        
                        if isCriminal and plr.Character.Humanoid.Health > 0 then
                            local targetRoot = plr.Character.HumanoidRootPart
                            -- Dịch chuyển an toàn đến ngay sau lưng tội phạm
                            BypassMoveTo(targetRoot.CFrame * CFrame.new(0, 0, 2))
                            
                            -- Giả lập bấm tương tác/bắt giữ liên tục
                            task.wait(0.2)
                            fireproximityprompt or VirtualUser:ClickButton1(Vector2.new())
                            
                            -- Kích hoạt công cụ Handcuffs (Còng tay) nếu có trong Balo
                            local handcuffs = LocalPlayer.Backpack:FindFirstChild("Còng Tay") or LocalPlayer.Backpack:FindFirstChild("Handcuffs")
                            if handcuffs then
                                LocalPlayer.Character.Humanoid:EquipTool(handcuffs)
                                handcuffs:Activate()
                            end
                        end
                    end
                end
            end)
        end
    end
end)

--==================== AUTO FARM DÂN THƯỜNG (FULL LOOP) ====================--
-- 1. Auto Buôn Bán Lậu (Mua liên tục không dừng)
task.spawn(function()
    while task.wait(1) do
        if Config.Faction == "Civilian" and Config.AutoTrade then
            pcall(function()
                local DealerPos = CFrame.new(-210, 10, -150)
                local DropOffPos = CFrame.new(320, 12, -800)
                
                -- Đến chỗ lấy hàng lậu
                BypassMoveTo(DealerPos)
                task.wait(0.5)
                
                -- Vòng lặp tự động nhấp mua hàng lậu liên tục cho đến khi đầy túi
                for i = 1, 5 do
                    fireproximityprompt or VirtualUser:ClickButton1(Vector2.new())
                    task.wait(0.2)
                end
                
                -- Bán hàng lậu
                BypassMoveTo(DropOffPos)
                task.wait(1)
                fireproximityprompt or VirtualUser:ClickButton1(Vector2.new())
            end)
        end
    end
end)

-- 2. Auto Rob Bank
task.spawn(function()
    while task.wait(1) do
        if Config.Faction == "Civilian" and Config.AutoBank then
            pcall(function()
                local VaultCFrame = CFrame.new(105, 12, -380)
                BypassMoveTo(VaultCFrame)
                task.wait(1)
                fireproximityprompt or VirtualUser:ClickButton1(Vector2.new())
            end)
        end
    end
end)

--==================== GIAO DIỆN MENU (GUI) ====================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaV4ProUI"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Toggle Button Mobile
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.3, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
ToggleBtn.Text = "ZAKA V4"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 11
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

-- Main Window
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 350, 0, 440)
Main.Position = UDim2.new(0.5, -175, 0.5, -220)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
Main.Active = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- Top Title Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Zaka V4 Pro - San Diego Edition"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Faction Selector (Chọn Phe Dân Thường / Cảnh Sát)
local FactionFrame = Instance.new("Frame")
FactionFrame.Size = UDim2.new(1, -20, 0, 35)
FactionFrame.Position = UDim2.new(0, 10, 0, 45)
FactionFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
FactionFrame.Parent = Main
Instance.new("UICorner", FactionFrame).CornerRadius = UDim.new(0, 8)

local CivBtn = Instance.new("TextButton")
CivBtn.Size = UDim2.new(0.5, -4, 1, -4)
CivBtn.Position = UDim2.new(0, 2, 0, 2)
CivBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
CivBtn.Text = "DÂN THƯỜNG"
CivBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CivBtn.Font = Enum.Font.GothamBold
CivBtn.TextSize = 11
CivBtn.Parent = FactionFrame
Instance.new("UICorner", CivBtn).CornerRadius = UDim.new(0, 6)

local CopBtn = Instance.new("TextButton")
CopBtn.Size = UDim2.new(0.5, -4, 1, -4)
CopBtn.Position = UDim2.new(0.5, 2, 0, 2)
CopBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CopBtn.Text = "CẢNH SÁT"
CopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopBtn.Font = Enum.Font.GothamBold
CopBtn.TextSize = 11
CopBtn.Parent = FactionFrame
Instance.new("UICorner", CopBtn).CornerRadius = UDim.new(0, 6)

CivBtn.MouseButton1Click:Connect(function()
    Config.Faction = "Civilian"
    CivBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    CopBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
end)

CopBtn.MouseButton1Click:Connect(function()
    Config.Faction = "Police"
    CopBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    CivBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
end)

-- Container chứa Toggles
local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Size = UDim2.new(1, -20, 1, -90)
ContentScroll.Position = UDim2.new(0, 10, 0, 85)
ContentScroll.BackgroundTransparency = 1
ContentScroll.ScrollBarThickness = 3
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 500)
ContentScroll.Parent = Main

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 8)
ListLayout.Parent = ContentScroll

local function AddToggle(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    frame.Parent = ContentScroll
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 230)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -45, 0.5, -10)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(60, 60, 70)
    btn.Text = ""
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(60, 60, 70)
        callback(state)
    end)
end

-- TÍNH NĂNG COMBAT
AddToggle("Aimbot Lock (Fixed Center FOV)", false, function(v) Config.Aimbot = v end)

-- TÍNH NĂNG CẢNH SÁT
AddToggle("[Police] Auto Teleport & Arrest Tội Phạm", false, function(v) Config.AutoArrest = v end)

-- TÍNH NĂNG AUTO FARM (DÂN THƯỜNG)
AddToggle("[Civilian] Auto Buôn Bán Lậu (Buy Loop)", false, function(v) Config.AutoTrade = v end)
AddToggle("[Civilian] Auto Rob Bank (Cướp Ngân Hàng)", false, function(v) Config.AutoBank = v end)

-- DI CHUYỂN AN TOÀN
AddToggle("Speed Hack (24 WalkSpeed Safe)", false, function(v) 
    Config.EnableSpeed = v 
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v and Config.WalkSpeed or 16
    end
end)

print("[Zaka V4 Pro] Script Loaded Successfully!")
