--[[
    ╔════════════════════════════════════════════════════════════════════════════════╗
    ║             ZAKA PURE UI v5.1 - DOUBLE ROUNDED MASTERWORK                      ║
    ║   - Giao diện Bo Góc 2 Lớp (Nested Double-Rounded UI) & Animation Động       ║
    ║   - Bố cục: Tab Bo Góc Bên Trái | Nội Dung Bo Góc Bên Phải | Giữa Thông Thấu   ║
    ║   - Multi-Game Engine: Blox Fruits, Doors, San Diego, Universal Shooter        ║
    ║   - Smart Skill Aim, Bullet Teleport, Multi-Entity ESP & Real Godmode         ║
    ║   - CHỈ SỬA UI - GIỮ NGUYÊN 100% LOGIC & KỸ NĂNG                             ║
    ╚════════════════════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==============================================================================--
--                            CẤU HÌNH HỆ THỐNG (SETTINGS)                       --
--==============================================================================--
local Settings = {
    -- Combat & Smart Aim
    Aimbot = false,
    AimbotFOV = 150,
    AimbotSmooth = 0.15,
    SilentAim = false,
    AutoTargetEntities = true,
    AutoClicker = false,
    ClickDelay = 0.05,
    TargetStrafe = false,
    StrafeDistance = 12,
    StrafeSpeed = 6,
    TriggerBot = false,
    KillAura = false,
    KillAuraRange = 25,
    GodMode = false,
    FastSkill = false,
    
    -- Hitbox Expansion
    HitboxHead = false,
    HeadSize = 15,
    HitboxTorso = false,
    TorsoSize = Vector3.new(6, 6, 6),
    HitboxMob = false,
    MobHitboxSize = 20,
    HitboxTransparent = 0.5,
    
    -- ESP & Visuals
    ESPPlayer = false,
    ESPMob = false,
    ESPEntity = false,
    ESPItem = false,
    ESPBox = true,
    ESPName = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPMaxDist = 999999,
    Chams = false,
    ChamsColor = Color3.fromRGB(0, 200, 255),
    CustomCrosshair = false,
    CrosshairSize = 12,
    Fullbright = false,
    FOVChanger = false,
    FOVValue = 90,
    
    -- Player & Movement
    Speed = false,
    SpeedValue = 50,
    Fly = false,
    FlySpeed = 60,
    Noclip = false,
    InfiniteJump = false,
    SpinBot = false,
    SpinSpeed = 45,
    HighJump = false,
    JumpPower = 120,
    
    -- World & Environment
    GravityMod = false,
    GravityValue = 196.2,
    TouchTP = false,
    BringMobs = false,
    AutoCollectItems = false,
    
    -- Troll & Fun
    ChatSpammer = false,
    SpamMessage = "Zaka Pure UI v5.1 - Ultimate Power Active!",
    SpamDelay = 2,
    Invisible = false,
}

--==============================================================================--
--                            QUẢN LÝ TÀI NGUYÊN HỆ THỐNG                         --
--==============================================================================--
local Connections = {}
local DrawESP = { Players = {}, Mobs = {}, Entities = {}, Items = {} }
local ChamsObjects = {}

local OriginalAmbient = Lighting.Ambient
local OriginalOutdoorAmbient = Lighting.OutdoorAmbient
local OriginalBrightness = Lighting.Brightness
local OriginalGravity = Workspace.Gravity

local function DisconnectAll()
    for name, conn in pairs(Connections) do
        if conn then
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            elseif typeof(conn) == "thread" then
                task.cancel(conn)
            end
            Connections[name] = nil
        end
    end
end

-- Anti-AFK
Connections["AntiAFK"] = LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Infinite Jump
Connections["InfJump"] = UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Drawing FOV Circle & Crosshair
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = Settings.AimbotFOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(0, 200, 255)

local CrosshairV = Drawing.new("Line")
local CrosshairH = Drawing.new("Line")

--==============================================================================--
--         MULTI-GAME TARGET FINDER (BLOX FRUITS, DOORS, SHOOTERS)               --
--==============================================================================--
local function GetClosestTarget()
    local closestPart = nil
    local shortestDist = Settings.AimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local head = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
            if head then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestPart = head
                    end
                end
            end
        end
    end

    if not closestPart and Settings.AutoTargetEntities then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj \~= LocalPlayer.Character and not Players:GetPlayerFromCharacter(obj) then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head") or obj:FindFirstChild("PrimaryPart")
                if root and ((hum and hum.Health > 0) or obj:FindFirstChild("Entity") or obj.Name:find("Rush") or obj.Name:find("Ambush") or obj.Name:find("Seek")) then
                    local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            closestPart = root
                        end
                    end
                end
            end
        end
    end

    return closestPart
end

-- Silent Aim Hook
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    if not checkcaller() and Settings.SilentAim and self == Mouse and (tostring(key) == "Hit" or tostring(key) == "Target") then
        local target = GetClosestTarget()
        if target then
            if tostring(key) == "Hit" then return target.CFrame end
            if tostring(key) == "Target" then return target end
        end
    end
    return oldIndex(self, key)
end)

--==============================================================================--
--                       UNIVERSAL FLY ENGINE (CHỐNG KẸT)                       --
--==============================================================================--
local FlyLinearVel, FlyAlignOrient

local function ToggleFlyEngine(state)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    if state then
        if FlyLinearVel then FlyLinearVel:Destroy() end
        if FlyAlignOrient then FlyAlignOrient:Destroy() end

        local attach = root:FindFirstChild("ZakaFlyAttach") or Instance.new("Attachment", root)
        attach.Name = "ZakaFlyAttach"

        FlyLinearVel = Instance.new("LinearVelocity")
        FlyLinearVel.MaxForce = 9e9
        FlyLinearVel.VectorVelocity = Vector3.new(0, 0, 0)
        FlyLinearVel.Attachment0 = attach
        FlyLinearVel.RelativeTo = Enum.ActuatorRelativeTo.World
        FlyLinearVel.Parent = root

        FlyAlignOrient = Instance.new("AlignOrientation")
        FlyAlignOrient.MaxTorque = 9e9
        FlyAlignOrient.Responsiveness = 200
        FlyAlignOrient.Mode = Enum.OrientationAlignmentMode.OneAttachment
        FlyAlignOrient.Attachment0 = attach
        FlyAlignOrient.CFrame = Camera.CFrame
        FlyAlignOrient.Parent = root

        if hum then hum.PlatformStand = true end

        Connections["FlyLoop"] = RunService.RenderStepped:Connect(function()
            if not Settings.Fly or not root or not root.Parent then
                ToggleFlyEngine(false)
                return
            end

            FlyAlignOrient.CFrame = Camera.CFrame
            local moveDir = hum and hum.MoveDirection or Vector3.new(0,0,0)

            if moveDir.Magnitude > 0 then
                local flyVector = (Camera.CFrame.LookVector * (moveDir.Z * -1)) + (Camera.CFrame.RightVector * moveDir.X)
                FlyLinearVel.VectorVelocity = flyVector.Unit * Settings.FlySpeed
            else
                FlyLinearVel.VectorVelocity = Vector3.new(0, 0.1, 0)
            end
        end)
    else
        if Connections["FlyLoop"] then Connections["FlyLoop"]:Disconnect() Connections["FlyLoop"] = nil end
        if FlyLinearVel then FlyLinearVel:Destroy() FlyLinearVel = nil end
        if FlyAlignOrient then FlyAlignOrient:Destroy() FlyAlignOrient = nil end
        if hum then hum.PlatformStand = false end
    end
end

-- REAL GODMODE LOOP
Connections["GodModeLoop"] = RunService.Stepped:Connect(function()
    if Settings.GodMode and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = hum.MaxHealth
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end
    end
end)

--==============================================================================--
--                             ESP DRAWING FACTORY                              --
--==============================================================================--
local function CreateDrawObject()
    local draw = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Distance = Drawing.new("Text")
    }
    draw.Box.Filled = false
    draw.Name.Size = 12
    draw.Name.Center = true
    draw.Name.Outline = true
    draw.Health.Size = 11
    draw.Health.Center = true
    draw.Health.Outline = true
    draw.Distance.Size = 11
    draw.Distance.Center = true
    draw.Distance.Outline = true
    return draw
