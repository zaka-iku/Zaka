--==============================================================
-- ZAKA PURE UI V1
-- ANIME EYE MENU ANIMATION
--==============================================================

local SOURCE = "https://raw.githubusercontent.com/zaka-iku/Zaka/main/Zakahud.lua"

--==============================================================
-- LOAD ZAKA MENU GỐC
--==============================================================

local success, err = pcall(function()
    loadstring(game:HttpGet(SOURCE))()
end)

if not success then
    warn("[ZAKA V1] Load failed:", err)
    return
end

--==============================================================
-- SERVICES
--==============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Đợi menu gốc tạo xong
local ZakaGui

repeat
    ZakaGui = PlayerGui:FindFirstChild("ZakaPureUI")
    task.wait()
until ZakaGui

-- Nút Z và Main của code gốc
local ToggleBtn = ZakaGui:FindFirstChildWhichIsA("TextButton")
local Main = ZakaGui:FindFirstChild("Frame")

if not ToggleBtn then
    warn("[ZAKA V1] Không tìm thấy nút Z.")
    return
end

if not Main then
    warn("[ZAKA V1] Không tìm thấy Main.")
    return
end

--==============================================================
-- XÓA EYE CŨ NẾU RELOAD
--==============================================================

local OldEye = ToggleBtn:FindFirstChild("ZAKA_ANIME_EYE")

if OldEye then
    OldEye:Destroy()
end

--==============================================================
-- CẤU HÌNH
--==============================================================

ToggleBtn.Text = ""

local EYE_Z = ToggleBtn.ZIndex + 10

local Purple = Color3.fromRGB(155, 40, 255)
local BrightPurple = Color3.fromRGB(235, 90, 255)
local PinkPurple = Color3.fromRGB(255, 120, 255)
local DarkPurple = Color3.fromRGB(28, 0, 48)
local Black = Color3.fromRGB(3, 0, 8)

--==============================================================
-- EYE ROOT
--==============================================================

local Eye = Instance.new("Frame")
Eye.Name = "ZAKA_ANIME_EYE"
Eye.AnchorPoint = Vector2.new(0.5, 0.5)
Eye.Position = UDim2.fromScale(0.5, 0.5)
Eye.Size = UDim2.fromScale(0.86, 0.86)
Eye.BackgroundTransparency = 1
Eye.ZIndex = EYE_Z
Eye.Parent = ToggleBtn

--==============================================================
-- HELPER
--==============================================================

local function MakeCircle(name, size, color, transparency, z)
    local obj = Instance.new("Frame")

    obj.Name = name
    obj.AnchorPoint = Vector2.new(0.5, 0.5)
    obj.Position = UDim2.fromScale(0.5, 0.5)
    obj.Size = UDim2.fromScale(size, size)

    obj.BackgroundColor3 = color
    obj.BackgroundTransparency = transparency or 0
    obj.BorderSizePixel = 0

    obj.ZIndex = z or EYE_Z
    obj.Parent = Eye

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = obj

    return obj
end

local function MakeStroke(parent, thickness, color, transparency)
    local s = Instance.new("UIStroke")

    s.Thickness = thickness
    s.Color = color
    s.Transparency = transparency or 0

    s.Parent = parent

    return s
end

local function Tween(obj, duration, easing, direction, properties)
    local info = TweenInfo.new(
        duration,
        easing or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )

    local tw = TweenService:Create(obj, info, properties)
    tw:Play()

    return tw
end

--==============================================================
-- OUTER GLOW
--==============================================================

local GlowBig = MakeCircle(
    "GlowBig",
    1.18,
    Purple,
    1,
    EYE_Z
)

local GlowMedium = MakeCircle(
    "GlowMedium",
    1.05,
    BrightPurple,
    1,
    EYE_Z + 1
)

local GlowSmall = MakeCircle(
    "GlowSmall",
    0.94,
    Purple,
    1,
    EYE_Z + 2
)

--==============================================================
-- OUTER RING
--==============================================================

local OuterRing = MakeCircle(
    "OuterRing",
    0.91,
    Black,
    0.18,
    EYE_Z + 3
)

MakeStroke(
    OuterRing,
    2.3,
    BrightPurple,
    0.1
)

--==============================================================
-- SECOND RING
--==============================================================

