--==============================================================--
-- ZAKA PURE UI V1 + V3 FUNCTIONS (FIXED - MENU LUÔN HIỆN)
--==============================================================--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = Player:GetMouse()
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Xóa bản cũ
pcall(function()
    local old = PlayerGui:FindFirstChild("ZakaPureUI")
    if old then old:Destroy() end
end)

--==============================================================
-- SETTINGS
--==============================================================
local Settings = {
    Aimbot = false, AimbotFOV = 120, AimbotSmooth = 0.25, SilentAim = false,
    AutoClicker = false, ClickDelay = 0.05, TargetStrafe = false,
    StrafeDistance = 12, StrafeSpeed = 6, SpinBot = false, SpinSpeed = 45,

    HitboxHead = false, HeadSize = 15, HitboxTorso = false,
    TorsoSize = Vector3.new(4,6,4), HitboxWeapon = false, WeaponSize = 5,
    HitboxTransparent = 0.5, HitboxLimb = false, LimbSize = 4,

    ESP = false, ESPBox = true, ESPName = true, ESPHealth = true,
    ESPDistance = true, ESPMaxDist = 3500, Chams = false,
    ChamsColor = Color3.fromRGB(0,200,255), CustomCrosshair = false,
    CrosshairSize = 12, GlowTrail = false, Fullbright = false,
    FOVChanger = false, FOVValue = 90,

    Speed = false, SpeedValue = 26, Fly = false, FlySpeed = 50,
    Noclip = false, InfiniteJump = false, HighJump = false, JumpPower = 100,
    Bhop = false, SpiderClimb = false, SpiderSpeed = 30, WaterWalk = false,

    TouchTP = false, BringNPC = false, GravityMod = false, GravityValue = 196.2,

    ChatSpammer = false, SpamMessage = "Zaka Pure UI - Eye Morph", SpamDelay = 2,
}

local NoclipConn, SpeedConn, FlyConn, TouchTPConn, AutoClickConn, SpamConn, StrafeConn, WaterConn, SpiderConn
local BodyGyro, BodyVelocity
local ESPObjects = {}
local ChamsObjects = {}
local OriginalAmbient = Lighting.Ambient
local OriginalGravity = Workspace.Gravity

-- Anti AFK
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

--==============================================================
-- CORE FUNCTIONS
--==============================================================
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.RenderStepped:Connect(function()
    local char = Player.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if Settings.HighJump then hum.JumpPower = Settings.JumpPower end
    end

    if Settings.Fullbright then
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = OriginalAmbient
    end

    if Settings.FOVChanger then Camera.FieldOfView = Settings.FOVValue end
    if Settings.GravityMod then Workspace.Gravity = Settings.GravityValue
    else Workspace.Gravity = OriginalGravity end

    if Settings.SpinBot and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
    end
end)

RunService.RenderStepped:Connect(function()
    if Settings.Bhop then
        local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.FloorMaterial \~= Enum.Material.Air then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local function SetTouchTP(state)
    Settings.TouchTP = state
    if TouchTPConn then TouchTPConn:Disconnect() TouchTPConn = nil end
    if state then
        TouchTPConn = UserInputService.InputBegan:Connect(function(input, gp)
            if not gp and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                if Settings.TouchTP and Mouse.Hit then
                    local char = Player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0,3.5,0))
                    end
                end
            end
        end)
    end
end

local function SetWaterWalk(state)
    Settings.WaterWalk = state
    if WaterConn then WaterConn:Disconnect() WaterConn = nil end
    if state then
        WaterConn = RunService.RenderStepped:Connect(function()
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local ray = Ray.new(root.Position, Vector3.new(0,-6,0))
                local hit, pos, _, mat = Workspace:FindPartOnRay(ray, char)
                if mat == Enum.Material.Water then
                    root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
                    root.CFrame = CFrame.new(root.Position.X, pos.Y + 3.2, root.Position.Z)
                end
            end
        end)
    end
end

local function SetSpiderClimb(state)
    Settings.SpiderClimb = state
    if SpiderConn then SpiderConn:Disconnect() SpiderConn = nil end
    if state then
        SpiderConn = RunService.RenderStepped:Connect(function()
            local char = Player.Character
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

local function SetBringNPC(state)
    Settings.BringNPC = state
    if not state then return end
    task.spawn(function()
        while Settings.BringNPC do
            local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj \~= Player.Character then
                        local hum = obj:FindFirstChildOfClass("Humanoid")
                        local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                        if hum and root and hum.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
                            root.CFrame = myRoot.CFrame * CFrame.new(0,0,-4)
                            root.Velocity = Vector3.zero
                        end
                    end
                end
            end
            task.wait(0.15)
        end
    end)
end

local function SetChatSpammer(state)
    Settings.ChatSpammer = state
    if SpamConn then pcall(task.cancel, SpamConn) SpamConn = nil end
    if state then
        SpamConn = task.spawn(function()
            while Settings.ChatSpammer do
                pcall(function()
                    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                        TextChatService.TextChannels.RBXGeneral:SendAsync(Settings.SpamMessage)
                    else
                        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Settings.SpamMessage, "All")
                    end
                end)
                task.wait(Settings.SpamDelay)
            end
        end)
    end
