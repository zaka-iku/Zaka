local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZenitsuEmptyMenu"
ScreenGui.ResetOnSpawn = false

local success = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not success or not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Nút Z
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 15, 0.35, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 40)
OpenBtn.Text = "Z"
OpenBtn.TextColor3 = Color3.fromRGB(30, 20, 0)
OpenBtn.TextSize = 22
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

-- Khung menu trống
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 280, 0, 200)
Main.Position = UDim2.new(0, 80, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 16, 10)
Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 35, 12)
Title.Text = "ZENITSU MENU (Trống)"
Title.TextColor3 = Color3.fromRGB(255, 220, 60)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Parent = Main
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -20, 0, 60)
Info.Position = UDim2.new(0, 10, 0, 60)
Info.BackgroundTransparency = 1
Info.Text = "Menu đã hiện thành công.\nBáo mình để thêm kỹ năng."
Info.TextColor3 = Color3.fromRGB(230, 220, 180)
Info.TextSize = 13
Info.Font = Enum.Font.Gotham
Info.TextWrapped = true
Info.Parent = Main

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

print("Zenitsu Empty Menu Loaded")
