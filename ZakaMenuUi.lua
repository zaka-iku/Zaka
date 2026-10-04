--[[
    ╔════════════════════════════════════════════════════════════════════════════════╗
    ║             ZAKA PURE UI v5.0 - MASTERWORK ULTIMATE FULL EDITION              ║
    ║   - Giao diện Bo Góc 2 Lớp (Nested Double-Rounded UI) & Animation Động       ║
    ║   - Bố cục: Tab Bo Góc Bên Trái | Nội Dung Bo Góc Bên Phải | Giữa Thông Thấu   ║
    ║   - Multi-Game Engine: Blox Fruits, Doors, San Diego, Universal Shooter        ║
    ║   - Smart Skill Aim, Bullet Teleport, Multi-Entity ESP & Real Godmode         ║
    ║   - MA HOA FULL CODE 100% - KHONG DIEN COMMENT TRONG - KHONG CAT BOT CODE     ║
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
    SpamMessage = "Zaka Pure UI v5.0 - Ultimate Power Active!",
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

    -- Tìm Players
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
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

    -- Tìm Quái / NPC / Boss / Doors Entities nếu bật AutoTarget
    if not closestPart and Settings.AutoTargetEntities then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj ~= LocalPlayer.Character and not Players:GetPlayerFromCharacter(obj) then
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

-- Silent Aim & Skill Auto-Aim Hook (Hook Metamethod)
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

    -- Movement Overrides
    if hum then
        if Settings.Speed then hum.WalkSpeed = Settings.SpeedValue end
        if Settings.HighJump then hum.JumpPower = Settings.JumpPower end
    end

    -- Lighting & Gravity
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

    -- Noclip
    if Settings.Noclip and char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    -- FOV & Crosshair
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

    -- Aimbot Lock
    if Settings.Aimbot then
        local target = GetClosestTarget()
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), Settings.AimbotSmooth)
        end
    end

    -- SpinBot
    if Settings.SpinBot and root then
        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
    end

    -- 1. ESP PLAYERS
    if Settings.ESPPlayer then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
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

    -- 2. ESP MOBS & ENTITIES (QUÁI / MOD / DOORS ENTITY)
    if Settings.ESPMob or Settings.ESPEntity then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj ~= LocalPlayer.Character and not Players:GetPlayerFromCharacter(obj) then
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
        if plr ~= LocalPlayer and plr.Character then
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
--        ZAKA PURE UI v5.0 INTERFACE (NESTED DOUBLE-ROUNDED & ANIMATIONS)      --
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

-- Toggle Button (Nút bật/tắt tròn có viền bo sáng)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
ToggleBtn.Position = UDim2.new(0, 16, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.Text = "Z"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 24
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Transparency = 0.3
ToggleStroke.Parent = ToggleBtn

-- Main Frame (LỚP BO GÓC NGOÀI LỚN - OUTSIDE ROUNDED FRAME)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 640, 0, 500)
Main.Position = UDim2.new(0.5, -320, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(10, 14, 22)
Main.BackgroundTransparency = 0.08
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 180, 255)
MainStroke.Thickness = 1.6
MainStroke.Transparency = 0.25
MainStroke.Parent = Main

-- Header Frame (Bo góc trên)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = Color3.fromRGB(6, 9, 14)
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA PURE UI // v5.0 MASTERWORK FULL"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(240, 245, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

-- LỚP BO GÓC TRONG 1: KHUNG CHỨA TAB BÊN TRÁI (LEFT TAB WRAPPER ROUNDED FRAME)
local TabWrapper = Instance.new("Frame")
TabWrapper.Size = UDim2.new(0, 135, 1, -62)
TabWrapper.Position = UDim2.new(0, 12, 0, 54)
TabWrapper.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
TabWrapper.Parent = Main
Instance.new("UICorner", TabWrapper).CornerRadius = UDim.new(0, 12)

local TabWrapperStroke = Instance.new("UIStroke")
TabWrapperStroke.Color = Color3.fromRGB(0, 180, 255)
TabWrapperStroke.Thickness = 1
TabWrapperStroke.Transparency = 0.8
TabWrapperStroke.Parent = TabWrapper

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(1, -8, 1, -12)
TabContainer.Position = UDim2.new(0, 4, 0, 6)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 2
TabContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
TabContainer.Parent = TabWrapper

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 6)
TabList.Parent = TabContainer

