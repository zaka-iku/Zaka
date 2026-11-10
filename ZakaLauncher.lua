--[[
    ZAKA PURE LIQUID GLASS - DELTA MOBILE EDITION
    UI-only overlay for Delta Mobile. Run/paste as a single script.
    No Roblox Studio placement required.
    Features: responsive glass shell, animated liquid gradients, moving specular
    highlights, floating light orbs, animated edge glow, touch/mouse dragging,
    5 navigation pages, working UI toggles, accent presets, scale slider,
    collapse/restore, close, and notification toasts.
    Note: Roblox GUI cannot physically refract the 3D world. This creates a
    layered animated liquid-glass approximation using native Roblox UI objects.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then return end

-- Remove an older copy if this script is executed again.
pcall(function()
    local old = CoreGui:FindFirstChild("ZAKA_PURE_LIQUID_GLASS")
    if old then old:Destroy() end
end)
pcall(function()
    local old = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        and LocalPlayer.PlayerGui:FindFirstChild("ZAKA_PURE_LIQUID_GLASS")
    if old then old:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZAKA_PURE_LIQUID_GLASS"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999

local parented = pcall(function() ScreenGui.Parent = CoreGui end)
if not parented or not ScreenGui.Parent then
    pcall(function() ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
end
if not ScreenGui.Parent then return end

local alive = true
local animationEnabled = true
local glowEnabled = true
local reflectionsEnabled = true
local compactMode = false
local currentAccent = Color3.fromRGB(74, 205, 255)
local baseScale = 1
local connections = {}
local tweens = {}

local function trackConnection(c)
    table.insert(connections, c)
    return c
end

local function tween(obj, duration, props, style, direction)
    local info = TweenInfo.new(duration or .3, style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    table.insert(tweens, t)
    t:Play()
    return t
end

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 18)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.new(1, 1, 1)
    s.Thickness = thickness or 1
    s.Transparency = transparency or .5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

local function gradient(obj, c1, c2, c3, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c1),
        ColorSequenceKeypoint.new(.5, c2),
        ColorSequenceKeypoint.new(1, c3)
    })
    g.Rotation = rotation or 0
    g.Parent = obj
    return g
end

local function makeLabel(parent, text, size, position, font, color)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextSize = size
    l.Font = font or Enum.Font.Gotham
    l.TextColor3 = color or Color3.fromRGB(242, 248, 255)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Position = position or UDim2.new()
    l.Size = UDim2.new(1, 0, 0, 28)
    l.Parent = parent
    return l
end

local function makeButton(parent, text, size, position)
    local b = Instance.new("TextButton")
    b.AutoButtonColor = false
    b.Text = text
    b.TextSize = 13
    b.Font = Enum.Font.GothamSemibold
    b.TextColor3 = Color3.fromRGB(243, 249, 255)
    b.Size = size
    b.Position = position
    b.BackgroundColor3 = Color3.fromRGB(80, 112, 150)
    b.BackgroundTransparency = .58
    b.Parent = parent
    corner(b, 15)
    local st = stroke(b, Color3.fromRGB(220, 240, 255), 1, .72)
    local original = size
    b.Activated:Connect(function()
        tween(b, .1, {Size = UDim2.new(original.X.Scale, original.X.Offset + 3,
            original.Y.Scale, original.Y.Offset + 3)}, Enum.EasingStyle.Quad)
        task.delay(.11, function()
            if b.Parent then tween(b, .2, {Size = original}, Enum.EasingStyle.Back) end
        end)
    end)
    return b, st
end

local function addPadding(parent, left, right, top, bottom)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, left or 0)
    p.PaddingRight = UDim.new(0, right or 0)
    p.PaddingTop = UDim.new(0, top or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.Parent = parent
end

-- Main shell
local shell = Instance.new("Frame")
shell.Name = "LiquidShell"
shell.AnchorPoint = Vector2.new(.5, .5)
shell.Position = UDim2.fromScale(.5, .5)
shell.Size = UDim2.new(.91, 0, .82, 0)
shell.BackgroundColor3 = Color3.fromRGB(13, 22, 42)
shell.BackgroundTransparency = .16
shell.ClipsDescendants = true
shell.Parent = ScreenGui
corner(shell, 30)

local shellGradient = gradient(shell,
    Color3.fromRGB(28, 67, 101),
    Color3.fromRGB(15, 24, 47),
    Color3.fromRGB(48, 35, 77), 35)

local outerStroke = stroke(shell, currentAccent, 1.6, .24)
local innerGlass = Instance.new("Frame")
innerGlass.Name = "InnerGlassRim"
innerGlass.BackgroundTransparency = 1
innerGlass.Position = UDim2.fromOffset(2, 2)
innerGlass.Size = UDim2.new(1, -4, 1, -4)
innerGlass.Parent = shell
corner(innerGlass, 28)
stroke(innerGlass, Color3.fromRGB(255, 255, 255), 1, .78)

-- Moving reflection layers clipped by shell
local reflection = Instance.new("Frame")
reflection.Name = "LiquidReflection"
reflection.BackgroundColor3 = Color3.fromRGB(220, 242, 255)
reflection.BackgroundTransparency = .91
reflection.BorderSizePixel = 0
reflection.Size = UDim2.new(.35, 0, 1.7, 0)
reflection.Position = UDim2.new(-.45, 0, -.3, 0)
reflection.Rotation = 17
reflection.ZIndex = 2
reflection.Parent = shell
corner(reflection, 80)
local reflectionGradient = gradient(reflection,
    Color3.new(1,1,1), Color3.fromRGB(120, 195, 255), Color3.new(1,1,1), 0)

local reflection2 = Instance.new("Frame")
reflection2.Name = "SecondaryReflection"
reflection2.BackgroundColor3 = Color3.fromRGB(180, 225, 255)
reflection2.BackgroundTransparency = .94
reflection2.BorderSizePixel = 0
reflection2.Size = UDim2.new(.2, 0, 1.45, 0)
reflection2.Position = UDim2.new(.8, 0, -.2, 0)
reflection2.Rotation = -18
reflection2.ZIndex = 2
reflection2.Parent = shell
corner(reflection2, 80)
gradient(reflection2, Color3.new(1,1,1), currentAccent, Color3.new(1,1,1), 0)

-- Soft light pools
local orbData = {
    {size = 190, pos = UDim2.new(.04, 0, .02, 0), color = Color3.fromRGB(50, 180, 255)},
    {size = 160, pos = UDim2.new(.76, 0, .62, 0), color = Color3.fromRGB(165, 95, 255)},
    {size = 120, pos = UDim2.new(.43, 0, .78, 0), color = Color3.fromRGB(70, 235, 210)}
}
local orbs = {}
for _, data in ipairs(orbData) do
    local orb = Instance.new("Frame")
    orb.Size = UDim2.fromOffset(data.size, data.size)
    orb.Position = data.pos
    orb.BackgroundColor3 = data.color
    orb.BackgroundTransparency = .91
    orb.BorderSizePixel = 0
    orb.ZIndex = 1
    orb.Parent = shell
    corner(orb, data.size)
    local g = Instance.new("UIGradient")
    g.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, .15),
        NumberSequenceKeypoint.new(.55, .55),
        NumberSequenceKeypoint.new(1, 1)
    })
    g.Rotation = 45
    g.Parent = orb
    table.insert(orbs, orb)
