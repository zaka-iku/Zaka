--============================================================--
-- ZAKA PURE UI V1
-- RAINBOW BORDER + ROTATING EYE MORPH
--============================================================--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--============================================================--
-- CLEAN
--============================================================--

local Old = PlayerGui:FindFirstChild("ZakaPureUI")
if Old then
    Old:Destroy()
end

--============================================================--
-- GUI
--============================================================--

local Gui = Instance.new("ScreenGui")
Gui.Name = "ZakaPureUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--============================================================--
-- TOGGLE
--============================================================--

local Toggle = Instance.new("TextButton")
Toggle.Name = "ToggleButton"
Toggle.Size = UDim2.fromOffset(64,64)
Toggle.Position = UDim2.new(0,18,0.42,0)
Toggle.AnchorPoint = Vector2.new(0,0.5)
Toggle.BackgroundColor3 = Color3.fromRGB(8,8,14)
Toggle.BorderSizePixel = 0
Toggle.Text = "Z"
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.TextSize = 30
Toggle.Font = Enum.Font.GothamBlack
Toggle.AutoButtonColor = false
Toggle.ZIndex = 100
Toggle.Parent = Gui

local TC = Instance.new("UICorner")
TC.CornerRadius = UDim.new(1,0)
TC.Parent = Toggle

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 2
ToggleStroke.Color = Color3.fromRGB(255,0,0)
ToggleStroke.Parent = Toggle

--============================================================--
-- MAIN
--============================================================--

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

local MC = Instance.new("UICorner")
MC.CornerRadius = UDim.new(0,18)
MC.Parent = Main

-- RAINBOW BORDER
local RainbowBorder = Instance.new("UIStroke")
RainbowBorder.Name = "RainbowBorder"
RainbowBorder.Thickness = 2.5
RainbowBorder.Transparency = 0
RainbowBorder.Parent = Main

--============================================================--
-- RAINBOW ENGINE
--============================================================--

local RainbowHue = 0
local RainbowConnection

RainbowConnection = RunService.RenderStepped:Connect(function(dt)

    RainbowHue = (RainbowHue + dt * 0.10) % 1

    local Color = Color3.fromHSV(
        RainbowHue,
        0.9,
        1
    )

    RainbowBorder.Color = Color

    ToggleStroke.Color = Color

end)

--============================================================--
-- HEADER
--============================================================--

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
Subtitle.Text = "V1 • RAINBOW EYE MORPH"
Subtitle.TextColor3 = Color3.fromRGB(150,145,175)
Subtitle.TextSize = 9
Subtitle.Font = Enum.Font.GothamBold
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(38,38)
Close.Position = UDim2.new(1,-48,0,12)
Close.BackgroundColor3 = Color3.fromRGB(30,25,40)
Close.BorderSizePixel = 0
Close.Text = "×"
Close.TextColor3 = Color3.new(1,1,1)
Close.TextSize = 25
Close.Font = Enum.Font.GothamBold
Close.AutoButtonColor = false
Close.Parent = Header

local CC = Instance.new("UICorner")
CC.CornerRadius = UDim.new(0,10)
CC.Parent = Close

--============================================================--
-- CONTENT
--============================================================--

local Content = Instance.new("Frame")
Content.Position = UDim2.fromOffset(14,75)
Content.Size = UDim2.new(1,-28,1,-88)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Banner = Instance.new("Frame")
Banner.Size = UDim2.new(1,0,0,60)
Banner.BackgroundColor3 = Color3.fromRGB(18,17,28)
Banner.BorderSizePixel = 0
Banner.Parent = Content

local BC = Instance.new("UICorner")
BC.CornerRadius = UDim.new(0,12)
BC.Parent = Banner