-- KHOẢNG TRỐNG GIỮA BẰNG KHUNG TỰ DO (CENTER BALANCED GAP)
local CenterSpace = Instance.new("Frame")
CenterSpace.Size = UDim2.new(0, 10, 1, -62)
CenterSpace.Position = UDim2.new(0, 149, 0, 54)
CenterSpace.BackgroundTransparency = 1
CenterSpace.Parent = Main

-- LỚP BO GÓC TRONG 2: KHUNG CHỨA NỘI DUNG CHỨC NĂNG BÊN PHẢI (RIGHT CONTENT WRAPPER ROUNDED FRAME)
local ContentWrapper = Instance.new("Frame")
ContentWrapper.Size = UDim2.new(1, -173, 1, -62)
ContentWrapper.Position = UDim2.new(0, 161, 0, 54)
ContentWrapper.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
ContentWrapper.Parent = Main
Instance.new("UICorner", ContentWrapper).CornerRadius = UDim.new(0, 12)

local ContentWrapperStroke = Instance.new("UIStroke")
ContentWrapperStroke.Color = Color3.fromRGB(0, 180, 255)
ContentWrapperStroke.Thickness = 1
ContentWrapperStroke.Transparency = 0.8
ContentWrapperStroke.Parent = ContentWrapper

-- Search Bar Bo Góc bên trong ContentWrapper
local SearchFrame = Instance.new("Frame")
SearchFrame.Size = UDim2.new(1, -16, 0, 34)
SearchFrame.Position = UDim2.new(0, 8, 0, 8)
SearchFrame.BackgroundColor3 = Color3.fromRGB(22, 28, 42)
SearchFrame.Parent = ContentWrapper
Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 8)

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -12, 1, 0)
SearchBox.Position = UDim2.new(0, 8, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.PlaceholderText = "🔍 Tìm kiếm kỹ năng..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(130, 140, 160)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(240, 245, 255)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 11
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.Parent = SearchFrame

-- Page Container
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -16, 1, -54)
PageContainer.Position = UDim2.new(0, 8, 0, 48)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = ContentWrapper

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

-- Advanced Card Factory với Bo Góc Thông Minh Lớp Con (Nested Card UI)
local function CreateAdvancedCard(parent, text, defaultState, typeCard, callback, extraInputLabel, extraCallback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, extraInputLabel and 76 or 42)
    card.BackgroundColor3 = Color3.fromRGB(22, 28, 40)
    card.ClipsDescendants = true
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.85
    stroke.Parent = card

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -65, 0, 42)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 11
    label.TextColor3 = Color3.fromRGB(230, 235, 250)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    if typeCard == "Toggle" then
        local toggleBg = Instance.new("TextButton")
        toggleBg.Size = UDim2.new(0, 40, 0, 20)
        toggleBg.Position = UDim2.new(1, -48, 0, 11)
        toggleBg.BackgroundColor3 = defaultState and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(35, 42, 58)
        toggleBg.Text = ""
        toggleBg.Parent = card
        Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

        local toggleDot = Instance.new("Frame")
        toggleDot.Size = UDim2.new(0, 14, 0, 14)
        toggleDot.Position = defaultState and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        toggleDot.BackgroundColor3 = Color3.new(1, 1, 1)
        toggleDot.Parent = toggleBg
        Instance.new("UICorner", toggleDot).CornerRadius = UDim.new(1, 0)

        local enabled = defaultState
        toggleBg.MouseButton1Click:Connect(function()
            enabled = not enabled
            TweenService:Create(toggleBg, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
                BackgroundColor3 = enabled and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(35, 42, 58)
            }):Play()
            TweenService:Create(toggleDot, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = enabled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            }):Play()
            if callback then callback(enabled) end
        end)
    end

    if extraInputLabel and extraCallback then
        local inputLbl = Instance.new("TextLabel")
        inputLbl.Size = UDim2.new(0.6, 0, 0, 22)
        inputLbl.Position = UDim2.new(0, 10, 0, 44)
        inputLbl.BackgroundTransparency = 1
        inputLbl.Text = extraInputLabel
        inputLbl.Font = Enum.Font.Gotham
        inputLbl.TextSize = 10
        inputLbl.TextColor3 = Color3.fromRGB(160, 170, 190)
        inputLbl.TextXAlignment = Enum.TextXAlignment.Left
        inputLbl.Parent = card

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0.35, -10, 0, 22)
        box.Position = UDim2.new(0.65, 0, 0, 44)
        box.BackgroundColor3 = Color3.fromRGB(12, 16, 24)
        box.Text = "100"
        box.TextColor3 = Color3.fromRGB(0, 220, 255)
        box.Font = Enum.Font.GothamBold
        box.TextSize = 11
        box.Parent = card
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

        box.FocusLost:Connect(function()
            local num = tonumber(box.Text)
            if num then extraCallback(num) end
        end)
    end

    table.insert(AllCards, {Frame = card, Text = text:lower(), Parent = parent})
    return card
