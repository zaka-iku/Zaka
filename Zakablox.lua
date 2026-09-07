--[[
    ZAKA LOADER (No Key)
    Menu to + nút to + icon rồng
]]

local Directory = "https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/Games"
local Scripts = {
    Free = {
        [994732206] = Directory .. "/BloxFruits.lua",
        [9186719164] = Directory .. "/SailorPiece.lua",
        [8191429227] = Directory .. "/CutTrees.lua",
    },
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local GameId = game.GameId

local function Protect(gui)
    if gethui then
        gui.Parent = gethui()
    else
        pcall(function() gui.Parent = game:GetService("CoreGui") end)
        if not gui.Parent then
            gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end
    end
end

local function Notify(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title or "Zaka",
            Text = text or "",
            Duration = 5,
        })
    end)
end

local function LoadFreeScript()
    local url = Scripts.Free[GameId]
    if url then
        Notify("Zaka", "Đang load script...")
        local ok, err = pcall(function()
            loadstring(game:HttpGet(url))()
        end)
        if not ok then
            Notify("Zaka Error", tostring(err):sub(1, 80))
        end
    else
        Notify("Zaka", "Game này chưa có script Free.\nGameId: " .. tostring(GameId))
    end
end

--==================== MENU ZAKA ====================--
local SG = Instance.new("ScreenGui")
SG.Name = "ZakaLoader"
SG.ResetOnSpawn = false
Protect(SG)

-- Khung menu to hơn
local Card = Instance.new("Frame")
Card.Size = UDim2.new(0, 380, 0, 280)
Card.Position = UDim2.new(0.5, -190, 0.5, -140)
Card.BackgroundColor3 = Color3.fromRGB(14, 12, 20)
Card.BorderSizePixel = 0
Card.Active = true
Card.Draggable = true
Card.Parent = SG
Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 16)

local stroke = Instance.new("UIStroke", Card)
stroke.Color = Color3.fromRGB(0, 180, 255)
stroke.Thickness = 2

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 70)
Header.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
Header.BorderSizePixel = 0
Header.Parent = Card
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 16)

-- Icon rồng (dùng asset rồng phổ biến)
local DragonIcon = Instance.new("ImageLabel")
DragonIcon.Size = UDim2.new(0, 48, 0, 48)
DragonIcon.Position = UDim2.new(0, 14, 0.5, -24)
DragonIcon.BackgroundTransparency = 1
DragonIcon.Image = "rbxassetid://6034287594" -- icon rồng
DragonIcon.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 70, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA LOADER"
Title.TextColor3 = Color3.fromRGB(0, 210, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -80, 0, 18)
SubTitle.Position = UDim2.new(0, 70, 0, 42)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "No Key System • Free Scripts"
SubTitle.TextColor3 = Color3.fromRGB(140, 160, 180)
SubTitle.TextSize = 12
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

-- Info
local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -30, 0, 45)
Info.Position = UDim2.new(0, 15, 0, 85)
Info.BackgroundTransparency = 1
Info.Text = "Chỉ hỗ trợ script Free theo GameId.\nBấm nút bên dưới để load."
Info.TextColor3 = Color3.fromRGB(200, 205, 220)
Info.TextSize = 14
Info.Font = Enum.Font.Gotham
Info.TextWrapped = true
Info.Parent = Card

-- Nút Load (to hơn)
local LoadBtn = Instance.new("TextButton")
LoadBtn.Size = UDim2.new(1, -40, 0, 50)
LoadBtn.Position = UDim2.new(0, 20, 0, 145)
LoadBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 230)
LoadBtn.Text = "LOAD SCRIPT"
LoadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadBtn.TextSize = 18
LoadBtn.Font = Enum.Font.GothamBold
LoadBtn.Parent = Card
Instance.new("UICorner", LoadBtn).CornerRadius = UDim.new(0, 10)

LoadBtn.MouseButton1Click:Connect(function()
    LoadFreeScript()
end)

-- Nút Đóng (to hơn)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(1, -40, 0, 42)
CloseBtn.Position = UDim2.new(0, 20, 0, 210)
CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
CloseBtn.Text = "ĐÓNG MENU"
CloseBtn.TextColor3 = Color3.fromRGB(210, 210, 220)
CloseBtn.TextSize = 15
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Card
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 10)

CloseBtn.MouseButton1Click:Connect(function()
    SG:Destroy()
end)

print("Zaka Loader Loaded")
