--[[
    ZAKA NARUTO UI - RASENGAN EDITION
    - Nút Rasengan động + đổi mắt
    - Naruto & Sasuke bay 2 bên
    - Naruto → Cửu Vĩ khi mở lâu
    - Tab dọc chủ đề Naruto
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

pcall(function()
    if PlayerGui:FindFirstChild("ZakaNarutoUI") then
        PlayerGui.ZakaNarutoUI:Destroy()
    end
end)

local Gui = Instance.new("ScreenGui")
Gui.Name = "ZakaNarutoUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--==============================================================
-- MÀU SẮC CHỦ ĐỀ
--==============================================================
local Colors = {
    Orange = Color3.fromRGB(255, 140, 30),
    Blue = Color3.fromRGB(40, 120, 255),
    Purple = Color3.fromRGB(140, 60, 255),
    Red = Color3.fromRGB(220, 40, 40),
    Yellow = Color3.fromRGB(255, 210, 50),
    Dark = Color3.fromRGB(12, 10, 18),
    Kurama = Color3.fromRGB(255, 160, 20),
}

--==============================================================
-- NÚT RASENGAN (TOGGLE)
--==============================================================
local Toggle = Instance.new("TextButton")
Toggle.Name = "RasenganBtn"
Toggle.Size = UDim2.fromOffset(72, 72)
Toggle.Position = UDim2.new(0, 20, 0.42, 0)
Toggle.AnchorPoint = Vector2.new(0, 0.5)
Toggle.BackgroundColor3 = Color3.fromRGB(15, 12, 25)
Toggle.BackgroundTransparency = 0.1
Toggle.Text = ""
Toggle.AutoButtonColor = false
Toggle.ZIndex = 100
Toggle.Parent = Gui
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 2.5
ToggleStroke.Color = Colors.Orange
ToggleStroke.Transparency = 0.2
ToggleStroke.Parent = Toggle

-- Rasengan Core
local Rasengan = Instance.new("Frame")
Rasengan.Name = "Rasengan"
Rasengan.AnchorPoint = Vector2.new(0.5, 0.5)
Rasengan.Position = UDim2.fromScale(0.5, 0.5)
Rasengan.Size = UDim2.fromScale(0.78, 0.78)
Rasengan.BackgroundColor3 = Colors.Blue
Rasengan.BorderSizePixel = 0
Rasengan.ZIndex = 101
Rasengan.Parent = Toggle
Instance.new("UICorner", Rasengan).CornerRadius = UDim.new(1, 0)

local RasenganStroke = Instance.new("UIStroke")
RasenganStroke.Thickness = 2
RasenganStroke.Color = Color3.fromRGB(180, 230, 255)
RasenganStroke.Parent = Rasengan

-- Vòng điện xoay
local Ring1 = Instance.new("Frame")
Ring1.AnchorPoint = Vector2.new(0.5, 0.5)
Ring1.Position = UDim2.fromScale(0.5, 0.5)
Ring1.Size = UDim2.fromScale(1.15, 1.15)
Ring1.BackgroundTransparency = 1
Ring1.ZIndex = 102
Ring1.Parent = Toggle
Instance.new("UICorner", Ring1).CornerRadius = UDim.new(1, 0)
local Ring1Stroke = Instance.new("UIStroke")
Ring1Stroke.Thickness = 1.5
Ring1Stroke.Color = Colors.Orange
Ring1Stroke.Transparency = 0.3
Ring1Stroke.Parent = Ring1

local Ring2 = Ring1:Clone()
Ring2.Size = UDim2.fromScale(1.35, 1.35)
Ring2.Parent = Toggle
Ring2:FindFirstChildOfClass("UIStroke").Color = Colors.Blue

-- Core sáng
local Core = Instance.new("Frame")
Core.AnchorPoint = Vector2.new(0.5, 0.5)
Core.Position = UDim2.fromScale(0.5, 0.5)
Core.Size = UDim2.fromScale(0.35, 0.35)
Core.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Core.BorderSizePixel = 0
Core.ZIndex = 103
Core.Parent = Rasengan
Instance.new("UICorner", Core).CornerRadius = UDim.new(1, 0)

--==============================================================
-- HỆ THỐNG ĐỔI MẮT RASENGAN
--==============================================================
local EyeStyles = {
    {Name = "Rasengan", Color = Color3.fromRGB(80, 180, 255), Accent = Color3.fromRGB(200, 240, 255)},
    {Name = "Sharingan", Color = Color3.fromRGB(220, 30, 30), Accent = Color3.fromRGB(255, 100, 100)},
    {Name = "Rinnegan", Color = Color3.fromRGB(160, 80, 255), Accent = Color3.fromRGB(220, 180, 255)},
    {Name = "Byakugan", Color = Color3.fromRGB(230, 230, 255), Accent = Color3.fromRGB(180, 200, 255)},
    {Name = "Tenseigan", Color = Color3.fromRGB(80, 200, 255), Accent = Color3.fromRGB(150, 230, 255)},
    {Name = "Ketsuryugan", Color = Color3.fromRGB(180, 20, 40), Accent = Color3.fromRGB(255, 80, 80)},
    {Name = "Jogan", Color = Color3.fromRGB(40, 120, 255), Accent = Color3.fromRGB(100, 180, 255)},
    {Name = "Kurama", Color = Color3.fromRGB(255, 160, 20), Accent = Color3.fromRGB(255, 220, 100)},
}

local CurrentEye = 1
local UsedEyes = {}

local function ChangeEyeStyle()
    local available = {}
    for i = 1, #EyeStyles do
        if not UsedEyes[i] then
            table.insert(available, i)
        end
    end
    if #available == 0 then
        UsedEyes = {}
        available = {1,2,3,4,5,6,7,8}
    end

    local next = available[math.random(1, #available)]
    UsedEyes[next] = true
    CurrentEye = next

    local style = EyeStyles[next]
    TweenService:Create(Rasengan, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {
        BackgroundColor3 = style.Color
    }):Play()
    TweenService:Create(RasenganStroke, TweenInfo.new(0.8), {Color = style.Accent}):Play()
    TweenService:Create(ToggleStroke, TweenInfo.new(0.8), {Color = style.Color}):Play()
    TweenService:Create(Ring1Stroke, TweenInfo.new(0.8), {Color = style.Color}):Play()
end

-- Xoay Rasengan liên tục
RunService.RenderStepped:Connect(function()
    Rasengan.Rotation = Rasengan.Rotation + 2.2
    Ring1.Rotation = Ring1.Rotation - 1.4
    Ring2.Rotation = Ring2.Rotation + 1.8
end)

--==============================================================
-- NARUTO & SASUKE BAY 2 BÊN
--==============================================================
local function CreateFloatingChar(name, side, color)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = UDim2.fromOffset(90, 140)
    frame.Position = side == "Left" and UDim2.new(0, 15, 0.5, -70) or UDim2.new(1, -105, 0.5, -70)
    frame.BackgroundTransparency = 1
    frame.ZIndex = 50
    frame.Parent = Gui

    local body = Instance.new("Frame")
    body.Size = UDim2.fromOffset(70, 100)
    body.Position = UDim2.fromOffset(10, 20)
    body.BackgroundColor3 = color
    body.BackgroundTransparency = 0.15
    body.BorderSizePixel = 0
    body.Parent = frame
    Instance.new("UICorner", body).CornerRadius = UDim.new(0, 16)

    local head = Instance.new("Frame")
    head.Size = UDim2.fromOffset(42, 42)
    head.Position = UDim2.fromOffset(24, -5)
    head.BackgroundColor3 = Color3.fromRGB(255, 210, 170)
    head.BorderSizePixel = 0
    head.Parent = frame
    Instance.new("UICorner", head).CornerRadius = UDim.new(1, 0)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.fromOffset(0, 125)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = color
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.Parent = frame

    -- Bay lên xuống
    local baseY = frame.Position.Y.Offset
    task.spawn(function()
        local t = 0
        while frame.Parent do
            t = t + 0.03
            local offset = math.sin(t) * 12
            frame.Position = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset, 0.5, baseY + offset)
            task.wait()
        end
    end)

    return frame, body
end

local NarutoFrame, NarutoBody = CreateFloatingChar("NARUTO", "Left", Colors.Orange)
local SasukeFrame, SasukeBody = CreateFloatingChar("SASUKE", "Right", Colors.Blue)

--==============================================================
-- MAIN MENU
--==============================================================
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(480, 540)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Colors.Dark
Main.BackgroundTransparency = 0.08
Main.Visible = false
Main.ClipsDescendants = true
Main.ZIndex = 20
Main.Parent = Gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.8
MainStroke.Color = Colors.Orange
MainStroke.Transparency = 0.25
MainStroke.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 70)
Header.BackgroundColor3 = Color3.fromRGB(18, 14, 28)
Header.BackgroundTransparency = 0.3
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 20)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 0, 30)
Title.Position = UDim2.fromOffset(20, 12)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA × NARUTO"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -80, 0, 20)
SubTitle.Position = UDim2.fromOffset(20, 42)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "RASENGAN EDITION • EYE MORPH"
SubTitle.TextColor3 = Color3.fromRGB(180, 150, 100)
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.GothamBold
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(38, 38)
CloseBtn.Position = UDim2.new(1, -52, 0, 16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 40)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextSize = 24
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 10)

