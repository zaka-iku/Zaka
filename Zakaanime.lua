--[[
    ZENITSU MENU - CỐ DAMAGE THẬT + HIỆU ỨNG MẠNH
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local SwordOn = false
local Cool = {S1=false, S2=false, S3=false, S4=false, Atk=false}
local SwordModel, Bubble = nil, nil

--==================== HIỆU ỨNG SÉT MẠNH ====================--
local function Lightning(pos, n)
    n = n or 6
    for i = 1, n do
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.15, math.random(4, 9), 0.15)
        p.Color = Color3.fromRGB(255, 235, 50)
        p.Material = Enum.Material.Neon
        p.Anchored = true
        p.CanCollide = false
        p.CFrame = CFrame.new(pos + Vector3.new(math.random(-4,4), math.random(0,5), math.random(-4,4)))
            * CFrame.Angles(math.rad(math.random(0,360)), 0, math.rad(math.random(0,360)))
        p.Parent = workspace
        Debris:AddItem(p, 0.25)
    end
end

local function LightningStreak(startPos, endPos)
    local dist = (endPos - startPos).Magnitude
    local p = Instance.new("Part")
    p.Size = Vector3.new(0.35, 0.35, dist)
    p.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -dist/2)
    p.Anchored = true
    p.CanCollide = false
    p.Material = Enum.Material.Neon
    p.Color = Color3.fromRGB(255, 230, 40)
    p.Parent = workspace
    TweenService:Create(p, TweenInfo.new(0.3), {Transparency = 1, Size = Vector3.new(0.05, 0.05, dist)}):Play()
    Debris:AddItem(p, 0.35)
end

local function Zoom(t)
    local old = Camera.FieldOfView
    TweenService:Create(Camera, TweenInfo.new(0.2), {FieldOfView = 36}):Play()
    task.delay(t or 0.9, function()
        TweenService:Create(Camera, TweenInfo.new(0.35), {FieldOfView = old}):Play()
    end)
end

--==================== CỐ GÂY DAMAGE + HẤT VĂNG ====================--
local function TryRealDamage(targetRoot, knockPower)
    if not targetRoot or not targetRoot.Parent then return end
    local hum = targetRoot.Parent:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    -- Cố trừ máu (một số game yếu vẫn ăn)
    pcall(function()
        hum.Health = math.max(0, hum.Health - 80)
    end)

    -- Hất văng mạnh
    pcall(function()
        targetRoot.AssemblyLinearVelocity = knockPower
        hum:ChangeState(Enum.HumanoidStateType.PlatformStand)
    end)

    Lightning(targetRoot.Position, 8)
end

local function GetClosestEnemy(range)
    local closest, shortest = nil, range or 40
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    -- Ưu tiên Player
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 then
                local d = (root.Position - myRoot.Position).Magnitude
                if d < shortest then
                    shortest = d
                    closest = root
                end
            end
        end
    end

    -- Thêm NPC / quái
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj.PrimaryPart
            if hum and root and hum.Health > 0 then
                local d = (root.Position - myRoot.Position).Magnitude
                if d < shortest then
                    shortest = d
                    closest = root
                end
            end
        end
    end
    return closest
end

--==================== KIẾM + NGỦ ====================--
local function CreateSword()
    local char = LocalPlayer.Character
    if not char then return end
    if SwordModel then SwordModel:Destroy() end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not torso then return end

    local model = Instance.new("Model")
    model.Name = "ZenitsuSword"

    local handle = Instance.new("Part")
    handle.Size = Vector3.new(0.28, 1, 0.28)
    handle.Color = Color3.fromRGB(35, 25, 18)
    handle.CanCollide = false
    handle.Massless = true
    handle.Parent = model

    local blade = Instance.new("Part")
    blade.Size = Vector3.new(0.18, 4, 0.1)
    blade.Color = Color3.fromRGB(255, 230, 50)
    blade.Material = Enum.Material.Neon
    blade.CanCollide = false
    blade.Massless = true
    blade.Parent = model

    local w = Instance.new("Weld")
    w.Part0 = handle
    w.Part1 = blade
    w.C0 = CFrame.new(0, 2.4, 0)
    w.Parent = blade

    local weld = Instance.new("Weld")
    weld.Part0 = torso
    weld.Part1 = handle
    weld.C0 = CFrame.new(1.12, 0.2, 0.55) * CFrame.Angles(math.rad(-10), math.rad(90), math.rad(-20))
    weld.Parent = handle

    model.Parent = char
    SwordModel = model
end

local function CreateBubble()
    local char = LocalPlayer.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    if Bubble then Bubble:Destroy() end

    local b = Instance.new("Part")
    b.Shape = Enum.PartType.Ball
    b.Size = Vector3.new(0.36, 0.36, 0.36)
    b.Color = Color3.fromRGB(180, 230, 255)
    b.Material = Enum.Material.Glass
    b.Transparency = 0.3
    b.CanCollide = false
    b.Massless = true
    b.Parent = head

    local w = Instance.new("Weld")
    w.Part0 = head
    w.Part1 = b
    w.C0 = CFrame.new(0, -0.16, -0.55)
    w.Parent = b
    Bubble = b
end

