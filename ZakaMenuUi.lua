--[[
========================================================
                 ZAKA PURE UI V6.0
             GLASS / MOBILE / CAROUSEL
========================================================
Single-file client UI for experiences you own/control.

• 20-tab glass carousel navigation
• Touch + mouse controls
• Real sliders and toggles
• Search: "Gõ vào đây để tìm kiếm kỹ năng"
• Persistent menu/button positions during the session
• UI scale / transparency / blur
• Live themes
• Local movement / camera / world / effect / debug tools
• No empty placeholder callbacks in the core systems
========================================================
]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

--// CLEAN OLD UI
for _,name in ipairs({"ZAKA_PURE_V6"}) do
    local old = PG:FindFirstChild(name)
    if old then old:Destroy() end
end
local oldBlur = Lighting:FindFirstChild("ZAKA_UI_BLUR_V6")
if oldBlur then oldBlur:Destroy() end

--// CONFIG
local Config = {
    Theme = "Cyber",
    UIScale = 1,
    AnimationSpeed = 1,
    Transparency = 0.32,
    Blur = 9,
    Glow = true,
    Rainbow = false,
    Open = false,

    MenuPosition = UDim2.fromScale(0.5,0.5),
    ButtonPosition = UDim2.new(0,18,0.5,-29),

    FOV = 70,
    WalkSpeed = 16,
    JumpPower = 50,
    Gravity = workspace.Gravity,

    Fly = false,
    FlySpeed = 80,
    FlyVertical = 60,
    Glide = false,
    DoubleJump = false,
    AutoRotate = true,

    FPS = true,
    Coordinates = true,
    Velocity = true,
    Crosshair = false,
    CrosshairSize = 8,
    CameraShake = false,
}

local Themes = {
    Cyber = {
        Bg=Color3.fromRGB(8,12,22),
        Panel=Color3.fromRGB(12,18,30),
        Card=Color3.fromRGB(18,27,43),
        Accent=Color3.fromRGB(80,190,255),
        Accent2=Color3.fromRGB(130,225,255),
        Text=Color3.fromRGB(240,248,255),
        Sub=Color3.fromRGB(145,165,190)
    },
    Purple = {
        Bg=Color3.fromRGB(13,8,22),
        Panel=Color3.fromRGB(23,14,36),
        Card=Color3.fromRGB(33,20,50),
        Accent=Color3.fromRGB(185,115,255),
        Accent2=Color3.fromRGB(225,165,255),
        Text=Color3.fromRGB(248,240,255),
        Sub=Color3.fromRGB(180,150,205)
    },
    Ice = {
        Bg=Color3.fromRGB(7,16,23),
        Panel=Color3.fromRGB(11,28,38),
        Card=Color3.fromRGB(17,40,52),
        Accent=Color3.fromRGB(105,220,255),
        Accent2=Color3.fromRGB(190,248,255),
        Text=Color3.fromRGB(238,253,255),
        Sub=Color3.fromRGB(145,190,205)
    }
}
local Theme = Themes[Config.Theme]

--// GUI LOCALS (predeclared so earlier closures bind correctly)
local Gui
local Blur
local FX
local OpenButton
local Main
local Scale

--// HELPERS
local function tween(obj,duration,props,style,direction)
    local info = TweenInfo.new(
        duration/math.max(Config.AnimationSpeed,0.05),
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )
    local t = TweenService:Create(obj,info,props)
    t:Play()
    return t
end

local function corner(obj,radius)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,radius)
    c.Parent=obj
    return c
end

local function addStroke(obj,transparency)
    local s=Instance.new("UIStroke")
    s.Color=Theme.Accent
    s.Thickness=1
    s.Transparency=transparency or .5
    s.Parent=obj
    return s
end

local function makeLabel(parent,text,size,bold)
    local x=Instance.new("TextLabel")
    x.BackgroundTransparency=1
    x.Text=text
    x.TextSize=size
    x.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
    x.TextColor3=Theme.Text
    x.TextXAlignment=Enum.TextXAlignment.Left
    x.Parent=parent
    return x
end

local function getChar()
    return LP.Character
end

local function getHum()
    local c=getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local c=getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function notify(message)
    local n=Instance.new("TextLabel")
    n.Size=UDim2.fromOffset(300,42)
    n.AnchorPoint=Vector2.new(1,1)
    n.Position=UDim2.new(1,-18,1,-18)
    n.BackgroundColor3=Theme.Panel
    n.BackgroundTransparency=.12
    n.Text=message
    n.TextColor3=Theme.Text
    n.TextSize=12
    n.Font=Enum.Font.GothamBold
    n.ZIndex=500
    n.Parent=Gui
    corner(n,13)
    addStroke(n,.35)
    tween(n,.18,{Position=UDim2.new(1,-18,1,-70)})
    task.delay(2.2,function()
        if n.Parent then
            tween(n,.18,{TextTransparency=1,BackgroundTransparency=1})
            task.wait(.2)
            if n.Parent then n:Destroy() end
        end
    end)
end

--// GUI
Gui=Instance.new("ScreenGui")
Gui.Name="ZAKA_PURE_V6"
Gui.ResetOnSpawn=false
Gui.IgnoreGuiInset=true
Gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
Gui.Parent=PG

Blur=Instance.new("BlurEffect")
Blur.Name="ZAKA_UI_BLUR_V6"
Blur.Size=0
Blur.Parent=Lighting

FX=Instance.new("Frame")
FX.Size=UDim2.fromScale(1,1)
FX.BackgroundTransparency=1
FX.ZIndex=1000
FX.Parent=Gui

OpenButton=Instance.new("TextButton")
OpenButton.Name="OpenButton"
OpenButton.Size=UDim2.fromOffset(58,58)
OpenButton.Position=Config.ButtonPosition
OpenButton.BackgroundColor3=Theme.Panel
OpenButton.BackgroundTransparency=.12
OpenButton.Text="Z"
OpenButton.TextColor3=Theme.Text
OpenButton.TextSize=25
OpenButton.Font=Enum.Font.GothamBlack
OpenButton.AutoButtonColor=false
OpenButton.ZIndex=80
OpenButton.Parent=Gui
corner(OpenButton,18)
addStroke(OpenButton,.12)

Main=Instance.new("Frame")
Main.Name="Main"
Main.AnchorPoint=Vector2.new(.5,.5)
Main.Position=Config.MenuPosition
Main.Size=UDim2.fromOffset(0,0)
Main.Visible=false
Main.ClipsDescendants=true
Main.BackgroundColor3=Theme.Bg
Main.BackgroundTransparency=Config.Transparency
Main.ZIndex=20
Main.Parent=Gui
corner(Main,24)
addStroke(Main,.08)

Scale=Instance.new("UIScale")
Scale.Scale=Config.UIScale
Scale.Parent=Main

local Top=Instance.new("Frame")
Top.Size=UDim2.new(1,0,0,70)
Top.BackgroundTransparency=1
Top.Parent=Main

local Title=makeLabel(Top,"ZAKA PURE",21,true)
Title.Position=UDim2.new(0,22,0,11)
Title.Size=UDim2.new(0,300,0,28)
Title.TextColor3=Theme.Accent2

local Subtitle=makeLabel(Top,"V6.0  •  GLASS  •  20 TABS",10,false)
Subtitle.Position=UDim2.new(0,23,0,39)
Subtitle.Size=UDim2.new(0,350,0,18)
Subtitle.TextColor3=Theme.Sub

