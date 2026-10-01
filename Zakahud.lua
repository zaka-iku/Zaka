--========================================================--
-- ZAKA PURE UI V1
-- UI REBUILD - MENU + ANIME EYE
--========================================================--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- XÓA BẢN CŨ NẾU ĐANG CHẠY
local Old = PlayerGui:FindFirstChild("ZakaPureUI")
if Old then
    Old:Destroy()
end

--========================================================--
-- SCREEN GUI
--========================================================--

local Gui = Instance.new("ScreenGui")
Gui.Name = "ZakaPureUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--========================================================--
-- TOGGLE BUTTON
--========================================================--

local Toggle = Instance.new("TextButton")
Toggle.Name = "ToggleButton"
Toggle.Size = UDim2.fromOffset(64,64)
Toggle.Position = UDim2.new(0,18,0.42,0)
Toggle.AnchorPoint = Vector2.new(0,0.5)
Toggle.BackgroundColor3 = Color3.fromRGB(10,10,18)
Toggle.BackgroundTransparency = 0.08
Toggle.BorderSizePixel = 0
Toggle.Text = "Z"
Toggle.TextColor3 = Color3.fromRGB(255,255,255)
Toggle.TextSize = 30
Toggle.Font = Enum.Font.GothamBlack
Toggle.AutoButtonColor = false
Toggle.ZIndex = 50
Toggle.Parent = Gui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1,0)
ToggleCorner.Parent = Toggle

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 2
ToggleStroke.Color = Color3.fromRGB(100,80,255)
ToggleStroke.Transparency = 0.1
ToggleStroke.Parent = Toggle

--========================================================--
-- MAIN MENU
--========================================================--

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.Position = UDim2.new(0.5,0,0.5,0)
Main.Size = UDim2.fromOffset(0,0)
Main.BackgroundColor3 = Color3.fromRGB(9,9,16)
Main.BackgroundTransparency = 0.08
Main.BorderSizePixel = 0
Main.Visible = false
Main.ZIndex = 10
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,18)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(100,80,255)
MainStroke.Transparency = 0.25
MainStroke.Parent = Main

--========================================================--
-- HEADER
--========================================================--

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,62)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(20,8)
Title.Size = UDim2.new(1,-80,0,28)
Title.Text = "ZAKA PURE UI"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 21
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Sub = Instance.new("TextLabel")
Sub.BackgroundTransparency = 1
Sub.Position = UDim2.fromOffset(21,35)
Sub.Size = UDim2.new(1,-80,0,20)
Sub.Text = "V1 • MOBILE EDITION"
Sub.TextColor3 = Color3.fromRGB(145,135,210)
Sub.TextSize = 10
Sub.Font = Enum.Font.GothamBold
Sub.TextXAlignment = Enum.TextXAlignment.Left
Sub.Parent = Header

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(38,38)
Close.Position = UDim2.new(1,-48,0,12)
Close.BackgroundColor3 = Color3.fromRGB(35,25,45)
Close.BackgroundTransparency = 0.1
Close.BorderSizePixel = 0
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.TextSize = 25
Close.Font = Enum.Font.GothamBold
Close.AutoButtonColor = false
Close.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0,10)
CloseCorner.Parent = Close

--========================================================--
-- CONTENT
--========================================================--

local Content = Instance.new("Frame")
Content.Position = UDim2.fromOffset(14,72)
Content.Size = UDim2.new(1,-28,1,-86)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1,0,0,55)
Info.BackgroundColor3 = Color3.fromRGB(20,18,32)
Info.BackgroundTransparency = 0.15
Info.BorderSizePixel = 0
Info.Text = "  ZAKA MENU\n  UI REBUILD V1"
Info.TextColor3 = Color3.fromRGB(225,220,255)
Info.TextSize = 15
Info.Font = Enum.Font.GothamBold
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.Parent = Content

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0,12)
InfoCorner.Parent = Info

--========================================================--
-- TABS
--========================================================--

local Tabs = {
    "COMBAT",
    "VISUAL",
    "PLAYER",
    "WORLD",
    "TROLL"
}

local TabContainer = Instance.new("Frame")
TabContainer.Position = UDim2.fromOffset(0,68)
TabContainer.Size = UDim2.new(1,0,0,42)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Content

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0,5)
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabLayout.Parent = TabContainer

for _,Name in ipairs(Tabs) do

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.fromOffset(76,38)
    Button.BackgroundColor3 = Color3.fromRGB(22,20,34)
    Button.BorderSizePixel = 0
    Button.Text = Name
    Button.TextColor3 = Color3.fromRGB(185,180,210)
    Button.TextSize = 10
    Button.Font = Enum.Font.GothamBold
    Button.AutoButtonColor = false
    Button.Parent = TabContainer

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0,9)
    C.Parent = Button

    Button.MouseButton1Click:Connect(function()

        for _,Obj in ipairs(TabContainer:GetChildren()) do
            if Obj:IsA("TextButton") then
                Obj.BackgroundColor3 = Color3.fromRGB(22,20,34)
                Obj.TextColor3 = Color3.fromRGB(185,180,210)
            end
        end

        Button.BackgroundColor3 = Color3.fromRGB(75,55,145)
        Button.TextColor3 = Color3.fromRGB(255,255,255)
    end)
