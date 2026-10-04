--[[ ZAKA PURE UI v5.3 - DOUBLE ROUNDED + DRAG + DOORS ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Settings = {
    -- Combat
    Aimbot = false, AimbotFOV = 180, AimbotSmooth = 0.12,
    SilentAim = false, AutoTargetEntities = true,
    AutoClicker = false, ClickDelay = 0.03,
    TriggerBot = false, KillAura = false, KillAuraRange = 28,
    GodMode = false,

    -- Hitbox
    HitboxHead = false, HeadSize = 18,
    HitboxTorso = false, TorsoSize = Vector3.new(7,7,7),
    HitboxTransparent = 0.55,

    -- Visual / ESP
    ESPPlayer = false, ESPMob = false, ESPEntity = false,
    ESPBox = true, ESPName = true, ESPHealth = true, ESPDistance = true, ESPMaxDist = 2500,
    Fullbright = false, CustomCrosshair = false, CrosshairSize = 13,
    FOVChanger = false, FOVValue = 100,
    NoFog = false,

    -- Player
    Speed = false, SpeedValue = 70,
    Fly = false, FlySpeed = 75,
    Noclip = false, InfiniteJump = false,
    SpinBot = false, SpinSpeed = 45,
    HighJump = false, JumpPower = 140,

    -- World
    GravityMod = false, GravityValue = 40,
    BringMobs = false,

    -- Troll
    ChatSpammer = false, SpamMessage = "Zaka Pure UI v5.3", SpamDelay = 2.5,

    -- Doors Specific
    DoorsEntityESP = false,
    DoorsNoSeek = false,
    DoorsAutoHide = false,
    DoorsSpeedBoost = false,
    DoorsGod = false,
    DoorsSkipRoom = false,
}

local Connections = {}
local DrawESP = {Players = {}, Mobs = {}, Entities = {}}
local OriginalAmbient = Lighting.Ambient
local OriginalOutdoor = Lighting.OutdoorAmbient
local OriginalBright = Lighting.Brightness
local OriginalGravity = Workspace.Gravity
local OriginalFog = Lighting.FogEnd

local function safeDisconnect(name)
    local c = Connections[name]
    if c then
        if typeof(c) == "RBXScriptConnection" then pcall(function() c:Disconnect() end)
        elseif typeof(c) == "thread" then pcall(task.cancel, c) end
        Connections[name] = nil
    end
end

local function DisconnectAll()
    for k in pairs(Connections) do safeDisconnect(k) end
end

-- Anti AFK
Connections.AntiAFK = LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Infinite Jump
Connections.InfJump = UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump and LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Drawing
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5 FOVCircle.NumSides = 64 FOVCircle.Filled = false FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(0, 200, 255)

local CrossV = Drawing.new("Line")
local CrossH = Drawing.new("Line")

local function GetClosestTarget()
    local closest, short = nil, Settings.AimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local head = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
            if head then
                local pos, on = Camera:WorldToViewportPoint(head.Position)
                if on then
                    local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if d < short then short = d closest = head end
                end
            end
        end
    end

    if not closest and Settings.AutoTargetEntities then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj \~= LocalPlayer.Character and not Players:GetPlayerFromCharacter(obj) then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head") or obj.PrimaryPart
                if root and ((hum and hum.Health > 0) or obj:FindFirstChild("Entity") or string.find(string.lower(obj.Name), "rush") or string.find(string.lower(obj.Name), "ambush") or string.find(string.lower(obj.Name), "seek") or string.find(string.lower(obj.Name), "figure") or string.find(string.lower(obj.Name), "screech")) then
                    local pos, on = Camera:WorldToViewportPoint(root.Position)
                    if on then
                        local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if d < short then short = d closest = root end
                    end
                end
            end
        end
    end
    return closest
end

-- Silent Aim
local oldIndex
pcall(function()
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if not checkcaller() and Settings.SilentAim and self == Mouse and (key == "Hit" or key == "Target") then
            local t = GetClosestTarget()
            if t then
                if key == "Hit" then return t.CFrame end
                if key == "Target" then return t end
            end
        end
        return oldIndex(self, key)
    end)
end)

-- Fly mượt
local FlyLV, FlyAO
local function ToggleFly(state)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    if state then
        if FlyLV then FlyLV:Destroy() end
        if FlyAO then FlyAO:Destroy() end

        local att = root:FindFirstChild("ZakaFly") or Instance.new("Attachment")
        att.Name = "ZakaFly" att.Parent = root

        FlyLV = Instance.new("LinearVelocity")
        FlyLV.MaxForce = 1e9
        FlyLV.VectorVelocity = Vector3.zero
        FlyLV.Attachment0 = att
        FlyLV.RelativeTo = Enum.ActuatorRelativeTo.World
        FlyLV.Parent = root

        FlyAO = Instance.new("AlignOrientation")
        FlyAO.MaxTorque = 1e9
        FlyAO.Responsiveness = 200
        FlyAO.Mode = Enum.OrientationAlignmentMode.OneAttachment
        FlyAO.Attachment0 = att
        FlyAO.CFrame = Camera.CFrame
        FlyAO.Parent = root

        if hum then hum.PlatformStand = true end

        safeDisconnect("Fly")
        Connections.Fly = RunService.RenderStepped:Connect(function()
            if not Settings.Fly or not root.Parent then ToggleFly(false) return end
            FlyAO.CFrame = Camera.CFrame
            local dir = hum and hum.MoveDirection or Vector3.zero
            if dir.Magnitude > 0.05 then
                local v = (Camera.CFrame.LookVector * -dir.Z) + (Camera.CFrame.RightVector * dir.X)
                FlyLV.VectorVelocity = v.Unit * Settings.FlySpeed
            else
                FlyLV.VectorVelocity = Vector3.new(0, 0.08, 0)
            end
        end)
    else
        safeDisconnect("Fly")
        if FlyLV then FlyLV:Destroy() FlyLV = nil end
        if FlyAO then FlyAO:Destroy() FlyAO = nil end
        if hum then hum.PlatformStand = false end
    end
end

-- GodMode
Connections.God = RunService.Heartbeat:Connect(function()
    if (Settings.GodMode or Settings.DoorsGod) and LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h.Health = h.MaxHealth
            pcall(function()
                h:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            end)
        end
    end
end)

-- AutoClicker
Connections.Click = task.spawn(function()
    while true do
        if Settings.AutoClicker then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new())
            end)
        end
        task.wait(Settings.ClickDelay)
    end
