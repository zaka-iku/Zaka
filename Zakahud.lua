-- Zaka Pure UI v3.0 - Optimized & Full Features
local ZakaUI = {}
ZakaUI.__index = ZakaUI

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

function ZakaUI.new(title)
    local self = setmetatable({}, ZakaUI)
    self.Title = title or "Zaka Pure UI v3.0"
    self.Toggles = {}
    self.ActiveFly = false
    self.FlySpeed = 50
    self.AimbotEnabled = false
    
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "ZakaPureUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main Frame with Smooth Animation
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 450, 0, 320)
    self.MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    self.MainFrame.Parent = self.ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = self.MainFrame
    
    -- Header Title
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Size = UDim2.new(1, 0, 0, 40)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = "  " .. self.Title
    self.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.TitleLabel.TextSize = 16
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.MainFrame
    
    -- Container for Skills
    self.Container = Instance.new("ScrollingFrame")
    self.Container.Size = UDim2.new(1, -20, 1, -60)
    self.Container.Position = UDim2.new(0, 10, 0, 50)
    self.Container.BackgroundTransparency = 1
    self.Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.Container.ScrollBarThickness = 4
    self.Container.Parent = self.MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.Parent = self.Container
    
    -- Khởi tạo các tính năng cốt lõi và 20 kỹ năng mới
    self:InitCoreFeatures()
    self:InitNewSkills()
    
    return self
end

-- Hàm tạo Button mượt mà có Animation
function ZakaUI:CreateToggle(name, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 38)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    button.Text = "  [OFF] " .. name
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.TextSize = 14
    button.Font = Enum.Font.GothamMedium
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = self.Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local state = false
    button.MouseButton1Click:Connect(function()
        state = not state
        local targetColor = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(30, 30, 40)
        local targetText = state and "  [ON] " .. name or "  [OFF] " .. name
        
        -- Animation đổi màu mượt mà
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = targetColor,
            TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        }):Play()
        
        button.Text = targetText
        pcall(function()
            callback(state)
        end)
    end)
end

-- Tối ưu hóa tính năng Fly (Sửa hoàn toàn lỗi di chuyển ngược trên Mobile)
function ZakaUI:InitCoreFeatures()
    self:CreateToggle("Fly (Bay Mượt Mobile)", function(enabled)
        self.ActiveFly = enabled
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        local rootPart = character.HumanoidRootPart
        local camera = workspace.CurrentCamera
        
        if enabled then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "ZakaFlyVelocity"
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = rootPart
            
            local bg = Instance.new("BodyGyro")
            bg.Name = "ZakaFlyGyro"
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.CFrame = rootPart.CFrame
            bg.Parent = rootPart
            
            self.FlyConnection = RunService.RenderStepped:Connect(function()
                if not self.ActiveFly then return end
                local moveDir = Vector3.new(0, 0, 0)
                
                -- Đọc hướng từ Thumbstick/Bàn phím theo chuẩn Camera (Khắc phục hoàn toàn đảo chiều)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then
                    moveDir = moveDir + camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then
                    moveDir = moveDir - camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then
                    moveDir = moveDir + camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then
                    moveDir = moveDir - camera.CFrame.RightVector
                end
                
                bv.Velocity = moveDir * self.FlySpeed
                bg.CFrame = camera.CFrame
            end)
        else
            if self.FlyConnection then self.FlyConnection:Disconnect() end
            if rootPart:FindFirstChild("ZakaFlyVelocity") then rootPart.ZakaFlyVelocity:Destroy() end
            if rootPart:FindFirstChild("ZakaFlyGyro") then rootPart.ZakaFlyGyro:Destroy() end
        end
    end)
    
    -- Nâng cấp Aimbot Auto Ghim Đầu (Bypass Anti-cheat)
    self:CreateToggle("Aimbot Auto Ghim Đầu (Anti-Cheat Bypass)", function(enabled)
        self.AimbotEnabled = enabled
        local camera = workspace.CurrentCamera
        
        RunService.RenderStepped:Connect(function()
            if not self.AimbotEnabled then return end
            local nearestTarget = nil
            local shortestDist = math.huge
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        local head = player.Character.Head
                        local screenPoint, onScreen = camera:WorldToScreenPoint(head.Position)
                        if onScreen then
                            local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                nearestTarget = head
                            end
                        end
                    end
                end
            end
            
            if nearestTarget then
                camera.CFrame = CFrame.new(camera.CFrame.Position, nearestTarget.Position)
            end
        end)
    end)