end

local function SetTargetStrafe(state)
    Settings.TargetStrafe = state
    if StrafeConn then StrafeConn:Disconnect() StrafeConn = nil end
    if state then
        local angle = 0
        StrafeConn = RunService.RenderStepped:Connect(function()
            local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            local target, minDist = nil, 9999
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr \~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (plr.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
                    if dist < minDist then minDist = dist target = plr.Character.HumanoidRootPart end
                end
            end
            if target and minDist <= 50 then
                angle = angle + math.rad(Settings.StrafeSpeed)
                local offset = Vector3.new(math.cos(angle)*Settings.StrafeDistance, 0, math.sin(angle)*Settings.StrafeDistance)
                myRoot.CFrame = CFrame.new(target.Position + offset, target.Position)
            end
        end)
    end
end

local function SetGlowTrail(state)
    Settings.GlowTrail = state
    local char = Player.Character
    if not char then return end
    if state then
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local a0 = Instance.new("Attachment", root) a0.Name = "TrailA0" a0.Position = Vector3.new(0,-2.2,0)
        local a1 = Instance.new("Attachment", root) a1.Name = "TrailA1" a1.Position = Vector3.new(0,-2.0,0)
        local trail = Instance.new("Trail")
        trail.Name = "PlayerGlowTrail"
        trail.Attachment0 = a0 trail.Attachment1 = a1
        trail.Lifetime = 0.8
        trail.Color = ColorSequence.new(Color3.fromRGB(120,80,255), Color3.fromRGB(255,50,100))
        trail.Transparency = NumberSequence.new(0.1, 1)
        trail.Parent = char
    else
        pcall(function()
            if char:FindFirstChild("PlayerGlowTrail") then char.PlayerGlowTrail:Destroy() end
            if char:FindFirstChild("HumanoidRootPart") then
                if char.HumanoidRootPart:FindFirstChild("TrailA0") then char.HumanoidRootPart.TrailA0:Destroy() end
                if char.HumanoidRootPart:FindFirstChild("TrailA1") then char.HumanoidRootPart.TrailA1:Destroy() end
            end
        end)
    end
end

-- Hitbox
RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= Player and plr.Character then
            local char = plr.Character
            local head = char:FindFirstChild("Head")
            if head then
                if Settings.HitboxHead then
                    head.Size = Vector3.new(Settings.HeadSize, Settings.HeadSize, Settings.HeadSize)
                    head.Transparency = Settings.HitboxTransparent
                    head.CanCollide = false
                else
                    head.Size = Vector3.new(2,1,1)
                    head.Transparency = 0
                end
            end
            local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            if torso then
                if Settings.HitboxTorso then
                    torso.Size = Settings.TorsoSize
                    torso.Transparency = Settings.HitboxTransparent
                    torso.CanCollide = false
                else
                    torso.Size = Vector3.new(2,2,1)
                    torso.Transparency = 0
                end
            end
            if Settings.HitboxLimb then
                for _, name in ipairs({"Left Arm","Right Arm","Left Leg","Right Leg","LeftLowerArm","RightLowerArm","LeftLowerLeg","RightLowerLeg"}) do
                    local limb = char:FindFirstChild(name)
                    if limb and limb:IsA("BasePart") then
                        limb.Size = Vector3.new(Settings.LimbSize, Settings.LimbSize, Settings.LimbSize)
                        limb.Transparency = Settings.HitboxTransparent
                        limb.CanCollide = false
                    end
                end
            end
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

-- Drawing (an toàn)
local FOVCircle, CrosshairV, CrosshairH
local DrawingSupported = false

pcall(function()
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1.5
    FOVCircle.NumSides = 64
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Filled = false
    FOVCircle.Visible = false
    FOVCircle.Color = Color3.fromRGB(120,80,255)

    CrosshairV = Drawing.new("Line")
    CrosshairH = Drawing.new("Line")
    DrawingSupported = true
end)

local function GetClosestPlayerHead()
    local closest, shortest = nil, Settings.AimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= Player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist < shortest then shortest = dist closest = head end
                end
            end
        end
    end
    return closest
end

-- Silent Aim (an toàn)
pcall(function()
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if not checkcaller() and Settings.SilentAim and self == Mouse and tostring(key) == "Hit" then
            local target = GetClosestPlayerHead()
            if target then return target.CFrame end
        end
        return oldIndex(self, key)
    end)
end)

