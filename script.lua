--[[
    Tylevo - Chỉ Auto Farm
    Bấm F để bật/tắt Auto Farm
]]

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local AutoFarm = false

-- Anti AFK nhẹ
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Hàm Auto Farm đơn giản (dùng ProximityPrompt)
local function DoFarm()
    while AutoFarm do
        for _, prompt in pairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                pcall(function()
                    fireproximityprompt(prompt)
                end)
            end
        end
        task.wait(0.6)
    end
end

-- Bật/Tắt bằng phím F
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F then
        AutoFarm = not AutoFarm
        if AutoFarm then
            print("Auto Farm: BẬT")
            task.spawn(DoFarm)
        else
            print("Auto Farm: TẮT")
        end
    end
end)

print("Tylevo Farm loaded")
print("Bấm phím F để Bật / Tắt Auto Farm")
