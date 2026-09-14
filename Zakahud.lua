--[[
    ZAKA PURE UI - Water Drop Close Animation
    Khi đóng / kéo → biến thành giọt nước bay về nút Z
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

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
ToggleBtn.Size = UDim2.new(0, 56, 0, 56)
ToggleBtn.Position = UDim2.new(0, 16, 0.38, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.BackgroundTransparency = 0.1
ToggleBtn.Text = "Z"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 24
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Transparency = 0.35
ToggleStroke.Parent = ToggleBtn

-- ========== MAIN ==========
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 390, 0, 460)
Main.Position = UDim2.new(0.5, -195, 0.5, -230)
Main.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
Main.BackgroundTransparency = 0.32
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 180, 255)
MainStroke.Thickness = 1.4
MainStroke.Transparency = 0.45
MainStroke.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 46)
Header.BackgroundColor3 = Color3.fromRGB(12, 15, 24)
Header.BackgroundTransparency = 0.35
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA UI"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(240, 245, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.BackgroundTransparency = 0.35
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

-- Search
local SearchFrame = Instance.new("Frame")
SearchFrame.Size = UDim2.new(1, -118, 0, 34)
SearchFrame.Position = UDim2.new(0, 108, 0, 54)
SearchFrame.BackgroundColor3 = Color3.fromRGB(30, 36, 50)
SearchFrame.BackgroundTransparency = 0.4
SearchFrame.Parent = Main
Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 10)

local SearchStroke = Instance.new("UIStroke")
SearchStroke.Color = Color3.fromRGB(0, 180, 255)
SearchStroke.Thickness = 1.2
SearchStroke.Transparency = 0.7
SearchStroke.Parent = SearchFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -14, 1, 0)
SearchBox.Position = UDim2.new(0, 10, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.PlaceholderText = "🔍  Tìm kiếm tính năng..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(140, 150, 170)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(240, 245, 255)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 13
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.Parent = SearchFrame

SearchBox.Focused:Connect(function()
    TweenService:Create(SearchFrame, TweenInfo.new(0.25), {BackgroundTransparency = 0.25, Size = UDim2.new(1, -118, 0, 38)}):Play()
    TweenService:Create(SearchStroke, TweenInfo.new(0.25), {Transparency = 0.3, Thickness = 1.6}):Play()
end)
SearchBox.FocusLost:Connect(function()
    TweenService:Create(SearchFrame, TweenInfo.new(0.25), {BackgroundTransparency = 0.4, Size = UDim2.new(1, -118, 0, 34)}):Play()
    TweenService:Create(SearchStroke, TweenInfo.new(0.25), {Transparency = 0.7, Thickness = 1.2}):Play()
end)

-- Tab dọc
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 92, 1, -60)
TabContainer.Position = UDim2.new(0, 10, 0, 54)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Main

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 7)
TabList.Parent = TabContainer

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -118, 1, -100)
Content.Position = UDim2.new(0, 108, 0, 96)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true
Content.Parent = Main

local TabsData = {
    {Name = "Home",   Icon = "⌂"},
    {Name = "Visual", Icon = "✦"},
    {Name = "Player", Icon = "◉"},
    {Name = "World",  Icon = "◈"},
    {Name = "Config", Icon = "⚙"},
}

local TabButtons, Pages, AllCards = {}, {}, {}
local CurrentTab = 1

local function CreateSmartCard(parent, text)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 44)
    card.BackgroundColor3 = Color3.fromRGB(28, 34, 48)
    card.BackgroundTransparency = 0.42
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 11)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.75
    stroke.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -14, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(230, 235, 250)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    card.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.18), {BackgroundTransparency = 0.28, Size = UDim2.new(1, 0, 0, 48)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.18), {Transparency = 0.4}):Play()
    end)
    card.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.18), {BackgroundTransparency = 0.42, Size = UDim2.new(1, 0, 0, 44)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.18), {Transparency = 0.75}):Play()
    end)

    table.insert(AllCards, {Frame = card, Text = text:lower(), Parent = parent})
    return card
end

for i, data in ipairs(TabsData) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(32, 38, 55)
    btn.BackgroundTransparency = 0.5
    btn.Text = data.Icon .. "  " .. data.Name
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(170, 180, 200)
    btn.AutoButtonColor = false
    btn.Parent = TabContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 11)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Thickness = 1.2
    stroke.Transparency = 1
    stroke.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Parent = Content

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 7)
    list.Parent = page
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 10)
    end)

    for j = 1, 6 do
        CreateSmartCard(page, data.Name .. "  •  Feature " .. j)
    end

    TabButtons[i] = {Button = btn, Stroke = stroke}
    Pages[i] = page
end

local function SwitchTab(index)
    if CurrentTab == index then return end
    local old = TabButtons[CurrentTab]
    local new = TabButtons[index]

    TweenService:Create(old.Button, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 0.5,
        TextColor3 = Color3.fromRGB(170, 180, 200)
    }):Play()
    TweenService:Create(old.Stroke, TweenInfo.new(0.25), {Transparency = 1}):Play()

    TweenService:Create(new.Button, TweenInfo.new(0.35, Enum.EasingStyle.Back), {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundTransparency = 0.22,
        TextColor3 = Color3.new(1, 1, 1)
    }):Play()
    TweenService:Create(new.Stroke, TweenInfo.new(0.3), {Transparency = 0.3}):Play()

    Pages[CurrentTab].Visible = false
    Pages[index].Visible = true
    CurrentTab = index
    SearchBox.Text = ""