RunService.RenderStepped:Connect(function()
    if not DrawingSupported then return end
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Position = center
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Visible = Settings.Aimbot or Settings.SilentAim

    if Settings.CustomCrosshair then
        local s = Settings.CrosshairSize
        CrosshairV.From = Vector2.new(center.X, center.Y - s)
        CrosshairV.To = Vector2.new(center.X, center.Y + s)
        CrosshairV.Color = Color3.fromRGB(160,100,255)
        CrosshairV.Thickness = 2
        CrosshairV.Visible = true
        CrosshairH.From = Vector2.new(center.X - s, center.Y)
        CrosshairH.To = Vector2.new(center.X + s, center.Y)
        CrosshairH.Color = Color3.fromRGB(160,100,255)
        CrosshairH.Thickness = 2
        CrosshairH.Visible = true
    else
        CrosshairV.Visible = false
        CrosshairH.Visible = false
    end

    if Settings.Aimbot then
        local target = GetClosestPlayerHead()
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), Settings.AimbotSmooth)
        end
    end
end)

-- ESP + Chams
RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= Player and plr.Character then
            if Settings.Chams then
                if not ChamsObjects[plr] then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ZakaChams"
                    hl.FillColor = Settings.ChamsColor
                    hl.OutlineColor = Color3.fromRGB(255,255,255)
                    hl.FillTransparency = 0.35
                    hl.Parent = plr.Character
                    ChamsObjects[plr] = hl
                end
            else
                if ChamsObjects[plr] then ChamsObjects[plr]:Destroy() ChamsObjects[plr] = nil end
            end
        end
    end

    if not Settings.ESP or not DrawingSupported then
        for _, drawings in pairs(ESPObjects) do
            for _, d in pairs(drawings) do pcall(function() d.Visible = false end) end
        end
        return
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == Player then continue end
        if not ESPObjects[plr] then
            local ok, box = pcall(Drawing.new, "Square")
            local ok2, name = pcall(Drawing.new, "Text")
            local ok3, health = pcall(Drawing.new, "Text")
            local ok4, dist = pcall(Drawing.new, "Text")
            if ok and ok2 and ok3 and ok4 then
                ESPObjects[plr] = {Box = box, Name = name, Health = health, Distance = dist}
                box.Filled = false
                name.Size = 12 name.Center = true name.Outline = true
                health.Size = 11 health.Center = true health.Outline = true
                dist.Size = 11 dist.Center = true dist.Outline = true
            end
        end

        local drawings = ESPObjects[plr]
        if not drawings then continue end

        local char = plr.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
            for _, d in pairs(drawings) do pcall(function() d.Visible = false end) end
            continue
        end

        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local dist = (root.Position - Camera.CFrame.Position).Magnitude

        if not onScreen or dist > Settings.ESPMaxDist then
            for _, d in pairs(drawings) do pcall(function() d.Visible = false end) end
            continue
        end

        local size = Vector2.new(math.clamp(2000/pos.Z, 8, 300), math.clamp(3000/pos.Z, 12, 450))
        drawings.Box.Size = size
        drawings.Box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
        drawings.Box.Color = Color3.fromRGB(120,80,255)
        drawings.Box.Visible = Settings.ESPBox

        drawings.Name.Text = plr.Name
        drawings.Name.Position = Vector2.new(pos.X, pos.Y - size.Y/2 - 14)
        drawings.Name.Color = Color3.fromRGB(240,245,255)
        drawings.Name.Visible = Settings.ESPName

        drawings.Health.Text = math.floor(hum.Health) .. " HP"
        drawings.Health.Position = Vector2.new(pos.X, pos.Y + size.Y/2 + 2)
        drawings.Health.Visible = Settings.ESPHealth

        drawings.Distance.Text = math.floor(dist) .. "m"
        drawings.Distance.Position = Vector2.new(pos.X, pos.Y + size.Y/2 + 14)
        drawings.Distance.Visible = Settings.ESPDistance
    end
end)

-- Fly
local function StartFly()
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 9e4
    BodyGyro.maxTorque = Vector3.new(9e9,9e9,9e9)
    BodyGyro.cframe = root.CFrame
    BodyGyro.Parent = root

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.velocity = Vector3.zero
    BodyVelocity.maxForce = Vector3.new(9e9,9e9,9e9)
    BodyVelocity.Parent = root

    FlyConn = RunService.RenderStepped:Connect(function()
        if not Settings.Fly or not char or not char:FindFirstChild("Humanoid") then
            if BodyGyro then BodyGyro:Destroy() end
            if BodyVelocity then BodyVelocity:Destroy() end
            if FlyConn then FlyConn:Disconnect() end
            return
        end
        BodyGyro.cframe = Camera.CFrame
        local moveDir = char.Humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            local flyVector = (Camera.CFrame.LookVector * (moveDir.Z * -1)) + (Camera.CFrame.RightVector * moveDir.X)
            BodyVelocity.velocity = flyVector.Unit * Settings.FlySpeed
        else
            BodyVelocity.velocity = Vector3.zero
        end
    end)
end

local function SetFly(state)
    Settings.Fly = state
    if state then StartFly()
    else
        if BodyGyro then BodyGyro:Destroy() end
        if BodyVelocity then BodyVelocity:Destroy() end
        if FlyConn then FlyConn:Disconnect() end
    end
