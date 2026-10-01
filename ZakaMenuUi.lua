--[[
    ZAKA × NARUTO UI
    - Nút Z cầu vồng → Rasengan Eye (12 kiểu)
    - Naruto & Sasuke chi tiết (code)
    - Animation mở/đóng mượt
    - Tab: Combat | ESP | Player | Teleport | Server | Ultra
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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
-- MÀU SẮC
--==============================================================
local Colors = {
    Orange = Color3.fromRGB(255, 145, 40),
    Blue = Color3.fromRGB(50, 130, 255),
    Purple = Color3.fromRGB(150, 70, 255),
    Red = Color3.fromRGB(230, 50, 50),
    Yellow = Color3.fromRGB(255, 210, 60),
    Dark = Color3.fromRGB(10, 8, 16),
}

--==============================================================
-- NÚT Z / RASENGAN
--==============================================================
local Toggle = Instance.new("TextButton")
Toggle.Name = "ToggleBtn"
Toggle.Size = UDim2.fromOffset(68, 68)
Toggle.Position = UDim2.new(0, 18, 0.42, 0)
Toggle.AnchorPoint = Vector2.new(0, 0.5)
Toggle.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
Toggle.BackgroundTransparency = 0.05
Toggle.Text = ""
Toggle.AutoButtonColor = false
Toggle.ZIndex = 120
Toggle.Parent = Gui
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

local RainbowStroke = Instance.new("UIStroke")
RainbowStroke.Thickness = 2.8
RainbowStroke.Color = Color3.fromRGB(255, 100, 50)
RainbowStroke.Parent = Toggle

local ZLabel = Instance.new("TextLabel")
ZLabel.Name = "ZLabel"
ZLabel.Size = UDim2.fromScale(1, 1)
ZLabel.BackgroundTransparency = 1
ZLabel.Text = "Z"
ZLabel.TextColor3 = Color3.new(1, 1, 1)
ZLabel.TextSize = 34
ZLabel.Font = Enum.Font.GothamBlack
ZLabel.ZIndex = 122
ZLabel.Parent = Toggle

-- Rasengan Eye
local Eye = Instance.new("Frame")
Eye.Name = "RasenganEye"
Eye.AnchorPoint = Vector2.new(0.5, 0.5)
Eye.Position = UDim2.fromScale(0.5, 0.5)
Eye.Size = UDim2.fromScale(0.82, 0.82)
Eye.BackgroundTransparency = 1
Eye.Visible = false
Eye.ZIndex = 121
Eye.Parent = Toggle

local function MakeCircle(size, color, transparency, z)
    local f = Instance.new("Frame")
    f.AnchorPoint = Vector2.new(0.5, 0.5)
    f.Position = UDim2.fromScale(0.5, 0.5)
    f.Size = UDim2.fromScale(size, size)
    f.BackgroundColor3 = color
    f.BackgroundTransparency = transparency or 0
    f.BorderSizePixel = 0
    f.ZIndex = z or 121
    f.Parent = Eye
    Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
    return f
end

local Glow = MakeCircle(1.35, Color3.fromRGB(255, 80, 40), 0.82, 121)
local Outer = MakeCircle(1.05, Color3.fromRGB(20, 10, 15), 0, 122)
local OuterStroke = Instance.new("UIStroke")
OuterStroke.Thickness = 2.2
OuterStroke.Color = Color3.fromRGB(255, 90, 50)
OuterStroke.Parent = Outer

local Mid = MakeCircle(0.72, Color3.fromRGB(180, 40, 40), 0, 123)
local MidStroke = Instance.new("UIStroke")
MidStroke.Thickness = 1.8
MidStroke.Color = Color3.fromRGB(255, 120, 80)
MidStroke.Parent = Mid

local Iris = MakeCircle(0.42, Color3.fromRGB(220, 50, 40), 0, 124)
local IrisStroke = Instance.new("UIStroke")
IrisStroke.Thickness = 1.5
IrisStroke.Color = Color3.fromRGB(255, 180, 120)
IrisStroke.Parent = Iris

local Pupil = MakeCircle(0.18, Color3.fromRGB(0, 0, 0), 0, 125)
local Core = MakeCircle(0.06, Color3.fromRGB(255, 255, 255), 0, 126)

local Symbol = Instance.new("Frame")
Symbol.AnchorPoint = Vector2.new(0.5, 0.5)
Symbol.Position = UDim2.fromScale(0.5, 0.5)
Symbol.Size = UDim2.fromScale(0.85, 0.85)
Symbol.BackgroundTransparency = 1
Symbol.ZIndex = 127
Symbol.Parent = Eye

local SymbolObjects = {}
local function ClearSymbol()
    for _, obj in ipairs(SymbolObjects) do
        if obj and obj.Parent then obj:Destroy() end
    end
    table.clear(SymbolObjects)
end

local function AddLine(angle, length, width, color)
    local l = Instance.new("Frame")
    l.AnchorPoint = Vector2.new(0.5, 0.5)
    l.Position = UDim2.fromScale(0.5, 0.5)
    l.Size = UDim2.new(0, length, 0, width)
    l.Rotation = angle
    l.BackgroundColor3 = color
    l.BorderSizePixel = 0
    l.ZIndex = 128
    l.Parent = Symbol
    table.insert(SymbolObjects, l)
    return l
end

local function AddDot(x, y, size, color)
    local d = Instance.new("Frame")
    d.AnchorPoint = Vector2.new(0.5, 0.5)
    d.Position = UDim2.fromScale(x, y)
    d.Size = UDim2.fromOffset(size, size)
    d.BackgroundColor3 = color
    d.BorderSizePixel = 0
    d.ZIndex = 129
    d.Parent = Symbol
    Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)
    table.insert(SymbolObjects, d)
    return d
end

local EyeTypes = {
    {Name="Sharingan", Color=Color3.fromRGB(230,35,40), Accent=Color3.fromRGB(20,0,0), Type="TOMOE"},
    {Name="Mangekyo", Color=Color3.fromRGB(210,25,35), Accent=Color3.fromRGB(10,0,0), Type="STAR"},
    {Name="Rinnegan", Color=Color3.fromRGB(160,90,255), Accent=Color3.fromRGB(40,15,80), Type="RINGS"},
    {Name="Byakugan", Color=Color3.fromRGB(230,230,255), Accent=Color3.fromRGB(180,190,255), Type="VOID"},
    {Name="Tenseigan", Color=Color3.fromRGB(70,190,255), Accent=Color3.fromRGB(30,80,160), Type="COSMIC"},
    {Name="Jogan", Color=Color3.fromRGB(40,120,255), Accent=Color3.fromRGB(20,50,140), Type="HEX"},
    {Name="Ketsuryugan", Color=Color3.fromRGB(180,20,40), Accent=Color3.fromRGB(60,0,10), Type="TRI"},
    {Name="Kurama", Color=Color3.fromRGB(255,160,30), Accent=Color3.fromRGB(80,30,0), Type="STAR6"},
    {Name="Rasengan", Color=Color3.fromRGB(60,160,255), Accent=Color3.fromRGB(20,60,140), Type="SPIRAL"},
    {Name="BlackStar", Color=Color3.fromRGB(220,40,50), Accent=Color3.fromRGB(0,0,0), Type="BLACKSTAR"},
    {Name="Triple", Color=Color3.fromRGB(200,40,50), Accent=Color3.fromRGB(30,0,0), Type="TRIPLE"},
    {Name="Crimson", Color=Color3.fromRGB(255,40,50), Accent=Color3.fromRGB(40,0,0), Type="STAR"},
}

local function BuildSymbol(data)
    ClearSymbol()
    local C, A = data.Color, data.Accent

    if data.Type == "TOMOE" then
        for i = 1, 3 do
            local ang = (i-1)*120
            AddDot(0.5 + math.cos(math.rad(ang))*0.26, 0.5 + math.sin(math.rad(ang))*0.26, 9, A)
            local l = AddLine((i-1)*120, 20, 5, A)
            l.Position = UDim2.fromScale(0.5 + math.cos(math.rad(ang))*0.13, 0.5 + math.sin(math.rad(ang))*0.13)
        end
    elseif data.Type == "RINGS" then
        for i = 1, 4 do
            local r = Instance.new("Frame")
            r.AnchorPoint = Vector2.new(0.5,0.5)
            r.Position = UDim2.fromScale(0.5,0.5)
            r.Size = UDim2.fromScale(0.18 + i*0.14, 0.18 + i*0.14)
            r.BackgroundTransparency = 1
            r.ZIndex = 128
            r.Parent = Symbol
            local s = Instance.new("UIStroke")
            s.Thickness = 1.6
            s.Color = A
            s.Parent = r
            Instance.new("UICorner", r).CornerRadius = UDim.new(1,0)
            table.insert(SymbolObjects, r)
        end
    elseif data.Type == "STAR" then
        for i = 1, 6 do AddLine((i-1)*60, 46, 6, A) end
    elseif data.Type == "TRI" then
        for i = 1, 3 do AddLine((i-1)*120, 42, 7, A) end
    elseif data.Type == "HEX" then
        for i = 1, 6 do AddLine((i-1)*60, 44, 5, A) end
        for i = 1, 6 do
            local ang = math.rad((i-1)*60)
            AddDot(0.5 + math.cos(ang)*0.24, 0.5 + math.sin(ang)*0.24, 6, C)
        end
    elseif data.Type == "SPIRAL" then
        for i = 1, 5 do
            local l = AddLine(i*30, 28 + i*3, 4, A)
            l.Position = UDim2.fromScale(0.5 + math.cos(math.rad(i*65))*0.07, 0.5 + math.sin(math.rad(i*65))*0.07)
        end
    elseif data.Type == "STAR6" then
        for i = 1, 6 do AddLine((i-1)*60, 50, 8, A) end
    elseif data.Type == "VOID" then
        for i = 1, 8 do AddLine((i-1)*45, 40, 3, C) end
    elseif data.Type == "TRIPLE" then
        for i = 1, 3 do
            local ang = math.rad((i-1)*120)
            AddDot(0.5 + math.cos(ang)*0.19, 0.5 + math.sin(ang)*0.19, 13, A)
            AddLine((i-1)*120, 28, 6, A)
        end
    elseif data.Type == "COSMIC" then
        for i = 1, 8 do
            local ang = math.rad((i-1)*45)
            AddDot(0.5 + math.cos(ang)*0.28, 0.5 + math.sin(ang)*0.28, 5, C)
            AddLine((i-1)*45, 40, 2, A)
        end
    elseif data.Type == "BLACKSTAR" then
        for i = 1, 5 do AddLine((i-1)*36, 48, 8, A) end
        for i = 1, 5 do
            local ang = math.rad((i-1)*72)
            AddDot(0.5 + math.cos(ang)*0.23, 0.5 + math.sin(ang)*0.23, 7, C)
        end
    end
end

local CurrentEye = 1
local Morphing = false
local EyeOpen = false

local function ChangeEyeColor(data)
    local t = 1.4
    TweenService:Create(Outer, TweenInfo.new(t), {BackgroundColor3 = data.Accent}):Play()
    TweenService:Create(Mid, TweenInfo.new(t), {BackgroundColor3 = data.Color}):Play()
    TweenService:Create(Iris, TweenInfo.new(t), {BackgroundColor3 = data.Color}):Play()
    TweenService:Create(Glow, TweenInfo.new(t), {BackgroundColor3 = data.Color}):Play()
    TweenService:Create(OuterStroke, TweenInfo.new(t), {Color = data.Color}):Play()
    TweenService:Create(MidStroke, TweenInfo.new(t), {Color = data.Color}):Play()
    TweenService:Create(IrisStroke, TweenInfo.new(t), {Color = data.Color}):Play()
    TweenService:Create(RainbowStroke, TweenInfo.new(t), {Color = data.Color}):Play()
end

local function MorphTo(index)
    if Morphing then return end
    Morphing = true
    local data = EyeTypes[index]

    TweenService:Create(Eye, TweenInfo.new(0.4), {Size = UDim2.fromScale(0.68, 0.68)}):Play()
    TweenService:Create(Symbol, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {Rotation = Symbol.Rotation + 180}):Play()
    ChangeEyeColor(data)
    task.wait(0.3)

    for _, obj in ipairs(SymbolObjects) do
        if obj:IsA("Frame") then
            TweenService:Create(obj, TweenInfo.new(0.45), {BackgroundTransparency = 1}):Play()
        end
    end
    task.wait(0.3)
    BuildSymbol(data)

    for _, obj in ipairs(SymbolObjects) do
        if obj:IsA("Frame") then
            obj.BackgroundTransparency = 1
            TweenService:Create(obj, TweenInfo.new(0.55), {BackgroundTransparency = 0}):Play()
        end
    end

    TweenService:Create(Eye, TweenInfo.new(0.55, Enum.EasingStyle.Back), {Size = UDim2.fromScale(0.82, 0.82)}):Play()
    CurrentEye = index
    task.wait(0.6)
    Morphing = false
end

local MorphThread
local function StartAutoMorph()
    if MorphThread then return end
    MorphThread = task.spawn(function()
        while EyeOpen do
            task.wait(5)
            if not EyeOpen then break end
            local next
            repeat next = math.random(1, #EyeTypes) until next \~= CurrentEye
            MorphTo(next)
        end
        MorphThread = nil
    end)
end

RunService.RenderStepped:Connect(function()
    if EyeOpen then
        Symbol.Rotation = Symbol.Rotation + 1.8
        Glow.Rotation = Glow.Rotation - 0.9
    end
end)

local hue = 0
RunService.RenderStepped:Connect(function()
    if not EyeOpen then
        hue = (hue + 0.6) % 360
        RainbowStroke.Color = Color3.fromHSV(hue/360, 0.85, 1)
    end
end)

--==============================================================
-- NARUTO & SASUKE CHI TIẾT
--==============================================================
local function CreateCharacter(name, side, mainColor, accentColor)
    local holder = Instance.new("Frame")
    holder.Name = name
    holder.Size = UDim2.fromOffset(108, 185)
    holder.Position = side == "Left" and UDim2.new(0, 10, 0.5, -92) or UDim2.new(1, -118, 0.5, -92)
    holder.BackgroundTransparency = 1
    holder.Visible = false
    holder.ZIndex = 40
    holder.Parent = Gui

    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.fromOffset(64, 16)
    shadow.Position = UDim2.fromOffset(22, 165)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.65
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 39
    shadow.Parent = holder
    Instance.new("UICorner", shadow).CornerRadius = UDim.new(1, 0)

    local body = Instance.new("Frame")
    body.Name = "Body"
    body.Size = UDim2.fromOffset(66, 92)
    body.Position = UDim2.fromOffset(21, 50)
    body.BackgroundColor3 = mainColor
    body.BorderSizePixel = 0
    body.ZIndex = 41
    body.Parent = holder
    Instance.new("UICorner", body).CornerRadius = UDim.new(0, 13)

    local inner = Instance.new("Frame")
    inner.Size = UDim2.fromOffset(50, 68)
    inner.Position = UDim2.fromOffset(8, 10)
    inner.BackgroundColor3 = accentColor
    inner.BackgroundTransparency = 0.35
    inner.BorderSizePixel = 0
    inner.Parent = body
    Instance.new("UICorner", inner).CornerRadius = UDim.new(0, 9)

    local pants = Instance.new("Frame")
    pants.Size = UDim2.fromOffset(58, 38)
    pants.Position = UDim2.fromOffset(4, 78)
    pants.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    pants.BorderSizePixel = 0
    pants.Parent = body
    Instance.new("UICorner", pants).CornerRadius = UDim.new(0, 8)

    local head = Instance.new("Frame")
    head.Name = "Head"
    head.Size = UDim2.fromOffset(46, 46)
    head.Position = UDim2.fromOffset(31, 10)
    head.BackgroundColor3 = Color3.fromRGB(255, 208, 170)
    head.BorderSizePixel = 0
    head.ZIndex = 42
    head.Parent = holder
    Instance.new("UICorner", head).CornerRadius = UDim.new(1, 0)

    local hair = Instance.new("Frame")
    hair.Size = UDim2.fromOffset(52, 26)
    hair.Position = UDim2.fromOffset(-3, -7)
    hair.BackgroundColor3 = name == "NARUTO" and Color3.fromRGB(255, 165, 40) or Color3.fromRGB(20, 18, 28)
    hair.BorderSizePixel = 0
    hair.ZIndex = 43
    hair.Parent = head
    Instance.new("UICorner", hair).CornerRadius = UDim.new(0.45, 0)

    local eyeL = Instance.new("Frame")
    eyeL.Size = UDim2.fromOffset(7, 7)
    eyeL.Position = UDim2.fromOffset(11, 17)
    eyeL.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    eyeL.BorderSizePixel = 0
    eyeL.Parent = head
    Instance.new("UICorner", eyeL).CornerRadius = UDim.new(1, 0)

    local eyeR = eyeL:Clone()
    eyeR.Position = UDim2.fromOffset(28, 17)
    eyeR.Parent = head

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.fromOffset(0, 162)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = mainColor
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBlack
    nameLabel.Parent = holder

    local glow = Instance.new("Frame")
    glow.Size = UDim2.fromOffset(88, 88)
    glow.Position = UDim2.fromOffset(10, 35)
    glow.BackgroundColor3 = mainColor
    glow.BackgroundTransparency = 0.87
    glow.BorderSizePixel = 0
    glow.ZIndex = 38
    glow.Parent = holder
    Instance.new("UICorner", glow).CornerRadius = UDim.new(1, 0)

    local baseY = holder.Position.Y.Offset
    task.spawn(function()
        local t = math.random() * 6
        while holder and holder.Parent do
            t = t + 0.032
            local yOffset = math.sin(t) * 7
            local rot = math.sin(t * 0.55) * 2.2

            holder.Position = UDim2.new(
                holder.Position.X.Scale,
                holder.Position.X.Offset,
                0.5,
                baseY + yOffset
            )
            body.Rotation = rot
            head.Rotation = rot * 0.5
            glow.BackgroundTransparency = 0.87 + math.sin(t * 1.4) * 0.035

            task.wait()
        end
    end)

    return holder, body
end

local NarutoHolder, NarutoBody = CreateCharacter(
    "NARUTO",
    "Left",
    Color3.fromRGB(255, 145, 40),
    Color3.fromRGB(255, 90, 30)
)

local SasukeHolder, SasukeBody = CreateCharacter(
    "SASUKE",
    "Right",
    Color3.fromRGB(45, 110, 220),
    Color3.fromRGB(25, 45, 110)
)

--==============================================================
-- MAIN MENU
--==============================================================
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(460, 520)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Colors.Dark
Main.BackgroundTransparency = 0.06
Main.Visible = false
Main.ClipsDescendants = true
Main.ZIndex = 30
Main.Parent = Gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.6
MainStroke.Color = Colors.Orange
MainStroke.Transparency = 0.3
MainStroke.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 62)
Header.BackgroundColor3 = Color3.fromRGB(16, 12, 24)
Header.BackgroundTransparency = 0.25
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 0, 28)
Title.Position = UDim2.fromOffset(18, 10)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA × NARUTO"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Sub = Instance.new("TextLabel")
Sub.Size = UDim2.new(1, -70, 0, 18)
Sub.Position = UDim2.fromOffset(18, 36)
Sub.BackgroundTransparency = 1
Sub.Text = "RASENGAN EYE • 12 STYLES"
Sub.TextColor3 = Color3.fromRGB(200, 150, 90)
Sub.TextSize = 11
Sub.Font = Enum.Font.GothamBold
Sub.TextXAlignment = Enum.TextXAlignment.Left
Sub.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(36, 36)
CloseBtn.Position = UDim2.new(1, -48, 0, 13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 40)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextSize = 22
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 10)

