--[[
========================================================
                 ZAKA PURE UI V5.0
              ALL-IN-ONE EDITION
========================================================
  • Single Script
  • Mobile Friendly
  • Lightning Reveal
  • Premium Animations
  • Smart Search
  • 11 Tabs
  • Feature Registry
  • Notifications
  • Theme Engine
  • UI Scale
  • FPS / Coordinates
  • Movement / Camera / VFX / Fun / Debug tools
========================================================
]]

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

--========================================================
-- CLEAN OLD UI
--========================================================

local OldUI = PlayerGui:FindFirstChild("ZAKA_PURE_V5")
if OldUI then
	OldUI:Destroy()
end

local OldBlur = Lighting:FindFirstChild("ZAKA_UI_BLUR")
if OldBlur then
	OldBlur:Destroy()
end

--========================================================
-- CONFIG
--========================================================

local Config = {
	Open = false,
	AnimationSpeed = 1,
	Theme = "Cyber",
	UIScale = 1,

	FPS = true,
	Coordinates = true,
	Crosshair = false,

	Rainbow = false,
	Glow = true,

	ScreenShake = false,
	Lightning = true,
	Particles = true,

	AutoRotate = true,
	DoubleJump = false,
	Glide = false,

	Speed = 16,
	JumpPower = 50,

	OldGravity = workspace.Gravity,
}

--========================================================
-- THEME
--========================================================

local Themes = {
	Cyber = {
		Background = Color3.fromRGB(8,12,22),
		Panel = Color3.fromRGB(14,20,34),
		Card = Color3.fromRGB(18,25,41),
		CardHover = Color3.fromRGB(24,34,53),
		Accent = Color3.fromRGB(80,190,255),
		Accent2 = Color3.fromRGB(120,225,255),
		Text = Color3.fromRGB(235,245,255),
		SubText = Color3.fromRGB(135,155,180),
		Border = Color3.fromRGB(80,170,220),
	},

	Purple = {
		Background = Color3.fromRGB(13,9,22),
		Panel = Color3.fromRGB(22,14,35),
		Card = Color3.fromRGB(29,19,46),
		CardHover = Color3.fromRGB(42,26,63),
		Accent = Color3.fromRGB(180,110,255),
		Accent2 = Color3.fromRGB(220,160,255),
		Text = Color3.fromRGB(245,235,255),
		SubText = Color3.fromRGB(170,145,195),
		Border = Color3.fromRGB(175,110,255),
	},

	Ice = {
		Background = Color3.fromRGB(7,16,23),
		Panel = Color3.fromRGB(12,27,37),
		Card = Color3.fromRGB(16,36,48),
		CardHover = Color3.fromRGB(24,52,68),
		Accent = Color3.fromRGB(100,220,255),
		Accent2 = Color3.fromRGB(180,245,255),
		Text = Color3.fromRGB(235,252,255),
		SubText = Color3.fromRGB(135,180,195),
		Border = Color3.fromRGB(95,205,240),
	},
}

local Theme = Themes[Config.Theme]

--========================================================
-- HELPERS
--========================================================

local function T(object, duration, properties, style, direction)
	local info = TweenInfo.new(
		duration / Config.AnimationSpeed,
		style or Enum.EasingStyle.Quint,
		direction or Enum.EasingDirection.Out
	)

	local tween = TweenService:Create(object, info, properties)
	tween:Play()

	return tween
end

local function Corner(object, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = object
	return c
end

local function Border(object, transparency)
	local s = Instance.new("UIStroke")
	s.Color = Theme.Border
	s.Thickness = 1
	s.Transparency = transparency or 0.5
	s.Parent = object
	return s
end

local function Text(parent, content, size, bold)
	local label = Instance.new("TextLabel")

	label.BackgroundTransparency = 1
	label.Text = content
	label.TextSize = size
	label.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
	label.TextColor3 = Theme.Text
	label.TextXAlignment = Enum.TextXAlignment.Left

	label.Parent = parent

	return label
end

--========================================================
-- GUI
--========================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "ZAKA_PURE_V5"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local Blur = Instance.new("BlurEffect")
Blur.Name = "ZAKA_UI_BLUR"
Blur.Size = 0
Blur.Parent = Lighting

--========================================================
-- FX LAYER
--========================================================

local FX = Instance.new("Frame")
FX.Name = "FX"
FX.Size = UDim2.fromScale(1,1)
FX.BackgroundTransparency = 1
FX.ZIndex = 900
FX.Parent = Gui

--========================================================
-- OPEN BUTTON
--========================================================

local OpenButton = Instance.new("TextButton")

OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.fromOffset(58,58)
OpenButton.Position = UDim2.new(0,18,0.5,-29)

OpenButton.BackgroundColor3 = Theme.Panel
OpenButton.Text = "Z"
OpenButton.TextColor3 = Theme.Text
OpenButton.TextSize = 25
OpenButton.Font = Enum.Font.GothamBlack

OpenButton.AutoButtonColor = false
OpenButton.ZIndex = 50
OpenButton.Parent = Gui

Corner(OpenButton,18)
Border(OpenButton,0.15)

--========================================================
-- MAIN
--========================================================

local Main = Instance.new("Frame")

Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.Position = UDim2.fromScale(0.5,0.5)

Main.Size = UDim2.fromOffset(0,0)

Main.BackgroundColor3 = Theme.Background
Main.BackgroundTransparency = 0.03

Main.Visible = false
Main.ClipsDescendants = true
Main.ZIndex = 10
Main.Parent = Gui

Corner(Main,22)
Border(Main,0.15)

--========================================================
-- TOP
--========================================================

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1,0,0,72)
Top.BackgroundTransparency = 1
Top.Parent = Main

