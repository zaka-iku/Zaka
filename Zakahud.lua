--==============================================================
-- ZAKA PINK PANTHER • DROP-FLOWER MENU V2
-- Roblox Delta Mobile / CLIENT UI
-- MENU ONLY — gameplay functions intentionally not connected.
--
-- CORE CONCEPT
--   CLOSED:
--      a small pink droplet lives at the flower's center.
--
--   OPEN:
--      the droplet stretches, bends and "spills" outward.
--      the curved glass menu grows from that droplet.
--      the Pink Panther holding the flower is the visual frame.
--      the flower center remains the menu close/open core.
--
--   CLOSE:
--      content contracts toward the flower center,
--      the curved menu is sucked inward,
--      then becomes a thin droplet and disappears.
--
-- The UI is intentionally built as many layers rather than a
-- single square frame. This makes later replacement of the
-- curved silhouette easier without rewriting the tab system.
--==============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local GUI_NAME = "ZAKA_PINK_PANTHER_DROP_FLOWER"

local old = PlayerGui:FindFirstChild(GUI_NAME)
if old then
    old:Destroy()
end

--==============================================================
-- THEME
--==============================================================

local Theme = {
    Pink = Color3.fromRGB(246, 137, 178),
    PinkLight = Color3.fromRGB(255, 177, 205),
    PinkDark = Color3.fromRGB(190, 42, 105),
    White = Color3.fromRGB(255, 255, 255),
    Ink = Color3.fromRGB(73, 24, 50),
    Glass = Color3.fromRGB(255, 150, 190),
    GlassDark = Color3.fromRGB(120, 34, 75),
}

local OpenInfo = TweenInfo.new(
    0.68,
    Enum.EasingStyle.Quint,
    Enum.EasingDirection.Out
)

local CloseInfo = TweenInfo.new(
    0.58,
    Enum.EasingStyle.Quint,
    Enum.EasingDirection.In
)

local SoftInfo = TweenInfo.new(
    0.30,
    Enum.EasingStyle.Quint,
    Enum.EasingDirection.Out
)

local function tween(object, info, properties)
    local t = TweenService:Create(object, info, properties)
    t:Play()
    return t
end

local function corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = object
    return c
end

local function round(object)
    return corner(object, 999)
end

