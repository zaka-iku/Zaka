--[[
    ZAKA HUB - BLOX FRUITS (NO KEY EDITION)
    Modern UI with Smooth Animations & Smart Icons
]]

repeat task.wait() until game:IsLoaded()

-- Kiểm tra game Blox Fruits (GameId: 994732206)
if tostring(game.GameId) ~= "994732206" then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Zaka Hub",
        Text = "Script này được thiết kế riêng cho Blox Fruits!",
        Icon = "rbxassetid://137698471325689",
    })
    return
end

-- Xóa GUI cũ nếu có
if game:GetService("CoreGui"):FindFirstChild("ZakaModernUI") then
    game:GetService("CoreGui"):FindFirstChild("ZakaModernUI"):Destroy()
end

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaModernUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Nút mở/đóng menu (Floating Toggle Button có bo góc tròn hoàn hảo)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
ToggleBtn.Position = UDim2.new(0, 25, 0.3, 0)
ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "🛡️"
ToggleBtn.TextSize = 22
ToggleBtn.Active = true
ToggleBtn.Draggable = true

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Parent = ToggleBtn
ToggleStroke.Color = Color3.fromRGB(215, 40, 114)
ToggleStroke.Thickness = 2

-- Khung Menu Chính (Hiệu ứng trong suốt & bo góc hiện đại)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
MainFrame.BackgroundTransparency = 0.08
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(215, 40, 114)
MainStroke.Thickness = 1.5

-- Tiêu đề Hub
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 20, 0, 15)
Title.Size = UDim2.new(1, -40, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "ZAKA HUB <font color='#D72872'>| Premium Free</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Khu vực chứa Tab (Sidebar bên trái)
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
TabContainer.BackgroundTransparency = 0.5
TabContainer.Position = UDim2.new(0, 15, 0, 55)
TabContainer.Size = UDim2.new(0, 130, 0, 285)
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
TabContainer.ScrollBarThickness = 2

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 8)
TabCorner.Parent = TabContainer

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabContainer
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 6)

-- Khu vực chứa nội dung chức năng (Container bên phải)
local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 155, 0, 55)
ContentContainer.Size = UDim2.new(0, 350, 0, 285)

-- Hàm tạo các Tab thông minh có Icon
local function createTab(name, iconText)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Parent = TabContainer
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TabBtn.BackgroundTransparency = 0.3
    TabBtn.Size = UDim2.new(1, 0, 0, 38)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Text = "  " .. iconText .. "  " .. name
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 195)
    TabBtn.TextSize = 13
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = TabBtn

    -- Nội dung trang tương ứng với Tab
    local Page = Instance.new("ScrollingFrame")
    Page.Parent = ContentContainer
    Page.BackgroundTransparency = 1
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ScrollBarThickness = 3
    Page.Visible = false

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = Page
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 8)

    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(ContentContaineraggio := ContentContainer:GetChildren()) do
            if v:IsA("ScrollingFrame") then v.Visible = false end
        end
        for _, v in pairs(TabContainer:GetChildren()) do
            if v:IsA("TextButton") then 
                TweenService:Create(v, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
            end
        end
        Page.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(215, 40, 114)}):Play()
    end)

    return Page
end

-- Hàm tạo nút chức năng (Toggle Button với Animation bo tròn đẹp mắt)
local function createToggle(parentPage, labelText, iconText, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = parentPage
    Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    Btn.Size = UDim2.new(1, -5, 0, 42)
    Btn.Font = Enum.Font.GothamMedium
    Btn.Text = "   " .. iconText .. "  " .. labelText
    Btn.TextColor3 = Color3.fromRGB(230, 230, 240)
    Btn.TextSize = 13
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Btn

    -- Trạng thái Bật/Tắt hiển thị bên phải nút
    local StatusIndicator = Instance.new("Frame")
    StatusIndicator.Parent = Btn
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    StatusIndicator.Position = UDim2.new(1, -38, 0.5, -10)
    StatusIndicator.Size = UDim2.new(0, 28, 0, 20)
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(1, 0)
    StatusCorner.Parent = StatusIndicator

    local Dot = Instance.new("Frame")
    Dot.Parent = StatusIndicator
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.Position = UDim2.new(0, 2, 0.5, -8)
    Dot.Size = UDim2.new(0, 16, 0, 16)
    
    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = Dot

    local enabled = false
    Btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        local goalIndicatorColor = enabled and Color3.fromRGB(215, 40, 114) or Color3.fromRGB(60, 60, 75)
        local goalDotPos = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)

        TweenService:Create(StatusIndicator, TweenInfo.new(0.25), {BackgroundColor3 = goalIndicatorColor}):Play()
        TweenService:Create(Dot, TweenInfo.new(0.25), {Position = goalDotPos}):Play()
        
        pcall(function()
            callback(enabled)
        end)
    end)
end

-- ==================== TẠO CÁC TAB & TÍNH NĂNG ====================

-- 1. Tab Farm
local FarmPage = createTab("Auto Farm", "⚔️")
createToggle(FarmPage, "Auto Farm Level", "🎯", function(state)
    print("Auto Farm Level:", state)
end)
createToggle(FarmPage, "Auto Nearest Quest", "📜", function(state)
    print("Auto Nearest Quest:", state)
end)
createToggle(FarmPage, "Fast Attack (No Delay)", "⚡", function(state)
    print("Fast Attack:", state)
end)

-- 2. Tab Stats
local StatsPage = createTab("Stats & Player", "📈")
createToggle(StatsPage, "Auto Stat Melee", "🥊", function(state)
    print("Auto Stat Melee:", state)
end)
createToggle(StatsPage, "Auto Stat Defense", "🛡️", function(state)
    print("Auto Stat Defense:", state)
end)
createToggle(StatsPage, "Auto Stat Sword", "🗡️", function(state)
    print("Auto Stat Sword:", state)
end)

-- 3. Tab Sea Events
local SeaPage = createTab("Sea & Boss", "🌊")
createToggle(SeaPage, "Auto Sea Events (Boat)", "⛵", function(state)
    print("Auto Sea Events:", state)
end)
createToggle(SeaPage, "Auto Kill Boss Server", "💀", function(state)
    print("Auto Kill Boss:", state)
end)

-- 4. Tab Misc / Visuals
local MiscPage = createTab("Misc & ESP", "👁️")
createToggle(MiscPage, "ESP Player (Name/Box)", "👤", function(state)
    print("ESP Player:", state)
end)
createToggle(MiscPage, "ESP Fruit (Fruit Name)", "🍎", function(state)
    print("ESP Fruit:", state)
end)
createToggle(MiscPage, "FPS Boost (Anti-Lag)", "🚀", function(state)
    print("FPS Boost:", state)
end)

-- Mặc định mở Tab đầu tiên
for _, v in pairs(TabContainer:GetChildren()) do
    if v:IsA("TextButton") then
        v.BackgroundColor3 = Color3.fromRGB(215, 40, 114)
        break
    end
end
for i, v in pairs(ContentContainer:GetChildren()) do
    if v:IsA("ScrollingFrame") then
        v.Visible = (i == 1)
        break
    end
end

-- Hiệu ứng ẩn/hiện menu chính mượt mà khi bấm nút Toggle
local isOpen = false
ToggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    if isOpen then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 520, 0, 360),
            Position = UDim2.new(0.5, -260, 0.5, -180)
        }):Play()
    else
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        tween:Play()
        tween.Completed:Connect(function()
            if not isOpen then MainFrame.Visible = false end
        end)
    end
end)

print("Zaka Hub No-Key Modern UI Loaded Successfully!")