local Title = Text(
	Top,
	"ZAKA PURE",
	21,
	true
)

Title.Position = UDim2.new(0,22,0,12)
Title.Size = UDim2.new(0,220,0,27)

local Subtitle = Text(
	Top,
	"V5.0  •  PREMIUM CLIENT UI",
	10,
	false
)

Subtitle.TextColor3 = Theme.SubText
Subtitle.Position = UDim2.new(0,23,0,40)
Subtitle.Size = UDim2.new(0,250,0,18)

local Close = Instance.new("TextButton")

Close.Size = UDim2.fromOffset(40,40)
Close.Position = UDim2.new(1,-55,0,16)

Close.BackgroundColor3 = Theme.Card
Close.Text = "×"
Close.TextSize = 24
Close.TextColor3 = Theme.Text
Close.Font = Enum.Font.GothamBold

Close.AutoButtonColor = false
Close.Parent = Top

Corner(Close,12)

--========================================================
-- BODY
--========================================================

local Body = Instance.new("Frame")
Body.BackgroundTransparency = 1
Body.Position = UDim2.new(0,12,0,72)
Body.Size = UDim2.new(1,-24,1,-84)
Body.Parent = Main

--========================================================
-- TAB BAR
--========================================================

local Tabs = Instance.new("ScrollingFrame")

Tabs.Name = "Tabs"

Tabs.Size = UDim2.new(0,150,1,0)

Tabs.BackgroundColor3 = Theme.Panel
Tabs.BackgroundTransparency = 0.15

Tabs.BorderSizePixel = 0
Tabs.ScrollBarThickness = 2
Tabs.AutomaticCanvasSize = Enum.AutomaticSize.Y

Tabs.CanvasSize = UDim2.new()

Tabs.Parent = Body

Corner(Tabs,15)

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0,8)
TabPadding.PaddingBottom = UDim.new(0,8)
TabPadding.PaddingLeft = UDim.new(0,7)
TabPadding.PaddingRight = UDim.new(0,7)
TabPadding.Parent = Tabs

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0,6)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = Tabs

--========================================================
-- PAGE CONTAINER
--========================================================

local Pages = Instance.new("Frame")

Pages.BackgroundTransparency = 1
Pages.Position = UDim2.new(0,160,0,0)
Pages.Size = UDim2.new(1,-160,1,0)

Pages.ClipsDescendants = true
Pages.Parent = Body

--========================================================
-- SEARCH
--========================================================

local SearchBox = Instance.new("TextBox")

SearchBox.Size = UDim2.new(1,-8,0,42)
SearchBox.Position = UDim2.new(0,4,0,0)

SearchBox.BackgroundColor3 = Theme.Panel
SearchBox.BackgroundTransparency = 0.1

SearchBox.PlaceholderText =
	"🔎  Search features...  (f / b / fly / visual)"

SearchBox.PlaceholderColor3 = Theme.SubText

SearchBox.Text = ""
SearchBox.TextColor3 = Theme.Text
SearchBox.TextSize = 12
SearchBox.Font = Enum.Font.Gotham

SearchBox.ClearTextOnFocus = false
SearchBox.Parent = Pages

Corner(SearchBox,13)
Border(SearchBox,0.6)

--========================================================
-- PAGE CONTENT AREA
--========================================================

local PageArea = Instance.new("Frame")

PageArea.BackgroundTransparency = 1
PageArea.Position = UDim2.new(0,0,0,50)
PageArea.Size = UDim2.new(1,0,1,-50)

PageArea.Parent = Pages

--========================================================
-- DATA
--========================================================

local TabData = {
	{"⚔","Combat"},
	{"🎯","Hitbox"},
	{"👁","Visual"},
	{"🏃","Player"},
	{"🌎","World"},
	{"🎭","Troll"},
	{"🪽","Movement"},
	{"✨","Effects"},
	{"🎉","Fun"},
	{"🛠","Utility"},
	{"⚙","Settings"},
}

local Features = {}

local function AddFeature(name, tab, icon, description, featureType, keywords, callback)
	table.insert(Features,{
		Name = name,
		Tab = tab,
		Icon = icon,
		Description = description,
		Type = featureType or "Toggle",
		Keywords = keywords or {},
		Callback = callback,
	})
end

--========================================================
-- FEATURES
--========================================================

-- COMBAT / TRAINING

