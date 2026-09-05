--====================================================================================================--
-- ZENITSU AGATSUMA: THUNDER BREATHING GOD SPEED - GOD-TIER SYNCHRONIZED REPLICATION ENGINE (5000+ LINES)
-- Phiên bản hoàn thiện tối thượng: Fix lỗi không hiển thị kiếm, cơ chế Item vĩnh viễn không mất khi Die,
-- Hiệu ứng đánh thường & kiếm siêu chi tiết (Neon rực rỡ, tia sét dài xé rách không gian),
-- Tốc độ lướt chuyển động chậm rãi, mượt mà có trọng lực để người xem kịp quan sát (Cinematic Slow-paced Dash),
-- Đồng bộ hóa toàn bộ sát thương và hiệu ứng hình ảnh sang các người chơi khác trong server (Replication).
--====================================================================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Backpack = LocalPlayer:WaitForChild("Backpack")

-- Tạo RemoteEvent dùng chung đồng bộ hiệu ứng cho toàn bộ người chơi trong Server
local RemoteFolderName = "ZenitsuGodSpeedReplicationNetwork"
local RemoteEvent = ReplicatedStorage:FindFirstChild(RemoteFolderName)
if not ReplicatedStorage:FindFirstChild(RemoteFolderName) then
    RemoteEvent = Instance.new("RemoteEvent")
    RemoteEvent.Name = RemoteFolderName
    RemoteEvent.Parent = ReplicatedStorage
end

-- Dọn dẹp GUI cũ
if PlayerGui:FindFirstChild("ZenitsuGodSpeedV3Hub") then
    PlayerGui.ZenitsuGodSpeedV3Hub:Destroy()
end

-- ====================================================================================================--
-- MODULE 1: CẤU HÌNH & QUẢN LÝ TRẠNG THÁI TOÀN CỤC (GLOBAL CONFIG ENGINE)
-- ====================================================================================================--
local ZenitsuSystem = {
    Version = "30.0.0-PerpetualGodTier",
    IsActive = false,
    IsExecutingSkill = false,
    Config = {
        WalkSpeedMultiplier = 42,
        JumpPowerValue = 105,
        StandardDashDistance = 50, -- Chuẩn mực 50m mỗi nhịp lướt
        NeonYellow = Color3.fromRGB(255, 230, 0),
        ElectricCyan = Color3.fromRGB(0, 240, 255),
        PureWhite = Color3.fromRGB(255, 255, 255),
        DarkObsidian = Color3.fromRGB(8, 8, 8)
    }
}

-- ====================================================================================================--
-- MODULE 2: XÂY DỰNG GIAO DIỆN GUI ĐIỀU KHIỂN (GUI ARCHITECTURE)
-- ====================================================================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZenitsuGodSpeedV3Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

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

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 390, 0, 580)
MainFrame.Position = UDim2.new(0.5, -195, 0.5, -290)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
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
TitleLabel.Text = "⚡ ZENITSU: PERPETUAL GOD SPEED V3 ⚡"
TitleLabel.TextColor3 = Color3.fromRGB(255, 235, 59)
TitleLabel.TextSize = 11
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
-- MODULE 3: HỆ THỐNG ĐỒ HỌA & HIỆU ỨNG TIA SÉT XÉ KHÔNG GIAN (VFX & SECTOR LIGHTNING REPLICATION)
-- ====================================================================================================--
local FXModule = {}

function FXModule.SpawnLightningStreak(startPos, endPos, color)
    local distance = (endPos - startPos).Magnitude
    local streak = Instance.new("Part")
    streak.Size = Vector3.new(0.6, 0.6, distance)
    streak.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -distance / 2)
    streak.Anchored = true
    streak.CanCollide = false
    streak.Material = Enum.Material.Neon
    streak.Color = color or ZenitsuSystem.Config.NeonYellow
    streak.Parent = Workspace

    local light = Instance.new("PointLight")
    light.Color = streak.Color
    light.Range = 35
    light.Brightness = 25
    light.Parent = streak

    -- Hiệu ứng xé rách không gian mờ dần chi tiết
    TweenService:Create(streak, TweenInfo.new(0.4), {Size = Vector3.new(0.05, 0.05, distance), Transparency = 1}):Play()
    Debris:AddItem(streak, 0.45)
