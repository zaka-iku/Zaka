--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║              ZAKA HUD v3.5 - FULL COMPLETE                   ║
    ║     Logo Z + Dragon + Auto Open Menu + Full Features         ║
    ╚══════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================== SETTINGS ====================--
local Settings = {
    -- Combat
    Aimbot = false, AimbotFOV = 130, AimbotSmooth = 0.15,
    AimbotTeamCheck = true, AimbotWallCheck = true,
    NPCAimbot = false, NPCAimbotFOV = 140, NPCAimbotSmooth = 0.14,
    Hitbox = false, HitboxSize = 11,
    TriggerBot = false, AutoClicker = false,

    -- ESP
    ESP = false, ESPBox = true, ESPName = true, ESPHealth = true,
    ESPDistance = true, ESPTracer = false, ESPMaxDist = 2500, ESPTeamCheck = false,
    NPCESP = false,

    -- Player
    Speed = false, SpeedValue = 28,
    Fly = false, FlySpeed = 75,
    Noclip = false, InfiniteJump = false, ClickTP = false, BunnyHop = false,
    GodMode = false, InfiniteAmmo = false, VehicleSpeed = false, VehicleSpeedValue = 150,

    -- Visuals / Magic
    Fullbright = false, FireAura = false, IceAura = false, ElectricAura = false,
    RainbowBody = false, HeadLight = false,

    -- Misc
    SpinBot = false, Fling = false, Invisible = false, AntiAFK = true,
}

--==================== VARIABLES ====================--
local Flying = false
local BodyVelocity, BodyGyro
local NoclipConn, SpeedConn, HitboxConn, GodConn, RainbowConn, VehicleConn, SpinConn
local CapeModel, CapeConn
local ESPObjects, NPCESPObjects = {}, {}
local MagicConns = {}
local OriginalSizes = {}

--==================== ANTI AFK ====================--
LocalPlayer.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

--==================== SUPERMAN FLY + CAPE ====================--
local function CreateCape(char)
    if CapeModel then CapeModel:Destroy() end
    if CapeConn then CapeConn:Disconnect() end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not torso or not root then return end

    CapeModel = Instance.new("Model")
    CapeModel.Name = "ZakaCape"
    local cape = Instance.new("Part")
    cape.Size = Vector3.new(2.3, 3.5, 0.14)
    cape.Color = Color3.fromRGB(170, 15, 15)
    cape.Material = Enum.Material.Fabric
    cape.CanCollide = false
    cape.Massless = true
    cape.Parent = CapeModel

    local border = Instance.new("Part")
    border.Size = Vector3.new(2.5, 3.7, 0.07)
    border.Color = Color3.fromRGB(255, 210, 40)
    border.Material = Enum.Material.Neon
    border.Transparency = 0.25
    border.CanCollide = false
    border.Massless = true
    border.Parent = CapeModel

    local bw = Instance.new("Weld")
    bw.Part0 = cape
    bw.Part1 = border
    bw.C0 = CFrame.new(0, 0, 0.03)
    bw.Parent = border

    local weld = Instance.new("Weld")
    weld.Part0 = torso
    weld.Part1 = cape
    weld.C0 = CFrame.new(0, 0.25, 1.15) * CFrame.Angles(math.rad(6), 0, 0)
    weld.Parent = cape
    CapeModel.Parent = char

    local base = weld.C0
    CapeConn = RunService.RenderStepped:Connect(function()
        if not cape or not cape.Parent then return end
        if Flying then
            weld.C0 = base * CFrame.Angles(math.rad(-18), math.sin(tick()*9)*0.18, 0)
        else
            weld.C0 = base * CFrame.Angles(math.rad(4), math.sin(tick()*2.2)*0.07, 0)
        end
    end)
end

local function RemoveCape()
    if CapeConn then CapeConn:Disconnect() CapeConn = nil end
    if CapeModel then CapeModel:Destroy() CapeModel = nil end
end

local function StartFly()
    if Flying then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    Flying = true
    local root = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = true end

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Parent = root
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.P = 4e4
    BodyGyro.Parent = root
    CreateCape(char)

    RunService:BindToRenderStep("ZakaFly", Enum.RenderPriority.Camera.Value, function()
        if not Flying or not root.Parent then return end
        local cam = Camera.CFrame
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
        BodyVelocity.Velocity = dir.Magnitude > 0 and dir.Unit * Settings.FlySpeed or Vector3.zero
        BodyGyro.CFrame = CFrame.new(root.Position, root.Position + cam.LookVector)
    end)
