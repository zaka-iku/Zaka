--==============================================================--
-- ZAKA PURE UI V1
-- EYE MORPH EDITION
--==============================================================--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==============================================================
-- CLEAN OLD VERSION
--==============================================================

local Old = PlayerGui:FindFirstChild("ZakaPureUI")

if Old then
    Old:Destroy()
end

--==============================================================
-- GUI
--==============================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "ZakaPureUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--==============================================================
-- TOGGLE
--==============================================================

local Toggle = Instance.new("TextButton")
Toggle.Name = "ToggleButton"
Toggle.Size = UDim2.fromOffset(64,64)
Toggle.Position = UDim2.new(0,18,0.42,0)
Toggle.AnchorPoint = Vector2.new(0,0.5)
Toggle.BackgroundColor3 = Color3.fromRGB(9,9,15)
Toggle.BackgroundTransparency = 0.05
Toggle.BorderSizePixel = 0
Toggle.Text = "Z"
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.TextSize = 30
Toggle.Font = Enum.Font.GothamBlack
Toggle.AutoButtonColor = false
Toggle.ZIndex = 100
Toggle.Parent = Gui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1,0)
ToggleCorner.Parent = Toggle

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 2
ToggleStroke.Color = Color3.fromRGB(120,80,255)
ToggleStroke.Transparency = 0.15
ToggleStroke.Parent = Toggle

--==============================================================
-- MAIN
--==============================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(.5,.5)
Main.Position = UDim2.fromScale(.5,.5)
Main.Size = UDim2.fromOffset(0,0)
Main.BackgroundColor3 = Color3.fromRGB(8,8,14)
Main.BackgroundTransparency = 1
Main.BorderSizePixel = 0
Main.Visible = false
Main.ZIndex = 20
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,18)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(105,75,255)
MainStroke.Transparency = .2
MainStroke.Parent = Main

--==============================================================
-- HEADER
--==============================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,65)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(20,8)
Title.Size = UDim2.new(1,-80,0,27)
Title.Text = "ZAKA PURE UI"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 21
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.fromOffset(21,36)
Subtitle.Size = UDim2.new(1,-80,0,18)
Subtitle.Text = "V1 • EYE MORPH EDITION"
Subtitle.TextColor3 = Color3.fromRGB(140,130,190)
Subtitle.TextSize = 9
Subtitle.Font = Enum.Font.GothamBold
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(38,38)
Close.Position = UDim2.new(1,-48,0,12)
Close.BackgroundColor3 = Color3.fromRGB(35,25,45)
Close.BorderSizePixel = 0
Close.Text = "×"
Close.TextColor3 = Color3.new(1,1,1)
Close.TextSize = 25
Close.Font = Enum.Font.GothamBold
Close.AutoButtonColor = false
Close.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0,10)
CloseCorner.Parent = Close

--==============================================================
-- CONTENT
--==============================================================

local Content = Instance.new("Frame")
Content.Position = UDim2.fromOffset(14,75)
Content.Size = UDim2.new(1,-28,1,-88)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Banner = Instance.new("Frame")
Banner.Size = UDim2.new(1,0,0,60)
Banner.BackgroundColor3 = Color3.fromRGB(19,17,30)
Banner.BorderSizePixel = 0
Banner.Parent = Content

local BannerCorner = Instance.new("UICorner")
BannerCorner.CornerRadius = UDim.new(0,12)
BannerCorner.Parent = Banner

local BannerText = Instance.new("TextLabel")
BannerText.BackgroundTransparency = 1
BannerText.Position = UDim2.fromOffset(15,7)
BannerText.Size = UDim2.new(1,-30,0,22)
BannerText.Text = "EYE SYSTEM"
BannerText.TextColor3 = Color3.new(1,1,1)
BannerText.TextSize = 14
BannerText.Font = Enum.Font.GothamBlack
BannerText.TextXAlignment = Enum.TextXAlignment.Left
BannerText.Parent = Banner

