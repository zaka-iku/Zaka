-- Delta Executor Full Keyboard & Menu Script for DOORS
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Clean Gui cũ nếu đã chạy trước đó
if LocalPlayer.PlayerGui:FindFirstChild("FullKeyboardOTG") then
    LocalPlayer.PlayerGui.FullKeyboardOTG:Destroy()
end

-- 1. Tạo ScreenGui chính
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FullKeyboardOTG"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 2. Hàm tạo Thông báo (Popup Notification)
local function showNotification(text)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 220, 0, 40)
    notif.Position = UDim2.new(0.5, -110, 0.1, 0)
    notif.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.Text = text
    notif.Font = Enum.Font.SourceSansBold
    notif.TextSize = 18
    notif.BackgroundTransparency = 0.2
    notif.Parent = ScreenGui

    -- Bo góc cho thông báo
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif

    -- Hiệu ứng ẩn dần
    task.delay(1.5, function()
        local tween = TweenService:Create(notif, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1})
        tween:Play()
        tween.Completed:Connect(function()
            notif:Destroy()
        end)
    end)
end

-- 3. Nút Toggle MENU
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 70, 0, 40)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.05, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "MENU"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 16
ToggleBtn.Parent = ScreenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = ToggleBtn

-- 4. Khung Bàn Phím Chính (Full Keyboard Frame)
local MainFrame = Instance.new("ScrollingFrame")
MainFrame.Size = UDim2.new(0, 850, 0, 260)
MainFrame.Position = UDim2.new(0.5, -425, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.15
MainFrame.CanvasSize = UDim2.new(0, 980, 0, 250)
MainFrame.ScrollBarThickness = 6
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true -- Cho phép kéo thả vị trí bàn phím
MainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = MainFrame

-- Hàm tạo phím bấm ảo
local function createKey(text, posX, posY, sizeX, sizeY, keyCode)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.Size = UDim2.new(0, sizeX, 0, sizeY)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.Parent = MainFrame

    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(0, 4)
    kCorner.Parent = btn

    btn.MouseButton1Down:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        if keyCode then
            VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
        end
    end)

    btn.MouseButton1Up:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        if keyCode then
            VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
        end
    end)
end

-- ==========================================
-- KHỞI TẠO NGUYÊN BÀN PHÍM MÁY TÍNH (104 PHÍM)
-- ==========================================

-- Hàng 0: Function Keys (ESC, F1-F12, Print, Scroll, Pause)
createKey("Esc", 5, 5, 35, 30, Enum.KeyCode.Escape)
local fKeys = {Enum.KeyCode.F1, Enum.KeyCode.F2, Enum.KeyCode.F3, Enum.KeyCode.F4, Enum.KeyCode.F5, Enum.KeyCode.F6, Enum.KeyCode.F7, Enum.KeyCode.F8, Enum.KeyCode.F9, Enum.KeyCode.F10, Enum.KeyCode.F11, Enum.KeyCode.F12}
for i, k in ipairs(fKeys) do
    local offset = (i > 8 and 60) or (i > 4 and 45) or 30
    createKey("F"..i, 20 + i*35 + offset, 5, 32, 30, k)
end
createKey("PrtSc", 520, 5, 35, 30, Enum.KeyCode.Print)
createKey("ScrLk", 560, 5, 35, 30, Enum.KeyCode.ScrollLock)
createKey("Pause", 600, 5, 35, 30, Enum.KeyCode.Pause)

-- Hàng 1: Number Row (~, 1-0, -, =, Backspace)
local r1 = {{"`", Enum.KeyCode.Backquote}, {"1", Enum.KeyCode.One}, {"2", Enum.KeyCode.Two}, {"3", Enum.KeyCode.Three}, {"4", Enum.KeyCode.Four}, {"5", Enum.KeyCode.Five}, {"6", Enum.KeyCode.Six}, {"7", Enum.KeyCode.Seven}, {"8", Enum.KeyCode.Eight}, {"9", Enum.KeyCode.Nine}, {"0", Enum.KeyCode.Zero}, {"-", Enum.KeyCode.Minus}, {"=", Enum.KeyCode.Equals}}
for i, item in ipairs(r1) do
    createKey(item[1], 5 + (i-1)*35, 40, 32, 32, item[2])
end
createKey("Backspace", 460, 40, 65, 32, Enum.KeyCode.Backspace)
createKey("Ins", 530, 40, 35, 32, Enum.KeyCode.Insert)
createKey("Home", 570, 40, 35, 32, Enum.KeyCode.Home)
createKey("PgUp", 610, 40, 35, 32, Enum.KeyCode.PageUp)

-- Hàng 2: QWERTY Row (Tab, Q-P, [, ], \)
createKey("Tab", 5, 75, 48, 32, Enum.KeyCode.Tab)
local r2 = {{"Q", Enum.KeyCode.Q}, {"W", Enum.KeyCode.W}, {"E", Enum.KeyCode.E}, {"R", Enum.KeyCode.R}, {"T", Enum.KeyCode.T}, {"Y", Enum.KeyCode.Y}, {"U", Enum.KeyCode.U}, {"I", Enum.KeyCode.I}, {"O", Enum.KeyCode.O}, {"P", Enum.KeyCode.P}, {"[", Enum.KeyCode.LeftBracket}, {"]", Enum.KeyCode.RightBracket}, {"\\", Enum.KeyCode.BackSlash}}
for i, item in ipairs(r2) do
    createKey(item[1], 56 + (i-1)*35, 75, 32, 32, item[2])
