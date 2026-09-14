--==============================================================================--
--        ZAKA BLOX // ULTIMATE FARM v3.3 (SILENT HITBOX & AUTO AURA)           --
--==============================================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Chống Idle Disconnect
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

-- Dọn dẹp UI cũ
if PlayerGui:FindFirstChild("ZakaBloxMain") then
    PlayerGui.ZakaBloxMain:Destroy()
end
if PlayerGui:FindFirstChild("ZakaFloatingIcon") then
    PlayerGui.ZakaFloatingIcon:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaBloxMain"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Khung chính kính mờ
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 580, 0, 380)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
MainFrame.BackgroundTransparency = 0.25
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 140, 0)
MainStroke.Transparency = 0.4
MainStroke.Parent = MainFrame

-- Nút icon chữ "ZK" nổi trong suốt khi thu gọn menu
local FloatGui = Instance.new("ScreenGui")
FloatGui.Name = "ZakaFloatingIcon"
FloatGui.ResetOnSpawn = false
FloatGui.Parent = PlayerGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ZkIconButton"
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 20, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
ToggleBtn.BackgroundTransparency = 0.4
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "ZK"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 150, 0)
ToggleBtn.TextSize = 16
ToggleBtn.Visible = false
ToggleBtn.Parent = FloatGui

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 14)
local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 140, 0)
ToggleStroke.Transparency = 0.3
ToggleStroke.Parent = ToggleBtn

-- Topbar kéo thả
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
TopBar.BackgroundTransparency = 0.3
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local FixBar = Instance.new("Frame")
FixBar.Size = UDim2.new(1, 0, 0, 10)
FixBar.Position = UDim2.new(0, 0, 1, -10)
FixBar.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
FixBar.BackgroundTransparency = 0.3
FixBar.BorderSizePixel = 0
FixBar.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 350, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "⚡ ZAKA BLOX // ULTIMATE v3.3"
TitleLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
TitleLabel.TextSize = 12
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Kéo thả menu mượt mà
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
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

-- Nút Thu Gọn Menu
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -36, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
MinimizeBtn.BackgroundTransparency = 0.3
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
MinimizeBtn.TextSize = 14
MinimizeBtn.Parent = TopBar
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

MinimizeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.2)
    MainFrame.Visible = false
    ToggleBtn.Visible = true
    ToggleBtn.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(ToggleBtn, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 50, 0, 50)
    }):Play()
end)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 580, 0, 380),
        BackgroundTransparency = 0.25
    }):Play()
    ToggleBtn.Visible = false
end)

-- Sidebar Tab
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 140, 1, -48)
Sidebar.Position = UDim2.new(0, 0, 0, 44)
Sidebar.BackgroundTransparency = 1
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 2
Sidebar.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.Parent = Sidebar
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 8)
UIPadding.Parent = Sidebar

local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -150, 1, -48)
ContentContainer.Position = UDim2.new(0, 148, 0, 44)
ContentContainer.BackgroundTransparency = 1
ContentContainer.BorderSizePixel = 0
ContentContainer.Parent = MainFrame

local Tabs = {}
local CurrentTabContent = nil

local function CreateTab(name, order)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0, 126, 0, 34)
    TabBtn.BackgroundColor3 = Color3.fromRGB(22, 28, 40)
    TabBtn.BackgroundTransparency = 0.4
    TabBtn.BorderSizePixel = 0
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(160, 170, 190)
    TabBtn.TextSize = 11
    TabBtn.LayoutOrder = order
    TabBtn.Parent = Sidebar
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.Position = UDim2.new(0, 0, 0, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 3
    TabContent.Visible = false
    TabContent.Parent = ContentContainer

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.Parent = TabContent

    local ContentPad = Instance.new("UIPadding")
    ContentPad.PaddingTop = UDim.new(0, 4)
    ContentPad.PaddingLeft = UDim.new(0, 2)
    ContentPad.Parent = TabContent

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Btn.BackgroundColor3 = Color3.fromRGB(22, 28, 40)
            t.Btn.BackgroundTransparency = 0.4
            t.Btn.TextColor3 = Color3.fromRGB(160, 170, 190)
            t.Content.Visible = false
        end
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
        TabBtn.BackgroundTransparency = 0.1
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabContent.Visible = true
        CurrentTabContent = TabContent
    end)

    if not CurrentTabContent then
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
        TabBtn.BackgroundTransparency = 0.1
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabContent.Visible = true
        CurrentTabContent = TabContent
    end

    table.insert(Tabs, {Btn = TabBtn, Content = TabContent})
    return TabContent
end