local function ToggleSword(state)
    SwordOn = state
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if state then
        CreateSword()
        CreateBubble()
        if hum then hum.WalkSpeed = 28 hum.JumpPower = 60 end
    else
        if SwordModel then SwordModel:Destroy() SwordModel = nil end
        if Bubble then Bubble:Destroy() Bubble = nil end
        if hum then hum.WalkSpeed = 16 hum.JumpPower = 50 end
    end
end

--==================== 4 SKILL ====================--
local function Skill1()
    if Cool.S1 or not SwordOn then return end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    Cool.S1 = true
    local start = root.Position
    local dir = root.CFrame.LookVector
    for i = 1, 8 do
        root.CFrame = root.CFrame + dir * 5
        Lightning(root.Position, 4)
        task.wait(0.04)
    end
    LightningStreak(start, root.Position)
    local target = GetClosestEnemy(18)
    if target then
        TryRealDamage(target, dir * 90 + Vector3.new(0, 70, 0))
    end
    task.delay(2.2, function() Cool.S1 = false end)
end

local function Skill2()
    if Cool.S2 or not SwordOn then return end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    Cool.S2 = true
    Zoom(1.2)
    for i = 1, 6 do
        local start = root.Position
        root.CFrame = root.CFrame + root.CFrame.LookVector * 7.5
        LightningStreak(start, root.Position)
        Lightning(root.Position, 6)
        local target = GetClosestEnemy(16)
        if target then
            TryRealDamage(target, (target.Position - root.Position).Unit * 70 + Vector3.new(0, 55, 0))
        end
        task.wait(0.08)
    end
    task.delay(3.2, function() Cool.S2 = false end)
end

local function Skill3()
    if Cool.S3 or not SwordOn then return end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    Cool.S3 = true
    Zoom(1.4)
    local start = root.Position
    for i = 1, 7 do
        root.CFrame = root.CFrame + root.CFrame.LookVector * 5.5
        Lightning(root.Position, 5)
        task.wait(0.04)
    end
    LightningStreak(start, root.Position)
    local target = GetClosestEnemy(20)
    if target then
        TryRealDamage(target, Vector3.new(0, 120, 0) + (target.Position - root.Position).Unit * 40)
    end
    task.wait(0.2)
    Lightning(root.Position, 12)
    task.delay(3.8, function() Cool.S3 = false end)
end

local function Skill4()
    if Cool.S4 or not SwordOn then return end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    Cool.S4 = true
    for i = 1, 15 do
        Lightning(root.Position, 5)
        task.wait(0.05)
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local t = plr.Character.HumanoidRootPart
            if (t.Position - root.Position).Magnitude < 25 then
                TryRealDamage(t, (t.Position - root.Position).Unit * 60 + Vector3.new(0, 80, 0))
            end
        end
    end
    task.delay(2.8, function() Cool.S4 = false end)
end

-- Đánh thường
UserInputService.InputBegan:Connect(function(input, gp)
    if gp or not SwordOn or Cool.Atk then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Cool.Atk = true
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            Lightning(root.Position + root.CFrame.LookVector * 3, 4)
            local target = GetClosestEnemy(12)
            if target then
                TryRealDamage(target, (target.Position - root.Position).Unit * 45 + Vector3.new(0, 35, 0))
            end
        end
        task.delay(0.35, function() Cool.Atk = false end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1.3)
    if SwordOn then CreateSword() CreateBubble() end
end)

--==================== MENU ====================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZenitsuMenu"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local ToggleIcon = Instance.new("TextButton")
ToggleIcon.Size = UDim2.new(0, 46, 0, 46)
ToggleIcon.Position = UDim2.new(0, 15, 0.4, 0)
ToggleIcon.BackgroundColor3 = Color3.fromRGB(255, 200, 40)
ToggleIcon.Text = "Z"
ToggleIcon.TextColor3 = Color3.fromRGB(30, 20, 0)
ToggleIcon.Font = Enum.Font.GothamBold
ToggleIcon.TextSize = 22
ToggleIcon.Parent = ScreenGui
Instance.new("UICorner", ToggleIcon).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 300, 0, 390)
Main.Position = UDim2.new(0.5, -150, 0.5, -195)
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
Title.Text = "ZENITSU | Cố Damage Thật"
Title.TextColor3 = Color3.fromRGB(255, 220, 60)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local function AddBtn(text, y, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 36)
    b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(40, 30, 15)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 230, 140)
    b.TextSize = 13
    b.Font = Enum.Font.Gotham
    b.Parent = Main
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(cb)
end

AddBtn("Bật / Tắt Kiếm + Ngủ", 50, function() ToggleSword(not SwordOn) end)
AddBtn("Skill 1: Lướt + Damage", 95, function() Skill1() end)
AddBtn("Skill 2: Lướt 6 Lần + Damage", 140, function() Skill2() end)
AddBtn("Skill 3: Lao + Hất Lên + Damage", 185, function() Skill3() end)
AddBtn("Skill 4: Sét AoE + Damage", 230, function() Skill4() end)
AddBtn("Đóng Menu", 300, function() Main.Visible = false end)

ToggleIcon.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

print("Zenitsu Damage Attempt Menu Loaded")