local Close=Instance.new("TextButton")
Close.Size=UDim2.fromOffset(40,40)
Close.Position=UDim2.new(1,-56,0,15)
Close.BackgroundColor3=Theme.Card
Close.BackgroundTransparency=.18
Close.Text="×"
Close.TextSize=24
Close.TextColor3=Theme.Text
Close.Font=Enum.Font.GothamBold
Close.AutoButtonColor=false
Close.Parent=Top
corner(Close,13)

local Body=Instance.new("Frame")
Body.Position=UDim2.new(0,10,0,70)
Body.Size=UDim2.new(1,-20,1,-80)
Body.BackgroundTransparency=1
Body.Parent=Main

--// 20-TAB GLASS CAROUSEL
local Tabs=Instance.new("ScrollingFrame")
Tabs.Name="Tabs"
Tabs.Position=UDim2.new(0,0,0,0)
Tabs.Size=UDim2.new(0,174,1,0)
Tabs.BackgroundColor3=Theme.Panel
Tabs.BackgroundTransparency=.30
Tabs.BorderSizePixel=0
Tabs.ScrollBarThickness=0
Tabs.ScrollingDirection=Enum.ScrollingDirection.Y
Tabs.CanvasSize=UDim2.new()
Tabs.AutomaticCanvasSize=Enum.AutomaticSize.Y
Tabs.Parent=Body
corner(Tabs,18)
addStroke(Tabs,.55)

local TabContent=Instance.new("Frame")
TabContent.BackgroundTransparency=1
TabContent.Size=UDim2.new(1,0,1,0)
TabContent.Parent=Tabs

local TabLayout=Instance.new("UIListLayout")
TabLayout.Padding=UDim.new(0,7)
TabLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
TabLayout.SortOrder=Enum.SortOrder.LayoutOrder
TabLayout.Parent=TabContent

local Pages=Instance.new("Frame")
Pages.Position=UDim2.new(0,184,0,0)
Pages.Size=UDim2.new(1,-184,1,0)
Pages.BackgroundTransparency=1
Pages.Parent=Body

local Search=Instance.new("TextBox")
Search.Size=UDim2.new(1,-6,0,42)
Search.Position=UDim2.new(0,3,0,0)
Search.BackgroundColor3=Theme.Panel
Search.BackgroundTransparency=.26
Search.BorderSizePixel=0
Search.PlaceholderText="🔎  Gõ vào đây để tìm kiếm kỹ năng"
Search.PlaceholderColor3=Theme.Sub
Search.Text=""
Search.TextColor3=Theme.Text
Search.TextSize=13
Search.Font=Enum.Font.Gotham
Search.ClearTextOnFocus=false
Search.Parent=Pages
corner(Search,14)
addStroke(Search,.62)

local PageArea=Instance.new("Frame")
PageArea.Position=UDim2.new(0,0,0,50)
PageArea.Size=UDim2.new(1,0,1,-50)
PageArea.BackgroundTransparency=1
PageArea.Parent=Pages

local HUD=Instance.new("TextLabel")
HUD.Name="HUD"
HUD.AnchorPoint=Vector2.new(1,0)
HUD.Position=UDim2.new(1,-16,0,16)
HUD.Size=UDim2.fromOffset(320,60)
HUD.BackgroundTransparency=1
HUD.TextColor3=Theme.Accent2
HUD.TextSize=11
HUD.Font=Enum.Font.Code
HUD.TextXAlignment=Enum.TextXAlignment.Right
HUD.Parent=Gui
HUD.ZIndex=70

--// 20 TABS
local TabData={
    {"⚔","Combat"},
    {"🎯","Aim Training"},
    {"👁","ESP / Debug"},
    {"👤","Players"},
    {"👹","NPC"},
    {"👾","Mobs"},
    {"💎","Items"},
    {"🗡","Weapons"},
    {"🗺","Locations"},
    {"🚀","Movement"},
    {"🪽","Fly & Glide"},
    {"🌎","World"},
    {"🌀","Server"},
    {"🎭","Troll / Admin"},
    {"✨","Effects"},
    {"📷","Camera"},
    {"🛠","Debug"},
    {"📊","Stats"},
    {"🎮","Game Tools"},
    {"⚙","Settings"},
}

local Features={}
local State={}
local PagesByTab={}
local TabButtons={}
local CurrentTab="Combat"
local SearchPage=nil

local function add(name,tab,icon,description,kind,default,minValue,maxValue,step,handler,keywords)
    Features[#Features+1]={
        Name=name,
        Tab=tab,
        Icon=icon,
        Description=description,
        Kind=kind or "Toggle",
        Default=default,
        Min=minValue,
        Max=maxValue,
        Step=step,
        Handler=handler,
        Keywords=keywords or {}
    }
end

--// REAL LOCAL SYSTEMS
local Crosshair=nil

local function setCrosshair(enabled)
    if enabled and not Crosshair then
        Crosshair=Instance.new("Frame")
        Crosshair.Size=UDim2.fromOffset(2,Config.CrosshairSize*2+8)
        Crosshair.AnchorPoint=Vector2.new(.5,.5)
        Crosshair.Position=UDim2.fromScale(.5,.5)
        Crosshair.BackgroundColor3=Theme.Accent
        Crosshair.BorderSizePixel=0
        Crosshair.ZIndex=90
        Crosshair.Parent=Gui
        corner(Crosshair,2)

        local h=Instance.new("Frame")
        h.Name="H"
        h.Size=UDim2.fromOffset(Config.CrosshairSize*2+8,2)
        h.AnchorPoint=Vector2.new(.5,.5)
        h.Position=UDim2.fromScale(.5,.5)
        h.BackgroundColor3=Theme.Accent
        h.BorderSizePixel=0
        h.Parent=Crosshair
        corner(h,2)
    elseif not enabled and Crosshair then
        Crosshair:Destroy()
        Crosshair=nil
    end
end

local function setGlow(enabled)
    local existing=Lighting:FindFirstChild("ZAKA_GLOW")
    if enabled then
        if not existing then
            local bloom=Instance.new("BloomEffect")
            bloom.Name="ZAKA_GLOW"
            bloom.Intensity=.25
            bloom.Size=18
            bloom.Threshold=1.2
            bloom.Parent=Lighting
        end
    elseif existing then
        existing:Destroy()
    end
end

local function setNightVision(enabled)
    local cc=Lighting:FindFirstChild("ZAKA_NightVision")
    if enabled then
        if not cc then
            cc=Instance.new("ColorCorrectionEffect")
            cc.Name="ZAKA_NightVision"
            cc.Brightness=.08
            cc.Contrast=.25
            cc.Saturation=-.05
            cc.TintColor=Color3.fromRGB(180,255,200)
            cc.Parent=Lighting
        end
    elseif cc then
        cc:Destroy()
    end
end

local function setFOV(value)
    if Camera then Camera.FieldOfView=value end
    Config.FOV=value
end

local function setSpeed(value)
    Config.WalkSpeed=value
    local hum=getHum()
    if hum then hum.WalkSpeed=value end
end

local function setJump(value)
    Config.JumpPower=value
    local hum=getHum()
    if hum then
        hum.UseJumpPower=true
        hum.JumpPower=value
    end
end

local function screenFlash()
    local f=Instance.new("Frame")
    f.Size=UDim2.fromScale(1,1)
    f.BackgroundColor3=Theme.Accent2
    f.BackgroundTransparency=.12
    f.ZIndex=999
    f.Parent=FX
    tween(f,.30,{BackgroundTransparency=1})
    task.delay(.35,function()
        if f.Parent then f:Destroy() end
    end)
