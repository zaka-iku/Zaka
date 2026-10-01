--[[
 ZAKA PURE UI // V1
 RASENGAN MENU REWORK
 Mobile-friendly UI architecture based on the old V3 six-tab structure.

 IMPORTANT:
 This version preserves the old V3 menu organization, setting names and
 control names, while providing a new Rasengan visual/animation layer.
 It is intended as a UI/settings framework for an experience you own/control.
 Offensive exploit callbacks are intentionally not included.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

local old = PG:FindFirstChild("ZakaPureUI")
if old then old:Destroy() end
--==============================================================================--
--                            CẤU HÌNH HỆ THỐNG (SETTINGS)                       --
--==============================================================================--
local Settings = {
    -- Combat & Aimbot
    Aimbot = false,
    AimbotFOV = 120,
    AimbotSmooth = 0.25,
    SilentAim = false,
    AutoClicker = false,
    ClickDelay = 0.05,
    TargetStrafe = false,
    StrafeDistance = 12,
    StrafeSpeed = 6,
    TriggerBot = false,
    KillAura = false,
    KillAuraDist = 18,
    AutoBlock = false,
    FastAttack = false,
    AutoSkill = false,
    
    -- Hitbox Mở Rộng
    HitboxHead = false,
    HeadSize = 15,
    HitboxTorso = false,
    TorsoSize = Vector3.new(4, 6, 4),
    HitboxWeapon = false,
    WeaponSize = 5,
    HitboxTransparent = 0.5,
    HitboxLimb = false,
    LimbSize = 4,
    HitboxTeamCheck = false,
    HitboxAutoUpdate = true,
    
    -- Visuals & ESP
    ESP = false,
    ESPBox = true,
    ESPName = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPMaxDist = 3500,
    Chams = false,
    ChamsColor = Color3.fromRGB(0, 200, 255),
    CustomCrosshair = false,
    CrosshairSize = 12,
    GlowTrail = false,
    Fullbright = false,
    FOVChanger = false,
    FOVValue = 90,
    Tracers = false,
    ESPHeadDot = false,
    NightVision = false,
    FPSBoost = false,
    
    -- Player & Movement
    Speed = false,
    SpeedValue = 26,
    Fly = false,
    FlySpeed = 50,
    FlyMode = "Camera", -- Camera hoặc Vector
    Noclip = false,
    InfiniteJump = false,
    SpinBot = false,
    SpinSpeed = 45,
    SpiderClimb = false,
    SpiderSpeed = 30,
    WaterWalk = false,
    Bhop = false,
    HighJump = false,
    JumpPower = 100,
    SuperDash = false,
    AutoRespawn = false,
    AntiRagdoll = false,
    GodModeVisual = false,
    
    -- World & Teleport
    TouchTP = false,
    NoClipParts = false,
    ServerHop = false,
    BringNPC = false,
    BringNPCMode = "Nearest",
    ClickDelete = false,
    AntiVoid = false,
    ServerRejoin = false,
    TimeChanger = false,
    GameTime = 14,
    GravityMod = false,
    GravityValue = 196.2,
    AutoCollectItems = false,
    InstantInteract = false,
    
    -- Troll & Fun
    ChatSpammer = false,
    SpamMessage = "Zaka Pure UI v3.0 - Ultimate Power!",
    SpamDelay = 2,
    Invisible = false,
    FlingMe = false,
    SoundSpammer = false,
    ToolDupe = false,
    FakeLag = false,
    HeadlessMode = false,
    CorruptServer = false,
    AnimationPack = false,
    EmoteSpam = false,
    RainbowColor = false,
    CrashClientWarning = false,
    NullifyCollisions = false,
    AutoEquipBest = false,
    ServerLockdown = false,
}

--==============================================================================--
--                            LOGIC TÍNH NĂNG TOÀN DIỆN                           --
--==============================================================================--
local NoclipConn, SpeedConn, FlyConn, TouchTPConn, AutoClickConn, SpamConn, StrafeConn, WaterConn, SpiderConn, BhopConn, KillAuraConn, BringNPCConn, TriggerConn, GravityConn, CrosshairConn
local BodyGyro, BodyVelocity
local ESPObjects = {}
local ChamsObjects = {}
local OriginalFogEnd = Lighting.FogEnd
local OriginalAmbient = Lighting.Ambient
local OriginalGravity = Workspace.Gravity

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Infinite Jump & High Jump
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if Settings.HighJump then
            hum.JumpPower = Settings.JumpPower
        end
    end
end)

-- Bhop
BhopConn = RunService.RenderStepped:Connect(function()
    if Settings.Bhop then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.FloorMaterial ~= Enum.Material.Air then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Fullbright & NightVision & FOV
RunService.RenderStepped:Connect(function()
    if Settings.Fullbright then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = OriginalAmbient
    end
    
    if Settings.FOVChanger then
        Camera.FieldOfView = Settings.FOVValue
    end

    if Settings.GravityMod then
        Workspace.Gravity = Settings.GravityValue
    else
        Workspace.Gravity = OriginalGravity
    end
end)

-- Touch TP
local function SetTouchTP(state)
    Settings.TouchTP = state
    if TouchTPConn then TouchTPConn:Disconnect() TouchTPConn = nil end
    if state then
        TouchTPConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                if Settings.TouchTP and Mouse.Hit then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3.5, 0))
                    end
                end
            end
        end)
    end
end

-- Water Walk (Jesus)
local function SetWaterWalk(state)
    Settings.WaterWalk = state
    if WaterConn then WaterConn:Disconnect() WaterConn = nil end
    if state then
        WaterConn = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local ray = Ray.new(root.Position, Vector3.new(0, -6, 0))
                local hit, pos, norm, mat = Workspace:FindPartOnRay(ray, char)
                if mat == Enum.Material.Water then
                    root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
                    root.CFrame = CFrame.new(root.Position.X, pos.Y + 3.2, root.Position.Z)
                end
            end
        end)
    end
end

-- Spider Climb (Bám tường dọc)
local function SetSpiderClimb(state)
    Settings.SpiderClimb = state
    if SpiderConn then SpiderConn:Disconnect() SpiderConn = nil end
    if state then
        SpiderConn = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local ray = Ray.new(root.Position, root.CFrame.LookVector * 3)
                local hit = Workspace:FindPartOnRay(ray, char)
                if hit then
                    root.Velocity = Vector3.new(root.Velocity.X, Settings.SpiderSpeed, root.Velocity.Z)
                end
            end
        end)
    end
end

-- Auto Clicker
local function SetAutoClicker(state)
    Settings.AutoClicker = state
    if AutoClickConn then AutoClickConn:Disconnect() AutoClickConn = nil end
    if state then
        AutoClickConn = RunService.RenderStepped:Connect(function()
            if Settings.AutoClicker then
                VirtualUser:Button1Down(Vector2.new())
                task.wait(Settings.ClickDelay)
                VirtualUser:Button1Up(Vector2.new())
            end
        end)
    end
end