end

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.BackgroundTransparency = 1
header.Position = UDim2.fromOffset(18, 10)
header.Size = UDim2.new(1, -36, 0, 54)
header.ZIndex = 5
header.Parent = shell

local logo = makeLabel(header, "Z", 24, UDim2.fromOffset(1, 2), Enum.Font.GothamBlack, currentAccent)
logo.Size = UDim2.fromOffset(30, 38)
local brand = makeLabel(header, "ZAKA", 20, UDim2.fromOffset(31, 0), Enum.Font.GothamBlack)
brand.Size = UDim2.fromOffset(90, 28)
local sub = makeLabel(header, "PURE LIQUID GLASS", 8, UDim2.fromOffset(33, 26),
    Enum.Font.GothamMedium, Color3.fromRGB(167, 196, 231))
sub.Size = UDim2.fromOffset(120, 16)

local status = makeLabel(header, "● SYSTEM ONLINE", 9, UDim2.new(1, -138, 0, 8),
    Enum.Font.GothamBold, Color3.fromRGB(125, 255, 205))
status.TextXAlignment = Enum.TextXAlignment.Right
status.Size = UDim2.fromOffset(112, 20)

local collapseButton = makeButton(header, "—", UDim2.fromOffset(32, 30), UDim2.new(1, -72, 0, 5))
collapseButton.TextSize = 17
local closeButton = makeButton(header, "×", UDim2.fromOffset(32, 30), UDim2.new(1, -35, 0, 5))
closeButton.TextSize = 19

