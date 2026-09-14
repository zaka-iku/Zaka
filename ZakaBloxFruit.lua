--==============================================================================--
--        ZAKA BLOX // GOD-TIER MAIN HUB (ULTIMATE FARM v2.0)                   --
--==============================================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Chống Idle Disconnect (Không bị đá ra khi treo máy)
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

-- Dọn dẹp UI cũ
if PlayerGui:FindFirstChild("ZakaBloxMain") then
    PlayerGui.ZakaBloxMain:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaBloxMain"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Khung chính
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 140, 0)
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

-- Hiệu ứng mở menu
TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 580, 0, 380),
    Position = UDim2.new(0.5, -290, 0.5, -190)
}):Play()

-- Topbar kéo thả
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 28, 40)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local FixBar = Instance.new("Frame")
FixBar.Size = UDim2.new(1, 0, 0, 10)
FixBar.Position = UDim2.new(0, 0, 1, -10)
FixBar.BackgroundColor3 = Color3.fromRGB(22, 28, 40)
FixBar.BorderSizePixel = 0
FixBar.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 350, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "⚔️ ZAKA BLOX // ULTIMATE FARM v2.0"
TitleLabel.TextColor3 = Color3.fromRGB(255, 160, 0)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Nút Đóng (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
CloseBtn.BorderSizePixel = 0
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextSize = 12
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.3)
    ScreenGui:Destroy()
end)

-- Sidebar Tab
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 140, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 13, 19)
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 2
Sidebar.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = Sidebar
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 8)
UIPadding.Parent = Sidebar

local ContentContainer = Instance.new("Folder")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame

local Tabs = {}
local CurrentTab = nil

local function CreateTab(name, order)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0, 126, 0, 34)
    TabBtn.BackgroundColor3 = Color3.fromRGB(18, 23, 33)
    TabBtn.BorderSizePixel = 0
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(150, 160, 180)
    TabBtn.TextSize = 11
    TabBtn.LayoutOrder = order
    TabBtn.Parent = Sidebar
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1, -155, 1, -55)
    TabContent.Position = UDim2.new(0, 150, 0, 48)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 3
    TabContent.Visible = false
    TabContent.Parent = ContentContainer

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.Parent = TabContent

    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 2)
    ContentPadding.Parent = TabContent

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Btn.BackgroundColor3 = Color3.fromRGB(18, 23, 33)
            t.Btn.TextColor3 = Color3.fromRGB(150, 160, 180)
            t.Content.Visible = false
        end
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabContent.Visible = true
        CurrentTab = TabContent
    end)

    if not CurrentTab then
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabContent.Visible = true
        CurrentTab = TabContent
    end

    table.insert(Tabs, {Btn = TabBtn, Content = TabContent})
    return TabContent
end

-- Hàm tạo Toggle
local function AddToggle(tab, text, callback)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, -10, 0, 36)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 26, 38)
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Font = Enum.Font.GothamMedium
    ToggleBtn.Text = "  " .. text
    ToggleBtn.TextColor3 = Color3.fromRGB(210, 220, 235)
    ToggleBtn.TextSize = 11
    ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
    ToggleBtn.Parent = tab
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

    local StatusIndicator = Instance.new("Frame")
    StatusIndicator.Size = UDim2.new(0, 16, 0, 16)
    StatusIndicator.Position = UDim2.new(1, -26, 0.5, -8)
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
    StatusIndicator.BorderSizePixel = 0
    StatusIndicator.Parent = ToggleBtn
    Instance.new("UICorner", StatusIndicator).CornerRadius = UDim.new(0, 4)

    local toggled = false
    ToggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        TweenService:Create(StatusIndicator, TweenInfo.new(0.15), {
            BackgroundColor3 = toggled and Color3.fromRGB(0, 230, 110) or Color3.fromRGB(40, 50, 70)
        }):Play()
        callback(toggled)
    end)
end

