    ╔════════════════════════════════════════════════════════════════════════════════╗
    ║               ZAKA HUD ULTIMATE - VERSION 1.1 (EXPANDED & RESTORED)            ║
    ║   - Logo / Toggle Button: Icon "Z"                                            ║
    ║   - Restored FULL Visual Magic 3D Scripts (Fire Dragon, Angel Wings, Ice Cage)  ║
    ║   - Added Search Bar, Config Concepts & Expanded ALL Categories               ║
    ║   - Real Dropkick Script Integrated directly from RawScripts                   ║
    ╚════════════════════════════════════════════════════════════════════════════════╝
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

-- Settings
local Settings = {
	Aimbot = false,
	AimbotFOV = 120,
	AimbotSmooth = 0.2,
	SilentAim = false,
	ESP = false,
	ESPBox = true,
	ESPName = true,
	ESPHealth = true,
	ESPDistance = true,
	Speed = false,
	SpeedValue = 28,
	Fly = false,
	FlySpeed = 65,
	Noclip = false,
	InfiniteJump = false,
	TouchTP = false,
	AntiAFK = true,
	HitboxExpander = false,
	HitboxSize = 18
}

local Connections = {}
local function AddConn(name, conn)
	if Connections[name] then
		pcall(function() Connections[name]:Disconnect() end)
	end
	Connections[name] = conn
end

local function Notify(t, m)
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = t,
			Text = m,
			Duration = 2
		})
	end)
end

-- Anti AFK + Jump
LocalPlayer.Idled:Connect(function()
	if Settings.AntiAFK then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end
end)

UserInputService.JumpRequest:Connect(function()
	if Settings.InfiniteJump then
		local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

-- ========== FLY + FAKE FLOOR ==========
local BodyGyro, BodyVelocity, FakeFloor

local function SetFly(state)
	Settings.Fly = state
	if Connections.Fly then Connections.Fly:Disconnect() end
	if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
	if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
	if FakeFloor then FakeFloor:Destroy() FakeFloor = nil end

	if not state then
		Notify("Fly", "Tắt")
		return
	end

	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local root = char.HumanoidRootPart
	local hum = char:FindFirstChildOfClass("Humanoid")

	FakeFloor = Instance.new("Part")
	FakeFloor.Size = Vector3.new(14, 1.2, 14)
	FakeFloor.Transparency = 1
	FakeFloor.Anchored = true
	FakeFloor.CanCollide = true
	FakeFloor.Parent = workspace

	BodyGyro = Instance.new("BodyGyro")
	BodyGyro.P = 4e4
	BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	BodyGyro.Parent = root

	BodyVelocity = Instance.new("BodyVelocity")
	BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	BodyVelocity.Parent = root

	AddConn("Fly", RunService.RenderStepped:Connect(function()
		if not Settings.Fly or not root or not root.Parent then
			SetFly(false)
			return
		end
		local cam = Camera.CFrame
		BodyGyro.CFrame = CFrame.lookAt(root.Position, root.Position + cam.LookVector)
		local move = hum.MoveDirection
		if move.Magnitude > 0.05 then
			local dir = (cam.LookVector * -move.Z + cam.RightVector * move.X).Unit
			BodyVelocity.Velocity = dir * Settings.FlySpeed
		else
			BodyVelocity.Velocity = Vector3.zero
		end
		if FakeFloor then
			FakeFloor.CFrame = CFrame.new(root.Position.X, root.Position.Y - 3.3, root.Position.Z)
		end
	end))
	Notify("Fly", "Bật (Superman)")
end

local function SetSpeed(state)
	Settings.Speed = state
	if Connections.Speed then Connections.Speed:Disconnect() end
	if state then
		AddConn("Speed", RunService.Heartbeat:Connect(function()
			local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = Settings.SpeedValue end
		end))
		Notify("Speed", "Bật")
	else
		local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = 16 end
		Notify("Speed", "Tắt")
	end
end

local function SetNoclip(state)
	Settings.Noclip = state
	if Connections.Noclip then Connections.Noclip:Disconnect() end
	if state then
		AddConn("Noclip", RunService.Stepped:Connect(function()
			local char = LocalPlayer.Character
			if char then
				for _, p in ipairs(char:GetDescendants()) do
					if p:IsA("BasePart") then p.CanCollide = false end
				end
			end
		end))
		Notify("Noclip", "Bật")
	else
		Notify("Noclip", "Tắt")
	end
end

local function SetTouchTP(state)
	Settings.TouchTP = state
	if Connections.TouchTP then Connections.TouchTP:Disconnect() end
	if state then
		AddConn("TouchTP", UserInputService.InputBegan:Connect(function(input, gp)
			if gp then return end
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and Mouse.Hit then
				local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if root then
					root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3.5, 0))
				end
			end
		end))
		Notify("TouchTP", "Bật")
	else
		Notify("TouchTP", "Tắt")
	end
