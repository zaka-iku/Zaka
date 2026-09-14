--[[
    ZAKA PURE UI - Bản siêu ổn định cho Delta
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Xóa bản cũ
pcall(function()
    if PlayerGui:FindFirstChild("ZakaPureUI") then
        PlayerGui.ZakaPureUI:Destroy()
    end
    if game:GetService("CoreGui"):FindFirstChild("ZakaPureUI") then
        game:GetService("CoreGui").ZakaPureUI:Destroy()
    end
end)

-- ======================== PARENT ƯU TIÊN PLAYERGUI (ổn định nhất trên Delta) ========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaPureUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui   -- Dùng PlayerGui cho chắc

-- ========== NÚT TOGGLE (TO + DỄ NHÌN) ==========
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "Toggle"
ToggleBtn.Size = UDim2.new(0, 70, 0, 70)
ToggleBtn.Position = UDim2.new(0, 20, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.Text = "Z"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 32
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = ScreenGui

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 3
ToggleStroke.Parent = ToggleBtn

-- ========== MAIN FRAME ==========
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 400, 0, 460)
Main.Position = UDim2.new(0.5, -200, 0.5, -230)
Main.BackgroundColor3 = Color3.fromRGB(15, 17, 25)
Main.BackgroundTransparency = 0.1
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 180, 255)
MainStroke.Thickness = 2
MainStroke.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
Header.BackgroundTransparency = 0.2
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA UI"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Position = UDim2.new(1, -45, 0.5, -18)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

-- Tab đơn giản
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 36)
TabBar.Position = UDim2.new(0, 10, 0, 58)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Main

local tabs = {"Home", "Visual", "Player", "Config"}
local currentPage = nil

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.23, 0, 1, 0)
    btn.Position = UDim2.new((i-1)*0.25, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    btn.Text = name
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = TabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -110)
    page.Position = UDim2.new(0, 10, 0, 100)
    page.BackgroundTransparency = 1
    page.Visible = (i == 1)
    page.ScrollBarThickness = 4
    page.Parent = Main

    for j = 1, 5 do
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 48)
        card.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
        card.Parent = page
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -15, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name .. " Item " .. j
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = card
    end

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.Parent = page

    btn.MouseButton1Click:Connect(function()
        if currentPage then currentPage.Visible = false end
        page.Visible = true
        currentPage = page
    end)

    if i == 1 then currentPage = page end
end

-- Mở / Đóng
local isOpen = false

local function OpenMenu()
    if isOpen then return end
    isOpen = true
    Main.Visible = true
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)

    TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 400, 0, 460),
        Position = UDim2.new(0.5, -200, 0.5, -230)
    }):Play()
end

local function CloseMenu()
    if not isOpen then return end
    isOpen = false
    TweenService:Create(Main, TweenInfo.new(0.25), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.25)
    Main.Visible = false
end

ToggleBtn.MouseButton1Click:Connect(function()
    if isOpen then CloseMenu() else OpenMenu() end
end)

CloseBtn.MouseButton1Click:Connect(CloseMenu)

-- Tự mở 1 lần để bạn thấy ngay
task.delay(0.8, function()
    OpenMenu()
end)

print("ZAKA UI đã load! Nút xanh chữ Z ở góc trái.")
