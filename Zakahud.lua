--[[
    ZAKA PURE UI V1
    MENU VISUAL UPGRADE ONLY
    - Keeps the original Zakahud.lua
    - Replaces the Z button look with an anime eye
    - Eye has layered iris, rings, tomoe-style marks, glow and rotation
    - Open: Z -> eye, eye expands/glows/rotates while menu opens
    - Close: eye contracts/fades -> Z
    - No feature logic is changed in this addon
]]

local SOURCE = "https://raw.githubusercontent.com/zaka-iku/Zaka/main/Zakahud.lua"

-- Load the current ZAKA menu first.
local ok, err = pcall(function()
    loadstring(game:HttpGet(SOURCE))()
end)

if not ok then
    warn("[ZAKA V1] Failed to load Zakahud.lua:", err)
    return
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- Wait for the original menu to finish creating its UI.
local ScreenGui = gui:WaitForChild("ZakaPureUI", 10)
if not ScreenGui then
    warn("[ZAKA V1] ZakaPureUI was not found.")
    return
end

local ToggleBtn = ScreenGui:WaitForChild("TextButton", 10)
if not ToggleBtn then
    warn("[ZAKA V1] Toggle button was not found.")
    return
end

local Main = ScreenGui:FindFirstChild("Frame")
if not Main then
    warn("[ZAKA V1] Main menu was not found.")
    return
end

-- Find the red close button from the header.
local CloseBtn
for _, obj in ipairs(Main:GetDescendants()) do
    if obj:IsA("TextButton") and obj.Text == "×" then
        CloseBtn = obj
        break
    end
end

-- Clean old addon if reloaded.
local old = ScreenGui:FindFirstChild("ZakaEyeV1")
if old then old:Destroy() end

-- Hide the original Z text/stroke while the eye is active.
ToggleBtn.Text = ""
ToggleBtn.TextTransparency = 1

local oldStroke = ToggleBtn:FindFirstChildOfClass("UIStroke")
if oldStroke then
    oldStroke.Transparency = 1
end

-- ============================================================
-- EYE CONTAINER
-- ============================================================

local Eye = Instance.new("Frame")
Eye.Name = "ZakaEyeV1"
Eye.AnchorPoint = Vector2.new(0.5, 0.5)
Eye.Position = UDim2.fromScale(0.5, 0.5)
Eye.Size = UDim2.fromScale(0.82, 0.82)
Eye.BackgroundTransparency = 1
Eye.ZIndex = ToggleBtn.ZIndex + 5
Eye.Parent = ToggleBtn

local function circle(name, size, color, transparency, z)
    local f = Instance.new("Frame")
    f.Name = name
    f.AnchorPoint = Vector2.new(0.5, 0.5)
    f.Position = UDim2.fromScale(0.5, 0.5)
    f.Size = UDim2.fromScale(size, size)
    f.BackgroundColor3 = color
    f.BackgroundTransparency = transparency or 0
    f.BorderSizePixel = 0
    f.ZIndex = z or Eye.ZIndex
    f.Parent = Eye

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = f
    return f
end

local function stroke(parent, thickness, color, transparency)
    local s = Instance.new("UIStroke")
    s.Thickness = thickness
    s.Color = color
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

-- Soft aura layers.
local Glow3 = circle("GlowOuter", 1.20, Color3.fromRGB(145, 20, 255), 0.90, Eye.ZIndex)
local Glow2 = circle("GlowMid",   1.06, Color3.fromRGB(95, 0, 255), 0.84, Eye.ZIndex + 1)
local Glow1 = circle("GlowCore",  0.96, Color3.fromRGB(35, 0, 80), 0.60, Eye.ZIndex + 2)

-- Outer rings.
local RingOuter = circle("RingOuter", 0.92, Color3.fromRGB(8, 4, 18), 0.30, Eye.ZIndex + 3)
stroke(RingOuter, 2.0, Color3.fromRGB(190, 70, 255), 0.12)

local RingMiddle = circle("RingMiddle", 0.77, Color3.fromRGB(15, 5, 30), 0.18, Eye.ZIndex + 4)
stroke(RingMiddle, 1.4, Color3.fromRGB(105, 30, 255), 0.15)