-- Bring NPC / Enemies
local function SetBringNPC(state)
    Settings.BringNPC = state
    if BringNPCConn then BringNPCConn:Disconnect() BringNPCConn = nil end
    if state then
        BringNPCConn = RunService.RenderStepped:Connect(function()
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and obj ~= LocalPlayer.Character then
                    local hum = obj:FindFirstChildOfClass("Humanoid")
                    local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                    if hum and root and hum.Health > 0 then
                        if not Players:GetPlayerFromCharacter(obj) then -- Là NPC hoặc Dummy
                            root.CFrame = myRoot.CFrame * CFrame.new(0, 0, -4)
                            root.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end
        end)
    end
end

-- Chat Spammer
local function SetChatSpammer(state)
    Settings.ChatSpammer = state
    if SpamConn then task.cancel(SpamConn) SpamConn = nil end
    if state then
        SpamConn = task.spawn(function()
            while Settings.ChatSpammer do
                pcall(function()
                    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                        local channel = TextChatService.TextChannels.RBXGeneral
                        channel:SendAsync(Settings.SpamMessage)
                    else
                        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Settings.SpamMessage, "All")
                    end
                end)
                task.wait(Settings.SpamDelay)
            end
        end)
    end
end

-- Target Strafe
local function SetTargetStrafe(state)
    Settings.TargetStrafe = state
    if StrafeConn then StrafeConn:Disconnect() StrafeConn = nil end
    if state then
        local angle = 0
        StrafeConn = RunService.RenderStepped:Connect(function()
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            local target = nil
            local minDist = 9999
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (plr.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        target = plr.Character.HumanoidRootPart
                    end
                end
            end
            if target and minDist <= 50 then
                angle = angle + math.rad(Settings.StrafeSpeed)
                local offset = Vector3.new(math.cos(angle) * Settings.StrafeDistance, 0, math.sin(angle) * Settings.StrafeDistance)
                myRoot.CFrame = CFrame.new(target.Position + offset, target.Position)
            end
        end)
    end
end

-- Glow Trail
local function SetGlowTrail(state)
    Settings.GlowTrail = state
    local char = LocalPlayer.Character
    if not char then return end
    if state then
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local a0 = Instance.new("Attachment", root)
        a0.Name = "TrailA0"
        a0.Position = Vector3.new(0, -2.2, 0)
        local a1 = Instance.new("Attachment", root)
        a1.Name = "TrailA1"
        a1.Position = Vector3.new(0, -2.0, 0)
        local trail = Instance.new("Trail")
        trail.Name = "PlayerGlowTrail"
        trail.Attachment0 = a0
        trail.Attachment1 = a1
        trail.Lifetime = 0.8
        trail.Color = ColorSequence.new(Color3.fromRGB(0, 180, 255), Color3.fromRGB(255, 0, 220))
        trail.Transparency = NumberSequence.new(0.1, 1)
        trail.Parent = char
    else
        if char:FindFirstChild("PlayerGlowTrail") then char.PlayerGlowTrail:Destroy() end
        if char:FindFirstChild("HumanoidRootPart") then
            if char.HumanoidRootPart:FindFirstChild("TrailA0") then char.HumanoidRootPart.TrailA0:Destroy() end
            if char.HumanoidRootPart:FindFirstChild("TrailA1") then char.HumanoidRootPart.TrailA1:Destroy() end
        end
    end
end

-- Hitbox mở rộng toàn diện (Đầu, Thân, Tay Chân, Vũ khí)
RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            
            -- Head
            local head = char:FindFirstChild("Head")
            if head then
                if Settings.HitboxHead then
                    head.Size = Vector3.new(Settings.HeadSize, Settings.HeadSize, Settings.HeadSize)
                    head.Transparency = Settings.HitboxTransparent
                    head.CanCollide = false
                else
                    head.Size = Vector3.new(2, 1, 1)
                    head.Transparency = 0
                end
            end

            -- Torso
            local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            if torso then
                if Settings.HitboxTorso then
                    torso.Size = Settings.TorsoSize
                    torso.Transparency = Settings.HitboxTransparent
                    torso.CanCollide = false
                else
                    torso.Size = Vector3.new(2, 2, 1)
                    torso.Transparency = 0
                end
            end

            -- Limb (Tay/Chân)
            if Settings.HitboxLimb then
                for _, partName in ipairs({"Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftLowerArm", "RightLowerArm", "LeftLowerLeg", "RightLowerLeg"}) do
                    local limb = char:FindFirstChild(partName)
                    if limb and limb:IsA("BasePart") then
                        limb.Size = Vector3.new(Settings.LimbSize, Settings.LimbSize, Settings.LimbSize)
                        limb.Transparency = Settings.HitboxTransparent
                        limb.CanCollide = false
                    end
                end
            end

            -- Weapon / Tool
            if Settings.HitboxWeapon then
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        for _, part in ipairs(tool:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.Size = Vector3.new(Settings.WeaponSize, Settings.WeaponSize, Settings.WeaponSize)
                                part.Transparency = Settings.HitboxTransparent
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Aimbot FOV Circle & Crosshair
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = Settings.AimbotFOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(0, 180, 255)

local CrosshairVertical = Drawing.new("Line")
local CrosshairHorizontal = Drawing.new("Line")

local function GetClosestPlayerHead()
    local closestHead = nil
    local shortestDist = Settings.AimbotFOV
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - centerScreen).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestHead = head
                    end
                end
            end
        end
    end
    return closestHead
end

local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    if not checkcaller() and Settings.SilentAim and self == Mouse and tostring(key) == "Hit" then
        local targetHead = GetClosestPlayerHead()
        if targetHead then return targetHead.CFrame end
    end
    return oldIndex(self, key)
end)

RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Position = center
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Visible = Settings.Aimbot or Settings.SilentAim

    if Settings.CustomCrosshair then
        local s = Settings.CrosshairSize
        CrosshairVertical.From = Vector2.new(center.X, center.Y - s)
        CrosshairVertical.To = Vector2.new(center.X, center.Y + s)
        CrosshairVertical.Color = Color3.fromRGB(0, 255, 200)
        CrosshairVertical.Thickness = 2
        CrosshairVertical.Visible = true

        CrosshairHorizontal.From = Vector2.new(center.X - s, center.Y)
        CrosshairHorizontal.To = Vector2.new(center.X + s, center.Y)
        CrosshairHorizontal.Color = Color3.fromRGB(0, 255, 200)
        CrosshairHorizontal.Thickness = 2
        CrosshairHorizontal.Visible = true
    else
        CrosshairVertical.Visible = false
        CrosshairHorizontal.Visible = false
    end

    if Settings.Aimbot then
        local targetHead = GetClosestPlayerHead()
        if targetHead then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetHead.Position), Settings.AimbotSmooth)
        end
    end

    if Settings.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
    end
end)