local BannerSub = Instance.new("TextLabel")
BannerSub.BackgroundTransparency = 1
BannerSub.Position = UDim2.fromOffset(15,30)
BannerSub.Size = UDim2.new(1,-30,0,20)
BannerSub.Text = "Morphing • Color transition • Rotation"
BannerSub.TextColor3 = Color3.fromRGB(135,125,160)
BannerSub.TextSize = 9
BannerSub.Font = Enum.Font.Gotham
BannerSub.TextXAlignment = Enum.TextXAlignment.Left
BannerSub.Parent = Banner

--==============================================================
-- TABS
--==============================================================

local TabFrame = Instance.new("Frame")
TabFrame.Position = UDim2.fromOffset(0,70)
TabFrame.Size = UDim2.new(1,0,0,40)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = Content

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0,5)
TabLayout.Parent = TabFrame

for _,Name in ipairs({
    "COMBAT",
    "VISUAL",
    "PLAYER",
    "WORLD",
    "TROLL"
}) do

    local B = Instance.new("TextButton")
    B.Size = UDim2.fromOffset(76,38)
    B.BackgroundColor3 = Color3.fromRGB(20,18,30)
    B.BorderSizePixel = 0
    B.Text = Name
    B.TextColor3 = Color3.fromRGB(180,175,205)
    B.TextSize = 9
    B.Font = Enum.Font.GothamBold
    B.AutoButtonColor = false
    B.Parent = TabFrame

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0,9)
    C.Parent = B

    B.MouseButton1Click:Connect(function()

        for _,X in ipairs(TabFrame:GetChildren()) do

            if X:IsA("TextButton") then

                X.BackgroundColor3 =
                    Color3.fromRGB(20,18,30)

                X.TextColor3 =
                    Color3.fromRGB(180,175,205)

            end
        end

        B.BackgroundColor3 =
            Color3.fromRGB(72,50,145)

        B.TextColor3 =
            Color3.new(1,1,1)

    end)
end

--==============================================================
-- CARDS
--==============================================================

local CardFrame = Instance.new("Frame")
CardFrame.Position = UDim2.fromOffset(0,120)
CardFrame.Size = UDim2.new(1,0,1,-120)
CardFrame.BackgroundTransparency = 1
CardFrame.Parent = Content

local CardLayout = Instance.new("UIListLayout")
CardLayout.Padding = UDim.new(0,8)
CardLayout.Parent = CardFrame

for _,Data in ipairs({
    {"AIM SYSTEM","Targeting interface"},
    {"ESP SYSTEM","Visual interface"},
    {"MOVEMENT","Movement controls"},
    {"WORLD","World settings"},
    {"SETTINGS","UI configuration"},
}) do

    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1,0,0,50)
    Card.BackgroundColor3 = Color3.fromRGB(17,16,27)
    Card.BorderSizePixel = 0
    Card.Parent = CardFrame

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0,11)
    C.Parent = Card

    local T = Instance.new("TextLabel")
    T.BackgroundTransparency = 1
    T.Position = UDim2.fromOffset(14,6)
    T.Size = UDim2.new(1,-60,0,20)
    T.Text = Data[1]
    T.TextColor3 = Color3.new(1,1,1)
    T.TextSize = 12
    T.Font = Enum.Font.GothamBold
    T.TextXAlignment = Enum.TextXAlignment.Left
    T.Parent = Card

    local S = Instance.new("TextLabel")
    S.BackgroundTransparency = 1
    S.Position = UDim2.fromOffset(14,27)
    S.Size = UDim2.new(1,-60,0,16)
    S.Text = Data[2]
    S.TextColor3 = Color3.fromRGB(115,110,140)
    S.TextSize = 8
    S.Font = Enum.Font.Gotham
    S.TextXAlignment = Enum.TextXAlignment.Left
    S.Parent = Card

    local Arrow = Instance.new("TextLabel")
    Arrow.BackgroundTransparency = 1
    Arrow.Position = UDim2.new(1,-38,0,10)
    Arrow.Size = UDim2.fromOffset(25,25)
    Arrow.Text = "›"
    Arrow.TextColor3 = Color3.fromRGB(130,105,255)
    Arrow.TextSize = 24
    Arrow.Font = Enum.Font.GothamBold
    Arrow.Parent = Card