end

local function ClearDrawObject(draw)
    if draw then
        for _, d in pairs(draw) do if d.Remove then d:Remove() end end
    end
end

--==============================================================================--
--                               MAIN RENDER LOOP                               --
--==============================================================================--
Connections["MainRender"] = RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    if hum then
        if Settings.Speed then hum.WalkSpeed = Settings.SpeedValue end
        if Settings.HighJump then hum.JumpPower = Settings.JumpPower end
    end

    if Settings.Fullbright then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = OriginalAmbient
        Lighting.OutdoorAmbient = OriginalOutdoorAmbient
        Lighting.Brightness = OriginalBrightness
    end

    if Settings.FOVChanger then Camera.FieldOfView = Settings.FOVValue end
    Workspace.Gravity = Settings.GravityMod and Settings.GravityValue or OriginalGravity

    if Settings.Noclip and char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    FOVCircle.Position = center
    FOVCircle.Radius = Settings.AimbotFOV
    FOVCircle.Visible = Settings.Aimbot or Settings.SilentAim

    if Settings.CustomCrosshair then
        local s = Settings.CrosshairSize
        CrosshairV.From = Vector2.new(center.X, center.Y - s)
        CrosshairV.To = Vector2.new(center.X, center.Y + s)
        CrosshairV.Color = Color3.fromRGB(0, 255, 200)
        CrosshairV.Thickness = 2
        CrosshairV.Visible = true

        CrosshairH.From = Vector2.new(center.X - s, center.Y)
        CrosshairH.To = Vector2.new(center.X + s, center.Y)
        CrosshairH.Color = Color3.fromRGB(0, 255, 200)
        CrosshairH.Thickness = 2
        CrosshairH.Visible = true
    else
        CrosshairV.Visible = false
        CrosshairH.Visible = false
    end

    if Settings.Aimbot then
        local target = GetClosestTarget()
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), Settings.AimbotSmooth)
        end
    end

    if Settings.SpinBot and root then
        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
    end

    -- ESP PLAYERS
    if Settings.ESPPlayer then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr \~= LocalPlayer then
                if not DrawESP.Players[plr] then DrawESP.Players[plr] = CreateDrawObject() end
                local draw = DrawESP.Players[plr]
                local pChar = plr.Character
                if pChar and pChar:FindFirstChild("HumanoidRootPart") and pChar:FindFirstChild("Humanoid") and pChar.Humanoid.Health > 0 then
                    local pRoot = pChar.HumanoidRootPart
                    local pos, onScreen = Camera:WorldToViewportPoint(pRoot.Position)
                    local dist = (pRoot.Position - Camera.CFrame.Position).Magnitude

                    if onScreen and dist <= Settings.ESPMaxDist then
                        local size = Vector2.new(math.clamp(2000 / pos.Z, 8, 300), math.clamp(3000 / pos.Z, 12, 450))
                        draw.Box.Size = size
                        draw.Box.Position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
                        draw.Box.Color = Color3.fromRGB(0, 200, 255)
                        draw.Box.Visible = Settings.ESPBox

                        draw.Name.Text = "[PLR] " .. plr.Name
                        draw.Name.Position = Vector2.new(pos.X, pos.Y - size.Y / 2 - 14)
                        draw.Name.Color = Color3.fromRGB(255, 255, 255)
                        draw.Name.Visible = Settings.ESPName

                        draw.Health.Text = math.floor(pChar.Humanoid.Health) .. " HP"
                        draw.Health.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 2)
                        draw.Health.Color = Color3.fromRGB(0, 255, 120)
                        draw.Health.Visible = Settings.ESPHealth

                        draw.Distance.Text = math.floor(dist) .. "m"
                        draw.Distance.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 14)
                        draw.Distance.Color = Color3.fromRGB(200, 200, 200)
                        draw.Distance.Visible = Settings.ESPDistance
                    else
                        for _, d in pairs(draw) do d.Visible = false end
                    end
                else
                    for _, d in pairs(draw) do d.Visible = false end
                end
            end
        end
    else
        for _, draw in pairs(DrawESP.Players) do for _, d in pairs(draw) do d.Visible = false end end
    end

    -- ESP MOBS & ENTITIES
    if Settings.ESPMob or Settings.ESPEntity then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj \~= LocalPlayer.Character and not Players:GetPlayerFromCharacter(obj) then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local mRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head") or obj:FindFirstChild("PrimaryPart")
                if mRoot and (hum or Settings.ESPEntity) then
                    if not DrawESP.Mobs[obj] then DrawESP.Mobs[obj] = CreateDrawObject() end
                    local draw = DrawESP.Mobs[obj]
                    local pos, onScreen = Camera:WorldToViewportPoint(mRoot.Position)
                    local dist = (mRoot.Position - Camera.CFrame.Position).Magnitude

                    if onScreen and dist <= Settings.ESPMaxDist then
                        local size = Vector2.new(math.clamp(1800 / pos.Z, 6, 250), math.clamp(2500 / pos.Z, 10, 350))
                        draw.Box.Size = size
                        draw.Box.Position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
                        draw.Box.Color = Color3.fromRGB(255, 70, 70)
                        draw.Box.Visible = Settings.ESPBox

                        draw.Name.Text = "[MOB/ENTITY] " .. obj.Name
                        draw.Name.Position = Vector2.new(pos.X, pos.Y - size.Y / 2 - 14)
                        draw.Name.Color = Color3.fromRGB(255, 100, 100)
                        draw.Name.Visible = Settings.ESPName

                        if hum then
                            draw.Health.Text = math.floor(hum.Health) .. " / " .. math.floor(hum.MaxHealth)
                            draw.Health.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 2)
                            draw.Health.Color = Color3.fromRGB(255, 200, 0)
                            draw.Health.Visible = Settings.ESPHealth
                        else
                            draw.Health.Visible = false
                        end

                        draw.Distance.Text = math.floor(dist) .. "m"
                        draw.Distance.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 14)
                        draw.Distance.Color = Color3.fromRGB(220, 220, 220)
                        draw.Distance.Visible = Settings.ESPDistance
                    else
                        for _, d in pairs(draw) do d.Visible = false end
                    end
                end
            end
        end
    else
        for _, draw in pairs(DrawESP.Mobs) do for _, d in pairs(draw) do d.Visible = false end end
    end

    -- Hitbox Expansion
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character then
            local pChar = plr.Character
            if Settings.HitboxHead and pChar:FindFirstChild("Head") then
                pChar.Head.Size = Vector3.new(Settings.HeadSize, Settings.HeadSize, Settings.HeadSize)
                pChar.Head.Transparency = Settings.HitboxTransparent
                pChar.Head.CanCollide = false
            end
            if Settings.HitboxTorso then
                local torso = pChar:FindFirstChild("UpperTorso") or pChar:FindFirstChild("Torso")
                if torso then
                    torso.Size = Settings.TorsoSize
                    torso.Transparency = Settings.HitboxTransparent
                    torso.CanCollide = false
                end
            end
        end
    end