local BT = Instance.new("TextLabel")
BT.BackgroundTransparency = 1
BT.Position = UDim2.fromOffset(15,7)
BT.Size = UDim2.new(1,-30,0,22)
BT.Text = "ZAKA EYE SYSTEM"
BT.TextColor3 = Color3.new(1,1,1)
BT.TextSize = 14
BT.Font = Enum.Font.GothamBlack
BT.TextXAlignment = Enum.TextXAlignment.Left
BT.Parent = Banner

local BS = Instance.new("TextLabel")
BS.BackgroundTransparency = 1
BS.Position = UDim2.fromOffset(15,31)
BS.Size = UDim2.new(1,-30,0,18)
BS.Text = "Rotating • Morphing • Rainbow"
BS.TextColor3 = Color3.fromRGB(130,125,155)
BS.TextSize = 9
BS.Font = Enum.Font.Gotham
BS.TextXAlignment = Enum.TextXAlignment.Left
BS.Parent = Banner

--============================================================--
-- TABS
--============================================================--

local Tabs = Instance.new("Frame")
Tabs.Position = UDim2.fromOffset(0,70)
Tabs.Size = UDim2.new(1,0,0,40)
Tabs.BackgroundTransparency = 1
Tabs.Parent = Content

local TL = Instance.new("UIListLayout")
TL.FillDirection = Enum.FillDirection.Horizontal
TL.Padding = UDim.new(0,5)
TL.Parent = Tabs

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
    B.Parent = Tabs

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0,9)
    C.Parent = B

    B.MouseButton1Click:Connect(function()

        for _,X in ipairs(Tabs:GetChildren()) do

            if X:IsA("TextButton") then
                X.BackgroundColor3 = Color3.fromRGB(20,18,30)
                X.TextColor3 = Color3.fromRGB(180,175,205)
            end

        end

        B.BackgroundColor3 = Color3.fromRGB(70,50,145)
        B.TextColor3 = Color3.new(1,1,1)

    end)
end

--============================================================--
-- CARDS
--============================================================--

local Cards = Instance.new("Frame")
Cards.Position = UDim2.fromOffset(0,120)
Cards.Size = UDim2.new(1,0,1,-120)
Cards.BackgroundTransparency = 1
Cards.Parent = Content

local CL = Instance.new("UIListLayout")
CL.Padding = UDim.new(0,8)
CL.Parent = Cards

for _,Data in ipairs({
    {"AIM SYSTEM","Targeting interface"},
    {"ESP SYSTEM","Visual interface"},
    {"MOVEMENT","Movement controls"},
    {"WORLD","World settings"},
    {"SETTINGS","UI configuration"}
}) do

    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1,0,0,50)
    Card.BackgroundColor3 = Color3.fromRGB(17,16,27)
    Card.BorderSizePixel = 0
    Card.Parent = Cards

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
end

--============================================================--
-- EYE
--============================================================--

local Eye = Instance.new("Frame")
Eye.Name = "ZakaEye"
Eye.AnchorPoint = Vector2.new(.5,.5)
Eye.Position = UDim2.fromScale(.5,.5)
Eye.Size = UDim2.fromScale(.82,.82)
Eye.BackgroundTransparency = 1
Eye.Visible = false
Eye.ZIndex = 150
Eye.Parent = Toggle

--============================================================--
-- EYE ROTATION CONTAINERS
--============================================================--

local OuterSpin = Instance.new("Frame")
OuterSpin.Name = "OuterSpin"
OuterSpin.AnchorPoint = Vector2.new(.5,.5)
OuterSpin.Position = UDim2.fromScale(.5,.5)
OuterSpin.Size = UDim2.fromScale(1,1)
OuterSpin.BackgroundTransparency = 1
OuterSpin.ZIndex = 150
OuterSpin.Parent = Eye

local InnerSpin = Instance.new("Frame")
InnerSpin.Name = "InnerSpin"
InnerSpin.AnchorPoint = Vector2.new(.5,.5)
InnerSpin.Position = UDim2.fromScale(.5,.5)
InnerSpin.Size = UDim2.fromScale(1,1)
InnerSpin.BackgroundTransparency = 1
InnerSpin.ZIndex = 160
InnerSpin.Parent = Eye