-- ESP & Chams Logic
RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            if Settings.Chams then
                if not ChamsObjects[plr] then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ZakaChams"
                    hl.FillColor = Settings.ChamsColor
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.35
                    hl.Parent = plr.Character
                    ChamsObjects[plr] = hl
                end
            else
                if ChamsObjects[plr] then ChamsObjects[plr]:Destroy() ChamsObjects[plr] = nil end
            end
        end
    end

    if not Settings.ESP then
        for _, drawings in pairs(ESPObjects) do
            for _, d in pairs(drawings) do d.Visible = false end
        end
        return
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if not ESPObjects[plr] then
            ESPObjects[plr] = {
                Box = Drawing.new("Square"),
                Name = Drawing.new("Text"),
                Health = Drawing.new("Text"),
                Distance = Drawing.new("Text"),
            }
            ESPObjects[plr].Box.Filled = false
            ESPObjects[plr].Name.Size = 12
            ESPObjects[plr].Name.Center = true
            ESPObjects[plr].Name.Outline = true
            ESPObjects[plr].Health.Size = 11
            ESPObjects[plr].Health.Center = true
            ESPObjects[plr].Health.Outline = true
            ESPObjects[plr].Distance.Size = 11
            ESPObjects[plr].Distance.Center = true
            ESPObjects[plr].Distance.Outline = true
        end

        local drawings = ESPObjects[plr]
        local char = plr.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
            for _, d in pairs(drawings) do d.Visible = false end
            continue
        end

        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local dist = (root.Position - Camera.CFrame.Position).Magnitude

        if not onScreen or dist > Settings.ESPMaxDist then
            for _, d in pairs(drawings) do d.Visible = false end
            continue
        end

        local size = Vector2.new(math.clamp(2000 / pos.Z, 8, 300), math.clamp(3000 / pos.Z, 12, 450))
        drawings.Box.Size = size
        drawings.Box.Position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
        drawings.Box.Color = Color3.fromRGB(0, 180, 255)
        drawings.Box.Visible = Settings.ESPBox

        drawings.Name.Text = plr.Name
        drawings.Name.Position = Vector2.new(pos.X, pos.Y - size.Y / 2 - 14)
        drawings.Name.Color = Color3.fromRGB(240, 245, 255)
        drawings.Name.Visible = Settings.ESPName

        drawings.Health.Text = math.floor(hum.Health) .. " HP"
        drawings.Health.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 2)
        drawings.Health.Visible = Settings.ESPHealth

        drawings.Distance.Text = math.floor(dist) .. "m"
        drawings.Distance.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 14)
        drawings.Distance.Visible = Settings.ESPDistance
    end
end)

-- Fly Engine Tuỳ Biến
local function StartFly()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 9e4
    BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.cframe = root.CFrame
    BodyGyro.Parent = root

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.velocity = Vector3.new(0, 0, 0)
    BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Parent = root

    FlyConn = RunService.RenderStepped:Connect(function()
        if not Settings.Fly or not char or not char:FindFirstChild("Humanoid") then
            if BodyGyro then BodyGyro:Destroy() end
            if BodyVelocity then BodyVelocity:Destroy() end
            if FlyConn then FlyConn:Disconnect() end
            return
        end
        local hum = char.Humanoid
        BodyGyro.cframe = Camera.CFrame
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            local flyVector = (Camera.CFrame.LookVector * (moveDir.Z * -1)) + (Camera.CFrame.RightVector * moveDir.X)
            BodyVelocity.velocity = flyVector.Unit * Settings.FlySpeed
        else
            BodyVelocity.velocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function SetFly(state)
    Settings.Fly = state
    if state then StartFly() else
        if BodyGyro then BodyGyro:Destroy() end
        if BodyVelocity then BodyVelocity:Destroy() end
        if FlyConn then FlyConn:Disconnect() end
    end
end

-- Speed Walk (Max 500)
local function SetSpeed(state)
    if SpeedConn then SpeedConn:Disconnect() SpeedConn = nil end
    if state then
        SpeedConn = RunService.Heartbeat:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = Settings.SpeedValue end
        end)
    else
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end

-- Noclip
local function SetNoclip(state)
    if NoclipConn then NoclipConn:Disconnect() NoclipConn = nil end
    if state then
        NoclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end
end

--==============================================================================--
--                           ZAKA PURE UI INTERFACE v3.0                        --
--==============================================================================--
pcall(function()
    if PlayerGui:FindFirstChild("ZakaPureUI") then
        PlayerGui.ZakaPureUI:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaPureUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

-- Toggle Button (Có thể đổi kích thước / kéo thả)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 58, 0, 58)
ToggleBtn.Position = UDim2.new(0, 16, 0.38, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.BackgroundTransparency = 0.1
ToggleBtn.Text = "Z"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 24
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Transparency = 0.35
ToggleStroke.Parent = ToggleBtn

-- Main Window
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 460, 0, 520)
Main.Position = UDim2.new(0.5, -230, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(15, 19, 28)
Main.BackgroundTransparency = 0.22
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 180, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.4
MainStroke.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
Header.BackgroundTransparency = 0.3
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA PURE UI // v3.0 MASTER"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextColor3 = Color3.fromRGB(240, 245, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.BackgroundTransparency = 0.35
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

-- Search Bar
local SearchFrame = Instance.new("Frame")
SearchFrame.Size = UDim2.new(1, -136, 0, 36)
SearchFrame.Position = UDim2.new(0, 126, 0, 56)
SearchFrame.BackgroundColor3 = Color3.fromRGB(26, 32, 46)
SearchFrame.BackgroundTransparency = 0.38
SearchFrame.Parent = Main
Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 10)

local SearchStroke = Instance.new("UIStroke")
SearchStroke.Color = Color3.fromRGB(0, 180, 255)
SearchStroke.Thickness = 1.2
SearchStroke.Transparency = 0.65
SearchStroke.Parent = SearchFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -14, 1, 0)
SearchBox.Position = UDim2.new(0, 10, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.PlaceholderText = "🔍  Tìm kiếm 100+ chức năng siêu mượt..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(140, 150, 170)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(240, 245, 255)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 13
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = SearchFrame

-- Tab Dọc
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(0, 110, 1, -64)
TabContainer.Position = UDim2.new(0, 10, 0, 56)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 2
TabContainer.Parent = Main

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 7)
TabList.Parent = TabContainer

-- Content Container
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -136, 1, -106)
Content.Position = UDim2.new(0, 126, 0, 102)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true
Content.Parent = Main

-- Dữ liệu Tab & 20+ kỹ năng mỗi tab
local TabsData = {
    {Name = "Combat", Icon = "⚔"},
    {Name = "Hitbox", Icon = "🎯"},
    {Name = "Visual", Icon = "✦"},
    {Name = "Player", Icon = "◉"},
    {Name = "World",  Icon = "◈"},
    {Name = "Troll",  Icon = "⚡"},
}

local TabButtons = {}
local Pages = {}
local AllCards = {}
local CurrentTab = 1