end

--==============================================================
-- EYE SYSTEM
--==============================================================

local Eye = Instance.new("Frame")
Eye.Name = "ZakaEye"
Eye.AnchorPoint = Vector2.new(.5,.5)
Eye.Position = UDim2.fromScale(.5,.5)
Eye.Size = UDim2.fromScale(.82,.82)
Eye.BackgroundTransparency = 1
Eye.Visible = false
Eye.ZIndex = 150
Eye.Parent = Toggle

--==============================================================
-- EYE LAYERS
--==============================================================

local function MakeCircle(Name,Size,Color,Transparency,Z)

    local F = Instance.new("Frame")

    F.Name = Name
    F.AnchorPoint = Vector2.new(.5,.5)
    F.Position = UDim2.fromScale(.5,.5)

    F.Size = UDim2.fromScale(Size,Size)

    F.BackgroundColor3 = Color
    F.BackgroundTransparency = Transparency or 0

    F.BorderSizePixel = 0
    F.ZIndex = Z or 150

    F.Parent = Eye

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1,0)
    Corner.Parent = F

    return F
end

-- Glow

local GlowOuter = MakeCircle(
    "GlowOuter",
    1.40,
    Color3.fromRGB(255,30,50),
    .90,
    150
)

local GlowMiddle = MakeCircle(
    "GlowMiddle",
    1.18,
    Color3.fromRGB(255,30,50),
    .80,
    151
)

local GlowInner = MakeCircle(
    "GlowInner",
    1.00,
    Color3.fromRGB(255,30,50),
    .70,
    152
)

-- Main eye

local EyeBase = MakeCircle(
    "EyeBase",
    .92,
    Color3.fromRGB(15,5,8),
    0,
    153
)

local EyeBaseStroke = Instance.new("UIStroke")
EyeBaseStroke.Thickness = 2
EyeBaseStroke.Color = Color3.fromRGB(255,40,50)
EyeBaseStroke.Parent = EyeBase

-- Rings

local RingOuter = MakeCircle(
    "RingOuter",
    .78,
    Color3.fromRGB(40,5,10),
    0,
    154
)

local RingOuterStroke = Instance.new("UIStroke")
RingOuterStroke.Thickness = 2
RingOuterStroke.Color = Color3.fromRGB(255,60,70)
RingOuterStroke.Parent = RingOuter

local RingMiddle = MakeCircle(
    "RingMiddle",
    .61,
    Color3.fromRGB(90,10,20),
    0,
    155
)

local RingMiddleStroke = Instance.new("UIStroke")
RingMiddleStroke.Thickness = 1.5
RingMiddleStroke.Color = Color3.fromRGB(255,100,100)
RingMiddleStroke.Parent = RingMiddle

local Iris = MakeCircle(
    "Iris",
    .45,
    Color3.fromRGB(180,20,30),
    0,
    156
)

local IrisStroke = Instance.new("UIStroke")
IrisStroke.Thickness = 1.5
IrisStroke.Color = Color3.fromRGB(255,150,150)
IrisStroke.Parent = Iris

local Inner = MakeCircle(
    "Inner",
    .29,
    Color3.fromRGB(40,3,7),
    0,
    157
)

local Pupil = MakeCircle(
    "Pupil",
    .15,
    Color3.fromRGB(0,0,0),
    0,
    158
)

local Core = MakeCircle(
    "Core",
    .045,
    Color3.fromRGB(255,255,255),
    0,
    159
)

--==============================================================
-- PROCEDURAL SYMBOL LAYERS
--==============================================================