end)

-- Trigger + KillAura
Connections.Combat = RunService.Heartbeat:Connect(function()
    if not (Settings.TriggerBot or Settings.KillAura) then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("Head")
            if tRoot then
                local dist = (tRoot.Position - root.Position).Magnitude
                if Settings.KillAura and dist <= Settings.KillAuraRange then
                    pcall(function()
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                    end)
                end
                if Settings.TriggerBot and dist < 90 then
                    local pos, on = Camera:WorldToViewportPoint(tRoot.Position)
                    if on then
                        local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                        if (Vector2.new(pos.X, pos.Y) - center).Magnitude < 45 then
                            VirtualUser:CaptureController()
                            VirtualUser:ClickButton1(Vector2.new())
                        end
                    end
                end
            end
        end
    end
end)

-- Chat Spam
Connections.Spam = task.spawn(function()
    while true do
        if Settings.ChatSpammer then
            pcall(function()
                local ch = TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                if ch then ch:SendAsync(Settings.SpamMessage)
                else
                    local ev = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
                    if ev and ev:FindFirstChild("SayMessageRequest") then
                        ev.SayMessageRequest:FireServer(Settings.SpamMessage, "All")
                    end
                end
            end)
        end
        task.wait(Settings.SpamDelay)
    end
end)

-- Bring Mobs
Connections.Bring = RunService.Heartbeat:Connect(function()
    if not Settings.BringMobs then return end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
            local mRoot = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if mRoot and hum and hum.Health > 0 and (mRoot.Position - root.Position).Magnitude < 100 then
                pcall(function() mRoot.CFrame = root.CFrame * CFrame.new(0, 0, -6) end)
            end
        end
    end
end)

-- Doors helpers
local function isDoorsEntity(name)
    name = string.lower(name or "")
    return string.find(name, "rush") or string.find(name, "ambush") or string.find(name, "seek") or
           string.find(name, "figure") or string.find(name, "screech") or string.find(name, "halt") or
           string.find(name, "eyes") or string.find(name, "lookman") or string.find(name, "snare") or
           string.find(name, "dupe") or string.find(name, "hide") or string.find(name, "entity")
end