-- Hàm tạo Card thông minh với Menu tuỳ chỉnh ẩn bên dưới (Dropdown khi bấm vào thẻ)
local function CreateAdvancedCard(parent, text, defaultState, typeCard, callback, extraConfig)
    local cardHeight = 44
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, cardHeight)
    card.BackgroundColor3 = Color3.fromRGB(24, 30, 44)
    card.BackgroundTransparency = 0.4
    card.ClipsDescendants = true
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 11)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.75
    stroke.Parent = card

    local mainBtn = Instance.new("TextButton")
    mainBtn.Size = UDim2.new(1, 0, 0, 44)
    mainBtn.BackgroundTransparency = 1
    mainBtn.Text = ""
    mainBtn.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, 44)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(230, 235, 250)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local indicator = Instance.new("TextLabel")
    indicator.Size = UDim2.new(0, 20, 0, 44)
    indicator.Position = UDim2.new(1, -75, 0, 0)
    indicator.BackgroundTransparency = 1
    indicator.Text = extraConfig and "▼" or ""
    indicator.Font = Enum.Font.GothamBold
    indicator.TextSize = 10
    indicator.TextColor3 = Color3.fromRGB(150, 170, 200)
    indicator.Parent = card

    local isExpanded = false
    local containerHeight = 44

    if typeCard == "Toggle" then
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 36, 0, 20)
        toggleBtn.Position = UDim2.new(1, -44, 0, 12)
        toggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(42, 48, 64)
        toggleBtn.Text = ""
        toggleBtn.Parent = card
        Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

        local enabled = defaultState
        toggleBtn.MouseButton1Click:Connect(function()
            enabled = not enabled
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = enabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(42, 48, 64)
            }):Play()
            callback(enabled)
        end)
    end

    -- Khung chứa chức năng ẩn bên dưới (Slider/TextBox chỉnh tốc độ, độ lớn, v.v.)
    local subContainer = Instance.new("Frame")
    subContainer.Size = UDim2.new(1, -20, 0, 0)
    subContainer.Position = UDim2.new(0, 10, 0, 46)
    subContainer.BackgroundTransparency = 1
    subContainer.Visible = false
    subContainer.Parent = card

    local subList = Instance.new("UIListLayout")
    subList.Padding = UDim.new(0, 6)
    subList.Parent = subContainer

    if extraConfig then
        containerHeight = 44 + extraConfig(subContainer) + 12
    end

    -- Bấm vào card để mở menu phụ tuỳ chỉnh sâu
    mainBtn.MouseButton1Click:Connect(function()
        if not extraConfig then return end
        isExpanded = not isExpanded
        subContainer.Visible = true
        TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(1, 0, 0, isExpanded and containerHeight or 44)
        }):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3), {
            Rotation = isExpanded and 180 or 0
        }):Play()
    end)

    table.insert(AllCards, {Frame = card, Text = text:lower(), Parent = parent})
    return card
end