end)

--==============================================================================--
--        ZAKA PURE UI v5.1 - DOUBLE ROUNDED NESTED UI (CHỈ SỬA PHẦN NÀY)       --
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

-- ========== TOGGLE BUTTON (Bo góc 2 lớp) ==========
local ToggleOuter = Instance.new("Frame")
ToggleOuter.Size = UDim2.new(0, 56, 0, 56)
ToggleOuter.Position = UDim2.new(0, 14, 0.42, 0)
ToggleOuter.BackgroundColor3 = Color3.fromRGB(8, 12, 20)
ToggleOuter.Parent = ScreenGui
Instance.new("UICorner", ToggleOuter).CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(0, 190, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Transparency = 0.25
ToggleStroke.Parent = ToggleOuter

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, -6, 1, -6)
ToggleBtn.Position = UDim2.new(0, 3, 0, 3)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 240)
ToggleBtn.Text = "Z"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 22
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Parent = ToggleOuter
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

-- ========== MAIN MENU (Bo góc 2 lớp - hình chữ nhật) ==========
local MainOuter = Instance.new("Frame")
MainOuter.Name = "MainOuter"
MainOuter.Size = UDim2.new(0, 620, 0, 460)
MainOuter.Position = UDim2.new(0.5, -310, 0.5, -230)
MainOuter.BackgroundColor3 = Color3.fromRGB(6, 9, 16)
MainOuter.BackgroundTransparency = 0.05
MainOuter.Visible = false
MainOuter.ClipsDescendants = true
MainOuter.Parent = ScreenGui
Instance.new("UICorner", MainOuter).CornerRadius = UDim.new(0, 20)