local TabFrame = Instance.new("ScrollingFrame")
TabFrame.Size = UDim2.new(0, 118, 1, -80)
TabFrame.Position = UDim2.fromOffset(12, 72)
TabFrame.BackgroundTransparency = 1
TabFrame.ScrollBarThickness = 2
TabFrame.Parent = Main

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 7)
TabLayout.Parent = TabFrame

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -145, 1, -80)
Content.Position = UDim2.fromOffset(138, 72)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true
Content.Parent = Main

local TabNames = {"Combat", "ESP", "Player", "Teleport", "Server", "Ultra"}
local TabIcons = {"⚔", "👁", "◉", "⇪", "🌐", "✦"}
local TabButtons = {}
local Pages = {}

for i, name in ipairs(TabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
    btn.BackgroundTransparency = 0.25
    btn.Text = TabIcons[i] .. "  " .. name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(170, 150, 140)
    btn.AutoButtonColor = false
    btn.Parent = TabFrame
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
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 12)
    end)

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 70)
    card.BackgroundColor3 = Color3.fromRGB(20, 16, 28)
    card.BorderSizePixel = 0
    card.Parent = page
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.fromOffset(12, 0)
    label.BackgroundTransparency = 1
    label.Text = name .. " Tab\n(Chưa gắn chức năng)"
    label.TextColor3 = Color3.fromRGB(180, 160, 140)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    TabButtons[i] = btn
    Pages[i] = page
