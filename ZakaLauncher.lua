local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local savedCFrame = nil
local isSpeedEnabled = false
local speedValue = 120 -- Tốc độ cực nhanh nhưng được kiểm soát để tránh crash game

local getHui = gethui or function() return game:GetService("CoreGui") end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ProAntiCheatGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = getHui()

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 280)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "Steal An Egg - Pro Bypass"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Nút Chạy Nhanh
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(0.88, 0, 0, 38)
SpeedBtn.Position = UDim2.new(0.06, 0, 0.18, 0)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SpeedBtn.Text = "Siêu Tốc Độ: Tắt"
SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBtn.Font = Enum.Font.GothamMedium
SpeedBtn.Parent = MainFrame

-- Nút Lưu Vị Trí
local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(0.88, 0, 0, 38)
SaveBtn.Position = UDim2.new(0.06, 0, 0.38, 0)
SaveBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SaveBtn.Text = "Lưu Vị Trí Hiện Tại"
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.Font = Enum.Font.GothamMedium
SaveBtn.Parent = MainFrame

-- Nút Teleport Tức Thì (Instant TP)
local InstantTeleBtn = Instance.new("TextButton")
InstantTeleBtn.Size = UDim2.new(0.88, 0, 0, 38)
InstantTeleBtn.Position = UDim2.new(0.06, 0, 0.58, 0)
InstantTeleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
InstantTeleBtn.Text = "⚡ Tele Tức Thì (Về Lưu)"
InstantTeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
InstantTeleBtn.Font = Enum.Font.GothamBold
InstantTeleBtn.Parent = MainFrame

-- Nút Teleport Trơn Mượt (Safe TP)
local SafeTeleBtn = Instance.new("TextButton")
SafeTeleBtn.Size = UDim2.new(0.88, 0, 0, 38)
SafeTeleBtn.Position = UDim2.new(0.06, 0, 0.78, 0)
SafeTeleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SafeTeleBtn.Text = "🛡️ Tele An Toàn (Chống Die)"
SafeTeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SafeTeleBtn.Font = Enum.Font.GothamMedium
SafeTeleBtn.Parent = MainFrame

local function getCharacterParts()
    local char = player.Character
    if not char then return nil, nil, nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    return char, hum, hrp
end

-- Chạy cực nhanh bằng phương pháp ép tọa độ liên tục (Bypass WalkSpeed limit của server)
RunService.Heartbeat:Connect(function()
    if isSpeedEnabled then
        local _, hum, hrp = getCharacterParts()
        if hum and hrp and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (speedValue / 45))
        end
    end
end)

SpeedBtn.MouseButton1Click:Connect(function()
    isSpeedEnabled = not isSpeedEnabled
    if isSpeedEnabled then
        SpeedBtn.Text = "Siêu Tốc Độ: BẬT"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 80)
    else
        SpeedBtn.Text = "Siêu Tốc Độ: Tắt"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end
end)

SaveBtn.MouseButton1Click:Connect(function()
    local _, _, hrp = getCharacterParts()
    if hrp then
        savedCFrame = hrp.CFrame
        SaveBtn.Text = "Đã Lưu Thành Công!"
        SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 110, 200)
        task.delay(1, function()
            SaveBtn.Text = "Lưu Vị Trí Hiện Tại"
            SaveBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
    end
end)

-- Hàm kích hoạt chế độ NoClip tạm thời để chống kẹt tường / chống die khi tele
local function activateAntiDeathNoClip(char, duration)
    local conn
    conn = RunService.Stepped:Connect(function()
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
    task.delay(duration, function()
        if conn then conn:Disconnect() end
    end)
end

-- 1. TÍNH NĂNG TELEPORT TỨC THÌ (Instant Teleport)
InstantTeleBtn.MouseButton1Click:Connect(function()
    local char, _, hrp = getCharacterParts()
    if savedCFrame and hrp then
        -- Bật chống kẹt va chạm trong 1 giây
        activateAntiDeathNoClip(char, 1)

        -- Xóa triệt để quán tính vật lý trước khi nhảy cóc tọa độ
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        
        -- Ép tọa độ đến vị trí lưu ngay lập tức
        hrp.CFrame = savedCFrame
        
        -- Đóng băng phụ trợ thêm 1 nhịp để chống server rollback
        task.defer(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = savedCFrame
        end)

        InstantTeleBtn.Text = "Đã Tele Tức Thì!"
        InstantTeleBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 70)
        task.delay(1, function()
            InstantTeleBtn.Text = "⚡ Tele Tức Thì (Về Lưu)"
            InstantTeleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        end)
    else
        InstantTeleBtn.Text = "Chưa Lưu Vị Trí!"
        task.delay(1, function()
            InstantTeleBtn.Text = "⚡ Tele Tức Thì (Về Lưu)"
        end)
    end
end)

-- 2. TÍNH NĂNG TELEPORT AN TOÀN (Dịch chuyển chống die dự phòng)
SafeTeleBtn.MouseButton1Click:Connect(function()
    local char, _, hrp = getCharacterParts()
    if savedCFrame and hrp then
        activateAntiDeathNoClip(char, 1.5)
        
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.CFrame = savedCFrame + Vector3.new(0, 3, 0) -- Nhấc cao hơn mặt đất 3 đơn vị tránh kẹt hầm

        SafeTeleBtn.Text = "Đã Tele An Toàn!"
        SafeTeleBtn.BackgroundColor3 = Color3.fromRGB(0, 110, 200)
        task.delay(1, function()
            SafeTeleBtn.Text = "🛡️ Tele An Toàn (Chống Die)"
            SafeTeleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
    else
        SafeTeleBtn.Text = "Chưa Lưu Vị Trí!"
        task.delay(1, function()
            SafeTeleBtn.Text = "🛡️ Tele An Toàn (Chống Die)"
        end)
    end
end)