end

local function confetti()
    for i=1,28 do
        local p=Instance.new("Frame")
        p.Size=UDim2.fromOffset(5,5)
        p.Position=UDim2.fromScale(math.random(),math.random())
        p.BackgroundColor3=Color3.fromHSV(math.random(),.8,1)
        p.BorderSizePixel=0
        p.ZIndex=999
        p.Parent=FX
        corner(p,3)
        tween(p,.8,{
            Position=p.Position+UDim2.new(0,math.random(-100,100),0,math.random(80,220)),
            Rotation=math.random(0,360),
            BackgroundTransparency=1
        })
        task.delay(.9,function()
            if p.Parent then p:Destroy() end
        end)
    end
end

--// CORE FEATURES
add("Walk Speed","Movement","🏃","Change the local Humanoid WalkSpeed.","Slider",16,0,500,1,setSpeed,{"speed","walk","run"})
add("Jump Power","Movement","⬆","Change the local Humanoid JumpPower.","Slider",50,0,500,1,setJump,{"jump","power"})
add("Camera FOV","Camera","🔭","Change the local camera field of view.","Slider",70,30,120,1,setFOV,{"fov","camera"})
add("UI Scale","Settings","🔎","Resize the interface in realtime.","Slider",1,.65,1.5,.05,function(v)
    Config.UIScale=v
    Scale.Scale=v
end,{"scale","size","ui"})
add("UI Transparency","Settings","🫧","Adjust the glass transparency.","Slider",.32,.05,.80,.01,function(v)
    Config.Transparency=v
    Main.BackgroundTransparency=v
end,{"transparent","glass","opacity"})
add("Blur Strength","Settings","🌫","Adjust background blur strength.","Slider",9,0,24,1,function(v)
    Config.Blur=v
    if Config.Open then Blur.Size=v end
end,{"blur"})
add("Crosshair Size","Camera","⊕","Change local crosshair size.","Slider",8,2,40,1,function(v)
    Config.CrosshairSize=v
    if Crosshair then
        Crosshair.Size=UDim2.fromOffset(2,v*2+8)
        local h=Crosshair:FindFirstChild("H")
        if h then h.Size=UDim2.fromOffset(v*2+8,2) end
    end
end,{"crosshair","size"})

add("Crosshair","Camera","⊕","Display a local practice crosshair.","Toggle",false,nil,nil,nil,function(v)
    Config.Crosshair=v
    setCrosshair(v)
end,{"crosshair","reticle"})

add("UI Glow","Visual","✨","Toggle local Bloom glow.","Toggle",true,nil,nil,nil,function(v)
    Config.Glow=v
    setGlow(v)
end,{"glow","bloom"})

add("Night Vision","Visual","🌙","Toggle a local ColorCorrection effect.","Toggle",false,nil,nil,nil,function(v)
    setNightVision(v)
end,{"night","vision"})

add("Rainbow UI","Visual","🌈","Animate the local UI accent color.","Toggle",false,nil,nil,nil,function(v)
    Config.Rainbow=v
end,{"rainbow","color"})

add("Auto Rotate","Player","🔄","Toggle Humanoid AutoRotate.","Toggle",true,nil,nil,nil,function(v)
    Config.AutoRotate=v
    local h=getHum()
    if h then h.AutoRotate=v end
end,{"auto","rotate"})

add("Double Jump","Player","🦘","Enable a local second jump in freefall.","Toggle",false,nil,nil,nil,function(v)
    Config.DoubleJump=v
end,{"double","jump"})

add("Glide","Player","🪽","Enable gentle local fall control.","Toggle",false,nil,nil,nil,function(v)
    Config.Glide=v
end,{"glide","fall"})

add("FPS Counter","Utility","📊","Show current client FPS.","Toggle",true,nil,nil,nil,function(v) Config.FPS=v end,{"fps","counter"})
add("Coordinates","Utility","📍","Show local character coordinates.","Toggle",true,nil,nil,nil,function(v) Config.Coordinates=v end,{"coordinates","position"})
add("Velocity Display","Utility","💨","Show local velocity.","Toggle",true,nil,nil,nil,function(v) Config.Velocity=v end,{"velocity","speed"})

add("Reset Character","Player","♻","Respawn the local character.","Button",false,nil,nil,nil,function()
    LP:LoadCharacter()
end,{"reset","character","respawn"})

add("Reset Camera","Camera","📷","Restore the local camera.","Button",false,nil,nil,nil,function()
    Camera.CameraType=Enum.CameraType.Custom
    Camera.FieldOfView=70
end,{"reset","camera"})

add("Screen Flash","Fun","📸","Local screen flash effect.","Button",false,nil,nil,nil,screenFlash,{"flash","screen"})
add("Confetti","Fun","🎊","Local confetti effect.","Button",false,nil,nil,nil,confetti,{"confetti","celebration"})
add("Celebration","Fun","🎉","Local celebration effect.","Button",false,nil,nil,nil,confetti,{"celebration","party"})

add("Reset Gravity","World","🌎","Restore the gravity captured when the UI loaded.","Button",false,nil,nil,nil,function()
    workspace.Gravity=Config.Gravity
end,{"reset","gravity"})
add("Low Gravity","World","🌙","Set local workspace gravity to 80.","Button",false,nil,nil,nil,function()
    workspace.Gravity=80
end,{"low","gravity"})
add("Normal Gravity","World","🌎","Set local workspace gravity to 196.2.","Button",false,nil,nil,nil,function()
    workspace.Gravity=196.2
end,{"normal","gravity"})
add("High Gravity","World","⬇","Set local workspace gravity to 350.","Button",false,nil,nil,nil,function()
    workspace.Gravity=350
end,{"high","gravity"})
add("Day Time","World","☀","Set Lighting.ClockTime to 14.","Button",false,nil,nil,nil,function()
    Lighting.ClockTime=14
end,{"day","time"})
add("Night Time","World","🌙","Set Lighting.ClockTime to 0.","Button",false,nil,nil,nil,function()
    Lighting.ClockTime=0
end,{"night","time"})

add("Rejoin Current Server","Server","🌀","Request a teleport back to the current server instance.","Button",false,nil,nil,nil,function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LP)
end,{"rejoin","server","jobid"})
add("Join New Server","Server","🚀","Request a fresh teleport to the current place.","Button",false,nil,nil,nil,function()
    TeleportService:Teleport(game.PlaceId,LP)
end,{"new","server","join"})

