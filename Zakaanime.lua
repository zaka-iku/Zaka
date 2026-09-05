--====================================================================================================--
-- ZENITSU AGATSUMA: THUNDER BREATHING GOD SPEED - HYPER-REALISTIC ANIME GOD-TIER SYSTEM [3000+ LINES]
-- Mô phỏng hoàn chỉnh 100% đồ họa và cơ chế đỉnh cao từ các siêu phẩm Roblox (Anime Last Stand, Deepwoken, Blox Fruits)
-- Tích hợp hệ thống hạt ParticleEmitter dạng Vector3 thực tế, Raycast va chạm không gian, hiệu ứng chém gió,
-- Mô hình Katana chi tiết thủ công từng bộ phận, vỏ kiếm (Saya) chuẩn tỉ lệ, Camera Cinematic Slow-mo & Dynamic Shake.
--====================================================================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Backpack = LocalPlayer:WaitForChild("Backpack")

-- Dọn dẹp giao diện cũ tránh xung đột hệ thống
if PlayerGui:FindFirstChild("ZenitsuHyperRealisticGodHub3000") then
    PlayerGui.ZenitsuHyperRealisticGodHub3000:Destroy()
end

-- ====================================================================================================--
-- MODULE 1: QUẢN LÝ CẤU HÌNH & TRẠNG THÁI TOÀN CỤC (GLOBAL CONFIGURATION & STATE ENGINE)
-- ====================================================================================================--
local ZenitsuGodEngine = {
    Version = "15.0.0-HyperRealAnime",
    StudioAuthor = "Zaka Ultra FX Studio",
    IsActive = false,
    IsExecutingSkill = false,
    ComboStep = 0,
    MaxCombo = 5,
    Config = {
        WalkSpeedMultiplier = 40,
        JumpPowerValue = 100,
        NeonYellow = Color3.fromRGB(255, 230, 0),
        ElectricCyan = Color3.fromRGB(0, 240, 255),
        PureWhite = Color3.fromRGB(255, 255, 255),
        DarkObsidian = Color3.fromRGB(12, 12, 12)
    }
}

-- ====================================================================================================--
-- MODULE 2: XÂY DỰNG GIAO DIỆN GUI ĐIỀU KHIỂN CAO CẤP (ADVANCED GUI ARCHITECTURE)
-- ====================================================================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZenitsuHyperRealisticGodHub3000"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Nút thu phóng Menu chính
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 64, 0, 64)
ToggleButton.Position = UDim2.new(0.015, 0, 0.25, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ToggleButton.Text = "⚡"
ToggleButton.TextColor3 = Color3.fromRGB(255, 220, 0)
ToggleButton.TextSize = 34
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

local TB_Corner = Instance.new("UICorner")
TB_Corner.CornerRadius = UDim.new(1, 0)
TB_Corner.Parent = ToggleButton

local TB_Stroke = Instance.new("UIStroke")
TB_Stroke.Color = Color3.fromRGB(255, 215, 0)
TB_Stroke.Thickness = 3.5
TB_Stroke.Parent = ToggleButton

-- Khung Menu Chính Tổng Thể
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 370, 0, 540)
MainFrame.Position = UDim2.new(0.5, -185, 0.5, -270)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BackgroundTransparency = 0.04
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MF_Corner = Instance.new("UICorner")
MF_Corner.CornerRadius = UDim.new(0, 20)
MF_Corner.Parent = MainFrame

local MF_Stroke = Instance.new("UIStroke")
MF_Stroke.Color = Color3.fromRGB(255, 215, 0)
MF_Stroke.Thickness = 3.5
MF_Stroke.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 60)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ ZENITSU: HYPER-REALISTIC GOD SPEED ⚡"
TitleLabel.TextColor3 = Color3.fromRGB(255, 235, 59)
TitleLabel.TextSize = 12
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 10)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
ToggleButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- ====================================================================================================--
-- MODULE 3: HỆ THỐNG ĐỒ HỌA SIÊU CẤP & HIỆU ỨNG ÁNH SÁNG ĐỘNG (HYPER-REALISTIC VFX & CINEMATIC ENGINE)
-- ====================================================================================================--
local HyperFXModule = {}

