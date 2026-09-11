--[[
    ZAKA HUD - Clean Version (No Magic)
    - Đã xóa toàn bộ Magic
    - Đã gỡ các chức năng rỗng
    - Đã dọn connection + thêm notification
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

--==============================================================================--
--                              SETTINGS
--==============================================================================--
local Settings = {
    -- Combat
    Aimbot = false,
    AimbotFOV = 120,
    AimbotSmooth = 0.2,
    SilentAim = false,
    AutoClicker = false,
    TargetStrafe = false,
    StrafeDistance = 10,
    StrafeSpeed = 5,
    HitboxExpander = false,
    HitboxSize = 20,
    NPCAimbot = false,
    NPCAimbotFOV = 140,
    NPCAimbotSmooth = 0.16,
    InfiniteAmmo = false,
    FastFire = false,

    -- ESP
    ESP = false,
    ESPBox = true,
    ESPName = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPTracers = false,
    ESPMaxDist = 3000,
    Chams = false,
    ChamsColor = Color3.fromRGB(0, 162, 255),
    CustomCrosshair = false,

    -- Movement
    Speed = false,
    SpeedValue = 28,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    InfiniteJump = false,
    SpinBot = false,
    SpinSpeed = 40,
    SpiderClimb = false,
    WaterWalk = false,
    CustomFOV = 70,

    -- Troll & Utility
    ChatSpammer = false,
    SpamMessage = "Zaka HUD On Top!",
    AntiAFK = true,
    TouchTP = false,
}

--==============================================================================--
--                         CONNECTION MANAGER
--==============================================================================--
local Connections = {}
local function AddConn(name, conn)
    if Connections[name] then
        Connections[name]:Disconnect()
    end
    Connections[name] = conn
end

local function ClearAllConnections()
    for name, conn in pairs(Connections) do
        if conn then
            pcall(function() conn:Disconnect() end)
        end
        Connections[name] = nil
    end
end

--==============================================================================--
--                           NOTIFICATION
--==============================================================================--
local function Notify(title, text, duration)
    duration = duration or 3
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration
        })
    end)
end

--==============================================================================--
--                           ANTI AFK + JUMP
--==============================================================================--
LocalPlayer.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

--==============================================================================--
--                         TOUCH TP / WATER / SPIDER
--==============================================================================--
local function SetTouchTP(state)
    Settings.TouchTP = state
    if Connections.TouchTP then Connections.TouchTP:Disconnect() end

    if state then
        AddConn("TouchTP", UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if Mouse.Hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3.5, 0))
                end
            end
        end))
        Notify("Touch TP", "Đã bật")
    else
        Notify("Touch TP", "Đã tắt")
    end
end

local function SetWaterWalk(state)
    Settings.WaterWalk = state
    if Connections.WaterWalk then Connections.WaterWalk:Disconnect() end

    if state then
        AddConn("WaterWalk", RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local ray = Ray.new(root.Position, Vector3.new(0, -5, 0))
                local hit, pos, _, mat = workspace:FindPartOnRay(ray, char)
                if mat == Enum.Material.Water then
                    root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
                    root.CFrame = CFrame.new(root.Position.X, pos.Y + 3.2, root.Position.Z)
                end
            end
        end))
        Notify("Water Walk", "Đã bật")
    else
        Notify("Water Walk", "Đã tắt")
    end
end

local function SetSpiderClimb(state)
    Settings.SpiderClimb = state
    if Connections.Spider then Connections.Spider:Disconnect() end

    if state then
        AddConn("Spider", RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local ray = Ray.new(root.Position, root.CFrame.LookVector * 2.5)
                local hit = workspace:FindPartOnRay(ray, char)
                if hit then
                    root.Velocity = Vector3.new(root.Velocity.X, 30, root.Velocity.Z)
                end
            end
        end))
        Notify("Spider Climb", "Đã bật")
    else
        Notify("Spider Climb", "Đã tắt")
    end
end

--==============================================================================--
--                           AUTO CLICKER + SPAM
--==============================================================================--
local function SetAutoClicker(state)
    Settings.AutoClicker = state
    if Connections.AutoClick then Connections.AutoClick:Disconnect() end

    if state then
        AddConn("AutoClick", RunService.RenderStepped:Connect(function()
            VirtualUser:Button1Down(Vector2.new())
            task.wait(0.05)
            VirtualUser:Button1Up(Vector2.new())
        end))
        Notify("Auto Clicker", "Đã bật")
    else
        Notify("Auto Clicker", "Đã tắt")
    end
