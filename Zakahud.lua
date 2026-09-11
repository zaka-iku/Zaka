--[[
    ZAKA HUD - Ultimate Edition
    - Menu animation đẹp
    - Đầy đủ chức năng
    - Fly Superman + Fake Floor (khó quét hơn)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

--================ SETTINGS ================--
local Settings = {
	Aimbot = false,
	AimbotFOV = 120,
	AimbotSmooth = 0.18,
	SilentAim = false,
	AutoClicker = false,
	TargetStrafe = false,
	StrafeDistance = 10,
	StrafeSpeed = 6,
	HitboxExpander = false,
	HitboxSize = 18,

	ESP = false,
	ESPBox = true,
	ESPName = true,
	ESPHealth = true,
	ESPDistance = true,
	ESPTracers = false,
	ESPMaxDist = 3000,
	Chams = false,

	Speed = false,
	SpeedValue = 28,
	Fly = false,
	FlySpeed = 70,
	Noclip = false,
	InfiniteJump = false,
	TouchTP = false,

	AntiAFK = true,
	ChatSpammer = false,
	SpamMessage = "Zaka HUD Ultimate"
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
			Duration = 2.2
		})
	end)
end

-- Anti AFK + Inf Jump
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

--================ SUPERMAN FLY + FAKE FLOOR ================--
local BodyGyro, BodyVelocity, FakeFloor, FlyTrail

local function SetFly(state)
	Settings.Fly = state
	if Connections.Fly then Connections.Fly:Disconnect() end
	if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
	if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
	if FlyTrail then FlyTrail:Destroy() FlyTrail = nil end
	if FakeFloor then FakeFloor:Destroy() FakeFloor = nil end

	if not state then
		Notify("Fly", "Đã tắt")
		return
	end

	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local root = char.HumanoidRootPart
	local hum = char:FindFirstChildOfClass("Humanoid")

	-- Fake Floor (đánh lừa grounded)
	FakeFloor = Instance.new("Part")
	FakeFloor.Name = "ZakaFloor"
	FakeFloor.Size = Vector3.new(16, 1.5, 16)
	FakeFloor.Transparency = 1
	FakeFloor.Anchored = true
	FakeFloor.CanCollide = true
	FakeFloor.CanQuery = true
	FakeFloor.Parent = workspace

	BodyGyro = Instance.new("BodyGyro")
	BodyGyro.P = 5e4
	BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	BodyGyro.Parent = root

	BodyVelocity = Instance.new("BodyVelocity")
	BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	BodyVelocity.Parent = root

	-- Trail đẹp
	local a0 = Instance.new("Attachment", root)
	a0.Position = Vector3.new(0, 0, 1.8)
	local a1 = Instance.new("Attachment", root)
	a1.Position = Vector3.new(0, 0, -1.8)

	FlyTrail = Instance.new("Trail")
	FlyTrail.Attachment0 = a0
	FlyTrail.Attachment1 = a1
	FlyTrail.Lifetime = 0.4
	FlyTrail.Color = ColorSequence.new(Color3.fromRGB(0, 170, 255), Color3.fromRGB(160, 80, 255))
	FlyTrail.Transparency = NumberSequence.new(0.15, 1)
	FlyTrail.WidthScale = NumberSequence.new(1.2, 0)
	FlyTrail.Parent = root

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

		-- Cập nhật Fake Floor
		if FakeFloor then
			FakeFloor.CFrame = CFrame.new(root.Position.X, root.Position.Y - 3.4, root.Position.Z)
		end
	end))

	Notify("Fly", "Superman + Fake Floor đã bật")
end

-- Speed / Noclip / TouchTP
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
				for _, p in ipairs(char:GetDescendants()) do
					if p:IsA("BasePart") then p.CanCollide = false end
				end
			end
		end))
		Notify("Noclip", "Đã bật")
	else
		Notify("Noclip", "Đã tắt")
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
		Notify("Touch TP", "Đã bật")
	else
		Notify("Touch TP", "Đã tắt")
	end
end

-- Aimbot + Silent Aim
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.6
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(0, 162, 255)
FOVCircle.Visible = false

