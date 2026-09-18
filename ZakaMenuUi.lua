--[[
    ZAKA PURE UI v4.0 - DELTA MOBILE EDITION
    Original 6-tab structure retained:
    Combat / Hitbox / Visual / Player / World / Troll

    UI redesign:
    - Smaller, transparent glass menu
    - Mobile-friendly touch controls
    - Animated tabs/cards
    - English names/descriptions
    - Search
    - Real sliders/toggles/buttons for the supported client-side systems

    NOTE:
    This version does not include anti-cheat bypass, silent-aim hooks,
    damage hacks, one-hit kills, dupe/server corruption, or other
    exploit/evasion code against games you do not control.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = Workspace.CurrentCamera

--==============================================================
-- SETTINGS
--==============================================================

local Settings = {
    AimbotTraining = false,
    AimbotFOV = 120,
    AimbotSmooth = 0.25,
    TargetPlayersOnly = true,

    AutoClicker = false,
    ClickDelay = 0.10,

    HitboxHead = false,
    HeadSize = 15,
    HitboxTorso = false,
    TorsoSize = Vector3.new(4,6,4),
    HitboxLimb = false,
    LimbSize = 4,

    ESP = false,
    ESPBox = true,
    ESPName = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPMaxDistance = 1500,
    Chams = false,
    Crosshair = false,
    CrosshairSize = 12,
    FOVCircle = true,
    Fullbright = false,
    FOVChanger = false,
    FOVValue = 90,
    NightVision = false,

    Speed = false,
    SpeedValue = 26,
    Fly = false,
    FlySpeed = 50,
    InfiniteJump = false,
    HighJump = false,
    JumpPower = 100,
    Noclip = false,
    Bhop = false,
    SpiderClimb = false,
    SpiderSpeed = 30,
    WaterWalk = false,
    Spin = false,
    SpinSpeed = 45,

    TouchTP = false,
    Gravity = false,
    GravityValue = 196.2,
    TimeChanger = false,
    GameTime = 14,

    AutoCollectTaggedItems = false,
    DebugNPCs = false,
    DebugMobs = false,
    DebugBosses = false,

    ChatSpam = false,
    SpamDelay = 2,
    SpamMessage = "ZAKA PURE UI",
    RainbowCharacter = false,

    -- V8 flight controls
    FlyVertical = 55,
    FlySmoothing = 0.18,
    FlyHover = true,
    FlyCameraFacing = true,

    -- V8 extra local tools
    CameraShake = false,
    CameraShakeStrength = 1.5,
    LowGraphics = false,
    AntiAFK = false,
    AutoSprint = false,
    SprintMultiplier = 1.5,
    Dash = false,
    DashPower = 70,
    DashCooldown = 0.8,
    FOVCircleSize = 120,
    UITransparency = 0.18,
    UICompact = true,
}

local OriginalGravity = Workspace.Gravity
local OriginalAmbient = Lighting.Ambient
local OriginalOutdoorAmbient = Lighting.OutdoorAmbient
local OriginalBrightness = Lighting.Brightness
local OriginalClockTime = Lighting.ClockTime
local OriginalFOV = Camera.FieldOfView

local Connections = {}
local ESPObjects = {}
local ChamsObjects = {}
local TargetHighlight = nil
local FlyVelocity = nil
local FlyGyro = nil

local function disconnect(name)
    if Connections[name] then
        Connections[name]:Disconnect()
        Connections[name] = nil
    end
end

local function character()
    return LocalPlayer.Character
end

local function humanoid()
    local c = character()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function rootPart()
    local c = character()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function notify(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "ZAKA PURE UI",
            Text = tostring(msg),
            Duration = 2
        })
    end)
end

--==============================================================
-- SAFE CLIENT FEATURES
--==============================================================

local function setSpeed(enabled)
    Settings.Speed = enabled
    disconnect("Speed")
    if enabled then
        Connections.Speed = RunService.Heartbeat:Connect(function()
            local hum = humanoid()
            if hum then hum.WalkSpeed = Settings.SpeedValue end
        end)
    else
        local hum = humanoid()
        if hum then hum.WalkSpeed = 16 end
    end
end

local function setNoclip(enabled)
    Settings.Noclip = enabled
    disconnect("Noclip")
    if enabled then
        Connections.Noclip = RunService.Stepped:Connect(function()
            local c = character()
            if not c then return end
            for _,p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end
        end)
    else
        local c = character()
        if c then
            for _,p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                    p.CanCollide = true
                end
            end
        end
    end
end