local SecondRing = MakeCircle(
    "SecondRing",
    0.76,
    DarkPurple,
    0.05,
    EYE_Z + 4
)

MakeStroke(
    SecondRing,
    1.5,
    Purple,
    0.05
)

--==============================================================
-- IRIS
--==============================================================

local Iris = MakeCircle(
    "Iris",
    0.60,
    Color3.fromRGB(65, 5, 105),
    0,
    EYE_Z + 5
)

MakeStroke(
    Iris,
    1.7,
    PinkPurple,
    0.08
)

--==============================================================
-- IRIS INNER RING
--==============================================================

local IrisInner = MakeCircle(
    "IrisInner",
    0.43,
    Color3.fromRGB(25, 0, 42),
    0,
    EYE_Z + 6
)

MakeStroke(
    IrisInner,
    1.2,
    BrightPurple,
    0.1
)

--==============================================================
-- PUPIL
--==============================================================

local Pupil = MakeCircle(
    "Pupil",
    0.19,
    Black,
    0,
    EYE_Z + 9
)

MakeStroke(
    Pupil,
    1.2,
    PinkPurple,
    0.05
)

--==============================================================
-- PUPIL CORE
--==============================================================

local Core = MakeCircle(
    "Core",
    0.065,
    Color3.fromRGB(255, 225, 255),
    0.05,
    EYE_Z + 10
)

--==============================================================
-- TOMOE RING
--==============================================================

local TomoeRing = Instance.new("Frame")

TomoeRing.Name = "TomoeRing"
TomoeRing.AnchorPoint = Vector2.new(0.5, 0.5)
TomoeRing.Position = UDim2.fromScale(0.5, 0.5)
TomoeRing.Size = UDim2.fromScale(0.72, 0.72)
TomoeRing.BackgroundTransparency = 1
TomoeRing.ZIndex = EYE_Z + 8
TomoeRing.Parent = Eye

--==============================================================
-- TOMOE CREATOR
--==============================================================

local Tomoes = {}

for i = 1, 3 do

    local holder = Instance.new("Frame")

    holder.Name = "TomoeHolder_" .. i
    holder.AnchorPoint = Vector2.new(0.5, 0.5)
    holder.Position = UDim2.fromScale(0.5, 0.5)
    holder.Size = UDim2.fromScale(1, 1)
    holder.BackgroundTransparency = 1
    holder.Rotation = (i - 1) * 120
    holder.ZIndex = EYE_Z + 8
    holder.Parent = TomoeRing

    local tomoe = Instance.new("Frame")

    tomoe.Name = "Tomoe"
    tomoe.AnchorPoint = Vector2.new(0.5, 0.5)

    tomoe.Position = UDim2.fromScale(
        0.5,
        0.16
    )

    tomoe.Size = UDim2.fromScale(
        0.13,
        0.22
    )

    tomoe.BackgroundColor3 = BrightPurple
    tomoe.BackgroundTransparency = 1
    tomoe.BorderSizePixel = 0
    tomoe.Rotation = 25
    tomoe.ZIndex = EYE_Z + 9
    tomoe.Parent = holder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = tomoe

    local stroke = Instance.new("UIStroke")
    stroke.Color = PinkPurple
    stroke.Thickness = 1
    stroke.Transparency = 1
    stroke.Parent = tomoe

    table.insert(Tomoes, tomoe)
end

--==============================================================
-- ORBIT DOTS
--==============================================================

local OrbitDots = {}

for i = 1, 6 do

    local dot = MakeCircle(
        "OrbitDot_" .. i,
        0.045,
        PinkPurple,
        1,
        EYE_Z + 9
    )

    local angle = math.rad((i - 1) * 60)

    dot.Position = UDim2.fromScale(
        0.5 + math.cos(angle) * 0.39,
        0.5 + math.sin(angle) * 0.39
    )

    table.insert(OrbitDots, dot)
end

--==============================================================
-- EYE LID EFFECT
--==============================================================

local TopLid = Instance.new("Frame")

TopLid.Name = "TopLid"
TopLid.AnchorPoint = Vector2.new(0.5, 1)
TopLid.Position = UDim2.fromScale(0.5, 0)
TopLid.Size = UDim2.fromScale(1.15, 0.48)
TopLid.BackgroundColor3 = Color3.fromRGB(5, 1, 10)
TopLid.BackgroundTransparency = 0.1
TopLid.BorderSizePixel = 0
TopLid.ZIndex = EYE_Z + 20
TopLid.Parent = Eye

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(1, 0)
TopCorner.Parent = TopLid

