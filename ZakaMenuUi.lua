local R, S, P, C, G = 130, 0.15, game.Players, workspace.CurrentCamera, Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui) 
G.ResetOnSpawn, G.IgnoreGuiInset = false, true; 
local F, M = Instance.new("Frame", G), Instance.new("Frame", G) 
local Active = true 
F.AnchorPoint, F.Size, F.BackgroundTransparency, Instance.new("UIStroke", F).Color, Instance.new("UICorner", F).CornerRadius = Vector2.new(0.5,0.5), UDim2.new(0, R*2, 0, R*2), 1, Color3.new(0,1,0), UDim.new(1,0) 
M.Size, M.Position, M.BackgroundColor3, Instance.new("UICorner", M).CornerRadius = UDim2.new(0, 110, 0, 45), UDim2.new(0.05, 0, 0.4, 0), Color3.fromRGB(30,30,30), UDim.new(0,6) 
local D = Instance.new("TextButton", M) 
D.Size, D.BackgroundColor3, D.BackgroundTransparency, D.Text, D.TextColor3, D.Font, D.TextSize = UDim2.new(1, 0, 0, 15), Color3.fromRGB(80,80,80), 0, "MOVE", Color3.new(1,1,1), Enum.Font.SourceSansBold, 10; 
Instance.new("UICorner", D).CornerRadius = UDim.new(0,4) 
local B = Instance.new("TextButton", M) 
B.Size, B.Position, B.BackgroundTransparency, B.Text, B.TextColor3, B.Font, B.TextSize = UDim2.new(1,0,0,30), UDim2.new(0,0,0,15), 1, "AIM: ON", Color3.new(0,1,0), Enum.Font.SourceSansBold, 15 

local drag, start, startPos 
D.MouseButton1Down:Connect(function() 
    drag, start, startPos = true, game:GetService("UserInputService"):GetMouseLocation(), M.Position 
end) 

game:GetService("UserInputService").InputChanged:Connect(function(input) 
    if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then 
        local delta = game:GetService("UserInputService"):GetMouseLocation() - start 
        M.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) 
    end 
end) 

game:GetService("UserInputService").InputEnded:Connect(function(input) 
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        drag = false 
    end 
end) 

B.MouseButton1Click:Connect(function() 
    if not drag then 
        Active = not Active 
        B.Text, B.TextColor3 = Active and "AIM: ON" or "AIM: OFF", Active and Color3.new(0,1,0) or Color3.new(1,0,0) 
    end 
end)

-- Nút menu đóng/mở gọn gàng như bạn yêu cầu ở trước
local ToggleBtn = Instance.new("TextButton", G)
ToggleBtn.Size = UDim2.new(0, 30, 0, 30)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Text = "-"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 16
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

local MenuOpen = true
ToggleBtn.MouseButton1Click:Connect(function()
    MenuOpen = not MenuOpen
    B.Visible = MenuOpen
    D.Visible = MenuOpen
    ToggleBtn.Text = MenuOpen and "-" or "+"
    M.Size = MenuOpen and UDim2.new(0, 110, 0, 45) or UDim2.new(0, 110, 0, 15)
end)

-- ==================== LOGIC AIMBOT GẮN CHẶT VÀO ĐẦU ====================
local LocalPlayer = P.LocalPlayer

local function GetClosestTargetHead()
    local target = nil
    local shortestDist = R 
    local mousePos = game:GetService("UserInputService"):GetMouseLocation()

    for _, player in ipairs(P:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Ép đổi sang tìm bộ phận "Head" (Đầu) thay vì RootPart để ghim chuẩn xác
            local head = player.Character:FindFirstChild("Head")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            if head and humanoid and humanoid.Health > 0 then
                if player.Team ~= LocalPlayer.Team or not LocalPlayer.Team then
                    local screenPoint, onScreen = C:WorldToViewportPoint(head.Position)
                    
                    if onScreen then
                        local screenDist = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                        if screenDist < shortestDist then
                            shortestDist = screenDist
                            target = head
                        end
                    end
                end
            end
        end
    end
    return target
end

game:GetService("RunService").RenderStepped:Connect(function()
    local mouseLoc = game:GetService("UserInputService"):GetMouseLocation()
    F.Position = UDim2.new(0, mouseLoc.X, 0, mouseLoc.Y)
    
    if Active then
        local targetHead = GetClosestTargetHead()
        if targetHead then
            -- Ghi đè trực tiếp góc nhìn camera hướng thẳng vào Head của địch, bỏ qua Lerp để tránh bị anti-cheat/lag làm lệch tâm
            C.CFrame = CFrame.new(C.CFrame.Position, targetHead.Position)
        end
    end
end)