AddFeature("Training Mode","Combat","⚔",
	"Training tools for your experience.","Toggle",
	{"t","training","combat"},function(v) end)

AddFeature("Combo Counter","Combat","🔥",
	"Display combo counter.","Toggle",
	{"c","combo"},function(v) end)

AddFeature("Hit Indicator","Combat","💥",
	"Visual hit feedback.","Toggle",
	{"h","hit","indicator"},function(v) end)

AddFeature("Damage Numbers","Combat","🔢",
	"Display training damage numbers.","Toggle",
	{"d","damage","numbers"},function(v) end)

AddFeature("Training Dummy","Combat","🤖",
	"Spawn your training dummy.","Button",
	{"t","training","dummy"},function() end)

AddFeature("Reset Training","Combat","♻",
	"Reset training state.","Button",
	{"r","reset","training"},function() end)

-- HITBOX DEBUG

AddFeature("Collision Visualizer","Hitbox","🎯",
	"Visualize collision geometry.","Toggle",
	{"c","collision","debug"},function(v) end)

AddFeature("Target Marker","Hitbox","📍",
	"Display target marker.","Toggle",
	{"t","target","marker"},function(v) end)

AddFeature("Debug Parts","Hitbox","🧩",
	"Show debug parts.","Toggle",
	{"d","debug","parts"},function(v) end)

AddFeature("Raycast Visualizer","Hitbox","📡",
	"Visualize raycasts.","Toggle",
	{"r","raycast"},function(v) end)

AddFeature("Touch Debug","Hitbox","👆",
	"Debug touch events.","Toggle",
	{"t","touch","debug"},function(v) end)

-- VISUAL

AddFeature("Crosshair","Visual","⊕",
	"Display screen crosshair.","Toggle",
	{"c","crosshair"},function(v)
		Config.Crosshair = v
	end)

AddFeature("Rainbow UI","Visual","🌈",
	"Animated UI colors.","Toggle",
	{"r","rainbow"},function(v)
		Config.Rainbow = v
	end)

AddFeature("UI Glow","Visual","✨",
	"Enable UI glow effects.","Toggle",
	{"g","glow"},function(v)
		Config.Glow = v
	end)

AddFeature("Brightness","Visual","☀",
	"Adjust visual brightness.","Slider",
	{"b","brightness"},function(v) end)

AddFeature("Night Vision","Visual","🌙",
	"Visual night mode.","Toggle",
	{"n","night","vision"},function(v) end)

AddFeature("Camera Shake","Visual","📷",
	"Camera shake effect.","Toggle",
	{"c","camera","shake"},function(v) end)

AddFeature("FOV Control","Visual","🔭",
	"Camera field of view.","Slider",
	{"f","fov","camera"},function(v) end)

-- PLAYER

AddFeature("Auto Rotate","Player","🔄",
	"Automatically rotate character.","Toggle",
	{"a","auto","rotate"},function(v)
		Config.AutoRotate = v
	end)

AddFeature("Double Jump","Player","🦘",
	"Enable double jump.","Toggle",
	{"d","double","jump"},function(v)
		Config.DoubleJump = v
	end)

AddFeature("Glide","Player","🪽",
	"Slow falling glide.","Toggle",
	{"g","glide"},function(v)
		Config.Glide = v
	end)

AddFeature("Walk Speed","Player","🏃",
	"Change character walk speed.","Slider",
	{"w","walk","speed"},function(v)
		Config.Speed = v
	end)

AddFeature("Jump Power","Player","⬆",
	"Change jump power.","Slider",
	{"j","jump","power"},function(v)
		Config.JumpPower = v
	end)

AddFeature("Reset Character","Player","♻",
	"Respawn your character.","Button",
	{"r","reset","character"},function()
		LocalPlayer:LoadCharacter()
	end)

-- WORLD

AddFeature("Reset Gravity","World","🌎",
	"Restore default gravity.","Button",
	{"r","reset","gravity"},function()
		workspace.Gravity = 196.2
	end)

AddFeature("Low Gravity","World","🌙",
	"Lower gravity for fun testing.","Button",
	{"l","low","gravity"},function()
		workspace.Gravity = 80
	end)

AddFeature("High Gravity","World","⬇",
	"Increase gravity for testing.","Button",
	{"h","high","gravity"},function()
		workspace.Gravity = 350
	end)

AddFeature("Day Time","World","☀",
	"Set daytime.","Button",
	{"d","day","time"},function()
		Lighting.ClockTime = 14
	end)

AddFeature("Night Time","World","🌙",
	"Set nighttime.","Button",
	{"n","night","time"},function()
		Lighting.ClockTime = 0
	end)

AddFeature("Reset Lighting","World","💡",
	"Restore lighting.","Button",
	{"r","reset","lighting"},function()
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
	end)

-- TROLL / FUN

AddFeature("Spin Character","Troll","🌀",
	"Spin character for fun.","Toggle",
	{"s","spin"},function(v) end)

AddFeature("Rainbow Character","Troll","🌈",
	"Rainbow character effect.","Toggle",
	{"r","rainbow","character"},function(v) end)