end

local function SetChatSpammer(state)
    Settings.ChatSpammer = state
    if Connections.Spam then
        task.cancel(Connections.Spam)
        Connections.Spam = nil
    end

    if state then
        Connections.Spam = task.spawn(function()
            while Settings.ChatSpammer do
                pcall(function()
                    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                        local channel = TextChatService.TextChannels.RBXGeneral
                        if channel then channel:SendAsync(Settings.SpamMessage) end
                    else
                        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Settings.SpamMessage, "All")
                    end
                end)
                task.wait(2.5)
            end
        end)
        Notify("Chat Spammer", "Đã bật")
    else
        Notify("Chat Spammer", "Đã tắt")
    end
end

--==============================================================================--
--                           TARGET STRAFE
--==============================================================================--
local function SetTargetStrafe(state)
    Settings.TargetStrafe = state
    if Connections.Strafe then Connections.Strafe:Disconnect() end

    if state then
        local angle = 0
        AddConn("Strafe", RunService.RenderStepped:Connect(function()
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end

            local target, minDist = nil, 9999
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (plr.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        target = plr.Character.HumanoidRootPart
                    end
                end
            end

            if target and minDist <= 40 then
                angle = angle + math.rad(Settings.StrafeSpeed)
                local offset = Vector3.new(math.cos(angle) * Settings.StrafeDistance, 0, math.sin(angle) * Settings.StrafeDistance)
                myRoot.CFrame = CFrame.new(target.Position + offset, target.Position)
            end
        end))
        Notify("Target Strafe", "Đã bật")
    else
        Notify("Target Strafe", "Đã tắt")
    end
end

--==============================================================================--
--                           AIMBOT + SILENT AIM
--==============================================================================--
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(0, 162, 255)
FOVCircle.Visible = false

local CrosshairV = Drawing.new("Line")
local CrosshairH = Drawing.new("Line")

local function GetClosestPlayerHead()
    local closest, shortest = nil, Settings.AimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = head
                    end
                end
            end
        end
    end
    return closest
end

-- Silent Aim
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    if not checkcaller() and Settings.SilentAim and self == Mouse and tostring(key) == "Hit" then
        local target = GetClosestPlayerHead()
        if target then
            return target.CFrame
        end
    end
    return oldIndex(self, key)
end)

-- NPC Aimbot
local NPCFOVCircle = Drawing.new("Circle")
NPCFOVCircle.Thickness = 1.5
NPCFOVCircle.NumSides = 64
NPCFOVCircle.Filled = false
NPCFOVCircle.Color = Color3.fromRGB(255, 80, 80)
NPCFOVCircle.Transparency = 0.7
NPCFOVCircle.Visible = false

local function GetClosestNPC()
    local closest, shortest = nil, Settings.NPCAimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local head = obj:FindFirstChild("Head") or obj:FindFirstChild("head")
            if hum and head and hum.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = head
                    end
                end
            end
        end
    end
    return closest
end

--==============================================================================--
--                           INFINITE AMMO + FAST FIRE
--==============================================================================--
local function SetInfiniteAmmo(state)
    Settings.InfiniteAmmo = state
    if Connections.Ammo then Connections.Ammo:Disconnect() end

    if state then
        AddConn("Ammo", RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end

            local function ForceAmmo(tool)
                if not tool or not tool:IsA("Tool") then return end
                pcall(function()
                    local names = {"Ammo", "Clip", "CurrentAmmo", "MaxAmmo", "Bullets", "AmmoCount", "Round", "Magazine"}
                    for _, name in ipairs(names) do
                        local val = tool:FindFirstChild(name)
                        if val and (val:IsA("IntValue") or val:IsA("NumberValue")) then
                            val.Value = 9999
                        end
                    end
                    tool:SetAttribute("Ammo", 9999)
                    tool:SetAttribute("Clip", 9999)
                end)
            end

            for _, item in ipairs(char:GetChildren()) do ForceAmmo(item) end
            local bp = LocalPlayer:FindFirstChild("Backpack")
            if bp then for _, item in ipairs(bp:GetChildren()) do ForceAmmo(item) end end
        end))
        Notify("Infinite Ammo", "Đã bật")
    else
        Notify("Infinite Ammo", "Đã tắt")
    end
end