local Symbol = Instance.new("Frame")
Symbol.Name = "Symbol"
Symbol.AnchorPoint = Vector2.new(.5,.5)
Symbol.Position = UDim2.fromScale(.5,.5)
Symbol.Size = UDim2.fromScale(.82,.82)
Symbol.BackgroundTransparency = 1
Symbol.ZIndex = 160
Symbol.Parent = Eye

local SymbolObjects = {}

local function ClearSymbol()

    for _,Obj in ipairs(SymbolObjects) do

        if Obj and Obj.Parent then
            Obj:Destroy()
        end

    end

    table.clear(SymbolObjects)
end

local function AddLine(angle,length,width,color)

    local L = Instance.new("Frame")

    L.AnchorPoint = Vector2.new(.5,.5)

    L.Position = UDim2.fromScale(.5,.5)

    L.Size = UDim2.new(
        0,
        length,
        0,
        width
    )

    L.Rotation = angle

    L.BackgroundColor3 = color
    L.BorderSizePixel = 0

    L.ZIndex = 161
    L.Parent = Symbol

    table.insert(SymbolObjects,L)

    return L
end

local function AddDot(x,y,size,color)

    local D = Instance.new("Frame")

    D.AnchorPoint = Vector2.new(.5,.5)

    D.Position = UDim2.fromScale(x,y)

    D.Size = UDim2.fromOffset(size,size)

    D.BackgroundColor3 = color
    D.BorderSizePixel = 0

    D.ZIndex = 162
    D.Parent = Symbol

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(1,0)
    C.Parent = D

    table.insert(SymbolObjects,D)

    return D
end

--==============================================================
-- EYE TYPES
--==============================================================

local EyeTypes = {

    -- 1
    {
        Name = "SHARINGAN",
        Color = Color3.fromRGB(255,35,45),
        Accent = Color3.fromRGB(30,0,0),
        Type = "TOMOE"
    },

    -- 2
    {
        Name = "RINNEGAN",
        Color = Color3.fromRGB(175,130,255),
        Accent = Color3.fromRGB(30,10,70),
        Type = "RINGS"
    },

    -- 3
    {
        Name = "MANGEKYO",
        Color = Color3.fromRGB(230,30,40),
        Accent = Color3.fromRGB(10,0,0),
        Type = "STAR"
    },

    -- 4
    {
        Name = "TRI-BLADE",
        Color = Color3.fromRGB(255,45,45),
        Accent = Color3.fromRGB(20,0,0),
        Type = "TRI"
    },

    -- 5
    {
        Name = "HEX",
        Color = Color3.fromRGB(255,75,35),
        Accent = Color3.fromRGB(25,0,0),
        Type = "HEX"
    },

    -- 6
    {
        Name = "SPIRAL",
        Color = Color3.fromRGB(245,40,60),
        Accent = Color3.fromRGB(30,0,15),
        Type = "SPIRAL"
    },

    -- 7
    {
        Name = "CRIMSON STAR",
        Color = Color3.fromRGB(255,20,30),
        Accent = Color3.fromRGB(0,0,0),
        Type = "STAR6"
    },

    -- 8
    {
        Name = "VOID",
        Color = Color3.fromRGB(90,70,120),
        Accent = Color3.fromRGB(5,5,10),
        Type = "VOID"
    },

    -- 9
    {
        Name = "TRIPLE",
        Color = Color3.fromRGB(220,35,55),
        Accent = Color3.fromRGB(15,0,0),
        Type = "TRIPLE"
    },

    -- 10
    {
        Name = "COSMIC",
        Color = Color3.fromRGB(80,170,255),
        Accent = Color3.fromRGB(15,30,70),
        Type = "COSMIC"
    },

    -- 11
    {
        Name = "BLACK STAR",
        Color = Color3.fromRGB(230,35,45),
        Accent = Color3.fromRGB(0,0,0),
        Type = "BLACKSTAR"
    },

    -- 12
    {
        Name = "RED RING",
        Color = Color3.fromRGB(255,55,40),
        Accent = Color3.fromRGB(30,0,0),
        Type = "RINGS"
    }
}

