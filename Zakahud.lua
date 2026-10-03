--[[
    ZAKA • PINK PANTHER MENU
    Chỉ giao diện + animation (chưa gắn chức năng)
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

pcall(function()
    local old = PlayerGui:FindFirstChild("ZakaPinkPanther")
    if old then old:Destroy() end
end)

local Gui = Instance.new("ScreenGui")
Gui.Name = "ZakaPinkPanther"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

-- Màu
local Pink = Color3.fromRGB(255, 105, 180)
local LightPink = Color3.fromRGB(255, 182, 210)
local SoftPink = Color3.fromRGB(255, 220, 235)
local DarkPink = Color3.fromRGB(180, 40, 100)
local White = Color3.fromRGB(255, 255, 255)

--==========================================================
-- NÚT Z (đóng)
--==========================================================
local Toggle = Instance.new("TextButton")
Toggle.Name = "Toggle"
Toggle.Size = UDim2.fromOffset(68, 68)
Toggle.Position = UDim2.new(0, 20, 0.45, 0)
Toggle.AnchorPoint = Vector2.new(0, 0.5)
Toggle.BackgroundColor3 = Pink
Toggle.BackgroundTransparency = 0.05
Toggle.Text = ""
Toggle.AutoButtonColor = false
Toggle.ZIndex = 100
Toggle.Parent = Gui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = Toggle

local RainbowStroke = Instance.new("UIStroke")
RainbowStroke.Name = "Rainbow"
RainbowStroke.Thickness = 3
RainbowStroke.Color = Color3.fromRGB(255, 100, 180)
RainbowStroke.Parent = Toggle

local ZLabel = Instance.new("TextLabel")
ZLabel.Name = "Z"
ZLabel.Size = UDim2.fromScale(1, 1)
ZLabel.BackgroundTransparency = 1
ZLabel.Text = "Z"
ZLabel.TextColor3 = White
ZLabel.TextSize = 34
ZLabel.Font = Enum.Font.GothamBlack
ZLabel.ZIndex = 101
ZLabel.Parent = Toggle

-- Z xoay liên tục
local zRot = 0
RunService.RenderStepped:Connect(function(dt)
    if not MenuOpen then
        zRot = (zRot + dt * 120) % 360
        ZLabel.Rotation = zRot
    end
end)

-- Viền cầu vồng
local hue = 0
RunService.RenderStepped:Connect(function(dt)
    if not MenuOpen then
        hue = (hue + dt * 0.45) % 1
        RainbowStroke.Color = Color3.fromHSV(hue, 0.75, 1)
    end
end)

--==========================================================
-- MENU CHÍNH (hình hoa / organics)
--==========================================================
local MenuOpen = false

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.Size = UDim2.fromOffset(0, 0)
Main.BackgroundColor3 = SoftPink
Main.BackgroundTransparency = 0.18
Main.Visible = false
Main.ClipsDescendants = true
Main.ZIndex = 50
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0.5, 0) -- bo tròn mạnh → cảm giác hoa / giọt nước
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 3
MainStroke.Color = Pink
MainStroke.Transparency = 0.15
MainStroke.Parent = Main

-- Lớp nền hồng mờ (giả background báo hồng)
local BgGlow = Instance.new("Frame")
BgGlow.Size = UDim2.fromScale(1.15, 1.15)
BgGlow.Position = UDim2.fromScale(0.5, 0.5)
BgGlow.AnchorPoint = Vector2.new(0.5, 0.5)
BgGlow.BackgroundColor3 = Pink
BgGlow.BackgroundTransparency = 0.82
BgGlow.ZIndex = 49
BgGlow.Parent = Main
Instance.new("UICorner", BgGlow).CornerRadius = UDim.new(1, 0)

--==========================================================
-- TÂM HOA (báo hồng xoay 360)
--==========================================================
local Center = Instance.new("TextButton")
Center.Name = "CenterFlower"
Center.Size = UDim2.fromOffset(78, 78)
Center.Position = UDim2.new(0.5, 0, 0, 52)
Center.AnchorPoint = Vector2.new(0.5, 0)
Center.BackgroundColor3 = Pink
Center.BackgroundTransparency = 0.1
Center.Text = ""
Center.AutoButtonColor = false
Center.ZIndex = 60
Center.Parent = Main
Instance.new("UICorner", Center).CornerRadius = UDim.new(1, 0)

local CenterStroke = Instance.new("UIStroke")
CenterStroke.Thickness = 2.5
CenterStroke.Color = White
CenterStroke.Parent = Center

-- Báo hồng (text tượng trưng + xoay)
local Panther = Instance.new("TextLabel")
Panther.Size = UDim2.fromScale(1, 1)
Panther.BackgroundTransparency = 1
Panther.Text = "🐆"
Panther.TextSize = 36
Panther.ZIndex = 61
Panther.Parent = Center

local pantherRot = 0
RunService.RenderStepped:Connect(function(dt)
    if MenuOpen then
        pantherRot = (pantherRot + dt * 90) % 360
        Panther.Rotation = pantherRot
    end
end)

--==========================================================
-- TABS DỌC (bo góc + phình to / thu nhỏ)
--==========================================================
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Name = "Tabs"
TabContainer.Size = UDim2.new(0, 130, 1, -150)
TabContainer.Position = UDim2.fromOffset(18, 140)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
TabContainer.ZIndex = 55
TabContainer.Parent = Main

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 10)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabContainer

-- Scrollbar hình báo hồng nhỏ
local ScrollBar = Instance.new("Frame")
ScrollBar.Name = "PinkScroll"
ScrollBar.Size = UDim2.fromOffset(14, 60)
ScrollBar.Position = UDim2.new(0, 148, 0, 140)
ScrollBar.BackgroundColor3 = Pink
ScrollBar.BackgroundTransparency = 0.2
ScrollBar.ZIndex = 56
ScrollBar.Parent = Main
Instance.new("UICorner", ScrollBar).CornerRadius = UDim.new(1, 0)

local ScrollIcon = Instance.new("TextLabel")
ScrollIcon.Size = UDim2.fromScale(1, 1)
ScrollIcon.BackgroundTransparency = 1
ScrollIcon.Text = "🐆"
ScrollIcon.TextSize = 12
ScrollIcon.Parent = ScrollBar

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -180, 1, -160)
Content.Position = UDim2.fromOffset(170, 145)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true
Content.ZIndex = 55
Content.Parent = Main

local Tabs = {
    {Name = "Combat", Icon = "⚔"},
    {Name = "Hitbox", Icon = "🎯"},
    {Name = "Visual", Icon = "✦"},
    {Name = "Player", Icon = "◉"},
    {Name = "World", Icon = "◈"},
    {Name = "Troll", Icon = "⚡"},
}

local TabButtons = {}
local Pages = {}
local CurrentTab = 1

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Pink
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Parent = Content

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.Parent = page
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 12)
    end)

    -- placeholder card
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 70)
    card.BackgroundColor3 = SoftPink
    card.BackgroundTransparency = 0.45
    card.Parent = page
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 16)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Text = name .. "\n(Chức năng sẽ gắn sau)"
    label.TextColor3 = DarkPink
    label.TextSize = 14
    label.Font = Enum.Font.GothamMedium
    label.Parent = card

    return page
end

for i, data in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Name = data.Name
    btn.Size = UDim2.new(1, 0, 0, 44)
    btn.BackgroundColor3 = SoftPink
    btn.BackgroundTransparency = 0.35
    btn.Text = data.Icon .. "  " .. data.Name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = DarkPink
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    btn.Parent = TabContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 14)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Pink
    stroke.Thickness = 1.2
    stroke.Transparency = 0.6
    stroke.Parent = btn

    -- hiệu ứng báo hồng nhỏ khi bấm
    local function PlayPantherPop()
        local pop = Instance.new("TextLabel")
        pop.Size = UDim2.fromOffset(28, 28)
        pop.Position = UDim2.new(0.5, 0, 0.5, 0)
        pop.AnchorPoint = Vector2.new(0.5, 0.5)
        pop.BackgroundTransparency = 1
        pop.Text = "🐆"
        pop.TextSize = 22
        pop.ZIndex = 80
        pop.Parent = btn

        TweenService:Create(pop, TweenInfo.new(0.45, Enum.EasingStyle.Back), {
            Position = UDim2.new(0.5, math.random(-20, 20), 0, -30),
            TextTransparency = 1,
            Rotation = math.random(-40, 40)
        }):Play()
        task.delay(0.5, function() pop:Destroy() end)
    end

    btn.MouseButton1Click:Connect(function()
        PlayPantherPop()
        SwitchTab(i)
    end)

    TabButtons[i] = btn
    Pages[i] = CreatePage(data.Name)