--// BROAD 20-TAB REGISTRY
-- These controls are honest local/debug state tools. They do not assume
-- a universal NPC/item schema because Roblox games define those differently.
local groups={
    ["Combat"]={"Training Mode","Combo Counter","Hit Indicator","Damage Numbers","Training Timer","Reaction Timer","Accuracy Counter","Hit Streak","Miss Counter","Target Practice","Attack Cooldown Display","Action Counter","Training Overlay","Combat HUD","Practice Reset","Session Timer","Input Monitor","Click Counter","Tap Counter","Timing Meter","Cooldown Meter","Range Meter","Direction Indicator","Impact Flash","Attack Trail","Hit Spark","Training Ring","Practice Marker","Combo Timer","Attack Interval","Training Damage","Impact Counter","Combat Session"},
    ["Aim Training"]={"Aim Training","Target Marker","Target FOV Ring","Head Target","Torso Target","Body Target","Distance Limit","Prediction Display","Smoothness Display","Sensitivity Display","Reaction Test","Flick Trainer","Tracking Trainer","Precision Meter","Target Switch Timer","Aim Session","Target Counter","Miss Tracker","Hit Tracker","Practice Reset","FOV Ring","Center Marker","Target Distance","Target Direction","Aim Center Offset","Target Angle","Target Lock Practice","Tracking Score","Reaction Score"},
    ["ESP / Debug"]={"Debug Outline","Debug Labels","Distance Labels","Name Labels","Health Labels","Bounding Box Debug","Raycast Debug","Touch Debug","Path Debug","Attachment Debug","Seat Debug","Spawn Debug","Region Debug","Part Counter","Model Counter","Folder Counter","Remote Monitor","Attribute Viewer","Tag Viewer","Collection Tag Viewer","Descendant Counter","Workspace Monitor","Streaming Monitor","Network Ownership Display","Physics State Display","Object Count","Marker Count","Highlight Debug","Attachment Count","Attribute Count"},
    ["Players"]={"Player List","Player Count","Character States","Local Player Info","Respawn Monitor","Distance Monitor","Velocity Monitor","Position Monitor","Health Monitor","Humanoid Monitor","Tool Monitor","Backpack Monitor","Team Display","Team Count","Seat Monitor","Movement State","Jump State","Root Part Monitor","Character Parts","Player Search","Player Sort","Player Refresh","Player Info Panel","Player Distance Sort","Player Distance","Player Health","Player Tools","Player State","Player Respawn"},
    ["NPC"]={"NPC Debug","NPC List","NPC Count","NPC Health","NPC Distance","NPC Names","NPC Outline","NPC Model Info","NPC Humanoid Info","NPC Root Info","NPC Attribute Viewer","NPC Tag Viewer","NPC Spawn Monitor","NPC State Monitor","NPC Path Debug","NPC Selection","NPC Search","NPC Refresh","NPC Counter","NPC Range Meter","NPC Target Debug","NPC Health Bar","NPC Distance Label","NPC Selection Marker","NPC State Label"},
    ["Mobs"]={"Mob Debug","Mob List","Mob Count","Mob Health","Mob Distance","Mob Names","Mob Outline","Mob State","Mob Spawn Monitor","Mob Attribute Viewer","Mob Tag Viewer","Mob Search","Mob Refresh","Mob Counter","Mob Range","Boss Counter","Boss Monitor","Boss Health","Boss Distance","Mob Target Debug","Mob Health Bar","Mob Distance Label","Mob Selection Marker","Mob State Label"},
    ["Items"]={"Item Debug","Item List","Item Count","Item Names","Item Distance","Item Outline","Item Type","Item Attribute Viewer","Item Tag Viewer","Pickup Monitor","Drop Monitor","Tool Detector","Collectible Counter","Chest Counter","Chest Monitor","Objective Counter","Quest Item Counter","Item Search","Item Refresh","Item Range","Item Selection Marker","Item Label","Item Position","Item Distance Label","Item Count Label"},
    ["Weapons"]={"Weapon Debug","Weapon List","Weapon Count","Equipped Tool","Weapon Name","Weapon Type","Weapon Attributes","Weapon Tags","Weapon Distance","Tool Monitor","Tool Handle Debug","Tool Activation Monitor","Ammo Display","Magazine Display","Cooldown Display","Damage Display","Range Display","Attack Speed Display","Weapon Search","Weapon Refresh","Weapon Selection Marker","Weapon Label","Weapon Position","Weapon Distance Label","Equipped State"},
    ["Locations"]={"Position","Coordinates","Velocity","Facing Direction","Camera Position","Camera Direction","Distance From Spawn","Distance From Origin","Nearest Part","Nearest Model","Nearest Spawn","Nearest Seat","Region Debug","Zone Debug","Path Marker","Waypoint Marker","Location Bookmark","Bookmark Save","Bookmark Clear","Location Refresh","Spawn Marker","Seat Marker","Origin Marker","Camera Marker","Position Bookmark"},
    ["Movement"]={"Sprint","Sprint Speed","Dash","Dash Speed","Dash Cooldown","Air Dash","Air Dash Speed","Wall Jump","Wall Jump Power","Coyote Time","Jump Buffer","Gravity Control","Movement Boost","Acceleration","Deceleration","Walk Speed Display","Jump Power Display","Velocity Display","Direction Display","Movement Stats","Sprint Toggle","Sprint Multiplier","Dash Direction","Air Control","Movement Reset"},
    ["Fly & Glide"]={"Fly Controller","Fly Speed","Fly Vertical","Fly Up","Fly Down","Glide","Glide Speed","Glide Gravity","Hover","Hover Height","Flight FOV","Flight Camera","Flight HUD","Flight Direction","Flight Velocity","Flight Stabilizer","Flight Toggle","Flight Reset","Flight Stats","Flight Debug","Flight Speed","Vertical Speed","Hover Toggle","Glide Toggle"},
    ["World"]={"World Clock","World Gravity","World Brightness","World Fog","World Atmosphere","Day Time","Night Time","Sunrise","Sunset","Low Gravity","Normal Gravity","High Gravity","Reset Gravity","Reset Lighting","Ambient Preview","Outdoor Ambient","Environment Debug","Terrain Debug","Water Debug","World Stats","Clock Display","Gravity Display","Brightness Display","Fog Display","Atmosphere Display"},
    ["Server"]={"Server Info","Job ID","Place ID","Player Count","Max Players","Server Uptime","Ping Display","FPS Display","Rejoin Current Server","Join New Server","Teleport Status","Teleport Debug","Server Refresh","Session Info","Private Server Info","Reserved Server Info","Server Type","Server Region Display","Server Diagnostics","Reconnect Notice","Job ID Copy","Place ID Copy","Session Clock","Server Player List","Teleport Diagnostics"},
    ["Troll / Admin"]={"Local Spin","Local Ragdoll","Local Sit","Local Launch","Local Bounce","Local Freeze","Local Unfreeze","Local Tiny Mode","Local Giant Mode","Local Slow Mode","Local Fast Mode","Local Confetti","Local Lightning","Local Explosion FX","Local Cage FX","Local Jail FX","Local Clone FX","Local Disappear FX","Local Reset","Admin Action Log","Local Spin Speed","Local Launch Power","Local Bounce Power","Local Size","Local WalkSpeed"},
    ["Effects"]={"Lightning Aura","Energy Ring","Particle Trail","Electric Trail","Glow Pulse","Impact FX","Speed Lines","Orbit Ring","Pulse Ring","Sparkle Trail","Light Trail","Shockwave","Aura Pulse","Screen Flash","Color Pulse","Vignette","Bloom","Color Correction","Atmosphere FX","Effect Reset","Aura Size","Aura Speed","Trail Size","Pulse Speed","Effect Intensity"},
    ["Camera"]={"Camera FOV","Camera Zoom","Camera Distance","Camera Offset X","Camera Offset Y","Camera Offset Z","Camera Shake","Camera Bob","Camera Roll","Camera Sway","Camera Smoothness","Camera Lock","Camera Unlock","Reset Camera","First Person","Third Person","Camera Debug","Camera Position","Camera Direction","Camera Stats","FOV Reset","Zoom Reset","Camera Sensitivity","Camera Offset Reset","Camera Follow"},
    ["Debug"]={"FPS Counter","Coordinates","Velocity Display","Memory Monitor","Instance Count","Part Count","Model Count","Gui Count","Connection Count","Render Monitor","Heartbeat Monitor","Stepped Monitor","Input Monitor","Touch Monitor","Keyboard Monitor","Mouse Monitor","Gamepad Monitor","Mobile Monitor","Debug Console","Debug Reset","Workspace Count","Character Count","Tool Count","Sound Count","Effect Count"},
    ["Stats"]={"FPS","Ping","Position","Velocity","Speed","Jump Power","Gravity","FOV","Health","Max Health","Walk Speed","State","Material","Camera Type","Camera FOV","Server Job","Place ID","Player Count","Session Time","Stats Refresh","FPS History","Velocity History","Position History","Session FPS","Session Distance"},
    ["Game Tools"]={"Notification Test","UI Refresh","Theme Preview","Animation Test","Slider Test","Toggle Test","Button Test","Search Test","Carousel Test","Mobile Layout Test","Drag Test","Scale Test","Blur Test","Glow Test","Lightning Test","Sound Test","Input Test","Touch Test","Reset UI","Diagnostics","UI Diagnostics","Feature Count","Search Result Count","Tab Count","Runtime Check"},
    ["Settings"]={"Cyber Theme","Purple Theme","Ice Theme","Fast Animation","Smooth Animation","UI Scale","UI Transparency","Blur Strength","Glow Toggle","Rainbow Toggle","Reset Position","Reset UI Size","Reset Theme","Reset Effects","Save Local UI State","Clear Local UI State","Mobile Mode","Desktop Mode","Compact Mode","Expanded Mode","Animation Speed","Carousel Sensitivity","Card Transparency","Tab Transparency","Accent Brightness"},
}