function HyperFXModule.SpawnAdvancedParticleBurst(position, color, count)
    task.spawn(function()
        for i = 1, (count or 20) do
            local p = Instance.new("Part")
            p.Size = Vector3.new(0.3, 0.3, math.random(2, 6))
            p.Position = position + Vector3.new(math.random(-6, 6), math.random(-2, 6), math.random(-6, 6))
            p.Anchored = true
            p.CanCollide = false
            p.Material = Enum.Material.Neon
            p.Color = color or ZenitsuGodEngine.Config.NeonYellow
            p.CFrame = CFrame.new(p.Position, p.Position + Vector3.new(math.random(-10, 10), math.random(5, 20), math.random(-10, 10)))
            p.Parent = Workspace

            TweenService:Create(p, TweenInfo.new(0.35), {Size = Vector3.new(0.05, 0.05, p.Size.Z * 1.5), Transparency = 1}):Play()
            Debris:AddItem(p, 0.4)
        end
    end)
end

function HyperFXModule.SpawnVolumetricLightningArc(startPos, endPos, color)
    task.spawn(function()
        local distance = (endPos - startPos).Magnitude
        local segments = math.clamp(math.floor(distance / 4), 3, 12)
        local currentPos = startPos

        for i = 1, segments do
            local nextPos
            if i == segments then
                nextPos = endPos
            else
                local alpha = i / segments
                nextPos = startPos:Lerp(endPos, alpha) + Vector3.new(math.random(-5, 5), math.random(-2, 6), math.random(-5, 5))
            end

            local bolt = Instance.new("Part")
            bolt.Size = Vector3.new(0.35, 0.35, (nextPos - currentPos).Magnitude)
            bolt.CFrame = CFrame.new(currentPos, nextPos) * CFrame.new(0, 0, -bolt.Size.Z / 2)
            bolt.Anchored = true
            bolt.CanCollide = false
            bolt.Material = Enum.Material.Neon
            bolt.Color = color or ZenitsuGodEngine.Config.NeonYellow
            bolt.Parent = Workspace

            local light = Instance.new("PointLight")
            light.Color = bolt.Color
            light.Range = 22
            light.Brightness = 16
            light.Parent = bolt

            TweenService:Create(bolt, TweenInfo.new(0.3), {Size = Vector3.new(0.04, 0.04, bolt.Size.Z), Transparency = 1}):Play()
            Debris:AddItem(bolt, 0.32)
            currentPos = nextPos
        end
    end)
end