end

--========================================================--
-- FEATURE CARDS
--========================================================--

local FeatureContainer = Instance.new("Frame")
FeatureContainer.Position = UDim2.fromOffset(0,120)
FeatureContainer.Size = UDim2.new(1,0,1,-120)
FeatureContainer.BackgroundTransparency = 1
FeatureContainer.Parent = Content

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,8)
Layout.Parent = FeatureContainer

local Features = {
    {"AIM SYSTEM","Combat interface"},
    {"ESP SYSTEM","Visual interface"},
    {"MOVEMENT","Player controls"},
    {"WORLD","World controls"},
    {"SETTINGS","UI configuration"},
}

for _,Data in ipairs(Features) do

    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1,0,0,52)
    Card.BackgroundColor3 = Color3.fromRGB(18,17,28)
    Card.BackgroundTransparency = 0.05
    Card.BorderSizePixel = 0
    Card.Parent = FeatureContainer

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0,12)
    Corner.Parent = Card

    local Name = Instance.new("TextLabel")
    Name.BackgroundTransparency = 1
    Name.Position = UDim2.fromOffset(15,6)
    Name.Size = UDim2.new(1,-80,0,20)
    Name.Text = Data[1]
    Name.TextColor3 = Color3.fromRGB(240,240,255)
    Name.TextSize = 13
    Name.Font = Enum.Font.GothamBold
    Name.TextXAlignment = Enum.TextXAlignment.Left
    Name.Parent = Card

    local Desc = Instance.new("TextLabel")
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.fromOffset(15,27)
    Desc.Size = UDim2.new(1,-80,0,18)
    Desc.Text = Data[2]
    Desc.TextColor3 = Color3.fromRGB(125,120,150)
    Desc.TextSize = 9
    Desc.Font = Enum.Font.Gotham
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.Parent = Card

    local Arrow = Instance.new("TextLabel")
    Arrow.BackgroundTransparency = 1
    Arrow.Position = UDim2.new(1,-42,0,10)
    Arrow.Size = UDim2.fromOffset(30,30)
    Arrow.Text = "›"
    Arrow.TextColor3 = Color3.fromRGB(130,110,255)
    Arrow.TextSize = 25
    Arrow.Font = Enum.Font.GothamBold
    Arrow.Parent = Card
end

--========================================================--
-- ANIME EYE
--========================================================--

local Eye = Instance.new("Frame")
Eye.Name = "ZakaEye"
Eye.AnchorPoint = Vector2.new(0.5,0.5)
Eye.Position = UDim2.fromScale(0.5,0.5)
Eye.Size = UDim2.fromScale(0.82,0.82)
Eye.BackgroundTransparency = 1
Eye.Visible = false
Eye.ZIndex = 100
Eye.Parent = Toggle

local function Circle(Name,Size,Color,Transparency,Z)

    local F = Instance.new("Frame")
    F.Name = Name
    F.AnchorPoint = Vector2.new(0.5,0.5)
    F.Position = UDim2.fromScale(0.5,0.5)
    F.Size = UDim2.fromScale(Size,Size)
    F.BackgroundColor3 = Color
    F.BackgroundTransparency = Transparency or 0
    F.BorderSizePixel = 0
    F.ZIndex = Z or 100
    F.Parent = Eye

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(1,0)
    C.Parent = F

    return F
end

-- glow
local Glow1 = Circle(
    "GlowOuter",
    1.35,
    Color3.fromRGB(80,40,255),
    0.88,
    100
)

local Glow2 = Circle(
    "Glow",
    1.12,
    Color3.fromRGB(100,60,255),
    0.76,
    101
)

-- outer eye
local Outer = Circle(
    "OuterRing",
    0.92,
    Color3.fromRGB(15,10,30),
    0,
    102
)

local OuterStroke = Instance.new("UIStroke")
OuterStroke.Thickness = 2
OuterStroke.Color = Color3.fromRGB(145,100,255)
OuterStroke.Parent = Outer

-- second ring
local Ring2 = Circle(
    "Ring2",
    0.76,
    Color3.fromRGB(55,25,100),
    0,
    103
)

local Ring2Stroke = Instance.new("UIStroke")
Ring2Stroke.Thickness = 2
Ring2Stroke.Color = Color3.fromRGB(100,55,220)
Ring2Stroke.Parent = Ring2

-- iris
local Iris = Circle(
    "Iris",
    0.58,
    Color3.fromRGB(95,40,180),
    0,
    104
)

local IrisStroke = Instance.new("UIStroke")
IrisStroke.Thickness = 2
IrisStroke.Color = Color3.fromRGB(180,100,255)
IrisStroke.Parent = Iris