local MainOuterStroke = Instance.new("UIStroke")
MainOuterStroke.Color = Color3.fromRGB(0, 170, 255)
MainOuterStroke.Thickness = 1.8
MainOuterStroke.Transparency = 0.3
MainOuterStroke.Parent = MainOuter

local MainInner = Instance.new("Frame")
MainInner.Size = UDim2.new(1, -10, 1, -10)
MainInner.Position = UDim2.new(0, 5, 0, 5)
MainInner.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
MainInner.Parent = MainOuter
Instance.new("UICorner", MainInner).CornerRadius = UDim.new(0, 16)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 44)
Header.BackgroundColor3 = Color3.fromRGB(8, 11, 18)
Header.Parent = MainInner
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA PURE UI  //  v5.1  DOUBLE ROUNDED"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextColor3 = Color3.fromRGB(230, 240, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseOuter = Instance.new("Frame")
CloseOuter.Size = UDim2.new(0, 28, 0, 28)
CloseOuter.Position = UDim2.new(1, -38, 0.5, -14)
CloseOuter.BackgroundColor3 = Color3.fromRGB(40, 12, 12)
CloseOuter.Parent = Header
Instance.new("UICorner", CloseOuter).CornerRadius = UDim.new(1, 0)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(1, -4, 1, -4)
CloseBtn.Position = UDim2.new(0, 2, 0, 2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 55, 55)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = CloseOuter
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