end

local function SetSpeed(state)
    if SpeedConn then SpeedConn:Disconnect() SpeedConn = nil end
    if state then
        SpeedConn = RunService.Heartbeat:Connect(function()
            local hum = Player.Character and Player.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = Settings.SpeedValue end
        end)
    else
        local hum = Player.Character and Player.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end

local function SetNoclip(state)
    if NoclipConn then NoclipConn:Disconnect() NoclipConn = nil end
    if state then
        NoclipConn = RunService.Stepped:Connect(function()
            local char = Player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end
end

--==============================================================
-- GUI (V1 Eye Morph)
--==============================================================
local Gui = Instance.new("ScreenGui")
Gui.Name = "ZakaPureUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local Toggle = Instance.new("TextButton")
Toggle.Name = "ToggleButton"
Toggle.Size = UDim2.fromOffset(64,64)
Toggle.Position = UDim2.new(0,18,0.42,0)
Toggle.AnchorPoint = Vector2.new(0,0.5)
Toggle.BackgroundColor3 = Color3.fromRGB(9,9,15)
Toggle.BackgroundTransparency = 0.05
Toggle.BorderSizePixel = 0
Toggle.Text = "Z"
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.TextSize = 30
Toggle.Font = Enum.Font.GothamBlack
Toggle.AutoButtonColor = false
Toggle.ZIndex = 100
Toggle.Parent = Gui
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1,0)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 2
ToggleStroke.Color = Color3.fromRGB(120,80,255)
ToggleStroke.Transparency = 0.15
ToggleStroke.Parent = Toggle

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(.5,.5)
Main.Position = UDim2.fromScale(.5,.5)
Main.Size = UDim2.fromOffset(0,0)
Main.BackgroundColor3 = Color3.fromRGB(8,8,14)
Main.BackgroundTransparency = 1
Main.BorderSizePixel = 0
Main.Visible = false
Main.ZIndex = 20
Main.Parent = Gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(105,75,255)
MainStroke.Transparency = .2
MainStroke.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,65)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(20,8)
Title.Size = UDim2.new(1,-80,0,27)
Title.Text = "ZAKA PURE UI"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 21
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.fromOffset(21,36)
Subtitle.Size = UDim2.new(1,-80,0,18)
Subtitle.Text = "V1 • EYE MORPH + FULL FEATURES"
Subtitle.TextColor3 = Color3.fromRGB(140,130,190)
Subtitle.TextSize = 9
Subtitle.Font = Enum.Font.GothamBold
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(38,38)
Close.Position = UDim2.new(1,-48,0,12)
Close.BackgroundColor3 = Color3.fromRGB(35,25,45)
Close.BorderSizePixel = 0
Close.Text = "×"
Close.TextColor3 = Color3.new(1,1,1)
Close.TextSize = 25
Close.Font = Enum.Font.GothamBold
Close.AutoButtonColor = false
Close.Parent = Header
Instance.new("UICorner", Close).CornerRadius = UDim.new(0,10)

local Content = Instance.new("Frame")
Content.Position = UDim2.fromOffset(14,75)
Content.Size = UDim2.new(1,-28,1,-88)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Banner = Instance.new("Frame")
Banner.Size = UDim2.new(1,0,0,50)
Banner.BackgroundColor3 = Color3.fromRGB(19,17,30)
Banner.BorderSizePixel = 0
Banner.Parent = Content
Instance.new("UICorner", Banner).CornerRadius = UDim.new(0,12)

local BannerText = Instance.new("TextLabel")
BannerText.BackgroundTransparency = 1
BannerText.Position = UDim2.fromOffset(15,6)
BannerText.Size = UDim2.new(1,-30,0,20)
BannerText.Text = "EYE SYSTEM + FULL FEATURES"
BannerText.TextColor3 = Color3.new(1,1,1)
BannerText.TextSize = 13
BannerText.Font = Enum.Font.GothamBlack
BannerText.TextXAlignment = Enum.TextXAlignment.Left
BannerText.Parent = Banner

local BannerSub = Instance.new("TextLabel")
BannerSub.BackgroundTransparency = 1
BannerSub.Position = UDim2.fromOffset(15,26)
BannerSub.Size = UDim2.new(1,-30,0,16)
BannerSub.Text = "Morphing • Aimbot • ESP • Fly • Hitbox • Troll"
BannerSub.TextColor3 = Color3.fromRGB(135,125,160)
BannerSub.TextSize = 9
BannerSub.Font = Enum.Font.Gotham
BannerSub.TextXAlignment = Enum.TextXAlignment.Left
BannerSub.Parent = Banner

local TabFrame = Instance.new("Frame")
TabFrame.Position = UDim2.fromOffset(0,58)
TabFrame.Size = UDim2.new(1,0,0,36)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = Content

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0,5)
TabLayout.Parent = TabFrame

local TabNames = {"COMBAT","HITBOX","VISUAL","PLAYER","WORLD","TROLL"}
local TabButtons = {}
local Pages = {}