--==============================================================
-- BUILD SYMBOL
--==============================================================

local function BuildSymbol(Data)

    ClearSymbol()

    local C = Data.Color
    local A = Data.Accent

    if Data.Type == "TOMOE" then

        for i=1,3 do

            local Angle = (i-1)*120

            local D = AddDot(
                .5 + math.cos(math.rad(Angle))*0.27,
                .5 + math.sin(math.rad(Angle))*0.27,
                10,
                A
            )

            D.Rotation = Angle
        end

        for i=1,3 do

            local L = AddLine(
                (i-1)*120,
                22,
                5,
                A
            )

            L.Position = UDim2.fromScale(
                .5 + math.cos(math.rad((i-1)*120))*0.14,
                .5 + math.sin(math.rad((i-1)*120))*0.14
            )
        end

    elseif Data.Type == "RINGS" then

        for i=1,4 do

            local R = Instance.new("Frame")

            R.AnchorPoint = Vector2.new(.5,.5)
            R.Position = UDim2.fromScale(.5,.5)

            R.Size = UDim2.fromScale(
                .15 + i*.13,
                .15 + i*.13
            )

            R.BackgroundTransparency = 1
            R.BorderSizePixel = 0
            R.ZIndex = 161+i

            R.Parent = Symbol

            local S = Instance.new("UIStroke")

            S.Thickness = 1.5
            S.Color = A
            S.Parent = R

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(1,0)
            Corner.Parent = R

            table.insert(SymbolObjects,R)
        end

    elseif Data.Type == "STAR" then

        for i=1,6 do

            local L = AddLine(
                (i-1)*60,
                48,
                6,
                A
            )

            L.Position = UDim2.fromScale(.5,.5)
        end

    elseif Data.Type == "TRI" then

        for i=1,3 do

            local L = AddLine(
                (i-1)*120,
                43,
                7,
                A
            )

            L.Position = UDim2.fromScale(.5,.5)
        end

    elseif Data.Type == "HEX" then

        for i=1,6 do

            AddLine(
                (i-1)*60,
                45,
                5,
                A
            )
        end

        for i=1,6 do

            local Angle = math.rad((i-1)*60)

            AddDot(
                .5 + math.cos(Angle)*.25,
                .5 + math.sin(Angle)*.25,
                6,
                C
            )
        end

    elseif Data.Type == "SPIRAL" then

        for i=1,5 do

            local L = AddLine(
                i*32,
                30+i*3,
                4,
                A
            )

            L.Position = UDim2.fromScale(
                .5 + math.cos(math.rad(i*70))*.08,
                .5 + math.sin(math.rad(i*70))*.08
            )
        end

    elseif Data.Type == "STAR6" then

        for i=1,6 do

            local L = AddLine(
                (i-1)*60,
                52,
                9,
                A
            )

            L.Position = UDim2.fromScale(.5,.5)
        end

    elseif Data.Type == "VOID" then

        for i=1,8 do

            AddLine(
                (i-1)*45,
                42,
                3,
                C
            )

        end

    elseif Data.Type == "TRIPLE" then

        for i=1,3 do

            local Angle = math.rad((i-1)*120)

            local X =
                .5 + math.cos(Angle)*.20

            local Y =
                .5 + math.sin(Angle)*.20

            AddDot(X,Y,14,A)

            AddLine(
                (i-1)*120,
                30,
                6,
                A
            )
        end

    elseif Data.Type == "COSMIC" then

        for i=1,8 do

            local Angle = math.rad((i-1)*45)

            AddDot(
                .5 + math.cos(Angle)*.30,
                .5 + math.sin(Angle)*.30,
                5,
                C
            )

            AddLine(
                (i-1)*45,
                42,
                2,
                A
            )
        end

    elseif Data.Type == "BLACKSTAR" then

        for i=1,5 do

            AddLine(
                (i-1)*36,
                50,
                9,
                A
            )

        end

        for i=1,5 do

            local Angle = math.rad((i-1)*72)

            AddDot(
                .5 + math.cos(Angle)*.25,
                .5 + math.sin(Angle)*.25,
                8,
                C
            )

        end
    end