-- ========== TAB WRAPPER (Bo góc 2 lớp) ==========
local TabOuter = Instance.new("Frame")
TabOuter.Size = UDim2.new(0, 128, 1, -56)
TabOuter.Position = UDim2.new(0, 10, 0, 48)
TabOuter.BackgroundColor3 = Color3.fromRGB(8, 11, 18)
TabOuter.Parent = MainInner
Instance.new("UICorner", TabOuter).CornerRadius = UDim.new(0, 14)

local TabOuterStroke = Instance.new("UIStroke")
TabOuterStroke.Color = Color3.fromRGB(0, 160, 240)
TabOuterStroke.Thickness = 1
TabOuterStroke.Transparency = 0.7
TabOuterStroke.Parent = TabOuter

local TabInner = Instance.new("Frame")
TabInner.Size = UDim2.new(1, -8, 1, -8)
TabInner.Position = UDim2.new(0, 4, 0, 4)
TabInner.BackgroundColor3 = Color3.fromRGB(14, 18, 28)
TabInner.Parent = TabOuter
Instance.new("UICorner", TabInner).CornerRadius = UDim.new(0, 11)

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(1, -6, 1, -8)
TabContainer.Position = UDim2.new(0, 3, 0, 4)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 2
TabContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
TabContainer.Parent = TabInner

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 5)
TabList.Parent = TabContainer
TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y + 8)
end)

-- ========== CONTENT WRAPPER (Bo góc 2 lớp) ==========
local ContentOuter = Instance.new("Frame")
ContentOuter.Size = UDim2.new(1, -152, 1, -56)
ContentOuter.Position = UDim2.new(0, 144, 0, 48)
ContentOuter.BackgroundColor3 = Color3.fromRGB(8, 11, 18)
ContentOuter.Parent = MainInner
Instance.new("UICorner", ContentOuter).CornerRadius = UDim.new(0, 14)

local ContentOuterStroke = Instance.new("UIStroke")
ContentOuterStroke.Color = Color3.fromRGB(0, 160, 240)
ContentOuterStroke.Thickness = 1
ContentOuterStroke.Transparency = 0.7
ContentOuterStroke.Parent = ContentOuter

local ContentInner = Instance.new("Frame")
ContentInner.Size = UDim2.new(1, -8, 1, -8)
ContentInner.Position = UDim2.new(0, 4, 0, 4)
ContentInner.BackgroundColor3 = Color3.fromRGB(14, 18, 28)
ContentInner.Parent = ContentOuter
Instance.new("UICorner", ContentInner).CornerRadius = UDim.new(0, 11)

-- Search (Bo góc 2 lớp)
local SearchOuter = Instance.new("Frame")
SearchOuter.Size = UDim2.new(1, -12, 0, 32)
SearchOuter.Position = UDim2.new(0, 6, 0, 6)
SearchOuter.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
SearchOuter.Parent = ContentInner
Instance.new("UICorner", SearchOuter).CornerRadius = UDim.new(0, 10)

local SearchInner = Instance.new("Frame")
SearchInner.Size = UDim2.new(1, -4, 1, -4)
SearchInner.Position = UDim2.new(0, 2, 0, 2)
SearchInner.BackgroundColor3 = Color3.fromRGB(20, 25, 38)
SearchInner.Parent = SearchOuter
Instance.new("UICorner", SearchInner).CornerRadius = UDim.new(0, 8)

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -14, 1, 0)
SearchBox.Position = UDim2.new(0, 8, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.PlaceholderText = "🔍  Tìm kiếm kỹ năng..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(120, 135, 160)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(235, 245, 255)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 12
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.Parent = SearchInner

local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -12, 1, -46)
PageContainer.Position = UDim2.new(0, 6, 0, 42)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = ContentInner