-- Navigation rail, double glass border
local rail = Instance.new("Frame")
rail.Name = "NavigationRail"
rail.Position = UDim2.fromOffset(13, 72)
rail.Size = UDim2.new(0, 66, 1, -87)
rail.BackgroundColor3 = Color3.fromRGB(165, 195, 235)
rail.BackgroundTransparency = .88
rail.Parent = shell
corner(rail, 24)
stroke(rail, Color3.fromRGB(231, 246, 255), 1.4, .42)

local railInner = Instance.new("Frame")
railInner.BackgroundTransparency = 1
railInner.Position = UDim2.fromOffset(4, 4)
railInner.Size = UDim2.new(1, -8, 1, -8)
railInner.Parent = rail
corner(railInner, 20)
stroke(railInner, Color3.fromRGB(255, 255, 255), 1, .77)

local content = Instance.new("Frame")
content.Name = "PageContent"
content.BackgroundTransparency = 1
content.Position = UDim2.fromOffset(91, 72)
content.Size = UDim2.new(1, -105, 1, -87)
content.Parent = shell

local pages = {}
for _, name in ipairs({"Home", "User", "Games", "System", "Settings"}) do
    local page = Instance.new("Frame")
    page.Name = name
    page.BackgroundTransparency = 1
    page.Size = UDim2.fromScale(1, 1)
    page.Visible = name == "Home"
    page.Parent = content
    pages[name] = page
end

local nav = {
    {"⌂", "Home", "HOME"},
    {"◉", "User", "USER"},
    {"▣", "Games", "GAMES"},
    {"⌁", "System", "SYSTEM"},
    {"⚙", "Settings", "SETTINGS"}
}
local selectedPill
local navButtons = {}
local function setPage(name)
    for key, p in pairs(pages) do
        p.Visible = key == name
    end
    for key, item in pairs(navButtons) do
        local selected = item.page == name
        tween(item.button, .22, {
            BackgroundTransparency = selected and .22 or .62,
            TextColor3 = selected and Color3.fromRGB(255,255,255) or Color3.fromRGB(185,205,231)
        })
        if item.glow then
            tween(item.glow, .22, {Transparency = selected and .22 or .88})
        end
    end
end

for i, item in ipairs(nav) do
    local b, st = makeButton(rail, item[1], UDim2.fromOffset(48, 48),
        UDim2.fromOffset(8, 10 + (i - 1) * 59))
    b.TextSize = 22
    b.BackgroundTransparency = i == 1 and .22 or .62
    b.ZIndex = 8
    local glow = stroke(b, currentAccent, 1.3, i == 1 and .22 or .88)
    navButtons[item[2]] = {button = b, glow = glow, page = item[2]}
    b.Activated:Connect(function()
        setPage(item[2])
    end)
end