Connections.Doors = RunService.Heartbeat:Connect(function()
    if Settings.DoorsNoSeek then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and string.find(string.lower(obj.Name), "seek") then
                pcall(function() obj:Destroy() end)
            end
        end
    end
    if Settings.NoFog then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
    end
end)

local function CreateDraw()
    local d = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Dist = Drawing.new("Text")
    }
    d.Box.Filled = false
    d.Name.Size = 13 d.Name.Center = true d.Name.Outline = true
    d.Health.Size = 12 d.Health.Center = true d.Health.Outline = true
    d.Dist.Size = 12 d.Dist.Center = true d.Dist.Outline = true
    return d
end

local function ClearDraw(d)
    if d then for _, v in pairs(d) do pcall(function() v:Remove() end) end end
end

-- Main Render
Connections.Render = RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    if hum then
        if Settings.Speed or Settings.DoorsSpeedBoost then
            hum.WalkSpeed = Settings.Speed and Settings.SpeedValue or 30
        end
        if Settings.HighJump then hum.JumpPower = Settings.JumpPower end
    end

    if Settings.Fullbright then
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = OriginalAmbient
        Lighting.OutdoorAmbient = OriginalOutdoor
        Lighting.Brightness = OriginalBright
    end

    if Settings.FOVChanger then Camera.FieldOfView = Settings.FOVValue end
    Workspace.Gravity = Settings.GravityMod and Settings.GravityValue or OriginalGravity

    if Settings.Noclip and char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end

    FOVCircle.Position = center
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Visible = Settings.Aimbot or Settings.SilentAim

    if Settings.CustomCrosshair then
        local s = Settings.CrosshairSize
        CrossV.From = Vector2.new(center.X, center.Y-s) CrossV.To = Vector2.new(center.X, center.Y+s)
        CrossV.Color = Color3.fromRGB(0,255,200) CrossV.Thickness = 2 CrossV.Visible = true
        CrossH.From = Vector2.new(center.X-s, center.Y) CrossH.To = Vector2.new(center.X+s, center.Y)
        CrossH.Color = Color3.fromRGB(0,255,200) CrossH.Thickness = 2 CrossH.Visible = true
    else
        CrossV.Visible = false CrossH.Visible = false
    end

    if Settings.Aimbot then
        local t = GetClosestTarget()
        if t then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Position), Settings.AimbotSmooth)
        end
    end

    if Settings.SpinBot and root then
        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
    end

    -- ESP Players
    if Settings.ESPPlayer then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr \~= LocalPlayer then
                if not DrawESP.Players[plr] then DrawESP.Players[plr] = CreateDraw() end
                local d = DrawESP.Players[plr]
                local pChar = plr.Character
                if pChar and pChar:FindFirstChild("HumanoidRootPart") and pChar.Humanoid and pChar.Humanoid.Health > 0 then
                    local pr = pChar.HumanoidRootPart
                    local pos, on = Camera:WorldToViewportPoint(pr.Position)
                    local dist = (pr.Position - Camera.CFrame.Position).Magnitude
                    if on and dist <= Settings.ESPMaxDist then
                        local sz = Vector2.new(math.clamp(1800/pos.Z, 8, 280), math.clamp(2800/pos.Z, 12, 420))
                        d.Box.Size = sz d.Box.Position = Vector2.new(pos.X-sz.X/2, pos.Y-sz.Y/2)
                        d.Box.Color = Color3.fromRGB(0,200,255) d.Box.Visible = Settings.ESPBox
                        d.Name.Text = plr.Name d.Name.Position = Vector2.new(pos.X, pos.Y-sz.Y/2-15)
                        d.Name.Color = Color3.new(1,1,1) d.Name.Visible = Settings.ESPName
                        d.Health.Text = math.floor(pChar.Humanoid.Health).." HP"
                        d.Health.Position = Vector2.new(pos.X, pos.Y+sz.Y/2+2)
                        d.Health.Color = Color3.fromRGB(0,255,120) d.Health.Visible = Settings.ESPHealth
                        d.Dist.Text = math.floor(dist).."m"
                        d.Dist.Position = Vector2.new(pos.X, pos.Y+sz.Y/2+15)
                        d.Dist.Color = Color3.fromRGB(200,200,200) d.Dist.Visible = Settings.ESPDistance
                    else for _,v in pairs(d) do v.Visible = false end end
                else for _,v in pairs(d) do v.Visible = false end end
            end
        end
    else
        for _, d in pairs(DrawESP.Players) do for _,v in pairs(d) do v.Visible = false end end
    end

    -- ESP Mob + Doors Entity
    if Settings.ESPMob or Settings.ESPEntity or Settings.DoorsEntityESP then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj \~= LocalPlayer.Character and not Players:GetPlayerFromCharacter(obj) then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local mr = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head") or obj.PrimaryPart
                local isEnt = isDoorsEntity(obj.Name) or obj:FindFirstChild("Entity")
                if mr and (hum or isEnt or Settings.ESPEntity) then
                    if not DrawESP.Mobs[obj] then DrawESP.Mobs[obj] = CreateDraw() end
                    local d = DrawESP.Mobs[obj]
                    local pos, on = Camera:WorldToViewportPoint(mr.Position)
                    local dist = (mr.Position - Camera.CFrame.Position).Magnitude
                    if on and dist <= Settings.ESPMaxDist then
                        local sz = Vector2.new(math.clamp(1600/pos.Z, 6, 220), math.clamp(2400/pos.Z, 10, 340))
                        d.Box.Size = sz d.Box.Position = Vector2.new(pos.X-sz.X/2, pos.Y-sz.Y/2)
                        d.Box.Color = isEnt and Color3.fromRGB(255,80,80) or Color3.fromRGB(255,140,40)
                        d.Box.Visible = Settings.ESPBox
                        d.Name.Text = (isEnt and "[ENTITY] " or "") .. obj.Name
                        d.Name.Position = Vector2.new(pos.X, pos.Y-sz.Y/2-15)
                        d.Name.Color = Color3.fromRGB(255,120,120) d.Name.Visible = Settings.ESPName
                        if hum then
                            d.Health.Text = math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)
                            d.Health.Position = Vector2.new(pos.X, pos.Y+sz.Y/2+2)
                            d.Health.Color = Color3.fromRGB(255,200,0) d.Health.Visible = Settings.ESPHealth
                        else d.Health.Visible = false end
                        d.Dist.Text = math.floor(dist).."m"
                        d.Dist.Position = Vector2.new(pos.X, pos.Y+sz.Y/2+15)
                        d.Dist.Color = Color3.fromRGB(220,220,220) d.Dist.Visible = Settings.ESPDistance
                    else for _,v in pairs(d) do v.Visible = false end end
                end
            end
        end
    else
        for _, d in pairs(DrawESP.Mobs) do for _,v in pairs(d) do v.Visible = false end end
    end

    -- Hitbox
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character then
            local c = plr.Character
            if Settings.HitboxHead and c:FindFirstChild("Head") then
                c.Head.Size = Vector3.new(Settings.HeadSize, Settings.HeadSize, Settings.HeadSize)
                c.Head.Transparency = Settings.HitboxTransparent
                c.Head.CanCollide = false
            end
            if Settings.HitboxTorso then
                local t = c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso")
                if t then
                    t.Size = Settings.TorsoSize
                    t.Transparency = Settings.HitboxTransparent
                    t.CanCollide = false
                end
            end
        end
    end
