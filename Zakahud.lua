--[[
    ZAKA • NARUTO
    Full UI + Full Functions
    6 Tabs | All Working Skills | Smooth Animation
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

pcall(function()
    for _, n in ipairs({"ZakaNaruto","ZAKA_PURE_V1","ZakaPureUI","ZakaNarutoUI"}) do
        local o = PlayerGui:FindFirstChild(n)
        if o then o:Destroy() end
    end
end)

local Settings = {
    Aimbot = false,
    AimbotFOV = 120,
    AimbotSmooth = 0.22,
    SilentAim = false,
    AutoClicker = false,
    ClickDelay = 0.05,
    TargetStrafe = false,
    StrafeDistance = 12,
    StrafeSpeed = 6,
    SpinBot = false,
    SpinSpeed = 45,
    HitboxHead = false,
    HeadSize = 15,
    HitboxTorso = false,
    TorsoSize = Vector3.new(4,6,4),
    HitboxWeapon = false,
    WeaponSize = 5,
    HitboxTransparent = 0.5,
    HitboxLimb = false,
    LimbSize = 4,
    ESP = false,
    ESPBox = true,
    ESPName = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPMaxDist = 3500,
    Chams = false,
    ChamsColor = Color3.fromRGB(0,200,255),
    CustomCrosshair = false,
    CrosshairSize = 12,
    GlowTrail = false,
    Fullbright = false,
    FOVChanger = false,
    FOVValue = 90,
    Speed = false,
    SpeedValue = 26,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    InfiniteJump = false,
    HighJump = false,
    JumpPower = 100,
    Bhop = false,
    SpiderClimb = false,
    SpiderSpeed = 30,
    WaterWalk = false,
    TouchTP = false,
    BringNPC = false,
    GravityMod = false,
    GravityValue = 196.2,
    ChatSpammer = false,
    SpamMessage = "Zaka • Naruto",
    SpamDelay = 2,
}

local NoclipConn, SpeedConn, FlyConn, TouchTPConn, AutoClickConn, SpamConn, StrafeConn, WaterConn, SpiderConn
local BodyGyro, BodyVelocity
local ESPObjects, ChamsObjects = {}, {}
local OriginalAmbient = Lighting.Ambient
local OriginalGravity = Workspace.Gravity

LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

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
    if Settings.GravityMod then Workspace.Gravity = Settings.GravityValue else Workspace.Gravity = OriginalGravity end
    if Settings.SpinBot and char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
    end
    if Settings.Bhop then
        local hum = char and char:FindFirstChildOfClass("Humanoid")
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
                    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0,3.5,0)) end
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
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local ray = Ray.new(root.Position, Vector3.new(0,-6,0))
                local _, pos, _, mat = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
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
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local ray = Ray.new(root.Position, root.CFrame.LookVector * 3)
                if Workspace:FindPartOnRay(ray, LocalPlayer.Character) then
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
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj \~= LocalPlayer.Character then
                        local hum = obj:FindFirstChildOfClass("Humanoid")
                        local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                        if hum and root and hum.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
                            root.CFrame = myRoot.CFrame * CFrame.new(0,0,-4)
                            root.Velocity = Vector3.zero
                        end
                    end
                end
            end
            task.wait(0.12)
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
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            local target, minDist = nil, 9999
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
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
    local char = LocalPlayer.Character
    if not char then return end
    if state then
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local a0 = Instance.new("Attachment", root)
        a0.Name = "TrailA0"
        a0.Position = Vector3.new(0,-2.2,0)
        local a1 = Instance.new("Attachment", root)
        a1.Name = "TrailA1"
        a1.Position = Vector3.new(0,-2.0,0)
        local trail = Instance.new("Trail")
        trail.Name = "PlayerGlowTrail"
        trail.Attachment0 = a0
        trail.Attachment1 = a1
        trail.Lifetime = 0.8
        trail.Color = ColorSequence.new(Color3.fromRGB(255,140,40), Color3.fromRGB(0,180,255))
        trail.Transparency = NumberSequence.new(0.1,1)
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

RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character then
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
                for _, n in ipairs({"Left Arm","Right Arm","Left Leg","Right Leg","LeftLowerArm","RightLowerArm","LeftLowerLeg","RightLowerLeg"}) do
                    local limb = char:FindFirstChild(n)
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
                        for _, p in ipairs(tool:GetDescendants()) do
                            if p:IsA("BasePart") then
                                p.Size = Vector3.new(Settings.WeaponSize, Settings.WeaponSize, Settings.WeaponSize)
                                p.Transparency = Settings.HitboxTransparent
                                p.CanCollide = false
                            end
                        end
                    end
                end
            end
        end
    end