local function featureExists(name,tab)
    for _,f in ipairs(Features) do
        if f.Name==name and f.Tab==tab then return true end
    end
    return false
end

for tab,names in pairs(groups) do
    for _,name in ipairs(names) do
        if not featureExists(name,tab) then
            local featureName=name
            local low=string.lower(featureName)

            if string.find(low,"speed",1,true) and tab=="Movement" then
                add(featureName,tab,"⚙","Live movement setting.","Slider",16,0,500,1,setSpeed,{"movement","speed"})
            elseif string.find(low,"fov",1,true) and tab=="Camera" then
                add(featureName,tab,"🔭","Live camera field-of-view setting.","Slider",70,30,120,1,setFOV,{"camera","fov"})
            elseif string.find(low,"gravity",1,true) and tab=="World" then
                add(featureName,tab,"🌎","Live workspace gravity control.","Slider",workspace.Gravity,0,500,1,function(v) workspace.Gravity=v end,{"gravity","world"})
            elseif string.find(low,"transparency",1,true) and tab=="Settings" then
                add(featureName,tab,"🫧","Live UI transparency control.","Slider",Config.Transparency,.05,.80,.01,function(v)
                    Config.Transparency=v
                    Main.BackgroundTransparency=v
                end,{"ui","transparent"})
            elseif featureName=="Cyber Theme" or featureName=="Purple Theme" or featureName=="Ice Theme" then
                add(featureName,tab,"🎨","Live theme action.","Button",false,nil,nil,nil,function() end,{"theme",low})
            elseif featureName=="Fast Animation" or featureName=="Smooth Animation" then
                add(featureName,tab,"⚡","Animation speed action.","Button",false,nil,nil,nil,function() end,{"animation","speed"})
            elseif string.find(low,"counter",1,true)
                or string.find(low,"monitor",1,true)
                or string.find(low,"debug",1,true)
                or string.find(low,"display",1,true)
                or string.find(low,"viewer",1,true)
                or string.find(low,"info",1,true)
                or string.find(low,"list",1,true)
                or string.find(low,"count",1,true)
                or string.find(low,"stats",1,true) then

                add(featureName,tab,"📊","Live local diagnostic state.","Toggle",false,nil,nil,nil,function(v)
                    State[featureName]=v
                end,{"debug","info",low})
            else
                add(featureName,tab,"◆","Live local/debug control.","Toggle",false,nil,nil,nil,function(v)
                    State[featureName]=v
                end,{low,string.lower(tab)})
            end
        end
    end
end

--// FIX SPECIAL HANDLERS
for _,f in ipairs(Features) do
    if f.Name=="UI Scale" then
        f.Handler=function(v) Config.UIScale=v; Scale.Scale=v end
    elseif f.Name=="UI Transparency" then
        f.Handler=function(v) Config.Transparency=v; Main.BackgroundTransparency=v end
    elseif f.Name=="Blur Strength" then
        f.Handler=function(v) Config.Blur=v; if Config.Open then Blur.Size=v end end
    elseif f.Name=="Reset Position" then
        f.Handler=function()
            Main.Position=UDim2.fromScale(.5,.5)
            Config.MenuPosition=Main.Position
        end
    elseif f.Name=="Reset UI Size" then
        f.Handler=function()
            Config.UIScale=1
            Scale.Scale=1
        end
    elseif f.Name=="Glow Toggle" then
        f.Handler=function(v) Config.Glow=v; setGlow(v) end
    elseif f.Name=="Rainbow Toggle" then
        f.Handler=function(v) Config.Rainbow=v end
    elseif f.Name=="Reset Effects" then
        f.Handler=function()
            setGlow(false)
            setNightVision(false)
            setCrosshair(false)
            Config.Glow=false
            Config.Rainbow=false
        end
    elseif f.Name=="Reset Camera" then
        f.Handler=function()
            Camera.CameraType=Enum.CameraType.Custom
            Camera.FieldOfView=70
        end
    elseif f.Name=="Reset Gravity" then
        f.Handler=function() workspace.Gravity=Config.Gravity end
    elseif f.Name=="Low Gravity" then
        f.Handler=function() workspace.Gravity=80 end
    elseif f.Name=="Normal Gravity" then
        f.Handler=function() workspace.Gravity=196.2 end
    elseif f.Name=="High Gravity" then
        f.Handler=function() workspace.Gravity=350 end
    elseif f.Name=="Day Time" then
        f.Handler=function() Lighting.ClockTime=14 end
    elseif f.Name=="Night Time" then
        f.Handler=function() Lighting.ClockTime=0 end
    elseif f.Name=="Rejoin Current Server" then
        f.Handler=function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LP)
        end
    elseif f.Name=="Join New Server" then
        f.Handler=function()
            TeleportService:Teleport(game.PlaceId,LP)
        end
    elseif f.Name=="Crosshair" then
        f.Handler=function(v) Config.Crosshair=v; setCrosshair(v) end
    elseif f.Name=="UI Glow" then
        f.Handler=function(v) Config.Glow=v; setGlow(v) end
    elseif f.Name=="Night Vision" then
        f.Handler=function(v) setNightVision(v) end
    elseif f.Name=="Rainbow UI" then
        f.Handler=function(v) Config.Rainbow=v end
    elseif f.Name=="Fast Animation" then
        f.Handler=function() Config.AnimationSpeed=1.8 end
    elseif f.Name=="Smooth Animation" then
        f.Handler=function() Config.AnimationSpeed=1 end
    end
end

--// REAL FLY CONTROLLER FOR AN EXPERIENCE YOU OWN/CONTROL
local FlyBV=nil
local FlyBG=nil
local FlyConn=nil

local function stopFly()
    if FlyConn then FlyConn:Disconnect(); FlyConn=nil end
    if FlyBV then FlyBV:Destroy(); FlyBV=nil end
    if FlyBG then FlyBG:Destroy(); FlyBG=nil end
end

