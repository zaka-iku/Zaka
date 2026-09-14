--==============================================================================--
--                     ZAKA BLOX // HUB LAUNCHER v1.0                           --
--==============================================================================--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Xóa menu cũ nếu đang mở để tránh trùng lặp
if PlayerGui:FindFirstChild("ZakaBloxMenu") then
    PlayerGui.ZakaBloxMenu:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaBloxMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Main Container (Hiệu ứng scale từ 0 lên 1 cực mượt giống Launcher)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 140, 0) -- Tông màu cam đặc trưng Blox Fruit
MainStroke.Transparency = 0.2
MainStroke.Parent = MainFrame

-- Animation mở Menu (Smooth Pop-up)
TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 440, 0, 300),
    Position = UDim2.new(0.5, -220, 0.5, -150)
}):Play()

-- Tiêu đề Menu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "⚔️ ZAKA BLOX // MAIN HUB"
Title.TextColor3 = Color3.fromRGB(255, 160, 0)
Title.TextSize = 15
Title.Parent = MainFrame

-- Container chứa các nút chức năng chờ sẵn
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -30, 1, -120)
Container.Position = UDim2.new(0, 15, 0, 55)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = Container

-- Thông báo trạng thái đang phát triển chức năng
local NoticeLabel = Instance.new("TextLabel")
NoticeLabel.Size = UDim2.new(1, 0, 0, 100)
NoticeLabel.BackgroundTransparency = 1
NoticeLabel.Font = Enum.Font.GothamMedium
NoticeLabel.Text = "⚡ Giao diện 'Zaka Blox' đã khởi tạo thành công!\nCác tính năng cày cuốc sẽ được tích hợp vào đây sau."
NoticeLabel.TextColor3 = Color3.fromRGB(160, 175, 200)
NoticeLabel.TextSize = 12
NoticeLabel.TextWrapped = true
NoticeLabel.Parent = Container

-- Nút Đóng Menu (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 410, 0, 36)
CloseBtn.Position = UDim2.new(0.5, -205, 1, -45)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
CloseBtn.BorderSizePixel = 0
CloseBtn.Font = Enum.Font.GothamMedium
CloseBtn.Text = "Đóng Menu"
CloseBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
CloseBtn.TextSize = 12
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.3)
    ScreenGui:Destroy()
end)

print("⚔️ Zaka Blox Hub đã khởi chạy animation mượt mà!")