local function GetClosestHead()
	local closest, shortest = nil, Settings.AimbotFOV
	local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
			local head = plr.Character:FindFirstChild("Head")
			if head then
				local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
				if onScreen then
					local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
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

local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
	if not checkcaller() and Settings.SilentAim and self == Mouse and key == "Hit" then
		local t = GetClosestHead()
		if t then return t.CFrame end
	end
	return oldIndex(self, key)
end)

-- ESP
local ESPObjects = {}
local ChamsObjects = {}

local function CreateESP(plr)
	if ESPObjects[plr] then return end
	local t = {
		Box = Drawing.new("Square"),
		Name = Drawing.new("Text"),
		Health = Drawing.new("Text"),
		Distance = Drawing.new("Text"),
		Tracer = Drawing.new("Line")
	}
	t.Box.Thickness = 1.4
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
	t.Tracer.Thickness = 1.2
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

-- Main Render
AddConn("Main", RunService.RenderStepped:Connect(function()
	local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

	FOVCircle.Position = center
	FOVCircle.Radius = Settings.AimbotFOV
	FOVCircle.Visible = Settings.Aimbot or Settings.SilentAim

	if Settings.Aimbot then
		local t = GetClosestHead()
		if t then
			Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, t.Position), Settings.AimbotSmooth)
		end
	end

	if Settings.HitboxExpander then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
				pcall(function()
					plr.Character.Head.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
					plr.Character.Head.Transparency = 0.55
					plr.Character.Head.CanCollide = false
				end)
			end
		end
	end

	-- ESP + Chams
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr == LocalPlayer then continue end

		if Settings.Chams then
			if not ChamsObjects[plr] and plr.Character then
				local hl = Instance.new("Highlight")
				hl.FillColor = Color3.fromRGB(0, 162, 255)
				hl.OutlineColor = Color3.new(1, 1, 1)
				hl.FillTransparency = 0.4
				hl.Parent = plr.Character
				ChamsObjects[plr] = hl
			end
		elseif ChamsObjects[plr] then
			ChamsObjects[plr]:Destroy()
			ChamsObjects[plr] = nil
		end

		if not Settings.ESP then
			if ESPObjects[plr] then
				for _, d in pairs(ESPObjects[plr]) do d.Visible = false end
			end
			continue
		end

		CreateESP(plr)
		local d = ESPObjects[plr]
		local char = plr.Character

		if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
			for _, v in pairs(d) do v.Visible = false end
			continue
		end

		local root = char.HumanoidRootPart
		local hum = char.Humanoid
		local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
		local dist = (root.Position - Camera.CFrame.Position).Magnitude

		if not onScreen or dist > Settings.ESPMaxDist then
			for _, v in pairs(d) do v.Visible = false end
			continue
		end

		local size = Vector2.new(math.clamp(1800 / pos.Z, 10, 260), math.clamp(2700 / pos.Z, 14, 400))
		local col = Color3.fromRGB(0, 162, 255)

		d.Box.Size = size
		d.Box.Position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
		d.Box.Color = col
		d.Box.Visible = Settings.ESPBox

		d.Name.Text = plr.Name
		d.Name.Position = Vector2.new(pos.X, pos.Y - size.Y / 2 - 15)
		d.Name.Color = col
		d.Name.Visible = Settings.ESPName

		d.Health.Text = math.floor(hum.Health) .. " HP"
		d.Health.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 3)
		d.Health.Color = Color3.fromRGB(255 * (1 - hum.Health / hum.MaxHealth), 255 * (hum.Health / hum.MaxHealth), 40)
		d.Health.Visible = Settings.ESPHealth

		d.Distance.Text = math.floor(dist) .. "m"
		d.Distance.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 17)
		d.Distance.Visible = Settings.ESPDistance

		if Settings.ESPTracers then
			d.Tracer.From = Vector2.new(center.X, Camera.ViewportSize.Y)
			d.Tracer.To = Vector2.new(pos.X, pos.Y)
			d.Tracer.Visible = true
		else
			d.Tracer.Visible = false
		end
	end
end))

