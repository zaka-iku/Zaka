local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local savedCFrame = nil
local isSpeedEnabled = false
local speedMultiplier = 25 -- Tốc độ di chuyển an toàn (Mặc định game là 16)

local getHui = gethui or function() return game:GetService("CoreGui") end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EggGameTeleSpeed"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = getHui()

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 210, 0, 230)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "Steal An Egg - Fix Tele"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.Parent = MainFrame

local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(0.85, 0, 0, 38)
SpeedBtn.Position = UDim2.new(0.07, 0, 0.25, 0)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBtn.Text = "Chạy Nhanh: Tắt"
SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBtn.Font = Enum.Font.GothamMedium
SpeedBtn.Parent = MainFrame

local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(0.85, 0, 0, 38)
SaveBtn.Position = UDim2.new(0.07, 0, 0.47, 0)
SaveBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SaveBtn.Text = "Lưu Vị Trí"
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.Font = Enum.Font.GothamMedium
SaveBtn.Parent = MainFrame

local TeleBtn = Instance.new("TextButton")
TeleBtn.Size = UDim2.new(0.85, 0, 0, 38)
TeleBtn.Position = UDim2.new(0.07, 0, 0.69, 0)
TeleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TeleBtn.Text = "Tele Mượt (Tween)"
TeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleBtn.Font = Enum.Font.GothamMedium
TeleBtn.Parent = MainFrame

local function getParts()
    local char = player.Character
    if not char then return nil, nil, nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    return char, hum, hrp
end

-- Chạy nhanh theo phương thức CFrame Lerp mượt
RunService.RenderStepped:Connect(function()
    if isSpeedEnabled then
        local _, hum, hrp = getParts()
        if hum and hrp and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (speedMultiplier / 60))
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
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

SaveBtn.MouseButton1Click:Connect(function()
    local _, _, hrp = getParts()
    if hrp then
        savedCFrame = hrp.CFrame
        SaveBtn.Text = "Đã Lưu Vị Trí!"
        SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 110, 200)
        task.delay(1, function()
            SaveBtn.Text = "Lưu Vị Trí"
            SaveBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)
    end
end)

-- Teleport bằng Tween để qua mặt Anti-Cheat của game
TeleBtn.MouseButton1Click:Connect(function()
    local char, hum, hrp = getParts()
    if savedCFrame and hrp then
        TeleBtn.Text = "Đang Teleport..."
        TeleBtn.BackgroundColor3 = Color3.fromRGB(180, 100, 0)
        
        -- Tính khoảng cách để điều chỉnh thời gian bay phù hợp
        local distance = (hrp.Position - savedCFrame.Position).Magnitude
        local duration = math.clamp(distance / 120, 0.2, 1.5) -- Tốc độ bay cực nhanh nhưng mượt
        
        -- Tạm thời tắt va chạm và vật lý để tránh bị giật lại
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = savedCFrame})
        
        tween:Play()
        tween.Completed:Connect(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            TeleBtn.Text = "Đã Teleport!"
            task.delay(1, function()
                TeleBtn.Text = "Tele Mượt (Tween)"
                TeleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end)
        end)
    else
        TeleBtn.Text = "Chưa có vị trí!"
        TeleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        task.delay(1, function()
            TeleBtn.Text = "Tele Mượt (Tween)"
            TeleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)
    end
end)