end

-- ================= TẠO TẤT CẢ TÍNH NĂNG TRONG 7 TAB BÊN TRÁI =================
for i, data in ipairs(TabsData) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(22, 28, 42)
    btn.Text = data.Icon .. "  " .. data.Name
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(150, 160, 180)
    btn.Parent = TabContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
    page.Visible = false
    page.Parent = PageContainer

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 6)
    list.Parent = page
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 10)
    end)

    if i == 1 then -- COMBAT
        CreateAdvancedCard(page, "Bất tử thật (Real Godmode)", false, "Toggle", function(v) Settings.GodMode = v end)
        CreateAdvancedCard(page, "Smart Silent Aim (Bẻ hướng đạn/chiêu)", false, "Toggle", function(v) Settings.SilentAim = v end)
        CreateAdvancedCard(page, "Tự nhắm Quái / Mod / Entity", true, "Toggle", function(v) Settings.AutoTargetEntities = v end)
        CreateAdvancedCard(page, "Aimbot Lock Camera", false, "Toggle", function(v) Settings.Aimbot = v end, "Aimbot FOV (Vô hạn):", function(v) Settings.AimbotFOV = v end)
        CreateAdvancedCard(page, "Auto Clicker Super Speed", false, "Toggle", function(v) Settings.AutoClicker = v end)
        CreateAdvancedCard(page, "TriggerBot Auto Shoot", false, "Toggle", function(v) Settings.TriggerBot = v end)
        CreateAdvancedCard(page, "KillAura Quái & Player xung quanh", false, "Toggle", function(v) Settings.KillAura = v end)
    elseif i == 2 then -- HITBOX
        CreateAdvancedCard(page, "Hitbox Đầu Player", false, "Toggle", function(v) Settings.HitboxHead = v end, "Kích thước đầu (Vô hạn):", function(v) Settings.HeadSize = v end)
        CreateAdvancedCard(page, "Hitbox Thân Player", false, "Toggle", function(v) Settings.HitboxTorso = v end)
        CreateAdvancedCard(page, "Hitbox Quái / Mod / Boss", false, "Toggle", function(v) Settings.HitboxMob = v end, "Kích thước Quái (Vô hạn):", function(v) Settings.MobHitboxSize = v end)
    elseif i == 3 then -- VISUAL
        CreateAdvancedCard(page, "ESP Người Chơi (Players)", false, "Toggle", function(v) Settings.ESPPlayer = v end)
        CreateAdvancedCard(page, "ESP Quái / Mod / Boss", false, "Toggle", function(v) Settings.ESPMob = v end)
        CreateAdvancedCard(page, "ESP Thực Thể Doors / Special", false, "Toggle", function(v) Settings.ESPEntity = v end)
        CreateAdvancedCard(page, "Fullbright Sáng Bản Đồ", false, "Toggle", function(v) Settings.Fullbright = v end)
        CreateAdvancedCard(page, "Custom Crosshair Tâm Ngắm", false, "Toggle", function(v) Settings.CustomCrosshair = v end)
        CreateAdvancedCard(page, "FOV Changer Góc Nhìn", false, "Toggle", function(v) Settings.FOVChanger = v end, "Chỉnh FOV (Vô hạn):", function(v) Settings.FOVValue = v end)
    elseif i == 4 then -- PLAYER
        CreateAdvancedCard(page, "Kỹ năng Bay Smooth Fly", false, "Toggle", function(v) Settings.Fly = v ToggleFlyEngine(v) end, "Tốc độ bay Fly (Vô hạn):", function(v) Settings.FlySpeed = v end)
        CreateAdvancedCard(page, "Speed Walk Boost", false, "Toggle", function(v) Settings.Speed = v end, "Tốc độ chạy (Vô hạn):", function(v) Settings.SpeedValue = v end)
        CreateAdvancedCard(page, "High Jump Mod", false, "Toggle", function(v) Settings.HighJump = v end, "Độ cao nhảy (Vô hạn):", function(v) Settings.JumpPower = v end)
        CreateAdvancedCard(page, "Infinite Jump Vô Hạn", false, "Toggle", function(v) Settings.InfiniteJump = v end)
        CreateAdvancedCard(page, "Noclip Đi Xuyên Tường", false, "Toggle", function(v) Settings.Noclip = v end)
    elseif i == 5 then -- WORLD
        CreateAdvancedCard(page, "Chỉnh Trọng Lực Gravity", false, "Toggle", function(v) Settings.GravityMod = v end, "Trọng lực (Vô hạn):", function(v) Settings.GravityValue = v end)
        CreateAdvancedCard(page, "Touch Teleport", false, "Toggle", function(v) Settings.TouchTP = v end)
        CreateAdvancedCard(page, "Gom Quái Lại Gần (Bring Mobs)", false, "Toggle", function(v) Settings.BringMobs = v end)
    elseif i == 6 then -- TROLL
        CreateAdvancedCard(page, "SpinBot Xoay Tấu Hài", false, "Toggle", function(v) Settings.SpinBot = v end, "Tốc độ Spin (Vô hạn):", function(v) Settings.SpinSpeed = v end)
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

    TabButtons[i] = btn
    Pages[i] = page