end)

local DrawingOK = false
local FOVCircle, CrossV, CrossH
pcall(function()
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1.5
    FOVCircle.NumSides = 64
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Filled = false
    FOVCircle.Visible = false
    FOVCircle.Color = Color3.fromRGB(255,140,40)
    CrossV = Drawing.new("Line")
    CrossH = Drawing.new("Line")
    DrawingOK = true
end)

local function ClosestHead()
    local best, short = nil, Settings.AimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local sp, on = Camera:WorldToViewportPoint(head.Position)
                if on then
                    local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                    if d < short then short = d best = head end
                end
            end
        end
    end
    return best
end

pcall(function()
    local old
    old = hookmetamethod(game, "__index", function(self, key)
        if not checkcaller() and Settings.SilentAim and self == Mouse and tostring(key) == "Hit" then
            local t = ClosestHead()
            if t then return t.CFrame end
        end
        return old(self, key)
    end)
end)

RunService.RenderStepped:Connect(function()
    if not DrawingOK then return end
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Position = center
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Visible = Settings.Aimbot or Settings.SilentAim
    if Settings.CustomCrosshair then
        local s = Settings.CrosshairSize
        CrossV.From = Vector2.new(center.X, center.Y - s)
        CrossV.To = Vector2.new(center.X, center.Y + s)
        CrossV.Color = Color3.fromRGB(255,180,60)
        CrossV.Thickness = 2
        CrossV.Visible = true
        CrossH.From = Vector2.new(center.X - s, center.Y)
        CrossH.To = Vector2.new(center.X + s, center.Y)
        CrossH.Color = Color3.fromRGB(255,180,60)
        CrossH.Thickness = 2
        CrossH.Visible = true
    else
        CrossV.Visible = false
        CrossH.Visible = false
    end
    if Settings.Aimbot then
        local t = ClosestHead()
        if t then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Position), Settings.AimbotSmooth)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character then
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
    if not Settings.ESP or not DrawingOK then
        for _, d in pairs(ESPObjects) do for _, x in pairs(d) do pcall(function() x.Visible = false end) end end
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if not ESPObjects[plr] then
            local ok1, box = pcall(Drawing.new, "Square")
            local ok2, name = pcall(Drawing.new, "Text")
            local ok3, hp = pcall(Drawing.new, "Text")
            local ok4, dist = pcall(Drawing.new, "Text")
            if ok1 and ok2 and ok3 and ok4 then
                ESPObjects[plr] = {Box = box, Name = name, Health = hp, Distance = dist}
                box.Filled = false
                name.Size = 12 name.Center = true name.Outline = true
                hp.Size = 11 hp.Center = true hp.Outline = true
                dist.Size = 11 dist.Center = true dist.Outline = true
            end
        end
        local d = ESPObjects[plr]
        if not d then continue end
        local char = plr.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
            for _, x in pairs(d) do pcall(function() x.Visible = false end) end
            continue
        end
        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        local pos, on = Camera:WorldToViewportPoint(root.Position)
        local dist = (root.Position - Camera.CFrame.Position).Magnitude
        if not on or dist > Settings.ESPMaxDist then
            for _, x in pairs(d) do pcall(function() x.Visible = false end) end
            continue
        end
        local size = Vector2.new(math.clamp(2000/pos.Z, 8, 300), math.clamp(3000/pos.Z, 12, 450))
        d.Box.Size = size
        d.Box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
        d.Box.Color = Color3.fromRGB(255,140,40)
        d.Box.Visible = Settings.ESPBox
        d.Name.Text = plr.Name
        d.Name.Position = Vector2.new(pos.X, pos.Y - size.Y/2 - 14)
        d.Name.Color = Color3.fromRGB(255,230,200)
        d.Name.Visible = Settings.ESPName
        d.Health.Text = math.floor(hum.Health) .. " HP"
        d.Health.Position = Vector2.new(pos.X, pos.Y + size.Y/2 + 2)
        d.Health.Visible = Settings.ESPHealth
        d.Distance.Text = math.floor(dist) .. "m"
        d.Distance.Position = Vector2.new(pos.X, pos.Y + size.Y/2 + 14)
        d.Distance.Visible = Settings.ESPDistance
    end
end)

local function StartFly()
    local char = LocalPlayer.Character
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
        local md = char.Humanoid.MoveDirection
        if md.Magnitude > 0 then
            local fv = (Camera.CFrame.LookVector * (md.Z * -1)) + (Camera.CFrame.RightVector * md.X)
            BodyVelocity.velocity = fv.Unit * Settings.FlySpeed
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
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = Settings.SpeedValue end
        end)
    else
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end