local function outline(object, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = object
    return s
end

local function label(parent, text, size, color, font)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextSize = size or 12
    l.TextColor3 = color or Theme.White
    l.Font = font or Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

--==============================================================
-- ASSET LOADER
--==============================================================

local function getAsset(name)
    if typeof(getcustomasset) ~= "function" then
        return ""
    end

    local ok, result = pcall(getcustomasset, name)
    if ok and result then
        return result
    end

    ok, result = pcall(getcustomasset, "./" .. name)
    if ok and result then
        return result
    end

    return ""
end

local BackgroundAsset = getAsset("PinkPanther_Background.jpg")
local PantherAsset = getAsset("PinkPanther_Character.jpg")

--==============================================================
-- ROOT
--==============================================================

local GUI = Instance.new("ScreenGui")
GUI.Name = GUI_NAME
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.Parent = PlayerGui

local Scale = Instance.new("UIScale")
Scale.Scale = 1
Scale.Parent = GUI

local function updateScale()
    local camera = workspace.CurrentCamera
    if not camera then
        return
    end

    local viewport = camera.ViewportSize
    local factor = math.min(
        viewport.X / 780,
        viewport.Y / 560
    )

    Scale.Scale = math.clamp(factor, 0.62, 1)
end

updateScale()

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

--==============================================================
-- CLOSED STATE
--==============================================================

local ClosedLayer = Instance.new("Frame")
ClosedLayer.Name = "ClosedFlowerLayer"
ClosedLayer.Size = UDim2.fromScale(1, 1)
ClosedLayer.BackgroundTransparency = 1
ClosedLayer.Parent = GUI

-- Pink background flash
local PinkFlash = Instance.new("Frame")
PinkFlash.Size = UDim2.fromScale(1, 1)
PinkFlash.BackgroundColor3 = Theme.Pink
PinkFlash.BackgroundTransparency = 0
PinkFlash.Parent = ClosedLayer

local RainbowStroke = Instance.new("UIStroke")
RainbowStroke.Thickness = 5
RainbowStroke.Parent = PinkFlash

-- Large Z
local Z = Instance.new("TextButton")
Z.Name = "ZButton"
Z.AnchorPoint = Vector2.new(0.5, 0.5)
Z.Position = UDim2.fromScale(0.5, 0.5)
Z.Size = UDim2.fromOffset(170, 170)
Z.BackgroundTransparency = 1
Z.Text = "Z"
Z.TextColor3 = Theme.White
Z.TextSize = 135
Z.Font = Enum.Font.GothamBlack
Z.AutoButtonColor = false
Z.Parent = ClosedLayer

-- Closed droplet
local ClosedDrop = Instance.new("Frame")
ClosedDrop.Name = "ClosedDrop"
ClosedDrop.AnchorPoint = Vector2.new(0.5, 0.5)
ClosedDrop.Position = UDim2.fromScale(0.5, 0.5)
ClosedDrop.Size = UDim2.fromOffset(14, 14)
ClosedDrop.BackgroundColor3 = Theme.PinkLight
ClosedDrop.BackgroundTransparency = 0.02
ClosedDrop.Visible = false
ClosedDrop.Parent = ClosedLayer
round(ClosedDrop)
outline(ClosedDrop, Theme.White, 2, 0.20)

--==============================================================
-- MAIN MENU
--==============================================================

local Menu = Instance.new("Frame")
Menu.Name = "PantherFlowerMenu"
Menu.AnchorPoint = Vector2.new(0.5, 0.5)
Menu.Position = UDim2.fromScale(0.5, 0.5)
Menu.Size = UDim2.fromOffset(760, 540)
Menu.BackgroundTransparency = 1
Menu.Visible = false
Menu.Parent = GUI

local MenuScale = Instance.new("UIScale")
MenuScale.Scale = 0.08
MenuScale.Parent = Menu

-- A layered curved/glass body.
-- Each plate overlaps to approximate the Panther/flower contour.
local BodyBack = Instance.new("Frame")
BodyBack.Name = "CurvedBodyBack"
BodyBack.AnchorPoint = Vector2.new(0.5, 0.5)
BodyBack.Position = UDim2.fromScale(0.5, 0.52)
BodyBack.Size = UDim2.fromOffset(710, 500)
BodyBack.BackgroundColor3 = Theme.Pink
BodyBack.BackgroundTransparency = 0.33
BodyBack.Parent = Menu
corner(BodyBack, 115)
outline(BodyBack, Theme.PinkDark, 7, 0.04)

local BodyTop = Instance.new("Frame")
BodyTop.Name = "CurvedTop"
BodyTop.AnchorPoint = Vector2.new(0.5, 0.5)
BodyTop.Position = UDim2.fromScale(0.50, 0.24)
BodyTop.Size = UDim2.fromOffset(550, 260)
BodyTop.BackgroundColor3 = Theme.PinkLight
BodyTop.BackgroundTransparency = 0.62
BodyTop.Parent = Menu
round(BodyTop)
outline(BodyTop, Theme.White, 2, 0.72)

local BodyBottom = Instance.new("Frame")
BodyBottom.Name = "CurvedBottom"
BodyBottom.AnchorPoint = Vector2.new(0.5, 0.5)
BodyBottom.Position = UDim2.fromScale(0.50, 0.76)
BodyBottom.Size = UDim2.fromOffset(570, 260)
BodyBottom.BackgroundColor3 = Theme.Pink
BodyBottom.BackgroundTransparency = 0.65
BodyBottom.Parent = Menu
round(BodyBottom)

-- Image reference layer
local Panther = Instance.new("ImageLabel")
Panther.Name = "PantherHoldingFlower"
Panther.AnchorPoint = Vector2.new(0.5, 0.5)
Panther.Position = UDim2.fromScale(0.5, 0.56)
Panther.Size = UDim2.fromScale(0.74, 0.84)
Panther.BackgroundTransparency = 1
Panther.Image = PantherAsset
Panther.ImageTransparency = PantherAsset == "" and 1 or 0.44
Panther.ScaleType = Enum.ScaleType.Fit
Panther.Parent = Menu

-- Background artwork
local Artwork = Instance.new("ImageLabel")
Artwork.Name = "PantherBackgroundArtwork"
Artwork.AnchorPoint = Vector2.new(0.5, 0.5)
Artwork.Position = UDim2.fromScale(0.5, 0.5)
Artwork.Size = UDim2.fromScale(0.97, 0.95)
Artwork.BackgroundTransparency = 1
Artwork.Image = BackgroundAsset
Artwork.ImageTransparency = BackgroundAsset == "" and 1 or 0.70
Artwork.ScaleType = Enum.ScaleType.Crop
Artwork.ZIndex = 2
Artwork.Parent = Menu
corner(Artwork, 105)

-- Pink glass overlay
local Glass = Instance.new("Frame")
Glass.Name = "PinkGlass"
Glass.AnchorPoint = Vector2.new(0.5, 0.5)
Glass.Position = UDim2.fromScale(0.5, 0.5)
Glass.Size = UDim2.fromScale(0.94, 0.91)
Glass.BackgroundColor3 = Theme.Glass
Glass.BackgroundTransparency = 0.50
Glass.ZIndex = 3
Glass.Parent = Menu
corner(Glass, 100)
outline(Glass, Theme.White, 2, 0.72)

--==============================================================
-- CURVED SIDE MASKS / DECOR
--==============================================================

local LeftCurve = Instance.new("Frame")
LeftCurve.Name = "LeftCurve"
LeftCurve.AnchorPoint = Vector2.new(0.5, 0.5)
LeftCurve.Position = UDim2.fromScale(0.15, 0.53)
LeftCurve.Size = UDim2.fromOffset(190, 390)
LeftCurve.BackgroundColor3 = Theme.Pink
LeftCurve.BackgroundTransparency = 0.58
LeftCurve.Rotation = -9
LeftCurve.ZIndex = 5
LeftCurve.Parent = Menu
corner(LeftCurve, 90)
outline(LeftCurve, Theme.PinkDark, 2, 0.45)

local RightCurve = Instance.new("Frame")
RightCurve.Name = "RightCurve"
RightCurve.AnchorPoint = Vector2.new(0.5, 0.5)
RightCurve.Position = UDim2.fromScale(0.85, 0.53)
RightCurve.Size = UDim2.fromOffset(190, 390)
RightCurve.BackgroundColor3 = Theme.Pink
RightCurve.BackgroundTransparency = 0.58
RightCurve.Rotation = 9
RightCurve.ZIndex = 5
RightCurve.Parent = Menu
corner(RightCurve, 90)
outline(RightCurve, Theme.PinkDark, 2, 0.45)

--==============================================================
-- HEADER
--==============================================================

local Header = label(
    Menu,
    "PINK PANTHER",
    24,
    Theme.White,
    Enum.Font.GothamBlack
)
Header.AnchorPoint = Vector2.new(0.5, 0)
Header.Position = UDim2.fromScale(0.5, 0.045)
Header.Size = UDim2.fromOffset(340, 32)
Header.TextXAlignment = Enum.TextXAlignment.Center
Header.ZIndex = 30

local HeaderSub = label(
    Menu,
    "ZAKA • DROP FLOWER EDITION",
    9,
    Theme.Ink,
    Enum.Font.GothamBold
)
HeaderSub.AnchorPoint = Vector2.new(0.5, 0)
HeaderSub.Position = UDim2.fromScale(0.5, 0.105)
HeaderSub.Size = UDim2.fromOffset(300, 18)
HeaderSub.TextXAlignment = Enum.TextXAlignment.Center
HeaderSub.ZIndex = 30

--==============================================================
-- FLOWER CENTER / OPEN-CLOSE CORE
--==============================================================

local Flower = Instance.new("Frame")
Flower.Name = "FlowerCenter"
Flower.AnchorPoint = Vector2.new(0.5, 0.5)
Flower.Position = UDim2.fromScale(0.5, 0.55)
Flower.Size = UDim2.fromOffset(205, 205)
Flower.BackgroundColor3 = Theme.Pink
Flower.BackgroundTransparency = 0.16
Flower.ZIndex = 45
Flower.Parent = Menu
round(Flower)
outline(Flower, Theme.White, 3, 0.28)

local PetalHolder = Instance.new("Frame")
PetalHolder.Name = "Petals"
PetalHolder.AnchorPoint = Vector2.new(0.5, 0.5)
PetalHolder.Position = UDim2.fromScale(0.5, 0.5)
PetalHolder.Size = UDim2.fromScale(0.90, 0.90)
PetalHolder.BackgroundTransparency = 1
PetalHolder.ZIndex = 46
PetalHolder.Parent = Flower

for i = 1, 8 do
    local petal = Instance.new("Frame")
    petal.Name = "Petal" .. i
    petal.AnchorPoint = Vector2.new(0.5, 1)
    petal.Position = UDim2.fromScale(0.5, 0.5)
    petal.Size = UDim2.fromOffset(38, 88)
    petal.BackgroundColor3 = i % 2 == 0 and Theme.PinkLight or Theme.Pink
    petal.BackgroundTransparency = 0.25
    petal.Rotation = (i - 1) * 45
    petal.ZIndex = 46
    petal.Parent = PetalHolder
    corner(petal, 999)
    outline(petal, Theme.White, 1.5, 0.60)
end

-- Central rotating Panther.
local CenterPanther = Instance.new("ImageLabel")
CenterPanther.Name = "RotatingPanther"
CenterPanther.AnchorPoint = Vector2.new(0.5, 0.5)
CenterPanther.Position = UDim2.fromScale(0.5, 0.5)
CenterPanther.Size = UDim2.fromScale(0.72, 0.72)
CenterPanther.BackgroundTransparency = 1
CenterPanther.Image = PantherAsset
CenterPanther.ImageTransparency = PantherAsset == "" and 1 or 0.08
CenterPanther.ScaleType = Enum.ScaleType.Fit
CenterPanther.ZIndex = 50
CenterPanther.Parent = Flower

local CoreRing = Instance.new("Frame")
CoreRing.Name = "CoreRing"
CoreRing.AnchorPoint = Vector2.new(0.5, 0.5)
CoreRing.Position = UDim2.fromScale(0.5, 0.5)
CoreRing.Size = UDim2.fromScale(0.91, 0.91)
CoreRing.BackgroundTransparency = 1
CoreRing.ZIndex = 52
CoreRing.Parent = Flower
round(CoreRing)
outline(CoreRing, Theme.White, 2, 0.40)

local CoreHint = label(
    Flower,
    "TẠM ĐÓNG",
    8,
    Theme.White,
    Enum.Font.GothamBold
)
CoreHint.AnchorPoint = Vector2.new(0.5, 1)
CoreHint.Position = UDim2.fromScale(0.5, 0.97)
CoreHint.Size = UDim2.fromOffset(90, 18)
CoreHint.TextXAlignment = Enum.TextXAlignment.Center
CoreHint.ZIndex = 55

task.spawn(function()
    while GUI.Parent do
        if Menu.Visible then
            CenterPanther.Rotation += 0.65
            PetalHolder.Rotation -= 0.15
        end
        task.wait()
    end
end)

--==============================================================
-- TABS
--==============================================================

local TabHolder = Instance.new("Frame")
TabHolder.Name = "CurvedTabs"
TabHolder.BackgroundTransparency = 1
TabHolder.Position = UDim2.fromOffset(30, 125)
TabHolder.Size = UDim2.fromOffset(190, 300)
TabHolder.ZIndex = 60
TabHolder.Parent = Menu

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 7)
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.Parent = TabHolder

