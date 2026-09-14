--[[
    ZAKA PURE UI - Fixed for Delta
    Nếu không hiện → xem Output / Console
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ======================== PARENT AN TOÀN ========================
local function GetGuiParent()
    local ok, result

    -- Ưu tiên gethui (Delta hỗ trợ tốt)
    ok, result = pcall(function() return gethui() end)
    if ok and result then return result end

    -- CoreGui
    ok, result = pcall(function() return game:GetService("CoreGui") end)
    if ok and result then return result end

    -- Cuối cùng PlayerGui
    return LocalPlayer:WaitForChild("PlayerGui")
end

local GuiParent = GetGuiParent()

-- Xóa bản cũ
pcall(function()
    if GuiParent:FindFirstChild("ZakaPureUI") then
        GuiParent.ZakaPureUI:Destroy()
    end
end)

-- ======================== CẤU HÌNH ========================
-- Để 0 cũng được, nút sẽ hiện chữ "Z" thay vì ảnh
local CAT_AVATAR_ID = "rbxassetid://0"   -- ← Thay bằng Asset ID thật nếu có

local Theme = {
    Background = Color3.fromRGB(12, 14, 22),
    Accent     = Color3.fromRGB(0, 180, 255),
    Text       = Color3.fromRGB(245, 248, 255),
    TextDim    = Color3.fromRGB(160, 170, 190),
    TabInactive= Color3.fromRGB(22, 25, 36),
}

-- ======================== TẠO GUI ========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaPureUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = GuiParent

-- ========== NÚT TOGGLE ==========
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "Toggle"
ToggleBtn.Size = UDim2.new(0, 62, 0, 62)
ToggleBtn.Position = UDim2.new(0, 16, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(18, 20, 32)
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = ScreenGui

-- Nếu có ảnh thì dùng, không thì hiện chữ Z
if CAT_AVATAR_ID \~= "rbxassetid://0" and CAT_AVATAR_ID \~= "" then
    ToggleBtn.Image = CAT_AVATAR_ID
    ToggleBtn.ScaleType = Enum.ScaleType.Crop
else
    -- Fallback đẹp khi chưa có ảnh
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "Z"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 28
    label.TextColor3 = Color3.fromRGB(0, 200, 255)
    label.Parent = ToggleBtn
end

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Theme.Accent
ToggleStroke.Thickness = 2.8
ToggleStroke.Transparency = 0.15
ToggleStroke.Parent = ToggleBtn

-- ========== MAIN FRAME ==========
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 420, 0, 490)
Main.Position = UDim2.new(0.5, -210, 0.5, -245)
Main.BackgroundColor3 = Theme.Background
Main.BackgroundTransparency = 0.12
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Accent
MainStroke.Thickness = 1.6
MainStroke.Transparency = 0.35
MainStroke.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
Header.BackgroundTransparency = 0.25
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA  <font color='#00B4FF'>UI</font>"
Title.RichText = true
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.TextColor3 = Theme.Text
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 34, 0, 34)
CloseBtn.Position = UDim2.new(1, -44, 0.5, -17)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.BackgroundTransparency = 0.6
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

-- Tab Bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 38)
TabBar.Position = UDim2.new(0, 10, 0, 60)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Main

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 6)
TabLayout.Parent = TabBar

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -112)
Content.Position = UDim2.new(0, 10, 0, 106)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true
Content.Parent = Main

-- ======================== TẠO TAB ========================
local TabsData = {
    {Name = "Home",   Icon = "⌂"},
    {Name = "Visual", Icon = "✦"},
    {Name = "Player", Icon = "◉"},
    {Name = "World",  Icon = "◈"},
    {Name = "Config", Icon = "⚙"},
}

local TabButtons, Pages = {}, {}
local CurrentTab = 1

local function CreateTab(i, data)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 72, 1, 0)
    btn.BackgroundColor3 = Theme.TabInactive
    btn.BackgroundTransparency = 0.3
    btn.Text = data.Icon .. " " .. data.Name
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextColor3 = Theme.TextDim
    btn.AutoButtonColor = false
    btn.Parent = TabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Accent
    stroke.Thickness = 1.2
    stroke.Transparency = 1
    stroke.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Theme.Accent
    page.Visible = false
    page.Parent = Content

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.Parent = page
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 10)
    end)

    for j = 1, 6 do
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 50)
        card.BackgroundColor3 = Color3.fromRGB(20, 24, 36)
        card.BackgroundTransparency = 0.35
        card.Parent = page
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -16, 1, 0)
        label.Position = UDim2.new(0, 14, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = data.Name .. "  •  Item " .. j
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.TextColor3 = Theme.Text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = card
    end

    TabButtons[i] = {Button = btn, Stroke = stroke}
    Pages[i] = page

    btn.MouseButton1Click:Connect(function()
        if CurrentTab == i then return end
        -- Ẩn tab cũ
        local old = TabButtons[CurrentTab]
        TweenService:Create(old.Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Theme.TabInactive,
            BackgroundTransparency = 0.3,
            TextColor3 = Theme.TextDim
        }):Play()
        TweenService:Create(old.Stroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        Pages[CurrentTab].Visible = false

        -- Hiện tab mới
        CurrentTab = i
        Pages[i].Visible = true
        TweenService:Create(btn, TweenInfo.new(0.25), {
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = 0.1,
            TextColor3 = Color3.new(1,1,1)
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.25), {Transparency = 0.3}):Play()
    end)
end

for i, data in ipairs(TabsData) do
    CreateTab(i, data)
end

-- Mặc định tab 1
Pages[1].Visible = true
TabButtons[1].Button.BackgroundColor3 = Theme.Accent
TabButtons[1].Button.BackgroundTransparency = 0.1
TabButtons[1].Button.TextColor3 = Color3.new(1,1,1)
TabButtons[1].Stroke.Transparency = 0.3

-- ======================== MỞ / ĐÓNG ========================
local isOpen = false

local function OpenMenu()
    if isOpen then return end
    isOpen = true
    Main.Visible = true
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.BackgroundTransparency = 1

    TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 420, 0, 490),
        Position = UDim2.new(0.5, -210, 0.5, -245),
        BackgroundTransparency = 0.12
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

-- Hover
ToggleBtn.MouseEnter:Connect(function()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 68, 0, 68)}):Play()
    TweenService:Create(ToggleStroke, TweenInfo.new(0.2), {Thickness = 3.5}):Play()
end)
ToggleBtn.MouseLeave:Connect(function()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 62, 0, 62)}):Play()
    TweenService:Create(ToggleStroke, TweenInfo.new(0.2), {Thickness = 2.8}):Play()
end)

-- Kéo được
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

print("✅ Zaka Pure UI đã load thành công trên Delta!")
print("→ Tìm nút tròn góc trái màn hình (chữ Z hoặc hình mèo)")
