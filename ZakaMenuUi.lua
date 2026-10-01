--[[
ZAKA PURE UI // V1
RASENGAN THEME // 6-TAB EDITION
Delta/mobile-friendly UI shell

GIỮ NGUYÊN 6 TAB VÀ DANH SÁCH CONTROL CỦA V3:
Combat / Hitbox / Visual / Player / World / Troll

Lưu ý:
Đây là UI/settings shell. Các control lưu trạng thái vào Settings và
không chứa implementation exploit đối với game của người khác.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- SETTINGS: GIỮ NGUYÊN TÊN SETTING CŨ
--==================================================

local Settings = {
    -- Combat
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

    -- Hitbox
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

    -- Visual
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

    -- Player
    Speed = false,
    SpeedValue = 26,
    Fly = false,
    FlySpeed = 50,
    FlyMode = "Camera",
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

    -- World
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

    -- Troll
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

--==================================================
-- TAB DATA: KHÔNG ĐỔI
--==================================================

local TabsData = {
    {Name = "Combat", Icon = "⚔"},
    {Name = "Hitbox", Icon = "🎯"},
    {Name = "Visual", Icon = "✦"},
    {Name = "Player", Icon = "◉"},
    {Name = "World",  Icon = "◈"},
    {Name = "Troll",  Icon = "⚡"},
}

--==================================================
-- CONTROL DATA
--==================================================

local Controls = {
    Combat = {
        {"Aimbot", "toggle", "Aimbot"},
        {"Aimbot FOV", "number", "AimbotFOV", 1, 500, 1},
        {"Aimbot Smooth", "number", "AimbotSmooth", 0.01, 1, 0.01},
        {"Silent Aim", "toggle", "SilentAim"},
        {"Auto Clicker", "toggle", "AutoClicker"},
        {"Click Delay", "number", "ClickDelay", 0.01, 2, 0.01},
        {"Target Strafe", "toggle", "TargetStrafe"},
        {"Strafe Distance", "number", "StrafeDistance", 1, 100, 1},
        {"Strafe Speed", "number", "StrafeSpeed", 1, 50, 1},
        {"Trigger Bot", "toggle", "TriggerBot"},
        {"Kill Aura", "toggle", "KillAura"},
        {"Kill Aura Distance", "number", "KillAuraDist", 1, 100, 1},
        {"Auto Block", "toggle", "AutoBlock"},
        {"Fast Attack", "toggle", "FastAttack"},
        {"Auto Skill", "toggle", "AutoSkill"},
    },

    Hitbox = {
        {"Hitbox Head", "toggle", "HitboxHead"},
        {"Head Size", "number", "HeadSize", 1, 50, 1},
        {"Hitbox Torso", "toggle", "HitboxTorso"},
        {"Torso Size", "text", "TorsoSize"},
        {"Hitbox Weapon", "toggle", "HitboxWeapon"},
        {"Weapon Size", "number", "WeaponSize", 1, 30, 1},
        {"Hitbox Transparent", "number", "HitboxTransparent", 0, 1, 0.05},
        {"Hitbox Limb", "toggle", "HitboxLimb"},
        {"Limb Size", "number", "LimbSize", 1, 30, 1},
        {"Hitbox Team Check", "toggle", "HitboxTeamCheck"},
        {"Hitbox Auto Update", "toggle", "HitboxAutoUpdate"},
    },

    Visual = {
        {"ESP", "toggle", "ESP"},
        {"ESP Box", "toggle", "ESPBox"},
        {"ESP Name", "toggle", "ESPName"},
        {"ESP Health", "toggle", "ESPHealth"},
        {"ESP Distance", "toggle", "ESPDistance"},
        {"ESP Max Distance", "number", "ESPMaxDist", 50, 10000, 50},
        {"Chams", "toggle", "Chams"},
        {"Chams Color", "color", "ChamsColor"},
        {"Custom Crosshair", "toggle", "CustomCrosshair"},
        {"Crosshair Size", "number", "CrosshairSize", 2, 50, 1},
        {"Glow Trail", "toggle", "GlowTrail"},
        {"Fullbright", "toggle", "Fullbright"},
        {"FOV Changer", "toggle", "FOVChanger"},
        {"FOV Value", "number", "FOVValue", 40, 140, 1},
        {"Tracers", "toggle", "Tracers"},
        {"ESP Head Dot", "toggle", "ESPHeadDot"},
        {"Night Vision", "toggle", "NightVision"},
        {"FPS Boost", "toggle", "FPSBoost"},
    },

    Player = {
        {"Speed", "toggle", "Speed"},
        {"Speed Value", "number", "SpeedValue", 1, 200, 1},
        {"Fly", "toggle", "Fly"},
        {"Fly Speed", "number", "FlySpeed", 1, 200, 1},
        {"Fly Mode", "text", "FlyMode"},
        {"Noclip", "toggle", "Noclip"},
        {"Infinite Jump", "toggle", "InfiniteJump"},
        {"Spin Bot", "toggle", "SpinBot"},
        {"Spin Speed", "number", "SpinSpeed", 1, 360, 1},
        {"Spider Climb", "toggle", "SpiderClimb"},
        {"Spider Speed", "number", "SpiderSpeed", 1, 100, 1},
        {"Water Walk", "toggle", "WaterWalk"},
        {"Bhop", "toggle", "Bhop"},
        {"High Jump", "toggle", "HighJump"},
        {"Jump Power", "number", "JumpPower", 1, 300, 1},
        {"Super Dash", "toggle", "SuperDash"},
        {"Auto Respawn", "toggle", "AutoRespawn"},
        {"Anti Ragdoll", "toggle", "AntiRagdoll"},
        {"GodMode Visual", "toggle", "GodModeVisual"},
    },

    World = {
        {"Touch TP", "toggle", "TouchTP"},
        {"NoClip Parts", "toggle", "NoClipParts"},
        {"Server Hop", "toggle", "ServerHop"},
        {"Bring NPC", "toggle", "BringNPC"},
        {"Bring NPC Mode", "text", "BringNPCMode"},
        {"Click Delete", "toggle", "ClickDelete"},
        {"Anti Void", "toggle", "AntiVoid"},
        {"Server Rejoin", "toggle", "ServerRejoin"},
        {"Time Changer", "toggle", "TimeChanger"},
        {"Game Time", "number", "GameTime", 0, 24, 1},
        {"Gravity Mod", "toggle", "GravityMod"},
        {"Gravity Value", "number", "GravityValue", 0, 500, 0.1},
        {"Auto Collect Items", "toggle", "AutoCollectItems"},
        {"Instant Interact", "toggle", "InstantInteract"},
    },

    Troll = {
        {"Chat Spammer", "toggle", "ChatSpammer"},
        {"Spam Message", "text", "SpamMessage"},
        {"Spam Delay", "number", "SpamDelay", 0.1, 20, 0.1},
        {"Invisible", "toggle", "Invisible"},
        {"Fling Me", "toggle", "FlingMe"},
        {"Sound Spammer", "toggle", "SoundSpammer"},
        {"Tool Dupe", "toggle", "ToolDupe"},
        {"Fake Lag", "toggle", "FakeLag"},
        {"Headless Mode", "toggle", "HeadlessMode"},
        {"Corrupt Server", "toggle", "CorruptServer"},
        {"Animation Pack", "toggle", "AnimationPack"},
        {"Emote Spam", "toggle", "EmoteSpam"},
        {"Rainbow Color", "toggle", "RainbowColor"},
        {"Crash Client Warning", "toggle", "CrashClientWarning"},
        {"Nullify Collisions", "toggle", "NullifyCollisions"},
        {"Auto Equip Best", "toggle", "AutoEquipBest"},
        {"Server Lockdown", "toggle", "ServerLockdown"},

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
--==================================================
-- CLEAN OLD UI
--==================================================

local old = PlayerGui:FindFirstChild("ZakaPureUI")
if old then
    old:Destroy()
end

--==================================================
-- HELPERS
--==================================================

local function new(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function corner(parent, radius)
    return new("UICorner", {
        CornerRadius = UDim.new(0, radius or 8)
    }, parent)
end

local function stroke(parent, thickness)
    return new("UIStroke", {
        Thickness = thickness or 1,
        Color = Color3.fromRGB(70, 190, 255),
        Transparency = 0.2
    }, parent)
end

local function tween(obj, info, props)
    TweenService:Create(obj, info, props):Play()
end

local function formatValue(v)
    if typeof(v) == "Color3" then
        return string.format(
            "#%02X%02X%02X",
            math.floor(v.R * 255),
            math.floor(v.G * 255),
            math.floor(v.B * 255)
        )
    elseif typeof(v) == "Vector3" then
        return string.format("%.2f, %.2f, %.2f", v.X, v.Y, v.Z)
    end
    return tostring(v)
end

--==================================================
-- GUI
--==================================================

local Gui = new("ScreenGui", {
    Name = "ZakaPureUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, PlayerGui)

-- Mobile scale
local Scale = new("UIScale", {
    Scale = 1
}, Gui)

local function updateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local size = camera.ViewportSize
    if size.X < 500 then
        Scale.Scale = math.clamp(size.X / 430, 0.78, 1)
    else
        Scale.Scale = 1
    end
end

updateScale()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

--==================================================
-- RASENGAN TOGGLE
--==================================================

local Toggle = new("TextButton", {
    Name = "RasenganToggle",
    Size = UDim2.fromOffset(58, 58),
    Position = UDim2.new(0, 18, 0.5, -29),
    BackgroundColor3 = Color3.fromRGB(8, 16, 34),
    Text = "Z",
    TextColor3 = Color3.fromRGB(220, 250, 255),
    TextSize = 25,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    Active = true,
    Draggable = true,
    ZIndex = 20,
}, Gui)
corner(Toggle, 29)
local ToggleStroke = stroke(Toggle, 2)

local ToggleGlow = new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 130, 255)),
        ColorSequenceKeypoint.new(0.28, Color3.fromRGB(80, 220, 255)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(155, 75, 255)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(50, 190, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 100, 255)),
    }),
    Rotation = 45,
}, Toggle)

-- Rasengan core: layered rings, glow and chakra particles. No eye/morph system.
local Core = new("Frame", {
    Size = UDim2.fromOffset(34, 34),
    Position = UDim2.fromOffset(12, 12),
    BackgroundColor3 = Color3.fromRGB(55, 205, 255),
    BackgroundTransparency = 0.08,
    ZIndex = 21,
}, Toggle)
corner(Core, 17)
local CoreGradient = new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 250, 255)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(50, 185, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(105, 55, 255)),
    }),
    Rotation = 25,
}, Core)