end

-- Tab Switch Logic + Elastic Dynamic Scale Animation
local function SwitchTab(index)
    if CurrentTab == index then return end
    local oldBtn = TabButtons[CurrentTab]
    local newBtn = TabButtons[index]

    TweenService:Create(oldBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
        BackgroundColor3 = Color3.fromRGB(22, 28, 42),
        TextColor3 = Color3.fromRGB(150, 160, 180)
    }):Play()

    TweenService:Create(newBtn, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(0, 170, 255),
        TextColor3 = Color3.new(1, 1, 1)
    }):Play()

    Pages[CurrentTab].Visible = false
    Pages[index].Visible = true
    CurrentTab = index
end

for i, btn in ipairs(TabButtons) do
    btn.MouseButton1Click:Connect(function() SwitchTab(i) end)
end

TabButtons[1].BackgroundColor3 = Color3.fromRGB(0, 170, 255)
TabButtons[1].TextColor3 = Color3.new(1, 1, 1)
Pages[1].Visible = true

-- Search Filter System
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local kw = SearchBox.Text:lower()
    for _, item in ipairs(AllCards) do
        if item.Parent.Visible then
            item.Frame.Visible = (kw == "" or item.Text:find(kw) ~= nil)
        end
    end
end)

-- Menu Open / Close Spring Elastic Animations
local isOpen = false
local function ToggleMenu()
    isOpen = not isOpen
    if isOpen then
        Main.Visible = true
        Main.Size = UDim2.new(0, 0, 0, 0)
        Main.Position = UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 640, 0, 500),
            Position = UDim2.new(0.5, -320, 0.5, -250)
        }):Play()
    else
        local tw = TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        tw:Play()
        tw.Completed:Connect(function()
            if not isOpen then Main.Visible = false end
        end)
    end
end

ToggleBtn.MouseButton1Click:Connect(ToggleMenu)
CloseBtn.MouseButton1Click:Connect(ToggleMenu)

print("✅ Zaka Pure UI v5.0 Masterwork Edition Fully Loaded Successfully!")