end

local function StopFly()
    Flying = false
    pcall(function() RunService:UnbindFromRenderStep("ZakaFly") end)
    if BodyVelocity then BodyVelocity:Destroy() end
    if BodyGyro then BodyGyro:Destroy() end
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = false end
    RemoveCape()
end

--==================== MOVEMENT ====================--
local function SetSpeed(v)
    if SpeedConn then SpeedConn:Disconnect() end
    if v then
        SpeedConn = RunService.Heartbeat:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = Settings.SpeedValue end
        end)
    else
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end

local function SetNoclip(v)
    if NoclipConn then NoclipConn:Disconnect() end
    if v then
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

UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump or Settings.BunnyHop then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

UserInputService.TouchTap:Connect(function(pos, gpe)
    if Settings.ClickTP and not gpe and pos[1] then
        local ray = Camera:ViewportPointToRay(pos[1].X, pos[1].Y)
        local hit, p = workspace:FindPartOnRayWithIgnoreList(Ray.new(ray.Origin, ray.Direction*2000), {LocalPlayer.Character})
        if hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(p + Vector3.new(0,4,0))
        end
    end
end)

local function SetGodMode(v)
    if GodConn then GodConn:Disconnect() end
    if v then
        GodConn = RunService.Heartbeat:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.MaxHealth = math.huge hum.Health = math.huge end
        end)
    end
end

--==================== INFINITE AMMO ====================--
local function SetInfiniteAmmo(state)
    Settings.InfiniteAmmo = state
    if state then
        task.spawn(function()
            while Settings.InfiniteAmmo do
                local char = LocalPlayer.Character
                if char then
                    for _, tool in ipairs(char:GetChildren()) do
                        if tool:IsA("Tool") then
                            pcall(function()
                                if tool:FindFirstChild("Ammo") then tool.Ammo.Value = 999 end
                                if tool:FindFirstChild("Clip") then tool.Clip.Value = 999 end
                                if tool:FindFirstChild("CurrentAmmo") then tool.CurrentAmmo.Value = 999 end
                            end)
                        end
                    end
                end
                task.wait(0.35)
            end
        end)
    end
end

--==================== VEHICLE SPEED ====================--
local function SetVehicleSpeed(state)
    Settings.VehicleSpeed = state
    if VehicleConn then VehicleConn:Disconnect() end
    if state then
        VehicleConn = RunService.Heartbeat:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.SeatPart then
                local vehicle = hum.SeatPart.Parent
                if vehicle then
                    pcall(function()
                        local seat = vehicle:FindFirstChildWhichIsA("VehicleSeat") or vehicle:FindFirstChild("VehicleSeat")
                        if seat then seat.MaxSpeed = Settings.VehicleSpeedValue end
                    end)
                end
            end
        end)
    end
end

--==================== VISUAL ====================--
local function SetFullbright(v)
    if v then
        Lighting.Brightness = 2.4
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1e5
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.FogEnd = 1000
        Lighting.GlobalShadows = true
    end
end

local function SetRainbowBody(v)
    if RainbowConn then RainbowConn:Disconnect() end
    if v then
        RainbowConn = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local color = Color3.fromHSV(tick()%5/5, 1, 1)
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.Name \~= "HumanoidRootPart" then p.Color = color end
            end
        end)
    end
end

--==================== AIMBOT ====================--
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(0, 180, 255)
FOVCircle.Transparency = 0.7
FOVCircle.Visible = false

local function GetClosestPlayer()
    local closest, short = nil, Settings.AimbotFOV
    local mouse = UserInputService:GetMouseLocation()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local head = plr.Character:FindFirstChild("Head")
            if hum and hum.Health > 0 and head then
                if Settings.AimbotTeamCheck and plr.Team == LocalPlayer.Team then continue end
                local sp, on = Camera:WorldToViewportPoint(head.Position)
                if on then
                    if Settings.AimbotWallCheck then
                        local ray = Ray.new(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 3000)
                        local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, Camera})
                        if hit and not hit:IsDescendantOf(plr.Character) then continue end
                    end
                    local d = (Vector2.new(sp.X, sp.Y) - mouse).Magnitude
                    if d < short then short = d closest = head end
                end
            end
        end
    end
    return closest
