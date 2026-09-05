--[[
    ZAKA ZENITSU MENU
    Kiếm vĩnh viễn + 3 Kỹ năng + Trạng thái ngủ + Đánh thường
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    SwordEnabled = false,
    SleepMode = true,
    Skill1 = false,
    Skill2 = false,
    Skill3 = false,
}

local SwordModel = nil
local SleepBubble = nil
local Cooldown = {
    Skill1 = false,
    Skill2 = false,
    Skill3 = false,
    Attack = false
}

--==================== TẠO KIẾM VĨNH VIỄN ====================--
local function CreateSword(char)
    if SwordModel then SwordModel:Destroy() end

    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not torso then return end

    local model = Instance.new("Model")
    model.Name = "ZenitsuSword"

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.3, 1.05, 0.3)
    handle.Color = Color3.fromRGB(35, 25, 18)
    handle.Material = Enum.Material.SmoothPlastic
    handle.CanCollide = false
    handle.Massless = true
    handle.Parent = model

    local guard = Instance.new("Part")
    guard.Size = Vector3.new(0.7, 0.16, 0.7)
    guard.Color = Color3.fromRGB(255, 210, 40)
    guard.Material = Enum.Material.Neon
    guard.CanCollide = false
    guard.Massless = true
    guard.Parent = model

    local blade = Instance.new("Part")
    blade.Name = "Blade"
    blade.Size = Vector3.new(0.2, 4.0, 0.12)
    blade.Color = Color3.fromRGB(255, 230, 70)
    blade.Material = Enum.Material.Neon
    blade.CanCollide = false
    blade.Massless = true
    blade.Parent = model

    local glow = Instance.new("Part")
    glow.Size = Vector3.new(0.08, 3.5, 0.04)
    glow.Color = Color3.fromRGB(255, 255, 180)
    glow.Material = Enum.Material.Neon
    glow.Transparency = 0.45
    glow.CanCollide = false
    glow.Massless = true
    glow.Parent = model

    local w1 = Instance.new("Weld")
    w1.Part0 = handle
    w1.Part1 = guard
    w1.C0 = CFrame.new(0, 0.52, 0)
    w1.Parent = guard

    local w2 = Instance.new("Weld")
    w2.Part0 = handle
    w2.Part1 = blade
    w2.C0 = CFrame.new(0, 2.45, 0)
    w2.Parent = blade

    local w3 = Instance.new("Weld")
    w3.Part0 = blade
    w3.Part1 = glow
    w3.Parent = glow

    local weld = Instance.new("Weld")
    weld.Part0 = torso
    weld.Part1 = handle
    weld.C0 = CFrame.new(1.12, 0.18, 0.55) * CFrame.Angles(math.rad(-12), math.rad(90), math.rad(-22))
    weld.Parent = handle

    model.Parent = char
    SwordModel = model
end

--==================== BONG BÓNG MŨI (NGỦ) ====================--
local function CreateBubble(char)
    if SleepBubble then SleepBubble:Destroy() end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local bubble = Instance.new("Part")
    bubble.Name = "ZenitsuBubble"
    bubble.Shape = Enum.PartType.Ball
    bubble.Size = Vector3.new(0.38, 0.38, 0.38)
    bubble.Color = Color3.fromRGB(185, 230, 255)
    bubble.Material = Enum.Material.Glass
    bubble.Transparency = 0.3
    bubble.CanCollide = false
    bubble.Massless = true
    bubble.Parent = head

    local w = Instance.new("Weld")
    w.Part0 = head
    w.Part1 = bubble
    w.C0 = CFrame.new(0, -0.16, -0.55)
    w.Parent = bubble

    SleepBubble = bubble
end

--==================== HIỆU ỨNG SÉT ====================--
local function SpawnLightning(pos, count)
    count = count or 5
    for i = 1, count do
        local bolt = Instance.new("Part")
        bolt.Size = Vector3.new(0.12, math.random(3, 7), 0.12)
        bolt.Color = Color3.fromRGB(255, 235, 60)
        bolt.Material = Enum.Material.Neon
        bolt.Anchored = true
        bolt.CanCollide = false
        bolt.CFrame = CFrame.new(pos + Vector3.new(math.random(-3,3), math.random(0,4), math.random(-3,3)))
            * CFrame.Angles(math.rad(math.random(0,360)), 0, math.rad(math.random(0,360)))
        bolt.Parent = workspace
        Debris:AddItem(bolt, 0.22)
    end
end

--==================== TƯ THẾ CÚI RÚT KIẾM ====================--
local function PlayDrawPose(char)
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    -- Giả lập cúi người bằng cách nghiêng camera + hơi hạ nhân vật
    local original = root.CFrame
    root.CFrame = root.CFrame * CFrame.new(0, -0.6, 0) * CFrame.Angles(math.rad(18), 0, 0)
    task.wait(0.85)
    root.CFrame = original
end

--==================== ZOOM CAMERA ====================--
local function ZoomIn(duration)
    local oldFOV = Camera.FieldOfView
    TweenService:Create(Camera, TweenInfo.new(0.25), {FieldOfView = 40}):Play()
    task.delay(duration or 0.8, function()
        TweenService:Create(Camera, TweenInfo.new(0.35), {FieldOfView = oldFOV}):Play()
    end)
end