end

local function SwitchTab(index)
    for i, btn in ipairs(TabButtons) do
        btn.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
        btn.TextColor3 = Color3.fromRGB(170, 150, 140)
        Pages[i].Visible = false
    end
    TabButtons[index].BackgroundColor3 = Colors.Orange
    TabButtons[index].TextColor3 = Color3.new(1,1,1)
    Pages[index].Visible = true
end

for i, btn in ipairs(TabButtons) do
    btn.MouseButton1Click:Connect(function()
        SwitchTab(i)
    end)
end
SwitchTab(1)

--==============================================================
-- MỞ / ĐÓNG
--==============================================================
local MenuOpen = false

local function OpenEye()
    EyeOpen = true
    ZLabel.Visible = false
    Eye.Visible = true
    Eye.Size = UDim2.fromScale(0.05, 0.05)
    BuildSymbol(EyeTypes[CurrentEye])
    ChangeEyeColor(EyeTypes[CurrentEye])

    TweenService:Create(Eye, TweenInfo.new(0.7, Enum.EasingStyle.Back), {
        Size = UDim2.fromScale(0.82, 0.82)
    }):Play()
    StartAutoMorph()
end

local function CloseEye()
    EyeOpen = false
    TweenService:Create(Eye, TweenInfo.new(0.55, Enum.EasingStyle.Quint), {
        Size = UDim2.fromScale(0.05, 0.05)
    }):Play()
    task.wait(0.5)
    Eye.Visible = false
    ZLabel.Visible = true
    ZLabel.TextTransparency = 1
    TweenService:Create(ZLabel, TweenInfo.new(0.35), {TextTransparency = 0}):Play()
