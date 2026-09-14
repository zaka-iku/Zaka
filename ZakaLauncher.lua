--==============================================================================--
--                ZAKA ECOSYSTEM // MASTER HUB & ANIMATION v3.5                 --
--==============================================================================--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Dọn dẹp Hub cũ nếu có
if PlayerGui:FindFirstChild("ZakaMasterHub") then
    PlayerGui.ZakaMasterHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaMasterHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Main Container (Hiệu ứng scale pop-up siêu mượt)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 16, 24)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 180, 255)
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

-- Animation mở Hub chính
TweenService:Create(MainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 520, 0, 310),
    Position = UDim2.new(0.5, -260, 0.5, -155)
}):Play()

-- Topbar (Thanh tiêu đề có thể kéo thả)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 48)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 24, 36)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 14)

local FixBar = Instance.new("Frame")
FixBar.Size = UDim2.new(1, 0, 0, 12)
FixBar.Position = UDim2.new(0, 0, 1, -12)
FixBar.BackgroundColor3 = Color3.fromRGB(18, 24, 36)
FixBar.BorderSizePixel = 0
FixBar.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 18, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "⚡ ZAKA MULTI-HUB // CHỌN HỆ THỐNG"
TitleLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Logic Kéo thả (Dragging) mượt mà
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Nút Đóng (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -40, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
CloseBtn.BorderSizePixel = 0
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextSize = 14
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.3)
    ScreenGui:Destroy()
end)

--==============================================================================--
--                 HAI TAB CHÍNH (GIẢI TRÍ & BLOX FRUIT)                        --
--==============================================================================--

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -36, 1, -75)
Container.Position = UDim2.new(0, 18, 0, 60)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

-- Tab 1: Phần Giải Trí (Bên Trái)
local EntCard = Instance.new("TextButton")
EntCard.Size = UDim2.new(0.48, 0, 1, 0)
EntCard.Position = UDim2.new(0, 0, 0, 0)
EntCard.BackgroundColor3 = Color3.fromRGB(18, 25, 40)
EntCard.BorderSizePixel = 0
EntCard.AutoButtonColor = false
EntCard.Text = ""
EntCard.Parent = Container
Instance.new("UICorner", EntCard).CornerRadius = UDim.new(0, 10)

local EntStroke = Instance.new("UIStroke")
EntStroke.Color = Color3.fromRGB(0, 160, 255)
EntStroke.Transparency = 0.5
EntStroke.Parent = EntCard

local EntTitle = Instance.new("TextLabel")
EntTitle.Size = UDim2.new(1, 0, 0, 30)
EntTitle.Position = UDim2.new(0, 0, 0.25, 0)
EntTitle.BackgroundTransparency = 1
EntTitle.Font = Enum.Font.GothamBold
EntTitle.Text = "🎮 GIẢI TRÍ UI"
EntTitle.TextColor3 = Color3.fromRGB(0, 220, 255)
EntTitle.TextSize = 16
EntTitle.Parent = EntCard

local EntDesc = Instance.new("TextLabel")
EntDesc.Size = UDim2.new(1, -20, 0, 50)
EntDesc.Position = UDim2.new(0, 10, 0.42, 0)
EntDesc.BackgroundTransparency = 1
EntDesc.Font = Enum.Font.GothamMedium
EntDesc.Text = "Tích hợp Aimbot, Noclip, Freecam, Fullbright và các tính năng Troll siêu cấp."
EntDesc.TextColor3 = Color3.fromRGB(150, 170, 200)
EntDesc.TextSize = 11
EntDesc.TextWrapped = true
EntDesc.Parent = EntCard

-- Tab 2: Phần Blox Fruit (Bên Phải)
local BloxCard = Instance.new("TextButton")
BloxCard.Size = UDim2.new(0.48, 0, 1, 0)
BloxCard.Position = UDim2.new(0.52, 0, 0, 0)
BloxCard.BackgroundColor3 = Color3.fromRGB(25, 20, 30)
BloxCard.BorderSizePixel = 0
BloxCard.AutoButtonColor = false
BloxCard.Text = ""
BloxCard.Parent = Container
Instance.new("UICorner", BloxCard).CornerRadius = UDim.new(0, 10)

local BloxStroke = Instance.new("UIStroke")
BloxStroke.Color = Color3.fromRGB(255, 140, 0)
BloxStroke.Transparency = 0.5
BloxStroke.Parent = BloxCard

local BloxTitle = Instance.new("TextLabel")
BloxTitle.Size = UDim2.new(1, 0, 0, 30)
BloxTitle.Position = UDim2.new(0, 0, 0.25, 0)
BloxTitle.BackgroundTransparency = 1
BloxTitle.Font = Enum.Font.GothamBold
BloxTitle.Text = "⚔️ BLOX FRUIT"
BloxTitle.TextColor3 = Color3.fromRGB(255, 160, 0)
BloxTitle.TextSize = 16
BloxCard.Parent = Container -- (Giữ đúng cấu trúc cha)
BloxTitle.Parent = BloxCard

local BloxDesc = Instance.new("TextLabel")
BloxDesc.Size = UDim2.new(1, -20, 0, 50)
BloxDesc.Position = UDim2.new(0, 10, 0.42, 0)
BloxDesc.BackgroundTransparency = 1
BloxDesc.Font = Enum.Font.GothamMedium
BloxDesc.Text = "Hệ thống chuyên sâu cày cuốc, Auto Farm, Sea Events và tính năng độc quyền."
BloxDesc.TextColor3 = Color3.fromRGB(200, 170, 150)
BloxDesc.TextSize = 11
BloxDesc.TextWrapped = true
BloxDesc.Parent = BloxCard

-- Hiệu ứng Hover mượt mà cho 2 Tab
EntCard.MouseEnter:Connect(function()
    TweenService:Create(EntCard, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(24, 34, 54)}):Play()
    TweenService:Create(EntStroke, TweenInfo.new(0.2), {Transparency = 0.1}):Play()
end)
EntCard.MouseLeave:Connect(function()
    TweenService:Create(EntCard, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(18, 25, 40)}):Play()
    TweenService:Create(EntStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
end)

BloxCard.MouseEnter:Connect(function()
    TweenService:Create(BloxCard, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 28, 42)}):Play()
    TweenService:Create(BloxStroke, TweenInfo.new(0.2), {Transparency = 0.1}):Play()
end)
BloxCard.MouseLeave:Connect(function()
    TweenService:Create(BloxCard, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 20, 30)}):Play()
    TweenService:Create(BloxStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
end)

--==============================================================================--
--                      SỰ KIỆN CLICK CHUYỂN MODULE                             --
--==============================================================================--

-- Ấn vào Tab Giải Trí -> Load link Zakahud.lua
EntCard.MouseButton1Click:Connect(function()
    TweenService:Create(EntCard, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
    task.wait(0.15)
    ScreenGui:Destroy()
    
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/zaka-iku/Zaka/main/Zakahud.lua"))()
    end)
    if not success then
        warn("Lỗi load Zaka Giải Trí: " .. tostring(err))
    end
end)

-- Ấn vào Tab Blox Fruit -> Load link ZakaBloxFruit.lua
BloxCard.MouseButton1Click:Connect(function()
    TweenService:Create(BloxCard, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 120, 0)}):Play()
    task.wait(0.15)
    ScreenGui:Destroy()
    
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/zaka-iku/Zaka/main/ZakaBloxFruit.lua"))()
    end)
    if not success then
        warn("Lỗi load Zaka Blox Fruit: " .. tostring(err))
    end
end)

print("⚡ Zaka Master Hub Loaded Successfully!")