end)

-- ====================== UI DOUBLE ROUNDED + DRAG ======================
pcall(function() if PlayerGui:FindFirstChild("ZakaPureUI") then PlayerGui.ZakaPureUI:Destroy() end end)

local SG = Instance.new("ScreenGui")
SG.Name = "ZakaPureUI"
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.DisplayOrder = 999
SG.Parent = PlayerGui

-- Toggle button
local ToggleOuter = Instance.new("Frame")
ToggleOuter.Size = UDim2.new(0, 52, 0, 52)
ToggleOuter.Position = UDim2.new(0, 12, 0.4, 0)
ToggleOuter.BackgroundColor3 = Color3.fromRGB(8, 12, 18)
ToggleOuter.Parent = SG
Instance.new("UICorner", ToggleOuter).CornerRadius = UDim.new(1, 0)
local tos = Instance.new("UIStroke", ToggleOuter)
tos.Color = Color3.fromRGB(0, 180, 255) tos.Thickness = 2 tos.Transparency = 0.25

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(1, -6, 1, -6)
Toggle.Position = UDim2.new(0, 3, 0, 3)
Toggle.BackgroundColor3 = Color3.fromRGB(0, 155, 235)
Toggle.Text = "Z"
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 22
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.Parent = ToggleOuter
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