-- Hàm tạo Button
local function AddButton(tab, text, callback)
    local ActionBtn = Instance.new("TextButton")
    ActionBtn.Size = UDim2.new(1, -10, 0, 36)
    ActionBtn.BackgroundColor3 = Color3.fromRGB(25, 33, 48)
    ActionBtn.BorderSizePixel = 0
    ActionBtn.AutoButtonColor = false
    ActionBtn.Font = Enum.Font.GothamMedium
    ActionBtn.Text = "  ⚡ " .. text
    ActionBtn.TextColor3 = Color3.fromRGB(255, 180, 50)
    ActionBtn.TextSize = 11
    ActionBtn.TextXAlignment = Enum.TextXAlignment.Left
    ActionBtn.Parent = tab
    Instance.new("UICorner", ActionBtn).CornerRadius = UDim.new(0, 6)

    ActionBtn.MouseButton1Click:Connect(function()
        TweenService:Create(ActionBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 140, 0)}):Play()
        task.wait(0.1)
        TweenService:Create(ActionBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 33, 48)}):Play()
        callback()
    end)
end

--==============================================================================--
--                      KHỞI TẠO CÁC TAB CHỨC NĂNG MỚI                          --
--==============================================================================--

local TabFarm = CreateTab("Auto Farm", 1)
local TabMastery = CreateTab("Thông Thạo", 2)
local TabMaterial = CreateTab("Nguyên Liệu", 3)
local TabTeleport = CreateTab("Dịch Chuyển", 4)
local TabStats = CreateTab("Chỉ Số", 5)
local TabMisc = CreateTab("Tiện Ích", 6)

-- 1. TAB AUTO FARM
AddToggle(TabFarm, "Auto Farm Level (Max Speed)", function(v)
    _G.AutoFarmLevel = v
    task.spawn(function()
        while _G.AutoFarmLevel do
            task.wait(0.3)
            pcall(function()
                -- Logic nhận quest và bay tới quái cày level
                for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        if _G.AutoFarmLevel then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 4, 3)
                            local args = { [1] = "StartQuest", [2] = "QuestNameHere", [3] = 1 }
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                        end
                    end
                end
            end)
        end
    end)
end)

AddToggle(TabFarm, "Fast Attack (Đánh Nhanh X2)", function(v)
    _G.FastAttack = v
    task.spawn(function()
        while _G.FastAttack do
            task.wait(0.1)
            pcall(function()
                local vim = game:GetService("VirtualInputManager")
                vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
        end
    end)
end)

-- 2. TAB THÔNG THẠO (MASTERY)
AddToggle(TabMastery, "Auto Farm Mastery Trái Ác Quỷ (Devil Fruit)", function(v)
    _G.FarmFruitMastery = v
    task.spawn(function()
        while _G.FarmFruitMastery do
            task.wait(0.4)
            pcall(function()
                -- Trang bị trái ác quỷ đang cầm và farm quái tối ưu khoảng cách
                for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 and _G.FarmFruitMastery then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 4)
                    end
                end
            end)
        end
    end)
end)

AddToggle(TabMastery, "Auto Farm Mastery Kiếm (Sword)", function(v)
    _G.FarmSwordMastery = v
    task.spawn(function()
        while _G.FarmSwordMastery do
            task.wait(0.4)
            pcall(function()
                for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 and _G.FarmSwordMastery then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 4, 3)
                    end
                end
            end)
        end
    end)
end)

AddToggle(TabMastery, "Auto Farm Mastery Súng (Gun)", function(v)
    _G.FarmGunMastery = v
    task.spawn(function()
        while _G.FarmGunMastery do
            task.wait(0.4)
            pcall(function()
                -- Giữ khoảng cách xa để bắn súng an toàn
                for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 and _G.FarmGunMastery then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 10, 15)
                    end
                end
            end)
        end
    end)
end)

-- 3. TAB NGUYÊN LIỆU (MATERIAL)
AddToggle(TabMaterial, "Auto Farm Xương (Bones - Haunted Castle)", function(v)
    _G.FarmBones = v
    task.spawn(function()
        while _G.FarmBones do
            task.wait(0.4)
            pcall(function()
                for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                    if mob.Name:find("Reborn Skeleton") or mob.Name:find("Demonic Soul") or mob.Name:find("Posessed Mummy") then
                        if mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 and _G.FarmBones then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 4, 3)
                        end
                    end
                end
            end)
        end
    end)