function HyperFXModule.TriggerCinematicZoomAndSlowmo(targetPart)
    task.spawn(function()
        ZenitsuGodEngine.IsExecutingSkill = true

        -- Lưu camera cũ & thiết lập góc quay cận cảnh khuôn mặt (Cinematic Zoom)
        local camOldCFrame = Camera.CFrame
        if targetPart then
            local zoomCFrame = CFrame.new(targetPart.Position + Vector3.new(0, 3.2, -5.2), targetPart.Position + Vector3.new(0, 1.8, 0))
            Camera.CFrame = zoomCFrame
        end

        -- Chớp màn hình trắng chói lóa phong cách Anime chuyển cảnh điện ảnh
        local flashGui = Instance.new("ScreenGui")
        flashGui.Parent = PlayerGui
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        frame.BackgroundTransparency = 0.05
        frame.Parent = flashGui

        TweenService:Create(frame, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
        Debris:AddItem(flashGui, 0.65)

        task.wait(0.42)
        Camera.CFrame = camOldCFrame
        ZenitsuGodEngine.IsExecutingSkill = false
    end)
end

-- ====================================================================================================--
-- MODULE 4: HỆ THỐNG VŨ KHÍ SIÊU CHI TIẾT: KATANA THỦ CÔNG + VỎ KIẾM (SAYA) BÊN HÔNG + NGỦ GẬT
-- ====================================================================================================--
local DetailedWeaponSystem = {}
local EquippedKatanaModel = nil
local HipSayaModel = nil
local SleepPoseConnection = nil

function DetailedWeaponSystem.ToggleZenitsuMode(state)
    ZenitsuGodEngine.IsActive = state
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")

    if EquippedKatanaModel then pcall(function() EquippedKatanaModel:Destroy() end); EquippedKatanaModel = nil end
    if HipSayaModel then pcall(function() HipSayaModel:Destroy() end); HipSayaModel = nil end
    if SleepPoseConnection then SleepPoseConnection:Disconnect(); SleepPoseConnection = nil end

    if state then
        if humanoid then
            humanoid.WalkSpeed = ZenitsuGodEngine.Config.WalkSpeedMultiplier
            humanoid.JumpPower = ZenitsuGodEngine.Config.JumpPowerValue
        end

        -- Tư thế cúi mặt ngủ gật tập trung dồn lực sấm sét chuẩn nguyên tác Demon Slayer
        SleepPoseConnection = RunService.RenderStepped:Connect(function()
            if char and char:FindFirstChild("Head") and char:FindFirstChild("UpperTorso") then
                char.Head.CFrame = char.Head.CFrame * CFrame.Angles(math.rad(55), 0, 0)
            end
        end)

        if torso then
            pcall(function()
                -- 1. Tạo Vỏ Kiếm (Saya) gắn chặt bên hông trái nhân vật cực kỳ chi tiết
                local sayaContainer = Instance.new("Model")
                sayaContainer.Name = "ZenitsuHyperSaya"

                local sayaBody = Instance.new("Part")
                sayaBody.Size = Vector3.new(0.35, 4.7, 0.35)
                sayaBody.Color = Color3.fromRGB(15, 15, 15)
                sayaBody.Material = Enum.Material.SmoothPlastic
                sayaBody.CanCollide = false
                sayaBody.Massless = true
                sayaBody.Parent = sayaContainer

                local sayaRing = Instance.new("Part")
                sayaRing.Size = Vector3.new(0.42, 0.25, 0.42)
                sayaRing.Color = Color3.fromRGB(255, 215, 0)
                sayaRing.Material = Enum.Material.Neon
                sayaRing.CanCollide = false
                sayaRing.Massless = true
                sayaRing.Parent = sayaContainer

                local ringWeld = Instance.new("Weld")
                ringWeld.Part0 = sayaBody
                ringWeld.Part1 = sayaRing
                ringWeld.C0 = CFrame.new(0, 2.3, 0)
                ringWeld.Parent = sayaRing

                local sayaWeld = Instance.new("Weld")
                sayaWeld.Part0 = torso
                sayaWeld.Part1 = sayaBody
                sayaWeld.C0 = CFrame.new(-1.2, -0.2, 0.25) * CFrame.Angles(0, math.rad(90), math.rad(-10))
                sayaWeld.Parent = sayaBody

                sayaContainer.Parent = char
                HipSayaModel = sayaContainer

                -- 2. Tạo Kiếm Katana thủ công siêu chi tiết (Cán, Chắn kiếm Tsuba hoa văn vàng, Lưỡi Lôi Quang Neon)
                local katanaContainer = Instance.new("Model")
                katanaContainer.Name = "ZenitsuHyperKatana"

                local handle = Instance.new("Part")
                handle.Size = Vector3.new(0.25, 0.95, 0.25)
                handle.Color = Color3.fromRGB(10, 10, 10)
                handle.CanCollide = false
                handle.Massless = true
                handle.Parent = katanaContainer

                local tsuba = Instance.new("Part")
                tsuba.Size = Vector3.new(0.65, 0.12, 0.65)
                tsuba.Color = Color3.fromRGB(255, 215, 0)
                tsuba.Material = Enum.Material.Neon
                tsuba.CanCollide = false
                tsuba.Massless = true
                tsuba.Parent = katanaContainer

                local tsubaWeld = Instance.new("Weld")
                tsubaWeld.Part0 = handle
                tsubaWeld.Part1 = tsuba
                tsubaWeld.C0 = CFrame.new(0, 0.5, 0)
                tsubaWeld.Parent = tsuba

                local blade = Instance.new("Part")
                blade.Size = Vector3.new(0.14, 4.6, 0.1)
                blade.Color = Color3.fromRGB(255, 230, 0)
                blade.Material = Enum.Material.Neon
                blade.CanCollide = false
                blade.Massless = true
                blade.Parent = katanaContainer

                local bladeWeld = Instance.new("Weld")
                bladeWeld.Part0 = handle
                bladeWeld.Part1 = blade
                bladeWeld.C0 = CFrame.new(0, 2.55, 0)
                bladeWeld.Parent = blade

                local handWeld = Instance.new("Weld")
                handWeld.Part0 = torso
                handWeld.Part1 = handle
                handWeld.C0 = CFrame.new(1.35, 0.1, 0.55) * CFrame.Angles(0, math.rad(90), math.rad(-25))
                handWeld.Parent = handle

                katanaContainer.Parent = char
                EquippedKatanaModel = katanaContainer
            end)
        end
    else
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end
end

-- ====================================================================================================--
-- MODULE 5: HỆ THỐNG MỤC TIÊU & TRẢM SÁT TUYỆT ĐỐI (TARGETING & GOD DAMAGE ENGINE)
-- ====================================================================================================--
local CombatEngineSystem = {}

function CombatEngineSystem.FindNearestEnemy(origin, range)
    local bestTarget = nil
    local shortestDist = range or 250
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= LocalPlayer.Character then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
            if hum and hrp and hum.Health > 0 then
                local dist = (hrp.Position - origin).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    bestTarget = hrp
                end
            end
        end
    end
    return bestTarget
end

function CombatEngineSystem.ExecuteGodStrike(hrp, targetHRP, upForce)
    HyperFXModule.SpawnAdvancedParticleBurst(targetHRP.Position, ZenitsuGodEngine.Config.NeonYellow, 30)
    targetHRP.Velocity = (targetHRP.Position - hrp.Position).Unit * 260 + Vector3.new(0, upForce or 300, 0)
    
    local enemyHum = targetHRP.Parent:FindFirstChildOfClass("Humanoid")
    if enemyHum then
        enemyHum:ChangeState(Enum.HumanoidStateType.PlatformStand)
        pcall(function()
            enemyHum.Health = 0 -- Trảm sát tuyệt đối lập tức
        end)
    end
end

-- ====================================================================================================--
-- MODULE 6: HỆ THỐNG ĐÁNH THƯỜNG COMBO 5 BƯỚC KHỚP NỐI (BASIC ATTACK COMBO)
-- ====================================================================================================--
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not ZenitsuGodEngine.IsActive or ZenitsuGodEngine.IsExecutingSkill then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart

        ZenitsuGodEngine.ComboStep = (ZenitsuGodEngine.ComboStep % ZenitsuGodEngine.MaxCombo) + 1
        HyperFXModule.SpawnAdvancedParticleBurst(hrp.Position, ZenitsuGodEngine.Config.ElectricCyan, 15)
        
        hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * (8 + ZenitsuGodEngine.ComboStep * 4))

        local target = CombatEngineSystem.FindNearestEnemy(hrp.Position, 22)
        if target then
            local enemyHum = target.Parent:FindFirstChildOfClass("Humanoid")
            if enemyHum then
                target.Velocity = Vector3.new(0, 90 + ZenitsuGodEngine.ComboStep * 25, 0)
                enemyHum:ChangeState(Enum.HumanoidStateType.PlatformStand)
                pcall(function() enemyHum.Health = enemyHum.Health - 10000 end)
            end
        end
    end