-- Page helper components
local function sectionTitle(parent, title, description)
    local a = makeLabel(parent, title, 23, UDim2.fromOffset(4, 0), Enum.Font.GothamBold)
    a.Size = UDim2.new(1, -8, 0, 32)
    if description then
        local d = makeLabel(parent, description, 11, UDim2.fromOffset(5, 35),
            Enum.Font.Gotham, Color3.fromRGB(175, 199, 232))
        d.Size = UDim2.new(1, -10, 0, 25)
    end
end

local function glassCard(parent, position, size)
    local f = Instance.new("Frame")
    f.Position = position
    f.Size = size
    f.BackgroundColor3 = Color3.fromRGB(65, 91, 130)
    f.BackgroundTransparency = .68
    f.Parent = parent
    corner(f, 18)
    stroke(f, Color3.fromRGB(218, 238, 255), 1, .73)
    local topLine = Instance.new("Frame")
    topLine.BackgroundColor3 = Color3.fromRGB(255,255,255)
    topLine.BackgroundTransparency = .82
    topLine.BorderSizePixel = 0
    topLine.Size = UDim2.new(.7, 0, 0, 1)
    topLine.Position = UDim2.new(.15, 0, 0, 1)
    topLine.Parent = f
    return f
end

local function notify(message)
    local toast = Instance.new("Frame")
    toast.AnchorPoint = Vector2.new(.5, 0)
    toast.Position = UDim2.new(.5, 0, 0, -55)
    toast.Size = UDim2.new(.72, 0, 0, 42)
    toast.BackgroundColor3 = Color3.fromRGB(42, 65, 98)
    toast.BackgroundTransparency = .12
    toast.ZIndex = 100
    toast.Parent = shell
    corner(toast, 15)
    stroke(toast, currentAccent, 1.2, .35)
    local text = makeLabel(toast, message, 11, UDim2.fromOffset(12, 0), Enum.Font.GothamMedium)
    text.Size = UDim2.new(1, -24, 1, 0)
    text.TextXAlignment = Enum.TextXAlignment.Center
    tween(toast, .38, {Position = UDim2.new(.5, 0, 0, 13)}, Enum.EasingStyle.Back)
    task.delay(2, function()
        if toast.Parent then
            tween(toast, .25, {Position = UDim2.new(.5, 0, 0, -55)})
            task.delay(.3, function() if toast.Parent then toast:Destroy() end end)
        end
    end)
end

-- HOME
sectionTitle(pages.Home, "Welcome back", "Một giao diện Liquid Glass sống động, tối ưu cho màn hình cảm ứng.")
local hero = glassCard(pages.Home, UDim2.fromOffset(4, 76), UDim2.new(1, -8, 0, 118))
local heroTitle = makeLabel(hero, "ZAKA PURE", 21, UDim2.fromOffset(15, 13), Enum.Font.GothamBlack, currentAccent)
heroTitle.Size = UDim2.new(1, -30, 0, 30)
local heroSub = makeLabel(hero, "LIQUID INTERFACE EXPERIENCE", 9, UDim2.fromOffset(16, 43),
    Enum.Font.GothamMedium, Color3.fromRGB(187, 209, 239))
heroSub.Size = UDim2.new(1, -32, 0, 18)
local heroInfo = makeLabel(hero, "Fluid motion  •  Dynamic lighting  •  Touch optimized", 10,
    UDim2.fromOffset(16, 73), Enum.Font.Gotham, Color3.fromRGB(213, 227, 246))
heroInfo.Size = UDim2.new(1, -28, 0, 22)

