--[[
    ZAKA MENU - Chỉ Menu + Mèo (Bản sạch cho Delta)
    - Chỉ có menu + animation
    - Nút đóng = hình mèo
    - Mèo bám thành menu + đầu lắc lư
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Tạo ScreenGui an toàn
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaCatMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

-- Parent an toàn cho Delta
local success = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not success then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ==================== NÚT MÈO (khi đóng) ====================
local CatBtn = Instance.new("TextButton")
CatBtn.Name = "CatButton"
CatBtn.Size = UDim2.new(0, 60, 0, 60)
CatBtn.Position = UDim2.new(0, 18, 0.4, 0)
CatBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
CatBtn.Text = "🐱"
CatBtn.TextSize = 34
CatBtn.Font = Enum.Font.GothamBold
CatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CatBtn.AutoButtonColor = false
CatBtn.Parent = ScreenGui

local corner1 = Instance.new("UICorner")
corner1.CornerRadius = UDim.new(1, 0)
corner1.Parent = CatBtn

local stroke1 = Instance.new("UIStroke")
stroke1.Color = Color3.fromRGB(180, 180, 180)
stroke1.Thickness = 2
stroke1.Parent = CatBtn

-- ==================== MAIN MENU ====================
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 0, 0, 0) -- bắt đầu nhỏ để animation
Main.Position = UDim2.new(0.5, -175, 0.5, -230)
Main.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = false
Main.Parent = ScreenGui

local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0, 20)
corner2.Parent = Main

local stroke2 = Instance.new("UIStroke")
stroke2.Color = Color3.fromRGB(70, 70, 75)
stroke2.Thickness = 1.5
stroke2.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
Header.Parent = Main

local corner3 = Instance.new("UICorner")
corner3.CornerRadius = UDim.new(0, 20)
corner3.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🐱  ZAKA HUD"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Nội dung tạm (chỉ để nhìn cho đẹp)
local Content = Instance.new("TextLabel")
Content.Size = UDim2.new(1, -30, 0, 80)
Content.Position = UDim2.new(0, 15, 0, 70)
Content.BackgroundTransparency = 1
Content.Text = "Menu đang hoạt động!\n\nMèo đã sẵn sàng 🐱"
Content.TextColor3 = Color3.fromRGB(200, 200, 200)
Content.Font = Enum.Font.Gotham
Content.TextSize = 15
Content.TextWrapped = true
Content.Parent = Main

-- ==================== CON MÈO BÁM THÀNH MENU ====================
local CatHolder = Instance.new("Frame")
CatHolder.Name = "CatMascot"
CatHolder.Size = UDim2.new(0, 70, 0, 95)
CatHolder.Position = UDim2.new(0, -40, 0.5, -47)
CatHolder.BackgroundTransparency = 1
CatHolder.ZIndex = 20
CatHolder.Parent = Main

-- Thân mèo
local CatBody = Instance.new("Frame")
CatBody.Size = UDim2.new(0, 48, 0, 48)
CatBody.Position = UDim2.new(0, 12, 0, 32)
CatBody.BackgroundColor3 = Color3.fromRGB(40, 40, 42)
CatBody.Parent = CatHolder

local cornerBody = Instance.new("UICorner")
cornerBody.CornerRadius = UDim.new(1, 0)
cornerBody.Parent = CatBody

-- Đầu mèo (sẽ lắc lư)
local CatHead = Instance.new("TextLabel")
CatHead.Name = "CatHead"
CatHead.Size = UDim2.new(0, 50, 0, 50)
CatHead.Position = UDim2.new(0, 10, 0, 0)
CatHead.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
CatHead.Text = "🐱"
CatHead.TextSize = 32
CatHead.Font = Enum.Font.GothamBold
CatHead.TextColor3 = Color3.fromRGB(255, 255, 255)
CatHead.Parent = CatHolder

local cornerHead = Instance.new("UICorner")
cornerHead.CornerRadius = UDim.new(1, 0)
cornerHead.Parent = CatHead

-- 2 chân bám vào menu
local Paw1 = Instance.new("Frame")
Paw1.Size = UDim2.new(0, 16, 0, 20)
Paw1.Position = UDim2.new(0, 50, 0, 40)
Paw1.BackgroundColor3 = Color3.fromRGB(55, 55, 58)
Paw1.Parent = CatHolder

local cornerPaw1 = Instance.new("UICorner")
cornerPaw1.CornerRadius = UDim.new(0, 6)
cornerPaw1.Parent = Paw1

local Paw2 = Instance.new("Frame")
Paw2.Size = UDim2.new(0, 16, 0, 20)
Paw2.Position = UDim2.new(0, 50, 0, 62)
Paw2.BackgroundColor3 = Color3.fromRGB(55, 55, 58)
Paw2.Parent = CatHolder

local cornerPaw2 = Instance.new("UICorner")
cornerPaw2.CornerRadius = UDim.new(0, 6)
cornerPaw2.Parent = Paw2

-- Animation đầu mèo lắc lư
task.spawn(function()
    local bob = true
    while CatHead and CatHead.Parent do
        local rot = bob and 9 or -9
        TweenService:Create(CatHead, TweenInfo.new(0.65, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Rotation = rot
        }):Play()
        bob = not bob
        task.wait(0.7)
    end
end)

-- ==================== ANIMATION MỞ / ĐÓNG ====================
local menuOpen = false

local function ToggleMenu()
    menuOpen = not menuOpen

    if menuOpen then
        Main.Visible = true
        Main.Size = UDim2.new(0, 0, 0, 0)

        TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 350, 0, 460)
        }):Play()

        TweenService:Create(CatBtn, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(255, 70, 70),
            Text = "✕"
        }):Play()
    else
        local tw = TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        })
        tw:Play()
        tw.Completed:Wait()
        Main.Visible = false

        TweenService:Create(CatBtn, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(28, 28, 30),
            Text = "🐱"
        }):Play()
    end
end

CatBtn.MouseButton1Click:Connect(ToggleMenu)

-- ===== ÉP HIỆN MENU NGAY KHI LOAD =====
task.delay(0.8, function()
    if not menuOpen then
        ToggleMenu() -- tự mở 1 lần để chắc chắn bạn thấy
    end
end)

print("✅ Zaka Cat Menu đã load thành công!")