local Iris = circle("Iris", 0.60, Color3.fromRGB(42, 5, 75), 0.02, Eye.ZIndex + 5)
stroke(Iris, 1.2, Color3.fromRGB(220, 80, 255), 0.10)

-- Inner ring.
local InnerRing = circle("InnerRing", 0.42, Color3.fromRGB(18, 2, 35), 0.05, Eye.ZIndex + 6)
stroke(InnerRing, 1.5, Color3.fromRGB(255, 105, 255), 0.05)

-- Pupil.
local Pupil = circle("Pupil", 0.20, Color3.fromRGB(2, 0, 8), 0, Eye.ZIndex + 8)
stroke(Pupil, 1.0, Color3.fromRGB(255, 150, 255), 0.12)

-- Small central glow.
local Core = circle("Core", 0.075, Color3.fromRGB(255, 235, 255), 0.02, Eye.ZIndex + 9)

-- ============================================================
-- TOMOE-STYLE MARKS
-- Decorative anime-inspired marks, not a character image.
-- ============================================================

local TomoeFolder = Instance.new("Frame")
TomoeFolder.Name = "TomoeRing"
TomoeFolder.AnchorPoint = Vector2.new(0.5, 0.5)
TomoeFolder.Position = UDim2.fromScale(0.5, 0.5)
TomoeFolder.Size = UDim2.fromScale(0.70, 0.70)
TomoeFolder.BackgroundTransparency = 1
TomoeFolder.ZIndex = Eye.ZIndex + 7
TomoeFolder.Parent = Eye

local Tomoe = {}

for i = 1, 3 do
    local holder = Instance.new("Frame")
    holder.Name = "Mark" .. i
    holder.AnchorPoint = Vector2.new(0.5, 0.5)
    holder.Position = UDim2.fromScale(0.5, 0.5)
    holder.Size = UDim2.fromScale(1, 1)
    holder.BackgroundTransparency = 1
    holder.Rotation = (i - 1) * 120
    holder.ZIndex = TomoeFolder.ZIndex
    holder.Parent = TomoeFolder

    local mark = Instance.new("Frame")
    mark.Name = "Tomoe"
    mark.AnchorPoint = Vector2.new(0.5, 0.5)
    mark.Position = UDim2.fromScale(0.5, 0.17)
    mark.Size = UDim2.fromScale(0.13, 0.21)
    mark.BackgroundColor3 = Color3.fromRGB(235, 90, 255)
    mark.BackgroundTransparency = 0.05
    mark.BorderSizePixel = 0
    mark.Rotation = 25
    mark.ZIndex = holder.ZIndex + 1
    mark.Parent = holder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = mark

    local markStroke = Instance.new("UIStroke")
    markStroke.Color = Color3.fromRGB(255, 185, 255)
    markStroke.Thickness = 0.8
    markStroke.Transparency = 0.20
    markStroke.Parent = mark

    table.insert(Tomoe, holder)
end

-- Small orbiting dots add depth while the eye rotates.
local Dots = {}
for i = 1, 6 do
    local dot = circle("OrbitDot" .. i, 0.045, Color3.fromRGB(255, 180, 255), 0.10, Eye.ZIndex + 8)
    dot.Position = UDim2.fromScale(
        0.5 + math.cos(math.rad(i * 60)) * 0.40,
        0.5 + math.sin(math.rad(i * 60)) * 0.40
    )
    table.insert(Dots, dot)
end

-- ============================================================
-- ANIMATION
-- ============================================================

local eyeOpen = false
local rotationConnection
local pulseConnection