--================ UI ================--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZakaUltimate"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local ok = pcall(function()
	ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ok then
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 52, 0, 52)
OpenBtn.Position = UDim2.new(0, 18, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
OpenBtn.Text = "Z"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 22
OpenBtn.AutoButtonColor = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 0, 0, 0)
Main.Position = UDim2.new(0.5, -180, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = false
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZAKA HUD  •  Ultimate"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -16, 0, 34)
TabBar.Position = UDim2.new(0, 8, 0, 58)
TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
TabBar.Parent = Main
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 10)

local Tabs = {"Combat", "ESP", "Player", "Teleport", "Troll", "Utility"}
local TabButtons, Pages = {}, {}
local CurrentTab = 1

local PageHolder = Instance.new("Frame")
PageHolder.Size = UDim2.new(1, -16, 1, -110)
PageHolder.Position = UDim2.new(0, 8, 0, 100)
PageHolder.BackgroundTransparency = 1
PageHolder.ClipsDescendants = true
PageHolder.Parent = Main

for i, name in ipairs(Tabs) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1 / #Tabs, -3, 1, -6)
	btn.Position = UDim2.new((i - 1) / #Tabs, 1.5, 0, 3)
	btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(45, 45, 50)
	btn.Text = name
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11
	btn.AutoButtonColor = false
	btn.Parent = TabBar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	TabButtons[i] = btn

	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.Position = UDim2.new(i - 1, 0, 0, 0)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = Color3.fromRGB(0, 122, 255)
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.Parent = PageHolder

	local list = Instance.new("UIListLayout")
	list.Padding = UDim.new(0, 8)
	list.Parent = page
	list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 12)
	end)
	Pages[i] = page

	btn.MouseButton1Click:Connect(function()
		if CurrentTab == i then return end
		CurrentTab = i
		for idx, b in ipairs(TabButtons) do
			TweenService:Create(b, TweenInfo.new(0.25), {
				BackgroundColor3 = (idx == i) and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(45, 45, 50)
			}):Play()
		end
		for idx, p in ipairs(Pages) do
			TweenService:Create(p, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
				Position = UDim2.new(idx - CurrentTab, 0, 0, 0)
			}):Play()
		end
	end)
end

-- Helper tạo Toggle
local function CreateToggle(parent, text, default, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 42)
	frame.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
	frame.Parent = parent
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -65, 1, 0)
	label.Position = UDim2.new(0, 14, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local track = Instance.new("Frame")
	track.Size = UDim2.new(0, 46, 0, 26)
	track.Position = UDim2.new(1, -56, 0.5, -13)
	track.BackgroundColor3 = default and Color3.fromRGB(52, 199, 89) or Color3.fromRGB(60, 60, 65)
	track.Parent = frame
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 22, 0, 22)
	knob.Position = default and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
	knob.BackgroundColor3 = Color3.new(1, 1, 1)
	knob.Parent = track
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local enabled = default
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.Parent = frame

	btn.MouseButton1Click:Connect(function()
		enabled = not enabled
		TweenService:Create(track, TweenInfo.new(0.22), {
			BackgroundColor3 = enabled and Color3.fromRGB(52, 199, 89) or Color3.fromRGB(60, 60, 65)
		}):Play()
		TweenService:Create(knob, TweenInfo.new(0.22), {
			Position = enabled and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
		}):Play()
		callback(enabled)
	end)
end

local function CreateButton(parent, text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 42)
	btn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
	btn.Text = text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.Parent = parent
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
	btn.MouseButton1Click:Connect(callback)
end