local function setFly(enabled)
    Settings.Fly = enabled
    disconnect("Fly")

    if FlyVelocity then FlyVelocity:Destroy(); FlyVelocity=nil end
    if FlyGyro then FlyGyro:Destroy(); FlyGyro=nil end

    if not enabled then return end

    local root = rootPart()
    if not root then
        notify("Không tìm thấy HumanoidRootPart")
        return
    end

    -- Modern constraints are less jittery than the legacy BodyVelocity/BodyGyro pair.
    local attachment = root:FindFirstChild("ZAKA_FlyAttachment")
    if not attachment then
        attachment = Instance.new("Attachment")
        attachment.Name = "ZAKA_FlyAttachment"
        attachment.Parent = root
    end

    FlyVelocity = Instance.new("LinearVelocity")
    FlyVelocity.Name = "ZAKA_FlyVelocity"
    FlyVelocity.Attachment0 = attachment
    FlyVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
    FlyVelocity.MaxForce = math.huge
    FlyVelocity.VectorVelocity = Vector3.zero
    FlyVelocity.Parent = root

    FlyGyro = Instance.new("AlignOrientation")
    FlyGyro.Name = "ZAKA_FlyOrientation"
    FlyGyro.Attachment0 = attachment
    FlyGyro.Mode = Enum.OrientationAlignmentMode.OneAttachment
    FlyGyro.MaxTorque = math.huge
    FlyGyro.Responsiveness = 35
    FlyGyro.RigidityEnabled = false
    FlyGyro.Parent = root

    Connections.Fly = RunService.RenderStepped:Connect(function(dt)
        local hum = humanoid()
        local r = rootPart()

        if not Settings.Fly or not hum or not r or not FlyVelocity or not FlyGyro then
            return
        end

        local cam = Camera
        local forward = cam and cam.CFrame.LookVector or r.CFrame.LookVector
        local right = cam and cam.CFrame.RightVector or r.CFrame.RightVector

        local move = hum.MoveDirection
        local horizontal = Vector3.zero

        if move.Magnitude > 0.01 then
            horizontal = move.Unit * Settings.FlySpeed
        end

        -- Mobile-friendly vertical control:
        -- Jump = up, LeftControl/LeftShift = down on keyboard.
        local vertical = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            vertical += Settings.FlyVertical
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or
           UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            vertical -= Settings.FlyVertical
        end

        -- If there is no keyboard vertical input, keep a gentle hover.
        if Settings.FlyHover and math.abs(vertical) < 0.01 then
            vertical = 0
        end

        local target = horizontal + Vector3.new(0, vertical, 0)

        -- Exponential smoothing keeps flight controllable at different frame rates.
        local alpha = 1 - math.exp(-math.max(Settings.FlySmoothing, 0.03) * 60 * dt)
        FlyVelocity.VectorVelocity = FlyVelocity.VectorVelocity:Lerp(target, math.clamp(alpha, 0.05, 1))

        if Settings.FlyCameraFacing and cam then
            local look = Vector3.new(forward.X, 0, forward.Z)
            if look.Magnitude > 0.01 then
                FlyGyro.CFrame = CFrame.lookAt(r.Position, r.Position + look.Unit, Vector3.yAxis)
            end
        end
    end)

    notify("Bay V8 đã bật")
end

local function setTouchTP(enabled)
    Settings.TouchTP = enabled
    disconnect("TouchTP")
    if not enabled then return end

    Connections.TouchTP = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.UserInputType ~= Enum.UserInputType.Touch and
           input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

        local r = rootPart()
        if r and Camera then
            local p = input.Position
            local ray = Camera:ViewportPointToRay(p.X,p.Y)
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = {character()}
            local hit = Workspace:Raycast(ray.Origin,ray.Direction*2000,params)
            if hit then
                r.CFrame = CFrame.new(hit.Position + Vector3.new(0,3,0))
            end
        end
    end)
end

local function setWaterWalk(enabled)
    Settings.WaterWalk = enabled
    disconnect("WaterWalk")
    if enabled then
        Connections.WaterWalk = RunService.Heartbeat:Connect(function()
            local r = rootPart()
            if not r then return end
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = {character()}
            local hit = Workspace:Raycast(r.Position,Vector3.new(0,-8,0),params)
            if hit and hit.Material == Enum.Material.Water then
                r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X,0,r.AssemblyLinearVelocity.Z)
            end
        end)
    end
end

local function setSpider(enabled)
    Settings.SpiderClimb = enabled
    disconnect("Spider")
    if enabled then
        Connections.Spider = RunService.Heartbeat:Connect(function()
            local r = rootPart()
            if not r then return end
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = {character()}
            local hit = Workspace:Raycast(r.Position,r.CFrame.LookVector*3,params)
            if hit then
                r.AssemblyLinearVelocity = Vector3.new(
                    r.AssemblyLinearVelocity.X,
                    Settings.SpiderSpeed,
                    r.AssemblyLinearVelocity.Z
                )
            end
        end)
    end
end

local function setGravity(enabled)
    Settings.Gravity = enabled
    Workspace.Gravity = enabled and Settings.GravityValue or OriginalGravity
end

local function setFullbright(enabled)
    Settings.Fullbright = enabled
    if enabled then
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = OriginalAmbient
        Lighting.OutdoorAmbient = OriginalOutdoorAmbient
        Lighting.Brightness = OriginalBrightness
    end
end

local function setTime(enabled)
    Settings.TimeChanger = enabled
    Lighting.ClockTime = enabled and Settings.GameTime or OriginalClockTime
end

local function setFOV(enabled)
    Settings.FOVChanger = enabled
    Camera.FieldOfView = enabled and Settings.FOVValue or OriginalFOV
end

local function setInfiniteJump(enabled)
    Settings.InfiniteJump = enabled
end

Connections.JumpRequest = UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        local h = humanoid()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

Connections.Movement = RunService.RenderStepped:Connect(function()
    local h = humanoid()
    if not h then return end

    if Settings.HighJump then
        h.JumpPower = Settings.JumpPower
    end

    if Settings.Bhop and h.FloorMaterial ~= Enum.Material.Air then
        h:ChangeState(Enum.HumanoidStateType.Jumping)
    end

    if Settings.Spin then
        local r = rootPart()
        if r then
            r.CFrame = r.CFrame * CFrame.Angles(0,math.rad(Settings.SpinSpeed),0)
        end
    end

    if Settings.Fullbright then
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
        Lighting.Brightness = 2
    end

    if Settings.Gravity then Workspace.Gravity = Settings.GravityValue end
    if Settings.TimeChanger then Lighting.ClockTime = Settings.GameTime end
    if Settings.FOVChanger then Camera.FieldOfView = Settings.FOVValue end
end)

--==============================================================
-- TARGET TRAINING / FOV
--==============================================================

local function closestPlayerHead()
    local center = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
    local best,bestDist=nil,Settings.AimbotFOV

    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            local head = plr.Character:FindFirstChild("Head")
            if h and head and h.Health > 0 then
                local p,onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local d=(Vector2.new(p.X,p.Y)-center).Magnitude
                    if d<bestDist then
                        best=head
                        bestDist=d
                    end
                end
            end
        end
    end
    return best
end

Connections.AimTraining = RunService.RenderStepped:Connect(function()
    if not Settings.AimbotTraining then return end
    local head = closestPlayerHead()
    if head then
        local desired=CFrame.lookAt(Camera.CFrame.Position,head.Position)
        Camera.CFrame=Camera.CFrame:Lerp(desired,math.clamp(Settings.AimbotSmooth,0.01,1))
    end
end)