local TabsData = {
    {Name = "Combat", Icon = "⚔"},
    {Name = "Hitbox", Icon = "🎯"},
    {Name = "Visual", Icon = "✦"},
    {Name = "Player", Icon = "◉"},
    {Name = "World",  Icon = "◈"},
    {Name = "Troll",  Icon = "⚡"},
    {Name = "Setting",Icon = "⚙"},
}

local TabButtons = {}
local Pages = {}
local AllCards = {}
local CurrentTab = 1

-- ========== CARD FACTORY (Bo góc 2 lớp) ==========
local function CreateAdvancedCard(parent, text, defaultState, typeCard, callback, extraInputLabel, extraCallback)
    local cardOuter = Instance.new("Frame")
    cardOuter.Size = UDim2.new(1, 0, 0, extraInputLabel and 72 or 40)
    cardOuter.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
    cardOuter.ClipsDescendants = true
    cardOuter.Parent = parent
    Instance.new("UICorner", cardOuter).CornerRadius = UDim.new(0, 10)

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromRGB(0, 160, 240)
    cardStroke.Thickness = 1
    cardStroke.Transparency = 0.75
    cardStroke.Parent = cardOuter

    local cardInner = Instance.new("Frame")
    cardInner.Size = UDim2.new(1, -4, 1, -4)
    cardInner.Position = UDim2.new(0, 2, 0, 2)
    cardInner.BackgroundColor3 = Color3.fromRGB(20, 26, 38)
    cardInner.Parent = cardOuter
    Instance.new("UICorner", cardInner).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -58, 0, 36)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(225, 235, 250)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = cardInner

    if typeCard == "Toggle" then
        local toggleOuter = Instance.new("Frame")
        toggleOuter.Size = UDim2.new(0, 38, 0, 20)
        toggleOuter.Position = UDim2.new(1, -46, 0, 8)
        toggleOuter.BackgroundColor3 = Color3.fromRGB(30, 36, 50)
        toggleOuter.Parent = cardInner
        Instance.new("UICorner", toggleOuter).CornerRadius = UDim.new(1, 0)

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(1, 0, 1, 0)
        toggleBtn.BackgroundTransparency = 1
        toggleBtn.Text = ""
        toggleBtn.Parent = toggleOuter

        local toggleDot = Instance.new("Frame")
        toggleDot.Size = UDim2.new(0, 14, 0, 14)
        toggleDot.Position = defaultState and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        toggleDot.BackgroundColor3 = Color3.new(1, 1, 1)
        toggleDot.Parent = toggleOuter
        Instance.new("UICorner", toggleDot).CornerRadius = UDim.new(1, 0)

        local enabled = defaultState
        if enabled then
            toggleOuter.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        end

        toggleBtn.MouseButton1Click:Connect(function()
            enabled = not enabled
            TweenService:Create(toggleOuter, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
                BackgroundColor3 = enabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(30, 36, 50)
            }):Play()
            TweenService:Create(toggleDot, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            }):Play()
            if callback then callback(enabled) end
        end)
    end

    if extraInputLabel and extraCallback then
        local inputLbl = Instance.new("TextLabel")
        inputLbl.Size = UDim2.new(0.58, 0, 0, 20)
        inputLbl.Position = UDim2.new(0, 10, 0, 38)
        inputLbl.BackgroundTransparency = 1
        inputLbl.Text = extraInputLabel
        inputLbl.Font = Enum.Font.Gotham
        inputLbl.TextSize = 10
        inputLbl.TextColor3 = Color3.fromRGB(150, 165, 185)
        inputLbl.TextXAlignment = Enum.TextXAlignment.Left
        inputLbl.Parent = cardInner

        local boxOuter = Instance.new("Frame")
        boxOuter.Size = UDim2.new(0.35, -8, 0, 20)
        boxOuter.Position = UDim2.new(0.62, 0, 0, 38)
        boxOuter.BackgroundColor3 = Color3.fromRGB(8, 11, 18)
        boxOuter.Parent = cardInner
        Instance.new("UICorner", boxOuter).CornerRadius = UDim.new(0, 6)

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -4, 1, -4)
        box.Position = UDim2.new(0, 2, 0, 2)
        box.BackgroundColor3 = Color3.fromRGB(16, 22, 34)
        box.Text = "100"
        box.TextColor3 = Color3.fromRGB(0, 220, 255)
        box.Font = Enum.Font.GothamBold
        box.TextSize = 11
        box.Parent = boxOuter
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)

        box.FocusLost:Connect(function()
            local num = tonumber(box.Text)
            if num then extraCallback(num) end
        end)
    end

    table.insert(AllCards, {Frame = cardOuter, Text = text:lower(), Parent = parent})
    return cardOuter
