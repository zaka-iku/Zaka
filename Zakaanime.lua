-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Dọn dẹp menu cũ nếu chạy lại
if PlayerGui:FindFirstChild("ZenitsuUltimateHub") then
    PlayerGui.ZenitsuUltimateHub:Destroy()
end

-- Tạo GUI chính chạy mượt trên Delta Client Mobile
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZenitsuUltimateHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Nút tròn mở/đóng menu (Có thể kéo thả trên màn hình)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.Text = "⚡"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 220, 0)
ToggleBtn.TextSize = 22
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(1, 0)
BtnCorner.Parent = ToggleBtn

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = Color3.fromRGB(255, 215, 0)
BtnStroke.Thickness = 2
BtnStroke.Parent = ToggleBtn

-- Khung Menu chính
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 310)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.05
MainFrame.Visible = true -- Hiện ngay lập tức để kiểm tra
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 215, 0)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "⚡ ZENITSU THUNDER MENU ⚡"
Title.TextColor3 = Color3.fromRGB(255, 235, 59)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Sự kiện ẩn/hiện menu khi bấm nút ⚡
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Hàm tạo các nút bấm chức năng an toàn
local function createMenuButton(text, yPos, onClick)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 42)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 100)
    stroke.Thickness = 1
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        pcall(function()
            onClick(btn)
        end)
    end)
end

-- Biến lưu trạng thái Kiếm Zenitsu
local ZenitsuOn = false
local SwordModel = nil

local function RemoveSword()
    if SwordModel then
        pcall(function() SwordModel:Destroy() end)
        SwordModel = nil
    end
end

-- 1. Tính năng Zenitsu Sword & Tốc độ
createMenuButton("🗡️ [1] Bật/Tắt Kiếm Sấm Sét", 45, function(btn)
    ZenitsuOn = not ZenitsuOn
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    
    if ZenitsuOn then
        btn.TextColor3 = Color3.fromRGB(255, 230, 0)
        btn.Text = "🗡️ [Đang Bật] Kiếm Sấm Sét"
        if humanoid then
            humanoid.WalkSpeed = 22
            humanoid.JumpPower = 70
        end
        
        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        if torso then
            RemoveSword()
            local model = Instance.new("Model")
            model.Name = "ZenitsuSword"
            
            local handle = Instance.new("Part")
            handle.Size = Vector3.new(0.3, 1, 0.3)
            handle.Color = Color3.fromRGB(40, 30, 20)
            handle.CanCollide = false
            handle.Massless = true
            handle.Parent = model

            local blade = Instance.new("Part")
            blade.Size = Vector3.new(0.2, 3.8, 0.12)
            blade.Color = Color3.fromRGB(255, 225, 50)
            blade.Material = Enum.Material.Neon
            blade.CanCollide = false
            blade.Massless = true
            blade.Parent = model

            local w = Instance.new("Weld")
            w.Part0 = handle
            w.Part1 = blade
            w.C0 = CFrame.new(0, 2.3, 0)
            w.Parent = blade

            local weld = Instance.new("Weld")
            weld.Part0 = torso
            weld.Part1 = handle
            weld.C0 = CFrame.new(1.1, 0.2, 0.5) * CFrame.Angles(0, math.rad(90), math.rad(-20))
            weld.Parent = handle

            model.Parent = char
            SwordModel = model
        end
    else
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = "🗡️ [1] Bật/Tắt Kiếm Sấm Sét"
        RemoveSword()
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end
end)

-- 2. Kỹ năng 1: Lướt nhanh
createMenuButton("⚡ Thức 1: Tích Khắc Nhất Thiểm", 95, function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 25)
    end
end)

-- 3. Kỹ năng 2: Lướt 6 lần
createMenuButton("⚡ Thức 2: Liên Hoàn Điện Quang", 145, function()
    task.spawn(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        for i = 1, 6 do
            hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 7)
            task.wait(0.03)
        end
    end)
end)

-- 4. Kỹ năng 3: Lao tới áp sát
createMenuButton("⚡ Thức 3: Hỏa Lôi Thần Tốc", 195, function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 35)
    end
end)

-- 5. Động tác đóng kiếm
createMenuButton("⚔️ Động Tác Đóng Kiếm Ngầu", 245, function()
    print("Đã thực hiện động tác đóng kiếm Katana!")
end)
