-- Tải thư viện Rayfield UI an toàn
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🥚 Steal An Egg | Ultimate VIP Hub v5.0 (Auto Dodge)",
   LoadingTitle = "Đang tải hệ thống Né Quái & Auto Farm...",
   LoadingSubtitle = "by Gemini AI",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Services & Biến toàn cục
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local savedEggPos = nil
local savedHomePos = nil
local isAutoFarmOn = false
local isAutoCollectOn = false
local isNoClipOn = false
local isAutoDodgeOn = false
local customSpeed = 35

-- Hàm lấy bộ phận nhân vật
local function getCharParts()
    local char = player.Character
    if not char then return nil, nil, nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    return char, hum, hrp
end

---------------------------------------------------------
-- TAB 1: TELEPORT NÉ MAP (BYPASS)
---------------------------------------------------------
local TeleTab = Window:CreateTab("🚀 Teleport Né Map", 4483362458)

TeleTab:CreateSection("Thiết Lập Tọa Độ")

TeleTab:CreateButton({
   Name = "📍 1. Lưu Vị Trí Trứng",
   Callback = function()
       local _, _, hrp = getCharParts()
       if hrp then
           savedEggPos = hrp.CFrame
           Rayfield:Notify({ Title = "Thành Công", Content = "Đã lưu tọa độ điểm lấy trứng!", Duration = 2 })
       end
   end,
})

TeleTab:CreateButton({
   Name = "🏠 2. Lưu Vị Trí Nhà (Base)",
   Callback = function()
       local _, _, hrp = getCharParts()
       if hrp then
           savedHomePos = hrp.CFrame
           Rayfield:Notify({ Title = "Thành Công", Content = "Đã lưu tọa độ căn cứ!", Duration = 2 })
       end
   end,
})

TeleTab:CreateSection("Thực Hiện Teleport")