local SymbolSpin = Instance.new("Frame")
SymbolSpin.Name = "SymbolSpin"
SymbolSpin.AnchorPoint = Vector2.new(.5,.5)
SymbolSpin.Position = UDim2.fromScale(.5,.5)
SymbolSpin.Size = UDim2.fromScale(1,1)
SymbolSpin.BackgroundTransparency = 1
SymbolSpin.ZIndex = 170
SymbolSpin.Parent = Eye

--============================================================--
-- CIRCLE CREATOR
--============================================================--

local function Circle(
    Parent,
    Name,
    Size,
    Color,
    Transparency,
    Z
)

    local F = Instance.new("Frame")

    F.Name = Name
    F.AnchorPoint = Vector2.new(.5,.5)
    F.Position = UDim2.fromScale(.5,.5)
    F.Size = UDim2.fromScale(Size,Size)

    F.BackgroundColor3 = Color
    F.BackgroundTransparency = Transparency or 0
    F.BorderSizePixel = 0
    F.ZIndex = Z or 150

    F.Parent = Parent

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(1,0)
    C.Parent = F

    return F
end

--============================================================--
-- GLOW
--============================================================--

local GlowOuter = Circle(
    OuterSpin,
    "GlowOuter",
    1.38,
    Color3.fromRGB(255,20,40),
    .90,
    150
)

local Glow = Circle(
    OuterSpin,
    "Glow",
    1.14,
    Color3.fromRGB(255,30,50),
    .78,
    151
)

--============================================================--
-- MAIN RINGS
--============================================================--

local Base = Circle(
    OuterSpin,
    "Base",
    .92,
    Color3.fromRGB(35,5,10),
    0,
    152
)

local BaseStroke = Instance.new("UIStroke")
BaseStroke.Thickness = 2
BaseStroke.Color = Color3.fromRGB(255,40,50)
BaseStroke.Parent = Base

local Ring1 = Circle(
    OuterSpin,
    "Ring1",
    .78,
    Color3.fromRGB(70,5,15),
    0,
    153
)

local Ring1Stroke = Instance.new("UIStroke")
Ring1Stroke.Thickness = 2
Ring1Stroke.Color = Color3.fromRGB(255,70,80)
Ring1Stroke.Parent = Ring1

local Ring2 = Circle(
    OuterSpin,
    "Ring2",
    .63,
    Color3.fromRGB(120,10,25),
    0,
    154
)

local Ring2Stroke = Instance.new("UIStroke")
Ring2Stroke.Thickness = 1.5
Ring2Stroke.Color = Color3.fromRGB(255,120,130)
Ring2Stroke.Parent = Ring2

--============================================================--
-- INNER IRIS
--============================================================--

local Iris = Circle(
    InnerSpin,
    "Iris",
    .47,
    Color3.fromRGB(210,25,40),
    0,
    160
)

local IrisStroke = Instance.new("UIStroke")
IrisStroke.Thickness = 2
IrisStroke.Color = Color3.fromRGB(255,150,160)
IrisStroke.Parent = Iris

local Inner = Circle(
    InnerSpin,
    "Inner",
    .30,
    Color3.fromRGB(35,2,5),
    0,
    161
)

local Pupil = Circle(
    InnerSpin,
    "Pupil",
    .14,
    Color3.fromRGB(0,0,0),
    0,
    162
)

local Core = Circle(
    InnerSpin,
    "Core",
    .045,
    Color3.fromRGB(255,255,255),
    0,
    163
)

--============================================================--
-- SYMBOL
--============================================================--

local Symbols = {}

local function ClearSymbols()

    for _,Obj in ipairs(Symbols) do

        if Obj and Obj.Parent then
            Obj:Destroy()
        end

    end

    table.clear(Symbols)
end

