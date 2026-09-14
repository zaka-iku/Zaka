--[[
    ZAKA PURE UI  -  Optimized for Delta Executor
    Chỉ là menu UI đẹp, không có chức năng hack
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ======================== PARENT AN TOÀN CHO DELTA ========================
local function GetGuiParent()
    local success, result = pcall(function()
        return gethui()
    end)
    if success and result then
        return result
    end

    success, result = pcall(function()
        return game:GetService("CoreGui")
    end)
    if success and result then
        return result
    end

    return LocalPlayer:WaitForChild("PlayerGui")
end

local GuiParent = GetGuiParent()

-- Xóa menu cũ nếu có
if GuiParent:FindFirstChild("ZakaPureUI") then
    GuiParent.ZakaPureUI:Destroy()
end

-- ======================== CẤU HÌNH ========================
local CAT_AVATAR_ID = "rbxassetid://0" -- ← Thay Asset ID mèo trắng của bạn vào đây

local Theme = {
    Background = Color3.fromRGB(12, 14, 22),
    Accent = Color3.fromRGB(0, 180, 255),
    Accent2 = Color3.fromRGB(160, 90, 255),
    Text = Color3.fromRGB(245, 248, 255),
    TextDim = Color3.fromRGB(160, 170, 190),
    TabInactive = Color3.fromRGB(22, 25, 36),
    Stroke = Color3.fromRGB(0, 170, 255),
}

-- ======================== TẠO GUI ========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaPureUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = GuiParent

-- Nút Toggle (hình mèo)
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "Toggle"
ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
ToggleBtn.Position = UDim2.new(0, 18, 0.42, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
ToggleBtn.Image = CAT_AVATAR_ID
ToggleBtn.ScaleType = Enum.ScaleType.Crop
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Theme.Accent
ToggleStroke.Thickness = 2.8
ToggleStroke.Transparency = 0.2
ToggleStroke.Parent = ToggleBtn

-- Glow nhẹ
local ToggleGlow = Instance.new("ImageLabel")
ToggleGlow.Size = UDim2.new(1.7, 0, 1.7, 0)
ToggleGlow.Position = UDim2.new(-0.35, 0, -0.35, 0)
ToggleGlow.BackgroundTransparency = 1
ToggleGlow.Image = "rbxassetid://5028857084"
ToggleGlow.ImageColor3 = Theme.Accent
ToggleGlow.ImageTransparency = 0.65
ToggleGlow.ZIndex = 0
ToggleGlow.Parent = ToggleBtn

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 430, 0, 500)
Main.Position = UDim2.new(0.5, -215, 0.5, -250)
Main.BackgroundColor3 = Theme.Background
Main.BackgroundTransparency = 0.15
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Stroke
MainStroke.Thickness = 1.8
MainStroke.Transparency = 0.4
MainStroke.Parent = Main

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 26, 42)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 14, 22))
})
Gradient.Rotation = 105
Gradient.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 54)
Header.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
Header.BackgroundTransparency = 0.3
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 18)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA  <font color='#00B4FF'>UI</font>  <font color='#888888'>| Pure</font>"
Title.RichText = true
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.TextColor3 = Theme.Text
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Nút đóng
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 34, 0, 34)
CloseBtn.Position = UDim2.new(1, -44, 0.5, -17)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
CloseBtn.BackgroundTransparency = 0.65
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = Header

Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

-- Tab Bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -24, 0, 40)
TabBar.Position = UDim2.new(0, 12, 0, 62)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Main

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 7)
TabLayout.Parent = TabBar

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -24, 1, -120)
Content.Position = UDim2.new(0, 12, 0, 110)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true
Content.Parent = Main

-- ======================== TẠO TAB ========================
local TabsData = {
    {Name = "Home", Icon = "⌂"},
    {Name = "Visual", Icon = "✦"},
    {Name = "Player", Icon = "◉"},
    {Name = "World", Icon = "◈"},
    {Name = "Config", Icon = "⚙"},
}

local TabButtons = {}
local Pages = {}
local CurrentTab = 1