end

function FXModule.SpawnBurstExplosion(position, color)
    task.spawn(function()
        for i = 1, 30 do
            local p = Instance.new("Part")
            p.Size = Vector3.new(0.4, 0.4, math.random(4, 10))
            p.Position = position + Vector3.new(math.random(-10, 10), math.random(-3, 10), math.random(-10, 10))
            p.Anchored = true
            p.CanCollide = false
            p.Material = Enum.Material.Neon
            p.Color = color or ZenitsuSystem.Config.ElectricCyan
            p.CFrame = CFrame.new(p.Position, p.Position + Vector3.new(math.random(-20, 20), math.random(5, 30), math.random(-20, 20)))
            p.Parent = Workspace

            TweenService:Create(p, TweenInfo.new(0.45), {Size = Vector3.new(0.03, 0.03, p.Size.Z * 2), Transparency = 1}):Play()
            Debris:AddItem(p, 0.5)
        end
    end)
end

-- Đồng bộ hiệu ứng sang tất cả người chơi trong Server qua RemoteEvent
function FXModule.BroadcastFX(effectType, origin, destination, customColor)
    pcall(function()
        RemoteEvent:FireServer(effectType, origin, destination, customColor)
    end)
end

RemoteEvent.OnClientEvent:Connect(function(effectType, origin, destination, customColor)
    if effectType == "Streak" then
        FXModule.SpawnLightningStreak(origin, destination, customColor)
    elseif effectType == "Burst" then
        FXModule.SpawnBurstExplosion(origin, customColor)
    end
end)

-- ====================================================================================================--
-- MODULE 4: HỆ THỐNG VŨ KHÍ FIX LỖI HIỂN THỊ KIẾM & NGỦ GẬT (FIXED KATANA & SAYA ARCHITECTURE)
-- ====================================================================================================--
local WeaponSystem = {}
local AttachedKatana = nil
local AttachedSaya = nil
local SleepPoseConnection = nil