end

--==============================================================
-- COLOR MORPH
--==============================================================

local CurrentColor = Color3.fromRGB(255,35,45)
local CurrentAccent = Color3.fromRGB(30,0,0)

local function TweenColor(Object,Color,Time)

    if not Object then return end

    TweenService:Create(
        Object,
        TweenInfo.new(
            Time,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut
        ),
        {
            BackgroundColor3 = Color
        }
    ):Play()
end

local function ChangeEyeColor(Data)

    local Time = 1.8

    TweenColor(
        EyeBase,
        Data.Accent,
        Time
    )

    TweenColor(
        RingOuter,
        Data.Color,
        Time
    )

    TweenColor(
        RingMiddle,
        Data.Color,
        Time
    )

    TweenColor(
        Iris,
        Data.Color,
        Time
    )

    TweenColor(
        GlowOuter,
        Data.Color,
        Time
    )

    TweenColor(
        GlowMiddle,
        Data.Color,
        Time
    )

    TweenColor(
        GlowInner,
        Data.Color,
        Time
    )

    TweenService:Create(
        EyeBaseStroke,
        TweenInfo.new(Time),
        {
            Color = Data.Color
        }
    ):Play()

    TweenService:Create(
        RingOuterStroke,
        TweenInfo.new(Time),
        {
            Color = Data.Color
        }
    ):Play()

    TweenService:Create(
        RingMiddleStroke,
        TweenInfo.new(Time),
        {
            Color = Data.Color
        }
    ):Play()

    TweenService:Create(
        IrisStroke,
        TweenInfo.new(Time),
        {
            Color = Data.Color
        }
    ):Play()
end

--==============================================================
-- MORPH ANIMATION
--==============================================================

local CurrentType = 1
local Morphing = false
local EyeOpen = false

local function MorphTo(NewIndex)

    if Morphing then return end

    Morphing = true

    local NewData = EyeTypes[NewIndex]

    -- fase 1: eye pulse

    TweenService:Create(
        Eye,
        TweenInfo.new(
            .45,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut
        ),
        {
            Size = UDim2.fromScale(.70,.70)
        }
    ):Play()

    -- phase 2: rotate quickly

    local StartRotation = Symbol.Rotation

    local RotateTween = TweenService:Create(
        Symbol,
        TweenInfo.new(
            .8,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.InOut
        ),
        {
            Rotation = StartRotation + 180
        }
    )

    RotateTween:Play()

    -- color starts transitioning immediately

    ChangeEyeColor(NewData)

    task.wait(.35)

    -- fade old symbol

    for _,Obj in ipairs(SymbolObjects) do

        if Obj:IsA("Frame") then

            TweenService:Create(
                Obj,
                TweenInfo.new(
                    .55,
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.InOut
                ),
                {
                    BackgroundTransparency = 1
                }
            ):Play()

        end
    end

    task.wait(.35)

    BuildSymbol(NewData)

    -- reveal new symbol

    for _,Obj in ipairs(SymbolObjects) do

        if Obj:IsA("Frame") then

            Obj.BackgroundTransparency = 1

            TweenService:Create(
                Obj,
                TweenInfo.new(
                    .65,
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.Out
                ),
                {
                    BackgroundTransparency = 0
                }
            ):Play()

        end
    end

    TweenService:Create(
        Eye,
        TweenInfo.new(
            .65,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            Size = UDim2.fromScale(.82,.82)
        }
    ):Play()

    CurrentType = NewIndex

    task.wait(.75)

    Morphing = false
end

--==============================================================
-- AUTO MORPH LOOP
--==============================================================

local MorphThread