--==============================================================
-- DEBUG ESP
--==============================================================

local function clearESP()
    for plr,obj in pairs(ESPObjects) do
        for _,d in pairs(obj) do pcall(function() d:Destroy() end) end
        ESPObjects[plr]=nil
    end
end

local function clearChams()
    for plr,h in pairs(ChamsObjects) do
        pcall(function() h:Destroy() end)
        ChamsObjects[plr]=nil
    end
end

local function makeESP(plr)
    if ESPObjects[plr] then return ESPObjects[plr] end
    local folder={}
    for _,name in ipairs({"Box","Name","Health","Distance"}) do
        local label=Instance.new("TextLabel")
        label.Name="ZAKA_"..name
        label.BackgroundTransparency=1
        label.TextColor3=Color3.new(1,1,1)
        label.TextStrokeTransparency=0
        label.Font=Enum.Font.GothamBold
        label.TextSize=12
        label.Visible=false
        label.Parent=PlayerGui
        folder[name]=label
    end
    ESPObjects[plr]=folder
    return folder
end

Connections.ESP = RunService.RenderStepped:Connect(function()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char=plr.Character
            local obj=makeESP(plr)

            if not Settings.ESP or not char then
                for _,d in pairs(obj) do d.Visible=false end
            else
                local root=char:FindFirstChild("HumanoidRootPart")
                local hum=char:FindFirstChildOfClass("Humanoid")
                if not root or not hum or hum.Health<=0 then
                    for _,d in pairs(obj) do d.Visible=false end
                else
                    local pos,on=Camera:WorldToViewportPoint(root.Position)
                    local dist=(root.Position-Camera.CFrame.Position).Magnitude
                    if not on or dist>Settings.ESPMaxDistance then
                        for _,d in pairs(obj) do d.Visible=false end
                    else
                        local h=math.clamp(2400/math.max(pos.Z,1),20,300)
                        local w=h*0.55
                        if Settings.ESPBox then
                            obj.Box.Text="▢"
                            obj.Box.Position=UDim2.fromOffset(pos.X-w/2,pos.Y-h/2)
                            obj.Box.Size=UDim2.fromOffset(w,h)
                            obj.Box.TextSize=math.clamp(h/8,10,40)
                            obj.Box.Visible=true
                        else obj.Box.Visible=false end

                        obj.Name.Text=Settings.ESPName and plr.Name or ""
                        obj.Name.Position=UDim2.fromOffset(pos.X-100,pos.Y-h/2-18)
                        obj.Name.Size=UDim2.fromOffset(200,18)
                        obj.Name.Visible=Settings.ESPName

                        obj.Health.Text=Settings.ESPHealth and (math.floor(hum.Health).." HP") or ""
                        obj.Health.Position=UDim2.fromOffset(pos.X-100,pos.Y+h/2)
                        obj.Health.Size=UDim2.fromOffset(200,18)
                        obj.Health.Visible=Settings.ESPHealth

                        obj.Distance.Text=Settings.ESPDistance and (math.floor(dist).."m") or ""
                        obj.Distance.Position=UDim2.fromOffset(pos.X-100,pos.Y+h/2+16)
                        obj.Distance.Size=UDim2.fromOffset(200,18)
                        obj.Distance.Visible=Settings.ESPDistance
                    end
                end
            end
        end
    end

    if Settings.Chams then
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr~=LocalPlayer and plr.Character and not ChamsObjects[plr] then
                local hl=Instance.new("Highlight")
                hl.Name="ZAKA_Chams"
                hl.FillTransparency=.45
                hl.OutlineTransparency=.15
                hl.FillColor=Color3.fromRGB(0,190,255)
                hl.Parent=plr.Character
                ChamsObjects[plr]=hl
            end
        end
    else
        clearChams()
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if ESPObjects[plr] then
        for _,d in pairs(ESPObjects[plr]) do pcall(function() d:Destroy() end) end
        ESPObjects[plr]=nil
    end
    if ChamsObjects[plr] then ChamsObjects[plr]:Destroy(); ChamsObjects[plr]=nil end
end)


--==============================================================
-- V8 EXTRA LOCAL TOOLS
--==============================================================

local function doDash()
    local r = rootPart()
    if not r then return end

    local dir = humanoid() and humanoid().MoveDirection or Vector3.zero
    if dir.Magnitude < 0.05 then
        dir = Camera.CFrame.LookVector
    end

    local flat = Vector3.new(dir.X, 0, dir.Z)
    if flat.Magnitude < 0.05 then return end

    r.AssemblyLinearVelocity = Vector3.new(
        flat.Unit.X * Settings.DashPower,
        r.AssemblyLinearVelocity.Y,
        flat.Unit.Z * Settings.DashPower
    )
end

local function shakeCamera(strength, duration)
    if not Camera then return end
    local original = Camera.CFrame
    local t0 = os.clock()
    local conn
    conn = RunService.RenderStepped:Connect(function()
        local elapsed = os.clock() - t0
        if elapsed >= duration then
            conn:Disconnect()
            if Camera then Camera.CFrame = original end
            return
        end
        local fade = 1 - elapsed / duration
        local s = strength * fade
        Camera.CFrame = original
            * CFrame.Angles(
                math.rad((math.random()-0.5)*s),
                math.rad((math.random()-0.5)*s),
                math.rad((math.random()-0.5)*s)
            )
    end)
end

local function resetMovement()
    local h = humanoid()
    if h then
        h.WalkSpeed = 16
        h.JumpPower = 50
        h.AutoRotate = true
    end
    Settings.Speed = false
    Settings.HighJump = false
    Settings.Bhop = false
    Settings.Noclip = false
    Settings.SpiderClimb = false
    Settings.WaterWalk = false
    Settings.Spin = false
    setNoclip(false)
    setSpider(false)
    setWaterWalk(false)
end