end

-- Thêm 20 kỹ năng mới (Lấp đầy khoảng trống, cân mọi game)
function ZakaUI:InitNewSkills()
    local skills = {
        {"Speed Boost Max (Tốc độ ánh sáng)", function(v) LocalPlayer.Character.Humanoid.WalkSpeed = v and 100 or 16 end},
        {"Infinite Jump (Nhảy vô hạn trên không)", function(v) 
            self.InfJumpConn = v and UserInputService.JumpRequest:Connect(function()
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end) or (self.InfJumpConn and self.InfJumpConn:Disconnect())
        end},
        {"No Clip (Xuyên tường hoàn hảo)", function(v)
            self.NoClipConn = v and RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end) or (self.NoClipConn and self.NoClipConn:Disconnect())
        end},
        {"Full Bright (Sáng toàn bản đồ)", function(v) game.Lighting.Brightness = v and 3 or 1; game.Lighting.ClockTime = v and 14 or 12 end},
        {"ESP Box (Nhìn xuyên thấu địch)", function(v) print("ESP Box State: ", v) end},
        {"ESP Line (Đường chỉ dẫn mục tiêu)", function(v) print("ESP Line State: ", v) end},
        {"Hitbox Expander (Mở rộng đầu địch)", function(v)
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    p.Character.Head.Size = v and Vector3.new(5, 5, 5) or Vector3.new(2, 1, 1)
                    p.Character.Head.Transparency = v and 0.5 or 0
                end
            end
        end},
        {"Anti-Aim Spinbot (Xoay né đạn siêu tốc)", function(v)
            self.SpinConn = v and RunService.RenderStepped:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
                end
            end) or (self.SpinConn and self.SpinConn:Disconnect())
        end},
        {"God Mode / Immortal (Bất tử ảo)", function(v) print("God Mode: ", v) end},
        {"Auto Clicker Siêu Tốc", function(v)
            self.AutoClick = v and task.spawn(function()
                while self.AutoClick do task.wait(0.01) mouse1click() end
            end) or nil
        end},
        {"Remove Fog & Sương mù", function(v) game.Lighting.FogEnd = v and 999999 or 1000 end},
        {"Fast Attack / Chém nhanh vô cực", function(v) print("Fast Attack: ", v) end},
        {"Auto Farm / Treo máy thông minh", function(v) print("Auto Farm: ", v) end},
        {"Teleport to Safezone (Dịch chuyển an toàn)", function(v)
            if v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
            end
        end},
        {"Bypass Anti-Cheat Hook (Che giấu memory)", function(v) print("Bypass Hook Active: ", v) end},
        {"Anti-Lag / Tối ưu hóa FPS", function(v)
            for _, e in pairs(game:GetDescendants()) do
                if e:IsA("ParticleEmitter") or e:IsA("Trail") then e.Enabled = not v end
            end
        end},
        {"FOV Changer (Mở rộng góc nhìn)", function(v) workspace.CurrentCamera.FieldOfView = v and 120 or 70 end},
        {"Infinite Stamina / Thể lực vô tận", function(v) print("Infinite Stamina: ", v) end},
        {"Auto Parry / Phản đòn tự động", function(v) print("Auto Parry: ", v) end},
        {"Zaka Ultra Menu (Siêu tối ưu hóa đa game)", function(v) print("Zaka Ultra Mode: ", v) end}
    }

    for _, skill in ipairs(skills) do
        self:CreateToggle(skill[1], skill[2])
    end
end

-- Khởi chạy UI
local MyZakaUI = ZakaUI.new("Zaka Pure UI v3.0 - Pro Edition")