local Tabs = {
    "HOME",
    "COMBAT",
    "VISUAL",
    "PLAYER",
    "WORLD",
    "SETTINGS",
}

local TabButtons = {}
local ActiveTab = nil

-- Little Panther feedback
local TabPanther = Instance.new("ImageLabel")
TabPanther.Name = "TabPanther"
TabPanther.BackgroundTransparency = 1
TabPanther.Image = PantherAsset
TabPanther.ImageTransparency = PantherAsset == "" and 1 or 0.03
TabPanther.Size = UDim2.fromOffset(54, 54)
TabPanther.Visible = false
TabPanther.ZIndex = 90
TabPanther.Parent = Menu

local function tabFeedback(button)
    TabPanther.Visible = true

    local y = button.AbsolutePosition.Y - Menu.AbsolutePosition.Y
    TabPanther.Position = UDim2.fromOffset(104, y - 8)
    TabPanther.Size = UDim2.fromOffset(10, 10)
    TabPanther.ImageTransparency = 0.75

    tween(TabPanther, SoftInfo, {
        Size = UDim2.fromOffset(54, 54),
        ImageTransparency = 0
    })

    task.delay(0.62, function()
        if TabPanther.Parent then
            tween(TabPanther, TweenInfo.new(0.20), {
                ImageTransparency = 1
            })
        end
    end)