local function SetFastFire(state)
    Settings.FastFire = state
    if Connections.FastFire then Connections.FastFire:Disconnect() end

    if state then
        AddConn("FastFire", RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    pcall(function()
                        if tool:FindFirstChild("FireRate") then tool.FireRate.Value = 0.01 end
                        if tool:FindFirstChild("Cooldown") then tool.Cooldown.Value = 0.01 end
                        if tool:FindFirstChild("ShootCooldown") then tool.ShootCooldown.Value = 0.01 end
                    end)
                end
            end
        end))
        Notify("Fast Fire", "Đã bật")
    else
        Notify("Fast Fire", "Đã tắt")
    end
end

--==============================================================================--
--                           ESP + CHAMS
--==============================================================================--
local ESPObjects = {}
local ChamsObjects = {}

local function CreateESP(plr)
    if ESPObjects[plr] then return end
    local t = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
    }
    t.Box.Thickness = 1
    t.Box.Filled = false
    t.Name.Size = 13
    t.Name.Center = true
    t.Name.Outline = true
    t.Health.Size = 12
    t.Health.Center = true
    t.Health.Outline = true
    t.Distance.Size = 12
    t.Distance.Center = true
    t.Distance.Outline = true
    t.Distance.Color = Color3.fromRGB(200, 200, 200)
    t.Tracer.Thickness = 1
    t.Tracer.Color = Color3.fromRGB(0, 162, 255)
    ESPObjects[plr] = t
end

Players.PlayerRemoving:Connect(function(plr)
    if ESPObjects[plr] then
        for _, d in pairs(ESPObjects[plr]) do pcall(function() d:Remove() end) end
        ESPObjects[plr] = nil
    end
    if ChamsObjects[plr] then
        ChamsObjects[plr]:Destroy()
        ChamsObjects[plr] = nil
    end
end)

--==============================================================================--
--                           MOVEMENT
--==============================================================================--
local BodyGyro, BodyVelocity

local function SetFly(state)
    Settings.Fly = state
    if Connections.Fly then Connections.Fly:Disconnect() end
    if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end

    if state then
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local root = char.HumanoidRootPart

        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.P = 9e4
        BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.cframe = root.CFrame
        BodyGyro.Parent = root

        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
        BodyVelocity.Parent = root

        AddConn("Fly", RunService.RenderStepped:Connect(function()
            if not Settings.Fly or not char or not char:FindFirstChild("Humanoid") then
                SetFly(false)
                return
            end
            BodyGyro.cframe = Camera.CFrame
            local moveDir = char.Humanoid.MoveDirection
            if moveDir.Magnitude > 0 then
                local flyDir = (Camera.CFrame.LookVector * -moveDir.Z) + (Camera.CFrame.RightVector * moveDir.X)
                BodyVelocity.velocity = flyDir.Unit * Settings.FlySpeed
            else
                BodyVelocity.velocity = Vector3.new()
            end
        end))
        Notify("Fly", "Đã bật")
    else
        Notify("Fly", "Đã tắt")
    end
end

local function SetSpeed(state)
    Settings.Speed = state
    if Connections.Speed then Connections.Speed:Disconnect() end

    if state then
        AddConn("Speed", RunService.Heartbeat:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = Settings.SpeedValue end
        end))
        Notify("Speed", "Đã bật")
    else
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
        Notify("Speed", "Đã tắt")
    end
end

local function SetNoclip(state)
    Settings.Noclip = state
    if Connections.Noclip then Connections.Noclip:Disconnect() end

    if state then
        AddConn("Noclip", RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end))
        Notify("Noclip", "Đã bật")
    else
        Notify("Noclip", "Đã tắt")
    end
end

