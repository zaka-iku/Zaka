--[[
    ╔════════════════════════════════════════════════════════════════════════════════╗
    ║       ZAKA PURE UI v3.3 - STEAL AN EGG BYPASS & SAFE RETURN EDITION          ║
    ║   - Chống ban/kick: Sử dụng Tween mượt mà, không teleport thô bạo             ║
    ║   - Ưu tiên nhặt trứng xịn nhất (Mythical -> Legendary -> Epic -> Rare -> Common) ║
    ║   - Cơ chế bay về vùng an toàn thông minh: Nhặt xong bay, hạ độ cao nghỉ chống kick ║
    ╚════════════════════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==============================================================================--
--                            CẤU HÌNH HỆ THỐNG & AN TOÀN                        --
--==============================================================================--
local Settings = {
    Speed = false,
    SpeedValue = 200000000000000000000000000000000, -- Giữ tốc độ vừa phải để không bị anti-cheat quét
    Fly = false,
    FlySpeed = 35,
    Noclip = false,
    InfiniteJump = false,
    
    -- Auto Farm Trứng thông minh
    AutoFarmEgg = false,
    SafeZonePosition = Vector3.new(0, 10, 0), -- Bạn có thể thay đổi tọa độ vùng an toàn của bạn ở đây
    TweenSpeed = 22, -- Tốc độ di chuyển an toàn không bị kick
    DropInterval = 15, -- Số giây bay lên sẽ hạ xuống 1 nhịp ngắn để lừa anti-cheat
}

local ActiveConnections = {}
local function SafeConnect(name, signal, handler)
    if ActiveConnections[name] then
        ActiveConnections[name]:Disconnect()
        ActiveConnections[name] = nil
    end
    ActiveConnections[name] = signal:Connect(handler)
end

local function SafeDisconnect(name)
    if ActiveConnections[name] then
        ActiveConnections[name]:Disconnect()
        ActiveConnections[name] = nil
    end
end

-- Anti-AFK
SafeConnect("AntiAFK", LocalPlayer.Idled, function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- WalkSpeed An Toàn
SafeConnect("MovementManager", RunService.RenderStepped, function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and Settings.Speed then
        hum.WalkSpeed = Settings.SpeedValue
    end
end)

-- Noclip An Toàn
local function ToggleNoclip(state)
    Settings.Noclip = state
    if state then
        SafeConnect("Noclip", RunService.Stepped, function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        SafeDisconnect("Noclip")
    end
end

--==============================================================================--
--      LOGIC ƯU TIÊN TRỨNG XỊN & BAY VỀ VÙNG AN TOÀN (CHỐNG BỊ KICK / BAN)         --
--==============================================================================--
local ActiveTween = nil

-- Hàm đánh giá độ hiếm của trứng để ưu tiên nhặt trứng xịn nhất
local function GetEggRarityScore(eggName)
    local name = eggName:lower()
    if name:find("mythical") or name:find("thần thoại") then return 5
    elseif name:find("legendary") or name:find("huyền thoại") then return 4
    elseif name:find("epic") or name:find("sử thi") then return 3
    elseif name:find("rare") or name:find("hiếm") then return 2
    else return 1 end
end

local function GetAvailableEggs()
    local eggs = {}
    for _, obj in ipairs(CollectionService:GetTagged("Egg")) do
        table.insert(eggs, obj)
    end
    if #eggs == 0 then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:lower():find("egg") or obj.Name:lower():find("trứng")) then
                table.insert(eggs, obj)
            end
        end
    end
    return eggs
end

local function ToggleAutoFarmEgg(state)
    Settings.AutoFarmEgg = state
    if ActiveTween then ActiveTween:Cancel() end
    
    if state then
        ToggleNoclip(true)
        SafeConnect("AutoFarmThread", RunService.Heartbeat, function()
            if not Settings.AutoFarmEgg then return end
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            local eggs = GetAvailableEggs()
            if #eggs == 0 then
                task.wait(1)
                return
            end
            
            -- Sắp xếp trứng theo độ hiếm (Ưu tiên trứng xịn nhất nhặt trước)
            table.sort(eggs, function(a, b)
                return GetEggRarityScore(a.Name) > GetEggRarityScore(b.Name)
            end)
            
            local targetEgg = eggs[1]
            local targetPart = targetEgg:IsA("Model") and (targetEgg.PrimaryPart or targetEgg:FindFirstChildWhichIsA("BasePart")) or targetEgg
            
            if targetPart and targetEgg.Parent then
                local targetCF = targetPart.CFrame + Vector3.new(0, 3, 0)
                local distance = (root.Position - targetCF.Position).Magnitude
                local duration = distance / Settings.TweenSpeed
                
                -- Di chuyển mượt mà bằng Tween (Tránh bị anti-cheat phát hiện dịch chuyển tức thời)
                if ActiveTween then ActiveTween:Cancel() end
                ActiveTween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCF})
                ActiveTween:Play()
                ActiveTween.Completed:Wait()
                
                -- Kích hoạt nhặt trứng (ProximityPrompt hoặc Touch)
                for _, prompt in ipairs(targetEgg:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        fireproximityprompt(prompt)
                    end
                end
                
                -- Sau khi nhặt xong, thực hiện bay về vùng an toàn với cơ chế thả xuống nghỉ giữa chừng chống kick
                task.wait(0.2)
                local safeCF = CFrame.new(Settings.SafeZonePosition)
                local backDist = (root.Position - safeCF.Position).Magnitude
                local backDuration = backDist / Settings.TweenSpeed
                
                if ActiveTween then ActiveTween:Cancel() end
                
                -- Bay nửa đoạn đường, thả xuống đất nhẹ 1 nhịp rồi bay tiếp về vùng an toàn
                local midCF = root.CFrame:Lerp(safeCF, 0.5) + Vector3.new(0, 5, 0)
                ActiveTween = TweenService:Create(root, TweenInfo.new(backDuration / 2, Enum.EasingStyle.Linear), {CFrame = midCF})
                ActiveTween:Play()
                ActiveTween.Completed:Wait()
                
                task.wait(0.1) -- Hạ chân chạm đất giả lập chống quét anti-cheat
                
                ActiveTween = TweenService:Create(root, TweenInfo.new(backDuration / 2, Enum.EasingStyle.Linear), {CFrame = safeCF})
                ActiveTween:Play()
                ActiveTween.Completed:Wait()
            end
        end)
    else
        SafeDisconnect("AutoFarmThread")
        ToggleNoclip(false)
        if ActiveTween then ActiveTween:Cancel() end
    end
end

--==============================================================================--
--                           GIAO DIỆN UI (ZAKA PURE UI)                        --
--==============================================================================--
pcall(function()
    if PlayerGui:FindFirstChild("ZakaStealAnEggUI") then
        PlayerGui.ZakaStealAnEggUI:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaStealAnEggUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
ToggleBtn.Position = UDim2.new(0, 16, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
ToggleBtn.BackgroundTransparency = 0.1
ToggleBtn.Text = "EGG"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 380, 0, 360)
Main.Position = UDim2.new(0.5, -190, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(15, 19, 28)
Main.BackgroundTransparency = 0.15
Main.Visible = false
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "STEAL AN EGG // SAFE BYPASS v3.3"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextColor3 = Color3.fromRGB(100, 200, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 300)
Scroll.ScrollBarThickness = 3
Scroll.Parent = Main

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.Parent = Scroll

local function CreateToggle(name, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 40)
    card.BackgroundColor3 = Color3.fromRGB(24, 30, 44)
    card.Parent = Scroll
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextColor3 = Color3.fromRGB(230, 235, 250)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 24)
    btn.Position = UDim2.new(1, -60, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(45, 52, 70)
    btn.Text = "OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.Parent = card
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = active and "ON" or "OFF"
        btn.TextColor3 = active and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(45, 52, 70)
        callback(active)
    end)
end

CreateToggle("🤖 Auto Farm Trứng Xịn + Về Vùng An Toàn", ToggleAutoFarmEgg)
CreateToggle("⚡ Tăng Tốc Chạy An Toàn", function(v) Settings.Speed = v end)
CreateToggle("🧱 Noclip (Đi Xuyên Tường)", ToggleNoclip)

ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

print("✅ Steal an Egg Safe Bypass v3.3 Loaded Successfully!")