-- Tab Combat
CreateToggle(Pages[1], "Aimbot", false, function(v) Settings.Aimbot = v end)
CreateToggle(Pages[1], "Silent Aim", false, function(v) Settings.SilentAim = v end)
CreateToggle(Pages[1], "Auto Clicker", false, function(v)
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
CreateToggle(Pages[1], "Target Strafe", false, function(v)
	Settings.TargetStrafe = v
	if Connections.Strafe then Connections.Strafe:Disconnect() end
	if v then
		local angle = 0
		AddConn("Strafe", RunService.RenderStepped:Connect(function()
			local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if not myRoot then return end
			local target, minD = nil, 40
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					local d = (plr.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
					if d < minD then minD = d target = plr.Character.HumanoidRootPart end
				end
			end
			if target then
				angle = angle + math.rad(Settings.StrafeSpeed)
				myRoot.CFrame = CFrame.new(target.Position + Vector3.new(math.cos(angle) * Settings.StrafeDistance, 0, math.sin(angle) * Settings.StrafeDistance), target.Position)
			end
		end))
	end
end)
CreateToggle(Pages[1], "Hitbox Expander", false, function(v) Settings.HitboxExpander = v end)

-- Tab ESP
CreateToggle(Pages[2], "ESP Main", false, function(v) Settings.ESP = v end)
CreateToggle(Pages[2], "ESP Box", true, function(v) Settings.ESPBox = v end)
CreateToggle(Pages[2], "ESP Name", true, function(v) Settings.ESPName = v end)
CreateToggle(Pages[2], "ESP Health", true, function(v) Settings.ESPHealth = v end)
CreateToggle(Pages[2], "ESP Distance", true, function(v) Settings.ESPDistance = v end)
CreateToggle(Pages[2], "ESP Tracers", false, function(v) Settings.ESPTracers = v end)
CreateToggle(Pages[2], "Chams", false, function(v) Settings.Chams = v end)

-- Tab Player
CreateToggle(Pages[3], "Speed", false, function(v) SetSpeed(v) end)
CreateToggle(Pages[3], "Fly (Superman)", false, function(v) SetFly(v) end)
CreateToggle(Pages[3], "Noclip", false, function(v) SetNoclip(v) end)
CreateToggle(Pages[3], "Infinite Jump", false, function(v) Settings.InfiniteJump = v end)

-- Tab Teleport
CreateToggle(Pages[4], "Touch TP", false, function(v) SetTouchTP(v) end)
CreateButton(Pages[4], "Bring All (Client)", function()
	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if root then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				plr.Character.HumanoidRootPart.CFrame = root.CFrame + Vector3.new(2.5, 0, 0)
			end
		end
		Notify("Bring", "Done")
	end
end)

-- Tab Troll
CreateButton(Pages[5], "Fling All (Client)", function()
	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local orig = root.CFrame
	local bav = Instance.new("BodyAngularVelocity")
	bav.AngularVelocity = Vector3.new(0, 99999, 0)
	bav.MaxTorque = Vector3.new(0, math.huge, 0)
	bav.Parent = root
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			for _ = 1, 5 do
				root.CFrame = plr.Character.HumanoidRootPart.CFrame
				task.wait(0.03)
			end
		end
	end
	bav:Destroy()
	root.CFrame = orig
	Notify("Fling", "Done")
end)

-- Tab Utility
CreateToggle(Pages[6], "Anti AFK", true, function(v) Settings.AntiAFK = v end)
CreateButton(Pages[6], "Rejoin", function()
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
CreateButton(Pages[6], "Unload Script", function()
	for _, c in pairs(Connections) do pcall(function() c:Disconnect() end) end
	if FakeFloor then FakeFloor:Destroy() end
	for _, t in pairs(ESPObjects) do for _, d in pairs(t) do pcall(function() d:Remove() end) end end
	FOVCircle:Remove()
	ScreenGui:Destroy()
	Notify("Zaka", "Unloaded")
end)

-- Toggle Menu
local isOpen = false
local function ToggleMenu()
	isOpen = not isOpen
	if isOpen then
		Main.Visible = true
		Main.Size = UDim2.new(0, 0, 0, 0)
		TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 360, 0, 480)
		}):Play()
		TweenService:Create(OpenBtn, TweenInfo.new(0.25), {
			BackgroundColor3 = Color3.fromRGB(255, 60, 60),
			Text = "✕"
		}):Play()
	else
		local tw = TweenService:Create(Main, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0)
		})
		tw:Play()
		tw.Completed:Wait()
		Main.Visible = false
		TweenService:Create(OpenBtn, TweenInfo.new(0.25), {
			BackgroundColor3 = Color3.fromRGB(0, 122, 255),
			Text = "Z"
		}):Play()
	end
end

OpenBtn.MouseButton1Click:Connect(ToggleMenu)

task.delay(0.8, function()
	if not isOpen then ToggleMenu() end
end)

print("Zaka HUD Ultimate đã sẵn sàng!")
Notify("Zaka HUD", "Ultimate Edition Loaded")