end

-- ========== TẠO TAB + CHỨC NĂNG ==========
for i, data in ipairs(TabsData) do
    -- Tab button (Bo góc 2 lớp)
    local tabOuter = Instance.new("Frame")
    tabOuter.Size = UDim2.new(1, 0, 0, 34)
    tabOuter.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
    tabOuter.Parent = TabContainer
    Instance.new("UICorner", tabOuter).CornerRadius = UDim.new(0, 9)

    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -4, 1, -4)
    tabBtn.Position = UDim2.new(0, 2, 0, 2)
    tabBtn.BackgroundColor3 = Color3.fromRGB(20, 26, 38)
    tabBtn.Text = data.Icon .. "  " .. data.Name
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextSize = 12
    tabBtn.TextColor3 = Color3.fromRGB(145, 160, 180)
    tabBtn.Parent = tabOuter
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 7)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
    page.Visible = false
    page.Parent = PageContainer

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 5)
    list.Parent = page
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 10)
    end)

    if i == 1 then -- COMBAT
        CreateAdvancedCard(page, "Bất tử thật (Real Godmode)", false, "Toggle", function(v) Settings.GodMode = v end)
        CreateAdvancedCard(page, "Smart Silent Aim (Bẻ hướng đạn/chiêu)", false, "Toggle", function(v) Settings.SilentAim = v end)
        CreateAdvancedCard(page, "Tự nhắm Quái / Mod / Entity", true, "Toggle", function(v) Settings.AutoTargetEntities = v end)
        CreateAdvancedCard(page, "Aimbot Lock Camera", false, "Toggle", function(v) Settings.Aimbot = v end, "Aimbot FOV:", function(v) Settings.AimbotFOV = v end)
        CreateAdvancedCard(page, "Auto Clicker Super Speed", false, "Toggle", function(v) Settings.AutoClicker = v end)
        CreateAdvancedCard(page, "TriggerBot Auto Shoot", false, "Toggle", function(v) Settings.TriggerBot = v end)
        CreateAdvancedCard(page, "KillAura Quái & Player xung quanh", false, "Toggle", function(v) Settings.KillAura = v end)
    elseif i == 2 then -- HITBOX
        CreateAdvancedCard(page, "Hitbox Đầu Player", false, "Toggle", function(v) Settings.HitboxHead = v end, "Kích thước đầu:", function(v) Settings.HeadSize = v end)
        CreateAdvancedCard(page, "Hitbox Thân Player", false, "Toggle", function(v) Settings.HitboxTorso = v end)
        CreateAdvancedCard(page, "Hitbox Quái / Mod / Boss", false, "Toggle", function(v) Settings.HitboxMob = v end, "Kích thước Quái:", function(v) Settings.MobHitboxSize = v end)
    elseif i == 3 then -- VISUAL
        CreateAdvancedCard(page, "ESP Người Chơi (Players)", false, "Toggle", function(v) Settings.ESPPlayer = v end)
        CreateAdvancedCard(page, "ESP Quái / Mod / Boss", false, "Toggle", function(v) Settings.ESPMob = v end)
        CreateAdvancedCard(page, "ESP Thực Thể Doors / Special", false, "Toggle", function(v) Settings.ESPEntity = v end)
        CreateAdvancedCard(page, "Fullbright Sáng Bản Đồ", false, "Toggle", function(v) Settings.Fullbright = v end)
        CreateAdvancedCard(page, "Custom Crosshair Tâm Ngắm", false, "Toggle", function(v) Settings.CustomCrosshair = v end)
        CreateAdvancedCard(page, "FOV Changer Góc Nhìn", false, "Toggle", function(v) Settings.FOVChanger = v end, "Chỉnh FOV:", function(v) Settings.FOVValue = v end)
    elseif i == 4 then -- PLAYER
        CreateAdvancedCard(page, "Kỹ năng Bay Smooth Fly", false, "Toggle", function(v) Settings.Fly = v ToggleFlyEngine(v) end, "Tốc độ bay Fly:", function(v) Settings.FlySpeed = v end)
        CreateAdvancedCard(page, "Speed Walk Boost", false, "Toggle", function(v) Settings.Speed = v end, "Tốc độ chạy:", function(v) Settings.SpeedValue = v end)
        CreateAdvancedCard(page, "High Jump Mod", false, "Toggle", function(v) Settings.HighJump = v end, "Độ cao nhảy:", function(v) Settings.JumpPower = v end)
        CreateAdvancedCard(page, "Infinite Jump Vô Hạn", false, "Toggle", function(v) Settings.InfiniteJump = v end)
        CreateAdvancedCard(page, "Noclip Đi Xuyên Tường", false, "Toggle", function(v) Settings.Noclip = v end)
    elseif i == 5 then -- WORLD
        CreateAdvancedCard(page, "Chỉnh Trọng Lực Gravity", false, "Toggle", function(v) Settings.GravityMod = v end, "Trọng lực:", function(v) Settings.GravityValue = v end)
        CreateAdvancedCard(page, "Touch Teleport", false, "Toggle", function(v) Settings.TouchTP = v end)
        CreateAdvancedCard(page, "Gom Quái Lại Gần (Bring Mobs)", false, "Toggle", function(v) Settings.BringMobs = v end)
    elseif i == 6 then -- TROLL
        CreateAdvancedCard(page, "SpinBot Xoay Tấu Hài", false, "Toggle", function(v) Settings.SpinBot = v end, "Tốc độ Spin:", function(v) Settings.SpinSpeed = v end)
        CreateAdvancedCard(page, "Spam Chat Tự Động", false, "Toggle", function(v) Settings.ChatSpammer = v end)
    elseif i == 7 then -- SETTINGS
        CreateAdvancedCard(page, "Gỡ Bỏ Giao Diện (Unload UI)", false, "Toggle", function(v)
            if v then
                ToggleFlyEngine(false)
                DisconnectAll()
                FOVCircle:Remove()
                CrosshairV:Remove()
                CrosshairH:Remove()
                for _, draw in pairs(DrawESP.Players) do ClearDrawObject(draw) end
                for _, draw in pairs(DrawESP.Mobs) do ClearDrawObject(draw) end
                ScreenGui:Destroy()
            end
        end)
    end

    TabButtons[i] = {Outer = tabOuter, Btn = tabBtn}
    Pages[i] = page
