-- ZakaDoorHub - Tối ưu Delta Mobile

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Xóa menu cũ
pcall(function()
    if PlayerGui:FindFirstChild("ZakaHub") then
        PlayerGui.ZakaHub:Destroy()
    end
end)

-- Tạo ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "ZakaHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = PlayerGui

-- Nút Z (luôn hiện)
local zBtn = Instance.new("TextButton")
zBtn.Name = "ZBtn"
zBtn.Size = UDim2.new(0, 65, 0, 65)
zBtn.Position = UDim2.new(1, -80, 0.35, 0)
zBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
zBtn.Text = "Z"
zBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
zBtn.TextSize = 28
zBtn.Font = Enum.Font.GothamBlack
zBtn.Parent = gui

local c1 = Instance.new("UICorner")
c1.CornerRadius = UDim.new(0, 14)
c1.Parent = zBtn

-- Menu chính
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 260, 0, 340)
main.Position = UDim2.new(0.5, -130, 0.5, -170)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
main.BorderSizePixel = 0
main.Visible = true
main.Parent = gui

local c2 = Instance.new("UICorner")
c2.CornerRadius = UDim.new(0, 12)
c2.Parent = main

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "ZakaDoorHub"
title.TextColor3 = Color3.fromRGB(255, 70, 70)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = main

-- Thông báo
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -16, 0, 50)
info.Position = UDim2.new(0, 8, 0, 40)
info.BackgroundTransparency = 1
info.Text = "Menu đã hiện trên Delta Mobile!\nBấm nút bên dưới để test"
info.TextColor3 = Color3.fromRGB(220, 220, 220)
info.TextSize = 13
info.Font = Enum.Font.Gotham
info.TextWrapped = true
info.Parent = main

-- Nút Test
local testBtn = Instance.new("TextButton")
testBtn.Size = UDim2.new(0, 200, 0, 40)
testBtn.Position = UDim2.new(0.5, -100, 0, 110)
testBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 70)
testBtn.Text = "Test - Bấm vào đây"
testBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
testBtn.TextSize = 15
testBtn.Font = Enum.Font.GothamBold
testBtn.Parent = main

local c3 = Instance.new("UICorner")
c3.CornerRadius = UDim.new(0, 8)
c3.Parent = testBtn

testBtn.MouseButton1Click:Connect(function()
    testBtn.Text = "Hoạt động OK!"
    testBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
end)

-- Nút Fullbright
local fbBtn = Instance.new("TextButton")
fbBtn.Size = UDim2.new(0, 200, 0, 40)
fbBtn.Position = UDim2.new(0.5, -100, 0, 165)
fbBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
fbBtn.Text = "Fullbright: OFF"
fbBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fbBtn.TextSize = 14
fbBtn.Font = Enum.Font.GothamBold
fbBtn.Parent = main

local c4 = Instance.new("UICorner")
c4.CornerRadius = UDim.new(0, 8)
c4.Parent = fbBtn

local fbOn = false
fbBtn.MouseButton1Click:Connect(function()
    fbOn = not fbOn
    local Lighting = game:GetService("Lighting")
    if fbOn then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 9e9
        Lighting.GlobalShadows = false
        fbBtn.Text = "Fullbright: ON"
        fbBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 70)
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 0
        Lighting.FogEnd = 1000
        Lighting.GlobalShadows = true
        fbBtn.Text = "Fullbright: OFF"
        fbBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
end)

-- Nút Speed
local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0, 200, 0, 40)
speedBtn.Position = UDim2.new(0.5, -100, 0, 220)
speedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedBtn.Text = "Speed: OFF"
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBtn.TextSize = 14
speedBtn.Font = Enum.Font.GothamBold
speedBtn.Parent = main

local c5 = Instance.new("UICorner")
c5.CornerRadius = UDim.new(0, 8)
c5.Parent = speedBtn

local speedOn = false
speedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    speedBtn.Text = speedOn and "Speed: ON" or "Speed: OFF"
    speedBtn.BackgroundColor3 = speedOn and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(60, 60, 80)
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if speedOn and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 22
        end
    end
end)

-- Nút đóng
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 200, 0, 35)
closeBtn.Position = UDim2.new(0.5, -100, 0, 280)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
closeBtn.Text = "Đóng Menu"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = main

local c6 = Instance.new("UICorner")
c6.CornerRadius = UDim.new(0, 8)
c6.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
end)

-- Bấm Z để mở/đóng
zBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

print("ZakaHub Delta Mobile đã load!")