-- inner
local Inner = Circle(
    "Inner",
    0.40,
    Color3.fromRGB(25,8,50),
    0,
    105
)

-- pupil
local Pupil = Circle(
    "Pupil",
    0.20,
    Color3.fromRGB(0,0,0),
    0,
    106
)

-- core
local Core = Circle(
    "Core",
    0.075,
    Color3.fromRGB(255,255,255),
    0.05,
    107
)

--========================================================--
-- TOMOE / ORBIT DOTS
--========================================================--

local Orbit = Instance.new("Frame")
Orbit.Name = "TomoeOrbit"
Orbit.AnchorPoint = Vector2.new(0.5,0.5)
Orbit.Position = UDim2.fromScale(0.5,0.5)
Orbit.Size = UDim2.fromScale(0.82,0.82)
Orbit.BackgroundTransparency = 1
Orbit.ZIndex = 108
Orbit.Parent = Eye

local Dots = {}

for i = 1,6 do

    local Dot = Instance.new("Frame")
    Dot.Name = "Tomoe"..i
    Dot.AnchorPoint = Vector2.new(0.5,0.5)
    Dot.Size = UDim2.fromOffset(6,6)
    Dot.BackgroundColor3 = Color3.fromRGB(235,210,255)
    Dot.BorderSizePixel = 0
    Dot.ZIndex = 109
    Dot.Parent = Orbit

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(1,0)
    C.Parent = Dot

    table.insert(Dots,Dot)
end

--========================================================--
-- EYE ROTATION
--========================================================--

local Rotation = 0
local RotationConnection

local function StartRotation()

    if RotationConnection then
        RotationConnection:Disconnect()
    end

    RotationConnection = RunService.RenderStepped:Connect(function(dt)

        Rotation += dt * 70

        Orbit.Rotation = Rotation
        Ring2.Rotation = -Rotation * 0.35
        Iris.Rotation = Rotation * 0.55

        for i,Dot in ipairs(Dots) do

            local Angle = math.rad((i-1)*60 + Rotation)
            local Radius = 0.29

            Dot.Position = UDim2.fromScale(
                0.5 + math.cos(Angle)*Radius,
                0.5 + math.sin(Angle)*Radius
            )
        end
    end)
end

local function StopRotation()

    if RotationConnection then
        RotationConnection:Disconnect()
        RotationConnection = nil
    end
end

--========================================================--
-- OPEN ANIMATION
--========================================================--

local Open = false

local function OpenMenu()

    if Open then return end
    Open = true

    Toggle.TextTransparency = 1
    Eye.Visible = true

    Eye.Size = UDim2.fromScale(0.05,0.05)

    Main.Visible = true
    Main.Size = UDim2.fromOffset(20,20)
    Main.BackgroundTransparency = 1

    TweenService:Create(
        Eye,
        TweenInfo.new(
            0.55,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            Size = UDim2.fromScale(0.82,0.82)
        }
    ):Play()

    TweenService:Create(
        Main,
        TweenInfo.new(
            0.55,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            Size = UDim2.fromOffset(460,520),
            BackgroundTransparency = 0.08
        }
    ):Play()

    StartRotation()
end

--========================================================--
-- CLOSE ANIMATION
--========================================================--

local function CloseMenu()

    if not Open then return end
    Open = false

    local EyeTween = TweenService:Create(
        Eye,
        TweenInfo.new(
            0.5,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.In
        ),
        {
            Size = UDim2.fromScale(0.03,0.03)
        }
    )

    local MenuTween = TweenService:Create(
        Main,
        TweenInfo.new(
            0.35,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.In
        ),
        {
            Size = UDim2.fromOffset(20,20),
            BackgroundTransparency = 1
        }
    )

    EyeTween:Play()
    MenuTween:Play()

    EyeTween.Completed:Connect(function()

        StopRotation()

        Eye.Visible = false

        -- MẮT BIẾN THÀNH Z
        Toggle.Text = "Z"

        TweenService:Create(
            Toggle,
            TweenInfo.new(
                0.28,
                Enum.EasingStyle.Back,
                Enum.EasingDirection.Out
            ),
            {
                TextTransparency = 0
            }
        ):Play()
    end)

    MenuTween.Completed:Connect(function()

        if not Open then
            Main.Visible = false
        end
    end)
end

--========================================================--
-- BUTTON
--========================================================--

Toggle.MouseButton1Click:Connect(function()

    if Open then
        CloseMenu()
    else
        OpenMenu()
    end
end)

Close.MouseButton1Click:Connect(function()
    CloseMenu()
end)

--========================================================--
-- DRAG MOBILE
--========================================================--

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

    if not Dragging then return end

    if Input.UserInputType == Enum.UserInputType.Touch
    or Input.UserInputType == Enum.UserInputType.MouseMovement then

        local Delta = Input.Position - DragStart

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

--========================================================--
-- START
--========================================================--

task.wait(0.25)
OpenMenu()

print("ZAKA PURE UI V1 LOADED")