local function AddToggle(tab, text, callback)
    local ToggleBtnUI = Instance.new("TextButton")
    ToggleBtnUI.Size = UDim2.new(1, -10, 0, 36)
    ToggleBtnUI.BackgroundColor3 = Color3.fromRGB(22, 28, 40)
    ToggleBtnUI.BackgroundTransparency = 0.5
    ToggleBtnUI.BorderSizePixel = 0
    ToggleBtnUI.AutoButtonColor = false
    ToggleBtnUI.Font = Enum.Font.GothamMedium
    ToggleBtnUI.Text = "  " .. text
    ToggleBtnUI.TextColor3 = Color3.fromRGB(220, 230, 245)
    ToggleBtnUI.TextSize = 11
    ToggleBtnUI.TextXAlignment = Enum.TextXAlignment.Left
    ToggleBtnUI.Parent = tab
    Instance.new("UICorner", ToggleBtnUI).CornerRadius = UDim.new(0, 6)

    local StatusIndicator = Instance.new("Frame")
    StatusIndicator.Size = UDim2.new(0, 16, 0, 16)
    StatusIndicator.Position = UDim2.new(1, -26, 0.5, -8)
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(50, 60, 80)
    StatusIndicator.BorderSizePixel = 0
    StatusIndicator.Parent = ToggleBtnUI
    Instance.new("UICorner", StatusIndicator).CornerRadius = UDim.new(0, 4)

    local toggled = false
    ToggleBtnUI.MouseButton1Click:Connect(function()
        toggled = not toggled
        TweenService:Create(StatusIndicator, TweenInfo.new(0.15), {
            BackgroundColor3 = toggled and Color3.fromRGB(0, 230, 110) or Color3.fromRGB(50, 60, 80)
        }):Play()
        callback(toggled)
    end)
end

-- ==================== CHỨC NĂNG THỰC CHIẾN BLOX FRUIT ====================

local TabFarm = CreateTab("Auto Farm", 1)
local TabCombat = CreateTab("Combat", 2)
local TabMisc = CreateTab("Tiện Ích", 3)

local _G_AutoFarm = false
local _G_BringMob = false
local _G_SilentHitbox = false

-- 1. Auto Farm Bay Trên Đầu Quái + Gom Quái (Bring Mob)
AddToggle(TabFarm, "Auto Farm (Bay trên đầu & Gom quái)", function(v)
    _G_AutoFarm = v
    _G_BringMob = v
    task.spawn(function()
        while _G_AutoFarm do
            task.wait(0.2)
            pcall(function()
                local char = LocalPlayer.Character
                local rootPart = char and char:FindFirstChild("HumanoidRootPart")
                if rootPart and Workspace:FindFirstChild("Enemies") then
                    for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                        local eRoot = enemy:FindFirstChild("HumanoidRootPart")
                        local eHuman = enemy:FindFirstChild("Humanoid")
                        if eRoot and eHuman and eHuman.Health > 0 then
                            -- Bay lên đầu quái (cách 5 đơn vị theo chiều dọc)
                            rootPart.CFrame = eRoot.CFrame + Vector3.new(0, 6, 0)
                            if _G_BringMob then
                                eRoot.CFrame = rootPart.CFrame + Vector3.new(0, -5, 0)
                                eRoot.CanCollide = false
                            end
                            break
                        end
                    end
                end
            end)
        end
    end)
end)

-- 2. Silent Hitbox & Auto Aura Attack (Cầm vũ khí tự gây sát thương diện rộng không cần chém)
AddToggle(TabCombat, "Silent Hitbox & Auto Aura Damage", function(v)
    _G_SilentHitbox = v
    task.spawn(function()
        while _G_SilentHitbox do
            task.wait(0.1)
            pcall(function()
                local char = LocalPlayer.Character
                local rootPart = char and char:FindFirstChild("HumanoidRootPart")
                if rootPart and Workspace:FindFirstChild("Enemies") then
                    for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                        local eRoot = enemy:FindFirstChild("HumanoidRootPart")
                        local eHuman = enemy:FindFirstChild("Humanoid")
                        if eRoot and eHuman and eHuman.Health > 0 then
                            if (eRoot.Position - rootPart.Position).Magnitude < 60 then
                                -- Kích hoạt tương tác sát thương ngầm qua CombatFramework chuẩn của game
                                local CombatFramework = require(LocalPlayer.PlayerScripts:WaitForChild("CombatFramework"))
                                local activeController = CombatFramework.activeController
                                if activeController then
                                    activeController.timeToNextAttack = 0
                                    activeController.hitboxMagnitude = 120
                                    activeController:attack()
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

-- 3. Tốc độ chạy & Nhảy cao
AddToggle(TabMisc, "WalkSpeed 100", function(v)
    pcall(function()
        LocalPlayer.Character.Humanoid.WalkSpeed = v and 100 or 16
    end)
end)

AddToggle(TabMisc, "Super Jump", function(v)
    pcall(function()
        LocalPlayer.Character.Humanoid.JumpPower = v and 150 or 50
    end)
end)

print("⚡ Zaka Blox Ultimate v3.3 Loaded with Silent Hitbox!")