-- Tab dọc
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(0, 130, 1, -90)
TabContainer.Position = UDim2.fromOffset(12, 80)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 2
TabContainer.Parent = Main

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 8)
TabList.Parent = TabContainer

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -160, 1, -90)
Content.Position = UDim2.fromOffset(150, 80)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true
Content.Parent = Main

-- Dữ liệu Tab (chủ đề Naruto)
local TabsData = {
    {Name = "RASENGAN", Icon = "🌀", Theme = "Kỹ thuật Rasengan & Chakra"},
    {Name = "SHARINGAN", Icon = "👁", Theme = "Dojutsu & Ảo thuật"},
    {Name = "NINJUTSU", Icon = "⚡", Theme = "Thuật nhẫn giả tấn công"},
    {Name = "TAIJUTSU", Icon = "🥋", Theme = "Võ thuật thể chất"},
    {Name = "GENJUTSU", Icon = "🌙", Theme = "Ảo thuật tâm trí"},
    {Name = "BIJUU", Icon = "🦊", Theme = "Vĩ thú & Cửu Vĩ"},
}

local TabButtons = {}
local Pages = {}
local CurrentTab = 1

local function CreateCard(parent, title, desc)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 58)
    card.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
    card.BorderSizePixel = 0
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Colors.Orange
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = card

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -20, 0, 24)
    t.Position = UDim2.fromOffset(14, 8)
    t.BackgroundTransparency = 1
    t.Text = title
    t.TextColor3 = Color3.new(1,1,1)
    t.TextSize = 14
    t.Font = Enum.Font.GothamBold
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = card

    local d = Instance.new("TextLabel")
    d.Size = UDim2.new(1, -20, 0, 18)
    d.Position = UDim2.fromOffset(14, 32)
    d.BackgroundTransparency = 1
    d.Text = desc
    d.TextColor3 = Color3.fromRGB(160, 140, 120)
    d.TextSize = 11
    d.Font = Enum.Font.Gotham
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.Parent = card
end

