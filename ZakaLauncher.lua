local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🥚 Steal An Egg | AFK Safe Farm v6.0",
   LoadingTitle = "Đang tải hệ thống AFK Chống Rollback...",
   LoadingSubtitle = "by Gemini AI",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local isAFKFarmOn = false
local isAutoCollectOn = false
local customSpeed = 32 -- Tốc độ chuẩn an toàn tối đa để server chấp nhận

local function getChar()
    local char = player.Character
    if not char then return nil, nil, nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    return char, hum, hrp
end

local MainTab = Window:CreateTab("🌾 Treo Máy AFK", 4483362458)

MainTab:CreateSection("Hệ Thống Auto Farm Không Lỗi")

-- 1. Auto Nhặt Trứng Liên Tục
MainTab:CreateToggle({
   Name = "🔥 Auto Nhặt Trứng (Spam Interaction)",
   CurrentValue = false,
   Callback = function(Value)
       isAutoCollectOn = Value
       task.spawn(function()
           while isAutoCollectOn do
               local _, _, hrp = getChar()
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
               task.wait(0.15)
           end
       end)
   end,
})

-- 2. Auto Di Chuyển Đi Tìm Trứng (AFK Walk)
MainTab:CreateToggle({
   Name = "🚜 Bật AFK Tự Đi Nhặt Trứng (Chống Die/Chống Rollback)",
   CurrentValue = false,
   Callback = function(Value)
       isAFKFarmOn = Value
       task.spawn(function()
           while isAFKFarmOn do
               local _, hum, hrp = getChar()
               if hum and hrp then
                   -- Quét các quả trứng có trong map
                   local closestEgg = nil
                   local shortestDistance = math.huge
                   
                   for _, obj in ipairs(workspace:GetDescendants()) do
                       if (obj:IsA("BasePart") or obj:IsA("Model")) and string.find(string.lower(obj.Name), "egg") then
                           local part = obj:IsA("Model") and obj.PrimaryPart or obj
                           if part and part:IsA("BasePart") then
                               local dist = (hrp.Position - part.Position).Magnitude
                               if dist < shortestDistance and dist > 3 then
                                   shortestDistance = dist
                                   closestEgg = part
                               end
                           end
                       end
                   end

                   -- Nếu tìm thấy trứng, điều khiển nhân vật TỰ ĐỘNG BƯỚC ĐI đến đó (không dùng Teleport)
                   if closestEgg then
                       hum:MoveTo(closestEgg.Position)
                   end
               end
               task.wait(1)
           end
       end)
   end,
})

MainTab:CreateSection("Tốc Độ Chạy An Toàn")

MainTab:CreateSlider({
   Name = "⚡ Chỉnh Tốc Độ Di Chuyển AFK",
   Range = {16, 45},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 32,
   Callback = function(Value)
       customSpeed = Value
   end,
})

-- Giữ tốc độ di chuyển ổn định không bị server kick
RunService.Heartbeat:Connect(function()
    local _, hum, hrp = getChar()
    if hum and hrp and hum.MoveDirection.Magnitude > 0 and customSpeed > 16 then
        hum.WalkSpeed = customSpeed
    end
end)

Rayfield:Notify({ Title = "AFK Farm Ready", Content = "Bật 2 nút Auto để bắt đầu treo máy!", Duration = 4 })