-- Main Outer (bo góc 2 lớp)
local MainOuter = Instance.new("Frame")
MainOuter.Size = UDim2.new(0, 540, 0, 400)
MainOuter.Position = UDim2.new(0.5, -270, 0.5, -200)
MainOuter.BackgroundColor3 = Color3.fromRGB(6, 9, 14)
MainOuter.Visible = false
MainOuter.ClipsDescendants = true
MainOuter.Parent = SG
Instance.new("UICorner", MainOuter).CornerRadius = UDim.new(0, 18)
local mos = Instance.new("UIStroke", MainOuter)
mos.Color = Color3.fromRGB(0, 170, 255) mos.Thickness = 1.6 mos.Transparency = 0.28

local MainInner = Instance.new("Frame")
MainInner.Size = UDim2.new(1, -10, 1, -10)
MainInner.Position = UDim2.new(0, 5, 0, 5)
MainInner.BackgroundColor3 = Color3.fromRGB(12, 16, 24)
MainInner.Parent = MainOuter
Instance.new("UICorner", MainInner).CornerRadius = UDim.new(0, 14)

-- Header (kéo được)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Color3.fromRGB(8, 11, 17)
Header.Parent = MainInner
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA PURE  v5.3  |  DOORS+"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextColor3 = Color3.fromRGB(230, 240, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseOuter = Instance.new("Frame")
CloseOuter.Size = UDim2.new(0, 28, 0, 28)
CloseOuter.Position = UDim2.new(1, -36, 0.5, -14)
CloseOuter.BackgroundColor3 = Color3.fromRGB(40, 12, 12)
CloseOuter.Parent = Header
Instance.new("UICorner", CloseOuter).CornerRadius = UDim.new(1, 0)

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(1, -4, 1, -4)
Close.Position = UDim2.new(0, 2, 0, 2)
Close.BackgroundColor3 = Color3.fromRGB(230, 55, 55)
Close.Text = "×"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 17
Close.TextColor3 = Color3.new(1,1,1)
Close.Parent = CloseOuter
Instance.new("UICorner", Close).CornerRadius = UDim.new(1, 0)

-- Drag
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainOuter.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainOuter.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Tab Outer (bo góc 2 lớp)
local TabOuter = Instance.new("Frame")
TabOuter.Size = UDim2.new(0, 118, 1, -52)
TabOuter.Position = UDim2.new(0, 8, 0, 46)
TabOuter.BackgroundColor3 = Color3.fromRGB(8, 11, 17)
TabOuter.Parent = MainInner
Instance.new("UICorner", TabOuter).CornerRadius = UDim.new(0, 12)
local tos2 = Instance.new("UIStroke", TabOuter)
tos2.Color = Color3.fromRGB(0, 160, 240) tos2.Thickness = 1 tos2.Transparency = 0.7

local TabInner = Instance.new("Frame")
TabInner.Size = UDim2.new(1, -6, 1, -6)
TabInner.Position = UDim2.new(0, 3, 0, 3)
TabInner.BackgroundColor3 = Color3.fromRGB(14, 18, 26)
TabInner.Parent = TabOuter
Instance.new("UICorner", TabInner).CornerRadius = UDim.new(0, 10)

local TabFrame = Instance.new("ScrollingFrame")
TabFrame.Size = UDim2.new(1, -4, 1, -6)
TabFrame.Position = UDim2.new(0, 2, 0, 3)
TabFrame.BackgroundTransparency = 1
TabFrame.ScrollBarThickness = 2
TabFrame.Parent = TabInner
local TabList = Instance.new("UIListLayout", TabFrame)
TabList.Padding = UDim.new(0, 4)
TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabFrame.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y + 6)
end)

-- Content Outer (bo góc 2 lớp)
local ContentOuter = Instance.new("Frame")
ContentOuter.Size = UDim2.new(1, -136, 1, -52)
ContentOuter.Position = UDim2.new(0, 130, 0, 46)
ContentOuter.BackgroundColor3 = Color3.fromRGB(8, 11, 17)
ContentOuter.Parent = MainInner
Instance.new("UICorner", ContentOuter).CornerRadius = UDim.new(0, 12)
local cos = Instance.new("UIStroke", ContentOuter)
cos.Color = Color3.fromRGB(0, 160, 240) cos.Thickness = 1 cos.Transparency = 0.7