end

local function activateTab(name)
    ActiveTab = name

    for tabName, button in pairs(TabButtons) do
        local selected = tabName == name

        local width = selected and 174 or 142
        local height = selected and 46 or 37

        tween(button, SoftInfo, {
            Size = UDim2.fromOffset(width, height),
            BackgroundTransparency = selected and 0.08 or 0.31
        })

        button.TextColor3 = selected and Theme.White or Theme.Ink
    end

    if TabButtons[name] then
        tabFeedback(TabButtons[name])
    end
end

for index, name in ipairs(Tabs) do
    local button = Instance.new("TextButton")
    button.Name = name
    button.Text = name
    button.TextSize = 11
    button.Font = Enum.Font.GothamBlack
    button.TextColor3 = Theme.Ink
    button.BackgroundColor3 = Theme.Pink
    button.BackgroundTransparency = 0.31
    button.AutoButtonColor = false
    button.Size = UDim2.fromOffset(142, 37)
    button.LayoutOrder = index
    button.ZIndex = 65
    button.Parent = TabHolder
    corner(button, 17)
    outline(button, Theme.PinkDark, 2, 0.48)

    TabButtons[name] = button

    button.MouseButton1Click:Connect(function()
        activateTab(name)
    end)
end

--==============================================================
-- CURVED FUNCTION AREA
--==============================================================