local function Dot(
    X,
    Y,
    Size,
    Color
)

    local D = Instance.new("Frame")

    D.AnchorPoint = Vector2.new(.5,.5)
    D.Position = UDim2.fromScale(X,Y)
    D.Size = UDim2.fromOffset(Size,Size)

    D.BackgroundColor3 = Color
    D.BorderSizePixel = 0
    D.ZIndex = 171
    D.Parent = SymbolSpin

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(1,0)
    C.Parent = D

    table.insert(Symbols,D)

    return D
end

local function Line(
    Angle,
    Length,
    Width,
    Color
)

    local L = Instance.new("Frame")

    L.AnchorPoint = Vector2.new(.5,.5)
    L.Position = UDim2.fromScale(.5,.5)

    L.Size = UDim2.fromOffset(
        Length,
        Width
    )

    L.Rotation = Angle

    L.BackgroundColor3 = Color
    L.BorderSizePixel = 0
    L.ZIndex = 171
    L.Parent = SymbolSpin

    table.insert(Symbols,L)

    return L
end

--============================================================--
-- EYE TYPES
--============================================================--

local EyeTypes = {

    {
        Name="SHARINGAN",
        Main=Color3.fromRGB(255,35,45),
        Dark=Color3.fromRGB(25,0,5),
        Accent=Color3.fromRGB(5,0,0),
        Type="TOMOE"
    },

    {
        Name="RINNEGAN",
        Main=Color3.fromRGB(175,125,255),
        Dark=Color3.fromRGB(35,15,70),
        Accent=Color3.fromRGB(10,0,25),
        Type="RINGS"
    },

    {
        Name="MANGEKYO",
        Main=Color3.fromRGB(235,25,40),
        Dark=Color3.fromRGB(30,0,5),
        Accent=Color3.fromRGB(0,0,0),
        Type="STAR"
    },

    {
        Name="TRI-BLADE",
        Main=Color3.fromRGB(255,55,45),
        Dark=Color3.fromRGB(35,0,5),
        Accent=Color3.fromRGB(0,0,0),
        Type="TRI"
    },

    {
        Name="CRIMSON",
        Main=Color3.fromRGB(255,20,30),
        Dark=Color3.fromRGB(20,0,0),
        Accent=Color3.fromRGB(0,0,0),
        Type="STAR6"
    },

    {
        Name="COSMIC",
        Main=Color3.fromRGB(70,170,255),
        Dark=Color3.fromRGB(10,30,70),
        Accent=Color3.fromRGB(0,10,30),
        Type="COSMIC"
    },

    {
        Name="VIOLET",
        Main=Color3.fromRGB(180,60,255),
        Dark=Color3.fromRGB(35,5,65),
        Accent=Color3.fromRGB(10,0,20),
        Type="HEX"
    },

    {
        Name="ORANGE",
        Main=Color3.fromRGB(255,100,25),
        Dark=Color3.fromRGB(50,15,0),
        Accent=Color3.fromRGB(15,3,0),
        Type="TRIPLE"
    },

    {
        Name="VOID",
        Main=Color3.fromRGB(110,100,140),
        Dark=Color3.fromRGB(8,8,15),
        Accent=Color3.fromRGB(0,0,0),
        Type="VOID"
    },

    {
        Name="CRAZY",
        Main=Color3.fromRGB(255,40,100),
        Dark=Color3.fromRGB(40,0,15),
        Accent=Color3.fromRGB(0,0,0),
        Type="SPIRAL"
    }
}

--============================================================--
-- BUILD EYE
--============================================================--