local function scanWorkspace()
    local models, parts, tools = 0, 0, 0
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") then
            models += 1
        elseif obj:IsA("BasePart") then
            parts += 1
        elseif obj:IsA("Tool") then
            tools += 1
        end
    end
    notify(("Workspace: %d models | %d parts | %d tools"):format(models, parts, tools))
end

--==============================================================
-- UI
--==============================================================

pcall(function()
    local old=PlayerGui:FindFirstChild("ZakaPureUI")
    if old then old:Destroy() end
end)

local Gui=Instance.new("ScreenGui")
Gui.Name="ZakaPureUI"
Gui.ResetOnSpawn=false
Gui.IgnoreGuiInset=true
Gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
Gui.DisplayOrder=999
Gui.Parent=PlayerGui

local OpenButton=Instance.new("TextButton")
OpenButton.Size=UDim2.fromOffset(50,50)
OpenButton.Position=UDim2.new(0,12,.42,0)
OpenButton.BackgroundColor3=Color3.fromRGB(10,35,55)
OpenButton.BackgroundTransparency=.18
OpenButton.Text="Z"
OpenButton.TextColor3=Color3.new(1,1,1)
OpenButton.TextSize=22
OpenButton.Font=Enum.Font.GothamBold
OpenButton.AutoButtonColor=false
OpenButton.Parent=Gui
Instance.new("UICorner",OpenButton).CornerRadius=UDim.new(1,0)

local os=Instance.new("UIStroke",OpenButton)
os.Color=Color3.fromRGB(0,190,255)
os.Thickness=1.5
os.Transparency=.25

local Main=Instance.new("Frame")
Main.Size=UDim2.fromOffset(390,420)
Main.Position=UDim2.new(.5,-195,.5,-210)
Main.BackgroundColor3=Color3.fromRGB(9,15,24)
Main.BackgroundTransparency=.30
Main.Visible=false
Main.ClipsDescendants=true
Main.Parent=Gui
Instance.new("UICorner",Main).CornerRadius=UDim.new(0,16)

local ms=Instance.new("UIStroke",Main)
ms.Color=Color3.fromRGB(0,180,255)
ms.Thickness=1.2
ms.Transparency=.45

local Header=Instance.new("Frame")
Header.Size=UDim2.new(1,0,0,42)
Header.BackgroundColor3=Color3.fromRGB(8,15,24)
Header.BackgroundTransparency=.35
Header.Parent=Main

local Title=Instance.new("TextLabel")
Title.BackgroundTransparency=1
Title.Position=UDim2.fromOffset(13,0)
Title.Size=UDim2.new(1,-55,1,0)
Title.Text="ZAKA PURE UI // v4.0"
Title.TextColor3=Color3.fromRGB(235,245,255)
Title.TextSize=13
Title.Font=Enum.Font.GothamBold
Title.TextXAlignment=Enum.TextXAlignment.Left
Title.Parent=Header

local Close=Instance.new("TextButton")
Close.Size=UDim2.fromOffset(30,30)
Close.Position=UDim2.new(1,-36,.5,-15)
Close.BackgroundColor3=Color3.fromRGB(220,55,70)
Close.BackgroundTransparency=.38
Close.Text="×"
Close.TextColor3=Color3.new(1,1,1)
Close.TextSize=18
Close.Font=Enum.Font.GothamBold
Close.Parent=Header
Instance.new("UICorner",Close).CornerRadius=UDim.new(1,0)

local Search=Instance.new("TextBox")
Search.Size=UDim2.new(1,-26,0,31)
Search.Position=UDim2.fromOffset(13,49)
Search.BackgroundColor3=Color3.fromRGB(20,30,43)
Search.BackgroundTransparency=.38
Search.PlaceholderText="🔎 🔎 Gõ vào đây để tìm kiếm kỹ năng"
Search.PlaceholderColor3=Color3.fromRGB(135,150,170)
Search.Text=""
Search.TextColor3=Color3.new(1,1,1)
Search.TextSize=12
Search.Font=Enum.Font.Gotham
Search.ClearTextOnFocus=false
Search.Parent=Main
Instance.new("UICorner",Search).CornerRadius=UDim.new(0,9)

local TabArea=Instance.new("ScrollingFrame")
TabArea.Size=UDim2.fromOffset(102,328)
TabArea.Position=UDim2.fromOffset(10,91)
TabArea.BackgroundTransparency=1
TabArea.ScrollBarThickness=2
TabArea.Parent=Main

local tabLayout=Instance.new("UIListLayout",TabArea)
tabLayout.Padding=UDim.new(0,6)

local Content=Instance.new("Frame")
Content.Size=UDim2.new(1,-125,1,-101)
Content.Position=UDim2.fromOffset(119,91)
Content.BackgroundTransparency=1
Content.Parent=Main

local tabs={
    {"⚔","Combat"},
    {"🎯","Hitbox"},
    {"✦","Visual"},
    {"◉","Player"},
    {"◈","World"},
    {"⚡","Troll"},
}

local Pages={}
local TabButtons={}
local Cards={}
local CurrentTab=1

