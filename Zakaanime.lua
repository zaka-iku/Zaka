local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "TestMenu"
gui.ResetOnSpawn = false

local success = pcall(function()
    gui.Parent = game:GetService("CoreGui")
end)

if not success or not gui.Parent then
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 120, 0, 40)
btn.Position = UDim2.new(0, 20, 0.4, 0)
btn.BackgroundColor3 = Color3.fromRGB(255, 200, 40)
btn.Text = "TEST MENU"
btn.TextColor3 = Color3.fromRGB(0, 0, 0)
btn.TextSize = 14
btn.Font = Enum.Font.GothamBold
btn.Parent = gui

print("TEST MENU LOADED")