for i, data in ipairs(TabsData) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
    btn.BackgroundTransparency = 0.3
    btn.Text = data.Icon .. "  " .. data.Name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(180, 160, 140)
    btn.AutoButtonColor = false
    btn.Parent = TabContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Colors.Orange
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Parent = Content

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.Parent = page
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 15)
    end)

    -- Nội dung theo chủ đề
    if i == 1 then -- Rasengan
        CreateCard(page, "Rasengan Thường", "Chakra xoáy hình cầu cơ bản")
        CreateCard(page, "Odama Rasengan", "Rasengan khổng lồ")
        CreateCard(page, "Rasenshuriken", "Rasengan biến thành shuriken gió")
        CreateCard(page, "Senpo: Rasengan", "Rasengan tiên thuật")
        CreateCard(page, "Chakra Nature Rasengan", "Kết hợp hệ chakra")
    elseif i == 2 then -- Sharingan
        CreateCard(page, "Sharingan 1 Tomoe", "Cấp độ cơ bản")
        CreateCard(page, "Mangekyo Sharingan", "Ảo thuật vĩnh cửu")
        CreateCard(page, "Rinnegan", "Mắt luân hồi")
        CreateCard(page, "Izanagi / Izanami", "Thuật định mệnh")
        CreateCard(page, "Susanoo", "Hộ thể khổng lồ")
    elseif i == 3 then -- Ninjutsu
        CreateCard(page, "Kage Bunshin", "Phân thân bóng")
        CreateCard(page, "Rasengan Series", "Chuỗi kỹ thuật Rasengan")
        CreateCard(page, "Chidori", "Sấm chớp xuyên phá")
        CreateCard(page, "Amaterasu", "Hắc hỏa")
        CreateCard(page, "Shinra Tensei", "Thần la thiên sinh")
    elseif i == 4 then -- Taijutsu
        CreateCard(page, "Konoha Taijutsu", "Võ thuật làng Lá")
        CreateCard(page, "Gentle Fist", "Quyền nhu Byakugan")
        CreateCard(page, "Primary Lotus", "Liên hoa sơ cấp")
        CreateCard(page, "Shadow of the Dancing Leaf", "Bóng lá nhảy múa")
    elseif i == 5 then -- Genjutsu
        CreateCard(page, "Tsukuyomi", "Ảo thuật mặt trăng")
        CreateCard(page, "Kotoamatsukami", "Điều khiển ý chí")
        CreateCard(page, "Ephemeral", "Ảo ảnh phù du")
    elseif i == 6 then -- Bijuu
        CreateCard(page, "Cửu Vĩ Chakra Mode", "Áo choàng Cửu Vĩ")
        CreateCard(page, "Kurama Mode", "Hợp thể với Cửu Vĩ")
        CreateCard(page, "Bijuudama", "Đạn vĩ thú")
        CreateCard(page, "Tailed Beast Bomb", "Bom vĩ thú")
    end

    TabButtons[i] = btn
    Pages[i] = page