local ContentInner = Instance.new("Frame")
ContentInner.Size = UDim2.new(1, -6, 1, -6)
ContentInner.Position = UDim2.new(0, 3, 0, 3)
ContentInner.BackgroundColor3 = Color3.fromRGB(14, 18, 26)
ContentInner.Parent = ContentOuter
Instance.new("UICorner", ContentInner).CornerRadius = UDim.new(0, 10)

local SearchOuter = Instance.new("Frame")
SearchOuter.Size = UDim2.new(1, -10, 0, 30)
SearchOuter.Position = UDim2.new(0, 5, 0, 5)
SearchOuter.BackgroundColor3 = Color3.fromRGB(10, 13, 19)
SearchOuter.Parent = ContentInner
Instance.new("UICorner", SearchOuter).CornerRadius = UDim.new(0, 9)

local Search = Instance.new("TextBox")
Search.Size = UDim2.new(1, -8, 1, -4)
Search.Position = UDim2.new(0, 4, 0, 2)
Search.BackgroundColor3 = Color3.fromRGB(20, 25, 36)
Search.PlaceholderText = "🔍  Tìm kỹ năng..."
Search.PlaceholderColor3 = Color3.fromRGB(120, 135, 155)
Search.Text = ""
Search.TextColor3 = Color3.new(1,1,1)
Search.Font = Enum.Font.Gotham
Search.TextSize = 12
Search.Parent = SearchOuter
Instance.new("UICorner", Search).CornerRadius = UDim.new(0, 7)

local PageHolder = Instance.new("Frame")
PageHolder.Size = UDim2.new(1, -10, 1, -42)
PageHolder.Position = UDim2.new(0, 5, 0, 38)
PageHolder.BackgroundTransparency = 1
PageHolder.Parent = ContentInner

local TabsData = {
    {n = "Combat", i = "⚔"},
    {n = "Hitbox", i = "🎯"},
    {n = "Visual", i = "✦"},
    {n = "Player", i = "◉"},
    {n = "World",  i = "◈"},
    {n = "Doors",  i = "🚪"},
    {n = "Troll",  i = "⚡"},
    {n = "Set",    i = "⚙"},
}

local TabBtns, Pages, Cards = {}, {}, {}
local Cur = 1

-- Card bo góc 2 lớp
local function MakeCard(parent, text, def, cb, extraLabel, extraCb)
    local outer = Instance.new("Frame")
    outer.Size = UDim2.new(1, 0, 0, extraLabel and 62 or 36)
    outer.BackgroundColor3 = Color3.fromRGB(10, 13, 19)
    outer.Parent = parent
    Instance.new("UICorner", outer).CornerRadius = UDim.new(0, 10)
    local os = Instance.new("UIStroke", outer)
    os.Color = Color3.fromRGB(0, 160, 240) os.Thickness = 1 os.Transparency = 0.78

    local inner = Instance.new("Frame")
    inner.Size = UDim2.new(1, -4, 1, -4)
    inner.Position = UDim2.new(0, 2, 0, 2)
    inner.BackgroundColor3 = Color3.fromRGB(20, 26, 38)
    inner.Parent = outer
    Instance.new("UICorner", inner).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -52, 0, 32)
    lbl.Position = UDim2.new(0, 9, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.TextColor3 = Color3.fromRGB(225, 235, 250)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = inner

    local tgOuter = Instance.new("Frame")
    tgOuter.Size = UDim2.new(0, 36, 0, 18)
    tgOuter.Position = UDim2.new(1, -44, 0, 7)
    tgOuter.BackgroundColor3 = def and Color3.fromRGB(0, 165, 245) or Color3.fromRGB(35, 42, 55)
    tgOuter.Parent = inner
    Instance.new("UICorner", tgOuter).CornerRadius = UDim.new(1, 0)

    local tg = Instance.new("TextButton")
    tg.Size = UDim2.new(1, 0, 1, 0)
    tg.BackgroundTransparency = 1
    tg.Text = ""
    tg.Parent = tgOuter

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = def and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    dot.BackgroundColor3 = Color3.new(1,1,1)
    dot.Parent = tgOuter
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local on = def
    tg.MouseButton1Click:Connect(function()
        on = not on
        TweenService:Create(tgOuter, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
            BackgroundColor3 = on and Color3.fromRGB(0, 165, 245) or Color3.fromRGB(35, 42, 55)
        }):Play()
        TweenService:Create(dot, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
            Position = on and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        }):Play()
        if cb then cb(on) end
    end)

    if extraLabel and extraCb then
        local il = Instance.new("TextLabel")
        il.Size = UDim2.new(0.55, 0, 0, 18)
        il.Position = UDim2.new(0, 9, 0, 34)
        il.BackgroundTransparency = 1
        il.Text = extraLabel
        il.Font = Enum.Font.Gotham
        il.TextSize = 10
        il.TextColor3 = Color3.fromRGB(145, 160, 180)
        il.TextXAlignment = Enum.TextXAlignment.Left
        il.Parent = inner

        local boxOuter = Instance.new("Frame")
        boxOuter.Size = UDim2.new(0.36, -6, 0, 18)
        boxOuter.Position = UDim2.new(0.6, 0, 0, 34)
        boxOuter.BackgroundColor3 = Color3.fromRGB(8, 11, 16)
        boxOuter.Parent = inner
        Instance.new("UICorner", boxOuter).CornerRadius = UDim.new(0, 6)

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -4, 1, -4)
        box.Position = UDim2.new(0, 2, 0, 2)
        box.BackgroundColor3 = Color3.fromRGB(16, 22, 32)
        box.Text = "100"
        box.TextColor3 = Color3.fromRGB(0, 220, 255)
        box.Font = Enum.Font.GothamBold
        box.TextSize = 11
        box.Parent = boxOuter
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
        box.FocusLost:Connect(function()
            local n = tonumber(box.Text)
            if n then extraCb(n) end
        end)
    end

    table.insert(Cards, {f = outer, t = text:lower(), p = parent})
    return outer