local FunctionArea = Instance.new("Frame")
FunctionArea.Name = "CurvedFunctionArea"
FunctionArea.AnchorPoint = Vector2.new(0.5, 0.5)
FunctionArea.Position = UDim2.fromScale(0.77, 0.53)
FunctionArea.Size = UDim2.fromOffset(210, 310)
FunctionArea.BackgroundTransparency = 1
FunctionArea.ZIndex = 60
FunctionArea.Parent = Menu

local FunctionTitle = label(
    FunctionArea,
    "HOME",
    17,
    Theme.White,
    Enum.Font.GothamBlack
)
FunctionTitle.Size = UDim2.new(1, 0, 0, 26)
FunctionTitle.TextXAlignment = Enum.TextXAlignment.Center
FunctionTitle.ZIndex = 65

local FunctionHint = label(
    FunctionArea,
    "Các chức năng sẽ được thêm sau",
    9,
    Theme.Ink,
    Enum.Font.GothamBold
)
FunctionHint.Position = UDim2.fromOffset(0, 28)
FunctionHint.Size = UDim2.new(1, 0, 0, 24)
FunctionHint.TextXAlignment = Enum.TextXAlignment.Center
FunctionHint.ZIndex = 65

local FunctionButtons = {}

for i = 1, 6 do
    local f = Instance.new("TextButton")
    f.Name = "CurvedFunction" .. i
    f.Text = "FUNCTION " .. i
    f.TextSize = 9
    f.Font = Enum.Font.GothamBold
    f.TextColor3 = Theme.Ink
    f.BackgroundColor3 = Theme.Pink
    f.BackgroundTransparency = 0.36
    f.AutoButtonColor = false
    f.Size = UDim2.fromOffset(170, 32)

    -- Curved path: center positions rise/fall with a sinusoid.
    local x = 20 + math.sin((i - 1) / 5 * math.pi) * 18
    local y = 62 + (i - 1) * 40
    local rot = (i - 3.5) * 3.3

    f.Position = UDim2.fromOffset(x, y)
    f.Rotation = rot
    f.ZIndex = 66
    f.Parent = FunctionArea
    corner(f, 15)
    outline(f, Theme.PinkDark, 1.5, 0.55)

    FunctionButtons[i] = f