local function startFly()
    stopFly()

    local root=getRoot()
    if not root then
        notify("Character not ready")
        return
    end

    FlyBV=Instance.new("BodyVelocity")
    FlyBV.MaxForce=Vector3.new(1e6,1e6,1e6)
    FlyBV.Velocity=Vector3.zero
    FlyBV.Parent=root

    FlyBG=Instance.new("BodyGyro")
    FlyBG.MaxTorque=Vector3.new(1e6,1e6,1e6)
    FlyBG.P=90000
    FlyBG.CFrame=root.CFrame
    FlyBG.Parent=root

    FlyConn=RunService.RenderStepped:Connect(function()
        if not Config.Fly or not root.Parent then
            stopFly()
            return
        end

        local hum=getHum()
        local move=hum and hum.MoveDirection or Vector3.zero
        local vertical=0

        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            vertical=Config.FlyVertical
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            vertical=-Config.FlyVertical
        end

        FlyBV.Velocity=move*Config.FlySpeed+Vector3.new(0,vertical,0)

        if Camera then
            FlyBG.CFrame=CFrame.lookAt(root.Position,root.Position+Camera.CFrame.LookVector)
        end
    end)
end

for _,f in ipairs(Features) do
    if f.Name=="Fly Controller" and f.Tab=="Fly & Glide" then
        f.Handler=function(v)
            Config.Fly=v
            if v then startFly() else stopFly() end
        end
    elseif f.Name=="Fly Speed" and f.Tab=="Fly & Glide" then
        f.Kind="Slider"
        f.Default=80
        f.Min=0
        f.Max=500
        f.Step=1
        f.Handler=function(v) Config.FlySpeed=v end
    elseif f.Name=="Fly Vertical" and f.Tab=="Fly & Glide" then
        f.Kind="Slider"
        f.Default=60
        f.Min=0
        f.Max=500
        f.Step=1
        f.Handler=function(v) Config.FlyVertical=v end
    elseif f.Name=="Glide Speed" and f.Tab=="Fly & Glide" then
        f.Kind="Slider"
        f.Default=35
        f.Min=0
        f.Max=200
        f.Step=1
        f.Handler=function(v) State[f.Name]=v end
    end
end

for _,f in ipairs(Features) do
    State[f.Name]=f.Default
end

--// SEARCH
local function normalize(text)
    text=tostring(text or ""):lower()
    text=text:gsub("[%p]"," ")
    text=text:gsub("%s+"," ")
    return text:match("^%s*(.-)%s*$")
end

local function searchScore(feature,query)
    if query=="" then return 0 end

    local name=normalize(feature.Name)
    local desc=normalize(feature.Description)
    local best=0

    if name==query then
        best=1000
    elseif name:sub(1,#query)==query then
        best=900
    elseif name:find(query,1,true) then
        best=700
    end

    for _,keyword in ipairs(feature.Keywords or {}) do
        local k=normalize(keyword)
        if k==query then
            best=math.max(best,850)
        elseif k:sub(1,#query)==query then
            best=math.max(best,800)
        elseif k:find(query,1,true) then
            best=math.max(best,650)
        end
    end

    if desc:find(query,1,true) then
        best=math.max(best,400)
    end

    local matched=0
    for token in query:gmatch("%S+") do
        if name:find(token,1,true) or desc:find(token,1,true) then
            matched+=1
        end
    end

    if matched>0 then
        best=math.max(best,300+matched*50)
    end

    return best
end

--// UI BUILDERS
local function clearChildren(parent)
    for _,child in ipairs(parent:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
end

local function makeToggle(parent,feature)
    local button=Instance.new("TextButton")
    button.Size=UDim2.fromOffset(58,34)
    button.BackgroundColor3=Theme.Card
    button.BackgroundTransparency=.08
    button.Text=""
    button.AutoButtonColor=false
    button.Parent=parent
    corner(button,17)

    local dot=Instance.new("Frame")
    dot.Size=UDim2.fromOffset(26,26)
    dot.AnchorPoint=Vector2.new(.5,.5)
    dot.Position=UDim2.new(0,18,.5,0)
    dot.BackgroundColor3=Theme.Sub
    dot.Parent=button
    corner(dot,13)

    local function refresh()
        local on=State[feature.Name] and true or false
        button.BackgroundColor3=on and Theme.Accent or Theme.Card
        dot.Position=UDim2.new(0,on and 40 or 18,.5,0)
        dot.BackgroundColor3=on and Theme.Accent2 or Theme.Sub
    end

    refresh()

    button.Activated:Connect(function()
        local nextValue=not (State[feature.Name] and true or false)
        State[feature.Name]=nextValue
        refresh()
        if feature.Handler then feature.Handler(nextValue) end
    end)

    return button
end

local function makeSlider(parent,feature)
    local wrap=Instance.new("Frame")
    wrap.Size=UDim2.fromOffset(190,42)
    wrap.BackgroundTransparency=1
    wrap.Parent=parent

    local value=State[feature.Name]
    if value==nil then
        value=feature.Default or feature.Min or 0
        State[feature.Name]=value
    end

    local valueText=Instance.new("TextLabel")
    valueText.Size=UDim2.new(0,54,0,18)
    valueText.Position=UDim2.new(1,-54,0,0)
    valueText.BackgroundTransparency=1
    valueText.Text=tostring(value)
    valueText.TextColor3=Theme.Accent2
    valueText.TextSize=11
    valueText.Font=Enum.Font.GothamBold
    valueText.Parent=wrap

    local track=Instance.new("Frame")
    track.Size=UDim2.new(1,-62,0,6)
    track.Position=UDim2.new(0,0,0,7)
    track.BackgroundColor3=Theme.Card
    track.BackgroundTransparency=.1
    track.Parent=wrap
    corner(track,3)

    local fill=Instance.new("Frame")
    fill.BackgroundColor3=Theme.Accent
    fill.BorderSizePixel=0
    fill.Parent=track
    corner(fill,3)

    local knob=Instance.new("Frame")
    knob.Size=UDim2.fromOffset(14,14)
    knob.AnchorPoint=Vector2.new(.5,.5)
    knob.BackgroundColor3=Theme.Accent2
    knob.Parent=track
    corner(knob,7)

    local minValue=feature.Min or 0
    local maxValue=feature.Max or 100
    local step=feature.Step or 1
    local dragging=false

    local function setFromX(x)
        local startX=track.AbsolutePosition.X
        local width=track.AbsoluteSize.X
        local alpha=math.clamp((x-startX)/math.max(width,1),0,1)
        local v=minValue+(maxValue-minValue)*alpha
        v=math.floor(v/step+.5)*step

        State[feature.Name]=v
        valueText.Text=tostring(v)

        fill.Size=UDim2.new(alpha,0,1,0)
        knob.Position=UDim2.new(alpha,0,.5,0)

        if feature.Handler then
            feature.Handler(v)
        end
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1
            or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true
            setFromX(input.Position.X)
        end
    end)

    track.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1
            or input.UserInputType==Enum.UserInputType.Touch then
            dragging=false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType==Enum.UserInputType.MouseMovement
            or input.UserInputType==Enum.UserInputType.Touch
        ) then
            setFromX(input.Position.X)
        end
    end)

    local alpha=math.clamp(
        (value-minValue)/math.max(maxValue-minValue,.0001),
        0,1
    )
    fill.Size=UDim2.new(alpha,0,1,0)
    knob.Position=UDim2.new(alpha,0,.5,0)

    return wrap
end