for i, Name in ipairs(TabNames) do
    local B = Instance.new("TextButton")
    B.Size = UDim2.fromOffset(70,34)
    B.BackgroundColor3 = Color3.fromRGB(20,18,30)
    B.BorderSizePixel = 0
    B.Text = Name
    B.TextColor3 = Color3.fromRGB(180,175,205)
    B.TextSize = 9
    B.Font = Enum.Font.GothamBold
    B.AutoButtonColor = false
    B.Parent = TabFrame
    Instance.new("UICorner", B).CornerRadius = UDim.new(0,9)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1,0,1,-100)
    page.Position = UDim2.fromOffset(0,100)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(120,80,255)
    page.Visible = false
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.Parent = Content

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0,7)
    list.Parent = page
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0,0,0, list.AbsoluteContentSize.Y + 20)
    end)

    TabButtons[i] = B
    Pages[i] = page
end

local function CreateToggle(parent, text, default, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1,0,0,42)
    card.BackgroundColor3 = Color3.fromRGB(17,16,27)
    card.BorderSizePixel = 0
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0,10)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.fromOffset(14,0)
    label.Size = UDim2.new(1,-70,1,0)
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(36,20)
    btn.Position = UDim2.new(1,-48,0.5,-10)
    btn.BackgroundColor3 = default and Color3.fromRGB(120,80,255) or Color3.fromRGB(40,35,55)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = card
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)

    local enabled = default
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = enabled and Color3.fromRGB(120,80,255) or Color3.fromRGB(40,35,55)
        }):Play()
        callback(enabled)
    end)
end

-- Nội dung Tab
CreateToggle(Pages[1], "Aimbot Lock Head", false, function(v) Settings.Aimbot = v end)
CreateToggle(Pages[1], "Silent Aim", false, function(v) Settings.SilentAim = v end)
CreateToggle(Pages[1], "Auto Clicker", false, function(v) SetAutoClicker(v) end)
CreateToggle(Pages[1], "Target Strafe", false, function(v) SetTargetStrafe(v) end)
CreateToggle(Pages[1], "SpinBot", false, function(v) Settings.SpinBot = v end)

CreateToggle(Pages[2], "Hitbox Head", false, function(v) Settings.HitboxHead = v end)
CreateToggle(Pages[2], "Hitbox Torso", false, function(v) Settings.HitboxTorso = v end)
CreateToggle(Pages[2], "Hitbox Limb", false, function(v) Settings.HitboxLimb = v end)
CreateToggle(Pages[2], "Hitbox Weapon", false, function(v) Settings.HitboxWeapon = v end)

CreateToggle(Pages[3], "ESP Box", false, function(v) Settings.ESP = v end)
CreateToggle(Pages[3], "Chams", false, function(v) Settings.Chams = v end)
CreateToggle(Pages[3], "Custom Crosshair", false, function(v) Settings.CustomCrosshair = v end)
CreateToggle(Pages[3], "Glow Trail", false, function(v) SetGlowTrail(v) end)
CreateToggle(Pages[3], "Fullbright", false, function(v) Settings.Fullbright = v end)
CreateToggle(Pages[3], "FOV Changer", false, function(v) Settings.FOVChanger = v end)

CreateToggle(Pages[4], "Speed Walk", false, function(v) Settings.Speed = v SetSpeed(v) end)
CreateToggle(Pages[4], "Fly", false, function(v) SetFly(v) end)
CreateToggle(Pages[4], "Noclip", false, function(v) Settings.Noclip = v SetNoclip(v) end)
CreateToggle(Pages[4], "Infinite Jump", false, function(v) Settings.InfiniteJump = v end)
CreateToggle(Pages[4], "High Jump", false, function(v) Settings.HighJump = v end)
CreateToggle(Pages[4], "Bunny Hop", false, function(v) Settings.Bhop = v end)
CreateToggle(Pages[4], "Spider Climb", false, function(v) SetSpiderClimb(v) end)
CreateToggle(Pages[4], "Water Walk", false, function(v) SetWaterWalk(v) end)

CreateToggle(Pages[5], "Touch TP", false, function(v) SetTouchTP(v) end)
CreateToggle(Pages[5], "Bring NPC", false, function(v) SetBringNPC(v) end)
CreateToggle(Pages[5], "Gravity Mod", false, function(v) Settings.GravityMod = v end)

CreateToggle(Pages[6], "Chat Spammer", false, function(v) SetChatSpammer(v) end)

local function SwitchTab(index)
    for i, btn in ipairs(TabButtons) do
        btn.BackgroundColor3 = Color3.fromRGB(20,18,30)
        btn.TextColor3 = Color3.fromRGB(180,175,205)
        Pages[i].Visible = false
    end
    TabButtons[index].BackgroundColor3 = Color3.fromRGB(72,50,145)
    TabButtons[index].TextColor3 = Color3.new(1,1,1)
    Pages[index].Visible = true