local function tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function setGlowVisible(visible, fast)
    local d = fast and 0.18 or 0.32
    local info = TweenInfo.new(d, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    tween(Glow3, info, {BackgroundTransparency = visible and 0.78 or 1})
    tween(Glow2, info, {BackgroundTransparency = visible and 0.70 or 1})
    tween(Glow1, info, {BackgroundTransparency = visible and 0.48 or 1})

    for _, h in ipairs(Tomoe) do
        local mark = h:FindFirstChild("Tomoe")
        if mark then
            tween(mark, info, {
                BackgroundTransparency = visible and 0.05 or 1
            })
        end
    end

    for _, d in ipairs(Dots) do
        tween(d, info, {BackgroundTransparency = visible and 0.10 or 1})
    end
end

local function stopRotation()
    if rotationConnection then
        rotationConnection:Disconnect()
        rotationConnection = nil
    end
end

local function stopPulse()
    if pulseConnection then
        pulseConnection:Disconnect()
        pulseConnection = nil
    end
end

local function startRotation()
    stopRotation()
    local last = os.clock()

    rotationConnection = RunService.RenderStepped:Connect(function()
        local now = os.clock()
        local dt = now - last
        last = now

        -- Opposite rotations make the eye feel layered.
        RingOuter.Rotation = (RingOuter.Rotation + dt * 75) % 360
        RingMiddle.Rotation = (RingMiddle.Rotation - dt * 115) % 360
        TomoeFolder.Rotation = (TomoeFolder.Rotation + dt * 55) % 360
        InnerRing.Rotation = (InnerRing.Rotation - dt * 145) % 360
    end)
end

local function startPulse()
    stopPulse()
    pulseConnection = RunService.RenderStepped:Connect(function()
        if not eyeOpen then return end

        local pulse = 0.5 + math.sin(os.clock() * 3.5) * 0.5
        local s = 0.96 + pulse * 0.045

        Glow1.Size = UDim2.fromScale(s, s)
        Core.Size = UDim2.fromScale(0.065 + pulse * 0.025, 0.065 + pulse * 0.025)
    end)
end

local function showEye()
    eyeOpen = true
    stopRotation()
    stopPulse()

    -- Start tiny, then bloom into the full eye.
    Eye.Size = UDim2.fromScale(0.06, 0.06)

    for _, obj in ipairs({Glow3, Glow2, Glow1, RingOuter, RingMiddle, Iris, InnerRing, Pupil, Core}) do
        obj.Visible = true
    end

    setGlowVisible(false, true)

    local bloom = TweenInfo.new(0.62, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    tween(Eye, bloom, {Size = UDim2.fromScale(0.82, 0.82)})

    tween(RingOuter, bloom, {Size = UDim2.fromScale(0.92, 0.92)})
    tween(RingMiddle, bloom, {Size = UDim2.fromScale(0.77, 0.77)})
    tween(Iris, bloom, {Size = UDim2.fromScale(0.60, 0.60)})
    tween(InnerRing, bloom, {Size = UDim2.fromScale(0.42, 0.42)})
    tween(Pupil, bloom, {Size = UDim2.fromScale(0.20, 0.20)})
    tween(Core, bloom, {Size = UDim2.fromScale(0.075, 0.075)})

    task.delay(0.05, function()
        setGlowVisible(true, false)
    end)

    task.delay(0.25, startRotation)
    task.delay(0.35, startPulse)
end

local function hideEye()
    eyeOpen = false
    stopPulse()
    stopRotation()

    local info = TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

    -- Spin down first.
    tween(RingOuter, info, {Rotation = RingOuter.Rotation + 70})
    tween(RingMiddle, info, {Rotation = RingMiddle.Rotation - 95})
    tween(TomoeFolder, info, {Rotation = TomoeFolder.Rotation + 80})

    setGlowVisible(false, false)

    -- Everything collapses toward the pupil.
    tween(Eye, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.fromScale(0.045, 0.045)
    })

    task.delay(0.30, function()
        if not eyeOpen then
            Eye.Size = UDim2.fromScale(0.045, 0.045)
        end
    end)
end

-- The original script opens/closes Main. Watching Visible keeps this addon
-- synchronized without replacing the original menu logic.
local lastVisible = Main.Visible

local function sync()
    local visible = Main.Visible

    if visible ~= lastVisible then
        lastVisible = visible
        if visible then
            showEye()
        else
            hideEye()
        end
    end
end

Main:GetPropertyChangedSignal("Visible"):Connect(sync)

-- If the original menu starts open after its startup delay.
task.defer(function()
    task.wait(0.65)
    sync()
end)

-- Also animate immediately after the button is clicked. The deferred call
-- lets the original Zakahud callback update Main.Visible first.
ToggleBtn.MouseButton1Click:Connect(function()
    task.defer(sync)
end)

if CloseBtn then
    CloseBtn.MouseButton1Click:Connect(function()
        task.defer(sync)
    end)
end

print("[ZAKA PURE UI V1] Eye menu animation loaded.")
