--==============================================================================--
--        ZAKA BLOX // EXPERIMENTAL MOBILE HUB v2.5                             --
--==============================================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Chống Idle Disconnect
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

-- Dọn dẹp UI cũ
if PlayerGui:FindFirstChild("ZakaBloxMain") then
    PlayerGui.ZakaBloxMain:Destroy()
end
if PlayerGui:FindFirstChild("ZakaFloatingIcon") then
    PlayerGui.ZakaFloatingIcon:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaBloxMain"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Khung chính
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 580, 0, 380)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 140, 0)
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

-- Nút mở lại dạng Icon nổi (Floating Toggle Button) trên màn hình
local FloatGui = Instance.new("ScreenGui")
FloatGui.Name = "ZakaFloatingIcon"
FloatGui.ResetOnSpawn = false
FloatGui.Parent = PlayerGui

local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "OpenButton"
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 20, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(22, 28, 40)
ToggleBtn.Image = "rbxassetid://6031075931" -- Icon menu/gear mặc định của Roblox
ToggleBtn.ImageColor3 = Color3.fromRGB(255, 140, 0)
ToggleBtn.Visible = false
ToggleBtn.Parent = FloatGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 10)
local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 140, 0)
ToggleStroke.Transparency = 0.2
ToggleStroke.Parent = ToggleBtn

-- Topbar kéo thả
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 28, 40)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local FixBar = Instance.new("Frame")
FixBar.Size = UDim2.new(1, 0, 0, 10)
FixBar.Position = UDim2.new(0, 0, 1, -10)
FixBar.BackgroundColor3 = Color3.fromRGB(22, 28, 40)
FixBar.BorderSizePixel = 0
FixBar.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 350, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "⚔️ ZAKA BLOX // EXPERIMENTAL v2.5"
TitleLabel.TextColor3 = Color3.fromRGB(255, 160, 0)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Kéo thả menu
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
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
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Nút Thu Gọn Menu (Minimize thay vì xóa hẳn)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 20)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
MinimizeBtn.TextSize = 14
MinimizeBtn.Parent = TopBar
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleBtn.Visible = true
end)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ToggleBtn.Visible = false
end)

-- Sidebar Tab
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 140, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 13, 19)
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 2
Sidebar.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = Sidebar
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 8)
UIPadding.Parent = Sidebar

local ContentContainer = Instance.new("Folder")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame

local Tabs = {}
local CurrentTab = nil

local function CreateTab(name, order)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0, 126, 0, 34)
    TabBtn.BackgroundColor3 = Color3.fromRGB(18, 23, 33)
    TabBtn.BorderSizePixel = 0
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(150, 160, 180)
    TabBtn.TextSize = 11
    TabBtn.LayoutOrder = order
    TabBtn.Parent = Sidebar
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1, -155, 1, -55)
    TabContent.Position = UDim2.new(0, 150, 0, 48)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 3
    TabContent.Visible = false
    TabContent.Parent = ContentContainer

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.Parent = TabContent

    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 2)
    ContentPadding.Parent = TabContent

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Btn.BackgroundColor3 = Color3.fromRGB(18, 23, 33)
            t.Btn.TextColor3 = Color3.fromRGB(150, 160, 180)
            t.Content.Visible = false
        end
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabContent.Visible = true
        CurrentTab = TabContent
    end)

    if not CurrentTab then
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabContent.Visible = true
        CurrentTab = TabContent
    end

    table.insert(Tabs, {Btn = TabBtn, Content = TabContent})
    return TabContent
end

-- Hàm tạo Toggle
local function AddToggle(tab, text, callback)
    local ToggleBtnUI = Instance.new("TextButton")
    ToggleBtnUI.Size = UDim2.new(1, -10, 0, 36)
    ToggleBtnUI.BackgroundColor3 = Color3.fromRGB(20, 26, 38)
    ToggleBtnUI.BorderSizePixel = 0
    ToggleBtnUI.AutoButtonColor = false
    ToggleBtnUI.Font = Enum.Font.GothamMedium
    ToggleBtnUI.Text = "  " .. text
    ToggleBtnUI.TextColor3 = Color3.fromRGB(210, 220, 235)
    ToggleBtnUI.TextSize = 11
    ToggleBtnUI.TextXAlignment = Enum.TextXAlignment.Left
    ToggleBtnUI.Parent = tab
    Instance.new("UICorner", ToggleBtnUI).CornerRadius = UDim.new(0, 6)

    local StatusIndicator = Instance.new("Frame")
    StatusIndicator.Size = UDim2.new(0, 16, 0, 16)
    StatusIndicator.Position = UDim2.new(1, -26, 0.5, -8)
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
    StatusIndicator.BorderSizePixel = 0
    StatusIndicator.Parent = ToggleBtnUI
    Instance.new("UICorner", StatusIndicator).CornerRadius = UDim.new(0, 4)

    local toggled = false
    ToggleBtnUI.MouseButton1Click:Connect(function()
        toggled = not toggled
        TweenService:Create(StatusIndicator, TweenInfo.new(0.15), {
            BackgroundColor3 = toggled and Color3.fromRGB(0, 230, 110) or Color3.fromRGB(40, 50, 70)
        }):Play()
        callback(toggled)
    end)
end

-- Khởi tạo các Tab cơ bản
local TabFarm = CreateTab("Auto Farm", 1)
local TabMisc = CreateTab("Tiện Ích", 2)

AddToggle(TabFarm, "Test Tính Năng Auto Farm", function(v)
    print("Trạng thái Auto Farm:", v)
end)

AddToggle(TabMisc, "WalkSpeed Tốc Độ Cao", function(v)
    pcall(function()
        LocalPlayer.Character.Humanoid.WalkSpeed = v and 100 or 16
    end)
end)

print("⚔️ Zaka Blox Experimental v2.5 đã tải thành công!")