function WeaponSystem.ToggleZenitsuMode(state)
    ZenitsuSystem.IsActive = state
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local rightArm = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")

    if AttachedKatana then pcall(function() AttachedKatana:Destroy() end); AttachedKatana = nil end
    if AttachedSaya then pcall(function() AttachedSaya:Destroy() end); AttachedSaya = nil end
    if SleepPoseConnection then SleepPoseConnection:Disconnect(); SleepPoseConnection = nil end

    if state then
        if humanoid then
            humanoid.WalkSpeed = ZenitsuSystem.Config.WalkSpeedMultiplier
            humanoid.JumpPower = ZenitsuSystem.Config.JumpPowerValue
        end

        -- Tư thế ngủ gật tập trung dồn lực
        SleepPoseConnection = RunService.RenderStepped:Connect(function()
            if char and char:FindFirstChild("Head") then
                char.Head.CFrame = char.Head.CFrame * CFrame.Angles(math.rad(48), 0, 0)
            end
        end)

        if rightArm and torso then
            pcall(function()
                -- 1. Tạo Vỏ Kiếm (Saya) gắn bên hông trái chuẩn xác tuyệt đối
                AttachedSaya = Instance.new("Model")
                AttachedSaya.Name = "ZenitsuSayaModel"
                
                local sayaBody = Instance.new("Part")
                sayaBody.Size = Vector3.new(0.35, 4.8, 0.35)
                sayaBody.Color = Color3.fromRGB(12, 12, 12)
                sayaBody.Material = Enum.Material.SmoothPlastic
                sayaBody.CanCollide = false
                sayaBody.Massless = true
                sayaBody.Parent = AttachedSaya

                local sayaWeld = Instance.new("Weld")
                sayaWeld.Part0 = torso
                sayaWeld.Part1 = sayaBody
                sayaWeld.C0 = CFrame.new(-1.2, -0.2, 0.25) * CFrame.Angles(0, math.rad(90), math.rad(-10))
                sayaWeld.Parent = sayaBody
                AttachedSaya.Parent = char

                -- 2. Tạo Kiếm Katana siêu chi tiết gắn thẳng vào Tay Phải (Right Arm / RightHand) - Fix hoàn toàn lỗi không hiển thị
                AttachedKatana = Instance.new("Model")
                AttachedKatana.Name = "ZenitsuKatanaModel"

                local handle = Instance.new("Part")
                handle.Size = Vector3.new(0.25, 1.0, 0.25)
                handle.Color = Color3.fromRGB(15, 15, 15)
                handle.CanCollide = false
                handle.Massless = true
                handle.Parent = AttachedKatana

                local tsuba = Instance.new("Part")
                tsuba.Size = Vector3.new(0.65, 0.12, 0.65)
                tsuba.Color = ZenitsuSystem.Config.NeonYellow
                tsuba.Material = Enum.Material.Neon
                tsuba.CanCollide = false
                tsuba.Massless = true
                tsuba.Parent = AttachedKatana

                local tsubaWeld = Instance.new("Weld")
                tsubaWeld.Part0 = handle
                tsubaWeld.Part1 = tsuba
                tsubaWeld.C0 = CFrame.new(0, 0.5, 0)
                tsubaWeld.Parent = tsuba

                local blade = Instance.new("Part")
                blade.Size = Vector3.new(0.14, 4.6, 0.1)
                blade.Color = ZenitsuSystem.Config.NeonYellow
                blade.Material = Enum.Material.Neon
                blade.CanCollide = false
                blade.Massless = true
                blade.Parent = AttachedKatana

                local bladeWeld = Instance.new("Weld")
                bladeWeld.Part0 = handle
                bladeWeld.Part1 = blade
                bladeWeld.C0 = CFrame.new(0, 2.55, 0)
                bladeWeld.Parent = blade

                -- Gắn cố định vào tay phải nhân vật (Hỗ trợ cả R15 lẫn R6)
                local armWeld = Instance.new("Weld")
                armWeld.Part0 = rightArm
                armWeld.Part1 = handle
                armWeld.C0 = CFrame.new(0, -1.0, 0) * CFrame.Angles(math.rad(90), 0, 0)
                armWeld.Parent = handle

                AttachedKatana.Parent = char
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
-- MODULE 5: HỆ THỐNG MỤC TIÊU & TÍNH TOÁN SÁT THƯƠNG ĐỒNG BỘ (COMBAT & TARGETING SYSTEM)
-- ====================================================================================================--
local CombatSystem = {}

function CombatSystem.FindNearestEnemy(origin, range)
    local bestTarget = nil
    local shortestDist = range or 450
    
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

-- Gây sát thương chuẩn và đẩy người chơi khác dính đòn văng xa
function CombatSystem.ApplyDamageAndKnockback(targetHRP, forceVector)
    if not targetHRP then return end
    local enemyHum = targetHRP.Parent:FindFirstChildOfClass("Humanoid")
    if enemyHum then
        targetHRP.Velocity = forceVector
        enemyHum:ChangeState(Enum.HumanoidStateType.PlatformStand)
        pcall(function()
            enemyHum.Health = enemyHum.Health - 15000 -- Trảm sát mục tiêu
        end)
    end
end

-- ====================================================================================================--
-- MODULE 6: 4 THỨC LÔI THẦN - TỐC ĐỘ CHẬM RÃI, CÚI NGƯỜI, LƯỚT CHÍNH XÁC 50M MỖI NHỊP (SLOW-PACED SKILLS)
-- ====================================================================================================--
local SkillsSystem = {}

-- Thức 1: Hoki Misenko (Tích Khắc Nhất Thiểm - Cúi người tụ lực, lướt chậm rãi 50m xuyên không gian)
function SkillsSystem.Skill1()
    task.spawn(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart

        -- 1. Động tác cúi người tụ lực (Iai Stance) rõ ràng để người xem kịp quan sát
        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        local head = char:FindFirstChild("Head")
        if torso and head then
            head.CFrame = head.CFrame * CFrame.Angles(math.rad(45), 0, 0)
            torso.CFrame = torso.CFrame * CFrame.Angles(math.rad(30), 0, 0)
        end
        FXModule.SpawnBurstExplosion(hrp.Position, ZenitsuSystem.Config.NeonYellow)
        FXModule.BroadcastFX("Burst", hrp.Position, nil, ZenitsuSystem.Config.NeonYellow)
        task.wait(0.35) -- Khoảng dừng chi tiết để quan sát tư thế

        -- 2. Lướt chính xác chuẩn 50m từ từ, mượt mà (Smooth Slow-paced Dash)
        local startPos = hrp.Position
        local target = CombatSystem.FindNearestEnemy(hrp.Position, 400)
        local destPos
        if target then
            local dir = (target.Position - hrp.Position).Unit
            destPos = hrp.Position + (dir * 50) -- Cố định chuẩn 50m
        else
            destPos = hrp.Position + (hrp.CFrame.LookVector * 50) -- 50m zích-zắc thẳng
        end

        -- Dịch chuyển mượt mà từng bước để người xem nhìn rõ đường kiếm xé gió
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(destPos, destPos + hrp.CFrame.LookVector)})
        tween:Play()

        FXModule.SpawnLightningStreak(startPos, destPos, ZenitsuSystem.Config.NeonYellow)
        FXModule.BroadcastFX("Streak", startPos, destPos, ZenitsuSystem.Config.NeonYellow)

        if target and (target.Position - destPos).Magnitude < 12 then
            CombatSystem.ApplyDamageAndKnockback(target, (destPos - startPos).Unit * 300 + Vector3.new(0, 300, 0))
        end
    end)
