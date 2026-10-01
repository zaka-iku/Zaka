--[[
ZAKA PURE UI // V1
RASENGAN THEME // 6-TAB EDITION
Delta/mobile-friendly UI shell

GIỮ NGUYÊN 6 TAB VÀ DANH SÁCH CONTROL CỦA V3:
Combat / Hitbox / Visual / Player / World / Troll

Lưu ý:
Đây là UI/settings shell. Các control lưu trạng thái vào Settings và
không chứa implementation exploit đối với game của người khác.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- SETTINGS: GIỮ NGUYÊN TÊN SETTING CŨ
--==================================================

local Settings = {
    -- Combat
    Aimbot = false,
    AimbotFOV = 120,
    AimbotSmooth = 0.25,
    SilentAim = false,
    AutoClicker = false,
    ClickDelay = 0.05,
    TargetStrafe = false,
    StrafeDistance = 12,
    StrafeSpeed = 6,
    TriggerBot = false,
    KillAura = false,
    KillAuraDist = 18,
    AutoBlock = false,
    FastAttack = false,
    AutoSkill = false,

    -- Hitbox
    HitboxHead = false,
    HeadSize = 15,
    HitboxTorso = false,
    TorsoSize = Vector3.new(4, 6, 4),
    HitboxWeapon = false,
    WeaponSize = 5,
    HitboxTransparent = 0.5,
    HitboxLimb = false,
    LimbSize = 4,
    HitboxTeamCheck = false,
    HitboxAutoUpdate = true,

    -- Visual
    ESP = false,
    ESPBox = true,
    ESPName = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPMaxDist = 3500,
    Chams = false,
    ChamsColor = Color3.fromRGB(0, 200, 255),
    CustomCrosshair = false,
    CrosshairSize = 12,
    GlowTrail = false,
    Fullbright = false,
    FOVChanger = false,
    FOVValue = 90,
    Tracers = false,
    ESPHeadDot = false,
    NightVision = false,
    FPSBoost = false,

    -- Player
    Speed = false,
    SpeedValue = 26,
    Fly = false,
    FlySpeed = 50,
    FlyMode = "Camera",
    Noclip = false,
    InfiniteJump = false,
    SpinBot = false,
    SpinSpeed = 45,
    SpiderClimb = false,
    SpiderSpeed = 30,
    WaterWalk = false,
    Bhop = false,
    HighJump = false,
    JumpPower = 100,
    SuperDash = false,
    AutoRespawn = false,
    AntiRagdoll = false,
    GodModeVisual = false,

    -- World
    TouchTP = false,
    NoClipParts = false,
    ServerHop = false,
    BringNPC = false,
    BringNPCMode = "Nearest",
    ClickDelete = false,
    AntiVoid = false,
    ServerRejoin = false,
    TimeChanger = false,
    GameTime = 14,
    GravityMod = false,
    GravityValue = 196.2,
    AutoCollectItems = false,
    InstantInteract = false,

    -- Troll
    ChatSpammer = false,
    SpamMessage = "Zaka Pure UI v3.0 - Ultimate Power!",
    SpamDelay = 2,
    Invisible = false,
    FlingMe = false,
    SoundSpammer = false,
    ToolDupe = false,
    FakeLag = false,
    HeadlessMode = false,
    CorruptServer = false,
    AnimationPack = false,
    EmoteSpam = false,
    RainbowColor = false,
    CrashClientWarning = false,
    NullifyCollisions = false,
    AutoEquipBest = false,
    ServerLockdown = false,
}

--==================================================
-- TAB DATA: KHÔNG ĐỔI
--==================================================

local TabsData = {
    {Name = "Combat", Icon = "⚔"},
    {Name = "Hitbox", Icon = "🎯"},
    {Name = "Visual", Icon = "✦"},
    {Name = "Player", Icon = "◉"},
    {Name = "World",  Icon = "◈"},
    {Name = "Troll",  Icon = "⚡"},
}

--==================================================
-- CONTROL DATA
--==================================================

local Controls = {
    Combat = {
        {"Aimbot", "toggle", "Aimbot"},
        {"Aimbot FOV", "number", "AimbotFOV", 1, 500, 1},
        {"Aimbot Smooth", "number", "AimbotSmooth", 0.01, 1, 0.01},
        {"Silent Aim", "toggle", "SilentAim"},
        {"Auto Clicker", "toggle", "AutoClicker"},
        {"Click Delay", "number", "ClickDelay", 0.01, 2, 0.01},
        {"Target Strafe", "toggle", "TargetStrafe"},
        {"Strafe Distance", "number", "StrafeDistance", 1, 100, 1},
        {"Strafe Speed", "number", "StrafeSpeed", 1, 50, 1},
        {"Trigger Bot", "toggle", "TriggerBot"},
        {"Kill Aura", "toggle", "KillAura"},
        {"Kill Aura Distance", "number", "KillAuraDist", 1, 100, 1},
        {"Auto Block", "toggle", "AutoBlock"},
        {"Fast Attack", "toggle", "FastAttack"},
        {"Auto Skill", "toggle", "AutoSkill"},
    },

    Hitbox = {
        {"Hitbox Head", "toggle", "HitboxHead"},
        {"Head Size", "number", "HeadSize", 1, 50, 1},
        {"Hitbox Torso", "toggle", "HitboxTorso"},
        {"Torso Size", "text", "TorsoSize"},
        {"Hitbox Weapon", "toggle", "HitboxWeapon"},
        {"Weapon Size", "number", "WeaponSize", 1, 30, 1},
        {"Hitbox Transparent", "number", "HitboxTransparent", 0, 1, 0.05},
        {"Hitbox Limb", "toggle", "HitboxLimb"},
        {"Limb Size", "number", "LimbSize", 1, 30, 1},
        {"Hitbox Team Check", "toggle", "HitboxTeamCheck"},
        {"Hitbox Auto Update", "toggle", "HitboxAutoUpdate"},
    },

    Visual = {
        {"ESP", "toggle", "ESP"},
        {"ESP Box", "toggle", "ESPBox"},
        {"ESP Name", "toggle", "ESPName"},
        {"ESP Health", "toggle", "ESPHealth"},
        {"ESP Distance", "toggle", "ESPDistance"},
        {"ESP Max Distance", "number", "ESPMaxDist", 50, 10000, 50},
        {"Chams", "toggle", "Chams"},
        {"Chams Color", "color", "ChamsColor"},
        {"Custom Crosshair", "toggle", "CustomCrosshair"},
        {"Crosshair Size", "number", "CrosshairSize", 2, 50, 1},
        {"Glow Trail", "toggle", "GlowTrail"},
        {"Fullbright", "toggle", "Fullbright"},
        {"FOV Changer", "toggle", "FOVChanger"},
        {"FOV Value", "number", "FOVValue", 40, 140, 1},
        {"Tracers", "toggle", "Tracers"},
        {"ESP Head Dot", "toggle", "ESPHeadDot"},
        {"Night Vision", "toggle", "NightVision"},
        {"FPS Boost", "toggle", "FPSBoost"},
    },

    Player = {
        {"Speed", "toggle", "Speed"},
        {"Speed Value", "number", "SpeedValue", 1, 200, 1},
        {"Fly", "toggle", "Fly"},
        {"Fly Speed", "number", "FlySpeed", 1, 200, 1},
        {"Fly Mode", "text", "FlyMode"},
        {"Noclip", "toggle", "Noclip"},
        {"Infinite Jump", "toggle", "InfiniteJump"},
        {"Spin Bot", "toggle", "SpinBot"},
        {"Spin Speed", "number", "SpinSpeed", 1, 360, 1},
        {"Spider Climb", "toggle", "SpiderClimb"},
        {"Spider Speed", "number", "SpiderSpeed", 1, 100, 1},
        {"Water Walk", "toggle", "WaterWalk"},
        {"Bhop", "toggle", "Bhop"},
        {"High Jump", "toggle", "HighJump"},
        {"Jump Power", "number", "JumpPower", 1, 300, 1},
        {"Super Dash", "toggle", "SuperDash"},
        {"Auto Respawn", "toggle", "AutoRespawn"},
        {"Anti Ragdoll", "toggle", "AntiRagdoll"},
        {"GodMode Visual", "toggle", "GodModeVisual"},
    },

    World = {
        {"Touch TP", "toggle", "TouchTP"},
        {"NoClip Parts", "toggle", "NoClipParts"},
        {"Server Hop", "toggle", "ServerHop"},
        {"Bring NPC", "toggle", "BringNPC"},
        {"Bring NPC Mode", "text", "BringNPCMode"},
        {"Click Delete", "toggle", "ClickDelete"},
        {"Anti Void", "toggle", "AntiVoid"},
        {"Server Rejoin", "toggle", "ServerRejoin"},
        {"Time Changer", "toggle", "TimeChanger"},
        {"Game Time", "number", "GameTime", 0, 24, 1},
        {"Gravity Mod", "toggle", "GravityMod"},
        {"Gravity Value", "number", "GravityValue", 0, 500, 0.1},
        {"Auto Collect Items", "toggle", "AutoCollectItems"},
        {"Instant Interact", "toggle", "InstantInteract"},
    },

    Troll = {
        {"Chat Spammer", "toggle", "ChatSpammer"},
        {"Spam Message", "text", "SpamMessage"},
        {"Spam Delay", "number", "SpamDelay", 0.1, 20, 0.1},
        {"Invisible", "toggle", "Invisible"},
        {"Fling Me", "toggle", "FlingMe"},
        {"Sound Spammer", "toggle", "SoundSpammer"},
        {"Tool Dupe", "toggle", "ToolDupe"},
        {"Fake Lag", "toggle", "FakeLag"},
        {"Headless Mode", "toggle", "HeadlessMode"},
        {"Corrupt Server", "toggle", "CorruptServer"},
        {"Animation Pack", "toggle", "AnimationPack"},
        {"Emote Spam", "toggle", "EmoteSpam"},
        {"Rainbow Color", "toggle", "RainbowColor"},
        {"Crash Client Warning", "toggle", "CrashClientWarning"},
        {"Nullify Collisions", "toggle", "NullifyCollisions"},
        {"Auto Equip Best", "toggle", "AutoEquipBest"},
        {"Server Lockdown", "toggle", "ServerLockdown"},
    },
}

--==================================================
-- CLEAN OLD UI
--==================================================

local old = PlayerGui:FindFirstChild("ZakaPureUI")
if old then
    old:Destroy()
end

--==================================================
-- HELPERS
--==================================================

local function new(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function corner(parent, radius)
    return new("UICorner", {
        CornerRadius = UDim.new(0, radius or 8)
    }, parent)
end

local function stroke(parent, thickness)
    return new("UIStroke", {
        Thickness = thickness or 1,
        Color = Color3.fromRGB(70, 190, 255),
        Transparency = 0.2
    }, parent)
end

local function tween(obj, info, props)
    TweenService:Create(obj, info, props):Play()
end

local function formatValue(v)
    if typeof(v) == "Color3" then
        return string.format(
            "#%02X%02X%02X",
            math.floor(v.R * 255),
            math.floor(v.G * 255),
            math.floor(v.B * 255)
        )
    elseif typeof(v) == "Vector3" then
        return string.format("%.2f, %.2f, %.2f", v.X, v.Y, v.Z)
    end
    return tostring(v)
end

--==================================================
-- GUI
--==================================================

local Gui = new("ScreenGui", {
    Name = "ZakaPureUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, PlayerGui)

-- Mobile scale
local Scale = new("UIScale", {
    Scale = 1
}, Gui)

local function updateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local size = camera.ViewportSize
    if size.X < 500 then
        Scale.Scale = math.clamp(size.X / 430, 0.78, 1)
    else
        Scale.Scale = 1
    end
end

updateScale()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

--==================================================
-- RASENGAN TOGGLE
--==================================================

local Toggle = new("TextButton", {
    Name = "RasenganToggle",
    Size = UDim2.fromOffset(58, 58),
    Position = UDim2.new(0, 18, 0.5, -29),
    BackgroundColor3 = Color3.fromRGB(8, 16, 34),
    Text = "Z",
    TextColor3 = Color3.fromRGB(220, 250, 255),
    TextSize = 25,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    Active = true,
    Draggable = true,
    ZIndex = 20,
}, Gui)
corner(Toggle, 29)
local ToggleStroke = stroke(Toggle, 2)

local ToggleGlow = new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 150, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(130, 70, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 220, 255)),
    }),
    Rotation = 45,
}, Toggle)