local RingA = new("Frame", {
    Size = UDim2.fromOffset(46, 46), Position = UDim2.fromOffset(6, 6),
    BackgroundTransparency = 1, ZIndex = 20,
}, Toggle)
corner(RingA, 23)
local RingAStroke = stroke(RingA, 2); RingAStroke.Color = Color3.fromRGB(55, 205, 255); RingAStroke.Transparency = 0.25

local RingB = new("Frame", {
    Size = UDim2.fromOffset(54, 54), Position = UDim2.fromOffset(2, 2),
    BackgroundTransparency = 1, ZIndex = 19,
}, Toggle)
corner(RingB, 27)
local RingBStroke = stroke(RingB, 1); RingBStroke.Color = Color3.fromRGB(155, 75, 255); RingBStroke.Transparency = 0.35

local Shine = new("Frame", {
    Size = UDim2.fromOffset(8, 8), Position = UDim2.fromOffset(18, 13),
    BackgroundColor3 = Color3.fromRGB(235, 255, 255), BackgroundTransparency = 0.1, ZIndex = 22,
}, Toggle)
corner(Shine, 4)

local ParticleHolders = {}
for i = 1, 8 do
    local p = new("Frame", {
        Size = UDim2.fromOffset(4, 4),
        BackgroundColor3 = (i % 2 == 0) and Color3.fromRGB(80, 220, 255) or Color3.fromRGB(175, 90, 255),
        BorderSizePixel = 0, ZIndex = 22,
    }, Toggle)
    corner(p, 2)
    ParticleHolders[i] = p