--==============================================================================--
--                           MAIN RENDER LOOP
--==============================================================================--
AddConn("MainRender", RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    -- FOV Circle
    FOVCircle.Position = center
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Visible = Settings.Aimbot or Settings.SilentAim

    -- Crosshair
    if Settings.CustomCrosshair then
        CrosshairV.From = Vector2.new(center.X, center.Y - 10)
        CrosshairV.To = Vector2.new(center.X, center.Y + 10)
        CrosshairV.Color = Color3.fromRGB(0, 255, 180)
        CrosshairV.Thickness = 2
        CrosshairV.Visible = true

        CrosshairH.From = Vector2.new(center.X - 10, center.Y)
        CrosshairH.To = Vector2.new(center.X + 10, center.Y)
        CrosshairH.Color = Color3.fromRGB(0, 255, 180)
        CrosshairH.Thickness = 2
        CrosshairH.Visible = true
    else
        CrosshairV.Visible = false
        CrosshairH.Visible = false
    end

    -- Aimbot
    if Settings.Aimbot then
        local target = GetClosestPlayerHead()
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), Settings.AimbotSmooth)
        end
    end

    -- NPC Aimbot
    NPCFOVCircle.Visible = Settings.NPCAimbot
    NPCFOVCircle.Position = center
    NPCFOVCircle.Radius = Settings.NPCAimbotFOV
    if Settings.NPCAimbot then
        local target = GetClosestNPC()
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), Settings.NPCAimbotSmooth)
        end
    end

    -- Hitbox
    if Settings.HitboxExpander then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                pcall(function()
                    plr.Character.Head.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                    plr.Character.Head.Transparency = 0.6
                    plr.Character.Head.CanCollide = false
                end)
            end
        end
    end

    -- SpinBot
    if Settings.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
    end

    Camera.FieldOfView = Settings.CustomFOV

    -- ESP + Chams
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end

        -- Chams
        if Settings.Chams then
            if not ChamsObjects[plr] and plr.Character then
                local hl = Instance.new("Highlight")
                hl.FillColor = Settings.ChamsColor
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.35
                hl.Parent = plr.Character
                ChamsObjects[plr] = hl
            end
        else
            if ChamsObjects[plr] then
                ChamsObjects[plr]:Destroy()
                ChamsObjects[plr] = nil
            end
        end

        -- ESP
        if not Settings.ESP then
            if ESPObjects[plr] then
                for _, d in pairs(ESPObjects[plr]) do d.Visible = false end
            end
            continue
        end

        CreateESP(plr)
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
        local color = Color3.fromRGB(0, 162, 255)

        drawings.Box.Size = size
        drawings.Box.Position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
        drawings.Box.Color = color
        drawings.Box.Visible = Settings.ESPBox

        drawings.Name.Text = plr.Name
        drawings.Name.Position = Vector2.new(pos.X, pos.Y - size.Y / 2 - 15)
        drawings.Name.Color = color
        drawings.Name.Visible = Settings.ESPName

        drawings.Health.Text = math.floor(hum.Health) .. " HP"
        drawings.Health.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 3)
        drawings.Health.Color = Color3.fromRGB(255 - (hum.Health / hum.MaxHealth) * 255, (hum.Health / hum.MaxHealth) * 255, 0)
        drawings.Health.Visible = Settings.ESPHealth

        drawings.Distance.Text = math.floor(dist) .. "m"
        drawings.Distance.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 16)
        drawings.Distance.Visible = Settings.ESPDistance

        if Settings.ESPTracers then
            drawings.Tracer.From = Vector2.new(center.X, Camera.ViewportSize.Y)
            drawings.Tracer.To = Vector2.new(pos.X, pos.Y)
            drawings.Tracer.Visible = true
        else
            drawings.Tracer.Visible = false
        end
    end
end))

--==============================================================================--
--                           BASIC TROLL
--==============================================================================--
local function BringAll()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = myRoot.CFrame + Vector3.new(2, 0, 2)
        end
    end
    Notify("Bring All", "Đã thực hiện (client-side)")
end

local function FlingAll()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local original = root.CFrame
    local bav = Instance.new("BodyAngularVelocity")
    bav.AngularVelocity = Vector3.new(0, 99999, 0)
    bav.MaxTorque = Vector3.new(0, math.huge, 0)
    bav.Parent = root

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            for i = 1, 8 do
                root.CFrame = plr.Character.HumanoidRootPart.CFrame
                task.wait(0.03)
            end
        end
    end
    bav:Destroy()
    root.CFrame = original
    Notify("Fling All", "Đã thực hiện (client-side)")
end

--==============================================================================--
--                           UI
--==============================================================================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaHUD_Clean"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local ToggleIcon = Instance.new("TextButton")
ToggleIcon.Size = UDim2.new(0, 46, 0, 46)
ToggleIcon.Position = UDim2.new(0, 15, 0.4, 0)
ToggleIcon.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
ToggleIcon.Text = "Z"
ToggleIcon.TextColor3 = Color3.new(1, 1, 1)
ToggleIcon.Font = Enum.Font.GothamBold
ToggleIcon.TextSize = 22
ToggleIcon.Draggable = true
ToggleIcon.Parent = ScreenGui
Instance.new("UICorner", ToggleIcon).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 360, 0, 420)
Main.Position = UDim2.new(0.5, -180, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", Main)
stroke.Color = Color3.fromRGB(0, 162, 255)
stroke.Thickness = 1.5

ToggleIcon.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Header
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "<b>ZAKA</b>  <font color='#00A2FF'>HUD Clean</font>"
Title.RichText = true
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 14
Title.Font = Enum.Font.Gotham
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Tabs
local Tabs = {"Combat", "ESP", "Player", "Teleport", "Troll", "Utility"}
local Pages = {}
local CurrentTab = 1

local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, -12, 0, 28)
TabFrame.Position = UDim2.new(0, 6, 0, 42)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = Main

