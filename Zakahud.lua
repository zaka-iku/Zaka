-- ZAKA MENU SIÊU ĐƠN GIẢN (Test hiện menu)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaSimpleMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Parent an toàn
local ok = pcall(function()
	ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ok then
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Nút mở menu
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 55, 0, 55)
OpenBtn.Position = UDim2.new(0, 20, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
OpenBtn.Text = "Z"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 24
OpenBtn.Parent = ScreenGui

local cornerBtn = Instance.new("UICorner")
cornerBtn.CornerRadius = UDim.new(1, 0)
cornerBtn.Parent = OpenBtn

-- Menu chính
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 0) -- bắt đầu cao = 0
Main.Position = UDim2.new(0.5, -160, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = ScreenGui

local cornerMain = Instance.new("UICorner")
cornerMain.CornerRadius = UDim.new(0, 16)
cornerMain.Parent = Main

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
Title.Text = "ZAKA HUD"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Main

local cornerTitle = Instance.new("UICorner")
cornerTitle.CornerRadius = UDim.new(0, 16)
cornerTitle.Parent = Title

-- Chữ bên trong
local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -20, 0, 100)
Info.Position = UDim2.new(0, 10, 0, 70)
Info.BackgroundTransparency = 1
Info.Text = "Menu đã hiện thành công!\n\nNếu bạn thấy dòng này thì ổn rồi."
Info.TextColor3 = Color3.fromRGB(200, 200, 200)
Info.Font = Enum.Font.Gotham
Info.TextSize = 15
Info.TextWrapped = true
Info.Parent = Main

-- Biến trạng thái
local isOpen = false

-- Hàm mở / đóng
local function Toggle()
	isOpen = not isOpen

	if isOpen then
		Main.Visible = true
		Main.Size = UDim2.new(0, 320, 0, 0)

		TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 320, 0, 380)
		}):Play()

		OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
		OpenBtn.Text = "X"
	else
		local tw = TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 320, 0, 0)
		})
		tw:Play()
		tw.Completed:Wait()
		Main.Visible = false

		OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
		OpenBtn.Text = "Z"
	end
end

OpenBtn.MouseButton1Click:Connect(Toggle)

-- Tự mở menu sau 1 giây để test
task.wait(1)
Toggle()

print("Zaka Simple Menu đã chạy!")