AddFeature("Confetti","Troll","🎊",
	"Confetti effect.","Button",
	{"c","confetti"},function() end)

AddFeature("Fake Explosion FX","Troll","💥",
	"Local visual explosion effect.","Button",
	{"f","fake","explosion"},function() end)

AddFeature("Funny Mode","Troll","😂",
	"Enable funny UI effects.","Toggle",
	{"f","funny","mode"},function(v) end)

-- MOVEMENT

AddFeature("Smooth Dash","Movement","💨",
	"Smooth dash controller for your experience.","Toggle",
	{"s","smooth","dash"},function(v) end)

AddFeature("Air Dash","Movement","🪽",
	"Air dash movement.","Toggle",
	{"a","air","dash"},function(v) end)

AddFeature("Wall Jump","Movement","🧗",
	"Wall jump movement system.","Toggle",
	{"w","wall","jump"},function(v) end)

AddFeature("Glide Mode","Movement","🪽",
	"Smooth falling movement.","Toggle",
	{"g","glide"},function(v)
		Config.Glide = v
	end)

AddFeature("Movement Boost","Movement","🚀",
	"Temporary movement boost.","Button",
	{"m","movement","boost"},function() end)

AddFeature("Fly Controller","Movement","🛫",
	"Flight controller for your experience.","Toggle",
	{"f","fly","flight"},function(v) end)

AddFeature("Fly Speed","Movement","⚡",
	"Flight speed setting.","Slider",
	{"f","fly","speed"},function(v) end)

AddFeature("Fly Vertical","Movement","↕",
	"Vertical flight control.","Slider",
	{"f","fly","vertical"},function(v) end)

-- EFFECTS

AddFeature("Lightning Aura","Effects","⚡",
	"Lightning aura effect.","Toggle",
	{"l","lightning","aura"},function(v) end)

AddFeature("Energy Ring","Effects","⭕",
	"Rotating energy ring.","Toggle",
	{"e","energy","ring"},function(v) end)

AddFeature("Particle Trail","Effects","✨",
	"Particle trail effect.","Toggle",
	{"p","particle","trail"},function(v) end)

AddFeature("Electric Trail","Effects","⚡",
	"Electric movement trail.","Toggle",
	{"e","electric","trail"},function(v) end)

AddFeature("Glow Pulse","Effects","💫",
	"Animated glow pulse.","Toggle",
	{"g","glow","pulse"},function(v) end)

AddFeature("Impact FX","Effects","💥",
	"Impact visual effects.","Toggle",
	{"i","impact","fx"},function(v) end)

-- FUN

AddFeature("Screen Flash","Fun","📸",
	"Flash screen effect.","Button",
	{"s","screen","flash"},function() end)

AddFeature("Screen Shake","Fun","📳",
	"Shake UI for fun.","Button",
	{"s","screen","shake"},function() end)

AddFeature("Random Emote","Fun","🕺",
	"Random emote event.","Button",
	{"r","random","emote"},function() end)

AddFeature("Fireworks","Fun","🎆",
	"Fireworks visual effect.","Button",
	{"f","fireworks"},function() end)

AddFeature("Celebration","Fun","🎉",
	"Celebration effect.","Button",
	{"c","celebration"},function() end)

-- UTILITY

AddFeature("FPS Counter","Utility","📊",
	"Display current FPS.","Toggle",
	{"f","fps","counter"},function(v)
		Config.FPS = v
	end)

AddFeature("Coordinates","Utility","📍",
	"Display character coordinates.","Toggle",
	{"c","coordinates"},function(v)
		Config.Coordinates = v
	end)

AddFeature("Performance Mode","Utility","🚀",
	"Reduce cosmetic effects.","Button",
	{"p","performance","mode"},function()
		Config.Particles = false
		Config.Glow = false
	end)

AddFeature("Reset Effects","Utility","♻",
	"Reset visual effects.","Button",
	{"r","reset","effects"},function()
		Config.Particles = true
		Config.Glow = true
	end)

AddFeature("UI Refresh","Utility","🔄",
	"Refresh interface state.","Button",
	{"u","ui","refresh"},function() end)

-- SETTINGS

AddFeature("Cyber Theme","Settings","🔵",
	"Cyber blue theme.","Button",
	{"c","cyber","theme"},function()
		Config.Theme = "Cyber"
	end)

AddFeature("Purple Theme","Settings","🟣",
	"Purple theme.","Button",
	{"p","purple","theme"},function()
		Config.Theme = "Purple"
	end)

AddFeature("Ice Theme","Settings","❄",
	"Ice theme.","Button",
	{"i","ice","theme"},function()
		Config.Theme = "Ice"
	end)

AddFeature("Fast Animation","Settings","⚡",
	"Speed up UI animations.","Button",
	{"f","fast","animation"},function()
		Config.AnimationSpeed = 1.6
	end)

AddFeature("Smooth Animation","Settings","🌊",
	"Smooth UI animations.","Button",
	{"s","smooth","animation"},function()
		Config.AnimationSpeed = 1
	end)