local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -12, 1, -80)
PageContainer.Position = UDim2.new(0, 6, 0, 76)
PageContainer.BackgroundTransparency = 1
PageContainer.ClipsDescendants = true
PageContainer.Parent = Main

local function CreatePage(i)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Position = UDim2.new(i - 1, 0, 0, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 162, 255)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Parent = PageContainer

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent = page
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    Pages[i] = page
    return page
end

local TabButtons = {}
for i, name in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1 / #Tabs, -2, 1, 0)
    btn.Position = UDim2.new((i - 1) / #Tabs, 1, 0, 0)
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(25, 25, 34)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TabFrame
    TabButtons[i] = btn
    CreatePage(i)

    btn.MouseButton1Click:Connect(function()
        CurrentTab = i
        for idx, b in ipairs(TabButtons) do
            TweenService:Create(b, TweenInfo.new(0.25), {
                BackgroundColor3 = idx == i and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(25, 25, 34)
            }):Play()
        end
        for idx, p in ipairs(Pages) do
            TweenService:Create(p, TweenInfo.new(0.3), {
                Position = UDim2.new(idx - CurrentTab, 0, 0, 0)
            }):Play()
        end
    end)
end

-- Helper UI
local function CreateToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 36, 0, 18)
    btn.Position = UDim2.new(1, -42, 0.5, -9)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(45, 45, 55)
    btn.Text = ""
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local enabled = default
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = enabled and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(45, 45, 55)
        }):Play()
        callback(enabled)
    end)
end

local function CreateInput(parent, text, default, maxVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 52, 0, 20)
    box.Position = UDim2.new(1, -58, 0.5, -10)
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    box.Text = tostring(default)
    box.TextColor3 = Color3.fromRGB(0, 162, 255)
    box.Font = Enum.Font.GothamBold
    box.TextSize = 12
    box.Parent = frame
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)
        if num then
            num = math.clamp(math.floor(num), 1, maxVal)
            box.Text = tostring(num)
            callback(num)
        else
            box.Text = tostring(default)
        end
    end)
end

local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -4, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

-- Tab 1: Combat
CreateToggle(Pages[1], "Aimbot", false, function(v) Settings.Aimbot = v end)
CreateToggle(Pages[1], "Silent Aim", false, function(v) Settings.SilentAim = v end)
CreateInput(Pages[1], "Aimbot FOV", 120, 600, function(v) Settings.AimbotFOV = v end)
CreateInput(Pages[1], "Aimbot Smooth (x10)", 2, 10, function(v) Settings.AimbotSmooth = v / 10 end)
CreateToggle(Pages[1], "Auto Clicker", false, function(v) SetAutoClicker(v) end)
CreateToggle(Pages[1], "Target Strafe", false, function(v) SetTargetStrafe(v) end)
CreateInput(Pages[1], "Strafe Distance", 10, 40, function(v) Settings.StrafeDistance = v end)
CreateInput(Pages[1], "Strafe Speed", 5, 20, function(v) Settings.StrafeSpeed = v end)
CreateToggle(Pages[1], "Hitbox Expander", false, function(v) Settings.HitboxExpander = v end)
CreateInput(Pages[1], "Hitbox Size", 20, 100, function(v) Settings.HitboxSize = v end)
CreateToggle(Pages[1], "NPC Aimbot", false, function(v) Settings.NPCAimbot = v end)
CreateInput(Pages[1], "NPC FOV", 140, 400, function(v) Settings.NPCAimbotFOV = v end)
CreateToggle(Pages[1], "Infinite Ammo", false, function(v) SetInfiniteAmmo(v) end)
CreateToggle(Pages[1], "Fast Fire", false, function(v) SetFastFire(v) end)