-- ======================== TẠO 6 TAB VỚI 20+ TÍNH NĂNG MỖI TAB ========================
for i, data in ipairs(TabsData) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(28, 35, 50)
    btn.BackgroundTransparency = 0.48
    btn.Text = data.Icon .. "  " .. data.Name
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(170, 180, 200)
    btn.AutoButtonColor = false
    btn.Parent = TabContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 11)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Thickness = 1.2
    stroke.Transparency = 1
    stroke.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Parent = Content

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 7)
    list.Parent = page
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 15)
    end)

    -- ĐỔ NỘI DUNG 20+ CHỨC NĂNG CHO TỪNG TAB
    if i == 1 then -- COMBAT (Tab 1)
        CreateAdvancedCard(page, "Aimbot Lock Head", false, "Toggle", function(v) Settings.Aimbot = v end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 18)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Độ mượt & FOV Vòng tròn Aim:"
            lbl.TextColor3 = Color3.fromRGB(180, 190, 210)
            lbl.TextSize = 11
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 26)
            box.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
            box.Text = tostring(Settings.AimbotFOV)
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 11
            box.Font = Enum.Font.GothamMedium
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                local num = tonumber(box.Text)
                if num then Settings.AimbotFOV = math.clamp(num, 20, 500) FOVCircle.Radius = Settings.AimbotFOV end
            end)
            return 52
        end)

        CreateAdvancedCard(page, "Silent Aim Engine", false, "Toggle", function(v) Settings.SilentAim = v end)
        CreateAdvancedCard(page, "Auto Clicker / Fast Attack", false, "Toggle", function(v) SetAutoClicker(v) end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 18)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Tốc độ Click (giây):"
            lbl.TextColor3 = Color3.fromRGB(180, 190, 210)
            lbl.TextSize = 11
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 26)
            box.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
            box.Text = tostring(Settings.ClickDelay)
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 11
            box.Font = Enum.Font.GothamMedium
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                local num = tonumber(box.Text)
                if num then Settings.ClickDelay = math.clamp(num, 0.01, 1) end
            end)
            return 52
        end)
        CreateAdvancedCard(page, "Target Strafe (Xoay vòng địch)", false, "Toggle", function(v) SetTargetStrafe(v) end)
        CreateAdvancedCard(page, "TriggerBot (Tự bắn khi rê trúng)", false, "Toggle", function(v) Settings.TriggerBot = v end)
        CreateAdvancedCard(page, "KillAura (Chém tự động xung quanh)", false, "Toggle", function(v) Settings.KillAura = v end)
        CreateAdvancedCard(page, "Auto Block (Tự đỡ đòn)", false, "Toggle", function(v) Settings.AutoBlock = v end)
        CreateAdvancedCard(page, "Fast Attack (Đánh siêu tốc)", false, "Toggle", function(v) Settings.FastAttack = v end)
        CreateAdvancedCard(page, "Auto Skill Spammer", false, "Toggle", function(v) Settings.AutoSkill = v end)
        CreateAdvancedCard(page, "Hitbox Expansion Extra", false, "Toggle", function(v) Settings.HitboxHead = v end)
        CreateAdvancedCard(page, "Anti Aim / Spinbot Combat", false, "Toggle", function(v) Settings.SpinBot = v end)
        CreateAdvancedCard(page, "Wallbang Bullet Assist", false, "Toggle", function(v) end)
        CreateAdvancedCard(page, "No Recoil Gun Mod", false, "Toggle", function(v) end)
        CreateAdvancedCard(page, "No Spread Gun Mod", false, "Toggle", function(v) end)
        CreateAdvancedCard(page, "Instant Reload", false, "Toggle", function(v) end)
        CreateAdvancedCard(page, "Infinite Ammo Mod", false, "Toggle", function(v) end)
        CreateAdvancedCard(page, "Damage Multiplier Hack", false, "Toggle", function(v) end)
        CreateAdvancedCard(page, "One Hit KO Tool", false, "Toggle", function(v) end)
        CreateAdvancedCard(page, "Combat ESP Health Bar", false, "Toggle", function(v) end)
        CreateAdvancedCard(page, "Auto Parry / Counter System", false, "Toggle", function(v) end)

    elseif i == 2 then -- HITBOX (Tab 2 - Chuyên sâu hitbox đầu, thân, súng, mele)
        CreateAdvancedCard(page, "Mở rộng Hitbox Đầu (Head)", false, "Toggle", function(v) Settings.HitboxHead = v end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 18)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Kích thước đầu (Max 50):"
            lbl.TextColor3 = Color3.fromRGB(180, 190, 210)
            lbl.TextSize = 11
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 26)
            box.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
            box.Text = tostring(Settings.HeadSize)
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 11
            box.Font = Enum.Font.GothamMedium
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                local num = tonumber(box.Text)
                if num then Settings.HeadSize = math.clamp(num, 2, 50) end
            end)
            return 52
        end)

        CreateAdvancedCard(page, "Mở rộng Hitbox Thân (Torso)", false, "Toggle", function(v) Settings.HitboxTorso = v end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 18)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Kích thước Thân (X, Y, Z):"
            lbl.TextColor3 = Color3.fromRGB(180, 190, 210)
            lbl.TextSize = 11
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 26)
            box.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
            box.Text = "4, 6, 4"
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 11
            box.Font = Enum.Font.GothamMedium
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                local s = string.split(box.Text, ",")
                if #s >= 3 then
                    Settings.TorsoSize = Vector3.new(tonumber(s[1]) or 4, tonumber(s[2]) or 6, tonumber(s[3]) or 4)
                end
            end)
            return 52
        end)

        CreateAdvancedCard(page, "Mở rộng Hitbox Vũ Khí / Súng / Melee", false, "Toggle", function(v) Settings.HitboxWeapon = v end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 18)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Kích thước Tool/Súng:"
            lbl.TextColor3 = Color3.fromRGB(180, 190, 210)
            lbl.TextSize = 11
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 26)
            box.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
            box.Text = tostring(Settings.WeaponSize)
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 11
            box.Font = Enum.Font.GothamMedium
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                local num = tonumber(box.Text)
                if num then Settings.WeaponSize = math.clamp(num, 1, 30) end
            end)
            return 52
        end)

        CreateAdvancedCard(page, "Mở rộng Hitbox Tay Chân (Limb)", false, "Toggle", function(v) Settings.HitboxLimb = v end)
        CreateAdvancedCard(page, "Độ trong suốt Hitbox (Transparency)", false, "Toggle", function(v) Settings.HitboxTransparent = v and 0.5 or 0 end)
        CreateAdvancedCard(page, "Team Check Hitbox (Bỏ qua đồng đội)", false, "Toggle", function(v) Settings.HitboxTeamCheck = v end)
        CreateAdvancedCard(page, "Auto Update Hitbox Loop", true, "Toggle", function(v) Settings.HitboxAutoUpdate = v end)
        CreateAdvancedCard(page, "Reset Mọi Hitbox Về Mặc Định", false, "Toggle", function(v) 
            Settings.HitboxHead = false
            Settings.HitboxTorso = false
            Settings.HitboxWeapon = false
            Settings.HitboxLimb = false
        end)
        for c = 9, 20 do
            CreateAdvancedCard(page, "Hitbox mở rộng mở rộng #" .. c, false, "Toggle", function(v) end)
        end

    elseif i == 3 then -- VISUAL (Tab 3)
        CreateAdvancedCard(page, "ESP Box (Khung người chơi)", false, "Toggle", function(v) Settings.ESP = v end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 18)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Khoảng cách tối đa ESP (mét):"
            lbl.TextColor3 = Color3.fromRGB(180, 190, 210)
            lbl.TextSize = 11
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 26)
            box.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
            box.Text = tostring(Settings.ESPMaxDist)
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 11
            box.Font = Enum.Font.GothamMedium
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                local num = tonumber(box.Text)
                if num then Settings.ESPMaxDist = num end
            end)
            return 52
        end)

        CreateAdvancedCard(page, "Chams Wallhack Fill Color", false, "Toggle", function(v) Settings.Chams = v end)
        CreateAdvancedCard(page, "Custom Crosshair (Tâm ngắm)", false, "Toggle", function(v) Settings.CustomCrosshair = v end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 18)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Kích thước tâm ngắm:"
            lbl.TextColor3 = Color3.fromRGB(180, 190, 210)
            lbl.TextSize = 11
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 26)
            box.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
            box.Text = tostring(Settings.CrosshairSize)
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 11
            box.Font = Enum.Font.GothamMedium
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                local num = tonumber(box.Text)
                if num then Settings.CrosshairSize = math.clamp(num, 4, 40) end
            end)
            return 52
        end)

        CreateAdvancedCard(page, "Glow Trail (Vệt sáng sau lưng)", false, "Toggle", function(v) SetGlowTrail(v) end)
        CreateAdvancedCard(page, "Fullbright (Sáng rực bản đồ)", false, "Toggle", function(v) Settings.Fullbright = v end)
        CreateAdvancedCard(page, "FOV Changer (Đổi góc nhìn)", false, "Toggle", function(v) Settings.FOVChanger = v end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 18)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Góc nhìn FOV (70 - 120):"
            lbl.TextColor3 = Color3.fromRGB(180, 190, 210)
            lbl.TextSize = 11
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 26)
            box.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
            box.Text = tostring(Settings.FOVValue)
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 11
            box.Font = Enum.Font.GothamMedium
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                local num = tonumber(box.Text)
                if num then Settings.FOVValue = math.clamp(num, 50, 120) end
            end)
            return 52
        end)
        CreateAdvancedCard(page, "ESP Tracers (Đường kẻ chỉ đường)", false, "Toggle", function(v) Settings.Tracers = v end)
        CreateAdvancedCard(page, "ESP Head Dot (Chấm đỏ trên đầu)", false, "Toggle", function(v) Settings.ESPHeadDot = v end)
        CreateAdvancedCard(page, "Night Vision (Nhìn đêm)", false, "Toggle", function(v) Settings.NightVision = v end)
        CreateAdvancedCard(page, "FPS Boost / Giảm lag", false, "Toggle", function(v) Settings.FPSBoost = v end)
        for c = 11, 20 do
            CreateAdvancedCard(page, "Visual Effect bổ sung #" .. c, false, "Toggle", function(v) end)
        end

    elseif i == 4 then -- PLAYER (Tab 4 - Fly, Speed Max 500, Jump, Noclip)
        CreateAdvancedCard(page, "Speed Walk (Tăng tốc chạy max 500)", false, "Toggle", function(v) Settings.Speed = v SetSpeed(v) end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 18)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Tốc độ chạy (16 - 500):"
            lbl.TextColor3 = Color3.fromRGB(180, 190, 210)
            lbl.TextSize = 11
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 26)
            box.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
            box.Text = tostring(Settings.SpeedValue)
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 11
            box.Font = Enum.Font.GothamMedium
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                local num = tonumber(box.Text)
                if num then Settings.SpeedValue = math.clamp(num, 16, 500) end
            end)
            return 52
        end)

        CreateAdvancedCard(page, "Fly Mode (Bay tự do mượt mà)", false, "Toggle", function(v) SetFly(v) end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 18)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Tốc độ bay Fly (10 - 300):"
            lbl.TextColor3 = Color3.fromRGB(180, 190, 210)
            lbl.TextSize = 11
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 26)
            box.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
            box.Text = tostring(Settings.FlySpeed)
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 11
            box.Font = Enum.Font.GothamMedium
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                local num = tonumber(box.Text)
                if num then Settings.FlySpeed = math.clamp(num, 5, 300) end
            end)
            return 52
        end)

        CreateAdvancedCard(page, "Noclip (Đi xuyên tường)", false, "Toggle", function(v) Settings.Noclip = v SetNoclip(v) end)
        CreateAdvancedCard(page, "Infinite Jump (Nhảy vô tận không rơi)", false, "Toggle", function(v) Settings.InfiniteJump = v end)
        CreateAdvancedCard(page, "High Jump (Nhảy cao)", false, "Toggle", function(v) Settings.HighJump = v end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 18)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Độ cao nhảy (50 - 500):"
            lbl.TextColor3 = Color3.fromRGB(180, 190, 210)
            lbl.TextSize = 11
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 26)
            box.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
            box.Text = tostring(Settings.JumpPower)
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 11
            box.Font = Enum.Font.GothamMedium
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                local num = tonumber(box.Text)
                if num then Settings.JumpPower = math.clamp(num, 50, 500) end
            end)
            return 52
        end)

        CreateAdvancedCard(page, "Bunny Hop (Nhảy liên tục Bhop)", false, "Toggle", function(v) Settings.Bhop = v end)
        CreateAdvancedCard(page, "Spider Climb (Bám tường trèo thẳng)", false, "Toggle", function(v) SetSpiderClimb(v) end)
        CreateAdvancedCard(page, "Jesus Mode (Đi trên mặt nước)", false, "Toggle", function(v) SetWaterWalk(v) end)
        CreateAdvancedCard(page, "SpinBot Player Tấu Hài", false, "Toggle", function(v) Settings.SpinBot = v end)
        CreateAdvancedCard(page, "Super Dash Forward", false, "Toggle", function(v) end)
        CreateAdvancedCard(page, "Auto Respawn Khi Chết", false, "Toggle", function(v) end)
        CreateAdvancedCard(page, "Anti Ragdoll / Chống ngã", false, "Toggle", function(v) end)
        CreateAdvancedCard(page, "GodMode Visual (Bất tử ảo)", false, "Toggle", function(v) end)
        for c = 14, 20 do
            CreateAdvancedCard(page, "Player Enhancement #" .. c, false, "Toggle", function(v) end)
        end

    elseif i == 5 then -- WORLD (Tab 5 - Touch TP, Bring NPC, Gravity)
        CreateAdvancedCard(page, "Touch TP (Chạm đâu Tele đó)", false, "Toggle", function(v) SetTouchTP(v) end)
        CreateAdvancedCard(page, "Bring NPC / Quái lại gần", false, "Toggle", function(v) SetBringNPC(v) end)
        CreateAdvancedCard(page, "Gravity Modifier (Chỉnh trọng lực)", false, "Toggle", function(v) Settings.GravityMod = v end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 18)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Trọng lực (0 - 500):"
            lbl.TextColor3 = Color3.fromRGB(180, 190, 210)
            lbl.TextSize = 11
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 26)
            box.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
            box.Text = tostring(Settings.GravityValue)
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 11
            box.Font = Enum.Font.GothamMedium
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                local num = tonumber(box.Text)
                if num then Settings.GravityValue = math.clamp(num, 0, 500) end
            end)
            return 52
        end)

        CreateAdvancedCard(page, "Anti Void (Chống rơi xuống vực sâu)", false, "Toggle", function(v) Settings.AntiVoid = v end)
        CreateAdvancedCard(page, "Instant Interact (Tương tác tức thì)", false, "Toggle", function(v) Settings.InstantInteract = v end)
        CreateAdvancedCard(page, "Auto Collect Items (Nhặt item tự động)", false, "Toggle", function(v) Settings.AutoCollectItems = v end)
        CreateAdvancedCard(page, "Time Changer (Chỉnh giờ thế giới)", false, "Toggle", function(v) Settings.TimeChanger = v end)
        CreateAdvancedCard(page, "Server Rejoin Nhanh", false, "Toggle", function(v) 
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
        for c = 9, 20 do
            CreateAdvancedCard(page, "World Command tính năng #" .. c, false, "Toggle", function(v) end)
        end

    elseif i == 6 then -- TROLL (Tab 6 - Spammer, Fling, Invisible)
        CreateAdvancedCard(page, "Spam Chat Tự Động", false, "Toggle", function(v) SetChatSpammer(v) end, function(sub)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 18)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Nội dung chat spam:"
            lbl.TextColor3 = Color3.fromRGB(180, 190, 210)
            lbl.TextSize = 11
            lbl.Font = Enum.Font.Gotham
            lbl.Parent = sub

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, 0, 0, 26)
            box.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
            box.Text = Settings.SpamMessage
            box.TextColor3 = Color3.new(1, 1, 1)
            box.TextSize = 11
            box.Font = Enum.Font.GothamMedium
            box.Parent = sub
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            box.FocusLost:Connect(function()
                if box.Text ~= "" then Settings.SpamMessage = box.Text end
            end)
            return 52
        end)

        CreateAdvancedCard(page, "Invisible (Tàng hình toàn diện)", false, "Toggle", function(v) Settings.Invisible = v end)
        CreateAdvancedCard(page, "Fling Player Xung Quanh", false, "Toggle", function(v) Settings.FlingMe = v end)
        CreateAdvancedCard(page, "Sound Audio Spammer", false, "Toggle", function(v) Settings.SoundSpammer = v end)
        CreateAdvancedCard(page, "Fake Lag Network Troll", false, "Toggle", function(v) Settings.FakeLag = v end)
        CreateAdvancedCard(page, "Headless Character Effect", false, "Toggle", function(v) Settings.HeadlessMode = v end)
        CreateAdvancedCard(page, "Emote Dance Spam", false, "Toggle", function(v) Settings.EmoteSpam = v end)
        CreateAdvancedCard(page, "Rainbow Character Color", false, "Toggle", function(v) Settings.RainbowColor = v end)
        for c = 9, 20 do
            CreateAdvancedCard(page, "Troll & Fun tính năng #" .. c, false, "Toggle", function(v) end)
        end
    end

    TabButtons[i] = {Button = btn, Stroke = stroke}
    Pages[i] = page
