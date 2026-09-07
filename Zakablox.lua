--[[
    ZAKA LOADER (No Key)
    Dựa trên Quantum Onyx - đã bỏ key system, đổi tên Zaka
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
local TweenService = game:GetService("TweenService")
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
        Notify("Zaka", "Game này chưa có script Free. GameId: " .. tostring(GameId))
    end
end

--==================== MENU ZAKA (không key) ====================--
local SG = Instance.new("ScreenGui")
SG.Name = "ZakaLoader"
SG.ResetOnSpawn = false
Protect(SG)

local Card = Instance.new("Frame")
Card.Size = UDim2.new(0, 320, 0, 180)
Card.Position = UDim2.new(0.5, -160, 0.5, -90)
Card.BackgroundColor3 = Color3.fromRGB(16, 14, 22)
Card.BorderSizePixel = 0
Card.Active = true
Card.Draggable = true
Card.Parent = SG
Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", Card)
stroke.Color = Color3.fromRGB(0, 162, 255)
stroke.Thickness = 1.5

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Title.Text = "ZAKA LOADER"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = Card
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -20, 0, 40)
Info.Position = UDim2.new(0, 10, 0, 50)
Info.BackgroundTransparency = 1
Info.Text = "Đã bỏ Key System.\nChỉ hỗ trợ script Free theo GameId."
Info.TextColor3 = Color3.fromRGB(200, 200, 210)
Info.TextSize = 12
Info.Font = Enum.Font.Gotham
Info.TextWrapped = true
Info.Parent = Card

local LoadBtn = Instance.new("TextButton")
LoadBtn.Size = UDim2.new(1, -40, 0, 36)
LoadBtn.Position = UDim2.new(0, 20, 0, 105)
LoadBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 220)
LoadBtn.Text = "Load Script"
LoadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadBtn.TextSize = 14
LoadBtn.Font = Enum.Font.GothamBold
LoadBtn.Parent = Card
Instance.new("UICorner", LoadBtn).CornerRadius = UDim.new(0, 8)

LoadBtn.MouseButton1Click:Connect(function()
    LoadFreeScript()
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(1, -40, 0, 28)
CloseBtn.Position = UDim2.new(0, 20, 0, 148)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CloseBtn.Text = "Đóng"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.Parent = Card
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    SG:Destroy()
end)

print("Zaka Loader (No Key) Loaded")