local function StartMorph()

    if MorphThread then return end

    MorphThread = task.spawn(function()

        while EyeOpen do

            task.wait(5)

            if not EyeOpen then
                break
            end

            local Next

            repeat

                Next = math.random(
                    1,
                    #EyeTypes
                )

            until Next ~= CurrentType

            MorphTo(Next)
        end

        MorphThread = nil
    end)
end

--==============================================================
-- EYE OPEN
--==============================================================

local function OpenEye()

    EyeOpen = true

    Toggle.TextTransparency = 1

    Eye.Visible = true

    Eye.Size = UDim2.fromScale(.02,.02)

    BuildSymbol(
        EyeTypes[CurrentType]
    )

    ChangeEyeColor(
        EyeTypes[CurrentType]
    )

    TweenService:Create(
        Eye,
        TweenInfo.new(
            .75,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            Size = UDim2.fromScale(.82,.82)
        }
    ):Play()

    StartMorph()
end

--==============================================================
-- EYE CLOSE
--==============================================================

local function CloseEye()

    EyeOpen = false

    TweenService:Create(
        Eye,
        TweenInfo.new(
            .65,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.In
        ),
        {
            Size = UDim2.fromScale(.02,.02)
        }
    ):Play()

    task.wait(.55)

    Eye.Visible = false

    Toggle.Text = "Z"

    TweenService:Create(
        Toggle,
        TweenInfo.new(
            .35,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            TextTransparency = 0
        }
    ):Play()
end

--==============================================================
-- MENU OPEN
--==============================================================

local MenuOpen = false

local function OpenMenu()

    if MenuOpen then return end

    MenuOpen = true

    Main.Visible = true

    Main.Size = UDim2.fromOffset(25,25)
    Main.BackgroundTransparency = 1

    OpenEye()

    TweenService:Create(
        Main,
        TweenInfo.new(
            .60,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            Size = UDim2.fromOffset(460,520),
            BackgroundTransparency = .08
        }
    ):Play()
end

--==============================================================
-- MENU CLOSE
--==============================================================

local function CloseMenu()

    if not MenuOpen then return end

    MenuOpen = false

    CloseEye()

    TweenService:Create(
        Main,
        TweenInfo.new(
            .40,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.In
        ),
        {
            Size = UDim2.fromOffset(25,25),
            BackgroundTransparency = 1
        }
    ):Play()

    task.delay(.42,function()

        if not MenuOpen then
            Main.Visible = false
        end

    end)
end

--==============================================================
-- BUTTON EVENTS
--==============================================================

Toggle.MouseButton1Click:Connect(function()

    if MenuOpen then
        CloseMenu()
    else
        OpenMenu()
    end

end)

Close.MouseButton1Click:Connect(function()

    CloseMenu()

end)

--==============================================================
-- MOBILE DRAG
--==============================================================

local Dragging = false
local DragStart
local StartPos

Toggle.InputBegan:Connect(function(Input)

    if Input.UserInputType == Enum.UserInputType.Touch
    or Input.UserInputType == Enum.UserInputType.MouseButton1 then

        Dragging = true

        DragStart = Input.Position
        StartPos = Toggle.Position

    end

end)

UserInputService.InputChanged:Connect(function(Input)

    if not Dragging then return end

    if Input.UserInputType == Enum.UserInputType.Touch
    or Input.UserInputType == Enum.UserInputType.MouseMovement then

        local Delta =
            Input.Position - DragStart

        Toggle.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + Delta.Y
        )

    end

end)

UserInputService.InputEnded:Connect(function(Input)

    if Input.UserInputType == Enum.UserInputType.Touch
    or Input.UserInputType == Enum.UserInputType.MouseButton1 then

        Dragging = false

    end

end)

--==============================================================
-- START
--==============================================================

task.wait(.25)

OpenMenu()

print("====================================")
print(" ZAKA PURE UI V1")
print(" EYE MORPH EDITION")
print(" 12 PROCEDURAL EYE STYLES")
print(" 5 SECOND AUTO MORPH")
print(" COLOR TRANSITION ENABLED")
print("====================================")