-- Hàm Teleport đường vòng 3 bước (Bay lên cao -> Lướt ngang -> Hạ cánh)
local function executeArcTeleport(targetCFrame)
    local char, _, hrp = getCharParts()
    if not hrp or not targetCFrame then
        Rayfield:Notify({ Title = "Lỗi", Content = "Chưa lưu vị trí!", Duration = 2 })
        return
    end

    local noclipConn = RunService.Stepped:Connect(function()
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero

    local highPos = hrp.CFrame + Vector3.new(0, 60, 0)
    local tweenUp = TweenService:Create(hrp, TweenInfo.new(0.35, Enum.EasingStyle.Linear), {CFrame = highPos})
    tweenUp:Play()

    tweenUp.Completed:Connect(function()
        local targetHighPos = targetCFrame + Vector3.new(0, 60, 0)
        local distance = (highPos.Position - targetHighPos.Position).Magnitude
        local flyTime = math.clamp(distance / 160, 0.2, 1.2)

        local tweenOver = TweenService:Create(hrp, TweenInfo.new(flyTime, Enum.EasingStyle.Linear), {CFrame = targetHighPos})
        tweenOver:Play()

        tweenOver.Completed:Connect(function()
            local tweenDown = TweenService:Create(hrp, TweenInfo.new(0.35, Enum.EasingStyle.Linear), {CFrame = targetCFrame + Vector3.new(0, 2, 0)})
            tweenDown:Play()

            tweenDown.Completed:Connect(function()
                if noclipConn then noclipConn:Disconnect() end
                hrp.AssemblyLinearVelocity = Vector3.zero
            end)
        end)
    end)
end

TeleTab:CreateButton({
   Name = "⚡ Bay Cầu Vồng Đến Chỗ Trứng",
   Callback = function()
       executeArcTeleport(savedEggPos)
   end,
})

TeleTab:CreateButton({
   Name = "🚀 Bay Cầu Vồng Về Base",
   Callback = function()
       executeArcTeleport(savedHomePos)
   end,
})

---------------------------------------------------------
-- TAB 2: AUTO FARM & TÍNH NĂNG NÉ QUÁI (AUTO DODGE)
---------------------------------------------------------
local FarmTab = Window:CreateTab("🛡️ Auto Farm & Né Quái", 4483362458)

FarmTab:CreateSection("Hệ Thống Né Quái Thông Minh (Auto Dodge)")

FarmTab:CreateToggle({
   Name = "🛡️ Bật Tự Động Né Quái (Nhảy Lên Đầu Quái)",
   CurrentValue = false,
   Callback = function(Value)
       isAutoDodgeOn = Value
       task.spawn(function()
           while isAutoDodgeOn do
               local _, _, hrp = getCharParts()
               if hrp then
                   -- Quét toàn bộ thư mục Workspace tìm quái hoặc nhân vật khác (ngoại trừ bản thân)
                   for _, model in ipairs(workspace:GetChildren()) do
                       if model:IsA("Model") and model ~= player.Character then
                           local enemyHrp = model:FindFirstChild("HumanoidRootPart")
                           local enemyHum = model:FindFirstChildOfClass("Humanoid")
                           
                           -- Nếu đối tượng có Humanoid (coi như là quái hoặc người chơi thù địch)
                           if enemyHrp and enemyHum and enemyHum.Health > 0 then
                               local distance = (hrp.Position - enemyHrp.Position).Magnitude
                               
                               -- Nếu khoảng cách dưới 12 đơn vị (quái áp sát tầm nguy hiểm)
                               if distance < 12 then
                                   -- Lập tức nhích nhẹ tele lên đỉnh đầu quái (cao hơn 10 đơn vị) để né hitbox
                                   local safeDodgeCFrame = enemyHrp.CFrame + Vector3.new(0, 10, 0)
                                   
                                   hrp.AssemblyLinearVelocity = Vector3.zero
                                   hrp.CFrame = safeDodgeCFrame
                                   
                                   -- Chờ 0.5s rồi tự động bay về lại vị trí nhà hoặc vị trí trứng an toàn
                                   task.wait(0.5)
                                   if savedHomePos then
                                       hrp.CFrame = savedHomePos
                                   end
                                   break
                               end
                           end
                       end
                   end
               end
               task.wait(0.2)
           end
       end)
   end,
})

FarmTab:CreateSection("Auto Nhặt & Cướp Trứng")

FarmTab:CreateToggle({
   Name = "🔥 Auto Nhặt Trứng (Spam Interaction)",
   CurrentValue = false,
   Callback = function(Value)
       isAutoCollectOn = Value
       task.spawn(function()
           while isAutoCollectOn do
               local _, _, hrp = getCharParts()
               if hrp then
                   for _, obj in ipairs(workspace:GetDescendants()) do
                       if obj:IsA("ProximityPrompt") then
                           fireproximityprompt(obj)
                       elseif obj:IsA("TouchTransmitter") and obj.Parent then
                           firetouchinterest(hrp, obj.Parent, 0)
                           firetouchinterest(hrp, obj.Parent, 1)
                       end
                   end
               end
               task.wait(0.2)
           end
       end)
   end,
})

FarmTab:CreateToggle({
   Name = "🔄 Auto Loop Farm (Bay Cướp -> Về Nộp)",
   CurrentValue = false,
   Callback = function(Value)
       isAutoFarmOn = Value
       task.spawn(function()
           while isAutoFarmOn do
               if savedEggPos and savedHomePos then
                   executeArcTeleport(savedEggPos)
                   task.wait(1.5)
                   
                   for _, obj in ipairs(workspace:GetDescendants()) do
                       if obj:IsA("ProximityPrompt") then fireproximityprompt(obj) end
                   end
                   task.wait(0.5)

                   executeArcTeleport(savedHomePos)
                   task.wait(2)
               else
                   Rayfield:Notify({ Title = "Cảnh Báo", Content = "Cần lưu cả 2 vị trí Trứng và Nhà trước!", Duration = 3 })
                   break
               end
           end
       end)
   end,
})

---------------------------------------------------------
-- TAB 3: BỔ TRỢ DI CHUYỂN & HỆ THỐNG
---------------------------------------------------------
local MiscTab = Window:CreateTab("🛠️ Bổ Trợ & Hack", 4483362458)

MiscTab:CreateSection("Vật Lý Nhân Vật")

MiscTab:CreateToggle({
   Name = "👻 NoClip Vĩnh Viễn (Đi Xuyên Tường)",
   CurrentValue = false,
   Callback = function(Value)
       isNoClipOn = Value
   end,
})

RunService.Stepped:Connect(function()
    if isNoClipOn then
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

MiscTab:CreateSlider({
   Name = "🏃 Chỉnh Tốc Độ Di Chuyển",
   Range = {16, 120},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 35,
   Callback = function(Value)
       customSpeed = Value
   end,
})

RunService.Heartbeat:Connect(function()
    local char, hum, hrp = getCharParts()
    if hum and hrp and hum.MoveDirection.Magnitude > 0 and customSpeed > 16 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (customSpeed / 60))
    end
end)

Rayfield:Notify({ Title = "Steal An Egg Hub", Content = "Đã tích hợp thành công Auto Dodge Né Quái!", Duration = 4 })