local function BuildEye(Data)

    ClearSymbols()

    local C = Data.Main
    local A = Data.Accent

    if Data.Type == "TOMOE" then

        for i=1,3 do

            local Angle =
                math.rad((i-1)*120)

            Dot(
                .5 + math.cos(Angle)*.28,
                .5 + math.sin(Angle)*.28,
                9,
                A
            )

            local Small =
                Line(
                    math.deg(Angle)+35,
                    19,
                    5,
                    A
                )

            Small.Position =
                UDim2.fromScale(
                    .5 + math.cos(Angle)*.18,
                    .5 + math.sin(Angle)*.18
                )
        end

    elseif Data.Type == "RINGS" then

        for i=1,4 do

            local R = Instance.new("Frame")

            R.AnchorPoint =
                Vector2.new(.5,.5)

            R.Position =
                UDim2.fromScale(.5,.5)

            local S =
                .18 + i*.12

            R.Size =
                UDim2.fromScale(S,S)

            R.BackgroundTransparency = 1
            R.ZIndex = 171+i
            R.Parent = SymbolSpin

            local St =
                Instance.new("UIStroke")

            St.Thickness = 1.4
            St.Color = A
            St.Parent = R

            local Co =
                Instance.new("UICorner")

            Co.CornerRadius =
                UDim.new(1,0)

            Co.Parent = R

            table.insert(Symbols,R)
        end

        for i=1,6 do

            local Angle =
                math.rad((i-1)*60)

            Dot(
                .5 + math.cos(Angle)*.31,
                .5 + math.sin(Angle)*.31,
                5,
                C
            )
        end

    elseif Data.Type == "STAR" then

        for i=1,6 do
            Line(
                (i-1)*60,
                50,
                7,
                A
            )
        end

    elseif Data.Type == "TRI" then

        for i=1,3 do

            Line(
                (i-1)*120,
                50,
                8,
                A
            )

        end

        for i=1,3 do

            local Angle =
                math.rad((i-1)*120)

            Dot(
                .5 + math.cos(Angle)*.24,
                .5 + math.sin(Angle)*.24,
                8,
                C
            )
        end

    elseif Data.Type == "STAR6" then

        for i=1,6 do

            Line(
                (i-1)*30,
                52,
                7,
                A
            )

        end

    elseif Data.Type == "COSMIC" then

        for i=1,8 do

            local Angle =
                math.rad((i-1)*45)

            Line(
                (i-1)*45,
                48,
                3,
                A
            )

            Dot(
                .5 + math.cos(Angle)*.29,
                .5 + math.sin(Angle)*.29,
                6,
                C
            )
        end

    elseif Data.Type == "HEX" then

        for i=1,6 do

            local Angle =
                math.rad((i-1)*60)

            Dot(
                .5 + math.cos(Angle)*.26,
                .5 + math.sin(Angle)*.26,
                8,
                A
            )

            Line(
                (i-1)*60,
                42,
                5,
                A
            )
        end

    elseif Data.Type == "TRIPLE" then

        for i=1,3 do

            local Angle =
                math.rad((i-1)*120)

            Line(
                (i-1)*120,
                45,
                9,
                A
            )

            Dot(
                .5 + math.cos(Angle)*.24,
                .5 + math.sin(Angle)*.24,
                12,
                C
            )
        end

    elseif Data.Type == "VOID" then

        for i=1,8 do

            Line(
                (i-1)*45,
                48,
                3,
                C
            )

        end

    elseif Data.Type == "SPIRAL" then

        for i=1,7 do

            local Angle =
                (i-1)*48

            local L =
                Line(
                    Angle,
                    20+i*4,
                    4,
                    A
                )

            L.Position =
                UDim2.fromScale(
                    .5 + math.cos(math.rad(Angle))*.10,
                    .5 + math.sin(math.rad(Angle))*.10
                )
        end
    end
end

--============================================================--
-- COLOR SET
--============================================================--