-- Vì là hiệu ứng overlay nên ban đầu ẩn.
TopLid.Visible = false

--==============================================================
-- ROTATION STATE
--==============================================================

local EyeOpen = false
local RotationConnection
local PulseConnection

--==============================================================
-- START ROTATION
--==============================================================

local function StartRotation()

    if RotationConnection then
        RotationConnection:Disconnect()
    end

    local last = os.clock()

    RotationConnection = RunService.RenderStepped:Connect(function()

        if not EyeOpen then
            return
        end

        local now = os.clock()
        local dt = now - last

        last = now

        -- Ngoài quay một chiều
        OuterRing.Rotation =
            (OuterRing.Rotation + dt * 70) % 360

        -- Vòng giữa quay ngược
        SecondRing.Rotation =
            (SecondRing.Rotation - dt * 110) % 360

        -- Tomoe quay
        TomoeRing.Rotation =
            (TomoeRing.Rotation + dt * 55) % 360

        -- Inner ring quay nhanh
        IrisInner.Rotation =
            (IrisInner.Rotation - dt * 150) % 360

    end)
end

--==============================================================
-- STOP ROTATION
--==============================================================

local function StopRotation()

    if RotationConnection then
        RotationConnection:Disconnect()
        RotationConnection = nil
    end

end

--==============================================================
-- PULSE
--==============================================================

local function StartPulse()

    if PulseConnection then
        PulseConnection:Disconnect()
    end

    PulseConnection = RunService.RenderStepped:Connect(function()

        if not EyeOpen then
            return
        end

        local pulse =
            (math.sin(os.clock() * 3.5) + 1) / 2

        GlowSmall.Size =
            UDim2.fromScale(
                0.94 + pulse * 0.06,
                0.94 + pulse * 0.06
            )

        Core.Size =
            UDim2.fromScale(
                0.06 + pulse * 0.025,
                0.06 + pulse * 0.025
            )

    end)

end

local function StopPulse()

    if PulseConnection then
        PulseConnection:Disconnect()
        PulseConnection = nil
    end

end

--==============================================================
-- SHOW EYE
--==============================================================

local function OpenEye()

    if EyeOpen then
        return
    end

    EyeOpen = true

    StopRotation()
    StopPulse()

    -- Thu nhỏ trước
    Eye.Size = UDim2.fromScale(
        0.04,
        0.04
    )

    -- Tất cả hiện
    GlowBig.BackgroundTransparency = 1
    GlowMedium.BackgroundTransparency = 1
    GlowSmall.BackgroundTransparency = 1

    OuterRing.BackgroundTransparency = 0.2
    SecondRing.BackgroundTransparency = 0.05
    Iris.BackgroundTransparency = 0
    IrisInner.BackgroundTransparency = 0
    Pupil.BackgroundTransparency = 0
    Core.BackgroundTransparency = 0.05

    -- Tomoe ẩn
    for _, tomoe in ipairs(Tomoes) do
        tomoe.BackgroundTransparency = 1

        local st = tomoe:FindFirstChildOfClass("UIStroke")

        if st then
            st.Transparency = 1
        end
    end

    -- Orbit dots ẩn
    for _, dot in ipairs(OrbitDots) do
        dot.BackgroundTransparency = 1
    end

    --==========================================================
    -- EYE BLOOM
    --==========================================================

    Tween(
        Eye,
        0.60,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out,
        {
            Size = UDim2.fromScale(
                0.86,
                0.86
            )
        }
    )

    Tween(
        GlowBig,
        0.45,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out,
        {
            BackgroundTransparency = 0.82
        }
    )

    Tween(
        GlowMedium,
        0.42,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out,
        {
            BackgroundTransparency = 0.70
        }
    )

    Tween(
        GlowSmall,
        0.38,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out,
        {
            BackgroundTransparency = 0.50
        }
    )

    --==========================================================
    -- TOMOE APPEAR
    --==========================================================

    task.delay(0.16, function()

        for index, tomoe in ipairs(Tomoes) do

            task.delay(
                (index - 1) * 0.07,
                function()

                    Tween(
                        tomoe,
                        0.28,
                        Enum.EasingStyle.Back,
                        Enum.EasingDirection.Out,
                        {
                            BackgroundTransparency = 0.03
                        }
                    )

                    local st =
                        tomoe:FindFirstChildOfClass("UIStroke")

                    if st then

                        Tween(
                            st,
                            0.28,
                            Enum.EasingStyle.Quint,
                            Enum.EasingDirection.Out,
                            {
                                Transparency = 0.10
                            }
                        )

                    end

                end
            )

        end

    end)

    --==========================================================
    -- ORBIT DOTS
    --==========================================================

    task.delay(0.22, function()

        for _, dot in ipairs(OrbitDots) do

            Tween(
                dot,
                0.30,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out,
                {
                    BackgroundTransparency = 0.08
                }
            )

        end

    end)

    -- Bắt đầu quay
    task.delay(0.30, function()

        if EyeOpen then
            StartRotation()
            StartPulse()
        end

    end)