end

for i, btn in ipairs(TabButtons) do
    btn.MouseButton1Click:Connect(function() SwitchTab(i) end)
end
SwitchTab(1)

--==============================================================
-- EYE SYSTEM
--==============================================================
local Eye = Instance.new("Frame")
Eye.Name = "ZakaEye"
Eye.AnchorPoint = Vector2.new(.5,.5)
Eye.Position = UDim2.fromScale(.5,.5)
Eye.Size = UDim2.fromScale(.82,.82)
Eye.BackgroundTransparency = 1
Eye.Visible = false
Eye.ZIndex = 150
Eye.Parent = Toggle

local function MakeCircle(Name, Size, Color, Transparency, Z)
    local F = Instance.new("Frame")
    F.Name = Name
    F.AnchorPoint = Vector2.new(.5,.5)
    F.Position = UDim2.fromScale(.5,.5)
    F.Size = UDim2.fromScale(Size, Size)
    F.BackgroundColor3 = Color
    F.BackgroundTransparency = Transparency or 0
    F.BorderSizePixel = 0
    F.ZIndex = Z or 150
    F.Parent = Eye
    Instance.new("UICorner", F).CornerRadius = UDim.new(1,0)
    return F
end

local GlowOuter = MakeCircle("GlowOuter", 1.40, Color3.fromRGB(255,30,50), .90, 150)
local GlowMiddle = MakeCircle("GlowMiddle", 1.18, Color3.fromRGB(255,30,50), .80, 151)
local GlowInner = MakeCircle("GlowInner", 1.00, Color3.fromRGB(255,30,50), .70, 152)
local EyeBase = MakeCircle("EyeBase", .92, Color3.fromRGB(15,5,8), 0, 153)
local EyeBaseStroke = Instance.new("UIStroke")
EyeBaseStroke.Thickness = 2
EyeBaseStroke.Color = Color3.fromRGB(255,40,50)
EyeBaseStroke.Parent = EyeBase

local RingOuter = MakeCircle("RingOuter", .78, Color3.fromRGB(40,5,10), 0, 154)
local RingOuterStroke = Instance.new("UIStroke")
RingOuterStroke.Thickness = 2
RingOuterStroke.Color = Color3.fromRGB(255,60,70)
RingOuterStroke.Parent = RingOuter

local RingMiddle = MakeCircle("RingMiddle", .61, Color3.fromRGB(90,10,20), 0, 155)
local RingMiddleStroke = Instance.new("UIStroke")
RingMiddleStroke.Thickness = 1.5
RingMiddleStroke.Color = Color3.fromRGB(255,100,100)
RingMiddleStroke.Parent = RingMiddle

local Iris = MakeCircle("Iris", .45, Color3.fromRGB(180,20,30), 0, 156)
local IrisStroke = Instance.new("UIStroke")
IrisStroke.Thickness = 1.5
IrisStroke.Color = Color3.fromRGB(255,150,150)
IrisStroke.Parent = Iris

local Inner = MakeCircle("Inner", .29, Color3.fromRGB(40,3,7), 0, 157)
local Pupil = MakeCircle("Pupil", .15, Color3.fromRGB(0,0,0), 0, 158)
local Core = MakeCircle("Core", .045, Color3.fromRGB(255,255,255), 0, 159)

local Symbol = Instance.new("Frame")
Symbol.Name = "Symbol"
Symbol.AnchorPoint = Vector2.new(.5,.5)
Symbol.Position = UDim2.fromScale(.5,.5)
Symbol.Size = UDim2.fromScale(.82,.82)
Symbol.BackgroundTransparency = 1
Symbol.ZIndex = 160
Symbol.Parent = Eye

local SymbolObjects = {}
local function ClearSymbol()
    for _, Obj in ipairs(SymbolObjects) do
        if Obj and Obj.Parent then Obj:Destroy() end
    end
    table.clear(SymbolObjects)
end

local function AddLine(angle, length, width, color)
    local L = Instance.new("Frame")
    L.AnchorPoint = Vector2.new(.5,.5)
    L.Position = UDim2.fromScale(.5,.5)
    L.Size = UDim2.new(0, length, 0, width)
    L.Rotation = angle
    L.BackgroundColor3 = color
    L.BorderSizePixel = 0
    L.ZIndex = 161
    L.Parent = Symbol
    table.insert(SymbolObjects, L)
    return L
end

local function AddDot(x, y, size, color)
    local D = Instance.new("Frame")
    D.AnchorPoint = Vector2.new(.5,.5)
    D.Position = UDim2.fromScale(x, y)
    D.Size = UDim2.fromOffset(size, size)
    D.BackgroundColor3 = color
    D.BorderSizePixel = 0
    D.ZIndex = 162
    D.Parent = Symbol
    Instance.new("UICorner", D).CornerRadius = UDim.new(1,0)
    table.insert(SymbolObjects, D)
    return D
end