local function SetEyeColor(Data,Time)

    local Info =
        TweenInfo.new(
            Time,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut
        )

    TweenService:Create(
        Base,
        Info,
        {BackgroundColor3=Data.Dark}
    ):Play()

    TweenService:Create(
        Ring1,
        Info,
        {BackgroundColor3=Data.Dark}
    ):Play()

    TweenService:Create(
        Ring2,
        Info,
        {BackgroundColor3=Data.Main}
    ):Play()

    TweenService:Create(
        Iris,
        Info,
        {BackgroundColor3=Data.Main}
    ):Play()

    TweenService:Create(
        Glow,
        Info,
        {BackgroundColor3=Data.Main}
    ):Play()

    TweenService:Create(
        GlowOuter,
        Info,
        {BackgroundColor3=Data.Main}
    ):Play()

    TweenService:Create(
        BaseStroke,
        Info,
        {Color=Data.Main}
    ):Play()

    TweenService:Create(
        Ring1Stroke,
        Info,
        {Color=Data.Main}
    ):Play()

    TweenService:Create(
        Ring2Stroke,
        Info,
        {Color=Data.Main}
    ):Play()

    TweenService:Create(
        IrisStroke,
        Info,
        {Color=Data.Main}
    ):Play()
end

--============================================================--
-- CONTINUOUS ROTATION
--============================================================--

local EyeRotationConnection

local OuterAngle = 0
local InnerAngle = 0
local SymbolAngle = 0

local function StartEyeRotation()

    if EyeRotationConnection then
        EyeRotationConnection:Disconnect()
    end

    EyeRotationConnection =
        RunService.RenderStepped:Connect(function(dt)

            if not Eye.Visible then
                return
            end

            -- vòng ngoài
            OuterAngle =
                (OuterAngle + dt*22) % 360

            -- vòng trong ngược chiều
            InnerAngle =
                (InnerAngle - dt*34) % 360

            -- họa tiết quay nhanh hơn
            SymbolAngle =
                (SymbolAngle + dt*48) % 360

            OuterSpin.Rotation =
                OuterAngle

            InnerSpin.Rotation =
                InnerAngle

            SymbolSpin.Rotation =
                SymbolAngle

        end)
end

local function StopEyeRotation()

    if EyeRotationConnection then

        EyeRotationConnection:Disconnect()
        EyeRotationConnection = nil

    end
end

--============================================================--
-- MORPH
--============================================================--

local CurrentIndex = 1
local Morphing = false
local EyeOpen = false

local function MorphEye(NewIndex)

    if Morphing or not EyeOpen then
        return
    end

    Morphing = true

    local NewData =
        EyeTypes[NewIndex]

    --========================================================--
    -- PHASE 1
    -- XOAY MẠNH
    --========================================================--

    local Spin1 =
        TweenService:Create(
            Eye,
            TweenInfo.new(
                .22,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                Size=UDim2.fromScale(.86,.86)
            }
        )

    Spin1:Play()

    local RotationTween =
        TweenService:Create(
            SymbolSpin,
            TweenInfo.new(
                1.15,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ),
            {
                Rotation=
                    SymbolSpin.Rotation + 360
            }
        )

    RotationTween:Play()

    RotationTween.Completed:Wait()

    --========================================================--
    -- PHASE 2
    -- XOAY CHẬM LẠI
    --========================================================--

    TweenService:Create(
        Eye,
        TweenInfo.new(
            .35,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ),
        {
            Size=UDim2.fromScale(.80,.80)
        }
    ):Play()

    task.wait(.18)

    --========================================================--
    -- PHASE 3
    -- BẮT ĐẦU ĐỔI MÀU
    --========================================================--

    SetEyeColor(
        NewData,
        1.5
    )

    --========================================================--
    -- PHASE 4
    -- SYMBOL CŨ MỜ DẦN
    --========================================================--

    for _,Obj in ipairs(Symbols) do

        if Obj:IsA("Frame") then

            TweenService:Create(
                Obj,
                TweenInfo.new(
                    .8,
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.InOut
                ),
                {
                    BackgroundTransparency=1
                }
            ):Play()

        end
    end

    task.wait(.65)

    --========================================================--
    -- PHASE 5
    -- TẠO MẮT MỚI
    --========================================================--

    BuildEye(NewData)

    --========================================================--
    -- PHASE 6
    -- MẮT MỚI HIỆN DẦN
    --========================================================--

    for _,Obj in ipairs(Symbols) do

        if Obj:IsA("Frame") then

            Obj.BackgroundTransparency = 1

            TweenService:Create(
                Obj,
                TweenInfo.new(
                    .9,
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.Out
                ),
                {
                    BackgroundTransparency=0
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
            Size=UDim2.fromScale(.82,.82)
        }
    ):Play()

    CurrentIndex = NewIndex

    task.wait(.75)

    Morphing = false