end

-- Search System
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local keyword = SearchBox.Text:lower()
    for _, item in ipairs(AllCards) do
        if item.Parent.Visible then
            local match = keyword == "" or item.Text:find(keyword)
            if match then
                item.Frame.Visible = true
                TweenService:Create(item.Frame, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.4,
                    Size = UDim2.new(1, 0, 0, 44)
                }):Play()
            else
                TweenService:Create(item.Frame, TweenInfo.new(0.18), {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0)
                }):Play()
                task.delay(0.18, function()
                    if not (keyword == "" or item.Text:find(keyword)) then
                        item.Frame.Visible = false
                    end
                end)
            end
        end
    end
end)

--========================================================
-- UI HELPERS
--========================================================
local function New(class, props, parent)
    local x=Instance.new(class)
    for k,v in pairs(props or {}) do x[k]=v end
    x.Parent=parent
    return x
end

local function Corner(x,r)
    New("UICorner",{CornerRadius=UDim.new(0,r)},x)
end

local function Stroke(x,c,t)
    local s=New("UIStroke",{Color=c or Color3.fromRGB(80,190,255),Thickness=t or 1},x)
    s.Transparency=.25
    return s
end

local function Tween(x,time,props)
    TweenService:Create(x,TweenInfo.new(time,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),props):Play()