end)

AddToggle(TabMaterial, "Auto Farm Ectoplasm (Cương Thi / Quái Cursed Ship)", function(v)
    _G.FarmEcto = v
    task.spawn(function()
        while _G.FarmEcto do
            task.wait(0.4)
            pcall(function()
                for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                    if mob.Name:find("Ship") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 and _G.FarmEcto then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 4, 3)
                    end
                end
            end)
        end
    end)
end)

-- 4. TAB DỊCH CHUYỂN (TELEPORT)
AddButton(TabTeleport, "Teleport Nhanh: Đảo Bí Ẩn / Mirage Island", function()
    pcall(function()
        for _, v in pairs(Workspace:GetChildren()) do
            if v.Name:find("Mirage") or v.Name:find("Island") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = v:GetModelPivot()
                break
            end
        end
    end)
end)

AddButton(TabTeleport, "Teleport: Lâu Đài Trên Biển (Sea 3)", function()
    pcall(function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5065, 315, -3155)
    end)
end)

AddButton(TabTeleport, "Teleport: Mansion (Biệt Thự Đảo Bí Ẩn)", function()
    pcall(function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-12466, 375, -7552)
    end)
end)

AddButton(TabTeleport, "Teleport: Quán Cafe (Sea 2)", function()
    pcall(function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-382, 73, 298)
    end)
end)

-- 5. TAB CHỈ SỐ (STATS)
AddToggle(TabStats, "Auto Upgrade Melee (Cận Chiến)", function(v)
    _G.UpMelee = v
    task.spawn(function()
        while _G.UpMelee do
            task.wait(1)
            pcall(function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Melee", 3) end)
        end
    end)
end)

AddToggle(TabStats, "Auto Upgrade Defense (Phòng Thủ)", function(v)
    _G.UpDefense = v
    task.spawn(function()
        while _G.UpDefense do
            task.wait(1)
            pcall(function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Defense", 3) end)
        end
    end)
end)

AddToggle(TabStats, "Auto Upgrade Sword (Kiếm Sĩ)", function(v)
    _G.UpSword = v
    task.spawn(function()
        while _G.UpSword do
            task.wait(1)
            pcall(function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Sword", 3) end)
        end
    end)
end)

-- 6. TAB TIỆN ÍCH (MISC / FLY & SPEED)
AddToggle(TabMisc, "Fly Mode (Bay Nhanh Tự Do)", function(v)
    _G.FlyMode = v
    local bg, bv
    task.spawn(function()
        if _G.FlyMode then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")
                bg = Instance.new("BodyGyro", hrp)
                bg.P = 9e4
                bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                bv = Instance.new("BodyVelocity", hrp)
                bv.velocity = Vector3.new(0,0,0)
                bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                
                while _G.FlyMode do
                    task.wait()
                    bg.cframe = Workspace.CurrentCamera.CFrame
                    local cam = Workspace.CurrentCamera
                    local move = Vector3.new()
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
                    bv.velocity = move * 120
                end
            end)
        else
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
        end
    end)
end)

AddToggle(TabMisc, "WalkSpeed Siêu Tốc Độ (Chạy Nhanh)", function(v)
    _G.FastRun = v
    task.spawn(function()
        while _G.FastRun do
            task.wait(0.1)
            pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 120 end)
        end
        pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 16 end)
    end)
end)

AddToggle(TabMisc, "Infinite Jump (Nhảy Vô Cực Trên Không)", function(v)
    _G.InfJump = v
    local conn
    if v then
        conn = UserInputService.JumpRequest:Connect(function()
            pcall(function() LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
        end)
    else
        if conn then conn:Disconnect() end
    end
end)

print("⚔️ Zaka Blox Ultimate Farm v2.0 đã được nạp thành công!")