end

local function GetClosestNPC()
    local closest, short = nil, Settings.NPCAimbotFOV
    local mouse = UserInputService:GetMouseLocation()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj:FindFirstChild("Head") then
            if Players:GetPlayerFromCharacter(obj) then continue end
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local head = obj.Head
            if hum.Health <= 0 then continue end
            local sp, on = Camera:WorldToViewportPoint(head.Position)
            if on then
                local d = (Vector2.new(sp.X, sp.Y) - mouse).Magnitude
                if d < short then short = d closest = head end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius = Settings.Aimbot and Settings.AimbotFOV or Settings.NPCAimbotFOV
    FOVCircle.Visible = Settings.Aimbot or Settings.NPCAimbot

    if Settings.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = GetClosestPlayer()
        if t then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Position), Settings.AimbotSmooth) end
    end
    if Settings.NPCAimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = GetClosestNPC()
        if t then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Position), Settings.NPCAimbotSmooth) end
    end
end)

--==================== ESP ====================--
local function CreateESP(plr)
    if ESPObjects[plr] then return end
    local t = {
        Box = Drawing.new("Square"), Name = Drawing.new("Text"),
        Health = Drawing.new("Text"), Distance = Drawing.new("Text"), Tracer = Drawing.new("Line")
    }
    t.Box.Thickness = 1.2 t.Box.Filled = false t.Box.Color = Color3.fromRGB(0, 200, 255)
    t.Name.Size = 14 t.Name.Center = true t.Name.Outline = true t.Name.Color = Color3.fromRGB(255,255,255)
    t.Health.Size = 12 t.Health.Center = true t.Health.Outline = true
    t.Distance.Size = 12 t.Distance.Center = true t.Distance.Outline = true t.Distance.Color = Color3.fromRGB(200,200,200)
    t.Tracer.Thickness = 1.2 t.Tracer.Color = Color3.fromRGB(0, 180, 255)
    ESPObjects[plr] = t
end

Players.PlayerRemoving:Connect(function(plr)
    if ESPObjects[plr] then for _, d in pairs(ESPObjects[plr]) do pcall(function() d:Remove() end) end ESPObjects[plr] = nil end
end)

RunService.RenderStepped:Connect(function()
    if not Settings.ESP then
        for _, t in pairs(ESPObjects) do for _, d in pairs(t) do d.Visible = false end end
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if Settings.ESPTeamCheck and plr.Team == LocalPlayer.Team then
            if ESPObjects[plr] then for _, d in pairs(ESPObjects[plr]) do d.Visible = false end end
            continue
        end
        CreateESP(plr)
        local t = ESPObjects[plr]
        local char = plr.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChildOfClass("Humanoid") or char.Humanoid.Health <= 0 then
            for _, d in pairs(t) do d.Visible = false end continue
        end
        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        local pos, on = Camera:WorldToViewportPoint(root.Position)
        local dist = (root.Position - Camera.CFrame.Position).Magnitude
        if not on or dist > Settings.ESPMaxDist then for _, d in pairs(t) do d.Visible = false end continue end
        local scale = math.clamp(1000/pos.Z, 0.3, 4)
        local size = Vector2.new(34*scale, 52*scale)
        t.Box.Size = size t.Box.Position = Vector2.new(pos.X-size.X/2, pos.Y-size.Y/2) t.Box.Visible = Settings.ESPBox
        t.Name.Text = plr.Name t.Name.Position = Vector2.new(pos.X, pos.Y-size.Y/2-15) t.Name.Visible = Settings.ESPName
        t.Health.Text = math.floor(hum.Health).." HP" t.Health.Position = Vector2.new(pos.X, pos.Y+size.Y/2+2)
        t.Health.Color = Color3.fromRGB(255-(hum.Health/hum.MaxHealth)*255, (hum.Health/hum.MaxHealth)*255, 0) t.Health.Visible = Settings.ESPHealth
        t.Distance.Text = math.floor(dist).."m" t.Distance.Position = Vector2.new(pos.X, pos.Y+size.Y/2+15) t.Distance.Visible = Settings.ESPDistance
        t.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y) t.Tracer.To = Vector2.new(pos.X, pos.Y+size.Y/2) t.Tracer.Visible = Settings.ESPTracer
    end