local function SetNoclip(state)
    if NoclipConn then NoclipConn:Disconnect() NoclipConn = nil end
    if state then
        NoclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    end
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "ZakaNaruto"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local Accent = Color3.fromRGB(255,140,40)
local Accent2 = Color3.fromRGB(255,190,80)
local Dark = Color3.fromRGB(12,10,18)
local Panel = Color3.fromRGB(20,16,28)
local CardColor = Color3.fromRGB(28,22,38)

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.fromOffset(62,62)
Toggle.Position = UDim2.new(0,16,0.42,0)
Toggle.BackgroundColor3 = Dark
Toggle.BackgroundTransparency = 0.05
Toggle.Text = "Z"
Toggle.Font = Enum.Font.GothamBlack
Toggle.TextSize = 26
Toggle.TextColor3 = Accent2
Toggle.AutoButtonColor = false
Toggle.ZIndex = 100
Toggle.Parent = Gui
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1,0)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Accent
ToggleStroke.Thickness = 2.4
ToggleStroke.Parent = Toggle

local hue = 0
RunService.RenderStepped:Connect(function()
    hue = (hue + 0.8) % 360
    ToggleStroke.Color = Color3.fromHSV(hue/360, 0.85, 1)
end)

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(0,0)
Main.Position = UDim2.new(0.5,0,0.5,0)
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.BackgroundColor3 = Dark
Main.BackgroundTransparency = 0.08
Main.Visible = false
Main.ClipsDescendants = true
Main.ZIndex = 50
Main.Parent = Gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,20)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Accent
MainStroke.Thickness = 1.8
MainStroke.Transparency = 0.25
MainStroke.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,58)
Header.BackgroundColor3 = Panel
Header.BackgroundTransparency = 0.25
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0,20)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-70,0,28)
Title.Position = UDim2.fromOffset(18,8)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA • NARUTO"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextColor3 = Accent2
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Sub = Instance.new("TextLabel")
Sub.Size = UDim2.new(1,-70,0,16)
Sub.Position = UDim2.fromOffset(18,34)
Sub.BackgroundTransparency = 1
Sub.Text = "FULL POWER  •  6 TABS  •  ALL SKILLS"
Sub.Font = Enum.Font.GothamBold
Sub.TextSize = 11
Sub.TextColor3 = Color3.fromRGB(180,150,120)
Sub.TextXAlignment = Enum.TextXAlignment.Left
Sub.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(34,34)
CloseBtn.Position = UDim2.new(1,-46,0,12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(60,30,40)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,10)

local TabFrame = Instance.new("ScrollingFrame")
TabFrame.Size = UDim2.new(0,118,1,-70)
TabFrame.Position = UDim2.fromOffset(12,66)
TabFrame.BackgroundTransparency = 1
TabFrame.ScrollBarThickness = 2
TabFrame.Parent = Main

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0,8)
TabLayout.Parent = TabFrame

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-145,1,-70)
Content.Position = UDim2.fromOffset(138,66)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true
Content.Parent = Main

local TabsData = {
    {Name = "Combat", Icon = "⚔"},
    {Name = "Hitbox", Icon = "🎯"},
    {Name = "Visual", Icon = "✦"},
    {Name = "Player", Icon = "◉"},
    {Name = "World", Icon = "◈"},
    {Name = "Troll", Icon = "⚡"},
}

local TabButtons, Pages = {}, {}
local CurrentTab = 1

local function CreateCard(parent, text, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1,0,0,48)
    card.BackgroundColor3 = CardColor
    card.BackgroundTransparency = 0.35
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0,12)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-70,1,0)
    label.Position = UDim2.fromOffset(14,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(235,230,220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(42,22)
    btn.Position = UDim2.new(1,-54,0.5,-11)
    btn.BackgroundColor3 = Color3.fromRGB(45,40,55)
    btn.Text = ""
    btn.Parent = card
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)

    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = on and Accent or Color3.fromRGB(45,40,55)
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {
            Transparency = on and 0.25 or 0.7
        }):Play()
        callback(on)
    end)

    card.BackgroundTransparency = 1
    TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
        BackgroundTransparency = 0.35
    }):Play()
end