end

local function OpenMenu()
    if MenuOpen then return end
    MenuOpen = true

    NarutoHolder.Visible = true
    SasukeHolder.Visible = true
    NarutoHolder.Position = UDim2.new(0, -130, 0.5, -92)
    SasukeHolder.Position = UDim2.new(1, 30, 0.5, -92)

    TweenService:Create(NarutoHolder, TweenInfo.new(0.6, Enum.EasingStyle.Back), {
        Position = UDim2.new(0, 10, 0.5, -92)
    }):Play()
    TweenService:Create(SasukeHolder, TweenInfo.new(0.6, Enum.EasingStyle.Back), {
        Position = UDim2.new(1, -118, 0.5, -92)
    }):Play()

    Main.Visible = true
    Main.Size = UDim2.fromOffset(20, 20)
    Main.BackgroundTransparency = 1

    OpenEye()

    TweenService:Create(Main, TweenInfo.new(0.55, Enum.EasingStyle.Back), {
        Size = UDim2.fromOffset(460, 520),
        BackgroundTransparency = 0.06
    }):Play()
end

local function CloseMenu()
    if not MenuOpen then return end
    MenuOpen = false

    TweenService:Create(NarutoHolder, TweenInfo.new(0.4), {
        Position = UDim2.new(0, -130, 0.5, -92)
    }):Play()
    TweenService:Create(SasukeHolder, TweenInfo.new(0.4), {
        Position = UDim2.new(1, 30, 0.5, -92)
    }):Play()
    task.delay(0.45, function()
        if not MenuOpen then
            NarutoHolder.Visible = false
            SasukeHolder.Visible = false
        end
    end)

    CloseEye()

    TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
        Size = UDim2.fromOffset(20, 20),
        BackgroundTransparency = 1
    }):Play()
    task.delay(0.4, function()
        if not MenuOpen then Main.Visible = false end
    end)
end

Toggle.MouseButton1Click:Connect(function()
    if MenuOpen then CloseMenu() else OpenMenu() end
end)
CloseBtn.MouseButton1Click:Connect(CloseMenu)

-- Kéo nút
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

task.wait(0.4)
OpenMenu()

print("✅ ZAKA × NARUTO UI LOADED")
print("• Nút Z cầu vồng → Rasengan Eye 12 kiểu")
print("• Naruto & Sasuke chi tiết")
print("• Tab: Combat | ESP | Player | Teleport | Server | Ultra")
