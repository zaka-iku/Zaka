--==============================================================================--
--             ZAKA BLOX // GOD-TIER MAIN HUB (FREE VERSION)                    --
--==============================================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Dọn dẹp UI cũ nếu có
if PlayerGui:FindFirstChild("ZakaBloxMain") then
    PlayerGui.ZakaBloxMain:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaBloxMain"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Khung chính
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 140, 0)
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

-- Hiệu ứng mở menu
TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 560, 0, 360),
    Position = UDim2.new(0.5, -280, 0.5, -180)
}):Play()

-- Topbar (Thanh tiêu đề kéo thả)
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
TitleLabel.Size = UDim2.new(0, 300, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "⚔️ ZAKA BLOX // FREE HUB v1.0"
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
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Nút Đóng (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
CloseBtn.BorderSizePixel = 0
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextSize = 12
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.3)
    ScreenGui:Destroy()
end)

-- Sidebar Chuyển Tab
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 135, 1, -45)
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
    TabBtn.Size = UDim2.new(0, 120, 0, 34)
    TabBtn.BackgroundColor3 = Color3.fromRGB(18, 23, 33)
    TabBtn.BorderSizePixel = 0
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(150, 160, 180)
    TabBtn.TextSize = 12
    TabBtn.LayoutOrder = order
    TabBtn.Parent = Sidebar
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1, -150, 1, -55)
    TabContent.Position = UDim2.new(0, 145, 0, 48)
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

-- Hàm tạo Toggle tính năng
local function AddToggle(tab, text, callback)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, -10, 0, 36)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 26, 38)
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Font = Enum.Font.GothamMedium
    ToggleBtn.Text = "  " + text -- (Lua dùng dấu ..)
    ToggleBtn.Text = "  " .. text
    ToggleBtn.TextColor3 = Color3.fromRGB(210, 220, 235)
    ToggleBtn.TextSize = 11
    ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
    ToggleBtn.Parent = tab
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

    local StatusIndicator = Instance.new("Frame")
    StatusIndicator.Size = UDim2.new(0, 16, 0, 16)
    StatusIndicator.Position = UDim2.new(1, -26, 0.5, -8)
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
    StatusIndicator.BorderSizePixel = 0
    StatusIndicator.Parent = ToggleBtn
    Instance.new("UICorner", StatusIndicator).CornerRadius = UDim.new(0, 4)

    local toggled = false
    ToggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        TweenService:Create(StatusIndicator, TweenInfo.new(0.15), {
            BackgroundColor3 = toggled and Color3.fromRGB(0, 230, 110) or Color3.fromRGB(40, 50, 70)
        }):Play()
        callback(toggled)
    end)
end

--==============================================================================--
--                         KHỞI TẠO CÁC TAB CHỨC NĂNG                           --
--==============================================================================--

local TabFarm = CreateTab("Auto Farm", 1)
local TabStats = CreateTab("Stats", 2)
local TabTeleport = CreateTab("Teleport", 3)
local TabVisuals = CreateTab("Visuals", 4)
local TabMisc = CreateTab("Misc", 5)

-- Thêm mẫu một vài toggle test (Sau này sẽ thay bằng code chức năng thật)
AddToggle(TabFarm, "Auto Farm Level (Cơ Bản)", function(v)
    print("Auto Farm Level:", v)
end)
AddToggle(TabFarm, "Auto Quest / Accept Quest", function(v)
    print("Auto Quest:", v)
end)

AddToggle(TabStats, "Auto Upgrade Melee", function(v)
    print("Auto Upgrade Melee:", v)
end)
AddToggle(TabStats, "Auto Upgrade Defense", function(v)
    print("Auto Upgrade Defense:", v)
end)

AddToggle(TabVisuals, "ESP Chest (Tìm Rương)", function(v)
    print("ESP Chest:", v)
end)
AddToggle(TabVisuals, "ESP Fruit (Tìm Trái Ác Quỷ)", function(v)
    print("ESP Fruit:", v)
end)

print("⚔️ Zaka Blox Free Hub đã tải thành công toàn bộ giao diện!")