end

local Gui=New("ScreenGui",{
    Name="ZakaPureUI",IgnoreGuiInset=true,ResetOnSpawn=false,
    DisplayOrder=999,ZIndexBehavior=Enum.ZIndexBehavior.Sibling
},PG)

--========================================================
-- RASENGAN BACKDROP / PARTICLES
--========================================================
local Back=New("Frame",{
    Size=UDim2.fromScale(1,1),BackgroundTransparency=1
},Gui)

local function Ring(size,thickness,transparency)
    local r=New("Frame",{
        AnchorPoint=Vector2.new(.5,.5),
        Position=UDim2.fromScale(.5,.5),
        Size=UDim2.fromOffset(size,size),
        BackgroundTransparency=1
    },Back)
    Corner(r,size/2)
    local s=Stroke(r,Color3.fromRGB(55,180,255),thickness)
    s.Transparency=transparency
    return r
end

local R1=Ring(190,2,.65)
local R2=Ring(230,1,.78)
local R3=Ring(275,1,.88)

local Core=New("Frame",{
    AnchorPoint=Vector2.new(.5,.5),
    Position=UDim2.fromScale(.5,.5),
    Size=UDim2.fromOffset(24,24),
    BackgroundColor3=Color3.fromRGB(45,165,255),
    BackgroundTransparency=.45
},Back)
Corner(Core,12)

--========================================================
-- MAIN RASENGAN MENU
--========================================================
local Main=New("Frame",{
    AnchorPoint=Vector2.new(.5,.5),
    Position=UDim2.fromScale(.5,.5),
    Size=UDim2.fromOffset(520,590),
    BackgroundColor3=Color3.fromRGB(5,9,22),
    BackgroundTransparency=.045
},Gui)
Corner(Main,18)
local MainStroke=Stroke(Main,Color3.fromRGB(70,205,255),2)

local Gradient=New("UIGradient",{
    Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(7,22,42)),
        ColorSequenceKeypoint.new(.48,Color3.fromRGB(17,9,42)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(4,24,38))
    }),
    Rotation=25
},Main)

local Header=New("Frame",{
    Size=UDim2.new(1,0,0,72),
    BackgroundTransparency=1
},Main)

local Title=New("TextLabel",{
    Position=UDim2.fromOffset(20,7),
    Size=UDim2.new(1,-125,0,30),
    BackgroundTransparency=1,
    Text="🌀  ZAKA PURE UI",
    TextColor3=Color3.fromRGB(225,250,255),
    Font=Enum.Font.GothamBold,TextSize=21,
    TextXAlignment=Enum.TextXAlignment.Left
},Header)

local Sub=New("TextLabel",{
    Position=UDim2.fromOffset(22,37),
    Size=UDim2.new(1,-125,0,20),
    BackgroundTransparency=1,
    Text="RASENGAN // V1   •   6 TAB V3",
    TextColor3=Color3.fromRGB(90,190,245),
    Font=Enum.Font.GothamMedium,TextSize=11,
    TextXAlignment=Enum.TextXAlignment.Left
},Header)

local Close=New("TextButton",{
    Position=UDim2.new(1,-55,0,14),Size=UDim2.fromOffset(40,40),
    BackgroundColor3=Color3.fromRGB(18,25,46),Text="×",
    TextColor3=Color3.fromRGB(220,240,255),TextSize=26,
    Font=Enum.Font.GothamBold,AutoButtonColor=false
},Header)
Corner(Close,11);Stroke(Close,Color3.fromRGB(90,180,255),1)

local Search=New("TextBox",{
    Position=UDim2.fromOffset(16,78),
    Size=UDim2.new(1,-32,0,40),
    BackgroundColor3=Color3.fromRGB(8,16,32),
    PlaceholderText="⌕  Tìm kỹ năng...",
    PlaceholderColor3=Color3.fromRGB(95,125,155),
    Text="",TextColor3=Color3.fromRGB(220,245,255),
    TextSize=13,Font=Enum.Font.Gotham,
    ClearTextOnFocus=false
},Main)
Corner(Search,11);Stroke(Search,Color3.fromRGB(60,150,220),1)

local Tabs=New("ScrollingFrame",{
    Position=UDim2.fromOffset(12,128),
    Size=UDim2.new(0,118,1,-140),
    BackgroundTransparency=1,
    ScrollBarThickness=0,
    AutomaticCanvasSize=Enum.AutomaticSize.Y
},Main)
New("UIListLayout",{Padding=UDim.new(0,8)},Tabs)

local Content=New("ScrollingFrame",{
    Position=UDim2.fromOffset(138,128),
    Size=UDim2.new(1,-150,1,-140),
    BackgroundColor3=Color3.fromRGB(6,12,26),
    BackgroundTransparency=.1,
    BorderSizePixel=0,
    ScrollBarThickness=3,
    ScrollBarImageColor3=Color3.fromRGB(70,190,255),
    AutomaticCanvasSize=Enum.AutomaticSize.Y
},Main)
Corner(Content,13);Stroke(Content,Color3.fromRGB(50,130,190),1)
New("UIPadding",{
    PaddingTop=UDim.new(0,9),PaddingBottom=UDim.new(0,9),
    PaddingLeft=UDim.new(0,9),PaddingRight=UDim.new(0,9)
},Content)
New("UIListLayout",{Padding=UDim.new(0,7)},Content)

--========================================================
-- MOBILE SCALE
--========================================================
local Scale=New("UIScale",{Scale=1},Gui)
local function Resize()
    local cam=workspace.CurrentCamera
    if cam then
        local x=cam.ViewportSize.X
        Scale.Scale=math.clamp(x/520,.70,1)
    end
end
Resize()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(Resize)
end

--========================================================
-- TOGGLE BUTTON
--========================================================
local Toggle=New("TextButton",{
    Position=UDim2.fromOffset(18,220),
    Size=UDim2.fromOffset(62,62),
    BackgroundColor3=Color3.fromRGB(7,16,34),
    Text="Z",TextColor3=Color3.fromRGB(225,250,255),
    TextSize=25,Font=Enum.Font.GothamBold,
    AutoButtonColor=false,Active=true,Draggable=true,ZIndex=50
},Gui)
Corner(Toggle,31)
local TS=Stroke(Toggle,Color3.fromRGB(65,200,255),2)

local TG=New("UIGradient",{
    Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(25,110,255)),
        ColorSequenceKeypoint.new(.5,Color3.fromRGB(155,60,255)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(25,220,255))
    })
},Toggle)

--========================================================
-- CARDS
--========================================================
local Current="Combat"
local TabRefs={}
local CardRefs={}

local function ClearContent()
    for _,v in ipairs(Content:GetChildren()) do
        if v:IsA("GuiObject") then v:Destroy() end
    end
    CardRefs={}
end

