--[[
    ZAKA HUB - MINIMALIST ONE UI EDITION
    Tối ưu gọn nhẹ & Tích hợp Nút tròn Toggle di động
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. Tạo GUI Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaHub_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 2. Nút Tròn Mở/Tắt Nhanh (One UI Toggle Icon)
local ToggleIcon = Instance.new("TextButton")
ToggleIcon.Name = "ZakaToggleIcon"
ToggleIcon.Size = UDim2.new(0, 45, 0, 45)
ToggleIcon.Position = UDim2.new(0, 15, 0.4, 0)
ToggleIcon.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
ToggleIcon.Text = "Z"
ToggleIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleIcon.Font = Enum.Font.GothamBold
ToggleIcon.TextSize = 20
ToggleIcon.Active = true
ToggleIcon.Draggable = true -- Cho phép kéo thả nút tròn
ToggleIcon.Parent = ScreenGui

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0) -- Bo tròn hoàn toàn
IconCorner.Parent = ToggleIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(255, 255, 255)
IconStroke.Thickness = 2
IconStroke.Transparency = 0.5
IconStroke.Parent = ToggleIcon

-- 3. Main Frame (Bảng Menu Tối Giản)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 260) -- Kích thước gọn gàng 300x260
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 38)
Header.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "<b>ZAKA</b> <font color=\"#00A2FF\">HUB</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.Gotham
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
MinimizeBtn.Position = UDim2.new(1, -32, 0.5, -13)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16
MinimizeBtn.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

-- 4. Scrolling Container
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -16, 1, -48)
Container.Position = UDim2.new(0, 8, 0, 42)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 3
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 162, 255)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)

UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Container.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 8)
end)

-- 5. Hàm Tạo Nút Chức Năng (Compact Size)
local function AddButton(text, callback)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, -6, 0, 32)
	Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
	Btn.Text = text
	Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
	Btn.Font = Enum.Font.GothamMedium
	Btn.TextSize = 12
	Btn.Parent = Container

	local BtnCorner = Instance.new("UICorner")
	BtnCorner.CornerRadius = UDim.new(0, 6)
	BtnCorner.Parent = Btn

	Btn.MouseButton1Click:Connect(function()
		pcall(callback)
	end)
end

-- =======================================================
-- ĐÓNG / MỞ MENU LOGIC (ONE UI TOGGLE)
-- =======================================================

local isOpen = true
local function ToggleMenu()
	isOpen = not isOpen
	MainFrame.Visible = isOpen
end

ToggleIcon.MouseButton1Click:Connect(ToggleMenu)
MinimizeBtn.MouseButton1Click:Connect(ToggleMenu)

-- Phím tắt Control trên máy tính
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
		ToggleMenu()
	end
end)

-- =======================================================
-- CHỨC NĂNG CỦA ZAKA HUB
-- =======================================================

AddButton("Tăng Tốc (Speed x2)", function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = 32
	end
end)

AddButton("Nhảy Cao (Jump x2)", function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.JumpPower = 100
	end
end)

AddButton("Reset Tốc Độ / Nhảy", function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = 16
		LocalPlayer.Character.Humanoid.JumpPower = 50
	end
end)