end

--==============================================================
-- HIDE EYE
--==============================================================

local function CloseEye()

    if not EyeOpen then
        return
    end

    EyeOpen = false

    StopPulse()
    StopRotation()

    -- Quay thêm một đoạn trước khi biến mất
    Tween(
        OuterRing,
        0.30,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.In,
        {
            Rotation = OuterRing.Rotation + 100
        }
    )

    Tween(
        SecondRing,
        0.30,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.In,
        {
            Rotation = SecondRing.Rotation - 130
        }
    )

    Tween(
        TomoeRing,
        0.30,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.In,
        {
            Rotation = TomoeRing.Rotation + 90
        }
    )

    -- Tomoe biến mất
    for _, tomoe in ipairs(Tomoes) do

        Tween(
            tomoe,
            0.20,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.In,
            {
                BackgroundTransparency = 1
            }
        )

        local st =
            tomoe:FindFirstChildOfClass("UIStroke")

        if st then
            Tween(
                st,
                0.20,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.In,
                {
                    Transparency = 1
                }
            )
        end

    end

    -- Glow tắt
    Tween(
        GlowBig,
        0.28,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.In,
        {
            BackgroundTransparency = 1
        }
    )

    Tween(
        GlowMedium,
        0.25,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.In,
        {
            BackgroundTransparency = 1
        }
    )

    Tween(
        GlowSmall,
        0.22,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.In,
        {
            BackgroundTransparency = 1
        }
    )

    for _, dot in ipairs(OrbitDots) do

        Tween(
            dot,
            0.18,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.In,
            {
                BackgroundTransparency = 1
            }
        )

    end

    --==========================================================
    -- EYE COLLAPSE
    --==========================================================

    Tween(
        Eye,
        0.42,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.In,
        {
            Size = UDim2.fromScale(
                0.035,
                0.035
            )
        }
    )

end

--==============================================================
-- BẮT ĐẦU TRẠNG THÁI
--==============================================================

local VisualOpen = false

-- Menu gốc tự mở sau 0.5 giây.
task.delay(0.75, function()

    if Main.Visible and not VisualOpen then

        VisualOpen = true
        OpenEye()

    end

end)

--==============================================================
-- NÚT Z
--==============================================================

ToggleBtn.MouseButton1Click:Connect(function()

    -- Chờ code gốc xử lý OpenMenu / CloseMenu
    task.delay(0.05, function()

        if Main.Visible then

            if not VisualOpen then

                VisualOpen = true
                OpenEye()

            end

        else

            if VisualOpen then

                VisualOpen = false
                CloseEye()

            end

        end

    end)

end)

--==============================================================
-- NÚT X ĐÓNG MENU
--==============================================================

local CloseBtn

for _, obj in ipairs(Main:GetDescendants()) do

    if obj:IsA("TextButton") and obj.Text == "×" then

        CloseBtn = obj
        break

    end

end

if CloseBtn then

    CloseBtn.MouseButton1Click:Connect(function()

        task.delay(0.05, function()

            if not Main.Visible and VisualOpen then

                VisualOpen = false
                CloseEye()

            end

        end)

    end)

end

--==============================================================
-- THE END
--==============================================================

print("🔥 ZAKA PURE UI V1 - ANIME EYE MENU LOADED")