end
createKey("Del", 530, 75, 35, 32, Enum.KeyCode.Delete)
createKey("End", 570, 75, 35, 32, Enum.KeyCode.End)
createKey("PgDn", 610, 75, 35, 32, Enum.KeyCode.PageDown)

-- Hàng 3: ASDFGH Row (Caps, A-L, ;, ', Enter)
createKey("Caps", 5, 110, 58, 32, Enum.KeyCode.CapsLock)
local r3 = {{"A", Enum.KeyCode.A}, {"S", Enum.KeyCode.S}, {"D", Enum.KeyCode.D}, {"F", Enum.KeyCode.F}, {"G", Enum.KeyCode.G}, {"H", Enum.KeyCode.H}, {"J", Enum.KeyCode.J}, {"K", Enum.KeyCode.K}, {"L", Enum.KeyCode.L}, {";", Enum.KeyCode.Semicolon}, {"'", Enum.KeyCode.Quote}}
for i, item in ipairs(r3) do
    createKey(item[1], 66 + (i-1)*35, 110, 32, 32, item[2])
end
createKey("Enter", 451, 110, 74, 32, Enum.KeyCode.Return)

-- Hàng 4: ZXCVBN Row (Shift, Z-M, ,, ., /, Shift)
createKey("Shift", 5, 145, 75, 32, Enum.KeyCode.LeftShift)
local r4 = {{"Z", Enum.KeyCode.Z}, {"X", Enum.KeyCode.X}, {"C", Enum.KeyCode.C}, {"V", Enum.KeyCode.V}, {"B", Enum.KeyCode.B}, {"N", Enum.KeyCode.N}, {"M", Enum.KeyCode.M}, {",", Enum.KeyCode.Comma}, {".", Enum.KeyCode.Period}, {"/", Enum.KeyCode.Slash}}
for i, item in ipairs(r4) do
    createKey(item[1], 83 + (i-1)*35, 145, 32, 32, item[2])
end
createKey("RShift", 433, 145, 92, 32, Enum.KeyCode.RightShift)
createKey("▲", 570, 145, 35, 32, Enum.KeyCode.Up)

-- Hàng 5: Bottom Row (Ctrl, Win, Alt, Space, Alt, Win, Menu, Ctrl, Arrows)
createKey("Ctrl", 5, 180, 45, 32, Enum.KeyCode.LeftControl)
createKey("Win", 53, 180, 40, 32, Enum.KeyCode.LeftSuper)
createKey("Alt", 96, 180, 40, 32, Enum.KeyCode.LeftAlt)
createKey("Space Bar", 139, 180, 200, 32, Enum.KeyCode.Space)
createKey("RAlt", 342, 180, 40, 32, Enum.KeyCode.RightAlt)
createKey("RWin", 385, 180, 40, 32, Enum.KeyCode.RightSuper)
createKey("RCtrl", 428, 180, 45, 32, Enum.KeyCode.RightControl)
createKey("◄", 530, 180, 35, 32, Enum.KeyCode.Left)
createKey("▼", 570, 180, 35, 32, Enum.KeyCode.Down)
createKey("►", 610, 180, 35, 32, Enum.KeyCode.Right)

-- Cụm Numpad (Cụm phím số bên phải 17 phím)
local npX = 660
createKey("Num", npX, 5, 32, 30, Enum.KeyCode.NumLock)
createKey("/", npX+35, 5, 32, 30, Enum.KeyCode.KeypadDivide)
createKey("*", npX+70, 5, 32, 30, Enum.KeyCode.KeypadMultiply)
createKey("-", npX+105, 5, 32, 30, Enum.KeyCode.KeypadMinus)

createKey("7", npX, 40, 32, 32, Enum.KeyCode.KeypadSeven)
createKey("8", npX+35, 40, 32, 32, Enum.KeyCode.KeypadEight)
createKey("9", npX+70, 40, 32, 32, Enum.KeyCode.KeypadNine)
createKey("+", npX+105, 40, 32, 67, Enum.KeyCode.KeypadPlus)

createKey("4", npX, 75, 32, 32, Enum.KeyCode.KeypadFour)
createKey("5", npX+35, 75, 32, 32, Enum.KeyCode.KeypadFive)
createKey("6", npX+70, 75, 32, 32, Enum.KeyCode.KeypadSix)

createKey("1", npX, 110, 32, 32, Enum.KeyCode.KeypadOne)
createKey("2", npX+35, 110, 32, 32, Enum.KeyCode.KeypadTwo)
createKey("3", npX+70, 110, 32, 32, Enum.KeyCode.KeypadThree)
createKey("Ent", npX+105, 110, 32, 67, Enum.KeyCode.KeypadEnter)

createKey("0", npX, 145, 67, 32, Enum.KeyCode.KeypadZero)
createKey(".", npX+70, 145, 32, 32, Enum.KeyCode.KeypadPeriod)

-- 5. Logic Nút Toggle Menu + Thông báo "Thành công"
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        showNotification("Bật Bàn Phím Thành Công!")
    else
        showNotification("Ẩn Bàn Phím Thành Công!")
    end
end)

-- Thông báo kích hoạt ban đầu
showNotification("Tải Bàn Phím OTG Thành Công!")