local function makeCard(parent,feature,order)
    local card=Instance.new("Frame")
    card.Size=UDim2.new(1,-4,0,82)
    card.BackgroundColor3=Theme.Card
    card.BackgroundTransparency=.36
    card.BorderSizePixel=0
    card.LayoutOrder=order
    card.Parent=parent
    corner(card,16)
    addStroke(card,.62)

    local icon=makeLabel(card,feature.Icon or "◆",20,true)
    icon.Position=UDim2.new(0,14,0,14)
    icon.Size=UDim2.fromOffset(38,30)
    icon.TextXAlignment=Enum.TextXAlignment.Center

    local name=makeLabel(card,feature.Name,14,true)
    name.Position=UDim2.new(0,66,0,12)
    name.Size=UDim2.new(1,-285,0,22)

    local desc=makeLabel(card,feature.Description,10,false)
    desc.Position=UDim2.new(0,67,0,38)
    desc.Size=UDim2.new(1,-285,0,30)
    desc.TextColor3=Theme.Sub
    desc.TextWrapped=true

    if feature.Kind=="Toggle" then
        local control=makeToggle(card,feature)
        control.Position=UDim2.new(1,-92,.5,-17)
    elseif feature.Kind=="Slider" then
        local control=makeSlider(card,feature)
        control.Position=UDim2.new(1,-200,.5,-21)
    else
        local button=Instance.new("TextButton")
        button.Size=UDim2.fromOffset(76,38)
        button.Position=UDim2.new(1,-92,.5,-19)
        button.BackgroundColor3=Theme.Panel
        button.BackgroundTransparency=.12
        button.Text="GO"
        button.TextColor3=Theme.Accent2
        button.TextSize=11
        button.Font=Enum.Font.GothamBold
        button.AutoButtonColor=false
        button.Parent=card
        corner(button,13)
        addStroke(button,.65)

        button.Activated:Connect(function()
            if feature.Handler then feature.Handler() end
            tween(button,.08,{Size=UDim2.fromOffset(70,34)})
            task.delay(.08,function()
                if button.Parent then
                    tween(button,.12,{Size=UDim2.fromOffset(76,38)})
                end
            end)
        end)
    end

    return card
end

local function renderTab(tabName)
    for _,page in pairs(PagesByTab) do
        page.Visible=false
    end

    local page=PagesByTab[tabName]

    if not page then
        page=Instance.new("ScrollingFrame")
        page.Name="Page_"..tabName
        page.Size=UDim2.fromScale(1,1)
        page.BackgroundTransparency=1
        page.BorderSizePixel=0
        page.ScrollBarThickness=2
        page.AutomaticCanvasSize=Enum.AutomaticSize.Y
        page.CanvasSize=UDim2.new()
        page.Parent=PageArea

        local padding=Instance.new("UIPadding")
        padding.PaddingBottom=UDim.new(0,10)
        padding.Parent=page

        local layout=Instance.new("UIListLayout")
        layout.Padding=UDim.new(0,9)
        layout.SortOrder=Enum.SortOrder.LayoutOrder
        layout.Parent=page

        PagesByTab[tabName]=page

        local index=0
        for _,feature in ipairs(Features) do
            if feature.Tab==tabName then
                index+=1
                makeCard(page,feature,index)
            end
        end
    end

    page.Visible=true
    CurrentTab=tabName
end