end)

--==================== NPC ESP ====================--
RunService.RenderStepped:Connect(function()
    if not Settings.NPCESP then return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            if Players:GetPlayerFromCharacter(obj) then continue end
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum.Health <= 0 then continue end
            if not NPCESPObjects[obj] then
                NPCESPObjects[obj] = {
                    Box = Drawing.new("Square"),
                    Name = Drawing.new("Text")
                }
                NPCESPObjects[obj].Box.Thickness = 1.2
                NPCESPObjects[obj].Box.Color = Color3.fromRGB(255, 80, 80)
                NPCESPObjects[obj].Name.Size = 13
                NPCESPObjects[obj].Name.Center = true
                NPCESPObjects[obj].Name.Outline = true
                NPCESPObjects[obj].Name.Color = Color3.fromRGB(255, 180, 80)
            end
            local t = NPCESPObjects[obj]
            local root = obj.HumanoidRootPart
            local pos, on = Camera:WorldToViewportPoint(root.Position)
            if on then
                local scale = math.clamp(900/pos.Z, 0.25, 3.5)
                local size = Vector2.new(28*scale, 45*scale)
                t.Box.Size = size
                t.Box.Position = Vector2.new(pos.X-size.X/2, pos.Y-size.Y/2)
                t.Box.Visible = true
                t.Name.Text = obj.Name \~= "" and obj.Name or "NPC"
                t.Name.Position = Vector2.new(pos.X, pos.Y-size.Y/2-13)
                t.Name.Visible = true
            else
                t.Box.Visible = false
                t.Name.Visible = false
            end
        end
    end
end)

--==================== MAGIC ====================--
local function ClearMagic(name)
    if MagicConns[name] then MagicConns[name]:Disconnect() MagicConns[name] = nil end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("ZakaMagic") then
        local obj = char.ZakaMagic:FindFirstChild(name)
        if obj then obj:Destroy() end
    end
end

local function GetMagicFolder()
    local char = LocalPlayer.Character
    if not char then return end
    local f = char:FindFirstChild("ZakaMagic")
    if not f then f = Instance.new("Folder") f.Name = "ZakaMagic" f.Parent = char end
    return f
end

local function SetFireAura(v)
    ClearMagic("FireAura")
    if not v then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local folder = GetMagicFolder()
    local part = Instance.new("Part")
    part.Name = "FireAura" part.Size = Vector3.new(1,1,1) part.Transparency = 1
    part.CanCollide = false part.Anchored = true part.Parent = folder
    local fire = Instance.new("Fire")
    fire.Size = 7 fire.Heat = 11 fire.Color = Color3.fromRGB(255,110,20)
    fire.SecondaryColor = Color3.fromRGB(255,40,0) fire.Parent = part
    MagicConns["FireAura"] = RunService.RenderStepped:Connect(function()
        if char and char:FindFirstChild("HumanoidRootPart") then part.CFrame = char.HumanoidRootPart.CFrame end
    end)
end

local function SetIceAura(v)
    ClearMagic("IceAura")
    if not v then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local folder = GetMagicFolder()
    local part = Instance.new("Part")
    part.Name = "IceAura" part.Size = Vector3.new(5.5,0.25,5.5)
    part.Color = Color3.fromRGB(140,220,255) part.Material = Enum.Material.Ice
    part.Transparency = 0.35 part.CanCollide = false part.Anchored = true part.Parent = folder
    MagicConns["IceAura"] = RunService.RenderStepped:Connect(function()
        if char and char:FindFirstChild("HumanoidRootPart") then
            part.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0,-2.7,0) * CFrame.Angles(0,tick()*1.4,0)
        end
    end)
end