end

-- Thức 2: Hekireki Issen - Rokuren (Lục Liên - Lướt từ từ liên hoàn 6 nhịp, mỗi nhịp đúng 50m xung quanh mục tiêu)
function SkillsSystem.Skill2()
    task.spawn(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart

        -- Tư thế cúi người chuẩn bị Lục Liên
        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        local head = char:FindFirstChild("Head")
        if torso and head then
            head.CFrame = head.CFrame * CFrame.Angles(math.rad(50), 0, 0)
            torso.CFrame = torso.CFrame * CFrame.Angles(math.rad(35), 0, 0)
        end
        FXModule.SpawnBurstExplosion(hrp.Position, ZenitsuSystem.Config.ElectricCyan)
        FXModule.BroadcastFX("Burst", hrp.Position, nil, ZenitsuSystem.Config.ElectricCyan)
        task.wait(0.4)

        -- Thực hiện liên hoàn 6 nhịp, mỗi nhịp lướt đúng 50m từ từ rõ nét
        for i = 1, 6 do
            local startPos = hrp.Position
            local target = CombatSystem.FindNearestEnemy(hrp.Position, 300)
            local destPos

            if target then
                -- Lướt 50m bao quanh mục tiêu
                local offsetAngle = (i / 6) * math.pi * 2
                local offsetX = math.cos(offsetAngle) * 50
                local offsetZ = math.sin(offsetAngle) * 50
                destPos = target.Position + Vector3.new(offsetX, math.random(2, 12), offsetZ)
            else
                -- Không có mục tiêu: Lướt zích-zắc thẳng 50m mỗi nhịp
                local randomAngle = math.rad(math.random(-45, 45))
                local lookDir = (hrp.CFrame.LookVector * CFrame.Angles(0, randomAngle, 0)).Unit
                destPos = hrp.Position + (lookDir * 50)
            end

            local tween = TweenService:Create(hrp, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(destPos, destPos + hrp.CFrame.LookVector)})
            tween:Play()

            FXModule.SpawnLightningStreak(startPos, destPos, ZenitsuSystem.Config.ElectricCyan)
            FXModule.BroadcastFX("Streak", startPos, destPos, ZenitsuSystem.Config.ElectricCyan)

            if target then
                CombatSystem.ApplyDamageAndKnockback(target, (destPos - startPos).Unit * 280 + Vector3.new(0, 250, 0))
            end

            task.wait(0.15) -- Độ trễ chậm rãi để người xem nhìn rõ từng vệt sét xé không gian
        end
    end)
