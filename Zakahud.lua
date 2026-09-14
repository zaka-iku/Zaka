--[[
    ZAKA PURE UI - Vertical Smart Tabs
    Tab dọc + Animation phóng to/thu nhỏ thông minh
    Trong suốt + Bo góc đẹp
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Xóa bản cũ
pcall(function()
    if PlayerGui:FindFirstChild("ZakaPureUI") then
        PlayerGui.ZakaPureUI:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaPureUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

-- ========== NÚT TOGGLE ==========
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "Toggle"
ToggleBtn.Size = UDim2.new(0, 58, 0, 58)
ToggleBtn.Position = UDim2.new(0, 16, 0.38, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.BackgroundTransparency = 0.15
ToggleBtn.Text = "Z"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 26
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = ScreenGui

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Transparency = 0.3
ToggleStroke.Parent = ToggleBtn

-- ========== MAIN FRAME (TRONG SUỐT) ==========
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 380, 0, 440)
Main.Position = UDim2.new(0.5, -190, 0.5, -220)
Main.BackgroundColor3 = Color3.fromRGB(20, 24, 35)
Main.BackgroundTransparency = 0.35          -- trong suốt
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 180, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.5
MainStroke.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = Color3.fromRGB(15, 18, 28)
Header.BackgroundTransparency = 0.4
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA UI"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.TextColor3 = Color3.fromRGB(240, 245, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.BackgroundTransparency = 0.4
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

-- ========== TAB DỌC (SMART) ==========
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 92, 1, -60)
TabContainer.Position = UDim2.new(0, 10, 0, 54)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Main

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 8)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabContainer

-- Content bên phải
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -118, 1, -66)
Content.Position = UDim2.new(0, 108, 0, 56)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true
Content.Parent = Main

-- ======================== DỮ LIỆU TAB ========================
local TabsData = {
    {Name = "Home",   Icon = "⌂"},
    {Name = "Visual", Icon = "✦"},
    {Name = "Player", Icon = "◉"},
    {Name = "World",  Icon = "◈"},
    {Name = "Config", Icon = "⚙"},
}

local TabButtons = {}
local Pages = {}
local CurrentTab = 1

-- Hàm tạo card nội dung (có animation sẵn)
local function CreateSmartCard(parent, text, delay)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)          -- bắt đầu cao = 0
    card.BackgroundColor3 = Color3.fromRGB(30, 36, 52)
    card.BackgroundTransparency = 0.45
    card.ClipsDescendants = true
    card.Parent = parent

    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -16, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(235, 240, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTransparency = 1
    label.Parent = card

    -- Animation xuất hiện
    task.delay(delay, function()
        TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0, 46)
        }):Play()
        TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    end)

    return card
end

-- Tạo từng tab
for i, data in ipairs(TabsData) do
    local btn = Instance.new("TextButton")
    btn.Name = data.Name
    btn.Size = UDim2.new(1, 0, 0, 38)          -- kích thước nhỏ mặc định
    btn.BackgroundColor3 = Color3.fromRGB(35, 42, 60)
    btn.BackgroundTransparency = 0.5
    btn.Text = data.Icon .. "  " .. data.Name
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(180, 190, 210)
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    btn.Parent = TabContainer

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Thickness = 1.2
    stroke.Transparency = 1
    stroke.Parent = btn

    -- Page
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Parent = Content

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.Parent = page
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 12)
    end)

    -- Tạo vài card demo
    for j = 1, 6 do
        CreateSmartCard(page, data.Name .. "  •  Feature " .. j, 0.05 * j)
    end

    TabButtons[i] = {Button = btn, Stroke = stroke}
    Pages[i] = page
end

-- ======================== ANIMATION TAB THÔNG MINH ========================
local function SwitchTab(index)
    if CurrentTab == index then return end

    local old = TabButtons[CurrentTab]
    local new = TabButtons[index]

    -- Thu nhỏ tab cũ
    TweenService:Create(old.Button, TweenInfo.new(0.32, Enum.EasingStyle.Quint), {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundTransparency = 0.5,
        TextColor3 = Color3.fromRGB(180, 190, 210)
    }):Play()
    TweenService:Create(old.Stroke, TweenInfo.new(0.25), {Transparency = 1}):Play()

    -- Phóng to tab mới
    TweenService:Create(new.Button, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 0, 52),          -- to hơn
        BackgroundTransparency = 0.25,
        TextColor3 = Color3.new(1, 1, 1)
    }):Play()
    TweenService:Create(new.Stroke, TweenInfo.new(0.3), {Transparency = 0.35}):Play()

    -- Chuyển page
    Pages[CurrentTab].Visible = false
    Pages[index].Visible = true
    CurrentTab = index
end

-- Gán sự kiện click
for i, data in ipairs(TabButtons) do
    data.Button.MouseButton1Click:Connect(function()
        SwitchTab(i)
    end)
end

-- Mặc định tab đầu
TabButtons[1].Button.Size = UDim2.new(1, 0, 0, 52)
TabButtons[1].Button.BackgroundTransparency = 0.25
TabButtons[1].Button.TextColor3 = Color3.new(1, 1, 1)
TabButtons[1].Stroke.Transparency = 0.35
Pages[1].Visible = true

-- ======================== MỞ / ĐÓNG MENU ========================
local isOpen = false

local function OpenMenu()
    if isOpen then return end
    isOpen = true
    Main.Visible = true
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.BackgroundTransparency = 1

    TweenService:Create(Main, TweenInfo.new(0.48, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 380, 0, 440),
        Position = UDim2.new(0.5, -190, 0.5, -220),
        BackgroundTransparency = 0.35
    }):Play()
end

local function CloseMenu()
    if not isOpen then return end
    isOpen = false

    local tw = TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    })
    tw:Play()
    tw.Completed:Connect(function()
        if not isOpen then Main.Visible = false end
    end)
end

ToggleBtn.MouseButton1Click:Connect(function()
    if isOpen then CloseMenu() else OpenMenu() end
end)
CloseBtn.MouseButton1Click:Connect(CloseMenu)

-- Hover nút Z
ToggleBtn.MouseEnter:Connect(function()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 64, 0, 64),
        BackgroundTransparency = 0
    }):Play()
end)
ToggleBtn.MouseLeave:Connect(function()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 58, 0, 58),
        BackgroundTransparency = 0.15
    }):Play()
end)

-- Kéo được nút
local dragging, dragStart, startPos
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleBtn.Position
    end
end)
ToggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Tự mở lần đầu để dễ thấy
task.delay(0.6, OpenMenu)

print("✅ Zaka Pure UI (Smart Vertical Tabs) loaded!")
