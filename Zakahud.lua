-- // ZAKA PINK PANTHER V11 - CLEAN UI (NO ASSETS) \\ --
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Xóa UI cũ nếu có
if PlayerGui:FindFirstChild("ZakaPinkPantherV11") then
	PlayerGui.ZakaPinkPantherV11:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaPinkPantherV11"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Main Frame (Kính mờ & Viền hồng neon)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 25)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.Size = UDim2.new(0, 550, 0, 350)

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 105, 180)
MainStroke.Transparency = 0.3
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Topbar (Thanh tiêu đề kéo thả)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(30, 20, 35)
TopBar.BackgroundTransparency = 0.5
TopBar.Size = UDim2.new(1, 0, 0, 40)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

-- Sửa lỗi tràn góc dưới TopBar
local TopCover = Instance.new("Frame")
TopCover.Name = "TopCover"
TopCover.Parent = TopBar
TopCover.BackgroundColor3 = Color3.fromRGB(30, 20, 35)
TopCover.BackgroundTransparency = 0.5
TopCover.BorderSizePixel = 0
TopCover.Position = UDim2.new(0, 0, 0.5, 0)
TopCover.Size = UDim2.new(1, 0, 0.5, 0)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "ZAKA PINK PANTHER V11"
Title.TextColor3 = Color3.fromRGB(255, 182, 193)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Nút đóng (Close)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 75, 100)
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.Position = UDim2.new(1, -35, 0.5, -12)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
	task.wait(0.2)
	ScreenGui:Destroy()
end)

-- Kéo thả Menu mượt mà (Draggable)
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

TopBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		TweenService:Create(MainFrame, TweenInfo.new(0.05), {
			Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		}):Play()
	end
end)

-- Sidebar (Danh sách Tab bên trái)
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Parent = MainFrame
Sidebar.Active = true
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 18, 30)
Sidebar.BackgroundTransparency = 0.4
Sidebar.BorderSizePixel = 0
Sidebar.Position = UDim2.new(0, 10, 0, 50)
Sidebar.Size = UDim2.new(0, 140, 1, -60)
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 360)
Sidebar.ScrollBarThickness = 3

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 8)
SidebarCorner.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 6)

-- Container chứa nội dung các Tab bên phải
local Container = Instance.new("Folder")
Container.Name = "Container"
Container.Parent = MainFrame

-- Khởi tạo hệ thống Tab
local Tabs = {}
local FirstTab = true

local function CreateTab(name, order)
	-- Nút Tab trên Sidebar
	local TabBtn = Instance.new("TextButton")
	TabBtn.Parent = Sidebar
	TabBtn.BackgroundColor3 = Color3.fromRGB(40, 25, 45)
	TabBtn.BackgroundTransparency = 0.6
	TabBtn.Size = UDim2.new(0, 125, 0, 35)
	TabBtn.Font = Enum.Font.GothamMedium
	TabBtn.Text = name
	TabBtn.TextColor3 = Color3.fromRGB(200, 180, 210)
	TabBtn.TextSize = 13
	TabBtn.LayoutOrder = order

	local TabCorner = Instance.new("UICorner")
	TabCorner.CornerRadius = UDim.new(0, 6)
	TabCorner.Parent = TabBtn

	-- Trang nội dung tương ứng
	local TabContent = Instance.new("ScrollingFrame")
	TabContent.Name = name .. "Content"
	TabContent.Parent = MainFrame
	TabContent.Active = true
	TabContent.BackgroundColor3 = Color3.fromRGB(20, 15, 25)
	TabContent.BackgroundTransparency = 1
	TabContent.BorderSizePixel = 0
	TabContent.Position = UDim2.new(0, 160, 0, 50)
	TabContent.Size = UDim2.new(1, -170, 1, -60)
	TabContent.CanvasSize = UDim2.new(0, 0, 0, 500)
	TabContent.ScrollBarThickness = 4
	TabContent.Visible = false

	local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Parent = TabContent
    ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8)

	if FirstTab then
		TabContent.Visible = true
		TabBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
		TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		FirstTab = false
	end

	TabBtn.MouseButton1Click:Connect(function()
		for _, v in pairs(Container:GetChildren()) do end -- placeholder
		for _, child in pairs(MainFrame:GetChildren()) do
			if child:IsA("ScrollingFrame") and child.Name ~= "Sidebar" then
				child.Visible = false
			end
		end
		for _, btn in pairs(Sidebar:GetChildren()) do
			if btn:IsA("TextButton") then
				TweenService:Create(btn, TweenInfo.new(0.2), {
					BackgroundColor3 = Color3.fromRGB(40, 25, 45),
					TextColor3 = Color3.fromRGB(200, 180, 210)
				}):Play()
			end
		end
		
		TabContent.Visible = true
		TweenService:Create(TabBtn, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(255, 105, 180),
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()
	end)

	return TabContent
end

-- Tạo sẵn 8 Tabs mẫu theo đúng ý bản V11
local Tab1 = CreateTab("Trang Chủ", 1)
local Tab2 = CreateTab("Nhân Vật", 2)
local Tab3 = CreateTab("Script Hub", 3)
local Tab4 = CreateTab("ESP / Visual", 4)
local Tab5 = CreateTab("Teleport", 5)
local Tab6 = CreateTab("Cửa Hàng", 6)
local Tab7 = CreateTab("Cài Đặt", 7)
local Tab8 = CreateTab("Thông Tin", 8)

-- Ví dụ hàm tạo Toggle mẫu mượt mà bên trong Tab 1
local function AddToggle(parent, title, callback)
	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Parent = parent
	ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 25, 40)
	ToggleBtn.BackgroundTransparency = 0.4
	ToggleBtn.Size = UDim2.new(0, 365, 0, 40)
	ToggleBtn.Font = Enum.Font.GothamMedium
	ToggleBtn.Text = "   " .. title
	ToggleBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
	ToggleBtn.TextSize = 13
	ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = ToggleBtn

	local StatusIndicator = Instance.new("Frame")
	StatusIndicator.Parent = ToggleBtn
	StatusIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	StatusIndicator.Position = UDim2.new(1, -35, 0.5, -10)
	StatusIndicator.Size = UDim2.new(0, 25, 0, 20)
	
	local StatusCorner = Instance.new("UICorner")
	StatusCorner.CornerRadius = UDim.new(1, 0)
	StatusCorner.Parent = StatusIndicator

	local toggled = false
	ToggleBtn.MouseButton1Click:Connect(function()
		toggled = not toggled
		local targetColor = toggled and Color3.fromRGB(255, 105, 180) or Color3.fromRGB(100, 100, 100)
		TweenService:Create(StatusIndicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
		pcall(callback, toggled)
	end)
end

-- Thêm vài tính năng mẫu vào Tab 1
AddToggle(Tab1, "Bật tính năng Bay (Fly)", function(v) print("Fly:", v) end)
AddToggle(Tab1, "Tăng tốc độ chạy (WalkSpeed)", function(v) print("Speed:", v) end)
AddToggle(Tab1, "Nhảy cao (JumpPower)", function(v) print("Jump:", v) end)

print("ZAKA PINK PANTHER V11 Loaded Successfully!")