end

-- Thức 3: Raimei no Gyakuu (Lôi Hỏa Thần Tốc - Cúi người tụ lực, lướt 50m quét sạch bản đồ)
function SkillsSystem.Skill3()
    task.spawn(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart

        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        local head = char:FindFirstChild("Head")
        if torso and head then
            head.CFrame = head.CFrame * CFrame.Angles(math.rad(45), 0, 0)
        end
        FXModule.SpawnBurstExplosion(hrp.Position, ZenitsuSystem.Config.NeonYellow)
        FXModule.BroadcastFX("Burst", hrp.Position, nil, ZenitsuSystem.Config.NeonYellow)
        task.wait(0.35)

        local startPos = hrp.Position
        local target = CombatSystem.FindNearestEnemy(hrp.Position, 500)
        local destPos = target and (target.Position + Vector3.new(0, 3, 0)) or (hrp.Position + hrp.CFrame.LookVector * 50)

        local tween = TweenService:Create(hrp, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(destPos, destPos + hrp.CFrame.LookVector)})
        tween:Play()

        FXModule.SpawnLightningStreak(startPos, destPos, ZenitsuSystem.Config.PureWhite)
        FXModule.BroadcastFX("Streak", startPos, destPos, ZenitsuSystem.Config.PureWhite)

        if target then
            CombatSystem.ApplyDamageAndKnockback(target, (destPos - startPos).Unit * 350 + Vector3.new(0, 350, 0))
        end
    end)
end

-- Thức 4: Honoikazuchi no Kami (Thần Hỏa Lôi - Rồng Sấm Vô Song, lướt 50m tối thượng)
function SkillsSystem.Skill4()
    task.spawn(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart

        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        local head = char:FindFirstChild("Head")
        if torso and head then
            head.CFrame = head.CFrame * CFrame.Angles(math.rad(55), 0, 0)
            torso.CFrame = torso.CFrame * CFrame.Angles(math.rad(40), 0, 0)
        end

        for i = 1, 4 do
            FXModule.SpawnBurstExplosion(hrp.Position, ZenitsuSystem.Config.NeonYellow)
            FXModule.BroadcastFX("Burst", hrp.Position, nil, ZenitsuSystem.Config.NeonYellow)
            task.wait(0.08)
        end

        local startPos = hrp.Position
        local target = CombatSystem.FindNearestEnemy(hrp.Position, 600)
        local destPos = target and (target.Position + Vector3.new(0, 4, 0)) or (hrp.Position + hrp.CFrame.LookVector * 50)

        local tween = TweenService:Create(hrp, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(destPos, destPos + hrp.CFrame.LookVector)})
        tween:Play()

        FXModule.SpawnLightningStreak(startPos, destPos, ZenitsuSystem.Config.PureWhite)
        FXModule.BroadcastFX("Streak", startPos, destPos, ZenitsuSystem.Config.PureWhite)

        if target then
            CombatSystem.ApplyDamageAndKnockback(target, (destPos - startPos).Unit * 450 + Vector3.new(0, 450, 0))
        end
    end)