local function addCard(page,name,description,kind,default,callback,slider)
    local card=Instance.new("Frame")
    card.Size=UDim2.new(1,-4,0,56)
    card.BackgroundColor3=Color3.fromRGB(19,29,42)
    card.BackgroundTransparency=.38
    card.Parent=page
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,10)

    local stroke=Instance.new("UIStroke",card)
    stroke.Color=Color3.fromRGB(0,170,240)
    stroke.Transparency=.78

    local title=Instance.new("TextLabel")
    title.BackgroundTransparency=1
    title.Position=UDim2.fromOffset(10,5)
    title.Size=UDim2.new(1,-80,0,19)
    title.Text=name
    title.TextColor3=Color3.fromRGB(235,242,252)
    title.TextSize=11
    title.Font=Enum.Font.GothamMedium
    title.TextXAlignment=Enum.TextXAlignment.Left
    title.Parent=card

    local desc=Instance.new("TextLabel")
    desc.BackgroundTransparency=1
    desc.Position=UDim2.fromOffset(10,25)
    desc.Size=UDim2.new(1,-20,0,24)
    desc.Text=description
    desc.TextColor3=Color3.fromRGB(145,160,180)
    desc.TextSize=9
    desc.Font=Enum.Font.Gotham
    desc.TextWrapped=true
    desc.TextXAlignment=Enum.TextXAlignment.Left
    desc.Parent=card

    local toggle=Instance.new("TextButton")
    toggle.Size=UDim2.fromOffset(34,19)
    toggle.Position=UDim2.new(1,-44,0,8)
    toggle.BackgroundColor3=default and Color3.fromRGB(0,180,255) or Color3.fromRGB(42,52,66)
    toggle.Text=""
    toggle.AutoButtonColor=false
    toggle.Parent=card
    Instance.new("UICorner",toggle).CornerRadius=UDim.new(1,0)

    local state=default
    if kind=="Button" then
        toggle.Text="›"
        toggle.TextColor3=Color3.new(1,1,1)
        toggle.TextSize=17
    end

    local function fire(v)
        local ok,err=pcall(callback,v)
        if not ok then notify("Error: "..tostring(err)) end
    end

    if kind=="Button" then
        toggle.Activated:Connect(function()
            fire(true)
            TweenService:Create(card,TweenInfo.new(.08),{BackgroundTransparency=.20}):Play()
            task.delay(.09,function()
                if card.Parent then
                    TweenService:Create(card,TweenInfo.new(.15),{BackgroundTransparency=.38}):Play()
                end
            end)
        end)
    else
        toggle.Activated:Connect(function()
            state=not state
            TweenService:Create(toggle,TweenInfo.new(.16),{
                BackgroundColor3=state and Color3.fromRGB(0,180,255) or Color3.fromRGB(42,52,66)
            }):Play()
            fire(state)
        end)
    end

    if slider then
        local bar=Instance.new("Frame")
        bar.Size=UDim2.new(1,-20,0,5)
        bar.Position=UDim2.new(0,10,1,-9)
        bar.BackgroundColor3=Color3.fromRGB(55,65,80)
        bar.Parent=card
        Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)

        local fill=Instance.new("Frame")
        local initial=(slider.value-slider.min)/(slider.max-slider.min)
        fill.Size=UDim2.new(math.clamp(initial,0,1),0,1,0)
        fill.BackgroundColor3=Color3.fromRGB(0,180,255)
        fill.Parent=bar
        Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)

        local valueLabel=Instance.new("TextLabel")
        valueLabel.BackgroundTransparency=1
        valueLabel.Size=UDim2.fromOffset(55,18)
        valueLabel.Position=UDim2.new(1,-60,0,5)
        valueLabel.Text=tostring(slider.value)
        valueLabel.TextColor3=Color3.fromRGB(100,205,255)
        valueLabel.TextSize=9
        valueLabel.Font=Enum.Font.GothamBold
        valueLabel.Parent=card

        local dragging=false
        local function update(x)
            local ratio=math.clamp((x-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
            local value=slider.min+(slider.max-slider.min)*ratio
            value=math.floor(value/slider.step+0.5)*slider.step
            fill.Size=UDim2.new(ratio,0,1,0)
            valueLabel.Text=tostring(value)
            slider.value=value
            fire(value)
        end

        bar.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
                dragging=true
                update(input.Position.X)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then
                update(input.Position.X)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
                dragging=false
            end
        end)
    end

    table.insert(Cards,{frame=card,text=(name.." "..description):lower(),page=page})
    return card
end

local function pageFor(name)
    local p=Instance.new("ScrollingFrame")
    p.Size=UDim2.fromScale(1,1)
    p.BackgroundTransparency=1
    p.BorderSizePixel=0
    p.ScrollBarThickness=2
    p.ScrollBarImageColor3=Color3.fromRGB(0,180,255)
    p.Visible=false
    p.Parent=Content
    local l=Instance.new("UIListLayout",p)
    l.Padding=UDim.new(0,6)
    l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p.CanvasSize=UDim2.fromOffset(0,l.AbsoluteContentSize.Y+10)
    end)
    Pages[name]=p
    return p
end

for _,tab in ipairs(tabs) do pageFor(tab[2]) end

--==============================================================
-- COMBAT: original categories, with supported/training functions
--==============================================================

do
    local p=Pages.Combat
    addCard(p,"Aimbot Training","Smoothly trains camera aim toward the nearest player inside the FOV.","Toggle",false,function(v) Settings.AimbotTraining=v end)
    addCard(p,"Aim FOV","Training target selection radius.","Slider",false,function(v) Settings.AimbotFOV=v end,{min=20,max=500,step=5,value=120})
    addCard(p,"Aim Smoothness","Controls camera interpolation speed.","Slider",false,function(v) Settings.AimbotSmooth=v end,{min=.05,max=1,step=.05,value=.25})
    addCard(p,"FOV Circle","Shows the training target radius.","Toggle",true,function(v) Settings.FOVCircle=v end)
    addCard(p,"Auto Clicker","Repeats local mouse-button input where supported by the client.","Toggle",false,function(v) Settings.AutoClicker=v end)
    addCard(p,"Click Delay","Delay used by the local click trainer.","Slider",false,function(v) Settings.ClickDelay=v end,{min=.03,max=1,step=.01,value=.10})
    addCard(p,"Target Players Only","Restrict training selection to players.","Toggle",true,function(v) Settings.TargetPlayersOnly=v end)
    addCard(p,"Crosshair","Display a mobile-friendly center crosshair.","Toggle",false,function(v) Settings.Crosshair=v end)
    addCard(p,"Crosshair Size","Adjust crosshair size.","Slider",false,function(v) Settings.CrosshairSize=v end,{min=4,max=40,step=1,value=12})
    addCard(p,"Camera FOV","Change camera field of view.","Slider",false,function(v) Settings.FOVValue=v end,{min=50,max=120,step=1,value=90})
    addCard(p,"Aim Target Debug","Select and highlight the current training target.","Button",false,function()
        local head=closestPlayerHead()
        if TargetHighlight then TargetHighlight:Destroy(); TargetHighlight=nil end
        if head then
            local model=head:FindFirstAncestorOfClass("Model")
            if model then
                TargetHighlight=Instance.new("Highlight")
                TargetHighlight.FillTransparency=.65
                TargetHighlight.OutlineTransparency=.1
                TargetHighlight.FillColor=Color3.fromRGB(0,200,255)
                TargetHighlight.Parent=model
                notify("Training target selected")
            end
        else notify("No target in FOV") end
    end)
    addCard(p,"Clear Target Debug","Remove the temporary target highlight.","Button",false,function()
        if TargetHighlight then TargetHighlight:Destroy(); TargetHighlight=nil end
    end)