--==================== SKILL 1: LƯỚT NGỦ ====================--
local function Skill1()
    if Cooldown.Skill1 or not Settings.SwordEnabled then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    Cooldown.Skill1 = true
    PlayDrawPose(char)

    local dir = root.CFrame.LookVector
    for i = 1, 8 do
        root.CFrame = root.CFrame + dir * 4.5
        SpawnLightning(root.Position, 3)
        task.wait(0.04)
    end

    task.delay(2.5, function() Cooldown.Skill1 = false end)
end

--==================== SKILL 2: LƯỚT 6 LẦN ====================--
local function Skill2()
    if Cooldown.Skill2 or not Settings.SwordEnabled then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    Cooldown.Skill2 = true
    PlayDrawPose(char)
    ZoomIn(1.2)

    local target = nil
    local shortest = 55
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if dist < shortest then
                shortest = dist
                target = plr.Character.HumanoidRootPart
            end
        end
    end

    for i = 1, 6 do
        local dir = target and (target.Position - root.Position).Unit or root.CFrame.LookVector
        root.CFrame = root.CFrame + dir * 8
        SpawnLightning(root.Position, 6)

        if target and target.Parent then
            pcall(function()
                target.AssemblyLinearVelocity = dir * 50 + Vector3.new(0, 35, 0)
            end)
        end
        task.wait(0.08)
    end

    task.delay(3.5, function() Cooldown.Skill2 = false end)
end

--==================== SKILL 3: LAO + HẤT + CHÉM + ĐÓNG KIẾM ====================--
local function Skill3()
    if Cooldown.Skill3 or not Settings.SwordEnabled then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    Cooldown.Skill3 = true
    PlayDrawPose(char)

    local target = nil
    local shortest = 50
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if dist < shortest then
                shortest = dist
                target = plr.Character.HumanoidRootPart
            end
        end
    end

    -- Lao tới
    if target then
        root.CFrame = CFrame.new(root.Position, target.Position)
        for i = 1, 6 do
            root.CFrame = root.CFrame + root.CFrame.LookVector * 5
            SpawnLightning(root.Position, 4)
            task.wait(0.05)
        end

        -- Hất lên
        pcall(function()
            target.AssemblyLinearVelocity = Vector3.new(0, 110, 0)
        end)
        SpawnLightning(target.Position, 8)
        task.wait(0.25)

        -- Zoom đóng kiếm
        ZoomIn(1.0)
        SpawnLightning(root.Position, 10)
    else
        -- Không có target thì lướt thẳng
        for i = 1, 7 do
            root.CFrame = root.CFrame + root.CFrame.LookVector * 5
            SpawnLightning(root.Position, 4)
            task.wait(0.05)
        end
        ZoomIn(0.8)
    end

    task.delay(4, function() Cooldown.Skill3 = false end)
end

--==================== ĐÁNH THƯỜNG ====================--
local function NormalAttack()
    if not Settings.SwordEnabled or Cooldown.Attack then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    Cooldown.Attack = true
    SpawnLightning(root.Position + root.CFrame.LookVector * 4, 4)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local t = plr.Character.HumanoidRootPart
            if (t.Position - root.Position).Magnitude < 11 then
                pcall(function()
                    t.AssemblyLinearVelocity = (t.Position - root.Position).Unit * 45 + Vector3.new(0, 30, 0)
                end)
            end
        end
    end

    task.delay(0.4, function() Cooldown.Attack = false end)
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        NormalAttack()
    end
end)

--==================== BẬT / TẮT KIẾM ====================--
local function ToggleSword(state)
    Settings.SwordEnabled = state
    local char = LocalPlayer.Character
    if not char then return end

    if state then
        CreateSword(char)
        if Settings.SleepMode then CreateBubble(char) end
        -- Tăng tốc + nhảy
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 28
            hum.JumpPower = 60
        end
    else
        if SwordModel then SwordModel:Destroy() SwordModel = nil end
        if SleepBubble then SleepBubble:Destroy() SleepBubble = nil end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1.3)
    if Settings.SwordEnabled then
        CreateSword(char)
        if Settings.SleepMode then CreateBubble(char) end
    end
end)

--==================== MENU ====================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZenitsuMenu"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 15, 0.35, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 40)
OpenBtn.Text = "Z"
OpenBtn.TextColor3 = Color3.fromRGB(30, 20, 0)
OpenBtn.TextSize = 22
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 300, 0, 340)
Main.Position = UDim2.new(0, 75, 0.25, 0)
Main.BackgroundColor3 = Color3.fromRGB(18, 16, 12)
Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 30, 10)
Title.Text = "ZENITSU  |  Hơi Thở Sấm Sét"
Title.TextColor3 = Color3.fromRGB(255, 220, 60)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.Parent = Main
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

local function AddBtn(text, y, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 36)
    b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(35, 28, 15)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 230, 150)
    b.TextSize = 13
    b.Font = Enum.Font.Gotham
    b.Parent = Main
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(callback)
end

AddBtn("Bật / Tắt Kiếm Zenitsu", 55, function()
    ToggleSword(not Settings.SwordEnabled)
end)

AddBtn("Skill 1: Lướt Ngủ", 100, function()
    Skill1()
end)

AddBtn("Skill 2: Lướt 6 Lần + Sét", 145, function()
    Skill2()
end)

AddBtn("Skill 3: Lao + Hất + Đóng Kiếm", 190, function()
    Skill3()
end)

AddBtn("Đóng Menu", 250, function()
    Main.Visible = false
end)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

print("Zenitsu Menu Loaded")