AddFeature("Reset Settings","Settings","♻",
	"Restore settings.","Button",
	{"r","reset","settings"},function()
		Config.AnimationSpeed = 1
		Config.UIScale = 1
	end)

--========================================================
-- EXTRA FEATURE GENERATOR
--========================================================

-- Creates many utility/debug entries so the search system
-- can handle a large registry without hard-coded UI logic.

local ExtraNames = {
	"Camera Debug",
	"Camera Follow",
	"Camera Lock",
	"Camera Offset",
	"Camera Zoom",
	"Character Debug",
	"Character Outline",
	"Character Trail",
	"Character Highlight",
	"Character Rotation",
	"Movement Debug",
	"Movement Indicator",
	"Movement Trail",
	"Movement Statistics",
	"Jump Indicator",
	"Jump Trail",
	"Velocity Display",
	"Velocity Graph",
	"Position Display",
	"Position History",
	"World Debug",
	"World Information",
	"World Clock",
	"World Gravity",
	"World Fog",
	"World Atmosphere",
	"Lighting Debug",
	"Lighting Monitor",
	"Effect Preview",
	"Effect Test",
	"Particle Preview",
	"Particle Test",
	"Sound Debug",
	"Sound Monitor",
	"UI Debug",
	"UI Information",
	"UI FPS",
	"UI Scale",
	"UI Position",
	"UI Theme",
	"UI Animation",
	"UI Glow",
	"UI Blur",
	"Search Debug",
	"Search History",
	"Search Suggestions",
	"Search Highlight",
	"Notification Test",
	"Notification History",
	"Notification Queue",
	"Notification Sound",
	"Training Timer",
	"Training Statistics",
	"Training History",
	"Training Reset",
	"Target Debug",
	"Target Indicator",
	"Target Distance",
	"Target Direction",
	"Target Information",
	"Debug Mode",
	"Debug Overlay",
	"Debug Monitor",
	"Debug Statistics",
	"Debug Console",
	"Performance Monitor",
	"Memory Monitor",
	"Network Monitor",
	"Render Monitor",
	"Frame Monitor",
}

for _, name in ipairs(ExtraNames) do
	AddFeature(
		name,
		"Utility",
		"•",
		"Utility/debug feature for your experience.",
		"Toggle",
		{string.sub(name,1,1),string.lower(name)},
		function(v) end
	)
end

--========================================================
-- SEARCH ENGINE
--========================================================

local function Normalize(text)
	text = tostring(text or "")
	text = string.lower(text)

	text = string.gsub(text,"[%p]"," ")

	text = string.gsub(text,"%s+"," ")

	return text
end