local quick1 = glassCard(pages.Home, UDim2.fromOffset(4, 207), UDim2.new(.48, -5, 0, 77))
local quick2 = glassCard(pages.Home, UDim2.new(.52, 1, 0, 207), UDim2.new(.48, -5, 0, 77))
makeLabel(quick1, "✧  VISUAL", 12, UDim2.fromOffset(12, 12), Enum.Font.GothamBold, currentAccent)
makeLabel(quick1, "Liquid effects", 10, UDim2.fromOffset(12, 38), Enum.Font.Gotham, Color3.fromRGB(195, 213, 239))
makeLabel(quick2, "◈  CONTROL", 12, UDim2.fromOffset(12, 12), Enum.Font.GothamBold, currentAccent)
makeLabel(quick2, "Touch interface", 10, UDim2.fromOffset(12, 38), Enum.Font.Gotham, Color3.fromRGB(195, 213, 239))
local homeHint = makeLabel(pages.Home, "Chọn một mục ở thanh bên để khám phá menu.", 11,
    UDim2.fromOffset(6, 300), Enum.Font.Gotham, Color3.fromRGB(174, 197, 228))
homeHint.Size = UDim2.new(1, -12, 0, 25)

-- USER
sectionTitle(pages.User, "User Profile", "Thông tin phiên Roblox hiện tại.")
local userCard = glassCard(pages.User, UDim2.fromOffset(4, 76), UDim2.new(1, -8, 0, 130))
local avatar = Instance.new("ImageLabel")
avatar.BackgroundColor3 = Color3.fromRGB(65, 94, 132)
avatar.BackgroundTransparency = .25
avatar.Position = UDim2.fromOffset(14, 18)
avatar.Size = UDim2.fromOffset(76, 76)
avatar.Parent = userCard
corner(avatar, 22)
stroke(avatar, currentAccent, 1.4, .3)
task.spawn(function()
    local ok, image = pcall(function()
        return Players:GetUserThumbnailAsync(LocalPlayer.UserId,
            Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    end)
    if ok and avatar.Parent then avatar.Image = image end
end)
local userName = makeLabel(userCard, LocalPlayer.DisplayName, 16, UDim2.fromOffset(102, 25), Enum.Font.GothamBold)
userName.Size = UDim2.new(1, -112, 0, 25)
local userTag = makeLabel(userCard, "@" .. LocalPlayer.Name, 11, UDim2.fromOffset(103, 54),
    Enum.Font.Gotham, Color3.fromRGB(180, 203, 235))
userTag.Size = UDim2.new(1, -112, 0, 20)
local userId = makeLabel(userCard, "USER ID  •  " .. tostring(LocalPlayer.UserId), 9,
    UDim2.fromOffset(103, 77), Enum.Font.GothamMedium, currentAccent)
userId.Size = UDim2.new(1, -112, 0, 18)
local refreshProfile = makeButton(pages.User, "Làm mới thông tin", UDim2.new(1, -8, 0, 42), UDim2.fromOffset(4, 220))
refreshProfile.Activated:Connect(function()
    userName.Text = LocalPlayer.DisplayName
    userTag.Text = "@" .. LocalPlayer.Name
    userId.Text = "USER ID  •  " .. tostring(LocalPlayer.UserId)
    notify("Đã cập nhật thông tin người dùng")
end)

-- GAMES TAB: menu category only, no mini-games or launch game screen.
sectionTitle(pages.Games, "Game Menus", "Khu vực tổ chức các giao diện và cấu hình menu.")
local gameMenuCard = glassCard(pages.Games, UDim2.fromOffset(4, 76), UDim2.new(1, -8, 0, 84))
makeLabel(gameMenuCard, "▣  GAME INTERFACE HUB", 13, UDim2.fromOffset(13, 12), Enum.Font.GothamBold, currentAccent)
makeLabel(gameMenuCard, "Quản lý bố cục và các mục giao diện.", 10, UDim2.fromOffset(13, 41),
    Enum.Font.Gotham, Color3.fromRGB(194, 211, 237))
local gameMenuOptions = {"HUD Layout", "Visual Presets", "Control Layout", "Custom Sections"}
for i, text in ipairs(gameMenuOptions) do
    local b = makeButton(pages.Games, text .. "   ›", UDim2.new(1, -8, 0, 42),
        UDim2.fromOffset(4, 172 + (i - 1) * 49))
    b.TextXAlignment = Enum.TextXAlignment.Left
    addPadding(b, 13, 8, 0, 0)
    b.Activated:Connect(function()
        notify(text .. " • khu vực cấu hình giao diện")
    end)
end

-- SYSTEM
sectionTitle(pages.System, "System Center", "Các điều khiển giao diện và trạng thái hiển thị.")
local systemCard = glassCard(pages.System, UDim2.fromOffset(4, 76), UDim2.new(1, -8, 0, 78))
makeLabel(systemCard, "DYNAMIC ISLAND", 12, UDim2.fromOffset(13, 10), Enum.Font.GothamBold, currentAccent)
makeLabel(systemCard, "Thông báo và trạng thái menu", 10, UDim2.fromOffset(13, 37),
    Enum.Font.Gotham, Color3.fromRGB(190, 210, 238))
local testToast = makeButton(pages.System, "Hiện thông báo thử", UDim2.new(1, -8, 0, 42), UDim2.fromOffset(4, 168))
testToast.Activated:Connect(function() notify("ZAKA Liquid Glass • System active") end)
local resetPos = makeButton(pages.System, "Đưa menu về giữa màn hình", UDim2.new(1, -8, 0, 42), UDim2.fromOffset(4, 219))
resetPos.Activated:Connect(function()
    tween(shell, .35, {Position = UDim2.fromScale(.5, .5)}, Enum.EasingStyle.Back)
    notify("Đã căn giữa menu")
end)

-- SETTINGS
sectionTitle(pages.Settings, "Appearance", "Tùy chỉnh chuyển động và phong cách Liquid Glass.")
local settingsScroll = Instance.new("ScrollingFrame")
settingsScroll.BackgroundTransparency = 1
settingsScroll.BorderSizePixel = 0
settingsScroll.Position = UDim2.fromOffset(3, 70)
settingsScroll.Size = UDim2.new(1, -6, 1, -72)
settingsScroll.ScrollBarThickness = 2
settingsScroll.CanvasSize = UDim2.fromOffset(0, 450)
settingsScroll.Parent = pages.Settings

local function settingRow(y, titleText, detailText)
    local row = glassCard(settingsScroll, UDim2.fromOffset(2, y), UDim2.new(1, -6, 0, 57))
    makeLabel(row, titleText, 12, UDim2.fromOffset(12, 7), Enum.Font.GothamSemibold)
    local d = makeLabel(row, detailText, 9, UDim2.fromOffset(12, 31), Enum.Font.Gotham, Color3.fromRGB(172, 196, 229))
    d.Size = UDim2.new(1, -90, 0, 16)
    return row
end

local function toggleRow(y, titleText, detail, initial, callback)
    local row = settingRow(y, titleText, detail)
    local toggle = makeButton(row, initial and "ON" or "OFF", UDim2.fromOffset(53, 29), UDim2.new(1, -64, .5, -14))
    toggle.TextSize = 10
    local state = initial
    local function refresh()
        toggle.Text = state and "ON" or "OFF"
        toggle.BackgroundColor3 = state and currentAccent or Color3.fromRGB(70, 82, 104)
        toggle.BackgroundTransparency = state and .25 or .55
    end
    refresh()
    toggle.Activated:Connect(function()
        state = not state
        refresh()
        callback(state)
    end)
    return toggle
end

toggleRow(2, "Liquid Animation", "Chuyển động gradient và ánh sáng", true, function(v)
    animationEnabled = v
    notify(v and "Đã bật animation" or "Đã tắt animation")
end)
toggleRow(66, "Glow Effects", "Viền sáng và quầng màu", true, function(v)
    glowEnabled = v
    notify(v and "Đã bật glow" or "Đã tắt glow")
end)
toggleRow(130, "Glass Reflections", "Các dải phản chiếu chuyển động", true, function(v)
    reflectionsEnabled = v
    reflection.Visible = v
    reflection2.Visible = v
    notify(v and "Đã bật phản chiếu" or "Đã tắt phản chiếu")
end)

local accentRow = settingRow(194, "Accent Color", "Chọn màu nhấn của toàn bộ menu")
local colorChoices = {
    {"CYAN", Color3.fromRGB(74, 205, 255)},
    {"PURPLE", Color3.fromRGB(175, 125, 255)},
    {"PINK", Color3.fromRGB(255, 125, 190)},
    {"MINT", Color3.fromRGB(100, 245, 200)}
}
for i, choice in ipairs(colorChoices) do
    local b = makeButton(accentRow, "", UDim2.fromOffset(27, 27), UDim2.new(1, -125 + (i - 1) * 30, .5, -13))
    b.BackgroundColor3 = choice[2]
    b.BackgroundTransparency = .08
    b.Text = ""
    b.Activated:Connect(function()
        currentAccent = choice[2]
        logo.TextColor3 = currentAccent
        heroTitle.TextColor3 = currentAccent
        for _, item in pairs(navButtons) do item.glow.Color = currentAccent end
        outerStroke.Color = currentAccent
        userId.TextColor3 = currentAccent
        for _, child in ipairs(ScreenGui:GetDescendants()) do
            if child:IsA("UIStroke") and child.Parent and child.Parent.Name == "AccentTarget" then
                child.Color = currentAccent
            end
        end
        notify(choice[1] .. " accent selected")
    end)
end

local scaleRow = settingRow(258, "Menu Scale", "Kích thước menu phù hợp màn hình")
local scaleTrack = Instance.new("Frame")
scaleTrack.BackgroundColor3 = Color3.fromRGB(90, 111, 145)
scaleTrack.BackgroundTransparency = .3
scaleTrack.Position = UDim2.new(1, -128, .5, -3)
scaleTrack.Size = UDim2.fromOffset(105, 6)
scaleTrack.Parent = scaleRow
corner(scaleTrack, 8)
local scaleFill = Instance.new("Frame")
scaleFill.BackgroundColor3 = currentAccent
scaleFill.Size = UDim2.fromScale(.5, 1)
scaleFill.Parent = scaleTrack
corner(scaleFill, 8)
local scaleKnob = Instance.new("Frame")
scaleKnob.BackgroundColor3 = Color3.new(1,1,1)
scaleKnob.Size = UDim2.fromOffset(14,14)
scaleKnob.AnchorPoint = Vector2.new(.5,.5)
scaleKnob.Position = UDim2.new(.5,0,.5,0)
scaleKnob.Parent = scaleTrack
corner(scaleKnob, 10)
local scaleDragging = false
local function setScaleFromX(x)
    local rel = math.clamp((x - scaleTrack.AbsolutePosition.X) / scaleTrack.AbsoluteSize.X, 0, 1)
    baseScale = .82 + rel * .32
    scaleFill.Size = UDim2.fromScale(rel, 1)
    scaleKnob.Position = UDim2.new(rel, 0, .5, 0)
    shell.Size = UDim2.new(.91 * baseScale, 0, .82 * baseScale, 0)
end
scaleTrack.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        scaleDragging = true
        setScaleFromX(i.Position.X)
    end
end)
trackConnection(UserInputService.InputChanged:Connect(function(i)
    if scaleDragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
        setScaleFromX(i.Position.X)
    end
end))
trackConnection(UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        scaleDragging = false
    end
end))