end

--==============================================================
-- CENTER CLOSE ANIMATION
--==============================================================

local ClosingDrop = Instance.new("Frame")
ClosingDrop.Name = "ClosingDrop"
ClosingDrop.AnchorPoint = Vector2.new(0.5, 0.5)
ClosingDrop.Position = UDim2.fromScale(0.5, 0.5)
ClosingDrop.Size = UDim2.fromOffset(12, 12)
ClosingDrop.BackgroundColor3 = Theme.PinkLight
ClosingDrop.BackgroundTransparency = 0.02
ClosingDrop.Visible = false
ClosingDrop.ZIndex = 200
ClosingDrop.Parent = GUI
round(ClosingDrop)
outline(ClosingDrop, Theme.White, 2, 0.20)

local function closeMenu()
    -- 1) Push everything inward.
    tween(MenuScale, CloseInfo, {Scale = 0.08})

    -- 2) Slight inward rotation makes the flower feel like it is being sucked.
    tween(Menu, CloseInfo, {Rotation = 9})

    -- 3) Core expands briefly as the "suction point".
    tween(Flower, TweenInfo.new(0.24), {
        Size = UDim2.fromOffset(245, 245)
    })

    task.delay(0.48, function()
        if not GUI.Parent then return end

        Menu.Visible = false
        ClosingDrop.Visible = true
        ClosingDrop.Size = UDim2.fromOffset(18, 18)
        ClosingDrop.Position = UDim2.fromScale(0.5, 0.5)

        -- Circle -> vertical water drop.
        tween(ClosingDrop, TweenInfo.new(
            0.22,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ), {
            Size = UDim2.fromOffset(30, 72),
            Position = UDim2.fromScale(0.5, 0.475)
        })

        task.delay(0.23, function()
            tween(ClosingDrop, TweenInfo.new(
                0.30,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.In
            ), {
                Size = UDim2.fromOffset(10, 10),
                Position = UDim2.fromScale(0.5, 0.5)
            })

            task.delay(0.31, function()
                ClosingDrop.Visible = false
                ClosedLayer.Visible = true
                Z.Visible = true
                Z.Rotation = 0
            end)
        end)
    end)
end

