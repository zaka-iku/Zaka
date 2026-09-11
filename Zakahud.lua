--[[
    ZAKA HUD - UI Only (Bản đẹp + Tab đầy đủ)
    - Animation mượt
    - Có đầy đủ tab
    - Chưa có chức năng (chỉ UI)
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaHUD_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local ok = pcall(function()
	ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ok then
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Nút mở
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 52, 0, 52)
OpenBtn.Position = UDim2.new(0, 18, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
OpenBtn.Text = "Z"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 22
OpenBtn.AutoButtonColor = false
OpenBtn.Parent = ScreenGui

Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local btnStroke = Instance.new("UIStroke", OpenBtn)
btnStroke.Color = Color3.fromRGB(255, 255, 255)
btnStroke.Thickness = 1.5
btnStroke.Transparency = 0.6

-- Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 0, 0, 0)
Main.Position = UDim2.new(0.5, -180, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = false
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = Color3.fromRGB(55, 55, 60)
mainStroke.Thickness = 1.2

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA HUD"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Tab Bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -16, 0, 34)
TabBar.Position = UDim2.new(0, 8, 0, 58)
TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
TabBar.Parent = Main
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 10)

local Tabs = {"Combat", "ESP", "Player", "Teleport", "Troll", "Utility"}
local TabButtons = {}
local Pages = {}
local CurrentTab = 1

-- Page Holder
local PageHolder = Instance.new("Frame")
PageHolder.Size = UDim2.new(1, -16, 1, -110)
PageHolder.Position = UDim2.new(0, 8, 0, 100)
PageHolder.BackgroundTransparency = 1
PageHolder.ClipsDescendants = true
PageHolder.Parent = Main

-- Tạo Tab + Page
for i, name in ipairs(Tabs) do
	-- Nút Tab
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1 / #Tabs, -3, 1, -6)
	btn.Position = UDim2.new((i - 1) / #Tabs, 1.5, 0, 3)
	btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(45, 45, 50)
	btn.Text = name
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11
	btn.AutoButtonColor = false
	btn.Parent = TabBar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	TabButtons[i] = btn

	-- Page
	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.Position = UDim2.new(i - 1, 0, 0, 0)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = Color3.fromRGB(0, 122, 255)
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.BorderSizePixel = 0
	page.Parent = PageHolder

	local list = Instance.new("UIListLayout")
	list.Padding = UDim.new(0, 8)
	list.Parent = page

	list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 12)
	end)

	Pages[i] = page

	-- Placeholder content
	local placeholder = Instance.new("TextLabel")
	placeholder.Size = UDim2.new(1, 0, 0, 60)
	placeholder.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
	placeholder.Text = name .. " Tab\n(Chức năng sẽ thêm sau)"
	placeholder.TextColor3 = Color3.fromRGB(180, 180, 180)
	placeholder.Font = Enum.Font.Gotham
	placeholder.TextSize = 14
	placeholder.Parent = page
	Instance.new("UICorner", placeholder).CornerRadius = UDim.new(0, 10)

	-- Click Tab
	btn.MouseButton1Click:Connect(function()
		if CurrentTab == i then return end
		CurrentTab = i

		for idx, b in ipairs(TabButtons) do
			TweenService:Create(b, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
				BackgroundColor3 = (idx == i) and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(45, 45, 50)
			}):Play()
		end

		for idx, p in ipairs(Pages) do
			TweenService:Create(p, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Position = UDim2.new(idx - CurrentTab, 0, 0, 0)
			}):Play()
		end
	end)
end

-- Animation mở / đóng
local isOpen = false

local function ToggleMenu()
	isOpen = not isOpen

	if isOpen then
		Main.Visible = true
		Main.Size = UDim2.new(0, 0, 0, 0)

		TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 360, 0, 480)
		}):Play()

		TweenService:Create(OpenBtn, TweenInfo.new(0.25), {
			BackgroundColor3 = Color3.fromRGB(255, 60, 60),
			Text = "✕"
		}):Play()
	else
		local tw = TweenService:Create(Main, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0)
		})
		tw:Play()
		tw.Completed:Wait()
		Main.Visible = false

		TweenService:Create(OpenBtn, TweenInfo.new(0.25), {
			BackgroundColor3 = Color3.fromRGB(0, 122, 255),
			Text = "Z"
		}):Play()
	end
end

OpenBtn.MouseButton1Click:Connect(ToggleMenu)

-- Tự mở khi load
task.delay(0.7, function()
	if not isOpen then
		ToggleMenu()
	end
end)

print("Zaka HUD UI (Tab đầy đủ) đã sẵn sàng!")