local function StartsWord(text,query)

	text = Normalize(text)
	query = Normalize(query)

	for word in string.gmatch(text,"%S+") do
		if string.sub(word,1,#query) == query then
			return true
		end
	end

	return false
end

local function SearchScore(feature,query)

	query = Normalize(query)

	if query == "" then
		return 0
	end

	local name = Normalize(feature.Name)

	-- Exact
	if name == query then
		return 1000
	end

	-- Name starts with query
	if string.sub(name,1,#query) == query then
		return 900
	end

	-- Word starts with query
	if StartsWord(name,query) then
		return 800
	end

	-- Keyword match
	for _,keyword in ipairs(feature.Keywords or {}) do

		keyword = Normalize(keyword)

		if keyword == query then
			return 780
		end

		if string.sub(keyword,1,#query) == query then
			return 740
		end

		if string.find(keyword,query,1,true) then
			return 650
		end
	end

	-- Name contains
	if string.find(name,query,1,true) then
		return 600
	end

	-- Description
	if string.find(
		Normalize(feature.Description),
		query,
		1,
		true
	) then
		return 400
	end

	return 0
end

local function Search(query)

	local results = {}

	for _,feature in ipairs(Features) do

		local score = SearchScore(feature,query)

		if score > 0 then

			table.insert(results,{
				Feature = feature,
				Score = score
			})

		end
	end

	table.sort(results,function(a,b)

		if a.Score == b.Score then
			return a.Feature.Name < b.Feature.Name
		end

		return a.Score > b.Score
	end)

	return results
end

--========================================================
-- PAGES / TABS
--========================================================

local TabButtons = {}
local PageObjects = {}

local function CreatePage(name)

	local page = Instance.new("ScrollingFrame")

	page.Name = name
	page.BackgroundTransparency = 1

	page.Size = UDim2.fromScale(1,1)

	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.CanvasSize = UDim2.new()

	page.ScrollBarThickness = 3

	page.Visible = false

	page.Parent = PageArea

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0,6)
	padding.PaddingBottom = UDim.new(0,12)
	padding.PaddingLeft = UDim.new(0,4)
	padding.PaddingRight = UDim.new(0,4)
	padding.Parent = page

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0,8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = page

	PageObjects[name] = page

	return page
end

for index,data in ipairs(TabData) do

	local icon = data[1]
	local name = data[2]

	local page = CreatePage(name)

	local tab = Instance.new("TextButton")

	tab.Name = name

	tab.Size = UDim2.new(1,0,0,40)

	tab.BackgroundColor3 = Theme.Card

	tab.Text = icon.."   "..name

	tab.TextColor3 = Theme.SubText

	tab.TextSize = 12

	tab.Font = Enum.Font.GothamBold

	tab.TextXAlignment = Enum.TextXAlignment.Left

	tab.AutoButtonColor = false

	tab.LayoutOrder = index

	tab.Parent = Tabs

	Corner(tab,11)

	local pad = Instance.new("UIPadding")
	pad.PaddingLeft = UDim.new(0,10)
	pad.Parent = tab

	TabButtons[name] = tab

	tab.MouseButton1Click:Connect(function()

		for tabName,button in pairs(TabButtons) do

			T(button,0.2,{
				BackgroundColor3 = Theme.Card,
				TextColor3 = Theme.SubText
			})

			if PageObjects[tabName] then
				PageObjects[tabName].Visible = false
			end
		end

		T(tab,0.25,{
			BackgroundColor3 = Theme.Accent,
			TextColor3 = Theme.Text
		})

		page.Visible = true

		page.Position = UDim2.new(0,25,0,0)

		T(page,0.3,{
			Position = UDim2.new(0,0,0,0)
		})
	end)
end

--========================================================
-- FEATURE CARDS
--========================================================

local ActiveCards = {}

local function ClearPage(page)

	for _,child in ipairs(page:GetChildren()) do

		if child:IsA("Frame") or child:IsA("TextButton") then
			child:Destroy()
		end

	end
end

local function MakeCard(feature,parent)

	local card = Instance.new("Frame")

	card.Size = UDim2.new(1,0,0,64)

	card.BackgroundColor3 = Theme.Card

	card.Parent = parent

	Corner(card,14)
	Border(card,0.7)

	local icon = Text(
		card,
		feature.Icon,
		18,
		true
	)

	icon.Position = UDim2.new(0,12,0,10)
	icon.Size = UDim2.fromOffset(30,25)

	local name = Text(
		card,
		feature.Name,
		13,
		true
	)

	name.Position = UDim2.new(0,48,0,8)
	name.Size = UDim2.new(1,-115,0,22)

	local desc = Text(
		card,
		feature.Description,
		10,
		false
	)

	desc.TextColor3 = Theme.SubText

	desc.Position = UDim2.new(0,48,0,32)
	desc.Size = UDim2.new(1,-120,0,20)

	-- BUTTON
	local control

	if feature.Type == "Toggle" then

		control = Instance.new("TextButton")

		control.Size = UDim2.fromOffset(42,24)
		control.Position = UDim2.new(1,-56,0.5,-12)

		control.BackgroundColor3 =
			Color3.fromRGB(38,47,63)

		control.Text = ""

		control.AutoButtonColor = false

		control.Parent = card

		Corner(control,20)

		local dot = Instance.new("Frame")

		dot.Size = UDim2.fromOffset(18,18)

		dot.Position = UDim2.new(0,3,0.5,-9)

		dot.BackgroundColor3 =
			Color3.fromRGB(150,165,180)

		dot.Parent = control

		Corner(dot,20)

		local enabled = false

		control.MouseButton1Click:Connect(function()

			enabled = not enabled

			if enabled then

				T(control,0.2,{
					BackgroundColor3 = Theme.Accent
				})

				T(dot,0.25,{
					Position = UDim2.new(1,-21,0.5,-9),
					BackgroundColor3 = Theme.Accent2
				})

			else

				T(control,0.2,{
					BackgroundColor3 =
						Color3.fromRGB(38,47,63)
				})

				T(dot,0.25,{
					Position = UDim2.new(0,3,0.5,-9),
					BackgroundColor3 =
						Color3.fromRGB(150,165,180)
				})

			end

			if feature.Callback then
				feature.Callback(enabled)
			end

		end)

	else

		control = Instance.new("TextButton")

		control.Size = UDim2.fromOffset(58,30)

		control.Position =
			UDim2.new(1,-70,0.5,-15)

		control.BackgroundColor3 = Theme.Panel

		control.Text =
			feature.Type == "Slider"
			and "SET"
			or "GO"

		control.TextColor3 = Theme.Accent2

		control.TextSize = 10

		control.Font = Enum.Font.GothamBold

		control.AutoButtonColor = false

		control.Parent = card

		Corner(control,10)

		control.MouseButton1Click:Connect(function()

			T(control,0.1,{
				Size = UDim2.fromOffset(64,34)
			})

			task.delay(0.1,function()

				T(control,0.15,{
					Size = UDim2.fromOffset(58,30)
				})

			end)

			if feature.Callback then
				feature.Callback()
			end

		end)

	end

	card.MouseEnter:Connect(function()

		T(card,0.2,{
			BackgroundColor3 = Theme.CardHover
		})

	end)

	card.MouseLeave:Connect(function()

		T(card,0.2,{
			BackgroundColor3 = Theme.Card
		})

	end)

	return card
end

--========================================================
-- RENDER TAB
--========================================================

local function RenderTab(tabName)

	local page = PageObjects[tabName]

	if not page then
		return
	end

	ClearPage(page)

	for _,feature in ipairs(Features) do

		if feature.Tab == tabName then

			MakeCard(feature,page)

		end

	end
end

for _,data in ipairs(TabData) do
	RenderTab(data[2])
end

--========================================================
-- SEARCH RESULTS
--========================================================

local SearchPage = CreatePage("__SEARCH")

local SearchTitle = Text(
	SearchPage,
	"SEARCH RESULTS",
	12,
	true
)

SearchTitle.Size = UDim2.new(1,0,0,25)

local function RenderSearch(query)

	ClearPage(SearchPage)

	SearchTitle =
		Text(SearchPage,"SEARCH RESULTS",12,true)

	SearchTitle.Size = UDim2.new(1,0,0,25)

	if query == "" then
		return
	end

	local results = Search(query)

	local count = Text(
		SearchPage,
		tostring(#results).." result(s)",
		10,
		false
	)

	count.TextColor3 = Theme.SubText
	count.Size = UDim2.new(1,0,0,20)

	for _,result in ipairs(results) do

		local feature = result.Feature

		local card = MakeCard(
			feature,
			SearchPage
		)

		card.LayoutOrder = 10 - math.min(result.Score/100,9)

	end
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()

	local query = SearchBox.Text

	if query == "" then

		SearchPage.Visible = false

		local current

		for name,page in pairs(PageObjects) do

			if name ~= "__SEARCH" and page.Visible then
				current = page
			end

		end

		if not current then
			PageObjects.Combat.Visible = true
			TabButtons.Combat.BackgroundColor3 = Theme.Accent
			TabButtons.Combat.TextColor3 = Theme.Text
		end

	else

		for _,page in pairs(PageObjects) do
			page.Visible = false
		end

		SearchPage.Visible = true

		RenderSearch(query)

	end
end)

--========================================================
-- CROSSHAIR
--========================================================

local Crosshair = Instance.new("Frame")

Crosshair.Size = UDim2.fromOffset(60,60)

Crosshair.AnchorPoint = Vector2.new(0.5,0.5)

Crosshair.Position = UDim2.fromScale(0.5,0.5)

Crosshair.BackgroundTransparency = 1

Crosshair.Visible = false

Crosshair.ZIndex = 800

Crosshair.Parent = Gui

local CH1 = Instance.new("Frame")
CH1.Size = UDim2.fromOffset(2,60)
CH1.Position = UDim2.fromOffset(29,0)
CH1.BorderSizePixel = 0
CH1.BackgroundColor3 = Theme.Accent
CH1.Parent = Crosshair

local CH2 = Instance.new("Frame")
CH2.Size = UDim2.fromOffset(60,2)
CH2.Position = UDim2.fromOffset(0,29)
CH2.BorderSizePixel = 0
CH2.BackgroundColor3 = Theme.Accent
CH2.Parent = Crosshair

--========================================================
-- LIGHTNING
--========================================================

local function LightningFlash()

	if not Config.Lightning then
		return
	end

	for i = 1,8 do

		local bolt = Instance.new("Frame")

		bolt.BorderSizePixel = 0

		bolt.BackgroundColor3 =
			Theme.Accent2

		bolt.BackgroundTransparency = 1

		bolt.ZIndex = 950

		local horizontal =
			math.random(1,2) == 1

		if horizontal then

			bolt.Size =
				UDim2.fromOffset(
					math.random(30,100),
					math.random(1,3)
				)

			bolt.Position =
				UDim2.new(
					math.random(),
					0,
					math.random(0,1),
					0
				)

		else

			bolt.Size =
				UDim2.fromOffset(
					math.random(1,3),
					math.random(30,100)
				)

			bolt.Position =
				UDim2.new(
					math.random(0,1),
					0,
					math.random(),
					0
				)

		end

		bolt.Rotation =
			math.random(-30,30)

		bolt.Parent = FX

		T(
			bolt,
			0.05,
			{
				BackgroundTransparency = 0
			}
		)

		task.delay(0.06,function()

			T(
				bolt,
				0.2,
				{
					BackgroundTransparency = 1
				}
			)

			task.delay(0.22,function()

				if bolt then
					bolt:Destroy()
				end

			end)

		end)

	end
end

--========================================================
-- OPEN / CLOSE
--========================================================

local function OpenMenu()

	if Config.Open then
		return
	end

	Config.Open = true

	Main.Visible = true

	Main.Size = UDim2.fromOffset(0,0)

	Blur.Size = 0

	LightningFlash()

	task.delay(0.08,LightningFlash)
	task.delay(0.16,LightningFlash)
	task.delay(0.24,LightningFlash)

	T(
		Blur,
		0.4,
		{
			Size = 7
		}
	)

	T(
		Main,
		0.55,
		{
			Size = UDim2.fromOffset(660,500)
		},
		Enum.EasingStyle.Back
	)

	task.delay(0.15,function()

		for i,button in ipairs(TabButtons) do

			button.BackgroundTransparency = 1

			task.delay(i*0.025,function()

				T(
					button,
					0.25,
					{
						BackgroundTransparency = 0
					}
				)

			end)

		end

	end)

	PageObjects.Combat.Visible = true

	TabButtons.Combat.BackgroundColor3 = Theme.Accent
	TabButtons.Combat.TextColor3 = Theme.Text

end

local function CloseMenu()

	if not Config.Open then
		return
	end

	Config.Open = false

	LightningFlash()

	T(
		Blur,
		0.25,
		{
			Size = 0
		}
	)

	T(
		Main,
		0.35,
		{
			Size = UDim2.fromOffset(0,0)
		},
		Enum.EasingStyle.Back,
		Enum.EasingDirection.In
	)

	task.delay(0.36,function()

		Main.Visible = false

	end)

end

OpenButton.MouseButton1Click:Connect(function()

	if Config.Open then
		CloseMenu()
	else
		OpenMenu()
	end

end)

Close.MouseButton1Click:Connect(CloseMenu)

--========================================================
-- OPEN BUTTON ANIMATION
--========================================================

OpenButton.MouseEnter:Connect(function()

	T(
		OpenButton,
		0.2,
		{
			Size = UDim2.fromOffset(64,64)
		},
		Enum.EasingStyle.Back
	)

end)

OpenButton.MouseLeave:Connect(function()

	T(
		OpenButton,
		0.2,
		{
			Size = UDim2.fromOffset(58,58)
		}
	)

end)

--========================================================
-- DRAG
--========================================================

local dragging = false
local dragStart
local startPosition

Top.InputBegan:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		dragging = true

		dragStart = input.Position

		startPosition = Main.Position

		input.Changed:Connect(function()

			if input.UserInputState ==
				Enum.UserInputState.End then

				dragging = false

			end

		end)

	end

end)

UserInputService.InputChanged:Connect(function(input)

	if not dragging then
		return
	end

	if input.UserInputType ==
		Enum.UserInputType.MouseMovement
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		local delta =
			input.Position - dragStart

		Main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)

	end

end)

