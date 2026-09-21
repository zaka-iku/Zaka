local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Tạo giao diện chính cho Mobile
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Khung Menu
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 140, 0, 75)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

-- Nút di chuyển menu (Hỗ trợ cảm ứng vuốt trên điện thoại)
local MoveBtn = Instance.new("TextButton", MainFrame)
MoveBtn.Size = UDim2.new(1, 0, 0, 22)
MoveBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
MoveBtn.Text = "MOVE MENU"
MoveBtn.TextColor3 = Color3.new(1, 1, 1)
MoveBtn.Font = Enum.Font.SourceSansBold
MoveBtn.TextSize = 10
Instance.new("UICorner", MoveBtn).CornerRadius = UDim.new(0, 4)

-- Nút Bật/Tắt ESP
local EspBtn = Instance.new("TextButton", MainFrame)
EspBtn.Size = UDim2.new(1, 0, 0, 45)
EspBtn.Position = UDim2.new(0, 0, 0, 25)
EspBtn.BackgroundTransparency = 1
EspBtn.Text = "ESP: OFF"
EspBtn.TextColor3 = Color3.new(1, 0, 0)
EspBtn.Font = Enum.Font.SourceSansBold
EspBtn.TextSize = 16

-- Nút thu gọn/mở rộng menu nhỏ gọn góc trên
local ToggleMenuBtn = Instance.new("TextButton", ScreenGui)
ToggleMenuBtn.Size = UDim2.new(0, 30, 0, 30)
ToggleMenuBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleMenuBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleMenuBtn.Text = "-"
ToggleMenuBtn.Font = Enum.Font.SourceSansBold
ToggleMenuBtn.TextSize = 16
Instance.new("UICorner", ToggleMenuBtn).CornerRadius = UDim.new(0, 6)

-- Logic kéo thả menu trên màn hình cảm ứng điện thoại
local drag, start, startPos
MoveBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true
        start = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if drag and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - start
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = false
    end
end)

-- Logic Thu gọn Menu
local menuOpen = true
ToggleMenuBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    MoveBtn.Visible = menuOpen
    EspBtn.Visible = menuOpen
    ToggleMenuBtn.Text = menuOpen and "-" or "+"
    MainFrame.Size = menuOpen and UDim2.new(0, 140, 0, 75) or UDim2.new(0, 140, 0, 22)
end)

-- Logic ESP (Tô màu nhân vật, nhìn rõ kẻ địch trên mobile)
local ESPEnabled = false

local function ApplyESPToCharacter(character)
    if not character:FindFirstChild("ESPHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(255, 50, 50) -- Màu đỏ nổi bật cho địch
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.4
        highlight.OutlineTransparency = 0
        highlight.Parent = character
    end
end

local function ToggleESP(state)
    ESPEnabled = state
    EspBtn.Text = ESPEnabled and "ESP: ON" or "ESP: OFF"
    EspBtn.TextColor3 = ESPEnabled and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    
    if ESPEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if player.Character then
                    ApplyESPToCharacter(player.Character)
                end
                player.CharacterAdded:Connect(function(char)
                    if ESPEnabled then
                        ApplyESPToCharacter(char)
                    end
                end)
            end
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("ESPHighlight") then
                player.Character.ESPHighlight:Destroy()
            end
        end
    end
end

EspBtn.MouseButton1Click:Connect(function()
    if not drag then
        ToggleESP(not ESPEnabled)
    end
end)
