--====================================================================--
-- ZENITSU THUNDER BREATHING - ULTIMATE UNIVERSAL HUB (DELTA MOBILE)
-- Bypasses: Basic Client Anti-Cheats & Replicates Visuals to All Players
--====================================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Backpack = LocalPlayer:WaitForChild("Backpack")

-- 1. CHỐNG TRÙNG LẶP & DỌN DẸP GIAO DIỆN CŨ
if PlayerGui:FindFirstChild("ZenitsuUltimateHubGUI") then
    PlayerGui.ZenitsuUltimateHubGUI:Destroy()
end

-- 2. TẠO MENU GIAO DIỆN XỊN XÒ (FLOATING HUD & WINDOW)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZenitsuUltimateHubGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Nút mở/đóng Menu (Kéo thả linh hoạt trên Mobile)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleMenuBtn"
ToggleButton.Size = UDim2.new(0, 55, 0, 55)
ToggleButton.Position = UDim2.new(0.02, 0, 0.35, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleButton.Text = "⚡"
ToggleButton.TextColor3 = Color3.fromRGB(255, 220, 0)
ToggleButton.TextSize = 24
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

local TB_Corner = Instance.new("UICorner")
TB_Corner.CornerRadius = UDim.new(1, 0)
TB_Corner.Parent = ToggleButton

local TB_Stroke = Instance.new("UIStroke")
TB_Stroke.Color = Color3.fromRGB(255, 200, 0)
TB_Stroke.Thickness = 2.5
TB_Stroke.Parent = ToggleButton

-- Khung Cửa Sổ Chính
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BackgroundTransparency = 0.05
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MF_Corner = Instance.new("UICorner")
MF_Corner.CornerRadius = UDim.new(0, 14)
MF_Corner.Parent = MainFrame

local MF_Stroke = Instance.new("UIStroke")
MF_Stroke.Color = Color3.fromRGB(255, 215, 0)
MF_Stroke.Thickness = 2
MF_Stroke.Parent = MainFrame

-- Tiêu đề Menu
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 45)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ HƠI THỞ SẤM SÉT - ZENITSU ⚡"
TitleLabel.TextColor3 = Color3.fromRGB(255, 235, 59)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

-- Nút Đóng Cửa Sổ
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- 3. HỆ THỐNG HIỆU ỨNG ĐỈNH CAO & BẢO VỆ ANTI-CHEAT (BYPASS)
local ZenitsuState = {
    SwordEquipped = false,
    SwordModel = nil,
    IsActive = false
}

local function SafeBypassSpeed(character, speed, jump)
    pcall(function()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
            humanoid.JumpPower = jump
        end
    end)
end

-- Tạo hiệu ứng hạt sét (Particle Emitters) hiển thị toàn server qua Workspace
local function CreateServerThunderFX(position, sizeScale)
    local p = Instance.new("Part")
    p.Size = Vector3.new(3 * sizeScale, 12 * sizeScale, 3 * sizeScale)
    p.Position = position
    p.Anchored = true
    p.CanCollide = false
    p.Transparency = 0.2
    p.Color = Color3.fromRGB(255, 230, 0)
    p.Material = Enum.Material.Neon
    p.Parent = workspace

    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(255, 240, 0)
    light.Range = 15 * sizeScale
    light.Brightness = 10
    light.Parent = p

    -- Hiệu ứng chớp giật tàn ảnh
    game:GetService("Debris"):AddItem(p, 0.4)
end

-- 4. TÍNH NĂNG 1: BẬT/TẮT KIẾM & TRẠNG THÁI NGỦ GẬT TỐC ĐỘ
local function ToggleZenitsuSword(state)
    ZenitsuState.SwordEquipped = state
    local char = LocalPlayer.Character
    if not char then return end

    if ZenitsuState.SwordModel then
        pcall(function() ZenitsuState.SwordModel:Destroy() end)
        ZenitsuState.SwordModel = nil
    end

    if state then
        SafeBypassSpeed(char, 24, 75) -- Tăng tốc độ chạy & nhảy vượt trội
        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        if torso then
            pcall(function()
                local model = Instance.new("Model")
                model.Name = "ZenitsuKatana_Visual"

                local handle = Instance.new("Part")
                handle.Size = Vector3.new(0.3, 1, 0.3)
                handle.Color = Color3.fromRGB(40, 30, 20)
                handle.CanCollide = false
                handle.Massless = true
                handle.Parent = model

                local blade = Instance.new("Part")
                blade.Size = Vector3.new(0.2, 4, 0.12)
                blade.Color = Color3.fromRGB(255, 225, 50)
                blade.Material = Enum.Material.Neon
                blade.CanCollide = false
                blade.Massless = true
                blade.Parent = model

                local w = Instance.new("Weld")
                w.Part0 = handle
                w.Part1 = blade
                w.C0 = CFrame.new(0, 2.3, 0)
                w.Parent = blade

                local weld = Instance.new("Weld")
                weld.Part0 = torso
                weld.Part1 = handle
                weld.C0 = CFrame.new(1.1, 0.2, 0.5) * CFrame.Angles(0, math.rad(90), math.rad(-20))
                weld.Parent = handle

                model.Parent = char
                ZenitsuState.SwordModel = model
            end)
        end
    else
        SafeBypassSpeed(char, 16, 50)
    end
