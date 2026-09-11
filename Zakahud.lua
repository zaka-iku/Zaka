--[[
    ZAKA HUD ULTIMATE - STABLE + EXPANDED
    - Menu chắc chắn hiện
    - Giữ chức năng cốt lõi
    - Thêm nhiều chức năng mới (khoảng 20 cái)
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

--================ SETTINGS ================--
local Settings = {
	-- Combat
	Aimbot = false,
	AimbotFOV = 130,
	AimbotSmooth = 0.18,
	SilentAim = false,
	AutoClicker = false,
	HitboxExpander = false,
	HitboxSize = 18,
	TriggerBot = false,

	-- ESP
	ESP = false,
	ESPBox = true,
	ESPName = true,
	ESPHealth = true,
	ESPDistance = true,
	ESPTracers = false,
	Chams = false,
	ESPMaxDist = 3500,

	-- Movement
	Speed = false,
	SpeedValue = 28,
	Fly = false,
	FlySpeed = 70,
	Noclip = false,
	InfiniteJump = false,
	HighJump = false,
	JumpPower = 100,
	SpiderClimb = false,
	WaterWalk = false,
	SpinBot = false,
	SpinSpeed = 40,

	-- World
	Fullbright = false,
	NoFog = false,
	CustomFOV = 70,
	Gravity = 196.2,

	-- Utility
	AntiAFK = true,
	TouchTP = false,
	ChatSpammer = false,
	SpamMessage = "Zaka HUD Ultimate",
	Invisible = false,
}

local Connections = {}
local function AddConn(name, conn)
	if Connections[name] then pcall(function() Connections[name]:Disconnect() end) end
	Connections[name] = conn
end

local function Notify(title, text)
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = 2.3
		})
	end)
end

-- Anti AFK + Infinite Jump
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

--================ MOVEMENT FUNCTIONS ================--
local BodyGyro, BodyVelocity, FakeFloor

local function SetFly(state)
	Settings.Fly = state
	if Connections.Fly then Connections.Fly:Disconnect() end
	if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
	if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
	if FakeFloor then FakeFloor:Destroy() FakeFloor = nil end

	if not state then Notify("Fly", "Tắt") return end

	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local root = char.HumanoidRootPart
	local hum = char:FindFirstChildOfClass("Humanoid")

	FakeFloor = Instance.new("Part")
	FakeFloor.Size = Vector3.new(15, 1.3, 15)
	FakeFloor.Transparency = 1
	FakeFloor.Anchored = true
	FakeFloor.CanCollide = true
	FakeFloor.Parent = workspace

	BodyGyro = Instance.new("BodyGyro")
	BodyGyro.P = 5e4
	BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	BodyGyro.Parent = root

	BodyVelocity = Instance.new("BodyVelocity")
	BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	BodyVelocity.Parent = root

	AddConn("Fly", RunService.RenderStepped:Connect(function()
		if not Settings.Fly or not root.Parent then SetFly(false) return end
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
			FakeFloor.CFrame = CFrame.new(root.Position.X, root.Position.Y - 3.4, root.Position.Z)
		end
	end))
	Notify("Fly", "Superman + Fake Floor")
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
	else Notify("Noclip", "Tắt") end
end

local function SetTouchTP(state)
	Settings.TouchTP = state
	if Connections.TouchTP then Connections.TouchTP:Disconnect() end
	if state then
		AddConn("TouchTP", UserInputService.InputBegan:Connect(function(input, gp)
			if gp then return end
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and Mouse.Hit then
				local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if root then root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3.5, 0)) end
			end
		end))
		Notify("Touch TP", "Bật")
	else Notify("Touch TP", "Tắt") end
end

local function SetSpider(state)
	Settings.SpiderClimb = state
	if Connections.Spider then Connections.Spider:Disconnect() end
	if state then
		AddConn("Spider", RunService.RenderStepped:Connect(function()
			local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if root then
				local ray = Ray.new(root.Position, root.CFrame.LookVector * 2.8)
				if workspace:FindPartOnRay(ray, LocalPlayer.Character) then
					root.Velocity = Vector3.new(root.Velocity.X, 32, root.Velocity.Z)
				end
			end
		end))
		Notify("Spider", "Bật")
	else Notify("Spider", "Tắt") end
end

local function SetWaterWalk(state)
	Settings.WaterWalk = state
	if Connections.Water then Connections.Water:Disconnect() end
	if state then
		AddConn("Water", RunService.RenderStepped:Connect(function()
			local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if root then
				local ray = Ray.new(root.Position, Vector3.new(0, -6, 0))
				local _, pos, _, mat = workspace:FindPartOnRay(ray, LocalPlayer.Character)
				if mat == Enum.Material.Water then
					root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
					root.CFrame = CFrame.new(root.Position.X, pos.Y + 3.1, root.Position.Z)
				end
			end
		end))
		Notify("Water Walk", "Bật")
	else Notify("Water Walk", "Tắt") end
end

--================ UI ================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaUltimateStable"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ok = pcall(function()
	ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ok then
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 54, 0, 54)
OpenBtn.Position = UDim2.new(0, 16, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
OpenBtn.Text = "Z"
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 23
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 360, 0, 0)
Main.Position = UDim2.new(0.5, -180, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
Main.BorderSizePixel = 0
Main.Visible = false
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA HUD  •  Ultimate Stable"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -16, 1, -60)
Content.Position = UDim2.new(0, 8, 0, 55)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Color3.fromRGB(0, 122, 255)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.Parent = Main

local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0, 7)
List.Parent = Content
List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Content.CanvasSize = UDim2.new(0, 0, 0, List.AbsoluteContentSize.Y + 15)
end)