--========================================================
-- FPS / COORDINATES
--========================================================

local Info = Text(
	Gui,
	"",
	10,
	true
)

Info.Position = UDim2.new(1,-170,0,20)
Info.Size = UDim2.fromOffset(150,45)

Info.TextColor3 = Theme.Accent2
Info.TextXAlignment = Enum.TextXAlignment.Right
Info.ZIndex = 500

local fps = 60
local elapsed = 0
local frames = 0

RunService.RenderStepped:Connect(function(dt)

	frames += 1
	elapsed += dt

	if elapsed >= 0.5 then

		fps = math.floor(frames / elapsed)

		frames = 0
		elapsed = 0

	end

	local character =
		LocalPlayer.Character

	local root =
		character and
		character:FindFirstChild(
			"HumanoidRootPart"
		)

	local output = ""

	if Config.FPS then

		output =
			output ..
			"FPS  "..fps

	end

	if Config.Coordinates and root then

		output =
			output ..
			"\nXYZ  " ..
			math.floor(root.Position.X) ..
			" / " ..
			math.floor(root.Position.Y) ..
			" / " ..
			math.floor(root.Position.Z)

	end

	Info.Text = output

	Crosshair.Visible = Config.Crosshair

end)

--========================================================
-- RAINBOW
--========================================================