local EyeTypes = {
    {Name="SHARINGAN", Color=Color3.fromRGB(255,35,45), Accent=Color3.fromRGB(30,0,0), Type="TOMOE"},
    {Name="RINNEGAN", Color=Color3.fromRGB(175,130,255), Accent=Color3.fromRGB(30,10,70), Type="RINGS"},
    {Name="MANGEKYO", Color=Color3.fromRGB(230,30,40), Accent=Color3.fromRGB(10,0,0), Type="STAR"},
    {Name="TRI-BLADE", Color=Color3.fromRGB(255,45,45), Accent=Color3.fromRGB(20,0,0), Type="TRI"},
    {Name="HEX", Color=Color3.fromRGB(255,75,35), Accent=Color3.fromRGB(25,0,0), Type="HEX"},
    {Name="SPIRAL", Color=Color3.fromRGB(245,40,60), Accent=Color3.fromRGB(30,0,15), Type="SPIRAL"},
    {Name="CRIMSON STAR", Color=Color3.fromRGB(255,20,30), Accent=Color3.fromRGB(0,0,0), Type="STAR6"},
    {Name="VOID", Color=Color3.fromRGB(90,70,120), Accent=Color3.fromRGB(5,5,10), Type="VOID"},
    {Name="TRIPLE", Color=Color3.fromRGB(220,35,55), Accent=Color3.fromRGB(15,0,0), Type="TRIPLE"},
    {Name="COSMIC", Color=Color3.fromRGB(80,170,255), Accent=Color3.fromRGB(15,30,70), Type="COSMIC"},
    {Name="BLACK STAR", Color=Color3.fromRGB(230,35,45), Accent=Color3.fromRGB(0,0,0), Type="BLACKSTAR"},
    {Name="RED RING", Color=Color3.fromRGB(255,55,40), Accent=Color3.fromRGB(30,0,0), Type="RINGS"},
}

local function BuildSymbol(Data)
    ClearSymbol()
    local C, A = Data.Color, Data.Accent
    if Data.Type == "TOMOE" then
        for i=1,3 do
            local Angle = (i-1)*120
            AddDot(.5 + math.cos(math.rad(Angle))*0.27, .5 + math.sin(math.rad(Angle))*0.27, 10, A)
            local L = AddLine((i-1)*120, 22, 5, A)
            L.Position = UDim2.fromScale(.5 + math.cos(math.rad((i-1)*120))*0.14, .5 + math.sin(math.rad((i-1)*120))*0.14)
        end
    elseif Data.Type == "RINGS" then
        for i=1,4 do
            local R = Instance.new("Frame")
            R.AnchorPoint = Vector2.new(.5,.5)
            R.Position = UDim2.fromScale(.5,.5)
            R.Size = UDim2.fromScale(.15 + i*.13, .15 + i*.13)
            R.BackgroundTransparency = 1
            R.ZIndex = 161+i
            R.Parent = Symbol
            local S = Instance.new("UIStroke")
            S.Thickness = 1.5
            S.Color = A
            S.Parent = R
            Instance.new("UICorner", R).CornerRadius = UDim.new(1,0)
            table.insert(SymbolObjects, R)
        end
    elseif Data.Type == "STAR" then
        for i=1,6 do AddLine((i-1)*60, 48, 6, A) end
    elseif Data.Type == "TRI" then
        for i=1,3 do AddLine((i-1)*120, 43, 7, A) end
    elseif Data.Type == "HEX" then
        for i=1,6 do AddLine((i-1)*60, 45, 5, A) end
        for i=1,6 do
            local Angle = math.rad((i-1)*60)
            AddDot(.5 + math.cos(Angle)*.25, .5 + math.sin(Angle)*.25, 6, C)
        end
    elseif Data.Type == "SPIRAL" then
        for i=1,5 do
            local L = AddLine(i*32, 30+i*3, 4, A)
            L.Position = UDim2.fromScale(.5 + math.cos(math.rad(i*70))*.08, .5 + math.sin(math.rad(i*70))*.08)
        end
    elseif Data.Type == "STAR6" then
        for i=1,6 do AddLine((i-1)*60, 52, 9, A) end
    elseif Data.Type == "VOID" then
        for i=1,8 do AddLine((i-1)*45, 42, 3, C) end
    elseif Data.Type == "TRIPLE" then
        for i=1,3 do
            local Angle = math.rad((i-1)*120)
            AddDot(.5 + math.cos(Angle)*.20, .5 + math.sin(Angle)*.20, 14, A)
            AddLine((i-1)*120, 30, 6, A)
        end
    elseif Data.Type == "COSMIC" then
        for i=1,8 do
            local Angle = math.rad((i-1)*45)
            AddDot(.5 + math.cos(Angle)*.30, .5 + math.sin(Angle)*.30, 5, C)
            AddLine((i-1)*45, 42, 2, A)
        end
    elseif Data.Type == "BLACKSTAR" then
        for i=1,5 do AddLine((i-1)*36, 50, 9, A) end
        for i=1,5 do
            local Angle = math.rad((i-1)*72)
            AddDot(.5 + math.cos(Angle)*.25, .5 + math.sin(Angle)*.25, 8, C)
        end
    end