local function SetElectricAura(v)
    ClearMagic("ElectricAura")
    if not v then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local folder = GetMagicFolder()
    local part = Instance.new("Part")
    part.Name = "ElectricAura" part.Size = Vector3.new(1,1,1) part.Transparency = 1
    part.CanCollide = false part.Anchored = true part.Parent = folder
    local pe = Instance.new("ParticleEmitter")
    pe.Texture = "rbxassetid://243664672"
    pe.Color = ColorSequence.new(Color3.fromRGB(80,160,255), Color3.fromRGB(200,240,255))
    pe.Size = NumberSequence.new(0.35,0) pe.Lifetime = NumberRange.new(0.15,0.3)
    pe.Rate = 55 pe.Speed = NumberRange.new(5,12) pe.SpreadAngle = Vector2.new(180,180)
    pe.Parent = part
    MagicConns["ElectricAura"] = RunService.RenderStepped:Connect(function()
        if char and char:FindFirstChild("HumanoidRootPart") then part.CFrame = char.HumanoidRootPart.CFrame end
    end)
end

--==================== UI + LOGO Z CÓ RỒNG ====================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaHUDv35"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Nút Z + hiệu ứng rồng bao quanh
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 56, 0, 56)
OpenBtn.Position = UDim2.new(0, 14, 0.3, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
OpenBtn.Text = "Z"
OpenBtn.TextColor3 = Color3.fromRGB(255,255,255)
OpenBtn.TextSize = 26
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 200, 50)
stroke.Thickness = 2.5
stroke.Parent = OpenBtn

-- Vòng rồng xoay quanh nút Z
local DragonRing = Instance.new("Frame")
DragonRing.Size = UDim2.new(0, 78, 0, 78)
DragonRing.Position = UDim2.new(0.5, -39, 0.5, -39)
DragonRing.BackgroundTransparency = 1
DragonRing.Parent = OpenBtn

local dragonLabel = Instance.new("TextLabel")
dragonLabel.Size = UDim2.new(1, 0, 1, 0)
dragonLabel.BackgroundTransparency = 1
dragonLabel.Text = "🐉"
dragonLabel.TextSize = 22
dragonLabel.Parent = DragonRing

-- Xoay rồng
task.spawn(function()
    local angle = 0
    while DragonRing and DragonRing.Parent do
        angle = angle + 2
        DragonRing.Rotation = angle
        task.wait(0.03)
    end
end)

-- Main Menu (tự hiện)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 370, 0, 480)
Main.Position = UDim2.new(0, 80, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Main.BorderSizePixel = 0
Main.Visible = true          -- << tự động hiện
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 46)
Top.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
Top.BorderSizePixel = 0
Top.Parent = Main
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Zaka HUD v3.5  |  🐉"
Title.TextColor3 = Color3.fromRGB(0, 190, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
CloseBtn.TextSize = 15
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Top
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

-- Drag
local dragging, dragStart, startPos
Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Tabs
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, -16, 0, 34)
TabFrame.Position = UDim2.new(0, 8, 0, 52)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = Main

local Tabs = {"Player", "Combat", "ESP", "Magic", "Misc"}
local Current = "Player"
local TabBtns, Pages = {}, {}

local function MakePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -16, 1, -100)
    page.Position = UDim2.new(0, 8, 0, 94)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.CanvasSize = UDim2.new(0, 0, 0, 700)
    page.Visible = name == Current
    page.Parent = Main
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 7)
    lay.Parent = page
    Pages[name] = page
end