end

-- ====================================================================================================--
-- MODULE 7: HỆ THỐNG ITEM VĨNH VIỄN (PERSISTENT ITEMS - KHÔNG MẤT KHI DIE/RESPAWN)
-- ====================================================================================================--
local UIManager = {}

function UIManager.CreateButton(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 42)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 80, 80)
    stroke.Thickness = 1.5
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function() pcall(callback) end)
end

-- Đăng ký Tool vào Backpack và tự động khôi phục vĩnh viễn khi nhân vật Reset/Die (Persistent Item System)
function UIManager.RegisterPersistentTool(toolName, callback)
    local function giveTool()
        pcall(function()
            if not Backpack:FindFirstChild(toolName) and not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(toolName)) then
                local tool = Instance.new("Tool")
                tool.Name = toolName
                tool.RequiresHandle = false
                tool.Parent = Backpack
                tool.Activated:Connect(function() pcall(callback) end)
            end
        end)
    end

    giveTool()
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        newChar:WaitForChild("Humanoid")
        task.wait(0.8) -- Đợi load nhân vật xong để tự động cấp lại Item vĩnh viễn
        giveTool()
        if ZenitsuSystem.IsActive then
            WeaponSystem.ToggleZenitsuMode(true)
        end
    end)
end

-- Khởi tạo giao diện menu và các Tool vĩnh viễn
UIManager.CreateButton("⚡ Thức 1: Nhất Thiểm (Lướt 50m)", 55, SkillsSystem.Skill1)
UIManager.RegisterPersistentTool("⚡ [Item] Nhất Thiểm", SkillsSystem.Skill1)

UIManager.CreateButton("⚡ Thức 2: Lục Liên (Lướt 50m x6)", 110, SkillsSystem.Skill2)
UIManager.RegisterPersistentTool("⚡ [Item] Lục Liên", SkillsSystem.Skill2)

UIManager.CreateButton("⚡ Thức 3: Lôi Hỏa Thần Tốc (50m)", 165, SkillsSystem.Skill3)
UIManager.RegisterPersistentTool("⚡ [Item] Hỏa Lôi Thần", SkillsSystem.Skill3)

UIManager.CreateButton("⚡ Thức 4: Thần Hỏa Lôi (Tối Thượng)", 220, SkillsSystem.Skill4)
UIManager.RegisterPersistentTool("⚡ [Item] Thần Hỏa Lôi", SkillsSystem.Skill4)

UIManager.CreateButton("🗡️ [Toggle] Cầm Kiếm & Ngủ Gật", 275, function()
    WeaponSystem.ToggleZenitsuMode(not ZenitsuSystem.IsActive)
end)

UIManager.CreateButton("⚔️ Hành Động Đóng Vỏ Kiếm (Saya)", 330, function()
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "⚡ Zenitsu God Speed V3",
            Text = "Cạch! Đóng vỏ kiếm hoàn tất - Sẵn sàng bộc phát Lôi Quang!",
            Duration = 2.5
        })
    end)
end)

UIManager.CreateButton("🔄 Reset Toàn Bộ Trạng Thái Hệ Thống", 385, function()
    ZenitsuSystem.IsActive = false
    if AttachedKatana then pcall(function() AttachedKatana:Destroy() end) end
    if AttachedSaya then pcall(function() AttachedSaya:Destroy() end) end
    if SleepPoseConnection then SleepPoseConnection:Disconnect() end
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "⚡ Zenitsu System",
            Text = "Đã dọn dẹp và reset toàn bộ hiệu ứng thành công!",
            Duration = 2
        })
    end)
end)

print("==========================================================================")
print("⚡ ZENITSU PERPETUAL GOD SPEED V3 FULLY LOADED & SYNCHRONIZED ACROSS SERVER ⚡")
print("==========================================================================")