end

local function TweenColor(Object, Color, Time)
    if not Object then return end
    TweenService:Create(Object, TweenInfo.new(Time, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundColor3 = Color}):Play()
end

local function ChangeEyeColor(Data)
    local Time = 1.8
    TweenColor(EyeBase, Data.Accent, Time)
    TweenColor(RingOuter, Data.Color, Time)
    TweenColor(RingMiddle, Data.Color, Time)
    TweenColor(Iris, Data.Color, Time)
    TweenColor(GlowOuter, Data.Color, Time)
    TweenColor(GlowMiddle, Data.Color, Time)
    TweenColor(GlowInner, Data.Color, Time)
    TweenService:Create(EyeBaseStroke, TweenInfo.new(Time), {Color = Data.Color}):Play()
    TweenService:Create(RingOuterStroke, TweenInfo.new(Time), {Color = Data.Color}):Play()
    TweenService:Create(RingMiddleStroke, TweenInfo.new(Time), {Color = Data.Color}):Play()
    TweenService:Create(IrisStroke, TweenInfo.new(Time), {Color = Data.Color}):Play()
end

local CurrentType = 1
local Morphing = false
local EyeOpen = false

local function MorphTo(NewIndex)
    if Morphing then return end
    Morphing = true
    local NewData = EyeTypes[NewIndex]

    TweenService:Create(Eye, TweenInfo.new(.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.fromScale(.70,.70)}):Play()
    TweenService:Create(Symbol, TweenInfo.new(.8, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {Rotation = Symbol.Rotation + 180}):Play()
    ChangeEyeColor(NewData)
    task.wait(.35)

    for _, Obj in ipairs(SymbolObjects) do
        if Obj:IsA("Frame") then
            TweenService:Create(Obj, TweenInfo.new(.55), {BackgroundTransparency = 1}):Play()
        end
    end
    task.wait(.35)
    BuildSymbol(NewData)

    for _, Obj in ipairs(SymbolObjects) do
        if Obj:IsA("Frame") then
            Obj.BackgroundTransparency = 1
            TweenService:Create(Obj, TweenInfo.new(.65), {BackgroundTransparency = 0}):Play()
        end
    end

    TweenService:Create(Eye, TweenInfo.new(.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.fromScale(.82,.82)}):Play()
    CurrentType = NewIndex
    task.wait(.75)
    Morphing = false
end

local MorphThread
local function StartMorph()
    if MorphThread then return end
    MorphThread = task.spawn(function()
        while EyeOpen do
            task.wait(5)
            if not EyeOpen then break end
            local Next
            repeat Next = math.random(1, #EyeTypes) until Next \~= CurrentType
            MorphTo(Next)
        end
        MorphThread = nil
    end)
end

local function OpenEye()
    EyeOpen = true
    Toggle.TextTransparency = 1
    Eye.Visible = true
    Eye.Size = UDim2.fromScale(.02,.02)
    BuildSymbol(EyeTypes[CurrentType])
    ChangeEyeColor(EyeTypes[CurrentType])
    TweenService:Create(Eye, TweenInfo.new(.75, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.fromScale(.82,.82)}):Play()
    StartMorph()
end

local function CloseEye()
    EyeOpen = false
    TweenService:Create(Eye, TweenInfo.new(.65, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.fromScale(.02,.02)}):Play()
    task.wait(.55)
    Eye.Visible = false
    Toggle.Text = "Z"
    TweenService:Create(Toggle, TweenInfo.new(.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
end

local MenuOpen = false

local function OpenMenu()
    if MenuOpen then return end
    MenuOpen = true
    Main.Visible = true
    Main.Size = UDim2.fromOffset(25,25)
    Main.BackgroundTransparency = 1
    OpenEye()
    TweenService:Create(Main, TweenInfo.new(.60, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(460,520),
        BackgroundTransparency = .08
    }):Play()
end

local function CloseMenu()
    if not MenuOpen then return end
    MenuOpen = false
    CloseEye()
    TweenService:Create(Main, TweenInfo.new(.40, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Size = UDim2.fromOffset(25,25),
        BackgroundTransparency = 1
    }):Play()
    task.delay(.42, function()
        if not MenuOpen then Main.Visible = false end
    end)
end

Toggle.MouseButton1Click:Connect(function()
    if MenuOpen then CloseMenu() else OpenMenu() end
end)
Close.MouseButton1Click:Connect(CloseMenu)

-- Drag
local Dragging, DragStart, StartPos
Toggle.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = Input.Position
        StartPos = Toggle.Position
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not Dragging then return end
    if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseMovement then
        local Delta = Input.Position - DragStart
        Toggle.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
    end
end)

-- START
task.wait(0.3)
OpenMenu()

print("✅ ZAKA PURE UI V1 + V3 LOADED - Menu should appear!")