local function CreateTab(index, data)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 74, 1, 0)
    btn.BackgroundColor3 = Theme.TabInactive
    btn.BackgroundTransparency = 0.35
    btn.Text = data.Icon .. "  " .. data.Name
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextColor3 = Theme.TextDim
    btn.AutoButtonColor = false
    btn.Parent = TabBar

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Accent
    stroke.Thickness = 1.3
    stroke.Transparency = 1
    stroke.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Theme.Accent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false
    page.Parent = Content

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.Parent = page

    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 12)
    end)

    -- Nội dung demo (chỉ để nhìn đẹp)
    for i = 1, 7 do
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 54)
        card.BackgroundColor3 = Color3.fromRGB(20, 24, 36)
        card.BackgroundTransparency = 0.38
        card.Parent = page

        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

        local cardStroke = Instance.new("UIStroke")
        cardStroke.Color = Theme.Accent
        cardStroke.Thickness = 1
        cardStroke.Transparency = 0.78
        cardStroke.Parent = card

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 1, 0)
        label.Position = UDim2.new(0, 16, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = data.Name .. "  •  Item " .. i
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.TextColor3 = Theme.Text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = card
    end

    TabButtons[index] = {Button = btn, Stroke = stroke}
    Pages[index] = page

    btn.MouseButton1Click:Connect(function()
        SwitchTab(index)
    end)

    btn.MouseEnter:Connect(function()
        if CurrentTab \~= index then
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.12,
                TextColor3 = Theme.Text
            }):Play()
        end
    end)

    btn.MouseLeave:Connect(function()
        if CurrentTab \~= index then
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.35,
                TextColor3 = Theme.TextDim
            }):Play()
        end
    end)
end

for i, data in ipairs(TabsData) do
    CreateTab(i, data)
end

-- ======================== CHUYỂN TAB ========================
function SwitchTab(index)
    if CurrentTab == index then return end

    local oldBtn = TabButtons[CurrentTab]
    TweenService:Create(oldBtn.Button, TweenInfo.new(0.25), {
        BackgroundColor3 = Theme.TabInactive,
        BackgroundTransparency = 0.35,
        TextColor3 = Theme.TextDim
    }):Play()
    TweenService:Create(oldBtn.Stroke, TweenInfo.new(0.25), {Transparency = 1}):Play()

    Pages[CurrentTab].Visible = false
    CurrentTab = index
    Pages[index].Visible = true

    local newBtn = TabButtons[index]
    TweenService:Create(newBtn.Button, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.12,
        TextColor3 = Color3.new(1, 1, 1)
    }):Play()
    TweenService:Create(newBtn.Stroke, TweenInfo.new(0.3), {Transparency = 0.35}):Play()
end

SwitchTab(1)

-- ======================== ANIMATION MỞ / ĐÓNG ========================
local isOpen = false

local function OpenMenu()
    if isOpen then return end
    isOpen = true
    Main.Visible = true
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.BackgroundTransparency = 1

    TweenService:Create(Main, TweenInfo.new(0.48, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 430, 0, 500),
        Position = UDim2.new(0.5, -215, 0.5, -250),
        BackgroundTransparency = 0.15
    }):Play()

    TweenService:Create(MainStroke, TweenInfo.new(0.4), {Transparency = 0.4}):Play()
end

local function CloseMenu()
    if not isOpen then return end
    isOpen = false

    local tw = TweenService:Create(Main, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    })
    tw:Play()
    tw.Completed:Connect(function()
        if not isOpen then
            Main.Visible = false
        end
    end)
end

ToggleBtn.MouseButton1Click:Connect(function()
    if isOpen then CloseMenu() else OpenMenu() end
end)

CloseBtn.MouseButton1Click:Connect(CloseMenu)

-- Hover nút mèo
ToggleBtn.MouseEnter:Connect(function()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.22), {Size = UDim2.new(0, 66, 0, 66)}):Play()
    TweenService:Create(ToggleStroke, TweenInfo.new(0.22), {Thickness = 3.4, Transparency = 0.05}):Play()
end)

ToggleBtn.MouseLeave:Connect(function()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.22), {Size = UDim2.new(0, 60, 0, 60)}):Play()
    TweenService:Create(ToggleStroke, TweenInfo.new(0.22), {Thickness = 2.8, Transparency = 0.2}):Play()
end)

-- Kéo nút toggle
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
        ToggleBtn.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

print("✅ Zaka Pure UI loaded | Optimized for Delta")