end

for i in ipairs(TabButtons) do
    TabButtons[i].Button.MouseButton1Click:Connect(function()
        SwitchTab(i)
    end)
end

TabButtons[1].Button.Size = UDim2.new(1, 0, 0, 48)
TabButtons[1].Button.BackgroundTransparency = 0.22
TabButtons[1].Button.TextColor3 = Color3.new(1, 1, 1)
TabButtons[1].Stroke.Transparency = 0.3
Pages[1].Visible = true

-- Search filter
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local keyword = SearchBox.Text:lower()
    for _, item in ipairs(AllCards) do
        if item.Parent.Visible then
            local match = keyword == "" or item.Text:find(keyword)
            if match then
                item.Frame.Visible = true
                TweenService:Create(item.Frame, TweenInfo.new(0.22), {
                    BackgroundTransparency = 0.42,
                    Size = UDim2.new(1, 0, 0, 44)
                }):Play()
            else
                TweenService:Create(item.Frame, TweenInfo.new(0.18), {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0)
                }):Play()
                task.delay(0.18, function()
                    if not (keyword == "" or item.Text:find(keyword)) then
                        item.Frame.Visible = false
                    end
                end)
            end
        end
    end
end)

-- ======================== WATER DROP CLOSE ANIMATION ========================
local isOpen = false
local isDraggingMain = false

local function OpenMenu()
    if isOpen then return end
    isOpen = true
    Main.Visible = true
    Main.Size = UDim2.new(0, 56, 0, 56) -- bắt đầu từ kích thước nút Z
    Main.Position = ToggleBtn.Position
    Main.BackgroundTransparency = 0.1
    MainCorner.CornerRadius = UDim.new(1, 0) -- tròn

    -- Ẩn nội dung tạm
    for _, child in ipairs(Main:GetChildren()) do
        if child \~= MainCorner and child \~= MainStroke then
            child.Visible = false
        end
    end

    -- Phóng ra thành menu
    local openInfo = TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    TweenService:Create(Main, openInfo, {
        Size = UDim2.new(0, 390, 0, 460),
        Position = UDim2.new(0.5, -195, 0.5, -230),
        BackgroundTransparency = 0.32
    }):Play()
    TweenService:Create(MainCorner, TweenInfo.new(0.4), {
        CornerRadius = UDim.new(0, 18)
    }):Play()

    task.delay(0.25, function()
        for _, child in ipairs(Main:GetChildren()) do
            if child \~= MainCorner and child \~= MainStroke then
                child.Visible = true
            end
        end
    end)
end

local function CloseMenu()
    if not isOpen then return end
    isOpen = false

    -- Ẩn nội dung trước
    for _, child in ipairs(Main:GetChildren()) do
        if child \~= MainCorner and child \~= MainStroke then
            child.Visible = false
        end
    end

    -- Biến thành giọt nước (tròn + hơi dãn)
    local dropInfo = TweenInfo.new(0.38, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

    TweenService:Create(Main, dropInfo, {
        Size = UDim2.new(0, 64, 0, 64),
        BackgroundTransparency = 0.05
    }):Play()
    TweenService:Create(MainCorner, TweenInfo.new(0.3), {
        CornerRadius = UDim.new(1, 0)
    }):Play()
    TweenService:Create(MainStroke, TweenInfo.new(0.3), {
        Thickness = 2.5,
        Transparency = 0.2
    }):Play()

    -- Bay về nút Z với chuyển động đẹp
    task.delay(0.15, function()
        local flyInfo = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
        local tw = TweenService:Create(Main, flyInfo, {
            Position = ToggleBtn.Position,
            Size = UDim2.new(0, 56, 0, 56)
        })
        tw:Play()
        tw.Completed:Connect(function()
            Main.Visible = false
            -- reset
            MainCorner.CornerRadius = UDim.new(0, 18)
            MainStroke.Thickness = 1.4
            MainStroke.Transparency = 0.45
        end)
    end)
end

-- Kéo Main (làm cảm giác lỏng)
local dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingMain = true
        dragStart = input.Position
        startPos = Main.Position

        -- Khi bắt đầu kéo → bo góc mạnh hơn (cảm giác lỏng)
        TweenService:Create(MainCorner, TweenInfo.new(0.2), {
            CornerRadius = UDim.new(0, 28)
        }):Play()
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingMain = false
        TweenService:Create(MainCorner, TweenInfo.new(0.25), {
            CornerRadius = UDim.new(0, 18)
        }):Play()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingMain and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Sự kiện
ToggleBtn.MouseButton1Click:Connect(function()
    if isOpen then CloseMenu() else OpenMenu() end
end)
CloseBtn.MouseButton1Click:Connect(CloseMenu)

ToggleBtn.MouseEnter:Connect(function()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 62, 0, 62)}):Play()
end)
ToggleBtn.MouseLeave:Connect(function()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 56, 0, 56)}):Play()
end)

-- Kéo nút Z
local tDragging, tDragStart, tStartPos
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        tDragging = true
        tDragStart = input.Position
        tStartPos = ToggleBtn.Position
    end
end)
ToggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        tDragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if tDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - tDragStart
        ToggleBtn.Position = UDim2.new(tStartPos.X.Scale, tStartPos.X.Offset + delta.X, tStartPos.Y.Scale, tStartPos.Y.Offset + delta.Y)
    end
end)

task.delay(0.5, OpenMenu)
print("✅ Zaka Pure UI - Water Drop Animation loaded!")
