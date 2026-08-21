--[[
    ZAKA V4 PRO ULTIMATE - SAFE FIX FOR DELTA EXECUTOR
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CẤU HÌNH LOGIC
local Config = {
    Faction = "Civilian", -- "Civilian" hoặc "Police"
    Aimbot = false,
    AutoArrest = false,
    AutoTrade = false,
    AutoBank = false
}

-- HÀM DỊCH CHUYỂN AN TOÀN (BYPASS ANTI-CHEAT)
local function SafeMoveTo(targetCFrame)
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
            local tween = TweenService:Create(char.HumanoidRootPart, TweenInfo.new(0.8, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
            tween:Play()
            tween.Completed:Wait()
        end
    end)
end

-- COMBAT LOCK TÂM
RunService.RenderStepped:Connect(function()
    if Config.Aimbot then
        pcall(function()
            local closestTarget = nil
            local shortestDist = 250
            local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character.Humanoid.Health > 0 then
                    local isEnemy = true
                    if Config.Faction == "Police" and plr.Team == LocalPlayer.Team then isEnemy = false end
                    
                    if isEnemy then
                        local head = plr.Character.Head
                        local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                        if onScreen then
                            local dist = (Vector2.new(pos.X, pos.Y) - centerScreen).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                closestTarget = head
                            end
                        end
                    end
                end
            end

            if closestTarget then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
            end
        end)
    end
end)

-- LOGIC CẢNH SÁT (AUTO ARREST)
task.spawn(function()
    while task.wait(0.5) do
        if Config.Faction == "Police" and Config.AutoArrest then
            pcall(function()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local stats = plr:FindFirstChild("leaderstats")
                        local wanted = stats and (stats:FindFirstChild("Wanted") or stats:FindFirstChild("Bounty"))
                        if wanted and wanted.Value > 0 and plr.Character.Humanoid.Health > 0 then
                            SafeMoveTo(plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2))
                            task.wait(0.2)
                            fireproximityprompt or VirtualUser:ClickButton1(Vector2.new())
                        end
                    end
                end
            end)
        end
    end
end)

-- LOGIC DÂN THƯỜNG (AUTO TRADE)
task.spawn(function()
    while task.wait(1) do
        if Config.Faction == "Civilian" and Config.AutoTrade then
            pcall(function()
                SafeMoveTo(CFrame.new(-210, 10, -150))
                task.wait(0.5)
                for i = 1, 5 do
                    fireproximityprompt or VirtualUser:ClickButton1(Vector2.new())
                    task.wait(0.2)
                end
                SafeMoveTo(CFrame.new(320, 12, -800))
                task.wait(1)
                fireproximityprompt or VirtualUser:ClickButton1(Vector2.new())
            end)
        end
    end
end)

-- GIAO DIỆN MENU (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaV4ProUI"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.3, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
ToggleBtn.Text = "ZAKA V4"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 11
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 360)
Main.Position = UDim2.new(0.5, -160, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Title.Text = "  Zaka V4 Pro - San Diego Edition"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

local FactionFrame = Instance.new("Frame", Main)
FactionFrame.Size = UDim2.new(1, -20, 0, 35)
FactionFrame.Position = UDim2.new(0, 10, 0, 48)
FactionFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Instance.new("UICorner", FactionFrame).CornerRadius = UDim.new(0, 6)

local CivBtn = Instance.new("TextButton", FactionFrame)
CivBtn.Size = UDim2.new(0.5, -2, 1, 0)
CivBtn.Position = UDim2.new(0, 0, 0, 0)
CivBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
CivBtn.Text = "DÂN THƯỜNG"
CivBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CivBtn.Font = Enum.Font.GothamBold
CivBtn.TextSize = 11
Instance.new("UICorner", CivBtn).CornerRadius = UDim.new(0, 6)

local CopBtn = Instance.new("TextButton", FactionFrame)
CopBtn.Size = UDim2.new(0.5, -2, 1, 0)
CopBtn.Position = UDim2.new(0.5, 2, 0, 0)
CopBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CopBtn.Text = "CẢNH SÁT"
CopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopBtn.Font = Enum.Font.GothamBold
CopBtn.TextSize = 11
Instance.new("UICorner", CopBtn).CornerRadius = UDim.new(0, 6)

CivBtn.MouseButton1Click:Connect(function()
    Config.Faction = "Civilian"
    CivBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    CopBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
end)

CopBtn.MouseButton1Click:Connect(function()
    Config.Faction = "Police"
    CopBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    CivBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
end)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -95)
Scroll.Position = UDim2.new(0, 10, 0, 90)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 300)

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 6)

local function AddOption(txt, callback)
    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(1, 0, 0, 36)
    f.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -50, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.Font = Enum.Font.Gotham
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left

    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0, 36, 0, 18)
    b.Position = UDim2.new(1, -42, 0.5, -9)
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    b.Text = ""
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)

    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(60, 60, 70)
        callback(state)
    end)
end

AddOption("Aimbot Lock Tâm", function(v) Config.Aimbot = v end)
AddOption("[Police] Auto Bắt Tội Phạm", function(v) Config.AutoArrest = v end)
AddOption("[Civilian] Auto Buôn Bán Lậu", function(v) Config.AutoTrade = v end)

print("Zaka V4 Pro Ready!")