for i, data in ipairs(TabsData) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,42)
    btn.BackgroundColor3 = Panel
    btn.BackgroundTransparency = 0.3
    btn.Text = data.Icon .. "  " .. data.Name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(170,150,140)
    btn.AutoButtonColor = false
    btn.Parent = TabFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,11)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1,0,1,0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Accent
    page.Visible = false
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.Parent = Content

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0,8)
    list.Parent = page
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0,0,0, list.AbsoluteContentSize.Y + 12)
    end)

    if i == 1 then
        CreateCard(page, "Aimbot Lock Head", function(v) Settings.Aimbot = v end)
        CreateCard(page, "Silent Aim Engine", function(v) Settings.SilentAim = v end)
        CreateCard(page, "Auto Clicker / Fast Attack", function(v) SetAutoClicker(v) end)
        CreateCard(page, "Target Strafe", function(v) SetTargetStrafe(v) end)
        CreateCard(page, "SpinBot", function(v) Settings.SpinBot = v end)
    elseif i == 2 then
        CreateCard(page, "Hitbox Head", function(v) Settings.HitboxHead = v end)
        CreateCard(page, "Hitbox Torso", function(v) Settings.HitboxTorso = v end)
        CreateCard(page, "Hitbox Limb", function(v) Settings.HitboxLimb = v end)
        CreateCard(page, "Hitbox Weapon", function(v) Settings.HitboxWeapon = v end)
    elseif i == 3 then
        CreateCard(page, "ESP Box", function(v) Settings.ESP = v end)
        CreateCard(page, "Chams Wallhack", function(v) Settings.Chams = v end)
        CreateCard(page, "Custom Crosshair", function(v) Settings.CustomCrosshair = v end)
        CreateCard(page, "Glow Trail", function(v) SetGlowTrail(v) end)
        CreateCard(page, "Fullbright", function(v) Settings.Fullbright = v end)
        CreateCard(page, "FOV Changer", function(v) Settings.FOVChanger = v end)
    elseif i == 4 then
        CreateCard(page, "Speed Walk", function(v) Settings.Speed = v SetSpeed(v) end)
        CreateCard(page, "Fly Mode", function(v) SetFly(v) end)
        CreateCard(page, "Noclip", function(v) Settings.Noclip = v SetNoclip(v) end)
        CreateCard(page, "Infinite Jump", function(v) Settings.InfiniteJump = v end)
        CreateCard(page, "High Jump", function(v) Settings.HighJump = v end)
        CreateCard(page, "Bunny Hop", function(v) Settings.Bhop = v end)
        CreateCard(page, "Spider Climb", function(v) SetSpiderClimb(v) end)
        CreateCard(page, "Water Walk", function(v) SetWaterWalk(v) end)
    elseif i == 5 then
        CreateCard(page, "Touch TP", function(v) SetTouchTP(v) end)
        CreateCard(page, "Bring NPC", function(v) SetBringNPC(v) end)
        CreateCard(page, "Gravity Mod", function(v) Settings.GravityMod = v end)
    elseif i == 6 then
        CreateCard(page, "Chat Spammer", function(v) SetChatSpammer(v) end)
    end

    TabButtons[i] = btn
    Pages[i] = page
end

local function SwitchTab(index)
    for i, btn in ipairs(TabButtons) do
        TweenService:Create(btn, TweenInfo.new(0.25), {
            BackgroundColor3 = Panel,
            TextColor3 = Color3.fromRGB(170,150,140)
        }):Play()
        Pages[i].Visible = false
    end
    TweenService:Create(TabButtons[index], TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        BackgroundColor3 = Accent,
        TextColor3 = Color3.new(1,1,1)
    }):Play()
    Pages[index].Visible = true
    CurrentTab = index
end

for i, btn in ipairs(TabButtons) do
    btn.MouseButton1Click:Connect(function()
        SwitchTab(i)
    end)
end
SwitchTab(1)

local isOpen = false

local function OpenMenu()
    if isOpen then return end
    isOpen = true
    Main.Visible = true
    Main.Size = UDim2.fromOffset(30,30)
    Main.BackgroundTransparency = 1
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(480, 540),
        BackgroundTransparency = 0.08
    }):Play()
end

local function CloseMenu()
    if not isOpen then return end
    isOpen = false
    TweenService:Create(Main, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Size = UDim2.fromOffset(30,30),
        BackgroundTransparency = 1
    }):Play()
    task.delay(0.35, function()
        if not isOpen then Main.Visible = false end
    end)
end

Toggle.MouseButton1Click:Connect(function()
    if isOpen then CloseMenu() else OpenMenu() end
end)
CloseBtn.MouseButton1Click:Connect(CloseMenu)

local dragging, dragStart, startPos
Toggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Toggle.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Toggle.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

task.wait(0.35)
OpenMenu()

print("✅ ZAKA • NARUTO LOADED")
print("6 Tabs | All Skills Active | Smooth Animation")