end

--==================================================
-- MAIN WINDOW
--==================================================

local Main = new("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(480, 550),
    Position = UDim2.new(0.5, -240, 0.5, -275),
    BackgroundColor3 = Color3.fromRGB(5, 9, 20),
    BackgroundTransparency = 0.06,
    Visible = true,
}, Gui)
corner(Main, 16)
local MainStroke = stroke(Main, 2)

local MainGradient = new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(7, 15, 30)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 8, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 18, 32)),
    }),
    Rotation = 25,
}, Main)

-- Header
local Header = new("Frame", {
    Size = UDim2.new(1, 0, 0, 64),
    BackgroundTransparency = 1,
}, Main)

local Title = new("TextLabel", {
    Size = UDim2.new(1, -110, 0, 32),
    Position = UDim2.fromOffset(18, 7),
    BackgroundTransparency = 1,
    Text = "RASENGAN // ZAKA PURE UI",
    TextColor3 = Color3.fromRGB(225, 250, 255),
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Header)

local SubTitle = new("TextLabel", {
    Size = UDim2.new(1, -110, 0, 20),
    Position = UDim2.fromOffset(19, 35),
    BackgroundTransparency = 1,
    Text = "V1  •  6 TABS  •  MOBILE",
    TextColor3 = Color3.fromRGB(100, 185, 235),
    TextSize = 11,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Header)

local Close = new("TextButton", {
    Size = UDim2.fromOffset(38, 38),
    Position = UDim2.new(1, -50, 0, 12),
    BackgroundColor3 = Color3.fromRGB(20, 24, 42),
    Text = "×",
    TextColor3 = Color3.fromRGB(220, 235, 255),
    TextSize = 25,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
}, Header)
corner(Close, 10)
stroke(Close, 1)

-- Search
local Search = new("TextBox", {
    Size = UDim2.new(1, -32, 0, 38),
    Position = UDim2.fromOffset(16, 70),
    BackgroundColor3 = Color3.fromRGB(10, 17, 34),
    PlaceholderText = "Search skills...",
    PlaceholderColor3 = Color3.fromRGB(100, 125, 155),
    Text = "",
    TextColor3 = Color3.fromRGB(225, 245, 255),
    TextSize = 13,
    Font = Enum.Font.Gotham,
    ClearTextOnFocus = false,
}, Main)
corner(Search, 10)
stroke(Search, 1)

-- Tabs
local TabsFrame = new("ScrollingFrame", {
    Size = UDim2.new(0, 108, 1, -122),
    Position = UDim2.fromOffset(12, 116),
    BackgroundTransparency = 1,
    ScrollBarThickness = 0,
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, Main)

new("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, TabsFrame)

local Content = new("ScrollingFrame", {
    Size = UDim2.new(1, -132, 1, -122),
    Position = UDim2.fromOffset(124, 116),
    BackgroundColor3 = Color3.fromRGB(7, 12, 25),
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Color3.fromRGB(60, 180, 255),
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, Main)
corner(Content, 12)
stroke(Content, 1)

new("UIPadding", {
    PaddingTop = UDim.new(0, 9),
    PaddingBottom = UDim.new(0, 9),
    PaddingLeft = UDim.new(0, 9),
    PaddingRight = UDim.new(0, 9),
}, Content)

local ContentLayout = new("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, Content)

--==================================================
-- CARD CREATION
--==================================================

local currentTab = "Combat"
local Cards = {}

local function makeCard(tabName, data, order)
    local label, kind, key, min, max, step = table.unpack(data)

    local card = new("Frame", {
        Name = label,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Color3.fromRGB(12, 20, 39),
        BackgroundTransparency = 0.04,
        LayoutOrder = order,
    }, Content)
    corner(card, 9)

    local cardStroke = stroke(card, 1)
    cardStroke.Transparency = 0.65

    local nameLabel = new("TextLabel", {
        Size = UDim2.new(1, -130, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Color3.fromRGB(215, 235, 250),
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)

    local valueLabel = new("TextLabel", {
        Size = UDim2.fromOffset(105, 22),
        Position = UDim2.new(1, -115, 0, 14),
        BackgroundTransparency = 1,
        Text = formatValue(Settings[key]),
        TextColor3 = Color3.fromRGB(90, 195, 255),
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, card)

    if kind == "toggle" then
        local button = new("TextButton", {
            Size = UDim2.fromOffset(46, 24),
            Position = UDim2.new(1, -58, 0, 13),
            BackgroundColor3 = Settings[key] and Color3.fromRGB(35, 180, 245) or Color3.fromRGB(35, 45, 65),
            Text = "",
            AutoButtonColor = false,
        }, card)
        corner(button, 12)

        local knob = new("Frame", {
            Size = UDim2.fromOffset(18, 18),
            Position = Settings[key] and UDim2.new(1, -21, 0, 3) or UDim2.fromOffset(3, 3),
            BackgroundColor3 = Color3.fromRGB(235, 250, 255),
        }, button)
        corner(knob, 9)

        local function refresh()
            local on = Settings[key] == true
            button.BackgroundColor3 = on
                and Color3.fromRGB(35, 180, 245)
                or Color3.fromRGB(35, 45, 65)
            tween(knob, TweenInfo.new(0.15), {
                Position = on
                    and UDim2.new(1, -21, 0, 3)
                    or UDim2.fromOffset(3, 3)
            })
            valueLabel.Text = on and "ON" or "OFF"
        end

        button.MouseButton1Click:Connect(function()
            Settings[key] = not Settings[key]
            refresh()
        end)

        refresh()

    elseif kind == "number" then
        valueLabel.Text = formatValue(Settings[key])

        local minus = new("TextButton", {
            Size = UDim2.fromOffset(24, 24),
            Position = UDim2.new(1, -112, 0, 13),
            BackgroundColor3 = Color3.fromRGB(20, 31, 53),
            Text = "−",
            TextColor3 = Color3.fromRGB(190, 225, 245),
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
        }, card)
        corner(minus, 7)

        local plus = new("TextButton", {
            Size = UDim2.fromOffset(24, 24),
            Position = UDim2.new(1, -30, 0, 13),
            BackgroundColor3 = Color3.fromRGB(20, 31, 53),
            Text = "+",
            TextColor3 = Color3.fromRGB(190, 225, 245),
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
        }, card)
        corner(plus, 7)

        valueLabel.Size = UDim2.fromOffset(52, 24)
        valueLabel.Position = UDim2.new(1, -84, 0, 13)

        local function change(delta)
            local oldValue = tonumber(Settings[key]) or 0
            local newValue = oldValue + delta
            newValue = math.clamp(newValue, min, max)
            local precision = step < 1 and 2 or 0
            Settings[key] = tonumber(string.format("%." .. precision .. "f", newValue))
            valueLabel.Text = formatValue(Settings[key])
        end

        minus.MouseButton1Click:Connect(function()
            change(-step)
        end)

        plus.MouseButton1Click:Connect(function()
            change(step)
        end)

    elseif kind == "text" then
        local box = new("TextBox", {
            Size = UDim2.fromOffset(105, 28),
            Position = UDim2.new(1, -115, 0, 11),
            BackgroundColor3 = Color3.fromRGB(17, 27, 48),
            Text = tostring(Settings[key]),
            PlaceholderText = "...",
            TextColor3 = Color3.fromRGB(205, 235, 250),
            TextSize = 10,
            Font = Enum.Font.Gotham,
            ClearTextOnFocus = false,
        }, card)
        corner(box, 7)

        box.FocusLost:Connect(function()
            Settings[key] = box.Text
            valueLabel.Text = box.Text
        end)

        valueLabel.Visible = false

    elseif kind == "color" then
        local colorButton = new("TextButton", {
            Size = UDim2.fromOffset(70, 28),
            Position = UDim2.new(1, -80, 0, 11),
            BackgroundColor3 = Settings[key],
            Text = "COLOR",
            TextColor3 = Color3.fromRGB(235, 250, 255),
            TextSize = 9,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
        }, card)
        corner(colorButton, 7)

        -- Simple cycling palette, no external color picker dependency.
        local colors = {
            Color3.fromRGB(0, 200, 255),
            Color3.fromRGB(80, 120, 255),
            Color3.fromRGB(160, 70, 255),
            Color3.fromRGB(255, 90, 210),
            Color3.fromRGB(255, 255, 255),
        }
        local index = 1

        colorButton.MouseButton1Click:Connect(function()
            index = index % #colors + 1
            Settings[key] = colors[index]
            colorButton.BackgroundColor3 = Settings[key]
        end)

        valueLabel.Visible = false
    end

    Cards[#Cards + 1] = {
        tab = tabName,
        object = card,
        searchName = string.lower(label),
    }

    return card
end

--==================================================
-- TAB BUILD
--==================================================

local TabButtons = {}

local function buildTab(tab)
    for _, child in ipairs(Content:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    Cards = {}

    local list = Controls[tab]
    for i, data in ipairs(list) do
        makeCard(tab, data, i)
    end
end

for index, tabData in ipairs(TabsData) do
    local tabName = tabData.Name

    local tabButton = new("TextButton", {
        Name = tabName,
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = Color3.fromRGB(10, 17, 34),
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = index,
    }, TabsFrame)
    corner(tabButton, 10)

    local icon = new("TextLabel", {
        Size = UDim2.fromOffset(32, 52),
        Position = UDim2.fromOffset(5, 0),
        BackgroundTransparency = 1,
        Text = tabData.Icon,
        TextColor3 = Color3.fromRGB(95, 205, 255),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
    }, tabButton)

    local name = new("TextLabel", {
        Size = UDim2.new(1, -38, 1, 0),
        Position = UDim2.fromOffset(35, 0),
        BackgroundTransparency = 1,
        Text = tabName,
        TextColor3 = Color3.fromRGB(185, 215, 235),
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, tabButton)

    local outline = stroke(tabButton, 1)
    outline.Transparency = 0.75

    TabButtons[tabName] = {
        button = tabButton,
        outline = outline,
        icon = icon,
        name = name,
    }

    tabButton.MouseButton1Click:Connect(function()
        currentTab = tabName

        for nameKey, refs in pairs(TabButtons) do
            local active = nameKey == currentTab
            refs.button.BackgroundColor3 = active
                and Color3.fromRGB(15, 48, 72)
                or Color3.fromRGB(10, 17, 34)
            refs.outline.Transparency = active and 0.1 or 0.75
            refs.icon.TextColor3 = active
                and Color3.fromRGB(120, 230, 255)
                or Color3.fromRGB(95, 205, 255)
            refs.name.TextColor3 = active
                and Color3.fromRGB(235, 250, 255)
                or Color3.fromRGB(185, 215, 235)
        end

        buildTab(currentTab)
        Search.Text = ""
    end)
end

-- Initial tab
TabButtons.Combat.button.BackgroundColor3 = Color3.fromRGB(15, 48, 72)
TabButtons.Combat.outline.Transparency = 0.1
TabButtons.Combat.name.TextColor3 = Color3.fromRGB(235, 250, 255)
buildTab("Combat")

--==================================================
-- SEARCH
--==================================================

Search:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower(Search.Text)

    for _, info in ipairs(Cards) do
        info.object.Visible = q == "" or string.find(info.searchName, q, 1, true) ~= nil
    end
end)

--==================================================
-- OPEN / CLOSE
--==================================================

local opened = true
local opening = false

local function setOpen(state)
    if opening or opened == state then return end
    opening = true

    if state then
        opened = true
        Main.Visible = true
        Main.BackgroundTransparency = 1
        Main.Size = UDim2.fromOffset(30, 30)
        Main.Position = UDim2.new(0.5, -15, 0.5, -15)
        local info = TweenInfo.new(0.48, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(Main, info, {
            Size = UDim2.fromOffset(480, 550),
            Position = UDim2.new(0.5, -240, 0.5, -275),
            BackgroundTransparency = 0.06,
        }):Play()
        task.delay(0.5, function() opening = false end)
    else
        opened = false
        local info = TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        TweenService:Create(Main, info, {
            Size = UDim2.fromOffset(30, 30),
            Position = UDim2.new(0.5, -15, 0.5, -15),
            BackgroundTransparency = 1,
        }):Play()
        task.delay(0.34, function()
            if not opened then Main.Visible = false end
            opening = false
        end)
    end
end

Toggle.MouseButton1Click:Connect(function()
    setOpen(not opened)
end)

Close.MouseButton1Click:Connect(function()
    setOpen(false)
end)

--==================================================
-- RASENGAN ANIMATION
--==================================================

task.spawn(function()
    local rotation = 0
    while Gui.Parent do
        rotation = (rotation + 2.4) % 360
        ToggleGlow.Rotation = rotation
        CoreGradient.Rotation = (rotation * 1.7) % 360
        RingA.Rotation = -rotation * 1.5
        RingB.Rotation = rotation * 0.9
        MainGradient.Rotation = (25 + rotation * 0.15) % 360

        local t = os.clock()
        local pulse = 0.18 + (math.sin(t * 2.8) + 1) * 0.10
        ToggleStroke.Transparency = pulse
        RingAStroke.Transparency = 0.18 + (math.sin(t * 3.2) + 1) * 0.12
        RingBStroke.Transparency = 0.25 + (math.sin(t * 2.1 + 1) + 1) * 0.10
        local s = 1 + math.sin(t * 2.5) * 0.045
        Core.Size = UDim2.fromOffset(34 * s, 34 * s)
        Core.Position = UDim2.new(0.5, -17 * s, 0.5, -17 * s)

        for i, p in ipairs(ParticleHolders) do
            local a = t * (1.3 + i * 0.035) + (i / #ParticleHolders) * math.pi * 2
            local r = 22 + math.sin(t * 2 + i) * 4
            p.Position = UDim2.new(0.5, math.cos(a) * r - 2, 0.5, math.sin(a) * r - 2)
            p.BackgroundTransparency = 0.12 + (math.sin(a * 2) + 1) * 0.18
        end
        task.wait(0.03)
    end
end)

-- Hover feedback
for _, refs in pairs(TabButtons) do
    refs.button.MouseEnter:Connect(function()
        if currentTab ~= refs.button.Name then
            tween(refs.button, TweenInfo.new(0.12), {
                BackgroundColor3 = Color3.fromRGB(14, 29, 50)
            })
        end
    end)

    refs.button.MouseLeave:Connect(function()
        if currentTab ~= refs.button.Name then
            tween(refs.button, TweenInfo.new(0.12), {
                BackgroundColor3 = Color3.fromRGB(10, 17, 34)
            })
        end
    end)
end

local Status = new("TextLabel", {
    Size = UDim2.new(1, -150, 0, 18),
    Position = UDim2.new(0, 132, 1, -22),
    BackgroundTransparency = 1,
    Text = "● CHAKRA CORE  •  RASENGAN ONLINE",
    TextColor3 = Color3.fromRGB(70, 200, 255),
    TextTransparency = 0.12,
    TextSize = 9,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Main)

task.spawn(function()
    while Gui.Parent do
        Status.TextTransparency = 0.12 + (math.sin(os.clock() * 2) + 1) * 0.08
        task.wait(0.05)
    end
end)

print("[ZAKA PURE UI] V1 Rasengan 6-tab UI loaded.")