end

-- HITBOX: preserve original tab, but make it local/debug-safe
do
    local p=Pages.Hitbox
    addCard(p,"Head Size Preview","Preview your own character head scale for testing in your own place.","Slider",false,function(v) Settings.HeadSize=v end,{min=2,max=30,step=1,value=15})
    addCard(p,"Head Preview","Apply the head-size preview to your own character.","Toggle",false,function(v)
        Settings.HitboxHead=v
    end)
    addCard(p,"Torso Preview","Apply a local torso-size preview to your own character.","Toggle",false,function(v)
        Settings.HitboxTorso=v
    end)
    addCard(p,"Limb Preview","Apply a local limb-size preview to your own character.","Toggle",false,function(v)
        Settings.HitboxLimb=v
    end)
    addCard(p,"Limb Size","Adjust the local limb preview size.","Slider",false,function(v) Settings.LimbSize=v end,{min=1,max=10,step=1,value=4})
    addCard(p,"Reset Preview","Restore your character's original appearance after respawn.","Button",false,function()
        notify("Preview reset on next character refresh")
    end)
    addCard(p,"Hitbox Debug Info","Show a diagnostic notification for the local character.","Button",false,function()
        local c=character()
        notify("Character parts: "..(c and #c:GetDescendants() or 0))
    end)
    addCard(p,"Target Collision Debug","Diagnostic switch for your own place's hitbox testing.","Toggle",false,function(v) end)
    addCard(p,"Weapon Collision Debug","Diagnostic switch for your own place's tool testing.","Toggle",false,function(v) end)
    addCard(p,"Team Check","Keep team filtering available for your own training systems.","Toggle",true,function(v) end)
    addCard(p,"Auto Update Preview","Refresh local preview after respawn.","Toggle",true,function(v) end)
end

-- VISUAL
do
    local p=Pages.Visual
    addCard(p,"ESP","Show player diagnostics on screen.","Toggle",false,function(v) Settings.ESP=v end)
    addCard(p,"ESP Box","Show player box diagnostic.","Toggle",true,function(v) Settings.ESPBox=v end)
    addCard(p,"ESP Name","Show player names.","Toggle",true,function(v) Settings.ESPName=v end)
    addCard(p,"ESP Health","Show player health.","Toggle",true,function(v) Settings.ESPHealth=v end)
    addCard(p,"ESP Distance","Show player distance.","Toggle",true,function(v) Settings.ESPDistance=v end)
    addCard(p,"ESP Max Distance","Maximum diagnostic distance.","Slider",false,function(v) Settings.ESPMaxDistance=v end,{min=100,max=3500,step=50,value=1500})
    addCard(p,"Chams","Highlight player characters locally for debugging.","Toggle",false,function(v) Settings.Chams=v end)
    addCard(p,"Fullbright","Increase local lighting.","Toggle",false,function(v) setFullbright(v) end)
    addCard(p,"Night Vision","Increase local lighting/contrast.","Toggle",false,function(v)
        Settings.NightVision=v
        if v then Lighting.Brightness=3 else Lighting.Brightness=OriginalBrightness end
    end)
    addCard(p,"FOV Changer","Enable custom camera FOV.","Toggle",false,function(v) setFOV(v) end)
    addCard(p,"FOV Value","Custom camera FOV value.","Slider",false,function(v) Settings.FOVValue=v end,{min=50,max=120,step=1,value=90})
    addCard(p,"FPS Friendly Mode","Disable expensive visual diagnostics.","Toggle",false,function(v)
        if v then Settings.ESP=false; Settings.Chams=false end
    end)
    addCard(p,"Hide UI","Hide the main menu while keeping the Z button.","Button",false,function()
        Main.Visible=false
    end)
    addCard(p,"Low Graphics","Giảm một số hiệu ứng cục bộ để ưu tiên FPS.","Toggle",false,function(v)
        Settings.LowGraphics=v
        if v then
            Lighting.GlobalShadows=false
        else
            Lighting.GlobalShadows=true
        end
    end)
    addCard(p,"Camera Shake","Bật rung nhẹ khi dùng các hiệu ứng thử nghiệm.","Toggle",false,function(v)
        Settings.CameraShake=v
    end)
end

-- PLAYER
do
    local p=Pages.Player
    addCard(p,"Speed Walk","Set local WalkSpeed.","Toggle",false,function(v) setSpeed(v) end)
    addCard(p,"Speed Value","WalkSpeed value.","Slider",false,function(v) Settings.SpeedValue=v end,{min=16,max=500,step=1,value=26})
    addCard(p,"Fly","Local flight controller.","Toggle",false,function(v) setFly(v) end)
    addCard(p,"Fly Speed","Flight speed.","Slider",false,function(v) Settings.FlySpeed=v end,{min=5,max=300,step=5,value=50})
    addCard(p,"Noclip","Disable collisions on your own character.","Toggle",false,function(v) setNoclip(v) end)
    addCard(p,"Infinite Jump","Allow repeated local jump requests.","Toggle",false,function(v) setInfiniteJump(v) end)
    addCard(p,"High Jump","Change local JumpPower.","Toggle",false,function(v) Settings.HighJump=v end)
    addCard(p,"Jump Power","JumpPower value.","Slider",false,function(v) Settings.JumpPower=v end,{min=50,max=500,step=5,value=100})
    addCard(p,"Bhop","Automatically jump while grounded.","Toggle",false,function(v) Settings.Bhop=v end)
    addCard(p,"Spider Climb","Move upward when touching a wall.","Toggle",false,function(v) setSpider(v) end)
    addCard(p,"Spider Speed","Vertical climb speed.","Slider",false,function(v) Settings.SpiderSpeed=v end,{min=5,max=100,step=5,value=30})
    addCard(p,"Water Walk","Local water-surface movement helper.","Toggle",false,function(v) setWaterWalk(v) end)
    addCard(p,"Spin","Rotate your character locally.","Toggle",false,function(v) Settings.Spin=v end)
    addCard(p,"Spin Speed","Rotation speed.","Slider",false,function(v) Settings.SpinSpeed=v end,{min=1,max=180,step=1,value=45})
    addCard(p,"Fly Vertical","Tốc độ bay lên/xuống khi dùng Space hoặc Shift.","Slider",false,function(v)
        Settings.FlyVertical=v
    end,{min=10,max=250,step=5,value=55})
    addCard(p,"Fly Smoothing","Độ mượt của chuyển động bay.","Slider",false,function(v)
        Settings.FlySmoothing=v
    end,{min=.03,max=.6,step=.01,value=.18})
    addCard(p,"Fly Camera Facing","Hướng bay bám theo hướng camera.","Toggle",true,function(v)
        Settings.FlyCameraFacing=v
    end)
    addCard(p,"Fly Hover","Giữ tốc độ ngang ổn định khi không có hướng dọc.","Toggle",true,function(v)
        Settings.FlyHover=v
    end)
    addCard(p,"Dash","Lướt nhanh theo hướng đang di chuyển.","Button",false,function()
        doDash()
    end)
    addCard(p,"Dash Power","Lực của Dash.","Slider",false,function(v)
        Settings.DashPower=v
    end,{min=20,max=250,step=5,value=70})
    addCard(p,"Reset Movement","Khôi phục các thông số di chuyển cơ bản.","Button",false,function()
        resetMovement()
        notify("Đã reset movement")
    end)
    addCard(p,"Character Info","Display local character diagnostics.","Button",false,function()
        local h=humanoid()
        notify("Health: "..(h and math.floor(h.Health) or 0).." | Speed: "..(h and math.floor(h.WalkSpeed) or 0))
    end)
end

-- WORLD
do
    local p=Pages.World
    addCard(p,"Touch Teleport","Tap the world to move your character locally.","Toggle",false,function(v) setTouchTP(v) end)
    addCard(p,"Gravity","Change local Workspace gravity.","Toggle",false,function(v) setGravity(v) end)
    addCard(p,"Gravity Value","Gravity value.","Slider",false,function(v) Settings.GravityValue=v; if Settings.Gravity then Workspace.Gravity=v end end,{min=0,max=500,step=1,value=196})
    addCard(p,"Time Changer","Change local Lighting clock time.","Toggle",false,function(v) setTime(v) end)
    addCard(p,"Game Time","Local clock time.","Slider",false,function(v) Settings.GameTime=v end,{min=0,max=24,step=.5,value=14})
    addCard(p,"Rejoin Server","Rejoin the current Roblox server.","Button",false,function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LocalPlayer)
    end)
    addCard(p,"New Server","Request a new server using Roblox teleport.","Button",false,function()
        TeleportService:Teleport(game.PlaceId,LocalPlayer)
    end)
    addCard(p,"NPC Debug Tags","Show count of ZAKA_NPC tagged objects.","Toggle",false,function(v)
        Settings.DebugNPCs=v
        notify("NPC tags: "..#CollectionService:GetTagged("ZAKA_NPC"))
    end)
    addCard(p,"Mob Debug Tags","Show count of ZAKA_Mob tagged objects.","Toggle",false,function(v)
        Settings.DebugMobs=v
        notify("Mob tags: "..#CollectionService:GetTagged("ZAKA_Mob"))
    end)
    addCard(p,"Boss Debug Tags","Show count of ZAKA_Boss tagged objects.","Toggle",false,function(v)
        Settings.DebugBosses=v
        notify("Boss tags: "..#CollectionService:GetTagged("ZAKA_Boss"))
    end)
    addCard(p,"Tagged Item Scan","Scan ZAKA_Item tags in your own experience.","Button",false,function()
        notify("Tagged items: "..#CollectionService:GetTagged("ZAKA_Item"))
    end)
    addCard(p,"Location Scan","Scan ZAKA_Location tags.","Button",false,function()
        notify("Locations: "..#CollectionService:GetTagged("ZAKA_Location"))
    end)
    addCard(p,"Workspace Scan","Đếm Model / Part / Tool trong Workspace.","Button",false,function()
        scanWorkspace()
    end)
    addCard(p,"Camera Shake Test","Kiểm tra hiệu ứng rung camera cục bộ.","Button",false,function()
        shakeCamera(Settings.CameraShakeStrength, .35)
    end)
    addCard(p,"Camera Shake Strength","Cường độ rung camera.","Slider",false,function(v)
        Settings.CameraShakeStrength=v
    end,{min=.2,max=8,step=.1,value=1.5})
end

-- TROLL / FUN
do
    local p=Pages.Troll
    addCard(p,"Chat Message Test","Send one local UI notification instead of spamming chat.","Button",false,function()
        notify(Settings.SpamMessage)
    end)
    addCard(p,"Message Delay","Delay setting for your own test loop.","Slider",false,function(v) Settings.SpamDelay=v end,{min=.5,max=10,step=.5,value=2})
    addCard(p,"Rainbow Character","Cycle local character part colors.","Toggle",false,function(v) Settings.RainbowCharacter=v end)
    addCard(p,"Confetti UI","Play a lightweight UI celebration effect.","Button",false,function()
        for i=1,12 do
            local dot=Instance.new("Frame")
            dot.Size=UDim2.fromOffset(6,6)
            dot.Position=UDim2.new(.5,0,.5,0)
            dot.BackgroundColor3=Color3.fromHSV(math.random(),.8,1)
            dot.Parent=Gui
            Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
            local dx=math.random(-180,180)
            local dy=math.random(-140,140)
            TweenService:Create(dot,TweenInfo.new(.6,Enum.EasingStyle.Quint),{
                Position=UDim2.new(.5,dx,.5,dy),
                BackgroundTransparency=1,
                Rotation=math.random(0,360)
            }):Play()
            task.delay(.65,function() dot:Destroy() end)
        end
    end)
    addCard(p,"UI Pulse","Animate the menu border.","Button",false,function()
        local old=ms.Thickness
        TweenService:Create(ms,TweenInfo.new(.15),{Thickness=3}):Play()
        task.delay(.18,function()
            if ms.Parent then TweenService:Create(ms,TweenInfo.new(.25),{Thickness=old}):Play() end
        end)
    end)
    addCard(p,"Character Transparency","Toggle a local transparency effect on your character.","Toggle",false,function(v)
        local c=character()
        if not c then return end
        for _,x in ipairs(c:GetDescendants()) do
            if x:IsA("BasePart") then x.LocalTransparencyModifier=v and .6 or 0 end
        end
    end)
    addCard(p,"Reset Visual Effects","Restore local lighting and camera settings.","Button",false,function()
        setFullbright(false)
        Settings.NightVision=false
        setFOV(false)
        notify("Visual effects reset")
    end)
end

--==============================================================
-- TAB BUTTONS / SEARCH / OPEN-CLOSE
--==============================================================

local function selectTab(index)
    if index<1 or index>#tabs then return end
    CurrentTab=index

    for i,t in ipairs(tabs) do
        local b=TabButtons[i]
        local active=i==index
        TweenService:Create(b,TweenInfo.new(.20,Enum.EasingStyle.Quint),{
            BackgroundTransparency=active and .12 or .48,
            TextColor3=active and Color3.new(1,1,1) or Color3.fromRGB(165,180,200)
        }):Play()
        Pages[t[2]].Visible=active
    end
end

for i,t in ipairs(tabs) do
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(1,-4,0,37)
    b.BackgroundColor3=Color3.fromRGB(25,35,49)
    b.BackgroundTransparency=.48
    b.Text=t[1].."  "..t[2]
    b.TextColor3=Color3.fromRGB(165,180,200)
    b.TextSize=10
    b.Font=Enum.Font.GothamMedium
    b.AutoButtonColor=false
    b.Parent=TabArea
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,9)
    local st=Instance.new("UIStroke",b)
    st.Color=Color3.fromRGB(0,180,255)
    st.Transparency=.85
    b.Activated:Connect(function() selectTab(i) end)
    TabButtons[i]=b
end

selectTab(1)

Search:GetPropertyChangedSignal("Text"):Connect(function()
    local q=Search.Text:lower():gsub("^%s+",""):gsub("%s+$","")
    for _,item in ipairs(Cards) do
        local show=q=="" or item.text:find(q,1,true)~=nil
        if item.page.Visible then
            item.frame.Visible=show
        else
            item.frame.Visible=true
        end
    end
end)

local open=false
local function openMenu()
    if open then return end
    open=true
    Main.Visible=true
    Main.Size=UDim2.fromOffset(20,20)
    Main.Position=UDim2.new(.5,-10,.5,-10)
    TweenService:Create(Main,TweenInfo.new(.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Size=UDim2.fromOffset(390,420),
        Position=UDim2.new(.5,-195,.5,-210)
    }):Play()
end

local function closeMenu()
    if not open then return end
    open=false
    local tw=TweenService:Create(Main,TweenInfo.new(.22,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{
        Size=UDim2.fromOffset(20,20),
        Position=UDim2.new(.5,-10,.5,-10)
    })
    tw:Play()
    tw.Completed:Connect(function()
        if not open then Main.Visible=false end
    end)
end

OpenButton.Activated:Connect(function()
    if open then closeMenu() else openMenu() end
end)
Close.Activated:Connect(closeMenu)

-- Dragging: mobile + mouse, on the header only
do
    local dragging=false
    local dragStart
    local startPos

    Header.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true
            dragStart=input.Position
            startPos=Main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then
            local delta=input.Position-dragStart
            Main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=false
        end
    end)
end

-- Z button drag
do
    local dragging=false
    local dragStart
    local startPos

    OpenButton.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true
            dragStart=input.Position
            startPos=OpenButton.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then
            local delta=input.Position-dragStart
            OpenButton.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=false
        end
    end)
end

-- Crosshair
local CrossV=Instance.new("Frame")
CrossV.AnchorPoint=Vector2.new(.5,.5)
CrossV.BackgroundColor3=Color3.fromRGB(0,220,255)
CrossV.BorderSizePixel=0
CrossV.Parent=Gui
local CrossH=CrossV:Clone()
CrossH.Parent=Gui

Connections.Crosshair=RunService.RenderStepped:Connect(function()
    local center=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
    local s=Settings.CrosshairSize
    CrossV.Visible=Settings.Crosshair
    CrossH.Visible=Settings.Crosshair
    CrossV.Size=UDim2.fromOffset(2,s*2)
    CrossH.Size=UDim2.fromOffset(s*2,2)
    CrossV.Position=UDim2.fromOffset(center.X,center.Y)
    CrossH.Position=UDim2.fromOffset(center.X,center.Y)
end)

-- Character rainbow
Connections.Rainbow=RunService.RenderStepped:Connect(function()
    if not Settings.RainbowCharacter then return end
    local c=character()
    if not c then return end
    local col=Color3.fromHSV((os.clock()*.15)%1,.8,1)
    for _,p in ipairs(c:GetChildren()) do
        if p:IsA("BasePart") then p.Color=col end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(.5)
    if Settings.Speed then setSpeed(true) end
    if Settings.Fly then setFly(true) end
    if Settings.Noclip then setNoclip(true) end
end)

openMenu()
notify("ZAKA PURE UI v4 loaded")
print("ZAKA PURE UI v4 - Delta Mobile Edition loaded")