end

for i, t in ipairs(TabsData) do
    local bOuter = Instance.new("Frame")
    bOuter.Size = UDim2.new(1, 0, 0, 32)
    bOuter.BackgroundColor3 = Color3.fromRGB(10, 13, 19)
    bOuter.Parent = TabFrame
    Instance.new("UICorner", bOuter).CornerRadius = UDim.new(0, 9)

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -4, 1, -4)
    b.Position = UDim2.new(0, 2, 0, 2)
    b.BackgroundColor3 = Color3.fromRGB(20, 26, 38)
    b.Text = t.i.."  "..t.n
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 11
    b.TextColor3 = Color3.fromRGB(150, 160, 180)
    b.Parent = bOuter
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.Visible = false
    page.Parent = PageHolder
    local lay = Instance.new("UIListLayout", page)
    lay.Padding = UDim.new(0, 5)
    lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y + 8)
    end)

    if i == 1 then -- Combat
        MakeCard(page, "GodMode Bất Tử", false, function(v) Settings.GodMode = v end)
        MakeCard(page, "Silent Aim", false, function(v) Settings.SilentAim = v end)
        MakeCard(page, "Auto Target Entity", true, function(v) Settings.AutoTargetEntities = v end)
        MakeCard(page, "Aimbot", false, function(v) Settings.Aimbot = v end, "FOV:", function(v) Settings.AimbotFOV = v end)
        MakeCard(page, "Auto Clicker", false, function(v) Settings.AutoClicker = v end)
        MakeCard(page, "TriggerBot", false, function(v) Settings.TriggerBot = v end)
        MakeCard(page, "KillAura", false, function(v) Settings.KillAura = v end, "Range:", function(v) Settings.KillAuraRange = v end)
    elseif i == 2 then -- Hitbox
        MakeCard(page, "Hitbox Đầu", false, function(v) Settings.HitboxHead = v end, "Size:", function(v) Settings.HeadSize = v end)
        MakeCard(page, "Hitbox Thân", false, function(v) Settings.HitboxTorso = v end)
    elseif i == 3 then -- Visual
        MakeCard(page, "ESP Player", false, function(v) Settings.ESPPlayer = v end)
        MakeCard(page, "ESP Mob", false, function(v) Settings.ESPMob = v end)
        MakeCard(page, "ESP Entity", false, function(v) Settings.ESPEntity = v end)
        MakeCard(page, "Fullbright", false, function(v) Settings.Fullbright = v end)
        MakeCard(page, "No Fog", false, function(v) Settings.NoFog = v if not v then Lighting.FogEnd = OriginalFog end end)
        MakeCard(page, "Crosshair", false, function(v) Settings.CustomCrosshair = v end)
        MakeCard(page, "FOV Changer", false, function(v) Settings.FOVChanger = v end, "FOV:", function(v) Settings.FOVValue = v end)
    elseif i == 4 then -- Player
        MakeCard(page, "Fly Mượt", false, function(v) Settings.Fly = v ToggleFly(v) end, "Speed:", function(v) Settings.FlySpeed = v end)
        MakeCard(page, "Speed", false, function(v) Settings.Speed = v end, "Value:", function(v) Settings.SpeedValue = v end)
        MakeCard(page, "High Jump", false, function(v) Settings.HighJump = v end, "Power:", function(v) Settings.JumpPower = v end)
        MakeCard(page, "Infinite Jump", false, function(v) Settings.InfiniteJump = v end)
        MakeCard(page, "Noclip", false, function(v) Settings.Noclip = v end)
    elseif i == 5 then -- World
        MakeCard(page, "Gravity", false, function(v) Settings.GravityMod = v end, "Value:", function(v) Settings.GravityValue = v end)
        MakeCard(page, "Bring Mobs", false, function(v) Settings.BringMobs = v end)
    elseif i == 6 then -- Doors
        MakeCard(page, "Doors Entity ESP", false, function(v) Settings.DoorsEntityESP = v end)
        MakeCard(page, "Doors GodMode", false, function(v) Settings.DoorsGod = v end)
        MakeCard(page, "Doors Speed Boost", false, function(v) Settings.DoorsSpeedBoost = v end)
        MakeCard(page, "No Seek (xóa Seek)", false, function(v) Settings.DoorsNoSeek = v end)
        MakeCard(page, "Auto Hide (thử nghiệm)", false, function(v) Settings.DoorsAutoHide = v end)
    elseif i == 7 then -- Troll
        MakeCard(page, "SpinBot", false, function(v) Settings.SpinBot = v end, "Speed:", function(v) Settings.SpinSpeed = v end)
        MakeCard(page, "Spam Chat", false, function(v) Settings.ChatSpammer = v end)
    elseif i == 8 then -- Set
        MakeCard(page, "Unload UI", false, function(v)
            if v then
                ToggleFly(false)
                DisconnectAll()
                pcall(function() FOVCircle:Remove() end)
                pcall(function() CrossV:Remove() end)
                pcall(function() CrossH:Remove() end)
                for _, d in pairs(DrawESP.Players) do ClearDraw(d) end
                for _, d in pairs(DrawESP.Mobs) do ClearDraw(d) end
                SG:Destroy()
            end
        end)
    end

    TabBtns[i] = {outer = bOuter, btn = b}
    Pages[i] = page