end

--============================================================--
-- AUTO MORPH
--============================================================--

local MorphThread

local function StartMorph()

    if MorphThread then
        return
    end

    MorphThread =
        task.spawn(function()

            while EyeOpen do

                task.wait(5)

                if not EyeOpen then
                    break
                end

                local Next

                repeat

                    Next =
                        math.random(
                            1,
                            #EyeTypes
                        )

                until Next ~= CurrentIndex

                MorphEye(Next)

            end

            MorphThread = nil

        end)
end

--============================================================--
-- OPEN EYE
--============================================================--

local function OpenEye()

    EyeOpen = true

    Toggle.TextTransparency = 1

    Eye.Visible = true

    Eye.Size =
        UDim2.fromScale(.03,.03)

    BuildEye(
        EyeTypes[CurrentIndex]
    )

    SetEyeColor(
        EyeTypes[CurrentIndex],
        .1
    )

    StartEyeRotation()

    TweenService:Create(
        Eye,
        TweenInfo.new(
            .75,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            Size=UDim2.fromScale(.82,.82)
        }
    ):Play()

    StartMorph()
end

--============================================================--
-- CLOSE EYE
--============================================================--

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
            Size=UDim2.fromScale(.02,.02)
        }
    ):Play()

    task.wait(.55)

    StopEyeRotation()

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
            TextTransparency=0
        }
    ):Play()
end

--============================================================--
-- MENU
--============================================================--

local MenuOpen = false

local function OpenMenu()

    if MenuOpen then
        return
    end

    MenuOpen = true

    Main.Visible = true

    Main.Size =
        UDim2.fromOffset(20,20)

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
            Size=UDim2.fromOffset(460,520),
            BackgroundTransparency=.08
        }
    ):Play()
end

local function CloseMenu()

    if not MenuOpen then
        return
    end

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
            Size=UDim2.fromOffset(20,20),
            BackgroundTransparency=1
        }
    ):Play()

    task.delay(.42,function()

        if not MenuOpen then
            Main.Visible = false
        end

    end)
end

--============================================================--
-- EVENTS
--============================================================--

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

--============================================================--
-- MOBILE DRAG
--============================================================--

local Dragging = false
local DragStart
local StartPosition

Toggle.InputBegan:Connect(function(Input)

    if Input.UserInputType == Enum.UserInputType.Touch
    or Input.UserInputType == Enum.UserInputType.MouseButton1 then

        Dragging = true
        DragStart = Input.Position
        StartPosition = Toggle.Position

    end
end)

UserInputService.InputChanged:Connect(function(Input)

    if not Dragging then
        return
    end

    if Input.UserInputType == Enum.UserInputType.Touch
    or Input.UserInputType == Enum.UserInputType.MouseMovement then

        local Delta =
            Input.Position - DragStart

        Toggle.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,

            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )

    end
end)

UserInputService.InputEnded:Connect(function(Input)

    if Input.UserInputType == Enum.UserInputType.Touch
    or Input.UserInputType == Enum.UserInputType.MouseButton1 then

        Dragging = false

    end
end)

--============================================================--
-- START
--============================================================--

task.wait(.25)

OpenMenu()

print("================================")
print(" ZAKA PURE UI V1")
print(" RAINBOW BORDER")
print(" ROTATING EYE")
print(" SEQUENTIAL EYE MORPH")
print(" 10 EYE STYLES")
print("================================")