end

local function SwitchTab(index)
    for i, btn in ipairs(TabButtons) do
        btn.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
        btn.TextColor3 = Color3.fromRGB(180, 160, 140)
        Pages[i].Visible = false
    end
    TabButtons[index].BackgroundColor3 = Colors.Orange
    TabButtons[index].TextColor3 = Color3.new(1,1,1)
    Pages[index].Visible = true
    CurrentTab = index
end

for i, btn in ipairs(TabButtons) do
    btn.MouseButton1Click:Connect(function()
        SwitchTab(i)
    end)
end
SwitchTab(1)

--==============================================================
-- MỞ / ĐÓNG MENU + BIẾN THÀNH CỬU VĨ
--==============================================================
local MenuOpen = false
local OpenTime = 0
local IsKurama = false

local function OpenMenu()
    if MenuOpen then return end
    MenuOpen = true
    OpenTime = tick()
    Main.Visible = true
    Main.Size = UDim2.fromOffset(30, 30)
    Main.BackgroundTransparency = 1

    TweenService:Create(Main, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(480, 540),
        BackgroundTransparency = 0.08
    }):Play()

    -- Đổi mắt mỗi lần mở
    ChangeEyeStyle()
end

local function CloseMenu()
    if not MenuOpen then return end
    MenuOpen = false
    IsKurama = false

    -- Trả về màu thường
    TweenService:Create(NarutoBody, TweenInfo.new(0.6), {BackgroundColor3 = Colors.Orange}):Play()
    TweenService:Create(MainStroke, TweenInfo.new(0.6), {Color = Colors.Orange}):Play()

    TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Size = UDim2.fromOffset(30, 30),
        BackgroundTransparency = 1
    }):Play()

    task.delay(0.4, function()
        if not MenuOpen then Main.Visible = false end
    end)
end

-- Biến thành Cửu Vĩ khi mở lâu
RunService.Heartbeat:Connect(function()
    if MenuOpen and not IsKurama then
        if tick() - OpenTime > 12 then -- sau 12 giây
            IsKurama = true
            TweenService:Create(NarutoBody, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {
                BackgroundColor3 = Colors.Kurama
            }):Play()
            TweenService:Create(MainStroke, TweenInfo.new(1.2), {Color = Colors.Kurama}):Play()
            TweenService:Create(ToggleStroke, TweenInfo.new(1.2), {Color = Colors.Kurama}):Play()
        end
    end
end)

Toggle.MouseButton1Click:Connect(function()
    if MenuOpen then CloseMenu() else OpenMenu() end
end)
CloseBtn.MouseButton1Click:Connect(CloseMenu)

-- Kéo nút Rasengan
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
        Toggle.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Tự mở
task.wait(0.5)
OpenMenu()

print("✅ ZAKA NARUTO UI - RASENGAN EDITION LOADED")
