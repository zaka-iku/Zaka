-- Khởi tạo dịch vụ CoreGui và TweenService
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Xóa menu cũ nếu đã tồn tại để tránh trùng lặp
if CoreGui:FindFirstChild("ZakaDragonMenu") then
    CoreGui.ZakaDragonMenu:Destroy()
end

-- Tạo ScreenGui chính
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaDragonMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- 1. Tạo Menu hình tròn chính (Nút Toggle Mở/Đóng)
local MainButton = Instance.new("TextButton")
MainButton.Name = "MainButton"
MainButton.Size = UDim2.new(0, 70, 0, 70)
MainButton.Position = UDim2.new(0.1, 0, 0.2, 0)
MainButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainButton.Text = "Zaka"
MainButton.TextColor3 = Color3.fromRGB(255, 100, 100)
MainButton.TextSize = 14
MainButton.Font = Enum.Font.GothamBold
MainButton.Parent = ScreenGui

-- Bo góc hình tròn tuyệt đối
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = MainButton

-- Viền phát sáng cho menu chính
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 50, 50)
UIStroke.Thickness = 2
UIStroke.Parent = MainButton

-- 2. Tạo hiệu ứng rồng uốn lượn quanh viền (Dùng các hạt sáng chuyển động theo quỹ đạo tròn)
local dragonParts = {}
local numParts = 8 -- Số lượng các đốt của rồng
local radius = 40  -- Bán kính quỹ đạo uốn quanh nút

for i = 1, numParts do
    local part = Instance.new("Frame")
    part.Size = UDim2.new(0, 8 - (i * 0.5), 0, 8 - (i * 0.5)) -- Tạo hiệu ứng đuôi nhỏ dần
    part.AnchorPoint = Vector2.new(0.5, 0.5)
    part.BackgroundColor3 = Color3.fromRGB(255, 200, 0) -- Màu vàng rồng lửa
    part.BorderSizePixel = 0
    part.Parent = MainButton
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = part
    
    table.insert(dragonParts, part)
end

-- 3. Tạo khung nội dung Menu (Bật/Tắt khi ấn vào nút chính)
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(0, 0, 0, 0) -- Ban đầu thu nhỏ bằng 0
ContentFrame.Position = UDim2.new(0, 85, 0, -35) -- Nằm cạnh menu chính
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
ContentFrame.BorderSizePixel = 0
ContentFrame.Visible = false
ContentFrame.Parent = MainButton

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = ContentFrame

local ContentStroke = Instance.new("UIStroke")
ContentStroke.Color = Color3.fromRGB(255, 100, 100)
ContentStroke.Thickness = 1.5
ContentStroke.Parent = ContentFrame

-- Tiêu đề bên trong Menu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "ZakaDragon Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Parent = ContentFrame

-- 4. Lập trình hiệu ứng rồng bay vòng tròn quanh nút
local angle = 0
local connection
connection = RunService.RenderStepped:Connect(function(dt)
    if not ScreenGui.Parent then
        connection:Disconnect()
        return
    end
    
    angle = angle + (dt * 3) -- Tốc độ uốn lượn của rồng
    
    for index, part in ipairs(dragonParts) do
        -- Tính toán vị trí x, y theo hình tròn dựa trên hàm Sin và Cos
        local currentAngle = angle - (index * 0.3)
        local x = 35 + math.cos(currentAngle) * radius
        local y = 35 + math.sin(currentAngle) * radius
        
        part.Position = UDim2.new(0, x, 0, y)
    end
end)

-- 5. Lập trình sự kiện Đóng / Mở Menu mượt mà
local isOpen = false

MainButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    
    if isOpen then
        ContentFrame.Visible = true
        -- Hiệu ứng mở rộng menu nội dung
        ContentFrame:TweenSize(UDim2.new(0, 200, 0, 150), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
        MainButton.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        -- Hiệu ứng thu nhỏ đóng menu nội dung
        local tween = TweenService:Create(ContentFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        })
        tween:Play()
        tween.Completed:Connect(function()
            if not isOpen then
                ContentFrame.Visible = false
            end
        end)
        MainButton.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- Cho phép kéo thả menu chính đi quanh màn hình bằng tay
local dragging, dragInput, dragStart, startPos

MainButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
