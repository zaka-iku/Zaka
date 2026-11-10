local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local savedCFrame = nil
local isSpeedEnabled = false
local speedValue = 110

local getHui = gethui or function() return game:GetService("CoreGui") end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InstantEggStealGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = getHui()

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 250)
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
Title.Text = "Steal An Egg - Siêu Tốc"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.Parent = MainFrame

-- Nút Lưu Vị Trí
local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(0.88, 0, 0, 38)
SaveBtn.Position = UDim2.new(0.06, 0, 0.22, 0)
SaveBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SaveBtn.Text = "1. Lưu Vị Trí Lấy Trứng"
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.Font = Enum.Font.GothamMedium
SaveBtn.Parent = MainFrame

-- Nút Tele Cực Tốc (Instant TP)
local FastTeleBtn = Instance.new("TextButton")
FastTeleBtn.Size = UDim2.new(0.88, 0, 0, 38)
FastTeleBtn.Position = UDim2.new(0.06, 0, 0.42, 0)
FastTeleBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
FastTeleBtn.Text = "⚡ 2. Tele Siêu Tốc (Lấy Trứng)"
FastTeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FastTeleBtn.Font = Enum.Font.GothamBold
FastTeleBtn.Parent = MainFrame

-- Nút Tele Quay Về
local BackTeleBtn = Instance.new("TextButton")
BackTeleBtn.Size = UDim2.new(0.88, 0, 0, 38)
BackTeleBtn.Position = UDim2.new(0.06, 0, 0.62, 0)
BackTeleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
BackTeleBtn.Text = "🏠 3. Tele Về Chỗ Cũ"
BackTeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BackTeleBtn.Font = Enum.Font.GothamBold
BackTeleBtn.Parent = MainFrame

local function getCharacterParts()
    local char = player.Character
    if not char then return nil, nil, nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    return char, hum, hrp
end

-- Biến lưu vị trí xuất phát trước khi tele (để bấm nút 3 bay về)
local originCFrame = nil

SaveBtn.MouseButton1Click:Connect(function()
    local _, _, hrp = getCharacterParts()
    if hrp then
        -- Lưu vị trí hiện tại (nâng cao 2 đơn vị tránh kẹt sàn)
        savedCFrame = hrp.CFrame + Vector3.new(0, 2, 0)
        SaveBtn.Text = "Đã Lưu Điểm Lấy Trứng!"
        SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 80)
        task.delay(1, function()
            SaveBtn.Text = "1. Lưu Vị Trí Lấy Trứng"
            SaveBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
    end
end)

-- Hàm tắt va chạm tạm thời chống chết
local function bypassCollision(char)
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
    task.delay(0.8, function()
        if conn then conn:Disconnect() end
    end)
end

-- ⚡ NÚT 2: TELE SIÊU TỐC ĐẾN CHỖ TRỨNG (Nhanh tức thì, chống kéo ngược)
FastTeleBtn.MouseButton1Click:Connect(function()
    local char, hum, hrp = getCharacterParts()
    if savedCFrame and hrp and hum then
        -- Lưu lại chỗ bạn đang đứng trước khi tele để lát còn bấm nút quay về
        originCFrame = hrp.CFrame
        
        bypassCollision(char)
        
        -- Triệt tiêu hoàn toàn quán tính cũ
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)

        -- Khóa chặt tọa độ đích liên tục trong 8 khung hình để lừa bộ kiểm tra của server
        local count = 0
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if hrp and savedCFrame then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = savedCFrame
                count = count + 1
                if count > 8 then
                    connection:Disconnect()
                end
            end
        end)

        FastTeleBtn.Text = "Đã Cướp Trứng Thành Công!"
        FastTeleBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 70)
        task.delay(1, function()
            FastTeleBtn.Text = "⚡ 2. Tele Siêu Tốc (Lấy Trứng)"
            FastTeleBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
        end)
    else
        FastTeleBtn.Text = "Chưa Lưu Điểm Lấy Trứng!"
        task.delay(1, function()
            FastTeleBtn.Text = "⚡ 2. Tele Siêu Tốc (Lấy Trứng)"
        end)
    end
end)

-- 🏠 NÚT 3: TELE QUAY VỀ CHỖ CŨ (Sau khi lấy trứng xong bay về ngay)
BackTeleBtn.MouseButton1Click:Connect(function()
    local char, hum, hrp = getCharacterParts()
    if originCFrame and hrp and hum then
        bypassCollision(char)
        
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        
        local count = 0
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if hrp and originCFrame then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = originCFrame
                count = count + 1
                if count > 8 then
                    connection:Disconnect()
                end
            end
        end)

        BackTeleBtn.Text = "Đã Về An Toàn!"
        BackTeleBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 80)
        task.delay(1, function()
            BackTeleBtn.Text = "🏠 3. Tele Về Chỗ Cũ"
            BackTeleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        end)
    else
        BackTeleBtn.Text = "Chưa Có Vị Trí Cũ!"
        task.delay(1, function()
            BackTeleBtn.Text = "🏠 3. Tele Về Chỗ Cũ"
        end)
    end
end)
