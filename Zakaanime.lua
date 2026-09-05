--[[
    ╔════════════════════════════════════════════════════════════════════════════════╗
    ║                        ZENITSU MENU - VERSION 1.0                              ║
    ║                    Hơi Thở Sấm Sét | Menu riêng                                ║
    ╚════════════════════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

--==============================================================================--
--                              MENU ZENITSU                                     --
--==============================================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZenitsuMenu"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Nút Z
local ToggleIcon = Instance.new("TextButton")
ToggleIcon.Name = "ZenitsuToggle"
ToggleIcon.Size = UDim2.new(0, 46, 0, 46)
ToggleIcon.Position = UDim2.new(0, 15, 0.4, 0)
ToggleIcon.BackgroundColor3 = Color3.fromRGB(255, 200, 40)
ToggleIcon.Text = "Z"
ToggleIcon.TextColor3 = Color3.fromRGB(30, 20, 0)
ToggleIcon.Font = Enum.Font.GothamBold
ToggleIcon.TextSize = 22
ToggleIcon.Parent = ScreenGui
Instance.new("UICorner", ToggleIcon).CornerRadius = UDim.new(1, 0)

-- Khung menu
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 300, 0, 280)
Main.Position = UDim2.new(0.5, -150, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(18, 14, 10)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(40, 30, 10)
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -15, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZENITSU | Hơi Thở Sấm Sét"
Title.TextColor3 = Color3.fromRGB(255, 220, 60)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -20, 0, 80)
Info.Position = UDim2.new(0, 10, 0, 55)
Info.BackgroundTransparency = 1
Info.Text = "Menu đã hiện thành công.\nBáo mình để thêm kỹ năng Zenitsu."
Info.TextColor3 = Color3.fromRGB(230, 220, 180)
Info.TextSize = 13
Info.Font = Enum.Font.Gotham
Info.TextWrapped = true
Info.Parent = Main

ToggleIcon.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

print("Zenitsu Menu Loaded Successfully!")