for i, name in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#Tabs, -4, 1, 0)
    btn.Position = UDim2.new((i-1)/#Tabs, 2, 0, 0)
    btn.BackgroundColor3 = name == Current and Color3.fromRGB(0, 160, 255) or Color3.fromRGB(30, 30, 42)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TabFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
    TabBtns[name] = btn
    MakePage(name)
    btn.MouseButton1Click:Connect(function()
        Current = name
        for n, b in pairs(TabBtns) do
            b.BackgroundColor3 = n == name and Color3.fromRGB(0, 160, 255) or Color3.fromRGB(30, 30, 42)
        end
        for n, p in pairs(Pages) do p.Visible = n == name end
    end)
end

local function AddToggle(page, text, default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 38)
    f.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    f.BorderSizePixel = 0
    f.Parent = page
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -58, 1, 0)
    l.Position = UDim2.new(0, 12, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(230,230,240)
    l.TextSize = 13
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 42, 0, 22)
    b.Position = UDim2.new(1, -50, 0.5, -11)
    b.BackgroundColor3 = default and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(50, 50, 60)
    b.Text = ""
    b.Parent = f
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)

    local c = Instance.new("Frame")
    c.Size = UDim2.new(0, 18, 0, 18)
    c.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    c.BackgroundColor3 = Color3.fromRGB(255,255,255)
    c.Parent = b
    Instance.new("UICorner", c).CornerRadius = UDim.new(1, 0)

    local on = default
    b.MouseButton1Click:Connect(function()
        on = not on
        TweenService:Create(b, TweenInfo.new(0.18), {BackgroundColor3 = on and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(50, 50, 60)}):Play()
        TweenService:Create(c, TweenInfo.new(0.18), {Position = on and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
        callback(on)
    end)
end

--===== TOGGLES =====--
-- Player
AddToggle(Pages["Player"], "Superman Fly + Cape", false, function(v) Settings.Fly = v if v then StartFly() else StopFly() end end)
AddToggle(Pages["Player"], "Speed Hack", false, function(v) Settings.Speed = v SetSpeed(v) end)
AddToggle(Pages["Player"], "Noclip", false, function(v) Settings.Noclip = v SetNoclip(v) end)
AddToggle(Pages["Player"], "Infinite Jump", false, function(v) Settings.InfiniteJump = v end)
AddToggle(Pages["Player"], "Bunny Hop", false, function(v) Settings.BunnyHop = v end)
AddToggle(Pages["Player"], "Click TP (Mobile)", false, function(v) Settings.ClickTP = v end)
AddToggle(Pages["Player"], "God Mode", false, function(v) Settings.GodMode = v SetGodMode(v) end)
AddToggle(Pages["Player"], "Infinite Ammo", false, function(v) SetInfiniteAmmo(v) end)
AddToggle(Pages["Player"], "Vehicle Speed Boost", false, function(v) SetVehicleSpeed(v) end)

-- Combat
AddToggle(Pages["Combat"], "Aimbot (Player)", false, function(v) Settings.Aimbot = v end)
AddToggle(Pages["Combat"], "NPC Aimbot (chỉ NPC)", false, function(v) Settings.NPCAimbot = v end)
AddToggle(Pages["Combat"], "Team Check", true, function(v) Settings.AimbotTeamCheck = v end)
AddToggle(Pages["Combat"], "Wall Check", true, function(v) Settings.AimbotWallCheck = v end)

-- ESP
AddToggle(Pages["ESP"], "ESP Player", false, function(v) Settings.ESP = v end)
AddToggle(Pages["ESP"], "ESP Box", true, function(v) Settings.ESPBox = v end)
AddToggle(Pages["ESP"], "ESP Name", true, function(v) Settings.ESPName = v end)
AddToggle(Pages["ESP"], "ESP Health", true, function(v) Settings.ESPHealth = v end)
AddToggle(Pages["ESP"], "ESP Distance", true, function(v) Settings.ESPDistance = v end)
AddToggle(Pages["ESP"], "ESP Tracer", false, function(v) Settings.ESPTracer = v end)
AddToggle(Pages["ESP"], "NPC ESP", false, function(v) Settings.NPCESP = v end)

-- Magic
AddToggle(Pages["Magic"], "Fire Aura", false, function(v) Settings.FireAura = v SetFireAura(v) end)
AddToggle(Pages["Magic"], "Ice Aura", false, function(v) Settings.IceAura = v SetIceAura(v) end)
AddToggle(Pages["Magic"], "Electric Aura", false, function(v) Settings.ElectricAura = v SetElectricAura(v) end)
AddToggle(Pages["Magic"], "Rainbow Body", false, function(v) Settings.RainbowBody = v SetRainbowBody(v) end)

-- Misc
AddToggle(Pages["Misc"], "Fullbright", false, function(v) Settings.Fullbright = v SetFullbright(v) end)
AddToggle(Pages["Misc"], "Anti AFK", true, function(v) Settings.AntiAFK = v end)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)
CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1.3)
    if Settings.Speed then SetSpeed(true) end
    if Settings.Fly then StartFly() end
    if Settings.Noclip then SetNoclip(true) end
    if Settings.GodMode then SetGodMode(true) end
end)

print("Zaka HUD v3.5 Full Complete | Logo Z + Dragon | Auto Open Menu")