local resetSettings = makeButton(settingsScroll, "Reset giao diện", UDim2.new(1, -6, 0, 42), UDim2.fromOffset(2, 326))
resetSettings.Activated:Connect(function()
    animationEnabled, glowEnabled, reflectionsEnabled = true, true, true
    reflection.Visible, reflection2.Visible = true, true
    currentAccent = Color3.fromRGB(74, 205, 255)
    logo.TextColor3 = currentAccent
    heroTitle.TextColor3 = currentAccent
    outerStroke.Color = currentAccent
    for _, item in pairs(navButtons) do item.glow.Color = currentAccent end
    shell.Size = UDim2.new(.91, 0, .82, 0)
    baseScale = 1
    scaleFill.Size = UDim2.fromScale(.5, 1)
    scaleKnob.Position = UDim2.new(.5, 0, .5, 0)
    notify("Đã khôi phục cài đặt giao diện")
end)

-- Collapse button and floating restore pill
local collapsed = false
local restore = makeButton(ScreenGui, "Z", UDim2.fromOffset(54, 54), UDim2.new(0, 16, .55, 0))
restore.Visible = false
restore.TextSize = 23
restore.BackgroundTransparency = .16
restore.BackgroundColor3 = Color3.fromRGB(35, 62, 99)
restore.ZIndex = 200
local restoreStroke = stroke(restore, currentAccent, 1.5, .2)
collapseButton.Activated:Connect(function()
    if collapsed then return end
    collapsed = true
    tween(shell, .28, {Size = UDim2.fromOffset(0, 0)}, Enum.EasingStyle.Back)
    task.delay(.3, function()
        if shell.Parent then shell.Visible = false; restore.Visible = true end
    end)
end)
restore.Activated:Connect(function()
    restore.Visible = false
    shell.Visible = true
    shell.Size = UDim2.fromOffset(0, 0)
    tween(shell, .35, {Size = UDim2.new(.91 * baseScale, 0, .82 * baseScale, 0)}, Enum.EasingStyle.Back)
    collapsed = false
end)
closeButton.Activated:Connect(function()
    alive = false
    for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
    for _, t in ipairs(tweens) do pcall(function() t:Cancel() end) end
    ScreenGui:Destroy()
end)

