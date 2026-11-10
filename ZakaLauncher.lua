local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local savedCFrame = nil
local isSpeedOn = false
local speedValue = 35 -- Tốc độ an toàn tối đa để server không rollback

local getHui = gethui or function() return game:GetService("CoreGui") end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CleanEggGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = getHui()

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 190)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "Menu Chạy & Tele Tối Ưu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.Parent = MainFrame

local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(0.85, 0, 0, 35)
SaveBtn.Position = UDim2.new(0.075, 0, 0.25, 0)
SaveBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SaveBtn.Text = "Lưu Vị Trí"
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.Font = Enum.Font.GothamMedium
SaveBtn.Parent = MainFrame

local TeleBtn = Instance.new("TextButton")
TeleBtn.Size = UDim2.new(0.85, 0, 0, 35)
TeleBtn.Position = UDim2.new(0.075, 0, 0.48, 0)
TeleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TeleBtn.Text = "Tele Về Vị Trí Lưu"
TeleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleBtn.Font = Enum.Font.GothamMedium
TeleBtn.Parent = MainFrame

local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(0.85, 0, 0, 35)
SpeedBtn.Position = UDim2.new(0.075, 0, 0.71, 0)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBtn.Text = "Tốc Độ Vừa Phải: Tắt"
SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBtn.Font = Enum.Font.GothamMedium
SpeedBtn.Parent = MainFrame

local function getHRP()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- Tăng tốc mượt trong giới hạn cho phép
RunService.Heartbeat:Connect(function()
    if isSpeedOn then
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = getHRP()
        if hum and hrp and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (speedValue / 60))
        end
    end
end)

SpeedBtn.MouseButton1Click:Connect(function()
    isSpeedOn = not isSpeedOn
    if isSpeedOn then
        SpeedBtn.Text = "Tốc Độ Vừa Phải: BẬT"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 70)
    else
        SpeedBtn.Text = "Tốc Độ Vừa Phải: Tắt"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

SaveBtn.MouseButton1Click:Connect(function()
    local hrp = getHRP()
    if hrp then
        savedCFrame = hrp.CFrame + Vector3.new(0, 1.5, 0)
        SaveBtn.Text = "Đã Lưu!"
        SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        task.delay(0.8, function()
            SaveBtn.Text = "Lưu Vị Trí"
            SaveBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)
    end
end)

TeleBtn.MouseButton1Click:Connect(function()
    local hrp = getHRP()
    if savedCFrame and hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.CFrame = savedCFrame
        TeleBtn.Text = "Đã Tele!"
        TeleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        task.delay(0.8, function()
            TeleBtn.Text = "Tele Về Vị Trí Lưu"
            TeleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)
    end
end)