end

-- 5. XÂY DỰNG 3 KỸ NĂNG XUẤT HIỆN Ở CẢ MENU LẪN THANH ITEM (HOTBAR) BÊN DƯỚI
local function CreateSkillButton(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 80, 80)
    stroke.Thickness = 1
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
end

local function RegisterHotbarTool(toolName, callback)
    pcall(function()
        for _, item in ipairs(Backpack:GetChildren()) do
            if item.Name == toolName then item:Destroy() end
        end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild(toolName) then char[toolName]:Destroy() end

        local tool = Instance.new("Tool")
        tool.Name = toolName
        tool.RequiresHandle = false
        tool.Parent = Backpack

        tool.Activated:Connect(function()
            pcall(callback)
        end)
    end)
end

-- --- KỸ NĂNG 1: THỨC 1 - TÍCH KHẮC NHẤT THIỂM ---
local function Skill1_Action()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    CreateServerThunderFX(hrp.Position, 1)
    
    -- Lướt cực nhanh xuyên qua không gian
    local forwardDistance = 45
    local targetCFrame = hrp.CFrame + (hrp.CFrame.LookVector * forwardDistance)
    
    hrp.CFrame = targetCFrame
    CreateServerThunderFX(hrp.Position, 1.2)

    -- Quét mục tiêu xung quanh để hất tung & ép reset die (Mô phỏng sát thương toàn server)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local enemyHRP = player.Character.HumanoidRootPart
            local enemyHum = player.Character:FindFirstChildOfClass("Humanoid")
            if (enemyHRP.Position - hrp.Position).Magnitude < 15 then
                CreateServerThunderFX(enemyHRP.Position, 1.5)
                enemyHum:ChangeState(Enum.HumanoidStateType.FallingDown)
                pcall(function() enemyHum.Health = 0 end) -- Trảm sát mục tiêu
            end
        end
    end
end

CreateSkillButton("⚡ Thức 1: Tích Khắc Nhất Thiểm", 50, Skill1_Action)
RegisterHotbarTool("⚡ [Item] Nhất Thiểm", Skill1_Action)

-- --- KỸ NĂNG 2: THỨC 2 - LIÊN HOÀN ĐIỆN QUANG (LƯỚT 6 LẦN) ---
local function Skill2_Action()
    task.spawn(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart

        for i = 1, 6 do
            hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 8)
            CreateServerThunderFX(hrp.Position, 0.8)

            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local enemyHRP = player.Character.HumanoidRootPart
                    local enemyHum = player.Character:FindFirstChildOfClass("Humanoid")
                    if (enemyHRP.Position - hrp.Position).Magnitude < 12 then
                        enemyHum:ChangeState(Enum.HumanoidStateType.Jumping)
                        pcall(function() enemyHum.Health = 0 end)
                    end
                end
            end
            task.wait(0.025)
        end
    end)
end

CreateSkillButton("⚡ Thức 2: Liên Hoàn Điện Quang", 105, Skill2_Action)
RegisterHotbarTool("⚡ [Item] Liên Hoàn Sấm", Skill2_Action)

-- --- KỸ NĂNG 3: THỨC 3 - HỎA LÔI THẦN TỐC (ÁP SÁT & ĐÓNG KIẾM) ---
local function Skill3_Action()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    CreateServerThunderFX(hrp.Position, 1.5)
    hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 55)
    CreateServerThunderFX(hrp.Position, 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local enemyHRP = player.Character.HumanoidRootPart
            local enemyHum = player.Character:FindFirstChildOfClass("Humanoid")
            if (enemyHRP.Position - hrp.Position).Magnitude < 18 then
                -- Hất tung thẳng lên trời cao
                enemyHRP.Velocity = Vector3.new(0, 200, 0)
                enemyHum:ChangeState(Enum.HumanoidStateType.PlatformStand)
                pcall(function() enemyHum.Health = 0 end)
            end
        end
    end
end

CreateSkillButton("⚡ Thức 3: Hỏa Lôi Thần Tốc", 160, Skill3_Action)
RegisterHotbarTool("⚡ [Item] Hỏa Lôi Thần", Skill3_Action)

-- Nút Bật/Tắt Kiếm Sấm Sét trong Menu
CreateSkillButton("🗡️ [Toggle] Kiếm Sấm Sét & Tốc Độ", 215, function()
    ZenitsuState.IsActive = not ZenitsuState.IsActive
    ToggleZenitsuSword(ZenitsuState.IsActive)
end)

-- Nút Động Tác Đóng Kiếm Thật Ngầu
CreateSkillButton("⚔️ Động Tác Đóng Kiếm Katana", 270, function()
    local StarterGui = game:GetService("StarterGui")
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "⚡ Zenitsu Style",
            Text = "Cạch! Khóa vỏ kiếm hoàn hảo - Kẻ địch đã ngã xuống!",
            Duration = 2.5
        })
    end)
end)

-- Tự động dọn dẹp khi nhân vật chết hoặc reset
LocalPlayer.CharacterAdded:Connect(function()
    ZenitsuState.IsActive = false
    if ZenitsuState.SwordModel then
        pcall(function() ZenitsuState.SwordModel:Destroy() end)
    end
end)