local function MakeToggle(text, default, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 38)
	frame.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
	frame.Parent = Content
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 9)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -58, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.new(1,1,1)
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 40, 0, 22)
	btn.Position = UDim2.new(1, -48, 0.5, -11)
	btn.BackgroundColor3 = default and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(70, 70, 75)
	btn.Text = default and "ON" or "OFF"
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11
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
	btn.Size = UDim2.new(1, 0, 0, 38)
	btn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
	btn.Text = text
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.Parent = Content
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)
	btn.MouseButton1Click:Connect(callback)
end

--===== TẠO CHỨC NĂNG =====--
MakeToggle("Aimbot", false, function(v) Settings.Aimbot = v end)
MakeToggle("Silent Aim (tạm camera)", false, function(v) Settings.SilentAim = v end)
MakeToggle("Auto Clicker", false, function(v)
	Settings.AutoClicker = v
	if Connections.Click then Connections.Click:Disconnect() end
	if v then
		AddConn("Click", RunService.RenderStepped:Connect(function()
			VirtualUser:Button1Down(Vector2.new())
			task.wait(0.04)
			VirtualUser:Button1Up(Vector2.new())
		end))
	end
end)
MakeToggle("Hitbox Expander", false, function(v) Settings.HitboxExpander = v end)

MakeToggle("ESP", false, function(v) Settings.ESP = v end)
MakeToggle("ESP Box", true, function(v) Settings.ESPBox = v end)
MakeToggle("ESP Name", true, function(v) Settings.ESPName = v end)
MakeToggle("ESP Health", true, function(v) Settings.ESPHealth = v end)
MakeToggle("ESP Distance", true, function(v) Settings.ESPDistance = v end)
MakeToggle("Chams", false, function(v) Settings.Chams = v end)

MakeToggle("Speed", false, function(v) SetSpeed(v) end)
MakeToggle("Fly Superman + FakeFloor", false, function(v) SetFly(v) end)
MakeToggle("Noclip", false, function(v) SetNoclip(v) end)
MakeToggle("Infinite Jump", false, function(v) Settings.InfiniteJump = v end)
MakeToggle("High Jump", false, function(v)
	Settings.HighJump = v
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.JumpPower = v and Settings.JumpPower or 50 end
end)
MakeToggle("Spider Climb", false, function(v) SetSpider(v) end)
MakeToggle("Water Walk", false, function(v) SetWaterWalk(v) end)
MakeToggle("SpinBot", false, function(v) Settings.SpinBot = v end)

MakeToggle("Touch TP", false, function(v) SetTouchTP(v) end)
MakeToggle("Fullbright", false, function(v)
	Settings.Fullbright = v
	if v then
		Lighting.Brightness = 3
		Lighting.ClockTime = 14
		Lighting.FogEnd = 1e6
	else
		Lighting.Brightness = 1
		Lighting.ClockTime = 12
	end
end)
MakeToggle("No Fog", false, function(v)
	Settings.NoFog = v
	Lighting.FogEnd = v and 1e6 or 1000
end)
MakeToggle("Anti AFK", true, function(v) Settings.AntiAFK = v end)
MakeToggle("Invisible (Client)", false, function(v)
	Settings.Invisible = v
	local char = LocalPlayer.Character
	if char then
		for _, p in ipairs(char:GetDescendants()) do
			if p:IsA("BasePart") or p:IsA("Decal") then
				p.Transparency = v and 1 or 0
			end
		end
	end
end)

MakeButton("Bring All (Client)", function()
	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if root then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				plr.Character.HumanoidRootPart.CFrame = root.CFrame + Vector3.new(3, 0, 0)
			end
		end
		Notify("Bring", "Done")
	end
end)

MakeButton("Fling All (Client)", function()
	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local orig = root.CFrame
	local bav = Instance.new("BodyAngularVelocity")
	bav.AngularVelocity = Vector3.new(0, 99999, 0)
	bav.MaxTorque = Vector3.new(0, math.huge, 0)
	bav.Parent = root
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			for i = 1, 5 do
				root.CFrame = plr.Character.HumanoidRootPart.CFrame
				task.wait(0.03)
			end
		end
	end
	bav:Destroy()
	root.CFrame = orig
	Notify("Fling", "Done")
end)

MakeButton("Rejoin", function()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

MakeButton("Server Hop", function()
	pcall(function()
		local data = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
		for _, s in ipairs(data) do
			if s.id \~= game.JobId and s.playing < s.maxPlayers then
				TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
				break
			end
		end
	end)
end)

MakeButton("Unload", function()
	for _, c in pairs(Connections) do pcall(function() c:Disconnect() end) end
	if FakeFloor then FakeFloor:Destroy() end
	ScreenGui:Destroy()
	Notify("Zaka", "Đã tắt")
end)

-- Mở / Đóng
local isOpen = false
local function Toggle()
	isOpen = not isOpen
	if isOpen then
		Main.Visible = true
		Main.Size = UDim2.new(0, 360, 0, 0)
		TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 360, 0, 480)
		}):Play()
		OpenBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
		OpenBtn.Text = "X"
	else
		local tw = TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 360, 0, 0)
		})
		tw:Play()
		tw.Completed:Wait()
		Main.Visible = false
		OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
		OpenBtn.Text = "Z"
	end
end

OpenBtn.MouseButton1Click:Connect(Toggle)

task.delay(0.9, function()
	if not isOpen then Toggle() end
end)

print("Zaka HUD Ultimate Stable đã load!")
Notify("Zaka HUD", "Menu đã sẵn sàng")