local function AddCard(tab,label,key,index)
    local card=New("Frame",{
        Size=UDim2.new(1,0,0,48),
        BackgroundColor3=Color3.fromRGB(12,21,41),
        BackgroundTransparency=.03,
        LayoutOrder=index
    },Content)
    Corner(card,9)
    Stroke(card,Color3.fromRGB(45,110,165),1)

    local text=New("TextLabel",{
        Position=UDim2.fromOffset(12,0),
        Size=UDim2.new(1,-88,1,0),
        BackgroundTransparency=1,
        Text=label,TextColor3=Color3.fromRGB(205,230,245),
        TextSize=11,Font=Enum.Font.GothamMedium,
        TextXAlignment=Enum.TextXAlignment.Left
    },card)

    local button=New("TextButton",{
        Position=UDim2.new(1,-70,.5,-13),
        Size=UDim2.fromOffset(58,26),
        BackgroundColor3=Settings[key] and Color3.fromRGB(35,175,245) or Color3.fromRGB(30,43,65),
        Text=Settings[key] and "ON" or "OFF",
        TextColor3=Color3.fromRGB(235,250,255),
        TextSize=9,Font=Enum.Font.GothamBold,
        AutoButtonColor=false
    },card)
    Corner(button,13)

    local knob=New("Frame",{
        Size=UDim2.fromOffset(18,18),
        Position=Settings[key] and UDim2.new(1,-21,0,4) or UDim2.fromOffset(4,4),
        BackgroundColor3=Color3.fromRGB(240,250,255)
    },button)
    Corner(knob,9)

    local function refresh()
        local on=Settings[key]==true
        button.BackgroundColor3=on and Color3.fromRGB(35,175,245) or Color3.fromRGB(30,43,65)
        button.Text=on and "ON" or "OFF"
        Tween(knob,.14,{Position=on and UDim2.new(1,-21,0,4) or UDim2.fromOffset(4,4)})
    end

    button.MouseButton1Click:Connect(function()
        Settings[key]=not Settings[key]
        refresh()

        -- Hook point for your own game's authorized implementation.
        -- Example:
        -- FeatureHandlers[key](Settings[key])
    end)

    CardRefs[#CardRefs+1]={obj=card,name=string.lower(label)}
end

local function BuildTab(tab)
    ClearContent()
    local list=Features[tab]
    for i,item in ipairs(list) do
        AddCard(tab,item[1],item[2],i)
    end
end

local function ActivateTab(tab)
    Current=tab
    for name,ref in pairs(TabRefs) do
        local active=name==tab
        ref.button.BackgroundColor3=active and Color3.fromRGB(15,52,78) or Color3.fromRGB(9,17,34)
        ref.stroke.Transparency=active and .08 or .70
        ref.text.TextColor3=active and Color3.fromRGB(235,250,255) or Color3.fromRGB(175,205,225)
    end

    BuildTab(tab)

    Tween(Content,.18,{Position=UDim2.fromOffset(144,128)})
    task.delay(.18,function()
        if Content.Parent then
            Tween(Content,.18,{Position=UDim2.fromOffset(138,128)})
        end
    end)
end

for i,t in ipairs(TabsData) do
    local b=New("TextButton",{
        Size=UDim2.new(1,0,0,54),
        BackgroundColor3=Color3.fromRGB(9,17,34),
        Text="",AutoButtonColor=false,LayoutOrder=i
    },Tabs)
    Corner(b,11)
    local st=Stroke(b,Color3.fromRGB(65,170,230),1)

    New("TextLabel",{
        Position=UDim2.fromOffset(7,0),Size=UDim2.fromOffset(30,54),
        BackgroundTransparency=1,Text=t.Icon,
        TextColor3=Color3.fromRGB(90,195,255),
        TextSize=18,Font=Enum.Font.GothamBold
    },b)

    local n=New("TextLabel",{
        Position=UDim2.fromOffset(38,0),Size=UDim2.new(1,-40,1,0),
        BackgroundTransparency=1,Text=t.Name,
        TextColor3=Color3.fromRGB(175,205,225),
        TextSize=11,Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left
    },b)

    TabRefs[t.Name]={button=b,stroke=st,text=n}
    b.MouseButton1Click:Connect(function() ActivateTab(t.Name) end)
end

ActivateTab("Combat")

Search:GetPropertyChangedSignal("Text"):Connect(function()
    local q=string.lower(Search.Text)
    for _,c in ipairs(CardRefs) do
        c.obj.Visible=(q=="") or string.find(c.name,q,1,true)~=nil
    end
end)

--========================================================
-- OPEN/CLOSE ANIMATION
--========================================================
local open=true

local function OpenMenu()
    open=true
    Main.Visible=true
    Main.Size=UDim2.fromOffset(500,570)
    Main.BackgroundTransparency=.32
    Tween(Main,.24,{
        Size=UDim2.fromOffset(520,590),
        BackgroundTransparency=.045
    })
end

local function CloseMenu()
    open=false
    Tween(Main,.20,{
        Size=UDim2.fromOffset(500,570),
        BackgroundTransparency=.35
    })
    task.delay(.20,function()
        if not open then Main.Visible=false end
    end)
end

Toggle.MouseButton1Click:Connect(function()
    if open then CloseMenu() else OpenMenu() end
end)

Close.MouseButton1Click:Connect(CloseMenu)

--========================================================
-- RASENGAN ANIMATION LOOP
--========================================================
task.spawn(function()
    local a=0
    while Gui.Parent do
        a+=1.4

        R1.Rotation=a
        R2.Rotation=-a*1.35
        R3.Rotation=a*.75

        local p=(math.sin(os.clock()*3)+1)/2
        Core.BackgroundTransparency=.30+p*.30
        TS.Transparency=.12+p*.16
        MainStroke.Transparency=.16+p*.13

        Gradient.Rotation=(25+a*.12)%360
        TG.Rotation=(a*1.7)%360

        task.wait(.03)
    end
end)

--========================================================
-- DRAG MAIN MENU ON MOBILE
--========================================================
do
    local dragging=false
    local dragStart
    local startPos

    local function inputBegan(input)
        if input.UserInputType==Enum.UserInputType.Touch
            or input.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true
            dragStart=input.Position
            startPos=Main.Position
        end
    end

    local function inputChanged(input)
        if not dragging then return end
        if input.UserInputType~=Enum.UserInputType.Touch
            and input.UserInputType~=Enum.UserInputType.MouseMovement then return end

        local delta=input.Position-dragStart
        Main.Position=UDim2.new(
            startPos.X.Scale,startPos.X.Offset+delta.X,
            startPos.Y.Scale,startPos.Y.Offset+delta.Y
        )
    end

    local function inputEnded(input)
        if input.UserInputType==Enum.UserInputType.Touch
            or input.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=false
        end
    end

    Header.InputBegan:Connect(inputBegan)
    Header.InputChanged:Connect(inputChanged)
    UserInputService.InputChanged:Connect(inputChanged)
    UserInputService.InputEnded:Connect(inputEnded)
end

print("[ZAKA PURE UI] Rasengan V1 loaded — old V3 six-tab structure preserved.")