end

local function Switch(i)
    if Cur == i then return end
    TweenService:Create(TabBtns[Cur].btn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(20, 26, 38),
        TextColor3 = Color3.fromRGB(150, 160, 180)
    }):Play()
    TweenService:Create(TabBtns[i].btn, TweenInfo.new(0.28, Enum.EasingStyle.Back), {
        BackgroundColor3 = Color3.fromRGB(0, 160, 240),
        TextColor3 = Color3.new(1,1,1)
    }):Play()
    Pages[Cur].Visible = false
    Pages[i].Visible = true
    Cur = i
end

for i, data in ipairs(TabBtns) do
    data.btn.MouseButton1Click:Connect(function() Switch(i) end)
end
TabBtns[1].btn.BackgroundColor3 = Color3.fromRGB(0, 160, 240)
TabBtns[1].btn.TextColor3 = Color3.new(1,1,1)
Pages[1].Visible = true

Search:GetPropertyChangedSignal("Text"):Connect(function()
    local k = Search.Text:lower()
    for _, c in ipairs(Cards) do
        if c.p.Visible then
            c.f.Visible = (k == "" or string.find(c.t, k))
        end
    end
end)

local open = false
local function ToggleMenu()
    open = not open
    if open then
        MainOuter.Visible = true
        MainOuter.Size = UDim2.new(0, 0, 0, 0)
        MainOuter.Position = UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(MainOuter, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 540, 0, 400),
            Position = UDim2.new(0.5, -270, 0.5, -200)
        }):Play()
    else
        local tw = TweenService:Create(MainOuter, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        tw:Play()
        tw.Completed:Connect(function() if not open then MainOuter.Visible = false end end)
    end
end

Toggle.MouseButton1Click:Connect(ToggleMenu)
Close.MouseButton1Click:Connect(ToggleMenu)

print("✅ Zaka Pure UI v5.3 Double Rounded + Drag + Doors loaded")