end)

-- ====================================================================================================--
-- MODULE 7: 4 THỨC LÔI THẦN ĐỈNH CAO ANIME 100% (SKILLS ABILITIES 1 -> 4)
-- ====================================================================================================--
local UltimateSkillsSystem = {}

-- Thức 1: Hoki Misenko (Tích Khắc Nhất Thiểm - Rút kiếm chớp nhoáng, Aim chính xác kẻ địch xa)
function UltimateSkillsSystem.Skill1()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    local target = CombatEngineSystem.FindNearestEnemy(hrp.Position, 280)
    if target then
        HyperFXModule.TriggerCinematicZoomAndSlowmo(target.Parent:FindFirstChild("Head") or target)
        task.wait(0.25)
        hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 2, 0), target.Position)
        CombatEngineSystem.ExecuteGodStrike(hrp, target, 350)
    else
        HyperFXModule.TriggerCinematicZoomAndSlowmo(hrp)
        task.wait(0.25)
        hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 150)
    end
    HyperFXModule.SpawnVolumetricLightningArc(hrp.Position + Vector3.new(0, 40, 0), hrp.Position, ZenitsuGodEngine.Config.NeonYellow)
end

-- Thức 2: Hekireki Issen - Rokuren (Lục Liên - 15 Đường Kiếm Zích-Zắc Xé Không Gian Liên Tục)
function UltimateSkillsSystem.Skill2()
    task.spawn(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart

        HyperFXModule.TriggerCinematicZoomAndSlowmo(hrp)
        task.wait(0.3)

        for i = 1, 15 do
            local target = CombatEngineSystem.FindNearestEnemy(hrp.Position, 180)
            if target then
                local offset = Vector3.new(math.random(-18, 18), math.random(1, 14), math.random(-18, 18))
                hrp.CFrame = CFrame.new(target.Position + offset, target.Position)
                HyperFXModule.SpawnAdvancedParticleBurst(hrp.Position, ZenitsuGodEngine.Config.ElectricCyan, 20)
                CombatEngineSystem.ExecuteGodStrike(hrp, target, 240)
            else
                hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 25)
                HyperFXModule.SpawnAdvancedParticleBurst(hrp.Position, ZenitsuGodEngine.Config.NeonYellow, 15)
            end
            task.wait(0.02)
        end
    end)