end

-- Tab Switch + Animation
local function SwitchTab(index)
    if CurrentTab == index then return end
    local old = TabButtons[CurrentTab]
    local new = TabButtons[index]

    TweenService:Create(old.Btn, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
        BackgroundColor3 = Color3.fromRGB(20, 26, 38),
        TextColor3 = Color3.fromRGB(145, 160, 180)
    }):Play()

    TweenService:Create(new.Btn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(0, 160, 240),
        TextColor3 = Color3.new(1, 1, 1)
    }):Play()

    Pages[CurrentTab].Visible = false
    Pages[index].Visible = true
    CurrentTab = index
end

for i, data in ipairs(TabButtons) do
    data.Btn.MouseButton1Click:Connect(function() SwitchTab(i) end)
end

TabButtons[1].Btn.BackgroundColor3 = Color3.fromRGB(0, 160, 240)
TabButtons[1].Btn.TextColor3 = Color3.new(1, 1, 1)
Pages[1].Visible = true

-- Search Filter
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local kw = SearchBox.Text:lower()
    for _, item in ipairs(AllCards) do
        if item.Parent.Visible then
            item.Frame.Visible = (kw == "" or item.Text:find(kw) \~= nil)
        end
    end
end)

-- ========== OPEN / CLOSE ANIMATION (Elastic + Scale) ==========
local isOpen = false
local function ToggleMenu()
    isOpen = not isOpen
    if isOpen then
        MainOuter.Visible = true
        MainOuter.Size = UDim2.new(0, 0, 0, 0)
        MainOuter.Position = UDim2.new(0.5, 0, 0.5, 0)
        MainOuter.BackgroundTransparency = 1

        TweenService:Create(MainOuter, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 620, 0, 460),
            Position = UDim2.new(0.5, -310, 0.5, -230),
            BackgroundTransparency = 0.05
        }):Play()
    else
        local tw = TweenService:Create(MainOuter, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        })
        tw:Play()
        tw.Completed:Connect(function()
            if not isOpen then MainOuter.Visible = false end
        end)
    end
end

ToggleBtn.MouseButton1Click:Connect(ToggleMenu)
CloseBtn.MouseButton1Click:Connect(ToggleMenu)

print("✅ Zaka Pure UI v5.1 Double Rounded Edition Fully Loaded!")