-- Tab 2: ESP
CreateToggle(Pages[2], "ESP Main", false, function(v) Settings.ESP = v end)
CreateToggle(Pages[2], "ESP Box", true, function(v) Settings.ESPBox = v end)
CreateToggle(Pages[2], "ESP Name", true, function(v) Settings.ESPName = v end)
CreateToggle(Pages[2], "ESP Health", true, function(v) Settings.ESPHealth = v end)
CreateToggle(Pages[2], "ESP Distance", true, function(v) Settings.ESPDistance = v end)
CreateToggle(Pages[2], "ESP Tracers", false, function(v) Settings.ESPTracers = v end)
CreateInput(Pages[2], "ESP Max Distance", 3000, 10000, function(v) Settings.ESPMaxDist = v end)
CreateToggle(Pages[2], "Chams", false, function(v) Settings.Chams = v end)
CreateToggle(Pages[2], "Custom Crosshair", false, function(v) Settings.CustomCrosshair = v end)
CreateInput(Pages[2], "Camera FOV", 70, 120, function(v) Settings.CustomFOV = v end)

-- Tab 3: Player
CreateToggle(Pages[3], "Speed", false, function(v) SetSpeed(v) end)
CreateInput(Pages[3], "WalkSpeed", 28, 200, function(v) Settings.SpeedValue = v end)
CreateToggle(Pages[3], "Fly", false, function(v) SetFly(v) end)
CreateInput(Pages[3], "Fly Speed", 50, 300, function(v) Settings.FlySpeed = v end)
CreateToggle(Pages[3], "Noclip", false, function(v) SetNoclip(v) end)
CreateToggle(Pages[3], "Infinite Jump", false, function(v) Settings.InfiniteJump = v end)
CreateToggle(Pages[3], "Spider Climb", false, function(v) SetSpiderClimb(v) end)
CreateToggle(Pages[3], "Water Walk", false, function(v) SetWaterWalk(v) end)
CreateToggle(Pages[3], "SpinBot", false, function(v) Settings.SpinBot = v end)
CreateInput(Pages[3], "Spin Speed", 40, 200, function(v) Settings.SpinSpeed = v end)

-- Tab 4: Teleport
CreateToggle(Pages[4], "Touch TP", false, function(v) SetTouchTP(v) end)
CreateButton(Pages[4], "Teleport to Random Player", function()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            myRoot.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            break
        end
    end
end)
CreateButton(Pages[4], "Bring All (Client)", function() BringAll() end)
CreateButton(Pages[4], "Teleport Up 100 studs", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame += Vector3.new(0, 100, 0) end
end)
CreateButton(Pages[4], "Save Position", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then _G.ZakaSavedPos = root.CFrame Notify("Position", "Đã lưu") end
end)
CreateButton(Pages[4], "Load Position", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and _G.ZakaSavedPos then root.CFrame = _G.ZakaSavedPos end
end)

-- Tab 5: Troll
CreateButton(Pages[5], "Fling All (Client)", function() FlingAll() end)
CreateToggle(Pages[5], "Chat Spammer", false, function(v) SetChatSpammer(v) end)
CreateButton(Pages[5], "Unequip All Tools", function()
    local char = LocalPlayer.Character
    if char then char:UnequipTools() end
end)

-- Tab 6: Utility
CreateToggle(Pages[6], "Anti AFK", true, function(v) Settings.AntiAFK = v end)
CreateButton(Pages[6], "Rejoin Server", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)
CreateButton(Pages[6], "Server Hop", function()
    pcall(function()
        local data = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
        for _, s in ipairs(data) do
            if s.id \~= game.JobId and s.playing < s.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                break
            end
        end
    end)
end)
CreateButton(Pages[6], "Copy JobId", function()
    if setclipboard then setclipboard(tostring(game.JobId)) Notify("JobId", "Đã copy") end
end)
CreateButton(Pages[6], "Unload Script", function()
    ClearAllConnections()
    for _, t in pairs(ESPObjects) do
        for _, d in pairs(t) do pcall(function() d:Remove() end) end
    end
    for _, hl in pairs(ChamsObjects) do pcall(function() hl:Destroy() end) end
    FOVCircle:Remove()
    NPCFOVCircle:Remove()
    CrosshairV:Remove()
    CrosshairH:Remove()
    ScreenGui:Destroy()
    Notify("Zaka HUD", "Đã unload")
end)

print("Zaka HUD Clean Version loaded!")
Notify("Zaka HUD", "Clean version đã sẵn sàng")