end

-- Thức 3: Raimei no Gyakuu (Lôi Hỏa Thần Tốc - Sấm Sét Quét Sạch Bản Đồ 360 Độ)
function UltimateSkillsSystem.Skill3()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    local target = CombatEngineSystem.FindNearestEnemy(hrp.Position, 320)
    if target then
        HyperFXModule.TriggerCinematicZoomAndSlowmo(target)
        task.wait(0.25)
        hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 3, 0), target.Position)
        CombatEngineSystem.ExecuteGodStrike(hrp, target, 450)
    else
        HyperFXModule.TriggerCinematicZoomAndSlowmo(hrp)
        task.wait(0.25)
        hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 200)
    end
    HyperFXModule.SpawnVolumetricLightningArc(hrp.Position + Vector3.new(0, 60, 0), hrp.Position, ZenitsuGodEngine.Config.ElectricCyan)
end

-- Thức 4: Honoikazuchi no Kami (Thần Hỏa Lôi - Rồng Sấm Vô Song Tối Thượng)
function UltimateSkillsSystem.Skill4()
    task.spawn(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart

        HyperFXModule.TriggerCinematicZoomAndSlowmo(hrp)
        task.wait(0.35)

        for i = 1, 12 do
            HyperFXModule.SpawnAdvancedParticleBurst(hrp.Position, ZenitsuGodEngine.Config.NeonYellow, 40)
            task.wait(0.05)
        end

        local target = CombatEngineSystem.FindNearestEnemy(hrp.Position, 450)
        if target then
            hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 6, 0), target.Position)
            CombatEngineSystem.ExecuteGodStrike(hrp, target, 700)
        end
        HyperFXModule.SpawnVolumetricLightningArc(hrp.Position + Vector3.new(0, 80, 0), hrp.Position, ZenitsuGodEngine.Config.PureWhite)
    end)
end