--==================================================
-- MAIN WINDOW
--==================================================

local Main = new("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(480, 550),
    Position = UDim2.new(0.5, -240, 0.5, -275),
    BackgroundColor3 = Color3.fromRGB(5, 9, 20),
    BackgroundTransparency = 0.06,
    Visible = true,
}, Gui)
corner(Main, 16)
local MainStroke = stroke(Main, 2)

local MainGradient = new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(7, 15, 30)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 8, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 18, 32)),
    }),
    Rotation = 25,
}, Main)

-- Header
local Header = new("Frame", {
    Size = UDim2.new(1, 0, 0, 64),
    BackgroundTransparency = 1,
}, Main)

local Title = new("TextLabel", {
    Size = UDim2.new(1, -110, 0, 32),
    Position = UDim2.fromOffset(18, 7),
    BackgroundTransparency = 1,
    Text = "RASENGAN // ZAKA PURE UI",
    TextColor3 = Color3.fromRGB(225, 250, 255),
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Header)

local SubTitle = new("TextLabel", {
    Size = UDim2.new(1, -110, 0, 20),
    Position = UDim2.fromOffset(19, 35),
    BackgroundTransparency = 1,
    Text = "V1  •  6 TABS  •  MOBILE",
    TextColor3 = Color3.fromRGB(100, 185, 235),
    TextSize = 11,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Header)

local Close = new("TextButton", {
    Size = UDim2.fromOffset(38, 38),
    Position = UDim2.new(1, -50, 0, 12),
    BackgroundColor3 = Color3.fromRGB(20, 24, 42),
    Text = "×",
    TextColor3 = Color3.fromRGB(220, 235, 255),
    TextSize = 25,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
}, Header)
corner(Close, 10)
stroke(Close, 1)

-- Search
local Search = new("TextBox", {
    Size = UDim2.new(1, -32, 0, 38),
    Position = UDim2.fromOffset(16, 70),
    BackgroundColor3 = Color3.fromRGB(10, 17, 34),
    PlaceholderText = "Search skills...",
    PlaceholderColor3 = Color3.fromRGB(100, 125, 155),
    Text = "",
    TextColor3 = Color3.fromRGB(225, 245, 255),
    TextSize = 13,
    Font = Enum.Font.Gotham,
    ClearTextOnFocus = false,
}, Main)
corner(Search, 10)
stroke(Search, 1)

-- Tabs
local TabsFrame = new("ScrollingFrame", {
    Size = UDim2.new(0, 108, 1, -122),
    Position = UDim2.fromOffset(12, 116),
    BackgroundTransparency = 1,
    ScrollBarThickness = 0,
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, Main)

new("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, TabsFrame)

local Content = new("ScrollingFrame", {
    Size = UDim2.new(1, -132, 1, -122),
    Position = UDim2.fromOffset(124, 116),
    BackgroundColor3 = Color3.fromRGB(7, 12, 25),
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Color3.fromRGB(60, 180, 255),
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, Main)
corner(Content, 12)
stroke(Content, 1)

new("UIPadding", {
    PaddingTop = UDim.new(0, 9),
    PaddingBottom = UDim.new(0, 9),
    PaddingLeft = UDim.new(0, 9),
    PaddingRight = UDim.new(0, 9),
}, Content)

local ContentLayout = new("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, Content)

--==================================================
-- CARD CREATION
--==================================================

local currentTab = "Combat"
local Cards = {}

local function makeCard(tabName, data, order)
    local label, kind, key, min, max, step = table.unpack(data)

    local card = new("Frame", {
        Name = label,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Color3.fromRGB(12, 20, 39),
        BackgroundTransparency = 0.04,
        LayoutOrder = order,
    }, Content)
    corner(card, 9)

    local cardStroke = stroke(card, 1)
    cardStroke.Transparency = 0.65

    local nameLabel = new("TextLabel", {
        Size = UDim2.new(1, -130, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Color3.fromRGB(215, 235, 250),
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)

    local valueLabel = new("TextLabel", {
        Size = UDim2.fromOffset(105, 22),
        Position = UDim2.new(1, -115, 0, 14),
        BackgroundTransparency = 1,
        Text = formatValue(Settings[key]),
        TextColor3 = Color3.fromRGB(90, 195, 255),
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, card)

    if kind == "toggle" then
        local button = new("TextButton", {
            Size = UDim2.fromOffset(46, 24),
            Position = UDim2.new(1, -58, 0, 13),
            BackgroundColor3 = Settings[key] and Color3.fromRGB(35, 180, 245) or Color3.fromRGB(35, 45, 65),
            Text = "",
            AutoButtonColor = false,
        }, card)
        corner(button, 12)

        local knob = new("Frame", {
            Size = UDim2.fromOffset(18, 18),
            Position = Settings[key] and UDim2.new(1, -21, 0, 3) or UDim2.fromOffset(3, 3),
            BackgroundColor3 = Color3.fromRGB(235, 250, 255),
        }, button)
        corner(knob, 9)

        local function refresh()
            local on = Settings[key] == true
            button.BackgroundColor3 = on
                and Color3.fromRGB(35, 180, 245)
                or Color3.fromRGB(35, 45, 65)
            tween(knob, TweenInfo.new(0.15), {
                Position = on
                    and UDim2.new(1, -21, 0, 3)
                    or UDim2.fromOffset(3, 3)
            })
            valueLabel.Text = on and "ON" or "OFF"
        end

        button.MouseButton1Click:Connect(function()
            Settings[key] = not Settings[key]
            refresh()
        end)

        refresh()

    elseif kind == "number" then
        valueLabel.Text = formatValue(Settings[key])

        local minus = new("TextButton", {
            Size = UDim2.fromOffset(24, 24),
            Position = UDim2.new(1, -112, 0, 13),
            BackgroundColor3 = Color3.fromRGB(20, 31, 53),
            Text = "−",
            TextColor3 = Color3.fromRGB(190, 225, 245),
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
        }, card)
        corner(minus, 7)

        local plus = new("TextButton", {
            Size = UDim2.fromOffset(24, 24),
            Position = UDim2.new(1, -30, 0, 13),
            BackgroundColor3 = Color3.fromRGB(20, 31, 53),
            Text = "+",
            TextColor3 = Color3.fromRGB(190, 225, 245),
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
        }, card)
        corner(plus, 7)

        valueLabel.Size = UDim2.fromOffset(52, 24)
        valueLabel.Position = UDim2.new(1, -84, 0, 13)

        local function change(delta)
            local oldValue = tonumber(Settings[key]) or 0
            local newValue = oldValue + delta
            newValue = math.clamp(newValue, min, max)
            local precision = step < 1 and 2 or 0
            Settings[key] = tonumber(string.format("%." .. precision .. "f", newValue))
            valueLabel.Text = formatValue(Settings[key])
        end

        minus.MouseButton1Click:Connect(function()
            change(-step)
        end)

        plus.MouseButton1Click:Connect(function()
            change(step)
        end)

    elseif kind == "text" then
        local box = new("TextBox", {
            Size = UDim2.fromOffset(105, 28),
            Position = UDim2.new(1, -115, 0, 11),
            BackgroundColor3 = Color3.fromRGB(17, 27, 48),
            Text = tostring(Settings[key]),
            PlaceholderText = "...",
            TextColor3 = Color3.fromRGB(205, 235, 250),
            TextSize = 10,
            Font = Enum.Font.Gotham,
            ClearTextOnFocus = false,
        }, card)
        corner(box, 7)

        box.FocusLost:Connect(function()
            Settings[key] = box.Text
            valueLabel.Text = box.Text
        end)

        valueLabel.Visible = false

    elseif kind == "color" then
        local colorButton = new("TextButton", {
            Size = UDim2.fromOffset(70, 28),
            Position = UDim2.new(1, -80, 0, 11),
            BackgroundColor3 = Settings[key],
            Text = "COLOR",
            TextColor3 = Color3.fromRGB(235, 250, 255),
            TextSize = 9,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
        }, card)
        corner(colorButton, 7)

        -- Simple cycling palette, no external color picker dependency.
        local colors = {
            Color3.fromRGB(0, 200, 255),
            Color3.fromRGB(80, 120, 255),
            Color3.fromRGB(160, 70, 255),
            Color3.fromRGB(255, 90, 210),
            Color3.fromRGB(255, 255, 255),
        }
        local index = 1

        colorButton.MouseButton1Click:Connect(function()
            index = index % #colors + 1
            Settings[key] = colors[index]
            colorButton.BackgroundColor3 = Settings[key]
        end)

        valueLabel.Visible = false
    end

    Cards[#Cards + 1] = {
        tab = tabName,
        object = card,
        searchName = string.lower(label),
    }

    return card
end

--==================================================
-- TAB BUILD
--==================================================

local TabButtons = {}

local function buildTab(tab)
    for _, child in ipairs(Content:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    Cards = {}

    local list = Controls[tab]
    for i, data in ipairs(list) do
        makeCard(tab, data, i)
    end
end

for index, tabData in ipairs(TabsData) do
    local tabName = tabData.Name

    local tabButton = new("TextButton", {
        Name = tabName,
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = Color3.fromRGB(10, 17, 34),
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = index,
    }, TabsFrame)
    corner(tabButton, 10)

    local icon = new("TextLabel", {
        Size = UDim2.fromOffset(32, 52),
        Position = UDim2.fromOffset(5, 0),
        BackgroundTransparency = 1,
        Text = tabData.Icon,
        TextColor3 = Color3.fromRGB(95, 205, 255),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
    }, tabButton)

    local name = new("TextLabel", {
        Size = UDim2.new(1, -38, 1, 0),
        Position = UDim2.fromOffset(35, 0),
        BackgroundTransparency = 1,
        Text = tabName,
        TextColor3 = Color3.fromRGB(185, 215, 235),
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, tabButton)

    local outline = stroke(tabButton, 1)
    outline.Transparency = 0.75

    TabButtons[tabName] = {
        button = tabButton,
        outline = outline,
        icon = icon,
        name = name,
    }

    tabButton.MouseButton1Click:Connect(function()
        currentTab = tabName

        for nameKey, refs in pairs(TabButtons) do
            local active = nameKey == currentTab
            refs.button.BackgroundColor3 = active
                and Color3.fromRGB(15, 48, 72)
                or Color3.fromRGB(10, 17, 34)
            refs.outline.Transparency = active and 0.1 or 0.75
            refs.icon.TextColor3 = active
                and Color3.fromRGB(120, 230, 255)
                or Color3.fromRGB(95, 205, 255)
            refs.name.TextColor3 = active
                and Color3.fromRGB(235, 250, 255)
                or Color3.fromRGB(185, 215, 235)
        end

        buildTab(currentTab)
        Search.Text = ""
    end)
end

-- Initial tab
TabButtons.Combat.button.BackgroundColor3 = Color3.fromRGB(15, 48, 72)
TabButtons.Combat.outline.Transparency = 0.1
TabButtons.Combat.name.TextColor3 = Color3.fromRGB(235, 250, 255)
buildTab("Combat")

--==================================================
-- SEARCH
--==================================================

Search:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower(Search.Text)

    for _, info in ipairs(Cards) do
        info.object.Visible = q == "" or string.find(info.searchName, q, 1, true) ~= nil
    end
end)

--==================================================
-- OPEN / CLOSE
--==================================================

local opened = true

local function setOpen(state)
    opened = state
    Main.Visible = state
end

Toggle.MouseButton1Click:Connect(function()
    setOpen(not opened)
end)

Close.MouseButton1Click:Connect(function()
    setOpen(false)
end)

--==================================================
-- RASENGAN ANIMATION
--==================================================

task.spawn(function()
    local rotation = 0
    while Gui.Parent do
        rotation = (rotation + 2) % 360
        ToggleGlow.Rotation = rotation
        MainGradient.Rotation = (25 + rotation * 0.15) % 360

        local pulse = 0.25 + (math.sin(os.clock() * 2.5) + 1) * 0.08
        ToggleStroke.Transparency = pulse

        task.wait(0.03)
    end
end)

-- Hover feedback
for _, refs in pairs(TabButtons) do
    refs.button.MouseEnter:Connect(function()
        if currentTab ~= refs.button.Name then
            tween(refs.button, TweenInfo.new(0.12), {
                BackgroundColor3 = Color3.fromRGB(14, 29, 50)
            })
        end
    end)

    refs.button.MouseLeave:Connect(function()
        if currentTab ~= refs.button.Name then
            tween(refs.button, TweenInfo.new(0.12), {
                BackgroundColor3 = Color3.fromRGB(10, 17, 34)
            })
        end
    end)
end

print("[ZAKA PURE UI] V1 Rasengan 6-tab UI loaded.")