-- Touch and mouse drag support for the main menu header.
local dragging = false
local dragStart = nil
local startPosition = nil
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = shell.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
trackConnection(UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        shell.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end
end))

-- Restore pill drag for mobile convenience.
local restoreDragging, restoreStart, restorePos = false, nil, nil
restore.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        restoreDragging = true
        restoreStart = input.Position
        restorePos = restore.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then restoreDragging = false end end)
    end
end)
trackConnection(UserInputService.InputChanged:Connect(function(input)
    if restoreDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local d = input.Position - restoreStart
        restore.Position = UDim2.new(restorePos.X.Scale, restorePos.X.Offset + d.X,
            restorePos.Y.Scale, restorePos.Y.Offset + d.Y)
    end
end))

-- Continuous liquid animation loop.
local phase = 0
trackConnection(RunService.RenderStepped:Connect(function(dt)
    if not alive then return end
    phase += dt
    if animationEnabled then
        shellGradient.Rotation = (shellGradient.Rotation + dt * 4) % 360
        reflection.Position = UDim2.new(-.45 + ((math.sin(phase * .32) + 1) * .58), 0, -.3, 0)
        reflection2.Position = UDim2.new(.78 + math.sin(phase * .21) * .09, 0, -.22 + math.cos(phase * .28) * .06, 0)
        for i, orb in ipairs(orbs) do
            local d = orbData[i]
            local offset = math.sin(phase * (.3 + i * .07) + i) * 13
            orb.Position = UDim2.new(d.pos.X.Scale, d.pos.X.Offset + offset,
                d.pos.Y.Scale, d.pos.Y.Offset + math.cos(phase * .25 + i) * 10)
        end
    end
    if glowEnabled then
        outerStroke.Color = currentAccent:Lerp(Color3.new(1,1,1), .18 + (math.sin(phase * 1.7) + 1) * .1)
        outerStroke.Transparency = .22 + (math.sin(phase * 1.4) + 1) * .07
    else
        outerStroke.Color = currentAccent
        outerStroke.Transparency = .68
    end
    if not reflectionsEnabled then
        reflection.Visible = false
        reflection2.Visible = false
    end
end))

notify("ZAKA PURE LIQUID GLASS đã sẵn sàng")