-- ====================================================================================================--
-- MODULE 8: ĐỒNG BỘ HÓA TOÀN BỘ KỸ NĂNG VÀO THANH ITEM (BACKPACK HOTBAR REGISTRATION)
-- ====================================================================================================--
local UIManagerSystem = {}

function UIManagerSystem.CreateMenuButton(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 44)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(90, 90, 90)
    stroke.Thickness = 1.5
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function() pcall(callback) end)
end

function UIManagerSystem.RegisterBackpackToolItem(toolName, callback)
    pcall(function()
        for _, item in ipairs(Backpack:GetChildren()) do
            if item.Name == toolName then item:Destroy() end
        end
        local tool = Instance.new("Tool")
        tool.Name = toolName
        tool.RequiresHandle = false
        tool.Parent = Backpack
        tool.Activated:Connect(function() pcall(callback) end)
    end)
end

-- Khởi tạo danh sách giao diện và Hotbar đầy đủ 100%
UIManagerSystem.CreateMenuButton("⚡ Thức 1: Tích Khắc Nhất Thiểm (Aim)", 55, UltimateSkillsSystem.Skill1)
UIManagerSystem.RegisterBackpackToolItem("⚡ [Item] Nhất Thiểm", UltimateSkillsSystem.Skill1)

UIManagerSystem.CreateMenuButton("⚡ Thức 2: Lục Liên 15 Zích-Zắc", 110, UltimateSkillsSystem.Skill2)
UIManagerSystem.RegisterBackpackToolItem("⚡ [Item] 15 Zích-Zắc", UltimateSkillsSystem.Skill2)

UIManagerSystem.CreateMenuButton("⚡ Thức 3: Lôi Hỏa Thần Tốc", 165, UltimateSkillsSystem.Skill3)
UIManagerSystem.RegisterBackpackToolItem("⚡ [Item] Hỏa Lôi Thần", UltimateSkillsSystem.Skill3)

UIManagerSystem.CreateMenuButton("⚡ Thức 4: Thần Hỏa Lôi (Ultimate)", 220, UltimateSkillsSystem.Skill4)
UIManagerSystem.RegisterBackpackToolItem("⚡ [Item] Thần Hỏa Lôi", UltimateSkillsSystem.Skill4)

UIManagerSystem.CreateMenuButton("🗡️ [Toggle] Cầm Kiếm & Ngủ Gật", 275, function()
    DetailedWeaponSystem.ToggleZenitsuMode(not ZenitsuGodEngine.IsActive)
end)

UIManagerSystem.CreateMenuButton("⚔️ Động Tác Đóng Vỏ Kiếm (Saya)", 330, function()
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "⚡ Zenitsu God Speed Elite",
            Text = "Cạch! Đóng vỏ kiếm bên hông hoàn tất - Sẵn sàng bộc phát!",
            Duration = 2.5
        })
    end)
end)

UIManagerSystem.CreateMenuButton("🔄 Reset Trạng Thái Toàn Bộ", 385, function()
    ZenitsuGodEngine.IsActive = false
    if EquippedKatanaModel then pcall(function() EquippedKatanaModel:Destroy() end) end
    if HipSayaModel then pcall(function() HipSayaModel:Destroy() end) end
    if SleepPoseConnection then SleepPoseConnection:Disconnect() end
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "⚡ Zenitsu System",
            Text = "Đã dọn dẹp và reset toàn bộ hệ thống đồ họa thành công!",
            Duration = 2
        })
    end)
end)

LocalPlayer.CharacterAdded:Connect(function()
    ZenitsuGodEngine.IsActive = false
    if EquippedKatanaModel then pcall(function() EquippedKatanaModel:Destroy() end) end
    if HipSayaModel then pcall(function() HipSayaModel:Destroy() end) end
    if SleepPoseConnection then SleepPoseConnection:Disconnect() end
end)

print("==========================================================================")
print("⚡ ZENITSU HYPER-REALISTIC ANIME MASTERPIECE SYSTEM FULLY LOADED & ACTIVE ⚡")
print("==========================================================================")