end

function SwitchTab(index)
    for i, btn in ipairs(TabButtons) do
        local isSelected = (i == index)
        TweenService:Create(btn, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
            Size = isSelected and UDim2.new(1, 0, 0, 58) or UDim2.new(1, -8, 0, 38),
            BackgroundTransparency = isSelected and 0.1 or 0.45,
            TextColor3 = isSelected and White or DarkPink
        }):Play()

        local stroke = btn:FindFirstChildOfClass("UIStroke")
        if stroke then
            TweenService:Create(stroke, TweenInfo.new(0.3), {
                Transparency = isSelected and 0.15 or 0.65,
                Color = isSelected and White or Pink
            }):Play()
        end

        Pages[i].Visible = false
    end
    Pages[index].Visible = true
    CurrentTab = index
end

SwitchTab(1)

--==========================================================
-- MỞ / ĐÓNG ANIMATION
--==========================================================
local function OpenMenu()
    if MenuOpen then return end
    MenuOpen = true

    -- Ẩn Z, hiện menu từ vị trí nút
    ZLabel.Visible = false
    Main.Visible = true
    Main.Position = Toggle.Position
    Main.Size = UDim2.fromOffset(40, 40)
    Main.BackgroundTransparency = 1
    MainCorner.CornerRadius = UDim.new(1, 0)

    -- Phóng to + di chuyển về giữa
    TweenService:Create(Main, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(520, 580),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundTransparency = 0.18
    }):Play()

    TweenService:Create(MainCorner, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {
        CornerRadius = UDim.new(0.22, 0)
    }):Play()

    TweenService:Create(Toggle, TweenInfo.new(0.3), {
        BackgroundTransparency = 0.6,
        TextTransparency = 1
    }):Play()
end

local function CloseMenu()
    if not MenuOpen then return end
    MenuOpen = false

    -- Hút vào + biến thành giọt nước
    TweenService:Create(MainCorner, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
        CornerRadius = UDim.new(0.5, 0)
    }):Play()

    TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Size = UDim2.fromOffset(36, 52), -- giọt nước
        Position = Toggle.Position,
        BackgroundTransparency = 0.3
    }):Play()

    task.delay(0.38, function()
        TweenService:Create(Main, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {
            Size = UDim2.fromOffset(0, 0),
            BackgroundTransparency = 1
        }):Play()
    end)

    task.delay(0.6, function()
        if not MenuOpen then
            Main.Visible = false
            ZLabel.Visible = true
            ZLabel.TextTransparency = 1
            TweenService:Create(ZLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
            TweenService:Create(Toggle, TweenInfo.new(0.3), {
                BackgroundTransparency = 0.05
            }):Play()
        end
    end)
end

-- Bấm nút Z hoặc tâm hoa để mở/đóng
Toggle.MouseButton1Click:Connect(function()
    if MenuOpen then CloseMenu() else OpenMenu() end
end)

Center.MouseButton1Click:Connect(function()
    CloseMenu()
end)

-- Kéo nút Z
local dragging, dragStart, startPos
Toggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Toggle.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Toggle.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Scrollbar kéo
local scrollDragging = false
ScrollBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        scrollDragging = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if scrollDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local y = math.clamp(input.Position.Y - Main.AbsolutePosition.Y - 140, 0, TabContainer.AbsoluteSize.Y - 60)
        ScrollBar.Position = UDim2.new(0, 148, 0, 140 + y)
        local alpha = y / math.max(TabContainer.AbsoluteSize.Y - 60, 1)
        TabContainer.CanvasPosition = Vector2.new(0, alpha * (TabContainer.AbsoluteCanvasSize.Y - TabContainer.AbsoluteSize.Y))
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        scrollDragging = false
    end
end)

task.wait(0.4)
OpenMenu()

print("✅ ZAKA • PINK PANTHER MENU LOADED")
print("Z xoay • Viền cầu vồng • Mở phóng to • Đóng hút vào giọt nước")
print("Tab phình to/thu nhỏ • Báo hồng pop • Scroll báo hồng")