local function openMenu()
    ClosedLayer.Visible = false
    Z.Visible = false
    ClosingDrop.Visible = false

    Menu.Visible = true
    MenuScale.Scale = 0.08
    Menu.Rotation = -8
    Flower.Size = UDim2.fromOffset(95, 95)

    -- The flower center starts as a droplet-like point and releases outward.
    tween(MenuScale, OpenInfo, {
        Scale = 1
    })

    tween(Menu, OpenInfo, {
        Rotation = 0
    })

    tween(Flower, TweenInfo.new(
        0.60,
        Enum.EasingStyle.Elastic,
        Enum.EasingDirection.Out
    ), {
        Size = UDim2.fromOffset(205, 205)
    })

    -- Curve plates grow after the drop is released.
    BodyBack.Size = UDim2.fromOffset(160, 120)
    BodyTop.Size = UDim2.fromOffset(130, 80)
    BodyBottom.Size = UDim2.fromOffset(140, 75)
    LeftCurve.Size = UDim2.fromOffset(70, 160)
    RightCurve.Size = UDim2.fromOffset(70, 160)

    tween(BodyBack, OpenInfo, {
        Size = UDim2.fromOffset(710, 500)
    })

    tween(BodyTop, OpenInfo, {
        Size = UDim2.fromOffset(550, 260)
    })

    tween(BodyBottom, OpenInfo, {
        Size = UDim2.fromOffset(570, 260)
    })

    tween(LeftCurve, OpenInfo, {
        Size = UDim2.fromOffset(190, 390)
    })

    tween(RightCurve, OpenInfo, {
        Size = UDim2.fromOffset(190, 390)
    })
end

-- The flower center is the close button.
local FlowerButton = Instance.new("TextButton")
FlowerButton.Name = "FlowerCloseButton"
FlowerButton.AnchorPoint = Vector2.new(0.5, 0.5)
FlowerButton.Position = UDim2.fromScale(0.5, 0.5)
FlowerButton.Size = UDim2.fromScale(0.75, 0.75)
FlowerButton.BackgroundTransparency = 1
FlowerButton.Text = ""
FlowerButton.AutoButtonColor = false
FlowerButton.ZIndex = 100
FlowerButton.Parent = Flower

FlowerButton.MouseButton1Click:Connect(closeMenu)

--==============================================================
-- MOBILE DRAG
--==============================================================

local dragging = false
local dragStart
local menuStart

Menu.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = true
        dragStart = input.Position
        menuStart = Menu.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.Touch
        and input.UserInputType ~= Enum.UserInputType.MouseMovement then
        return
    end

    local delta = input.Position - dragStart

    Menu.Position = UDim2.new(
        menuStart.X.Scale,
        menuStart.X.Offset + delta.X,
        menuStart.Y.Scale,
        menuStart.Y.Offset + delta.Y
    )
end)

--==============================================================
-- RAINBOW BORDER ANIMATION
--==============================================================

local hue = 0

RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt * 0.18) % 1
    RainbowStroke.Color = Color3.fromHSV(hue, 0.70, 1)

    if Menu.Visible then
        -- Very subtle glass breathing; no aggressive scaling that can
        -- make mobile devices stutter.
        local pulse = 1 + math.sin(os.clock() * 1.7) * 0.006
        CoreRing.Size = UDim2.fromScale(0.91 * pulse, 0.91 * pulse)
    end
end)

--==============================================================
-- INITIAL STATE
--==============================================================

activateTab("HOME")

-- Start with Z. The menu opens when Z is tapped.
Z.MouseButton1Click:Connect(function()
    openMenu()
end)

-- Small pulse on Z while closed.
task.spawn(function()
    while GUI.Parent do
        if ClosedLayer.Visible then
            tween(Z, TweenInfo.new(
                0.75,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ), {
                TextTransparency = 0.04
            })
            task.wait(0.75)

            tween(Z, TweenInfo.new(
                0.75,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ), {
                TextTransparency = 0.16
            })
            task.wait(0.75)
        else
            task.wait(0.1)
        end
    end
end)

--==============================================================
-- PUBLIC UI HANDLE
--==============================================================

_G.ZAKA_PINK_PANTHER_MENU = {
    GUI = GUI,
    Menu = Menu,
    Open = openMenu,
    Close = closeMenu,
    Toggle = function()
        if Menu.Visible then
            closeMenu()
        else
            openMenu()
        end
    end,
    SetTab = activateTab,
}

-- End of MENU ONLY version.
-- Gameplay functions will be added only after the visual/menu shape
-- is approved.
