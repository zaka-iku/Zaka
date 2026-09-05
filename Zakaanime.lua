--[[
    ZENITSU FULL MENU
    Ưu tiên: Menu hiện ổn định + 3 chiêu + kiếm
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================== BIẾN ====================--
local SwordOn = false
local Cool1, Cool2, Cool3, CoolAtk = false, false, false, false
local SwordModel = nil
local Bubble = nil

--==================== HIỆU ỨNG SÉT ====================--
local function Lightning(pos, n)
    n = n or 5
    for i = 1, n do
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.12, math.random(3,6), 0.12)
        p.Color = Color3.fromRGB(255, 235, 60)
        p.Material = Enum.Material.Neon
        p.Anchored = true
        p.CanCollide = false
        p.CFrame = CFrame.new(pos + Vector3.new(math.random(-3,3), math.random(0,3), math.random(-3,3)))
            * CFrame.Angles(math.rad(math.random(0,360)), 0, math.rad(math.random(0,360)))
        p.Parent = workspace
        Debris:AddItem(p, 0.2)
    end
end

--==================== TẠO KIẾM ====================--
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
    handle.Color = Color3.fromRGB(40, 30, 20)
    handle.CanCollide = false
    handle.Massless = true
    handle.Parent = model

    local blade = Instance.new("Part")
    blade.Size = Vector3.new(0.18, 3.8, 0.1)
    blade.Color = Color3.fromRGB(255, 230, 60)
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
    SwordModel = model
end

local function RemoveSword()
    if SwordModel then
        SwordModel:Destroy()
        SwordModel = nil
    end
    if Bubble then
        Bubble:Destroy()
        Bubble = nil
    end
end

--==================== BONG BÓNG NGỦ ====================--
local function CreateBubble()
    local char = LocalPlayer.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    if Bubble then Bubble:Destroy() end

    local b = Instance.new("Part")
    b.Shape = Enum.PartType.Ball
    b.Size = Vector3.new(0.35, 0.35, 0.35)
    b.Color = Color3.fromRGB(180, 230, 255)
    b.Material = Enum.Material.Glass
    b.Transparency = 0.3
    b.CanCollide = false
    b.Massless = true
    b.Parent = head

    local w = Instance.new("Weld")
    w.Part0 = head
    w.Part1 = b
    w.C0 = CFrame.new(0, -0.15, -0.55)
    w.Parent = b

    Bubble = b
end

--==================== 3 CHIÊU ====================--
local function Skill1()
    if Cool1 or not SwordOn then return end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    Cool1 = true
    local dir = root.CFrame.LookVector
    for i = 1, 8 do
        root.CFrame = root.CFrame + dir * 4.2
        Lightning(root.Position, 3)
        task.wait(0.04)
    end
    task.delay(2.5, function() Cool1 = false end)
end

local function Skill2()
    if Cool2 or not SwordOn then return end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    Cool2 = true
    local old = Camera.FieldOfView
    TweenService:Create(Camera, TweenInfo.new(0.2), {FieldOfView = 42}):Play()

    for i = 1, 6 do
        root.CFrame = root.CFrame + root.CFrame.LookVector * 7
        Lightning(root.Position, 6)
        task.wait(0.07)
    end

    TweenService:Create(Camera, TweenInfo.new(0.3), {FieldOfView = old}):Play()
    task.delay(3.2, function() Cool2 = false end)
end

local function Skill3()
    if Cool3 or not SwordOn then return end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    Cool3 = true
    local old = Camera.FieldOfView
    TweenService:Create(Camera, TweenInfo.new(0.2), {FieldOfView = 36}):Play()

    for i = 1, 7 do
        root.CFrame = root.CFrame + root.CFrame.LookVector * 5
        Lightning(root.Position, 5)
        task.wait(0.045)
    end

    -- Hất người gần
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local t = plr.Character.HumanoidRootPart
            if (t.Position - root.Position).Magnitude < 13 then
                pcall(function()
                    t.AssemblyLinearVelocity = Vector3.new(0, 90, 0)
                end)
                Lightning(t.Position, 7)
            end
        end
    end

    task.wait(0.25)
    Lightning(root.Position, 9)
    TweenService:Create(Camera, TweenInfo.new(0.35), {FieldOfView = old}):Play()
    task.delay(4, function() Cool3 = false end)
end

--==================== ĐÁNH THƯỜNG ====================--
UserInputService.InputBegan:Connect(function(input, gp)
    if gp or not SwordOn or CoolAtk then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        CoolAtk = true
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            Lightning(root.Position + root.CFrame.LookVector * 3, 4)
        end
        task.delay(0.35, function() CoolAtk = false end)
    end
end)

--==================== MENU (ƯU TIÊN HIỆN) ====================--
local gui = Instance.new("ScreenGui")
gui.Name = "ZenitsuMenu"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ok = pcall(function()
    gui.Parent = game:GetService("CoreGui")
end)
if not ok or not gui.Parent then
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Nút mở
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 52, 0, 52)
openBtn.Position = UDim2.new(0, 12, 0.32, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 40)
openBtn.Text = "Z"
openBtn.TextColor3 = Color3.fromRGB(30, 20, 0)
openBtn.TextSize = 22
openBtn.Font = Enum.Font.GothamBold
openBtn.Parent = gui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)

-- Khung menu
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 280, 0, 320)
main.Position = UDim2.new(0, 75, 0.22, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 16, 10)
main.BorderSizePixel = 0
main.Visible = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(45, 35, 12)
title.Text = "ZENITSU - Hơi Thở Sấm Sét"
title.TextColor3 = Color3.fromRGB(255, 220, 60)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.Parent = main
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

local function MakeButton(text, y, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 38)
    b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(40, 30, 15)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 230, 140)
    b.TextSize = 13
    b.Font = Enum.Font.Gotham
    b.Parent = main
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(callback)
end

MakeButton("Bật / Tắt Kiếm + Ngủ", 55, function()
    SwordOn = not SwordOn
    if SwordOn then
        CreateSword()
        CreateBubble()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 28
            hum.JumpPower = 60
        end
    else
        RemoveSword()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end
end)

MakeButton("Skill 1: Lướt Ngủ", 105, function()
    Skill1()
end)

MakeButton("Skill 2: Lướt 6 Lần + Sét", 155, function()
    Skill2()
end)

MakeButton("Skill 3: Lao + Hất + Đóng Kiếm", 205, function()
    Skill3()
end)

MakeButton("Đóng Menu", 265, function()
    main.Visible = false
end)

openBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- Giữ kiếm khi respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1.4)
    if SwordOn then
        CreateSword()
        CreateBubble()
    end
end)

print("Zenitsu Menu Loaded")
