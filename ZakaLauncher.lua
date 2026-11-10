local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local savedCFrame = nil
local isSpeedEnabled = false
local speedValue = 75 -- Tốc độ tối ưu hóa cao nhưng an toàn không bị server đá

local getHui = gethui or function() return game:GetService("CoreGui") end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateEggGui"
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
Title.Text = "Steal An Egg - Fix AntiCheat"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Nút Chạy Nhanh
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(0.88, 0, 0, 38)
SpeedBtn.Position = UDim2.new(0.06, 0, 0.18, 0)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SpeedBtn.Text = "Chạy Nhanh: Tắt"
SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBtn.Font = Enum.Font.GothamMedium
SpeedBtn.Parent = MainFrame

-- Nút Lưu Vị Trí
local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(0.88, 0, 0, 38)
SaveBtn.Position = UDim2.new(0.06, 0, 0.38, 0)
SaveBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SaveBtn.Text = "Lưu Vị Trí"
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.Font = Enum.Font.GothamMedium
SaveBtn.Parent = MainFrame

-- Nút Tele Tức Thì (Chống Rollback & Chống Die)
local InstantTeleBtn = Instance.new("TextButton")
InstantTeleBtn.Size = UDim2.new(0.88, 0, 0, 38)
InstantTeleBtn.Position = UDim2.new(0.06, 0, 0.58, 0)
InstantTeleBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
InstantTeleBtn.Text = "⚡ Tele Tức Thì (Chống Die)"
InstantTeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
InstantTeleBtn.Font = Enum.Font.GothamBold
InstantTeleBtn.Parent = MainFrame

-- Nút Tele Thường
local NormalTeleBtn = Instance.new("TextButton")
NormalTeleBtn.Size = UDim2.new(0.88, 0, 0, 38)
NormalTeleBtn.Position = UDim2.new(0.06, 0, 0.78, 0)
NormalTeleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
NormalTeleBtn.Text = "🎯 Tele Về Nơi Lưu"
NormalTeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NormalTeleBtn.Font = Enum.Font.GothamMedium
NormalTeleBtn.Parent = MainFrame

local function getCharacterParts()
    local char = player.Character
    if not char then return nil, nil, nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    return char, hum, hrp
end

-- Chạy nhanh mượt, không bị khựng hoặc bị quét
RunService.Heartbeat:Connect(function()
    if isSpeedEnabled then
        local _, hum, hrp = getCharacterParts()
        if hum and hrp and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (speedValue / 60))
        end
    end
end)

SpeedBtn.MouseButton1Click:Connect(function()
    isSpeedEnabled = not isSpeedEnabled
    if isSpeedEnabled then
        SpeedBtn.Text = "Chạy Nhanh: BẬT"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 80)
    else
        SpeedBtn.Text = "Chạy Nhanh: Tắt"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end
end)

SaveBtn.MouseButton1Click:Connect(function()
    local _, _, hrp = getCharacterParts()
    if hrp then
        -- Lưu vị trí nhô cao hơn mặt đất 2 đơn vị để tránh bị kẹt chân xuống sàn khi tele về
        savedCFrame = hrp.CFrame + Vector3.new(0, 2, 0)
        SaveBtn.Text = "Đã Lưu Vị Trí!"
        SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 110, 200)
        task.delay(1, function()
            SaveBtn.Text = "Lưu Vị Trí"
            SaveBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
    end
end)

-- Hàm vô hiệu hóa va chạm (NoClip) tạm thời giúp chống kẹt tường chết
local function temporaryNoClip(char, duration)
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

-- 1. TELEPORT TỨC THÌ (Khắc phục triệt để lỗi bị giật ngược về và chết)
InstantTeleBtn.MouseButton1Click:Connect(function()
    local char, hum, hrp = getCharacterParts()
    if savedCFrame and hrp and hum then
        -- Tạm thời vô hiệu hóa va chạm nhân vật trong 1.5 giây
        temporaryNoClip(char, 1.5)
        
        -- Reset toàn bộ quán tính và lực rơi hiện tại của nhân vật
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)

        -- Khóa vị trí liên tục trong 5 khung hình (giúp server nhận diện đây là vị trí hợp lệ, chặn đứng việc kéo ngược)
        local count = 0
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if hrp and savedCFrame then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = savedCFrame
                count = count + 1
                if count > 5 then
                    connection:Disconnect()
                end
            end
        end)

        InstantTeleBtn.Text = "Đã Tele Thành Công!"
        InstantTeleBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 70)
        task.delay(1, function()
            InstantTeleBtn.Text = "⚡ Tele Tức Thì (Chống Die)"
            InstantTeleBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
        end)
    else
        InstantTeleBtn.Text = "Chưa Lưu Vị Trí!"
        task.delay(1, function()
            InstantTeleBtn.Text = "⚡ Tele Tức Thì (Chống Die)"
        end)
    end
end)

-- 2. TELEPORT THƯỜNG (Dự phòng)
NormalTeleBtn.MouseButton1Click:Connect(function()
    local char, _, hrp = getCharacterParts()
    if savedCFrame and hrp then
        temporaryNoClip(char, 1)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.CFrame = savedCFrame
        
        NormalTeleBtn.Text = "Đã Đến Nơi!"
        NormalTeleBtn.BackgroundColor3 = Color3.fromRGB(0, 110, 200)
        task.delay(1, function()
            NormalTeleBtn.Text = "🎯 Tele Về Nơi Lưu"
            NormalTeleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
    else
        NormalTeleBtn.Text = "Chưa Lưu Vị Trí!"
        task.delay(1, function()
            NormalTeleBtn.Text = "🎯 Tele Về Nơi Lưu"
        end)
    end
end)