local function makeSearchPage()
    if SearchPage then SearchPage:Destroy() end

    SearchPage=Instance.new("ScrollingFrame")
    SearchPage.Size=UDim2.fromScale(1,1)
    SearchPage.BackgroundTransparency=1
    SearchPage.BorderSizePixel=0
    SearchPage.ScrollBarThickness=2
    SearchPage.AutomaticCanvasSize=Enum.AutomaticSize.Y
    SearchPage.CanvasSize=UDim2.new()
    SearchPage.Parent=PageArea

    local layout=Instance.new("UIListLayout")
    layout.Padding=UDim.new(0,9)
    layout.SortOrder=Enum.SortOrder.LayoutOrder
    layout.Parent=SearchPage

    local query=normalize(Search.Text)
    local results={}

    for _,feature in ipairs(Features) do
        local score=searchScore(feature,query)
        if query=="" or score>0 then
            results[#results+1]={Feature=feature,Score=score}
        end
    end

    table.sort(results,function(a,b)
        if a.Score==b.Score then
            return a.Feature.Name<b.Feature.Name
        end
        return a.Score>b.Score
    end)

    for i,result in ipairs(results) do
        makeCard(SearchPage,result.Feature,i)
    end
end

--// TAB CAROUSEL: CENTER TAB IS BIGGEST
local function refreshCarousel()
    local centerY=Tabs.AbsolutePosition.Y+Tabs.AbsoluteSize.Y/2
    local half=math.max(Tabs.AbsoluteSize.Y/2,1)

    for _,button in ipairs(TabButtons) do
        local y=button.AbsolutePosition.Y+button.AbsoluteSize.Y/2
        local distance=math.abs(y-centerY)
        local normalized=math.clamp(distance/half,0,1)

        local scale=1-.45*normalized
        local height=math.max(28,math.floor(48*scale))

        button.Size=UDim2.new(1,-14,0,height)
        button.TextTransparency=.12+.65*normalized

        local s=button:FindFirstChildOfClass("UIStroke")
        if s then
            s.Transparency=.55+.4*normalized
        end

        button.BackgroundTransparency=.25+.45*normalized
    end
end

for i,data in ipairs(TabData) do
    local icon,name=table.unpack(data)

    local button=Instance.new("TextButton")
    button.Size=UDim2.new(1,-14,0,48)
    button.BackgroundColor3=Theme.Card
    button.BackgroundTransparency=.25
    button.Text=icon.."  "..name
    button.TextColor3=Theme.Text
    button.TextSize=12
    button.Font=Enum.Font.GothamBold
    button.AutoButtonColor=false
    button.LayoutOrder=i
    button.Parent=TabContent
    corner(button,14)
    addStroke(button,.55)

    button.Activated:Connect(function()
        renderTab(name)

        local target=(i-1)*55
        tween(
            Tabs,.30,
            {CanvasPosition=Vector2.new(
                0,
                math.max(0,target-Tabs.AbsoluteSize.Y/2+28)
            )}
        )
    end)

    TabButtons[#TabButtons+1]=button
end

renderTab("Combat")

Tabs:GetPropertyChangedSignal("CanvasPosition"):Connect(refreshCarousel)
Tabs:GetPropertyChangedSignal("AbsoluteSize"):Connect(refreshCarousel)

Search:GetPropertyChangedSignal("Text"):Connect(function()
    local query=normalize(Search.Text)

    if query~="" then
        for _,page in pairs(PagesByTab) do page.Visible=false end
        makeSearchPage()
        SearchPage.Visible=true
    else
        if SearchPage then SearchPage.Visible=false end
        renderTab(CurrentTab)
    end
end)

--// PREMIUM LIGHTNING REVEAL
local function lightning()
    for i=1,8 do
        local line=Instance.new("Frame")
        line.BorderSizePixel=0
        line.BackgroundColor3=Theme.Accent2
        line.ZIndex=999

        if i%2==0 then
            line.Size=UDim2.new(0,2,0,math.random(20,120))
            line.Position=UDim2.new(math.random(),0,0,math.random(10,120))
        else
            line.Size=UDim2.new(0,math.random(30,180),0,2)
            line.Position=UDim2.new(math.random(),0,math.random(),0)
        end

        line.Parent=FX
        tween(line,.12,{BackgroundTransparency=1})

        task.delay(.13,function()
            if line.Parent then line:Destroy() end
        end)
    end
end

local function getMenuSize()
    local vp=workspace.CurrentCamera.ViewportSize

    local width=math.min(
        900,
        math.max(540,vp.X*.72)
    )

    local height=math.min(
        620,
        math.max(400,vp.Y*.78)
    )

    if vp.X<720 then
        width=math.min(680,math.max(330,vp.X-18))
        height=math.min(650,math.max(360,vp.Y-40))
    end

    return UDim2.fromOffset(width,height)
end

local function openMenu()
    if Config.Open then return end

    Config.Open=true
    Main.Visible=true
    Main.Position=Config.MenuPosition
    Main.Size=UDim2.fromOffset(20,20)
    Blur.Size=0

    lightning()
    task.delay(.07,lightning)
    task.delay(.14,lightning)

    tween(Blur,.35,{Size=Config.Blur})

    tween(
        Main,.45,
        {Size=getMenuSize()},
        Enum.EasingStyle.Back
    )
end

local function closeMenu()
    if not Config.Open then return end

    Config.Open=false
    Config.MenuPosition=Main.Position

    tween(Blur,.25,{Size=0})

    local t=tween(
        Main,.30,
        {Size=UDim2.fromOffset(20,20)},
        Enum.EasingStyle.Back,
        Enum.EasingDirection.In
    )

    t.Completed:Connect(function()
        if not Config.Open then
            Main.Visible=false
        end
    end)
end

OpenButton.Activated:Connect(function()
    if Config.Open then
        closeMenu()
    else
        openMenu()
    end
end)

Close.Activated:Connect(closeMenu)

--// DRAG SUPPORT: MENU + OPEN BUTTON
local function makeDraggable(object,onMoved)
    local dragging=false
    local startPosition=nil
    local startObjectPosition=nil

    object.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1
            or input.UserInputType==Enum.UserInputType.Touch then

            dragging=true
            startPosition=input.Position
            startObjectPosition=object.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end

        if input.UserInputType~=Enum.UserInputType.MouseMovement
            and input.UserInputType~=Enum.UserInputType.Touch then
            return
        end

        local delta=input.Position-startPosition

        object.Position=UDim2.new(
            startObjectPosition.X.Scale,
            startObjectPosition.X.Offset+delta.X,
            startObjectPosition.Y.Scale,
            startObjectPosition.Y.Offset+delta.Y
        )

        if onMoved then
            onMoved(object.Position)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1
            or input.UserInputType==Enum.UserInputType.Touch then
            dragging=false
        end
    end)
end

makeDraggable(Top,function(position)
    Main.Position=position
    Config.MenuPosition=position
end)

makeDraggable(OpenButton,function(position)
    Config.ButtonPosition=position
end)

--// DOUBLE JUMP
UserInputService.JumpRequest:Connect(function()
    if not Config.DoubleJump then return end

    local hum=getHum()
    if not hum then return end

    if hum:GetState()==Enum.HumanoidStateType.Freefall then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--// CHARACTER REAPPLY
LP.CharacterAdded:Connect(function()
    task.wait(.4)

    local hum=getHum()
    if hum then
        hum.AutoRotate=Config.AutoRotate
        hum.WalkSpeed=Config.WalkSpeed
        hum.UseJumpPower=true
        hum.JumpPower=Config.JumpPower
    end

    if Config.Fly then
        task.wait(.2)
        startFly()
    end
end)

--// MOBILE LAYOUT
local function updateLayout()
    local vp=workspace.CurrentCamera.ViewportSize

    if vp.X<720 then
        Tabs.Size=UDim2.new(0,126,1,0)
        Pages.Position=UDim2.new(0,136,0,0)
        Pages.Size=UDim2.new(1,-136,1,0)

        Title.TextSize=18
        Subtitle.TextSize=9
    else
        Tabs.Size=UDim2.new(0,174,1,0)
        Pages.Position=UDim2.new(0,184,0,0)
        Pages.Size=UDim2.new(1,-184,1,0)

        Title.TextSize=21
        Subtitle.TextSize=10
    end

    if Config.Open then
        Main.Size=getMenuSize()
    end
end

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateLayout)
updateLayout()

--// THEME ENGINE
local function applyTheme()
    Theme=Themes[Config.Theme] or Themes.Cyber

    Main.BackgroundColor3=Theme.Bg
    Main.BackgroundTransparency=Config.Transparency

    Tabs.BackgroundColor3=Theme.Panel
    Search.BackgroundColor3=Theme.Panel
    OpenButton.BackgroundColor3=Theme.Panel

    Title.TextColor3=Theme.Accent2
    Subtitle.TextColor3=Theme.Sub
    OpenButton.TextColor3=Theme.Text
    HUD.TextColor3=Theme.Accent2

    for _,button in ipairs(TabButtons) do
        button.BackgroundColor3=Theme.Card
        button.TextColor3=Theme.Text
    end

    if Crosshair then
        Crosshair.BackgroundColor3=Theme.Accent
        local h=Crosshair:FindFirstChild("H")
        if h then h.BackgroundColor3=Theme.Accent end
    end
end

for _,feature in ipairs(Features) do
    if feature.Name=="Cyber Theme" then
        feature.Handler=function()
            Config.Theme="Cyber"
            applyTheme()
        end
    elseif feature.Name=="Purple Theme" then
        feature.Handler=function()
            Config.Theme="Purple"
            applyTheme()
        end
    elseif feature.Name=="Ice Theme" then
        feature.Handler=function()
            Config.Theme="Ice"
            applyTheme()
        end
    elseif feature.Name=="Reset Theme" then
        feature.Handler=function()
            Config.Theme="Cyber"
            applyTheme()
        end
    elseif feature.Name=="Reset Effects" then
        feature.Handler=function()
            Config.Glow=false
            Config.Rainbow=false
            setGlow(false)
            setNightVision(false)
            setCrosshair(false)
        end
    end
end

--// RUNTIME HUD / RAINBOW / GLIDE
RunService.RenderStepped:Connect(function(dt)
    Camera=workspace.CurrentCamera

    local root=getRoot()
    local fps=math.floor(1/math.max(dt,.001))
    local lines={}

    if Config.FPS then
        lines[#lines+1]="FPS "..fps
    end

    if root and Config.Coordinates then
        local p=root.Position
        lines[#lines+1]=string.format(
            "XYZ %.0f / %.0f / %.0f",
            p.X,p.Y,p.Z
        )
    end

    if root and Config.Velocity then
        lines[#lines+1]=string.format(
            "VEL %.0f",
            root.AssemblyLinearVelocity.Magnitude
        )
    end

    HUD.Text=table.concat(lines,"  |  ")

    if Config.AutoRotate then
        local hum=getHum()
        if hum then hum.AutoRotate=true end
    end

    if Config.Glide then
        if root then
            local velocity=root.AssemblyLinearVelocity
            if velocity.Y<0 then
                root.AssemblyLinearVelocity=Vector3.new(
                    velocity.X,
                    math.max(velocity.Y,-18),
                    velocity.Z
                )
            end
        end
    end

    if Config.Rainbow then
        local color=Color3.fromHSV(
            (os.clock()*.12)%1,
            .8,
            1
        )

        OpenButton.TextColor3=color
        Title.TextColor3=color
    else
        OpenButton.TextColor3=Theme.Text
        Title.TextColor3=Theme.Accent2
    end

    refreshCarousel()
end)

--// INITIAL STATE
setGlow(Config.Glow)
updateLayout()

notify("ZAKA PURE V6 loaded • "..tostring(#Features).." registered tools")