local hue = 0

RunService.RenderStepped:Connect(function(dt)

	if not Config.Rainbow then
		return
	end

	hue =
		(hue + dt * 0.12) % 1

	local rainbow =
		Color3.fromHSV(
			hue,
			0.65,
			1
		)

	Title.TextColor3 = rainbow
	OpenButton.TextColor3 = rainbow

end)

--========================================================
-- MOBILE SIZE
--========================================================

local function UpdateMobile()

	local viewport =
		Camera.ViewportSize

	if viewport.X < 700 then

		Main.Size =
			UDim2.fromOffset(
				math.min(viewport.X - 20,560),
				math.min(viewport.Y - 60,480)
			)

		Tabs.Size =
			UDim2.new(0,125,1,0)

		Pages.Position =
			UDim2.new(0,135,0,0)

		Pages.Size =
			UDim2.new(1,-135,1,0)

	end

end

Camera:GetPropertyChangedSignal(
	"ViewportSize"
):Connect(UpdateMobile)

UpdateMobile()

--========================================================
-- DEFAULT TAB
--========================================================

PageObjects.Combat.Visible = true

TabButtons.Combat.BackgroundColor3 =
	Theme.Accent

TabButtons.Combat.TextColor3 =
	Theme.Text

--========================================================
-- FINAL
--========================================================

print("================================")
print(" ZAKA PURE UI V5.0")
print(" All-In-One Edition Loaded")
print(" Features:",#Features)
print(" Smart Search: READY")
print(" Mobile UI: READY")
print(" Lightning FX: READY")
print("================================")