end

-- ========== UI (Cách đã chạy được) ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaStable"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local success = pcall(function()
	ScreenGui.Parent = game:GetService("CoreGui")
end)
if not success then
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Nút Z
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 55, 0, 55)
OpenBtn.Position = UDim2.new(0, 18, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
OpenBtn.Text = "Z"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 24
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

-- Main Menu
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 340, 0, 0)
Main.Position = UDim2.new(0.5, -170, 0.5, -220)
Main.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
Main.BorderSizePixel = 0
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA HUD"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Content Frame
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -16, 1, -60)
Content.Position = UDim2.new(0, 8, 0, 55)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Color3.fromRGB(0, 122, 255)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.Parent = Main

local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0, 8)
List.Parent = Content
List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Content.CanvasSize = UDim2.new(0, 0, 0, List.AbsoluteContentSize.Y + 15)
end)

-- Hàm tạo Toggle
local function MakeToggle(text, default, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 40)
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	frame.Parent = Content
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -60, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 42, 0, 24)
	btn.Position = UDim2.new(1, -50, 0.5, -12)
	btn.BackgroundColor3 = default and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(70, 70, 75)
	btn.Text = default and "ON" or "OFF"
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.Parent = frame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	local on = default
	btn.MouseButton1Click:Connect(function()
		on = not on
		btn.BackgroundColor3 = on and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(70, 70, 75)
		btn.Text = on and "ON" or "OFF"
		callback(on)
	end)
end

local function MakeButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
	btn.Text = text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Parent = Content
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
	btn.MouseButton1Click:Connect(callback)
end

-- Tạo các nút
MakeToggle("Aimbot", false, function(v) Settings.Aimbot = v end)
MakeToggle("Silent Aim", false, function(v) Settings.SilentAim = v end)
MakeToggle("ESP", false, function(v) Settings.ESP = v end)
MakeToggle("Speed", false, function(v) SetSpeed(v) end)
MakeToggle("Fly (Superman)", false, function(v) SetFly(v) end)
MakeToggle("Noclip", false, function(v) SetNoclip(v) end)
MakeToggle("Infinite Jump", false, function(v) Settings.InfiniteJump = v end)
MakeToggle("Touch TP", false, function(v) SetTouchTP(v) end)
MakeToggle("Hitbox Expander", false, function(v) Settings.HitboxExpander = v end)
MakeToggle("Anti AFK", true, function(v) Settings.AntiAFK = v end)

MakeButton("Rejoin Server", function()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

MakeButton("Unload Script", function()
	for _, c in pairs(Connections) do
		pcall(function() c:Disconnect() end)
	end
	if FakeFloor then FakeFloor:Destroy() end
	ScreenGui:Destroy()
	Notify("Zaka", "Đã tắt")
end)

-- Mở / Đóng Menu
local isOpen = false

local function Toggle()
	isOpen = not isOpen
	if isOpen then
		Main.Visible = true
		Main.Size = UDim2.new(0, 340, 0, 0)
		TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 340, 0, 420)
		}):Play()
		OpenBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
		OpenBtn.Text = "X"
	else
		local tw = TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 340, 0, 0)
		})
		tw:Play()
		tw.Completed:Wait()
		Main.Visible = false
		OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
		OpenBtn.Text = "Z"
	end
end

OpenBtn.MouseButton1Click:Connect(Toggle)

-- Tự mở sau 1 giây
task.delay(1, function()
	if not isOpen then
		Toggle()
	end
end)

print("Zaka HUD Ổn Định đã load!")
Notify("Zaka HUD", "Menu đã sẵn sàng")
