--[[
============================================================
                    ZAKA PURE UI V1.0
              VIETNAMESE FEATURE EDITION
============================================================
20 English tabs / Vietnamese feature names.
Built for experiences you own or control.

IMPORTANT:
This file does NOT bypass anti-cheat or implement exploit
features against other games. Security for an experience
must be enforced server-side.

Core goals:
- Real controls instead of placeholder callbacks
- Glass UI + animated cards
- 20-tab vertical carousel
- Mobile touch support
- Vietnamese feature labels
- Search: "Gõ vào đây để tìm kiếm kỹ năng"
- Real sliders/toggles/buttons
- Cleanup-safe local systems
============================================================
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local CollectionService = game:GetService("CollectionService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

--==========================================================
-- CLEANUP
--==========================================================
for _, name in ipairs({"ZAKA_PURE_V1", "ZAKA_PURE_V6"}) do
    local old = PlayerGui:FindFirstChild(name)
    if old then old:Destroy() end
end
for _, name in ipairs({"ZAKA_UI_BLUR_V1", "ZAKA_GLOW_V1", "ZAKA_NIGHT_VISION_V1"}) do
    local old = Lighting:FindFirstChild(name)
    if old then old:Destroy() end
end

--==========================================================
-- CONFIG
--==========================================================
local Config = {
    Theme = "Cyber",
    UITransparency = 0.28,
    UIScale = 1,
    Blur = 10,
    AnimationSpeed = 1,
    CarouselSensitivity = 1,

    FPS = true,
    Coordinates = true,
    Velocity = true,

    WalkSpeed = 16,
    JumpPower = 50,
    Gravity = workspace.Gravity,
    FOV = 70,

    DoubleJump = false,
    Glide = false,
    Fly = false,
    FlySpeed = 80,
    FlyVertical = 60,

    Crosshair = false,
    CrosshairSize = 9,
    FOVCircle = false,
    FOVSize = 150,

    RainbowUI = false,
    UIGlow = true,
    NightVision = false,
    CameraShake = false,

    MenuPosition = UDim2.fromScale(.5,.5),
    OpenButtonPosition = UDim2.new(0,18,.5,-29),
}

local Themes = {
    Cyber = {
        Background=Color3.fromRGB(7,11,20),
        Panel=Color3.fromRGB(12,18,30),
        Card=Color3.fromRGB(18,28,44),
        Accent=Color3.fromRGB(75,185,255),
        Accent2=Color3.fromRGB(150,235,255),
        Text=Color3.fromRGB(240,248,255),
        Sub=Color3.fromRGB(145,165,190),
        Border=Color3.fromRGB(75,175,230),
    },
    Purple = {
        Background=Color3.fromRGB(12,8,20),
        Panel=Color3.fromRGB(22,13,35),
        Card=Color3.fromRGB(34,20,52),
        Accent=Color3.fromRGB(185,110,255),
        Accent2=Color3.fromRGB(230,175,255),
        Text=Color3.fromRGB(248,240,255),
        Sub=Color3.fromRGB(180,150,205),
        Border=Color3.fromRGB(180,110,255),
    },
    Ice = {
        Background=Color3.fromRGB(6,15,22),
        Panel=Color3.fromRGB(10,27,37),
        Card=Color3.fromRGB(16,41,53),
        Accent=Color3.fromRGB(95,220,255),
        Accent2=Color3.fromRGB(190,250,255),
        Text=Color3.fromRGB(240,253,255),
        Sub=Color3.fromRGB(145,190,205),
        Border=Color3.fromRGB(95,205,240),
    },
}
local Theme = Themes[Config.Theme]

--==========================================================
-- LANGUAGE SYSTEM
--==========================================================
local Language = "VI"
local LangLabels = {
    VI = {
        Title="ZAKA PURE", Subtitle="V1.0  •  GLASS  •  20 TABS",
        Search="🔎  Gõ vào đây để tìm kiếm kỹ năng", Execute="THỰC HIỆN",
        Language="VI / EN", LanguageHint="Ngôn ngữ",
        Tabs={Combat="Combat", ["Aim Training"]="Luyện tập ngắm", ["ESP / Debug"]="ESP / Debug", Players="Người chơi", NPC="NPC", Mobs="Mob", Items="Vật phẩm", Weapons="Vũ khí", Locations="Vị trí", Movement="Di chuyển", ["Fly & Glide"]="Bay & Lướt", World="Thế giới", Server="Máy chủ", ["Troll / Admin"]="Troll / Admin", Effects="Hiệu ứng", Camera="Camera", Debug="Debug", Stats="Thống kê", ["Game Tools"]="Công cụ game", Settings="Cài đặt"},
    },
    EN = {
        Title="ZAKA PURE", Subtitle="V1.0  •  GLASS  •  20 TABS",
        Search="🔎  Search features", Execute="EXECUTE",
        Language="EN / VI", LanguageHint="Language",
        Tabs={Combat="Combat", ["Aim Training"]="Aim Training", ["ESP / Debug"]="ESP / Debug", Players="Players", NPC="NPC", Mobs="Mobs", Items="Items", Weapons="Weapons", Locations="Locations", Movement="Movement", ["Fly & Glide"]="Fly & Glide", World="World", Server="Server", ["Troll / Admin"]="Troll / Admin", Effects="Effects", Camera="Camera", Debug="Debug", Stats="Stats", ["Game Tools"]="Game Tools", Settings="Settings"},
    },
}
local ENName = {
    ["Chế độ luyện tập"]="Training Mode",["Bộ đếm combo"]="Combo Counter",["Đèn báo thao tác"]="Action Indicator",["Đồng hồ phản xạ"]="Reaction Timer",
    ["Vòng FOV luyện tập"]="Training FOV Circle",["Kích thước FOV"]="FOV Size",["Tâm ngắm"]="Crosshair",["Kích thước tâm ngắm"]="Crosshair Size",
    ["Đánh dấu mục tiêu luyện tập"]="Mark Training Targets",["Xóa đánh dấu mục tiêu"]="Clear Target Marks",["Khung debug đối tượng"]="Object Debug Box",["Nhãn khoảng cách debug"]="Debug Distance Label",["Kiểm tra Raycast"]="Raycast Test",["Đếm đối tượng Workspace"]="Count Workspace Objects",
    ["Thông tin người chơi"]="Player Info",["Khoảng cách người chơi"]="Player Distance",["Theo dõi tốc độ"]="Speed Monitor",["Theo dõi máu"]="Health Monitor",["Làm mới danh sách"]="Refresh List",
    ["Đánh dấu NPC có tag"]="Mark Tagged NPCs",["Đếm NPC"]="Count NPCs",["Theo dõi máu NPC"]="NPC Health Monitor",["Đánh dấu Mob"]="Mark Mobs",["Đếm Mob"]="Count Mobs",["Đánh dấu Boss"]="Mark Bosses",
    ["Đánh dấu Item"]="Mark Items",["Đếm Item"]="Count Items",["Đánh dấu Rương"]="Mark Chests",["Đánh dấu vũ khí"]="Mark Weapons",["Đếm vũ khí"]="Count Weapons",["Thông tin Tool đang cầm"]="Held Tool Info",
    ["Đánh dấu điểm quan trọng"]="Mark Important Locations",["Đặt mốc vị trí"]="Set Position Marker",["Xóa mốc vị trí"]="Clear Position Marker",
    ["Tốc độ chạy"]="Walk Speed",["Lực nhảy"]="Jump Power",["Tự xoay nhân vật"]="Auto Rotate",["Nhảy hai lần"]="Double Jump",["Lướt nhẹ"]="Glide",["Tăng tốc tạm thời"]="Temporary Boost",
    ["Điều khiển bay"]="Fly Control",["Tốc độ bay"]="Fly Speed",["Tốc độ bay dọc"]="Vertical Fly Speed",["Tốc độ lướt"]="Glide Speed",
    ["Trọng lực"]="Gravity",["Ban ngày"]="Daytime",["Ban đêm"]="Nighttime",["Độ sáng"]="Brightness",["Sương mù"]="Fog",
    ["Thông tin Server"]="Server Info",["Vào lại Server hiện tại"]="Rejoin Current Server",["Vào Server mới"]="New Server",["Hiển thị JobId"]="Show JobId",
    ["Xoay nhân vật"]="Spin Character",["Ngồi"]="Sit",["Ragdoll thử nghiệm"]="Ragdoll Test",["Phóng nhân vật"]="Launch Character",["Confetti"]="Confetti",
    ["Vòng năng lượng"]="Energy Ring",["Nhịp sáng"]="Light Pulse",["Lightning"]="Lightning",["Flash màn hình"]="Screen Flash",
    ["FOV Camera"]="Camera FOV",["Rung camera"]="Camera Shake",["Thu phóng camera"]="Camera Zoom",["Reset Camera"]="Reset Camera",
    ["FPS"]="FPS",["Tọa độ"]="Coordinates",["Vận tốc"]="Velocity",["Kiểm tra Humanoid"]="Humanoid Check",["Đếm Part"]="Count Parts",["Máu"]="Health",["Tốc độ"]="Speed",["FOV"]="FOV",["Kiểm tra hệ thống"]="System Check",["Thông báo thử"]="Test Notification",["Hiệu ứng thử"]="Test Effect",["Refresh UI"]="Refresh UI",
    ["Aim Assist luyện tập"]="Training Aim Assist",["Vùng ghim mục tiêu"]="Target Lock Part",["Độ mạnh ghim"]="Lock Strength",["Khoảng cách mục tiêu"]="Target Range",["Kiểm tra xuyên vật thể"]="Line of Sight Check",
    ["Kích thước UI"]="UI Scale",["Độ trong suốt UI"]="UI Transparency",["Blur"]="Blur",["Animation Speed"]="Animation Speed",["Cyber Theme"]="Cyber Theme",["Purple Theme"]="Purple Theme",["Ice Theme"]="Ice Theme",["Glow UI"]="Glow UI",["Night Vision"]="Night Vision",["Xóa Highlight"]="Clear Highlights",["Xóa hiệu ứng"]="Clear Effects",["Reset nhân vật"]="Reset Character",["Reset chuyển động"]="Reset Movement",["Reset thế giới"]="Reset World",["Anti-Cheat Debug"]="Anti-Cheat Debug",["Ngưỡng tốc độ"]="Speed Threshold",["Ngưỡng dịch chuyển"]="Teleport Threshold",["Reset cảnh báo Security"]="Reset Security Warnings",
}
local function featureText(f)
    return Language=="EN" and (ENName[f.Name] or f.Name) or f.Name
end
local function featureDesc(f)
    if Language=="VI" then return f.Description end
    return f.ENDescription or "Configure this feature for your experience."
end
local function tabText(tab)
    return LangLabels[Language].Tabs[tab] or tab
end
local function uiText(key)
    return LangLabels[Language][key] or key
end

--==========================================================
-- STATE / REGISTRY
--==========================================================
local Features = {}
local State = {}
local Connections = {}
local notify
local Runtime = {
    Crosshair=nil,
    FOVCircle=nil,
    FOVStroke=nil,
    FOVCenter=nil,
    FlyBV=nil,
    FlyBG=nil,
    FlyConnection=nil,
    DoubleJumpConnection=nil,
    CharacterConnection=nil,
    CameraConnection=nil,
    Combo=0,
    LastClick=0,
    Cards={},
    TabButtons={},
    Pages={},
    CurrentTab="Combat",
}

local function connect(signal, fn)
    local c=signal:Connect(fn)
    table.insert(Connections,c)
    return c
end

local function disconnect(c)
    if c and c.Connected then c:Disconnect() end
end

local function getCharacter()
    return LocalPlayer.Character
end

local function getHumanoid()
    local c=getCharacter()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local c=getCharacter()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function tween(obj,time,props,style,direction)
    local info=TweenInfo.new(
        time/math.max(Config.AnimationSpeed,.05),
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )
    local t=TweenService:Create(obj,info,props)
    t:Play()
    return t
end

local function corner(obj,r)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r)
    c.Parent=obj
    return c
end

local function stroke(obj,trans)
    local s=Instance.new("UIStroke")
    s.Color=Theme.Border
    s.Thickness=1
    s.Transparency=trans or .5
    s.Parent=obj
    return s
end

local function label(parent,text,size,bold)
    local x=Instance.new("TextLabel")
    x.BackgroundTransparency=1
    x.Text=text
    x.TextColor3=Theme.Text
    x.TextSize=size
    x.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
    x.TextXAlignment=Enum.TextXAlignment.Left
    x.Parent=parent
    return x
end

--==========================================================
-- GUI
--==========================================================
local Gui=Instance.new("ScreenGui")
Gui.Name="ZAKA_PURE_V1"
Gui.ResetOnSpawn=false
Gui.IgnoreGuiInset=true
Gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
Gui.Parent=PlayerGui

local Blur=Instance.new("BlurEffect")
Blur.Name="ZAKA_UI_BLUR_V1"
Blur.Size=0
Blur.Parent=Lighting

local FX=Instance.new("Frame")
FX.Name="FX"
FX.Size=UDim2.fromScale(1,1)
FX.BackgroundTransparency=1
FX.ZIndex=900
FX.Parent=Gui

local OpenButton=Instance.new("TextButton")
OpenButton.Name="OpenButton"
OpenButton.Size=UDim2.fromOffset(58,58)
OpenButton.Position=Config.OpenButtonPosition
OpenButton.BackgroundColor3=Theme.Panel
OpenButton.BackgroundTransparency=.10
OpenButton.Text="Z"
OpenButton.TextColor3=Theme.Text
OpenButton.TextSize=25
OpenButton.Font=Enum.Font.GothamBlack
OpenButton.AutoButtonColor=false
OpenButton.ZIndex=80
OpenButton.Parent=Gui
corner(OpenButton,18)
stroke(OpenButton,.12)

local Main=Instance.new("Frame")
Main.Name="Main"
Main.AnchorPoint=Vector2.new(.5,.5)
Main.Position=Config.MenuPosition
Main.Size=UDim2.fromOffset(0,0)
Main.BackgroundColor3=Theme.Background
Main.BackgroundTransparency=Config.UITransparency
Main.Visible=false
Main.ClipsDescendants=false
Main.ZIndex=20
Main.Parent=Gui
corner(Main,24)
stroke(Main,.10)

local UIScale=Instance.new("UIScale")
UIScale.Scale=Config.UIScale
UIScale.Parent=Main

local Top=Instance.new("Frame")
Top.Size=UDim2.new(1,0,0,72)
Top.BackgroundTransparency=1
Top.Parent=Main

local Title=label(Top,"ZAKA PURE",21,true)
Title.Position=UDim2.new(0,22,0,10)
Title.Size=UDim2.fromOffset(300,28)
Title.TextColor3=Theme.Accent2

local Subtitle=label(Top,uiText("Subtitle"),10,false)
Subtitle.Position=UDim2.new(0,23,0,40)
Subtitle.Size=UDim2.fromOffset(350,18)
Subtitle.TextColor3=Theme.Sub

local Close=Instance.new("TextButton")
Close.Size=UDim2.fromOffset(40,40)
Close.Position=UDim2.new(1,-56,0,16)
Close.BackgroundColor3=Theme.Card
Close.BackgroundTransparency=.22
Close.Text="×"
Close.TextColor3=Theme.Text
    if LangBtn then LangBtn.BackgroundColor3=Theme.Card; LangBtn.TextColor3=Theme.Accent2 end
Close.TextSize=24
Close.Font=Enum.Font.GothamBold
Close.AutoButtonColor=false
Close.Parent=Top
corner(Close,13)

local RefreshLanguage
local LangBtn=Instance.new("TextButton")
LangBtn.Size=UDim2.fromOffset(70,30)
LangBtn.Position=UDim2.new(1,-135,0,21)
LangBtn.BackgroundColor3=Theme.Card
LangBtn.BackgroundTransparency=.16
LangBtn.Text=uiText("Language")
LangBtn.TextColor3=Theme.Accent2
LangBtn.TextSize=10
LangBtn.Font=Enum.Font.GothamBold
LangBtn.AutoButtonColor=false
LangBtn.Parent=Top
corner(LangBtn,10)
stroke(LangBtn,.55)
LangBtn.Activated:Connect(function()
    Language = Language=="VI" and "EN" or "VI"
    if RefreshLanguage then RefreshLanguage() end
end)

local Body=Instance.new("Frame")
Body.Position=UDim2.new(0,10,0,72)
Body.Size=UDim2.new(1,-20,1,-82)
Body.BackgroundTransparency=1
Body.Parent=Main

local Tabs=Instance.new("ScrollingFrame")
Tabs.Name="Tabs"
Tabs.Size=UDim2.new(0,176,1,0)
Tabs.BackgroundColor3=Theme.Panel
Tabs.BackgroundTransparency=.30
Tabs.BorderSizePixel=0
Tabs.ScrollBarThickness=0
Tabs.ScrollingDirection=Enum.ScrollingDirection.Y
Tabs.AutomaticCanvasSize=Enum.AutomaticSize.Y
Tabs.CanvasSize=UDim2.new()
Tabs.Parent=Body
corner(Tabs,18)
stroke(Tabs,.55)

local TabContent=Instance.new("Frame")
TabContent.Size=UDim2.new(1,-4,0,0)
TabContent.BackgroundTransparency=1
TabContent.Parent=Tabs

local TabLayout=Instance.new("UIListLayout")
TabLayout.Padding=UDim.new(0,7)
TabLayout.SortOrder=Enum.SortOrder.LayoutOrder
TabLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
TabLayout.Parent=TabContent

local Pages=Instance.new("Frame")
Pages.Position=UDim2.new(0,186,0,0)
Pages.Size=UDim2.new(1,-186,1,0)
Pages.BackgroundTransparency=1
Pages.Parent=Body

local Search=Instance.new("TextBox")
Search.Size=UDim2.new(1,-6,0,42)
Search.Position=UDim2.new(0,3,0,0)
Search.BackgroundColor3=Theme.Panel
Search.BackgroundTransparency=.30
Search.BorderSizePixel=0
Search.PlaceholderText=uiText("Search")
Search.PlaceholderColor3=Theme.Sub
Search.Text=""
Search.TextColor3=Theme.Text
Search.TextSize=13
Search.Font=Enum.Font.Gotham
Search.ClearTextOnFocus=false
Search.Parent=Pages
corner(Search,14)
stroke(Search,.62)

local PageArea=Instance.new("Frame")
PageArea.Position=UDim2.new(0,0,0,50)
PageArea.Size=UDim2.new(1,0,1,-50)
PageArea.BackgroundTransparency=1
PageArea.Parent=Pages

local HUD=label(Gui,"",11,false)
HUD.AnchorPoint=Vector2.new(1,0)
HUD.Position=UDim2.new(1,-16,0,16)
HUD.Size=UDim2.fromOffset(420,62)
HUD.TextXAlignment=Enum.TextXAlignment.Right
HUD.TextColor3=Theme.Accent2
HUD.Font=Enum.Font.Code
HUD.ZIndex=70

--==========================================================
-- TABS
--==========================================================
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

--==========================================================
-- FEATURE REGISTRY
--==========================================================
local function add(name,tab,icon,description,kind,default,minValue,maxValue,step,handler,keywords)
    local f={
        Name=name,Tab=tab,Icon=icon or "◆",Description=description,ENDescription="Configure "..(ENName[name] or name)..".",
        Kind=kind or "Toggle",Default=default,Min=minValue,Max=maxValue,
        Step=step or 1,Handler=handler,Keywords=keywords or {}
    }
    table.insert(Features,f)
    State[name]=default
    return f
end

local function setState(name,value)
    State[name]=value
end

--==========================================================
-- VISUAL HELPERS
--==========================================================
local function destroyNamed(parent,name)
    local x=parent and parent:FindFirstChild(name)
    if x then x:Destroy() end
end

local function setGlow(on)
    local b=Lighting:FindFirstChild("ZAKA_GLOW_V1")
    if on then
        if not b then
            b=Instance.new("BloomEffect")
            b.Name="ZAKA_GLOW_V1"
            b.Intensity=.22
            b.Size=18
            b.Threshold=1.1
            b.Parent=Lighting
        end
    elseif b then
        b:Destroy()
    end
end

local function setNightVision(on)
    local c=Lighting:FindFirstChild("ZAKA_NIGHT_VISION_V1")
    if on then
        if not c then
            c=Instance.new("ColorCorrectionEffect")
            c.Name="ZAKA_NIGHT_VISION_V1"
            c.Brightness=.08
            c.Contrast=.25
            c.Saturation=-.05
            c.TintColor=Color3.fromRGB(175,255,195)
            c.Parent=Lighting
        end
    elseif c then
        c:Destroy()
    end
end

local function makeCrosshair(on)
    if Runtime.Crosshair then Runtime.Crosshair:Destroy(); Runtime.Crosshair=nil end
    if not on then return end

    local holder=Instance.new("Frame")
    holder.Name="Crosshair"
    holder.Size=UDim2.fromOffset(Config.CrosshairSize*2+10,Config.CrosshairSize*2+10)
    holder.AnchorPoint=Vector2.new(.5,.5)
    holder.Position=UDim2.fromScale(.5,.5)
    holder.BackgroundTransparency=1
    holder.ZIndex=850
    holder.Parent=Gui

    local h=Instance.new("Frame")
    h.AnchorPoint=Vector2.new(.5,.5)
    h.Position=UDim2.fromScale(.5,.5)
    h.Size=UDim2.fromOffset(Config.CrosshairSize*2+8,2)
    h.BackgroundColor3=Theme.Accent
    h.BorderSizePixel=0
    h.Parent=holder
    corner(h,2)

    local v=Instance.new("Frame")
    v.AnchorPoint=Vector2.new(.5,.5)
    v.Position=UDim2.fromScale(.5,.5)
    v.Size=UDim2.fromOffset(2,Config.CrosshairSize*2+8)
    v.BackgroundColor3=Theme.Accent
    v.BorderSizePixel=0
    v.Parent=holder
    corner(v,2)

    Runtime.Crosshair=holder
end

local function makeFOVCircle(on)
    if Runtime.FOVCircle then Runtime.FOVCircle:Destroy(); Runtime.FOVCircle=nil end
    if not on then return end

    local circle=Instance.new("Frame")
    circle.Name="FOVCircle"
    circle.Size=UDim2.fromOffset(Config.FOVSize*2,Config.FOVSize*2)
    circle.AnchorPoint=Vector2.new(.5,.5)
    circle.Position=UDim2.fromScale(.5,.5)
    circle.BackgroundTransparency=1
    circle.ZIndex=840
    circle.Parent=Gui
    corner(circle,999)

    local s=stroke(circle,.05)
    s.Thickness=1.5
    Runtime.FOVCircle=circle
end

local function pulse(parent)
    local s=Instance.new("Frame")
    s.AnchorPoint=Vector2.new(.5,.5)
    s.Position=UDim2.fromScale(.5,.5)
    s.Size=UDim2.fromOffset(20,20)
    s.BackgroundColor3=Theme.Accent
    s.BackgroundTransparency=.45
    s.BorderSizePixel=0
    s.ZIndex=880
    s.Parent=parent
    corner(s,999)
    tween(s,.55,{Size=UDim2.fromOffset(150,150),BackgroundTransparency=1})
    task.delay(.6,function() if s.Parent then s:Destroy() end end)
end

local function screenFlash()
    local f=Instance.new("Frame")
    f.Size=UDim2.fromScale(1,1)
    f.BackgroundColor3=Theme.Accent2
    f.BackgroundTransparency=.15
    f.ZIndex=999
    f.Parent=FX
    tween(f,.35,{BackgroundTransparency=1})
    Debris:AddItem(f,.4)
end

local function confetti()
    for i=1,35 do
        local p=Instance.new("Frame")
        p.Size=UDim2.fromOffset(5,5)
        p.Position=UDim2.fromScale(math.random(),-0.05)
        p.BackgroundColor3=Color3.fromHSV(math.random(),.8,1)
        p.BorderSizePixel=0
        p.ZIndex=999
        p.Parent=FX
        corner(p,2)
        tween(p,.8,{
            Position=UDim2.new(p.Position.X.Scale,math.random(-180,180),1,math.random(10,220)),
            Rotation=math.random(-180,180),
            BackgroundTransparency=1
        })
        Debris:AddItem(p,1)
    end
end

--==========================================================
-- REAL MOVEMENT
--==========================================================
local function applyCharacterSettings()
    local hum=getHumanoid()
    if not hum then return end
    hum.WalkSpeed=Config.WalkSpeed
    hum.UseJumpPower=true
    hum.JumpPower=Config.JumpPower
end

local function stopFly()
    if Runtime.FlyConnection then
        Runtime.FlyConnection:Disconnect()
        Runtime.FlyConnection=nil
    end
    if Runtime.FlyBV then Runtime.FlyBV:Destroy(); Runtime.FlyBV=nil end
    if Runtime.FlyBG then Runtime.FlyBG:Destroy(); Runtime.FlyBG=nil end
end

local function startFly()
    stopFly()
    local root=getRoot()
    if not root then return end

    local bv=Instance.new("BodyVelocity")
    bv.MaxForce=Vector3.new(1e6,1e6,1e6)
    bv.Velocity=Vector3.zero
    bv.Parent=root

    local bg=Instance.new("BodyGyro")
    bg.MaxTorque=Vector3.new(1e6,1e6,1e6)
    bg.P=90000
    bg.CFrame=root.CFrame
    bg.Parent=root

    Runtime.FlyBV=bv
    Runtime.FlyBG=bg

    Runtime.FlyConnection=RunService.RenderStepped:Connect(function()
        if not Config.Fly or not root.Parent then
            stopFly()
            return
        end

        local hum=getHumanoid()
        local move=hum and hum.MoveDirection or Vector3.zero
        local vertical=0

        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            vertical=Config.FlyVertical
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            vertical=-Config.FlyVertical
        end

        bv.Velocity=move*Config.FlySpeed+Vector3.new(0,vertical,0)
        bg.CFrame=CFrame.lookAt(root.Position,root.Position+Camera.CFrame.LookVector)
    end)
end

--==========================================================
-- GENERIC OWN-EXPERIENCE INSPECTOR
--==========================================================
local Inspector={
    FolderName="ZAKA_Debug",
    HighlightTag="ZAKA_DEBUG",
}

local function getTagged(tag)
    local result={}
    for _,inst in ipairs(CollectionService:GetTagged(tag)) do
        if inst and inst.Parent then
            table.insert(result,inst)
        end
    end
    return result
end

local function highlightInstance(inst,on,color)
    if not inst then return end
    local name="ZAKA_HL_"..tostring(inst:GetDebugId())
    local old=inst:FindFirstChild(name)
    if on then
        if old then return end
        local h=Instance.new("Highlight")
        h.Name=name
        h.Adornee=inst
        h.FillTransparency=.82
        h.OutlineTransparency=.08
        h.FillColor=color or Theme.Accent
        h.OutlineColor=Theme.Accent2
        h.Parent=inst
    elseif old then
        old:Destroy()
    end
end

local function clearHighlights()
    for _,inst in ipairs(workspace:GetDescendants()) do
        for _,child in ipairs(inst:GetChildren()) do
            if child:IsA("Highlight") and child.Name:sub(1,8)=="ZAKA_HL_" then
                child:Destroy()
            end
        end
    end
end

local function scanFolder(folderName)
    local folder=workspace:FindFirstChild(folderName)
    local count=0
    if folder then
        for _,x in ipairs(folder:GetDescendants()) do
            count+=1
        end
    end
    return count
end

--==========================================================
-- DEV AIM TRAINER / AIM ASSIST (OWN-EXPERIENCE / STUDIO ONLY)
--==========================================================
-- Safe dev implementation: targets are explicitly tagged ZAKA_Target.
-- This does not bypass or evade anti-cheat in third-party experiences.
local AimTrainer = {
    Enabled=false,
    Active=false,
    Mode="Hold",
    Part="Head",
    Strength=85,
    MaxDistance=600,
    FOV=180,
    RequireLineOfSight=true,
    Priority="Screen",
    Prediction=0,
    Sticky=true,
    CurrentTarget=nil,
    Key=Enum.KeyCode.E,
    Deadzone=0,
    LockGrace=0.35,
    AdaptivePrediction=true,
    MaxPrediction=0.65,
    LastTargetTime=0,
}

local function aimPartNames()
    if AimTrainer.Part=="Head" then
        return {"Head"}
    elseif AimTrainer.Part=="Body" then
        return {"UpperTorso","Torso","HumanoidRootPart"}
    else
        return {"LeftFoot","RightFoot","LeftLowerLeg","RightLowerLeg","Left Leg","Right Leg"}
    end
end

local function getAimPoint(model)
    for _,name in ipairs(aimPartNames()) do
        local part=model:FindFirstChild(name)
        if part and part:IsA("BasePart") then return part end
    end
    return nil
end

local function hasLineOfSight(part,model)
    if not AimTrainer.RequireLineOfSight then return true end
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances={LocalPlayer.Character}
    local hit=workspace:Raycast(Camera.CFrame.Position,part.Position-Camera.CFrame.Position,params)
    return (not hit) or hit.Instance:IsDescendantOf(model)
end

local function findTrainingTarget()
    local best,bestScore
    local center=Camera.ViewportSize/2
    local current=AimTrainer.CurrentTarget

    -- Sticky lock: retain the current tagged target while it remains valid.
    if AimTrainer.Sticky and current and current.Parent then
        local model=current:FindFirstAncestorOfClass("Model")
        local hum=model and model:FindFirstChildOfClass("Humanoid")
        local root=model and (model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart)
        local part=model and getAimPoint(model)
        if model and hum and hum.Health>0 and root and part then
            local screen,onScreen=Camera:WorldToViewportPoint(part.Position)
            local pixel=(Vector2.new(screen.X,screen.Y)-center).Magnitude
            local dist=(Camera.CFrame.Position-part.Position).Magnitude
            if onScreen and pixel<=AimTrainer.FOV and dist<=AimTrainer.MaxDistance and hasLineOfSight(part,model) then
                return part
            end
        end
        AimTrainer.CurrentTarget=nil
    end

    for _,obj in ipairs(CollectionService:GetTagged("ZAKA_Target")) do
        if obj and obj.Parent then
            local model=obj:IsA("Model") and obj or obj:FindFirstAncestorOfClass("Model")
            if model and model~=LocalPlayer.Character then
                local hum=model:FindFirstChildOfClass("Humanoid")
                local root=model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
                local part=hum and root and getAimPoint(model)
                if hum and hum.Health>0 and root and part then
                    local dist=(Camera.CFrame.Position-part.Position).Magnitude
                    local screen,onScreen=Camera:WorldToViewportPoint(part.Position)
                    local pixel=(Vector2.new(screen.X,screen.Y)-center).Magnitude
                    if onScreen and dist<=AimTrainer.MaxDistance and pixel<=AimTrainer.FOV and pixel>=AimTrainer.Deadzone and hasLineOfSight(part,model) then
                        local score
                        if AimTrainer.Priority=="Distance" then
                            score=dist
                        elseif AimTrainer.Priority=="Balanced" then
                            score=pixel+(dist*0.15)
                        else
                            score=pixel
                        end
                        if bestScore==nil or score<bestScore then
                            best,bestScore=part,score
                        end
                    end
                end
            end
        end
    end
    AimTrainer.CurrentTarget=best
    return best
end

local function predictedPosition(part)
    local model=part:FindFirstAncestorOfClass("Model")
    local root=model and (model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart)
    local velocity=root and root:IsA("BasePart") and root.AssemblyLinearVelocity or Vector3.zero
    local distance=(Camera.CFrame.Position-part.Position).Magnitude
    local base=math.clamp(distance/1400,0.02,AimTrainer.MaxPrediction)
    local factor=math.clamp(AimTrainer.Prediction,0,2)
    if AimTrainer.AdaptivePrediction then
        local horizontal=Vector3.new(velocity.X,0,velocity.Z).Magnitude
        local adaptive=math.clamp(horizontal/55,0,1)
        factor=math.max(factor,adaptive)
    end
    if factor<=0 then return part.Position end
    return part.Position + velocity * base * factor
end

local AimConn
local function stopAimTrainer()
    if AimConn then AimConn:Disconnect(); AimConn=nil end
    AimTrainer.CurrentTarget=nil
end

local function startAimTrainer()
    stopAimTrainer()
    if not RunService:IsStudio() then
        notify("Aim Assist chỉ hoạt động trong Studio/experience bạn kiểm soát")
        return
    end
    AimConn=RunService.RenderStepped:Connect(function(dt)
        if not AimTrainer.Enabled or not AimTrainer.Active then return end
        local target=findTrainingTarget()
        if not target then return end
        local camPos=Camera.CFrame.Position
        local desired=CFrame.lookAt(camPos,predictedPosition(target))
        local alpha=math.clamp(AimTrainer.Strength/100,0,1)
        local angularBoost=math.clamp((target.Position-Camera.CFrame.Position).Magnitude/250,0,0.28)
        local step=1-math.pow(1-alpha,math.max(dt,1/240)*(12+angularBoost*20))
        Camera.CFrame=Camera.CFrame:Lerp(desired,math.clamp(step,0,0.98))
        AimTrainer.LastTargetTime=os.clock()
    end)
end

-- Mobile aim control: no keyboard key is required on phones/tablets.
local AimTouchButton=Instance.new("TextButton")
AimTouchButton.Name="AimTouchButton"
AimTouchButton.AnchorPoint=Vector2.new(1,1)
AimTouchButton.Position=UDim2.new(1,-18,1,-92)
AimTouchButton.Size=UDim2.fromOffset(118,42)
AimTouchButton.BackgroundColor3=Theme.Panel
AimTouchButton.BackgroundTransparency=.08
AimTouchButton.TextColor3=Theme.Text
AimTouchButton.Font=Enum.Font.GothamBold
AimTouchButton.TextSize=13
AimTouchButton.AutoButtonColor=false
AimTouchButton.ZIndex=90
AimTouchButton.Visible=UserInputService.TouchEnabled
AimTouchButton.Parent=Gui
corner(AimTouchButton,14)
stroke(AimTouchButton,.12)

function updateAimTouchButton()
    local active=AimTrainer.Active
    AimTouchButton.Text=(active and "🎯 AIM • ON" or "🎯 AIM • OFF")
    AimTouchButton.BackgroundColor3=active and Color3.fromRGB(70,8,16) or Theme.Panel
end
updateAimTouchButton()
AimTouchButton.Activated:Connect(function()
    if not AimTrainer.Enabled then
        notify("Hãy bật Aim Assist luyện tập trước")
        return
    end
    AimTrainer.Active=not AimTrainer.Active
    updateAimTouchButton()
end)

-- Keep the mobile control above the menu and reposition it for small screens.
connect(Camera:GetPropertyChangedSignal("ViewportSize"),function()
    AimTouchButton.Position=UDim2.new(1,-18,1,Camera.ViewportSize.Y<600 and -76 or -92)
    AimTouchButton.Visible=UserInputService.TouchEnabled
end)

add("Aim Assist luyện tập","Aim Training","🎯","Aim assist mạnh cho bộ target ZAKA_Target của experience bạn: chọn vùng Head/Body/Legs, FOV, prediction và sticky lock.","Toggle",false,nil,nil,nil,
    function(v)
        AimTrainer.Enabled=v
        AimTrainer.Active=v and AimTrainer.Mode=="Toggle"
        if v then startAimTrainer() else stopAimTrainer() end
        if AimTouchButton then updateAimTouchButton() end
    end,{"aimbot","aim assist","target lock","head","body","legs"})

add("Chế độ Aim","Aim Training","🖱","Chuyển giữa Hold và Toggle cho Aim Assist.","Button",false,nil,nil,nil,
    function()
        AimTrainer.Mode=(AimTrainer.Mode=="Hold" and "Toggle" or "Hold")
        notify("Aim mode: "..AimTrainer.Mode)
    end,{"aim mode","hold","toggle"})

add("Vùng ghim mục tiêu","Aim Training","🎯","Chọn Head, Body hoặc Legs cho mục tiêu luyện tập.","Button",false,nil,nil,nil,
    function()
        local order={"Head","Body","Legs"}
        local idx=1
        for i,v in ipairs(order) do if v==AimTrainer.Part then idx=i break end end
        AimTrainer.Part=order[idx%#order+1]
        AimTrainer.CurrentTarget=nil
        notify("Aim target: "..AimTrainer.Part)
    end,{"head","body","legs","bone","part"})

add("Độ mạnh ghim","Aim Training","⚡","Tăng/giảm độ bám camera vào mục tiêu trong bộ luyện tập Studio.","Input",85,nil,nil,nil,
    function(v) local n=tonumber(v); if n then AimTrainer.Strength=math.clamp(n,0,100) end end,{"strength","smooth","lock"})

add("FOV Aim","Aim Training","⭕","Giới hạn vùng màn hình mà Aim Assist được phép chọn mục tiêu.","Input",180,nil,nil,nil,
    function(v) local n=tonumber(v); if n and n>=1 then AimTrainer.FOV=n end end,{"fov","field of view","screen"})

add("Ưu tiên mục tiêu","Aim Training","📡","Đổi cách chọn mục tiêu: Screen, Distance hoặc Balanced.","Button",false,nil,nil,nil,
    function()
        local order={"Screen","Distance","Balanced"}
        local idx=1
        for i,v in ipairs(order) do if v==AimTrainer.Priority then idx=i break end end
        AimTrainer.Priority=order[idx%#order+1]
        AimTrainer.CurrentTarget=nil
        notify("Target priority: "..AimTrainer.Priority)
    end,{"priority","screen","distance","balanced"})

add("Prediction","Aim Training","🔮","Bù chuyển động mục tiêu dựa trên vận tốc HumanoidRootPart của target.","Input",0,nil,nil,nil,
    function(v) local n=tonumber(v); if n then AimTrainer.Prediction=math.clamp(n,0,2) end end,{"prediction","movement","velocity"})

add("Sticky Lock","Aim Training","🔒","Giữ mục tiêu hiện tại nếu mục tiêu vẫn hợp lệ, giúp aim ổn định hơn.","Toggle",true,nil,nil,nil,
    function(v) AimTrainer.Sticky=v; if not v then AimTrainer.CurrentTarget=nil end end,{"sticky","lock","target"})

add("Vùng chết tâm ngắm","Aim Training","⭕","Khoảng cách tối thiểu từ tâm màn hình trước khi khóa mục tiêu, giúp tránh rung khi mục tiêu đi sát tâm.","Input",0,nil,nil,nil,
    function(v) local n=tonumber(v); if n then AimTrainer.Deadzone=math.max(0,n) end end,{"deadzone","center","aim"})

add("Prediction thích ứng","Aim Training","🧠","Tự tăng prediction theo vận tốc ngang của mục tiêu trong bộ target luyện tập.","Toggle",true,nil,nil,nil,
    function(v) AimTrainer.AdaptivePrediction=v end,{"adaptive","prediction","velocity"})

add("Giới hạn Prediction","Aim Training","📐","Giới hạn thời gian dự đoán để tránh khóa quá xa vị trí hiện tại.","Input",0.65,nil,nil,nil,
    function(v) local n=tonumber(v); if n and n>0 then AimTrainer.MaxPrediction=math.clamp(n,0.02,3) end end,{"prediction","limit","max"})

add("Nút Aim trên điện thoại","Aim Training","📱","Hiển thị nút cảm ứng riêng để bật/tắt aim mà không cần bàn phím.","Toggle",true,nil,nil,nil,
    function(v) AimTouchButton.Visible=v and UserInputService.TouchEnabled; if not v then AimTrainer.Active=false; updateAimTouchButton() end end,{"mobile","touch","button","aim"})

add("Reset khóa mục tiêu","Aim Training","♻","Xóa mục tiêu đang giữ và buộc hệ thống chọn lại mục tiêu hợp lệ.","Button",false,nil,nil,nil,
    function() AimTrainer.CurrentTarget=nil; notify("Đã reset mục tiêu Aim") end,{"reset","target","lock"})

add("Kiểm tra xuyên vật thể","Aim Training","👁","Yêu cầu raycast không bị vật thể che khuất trước khi ghim.","Toggle",true,nil,nil,nil,
    function(v) AimTrainer.RequireLineOfSight=v end,{"raycast","visibility","wall"})

--==========================================================
-- 20 TABS: FUNCTIONAL CORE
--==========================================================
add("Chế độ luyện tập","Combat","⚔","Bật lớp hiển thị luyện tập cục bộ.","Toggle",false,nil,nil,nil,
    function(v) setState("Chế độ luyện tập",v) end,{"training","combat","luyen tap"})

add("Bộ đếm combo","Combat","🔥","Đếm chuỗi lần nhấn chuột trong phiên luyện tập.","Toggle",false,nil,nil,nil,
    function(v) setState("Bộ đếm combo",v) end,{"combo","dem","chuoi"})

add("Đèn báo thao tác","Combat","💥","Hiệu ứng phản hồi khi nhấn chuột.","Toggle",false,nil,nil,nil,
    function(v) setState("Đèn báo thao tác",v) end,{"hit","indicator","bao"})

add("Đồng hồ phản xạ","Combat","⏱","Đo thời gian giữa các lần nhấn.","Toggle",false,nil,nil,nil,
    function(v) setState("Đồng hồ phản xạ",v) end,{"reaction","timer","phan xa"})

add("Vòng FOV luyện tập","Aim Training","🎯","Hiển thị vòng FOV để luyện ngắm.","Toggle",false,nil,nil,nil,
    function(v) makeFOVCircle(v) end,{"fov","vong","aim"})

add("Kích thước FOV","Aim Training","⭕","Điều chỉnh bán kính vòng FOV.","Slider",150,25,500,1,
    function(v) Config.FOVSize=v; if State["Vòng FOV luyện tập"] then makeFOVCircle(true) end end,{"fov","size","kich thuoc"})

add("Tâm ngắm","Aim Training","⊕","Hiển thị tâm ngắm ở giữa màn hình.","Toggle",false,nil,nil,nil,
    function(v) makeCrosshair(v) end,{"crosshair","tam ngam"})

add("Kích thước tâm ngắm","Aim Training","↔","Điều chỉnh kích thước tâm ngắm.","Slider",9,2,40,1,
    function(v) Config.CrosshairSize=v; if State["Tâm ngắm"] then makeCrosshair(true) end end,{"crosshair","size"})

add("Đánh dấu mục tiêu luyện tập","Aim Training","📍","Đánh dấu các đối tượng có tag ZAKA_Target trong experience của bạn.","Button",false,nil,nil,nil,
    function()
        for _,x in ipairs(getTagged("ZAKA_Target")) do highlightInstance(x,true,Theme.Accent) end
    end,{"target","marker","muc tieu"})

add("Xóa đánh dấu mục tiêu","Aim Training","🧹","Xóa các đánh dấu luyện tập.","Button",false,nil,nil,nil,
    function() clearHighlights() end,{"clear","target"})

add("Khung debug đối tượng","ESP / Debug","▣","Hiển thị Highlight cho tag ZAKA_Debug.","Toggle",false,nil,nil,nil,
    function(v)
        if v then
            for _,x in ipairs(getTagged("ZAKA_Debug")) do highlightInstance(x,true,Theme.Accent) end
        else
            clearHighlights()
        end
    end,{"esp","debug","highlight"})

add("Nhãn khoảng cách debug","ESP / Debug","📏","Hiển thị khoảng cách cho đối tượng debug.","Toggle",false,nil,nil,nil,
    function(v) setState("Nhãn khoảng cách debug",v) end,{"distance","label","debug"})

add("Kiểm tra Raycast","ESP / Debug","📡","Bật đường Raycast debug của hệ thống luyện tập.","Toggle",false,nil,nil,nil,
    function(v) setState("Kiểm tra Raycast",v) end,{"raycast","debug"})

add("Đếm đối tượng Workspace","ESP / Debug","🔢","Đếm Model/Part trong Workspace.","Button",false,nil,nil,nil,
    function() setState("Đếm đối tượng Workspace",scanFolder("Workspace")) end,{"workspace","count","object"})

add("Thông tin người chơi","Players","👤","Hiển thị thông tin nhân vật cục bộ.","Toggle",false,nil,nil,nil,
    function(v) setState("Thông tin người chơi",v) end,{"player","info"})

add("Khoảng cách người chơi","Players","📏","Hiển thị khoảng cách từ nhân vật tới vị trí gốc.","Toggle",false,nil,nil,nil,
    function(v) setState("Khoảng cách người chơi",v) end,{"player","distance"})

add("Theo dõi tốc độ","Players","💨","Hiển thị vận tốc nhân vật.","Toggle",false,nil,nil,nil,
    function(v) setState("Theo dõi tốc độ",v) end,{"velocity","speed"})

add("Theo dõi máu","Players","❤️","Hiển thị Health/MaxHealth của Humanoid.","Toggle",false,nil,nil,nil,
    function(v) setState("Theo dõi máu",v) end,{"health","hp"})

add("Làm mới danh sách","Players","🔄","Làm mới dữ liệu hiển thị.","Button",false,nil,nil,nil,
    function() notify("Đã làm mới dữ liệu người chơi") end,{"refresh","player"})

add("Đánh dấu NPC có tag","NPC","👹","Highlight NPC được gắn tag ZAKA_NPC trong experience của bạn.","Toggle",false,nil,nil,nil,
    function(v)
        if v then
            for _,x in ipairs(getTagged("ZAKA_NPC")) do highlightInstance(x,true,Color3.fromRGB(255,170,80)) end
        else clearHighlights() end
    end,{"npc","highlight","esp"})

add("Đếm NPC","NPC","🔢","Đếm các đối tượng có tag ZAKA_NPC.","Button",false,nil,nil,nil,
    function() setState("Đếm NPC",#getTagged("ZAKA_NPC")) end,{"npc","count"})

add("Theo dõi máu NPC","NPC","❤️","Bật dữ liệu máu NPC trong experience của bạn.","Toggle",false,nil,nil,nil,
    function(v) setState("Theo dõi máu NPC",v) end,{"npc","health"})

add("Đánh dấu Mob","Mobs","👾","Highlight Mob có tag ZAKA_Mob.","Toggle",false,nil,nil,nil,
    function(v)
        if v then
            for _,x in ipairs(getTagged("ZAKA_Mob")) do highlightInstance(x,true,Color3.fromRGB(255,80,110)) end
        else clearHighlights() end
    end,{"mob","highlight"})

add("Đếm Mob","Mobs","🔢","Đếm Mob có tag ZAKA_Mob.","Button",false,nil,nil,nil,
    function() setState("Đếm Mob",#getTagged("ZAKA_Mob")) end,{"mob","count"})

add("Đánh dấu Boss","Mobs","👑","Highlight Boss có tag ZAKA_Boss.","Toggle",false,nil,nil,nil,
    function(v)
        if v then
            for _,x in ipairs(getTagged("ZAKA_Boss")) do highlightInstance(x,true,Color3.fromRGB(255,215,70)) end
        else clearHighlights() end
    end,{"boss","highlight"})

add("Đánh dấu Item","Items","💎","Highlight Item có tag ZAKA_Item.","Toggle",false,nil,nil,nil,
    function(v)
        if v then
            for _,x in ipairs(getTagged("ZAKA_Item")) do highlightInstance(x,true,Color3.fromRGB(80,255,170)) end
        else clearHighlights() end
    end,{"item","highlight"})

add("Đếm Item","Items","🔢","Đếm Item có tag ZAKA_Item.","Button",false,nil,nil,nil,
    function() setState("Đếm Item",#getTagged("ZAKA_Item")) end,{"item","count"})

add("Đánh dấu Rương","Items","📦","Highlight Rương có tag ZAKA_Chest.","Toggle",false,nil,nil,nil,
    function(v)
        if v then
            for _,x in ipairs(getTagged("ZAKA_Chest")) do highlightInstance(x,true,Color3.fromRGB(255,190,80)) end
        else clearHighlights() end
    end,{"chest","item"})

add("Đánh dấu vũ khí","Weapons","🗡","Highlight vũ khí có tag ZAKA_Weapon.","Toggle",false,nil,nil,nil,
    function(v)
        if v then
            for _,x in ipairs(getTagged("ZAKA_Weapon")) do highlightInstance(x,true,Color3.fromRGB(255,90,90)) end
        else clearHighlights() end
    end,{"weapon","highlight"})

add("Đếm vũ khí","Weapons","🔢","Đếm vũ khí có tag ZAKA_Weapon.","Button",false,nil,nil,nil,
    function() setState("Đếm vũ khí",#getTagged("ZAKA_Weapon")) end,{"weapon","count"})

add("Thông tin Tool đang cầm","Weapons","🗡","Hiển thị Tool hiện tại của nhân vật.","Toggle",false,nil,nil,nil,
    function(v) setState("Thông tin Tool đang cầm",v) end,{"tool","weapon","equipped"})

add("Đánh dấu điểm quan trọng","Locations","📍","Highlight các điểm có tag ZAKA_Location.","Toggle",false,nil,nil,nil,
    function(v)
        if v then
            for _,x in ipairs(getTagged("ZAKA_Location")) do highlightInstance(x,true,Theme.Accent) end
        else clearHighlights() end
    end,{"location","marker"})

add("Đặt mốc vị trí","Locations","🚩","Lưu vị trí hiện tại trong phiên.","Button",false,nil,nil,nil,
    function()
        local root=getRoot()
        if root then
            Runtime.Bookmark=root.Position
            notify("Đã lưu mốc vị trí")
        end
    end,{"bookmark","save","location"})

add("Xóa mốc vị trí","Locations","🧹","Xóa mốc vị trí hiện tại.","Button",false,nil,nil,nil,
    function() Runtime.Bookmark=nil; notify("Đã xóa mốc") end,{"bookmark","clear"})

add("Tốc độ chạy","Movement","🏃","Điều chỉnh WalkSpeed cục bộ. Nhập số tùy ý, không đặt trần trong UI.","Input",16,nil,nil,nil,
    function(v) local n=tonumber(v); if n then Config.WalkSpeed=n; applyCharacterSettings() end end,{"walk","speed","unlimited"})

add("Lực nhảy","Movement","⬆","Điều chỉnh JumpPower cục bộ.","Slider",50,0,500,1,
    function(v) Config.JumpPower=v; applyCharacterSettings() end,{"jump","power"})

add("Tự xoay nhân vật","Movement","🔄","Bật/tắt Humanoid AutoRotate.","Toggle",true,nil,nil,nil,
    function(v) local h=getHumanoid(); if h then h.AutoRotate=v end end,{"rotate"})

add("Nhảy hai lần","Movement","🦘","Cho phép cú nhảy thứ hai khi đang rơi.","Toggle",false,nil,nil,nil,
    function(v) Config.DoubleJump=v end,{"double","jump"})

add("Lướt nhẹ","Movement","🪽","Giảm tốc độ rơi khi đang rơi.","Toggle",false,nil,nil,nil,
    function(v) Config.Glide=v end,{"glide","fall"})

add("Tăng tốc tạm thời","Movement","🚀","Tăng tốc chạy trong 5 giây.","Button",false,nil,nil,nil,
    function()
        local h=getHumanoid()
        if not h then return end
        local old=h.WalkSpeed
        h.WalkSpeed=math.min(500,old*2)
        task.delay(5,function() if h.Parent then h.WalkSpeed=Config.WalkSpeed end end)
    end,{"boost","speed"})

add("Điều khiển bay","Fly & Glide","🪽","Bộ điều khiển bay cục bộ cho experience bạn kiểm soát.","Toggle",false,nil,nil,nil,
    function(v)
        Config.Fly=v
        if v then startFly() else stopFly() end
    end,{"fly","flight"})

add("Tốc độ bay","Fly & Glide","⚡","Nhập tốc độ bay tùy ý, không đặt trần trong UI.","Input",80,nil,nil,nil,
    function(v) local n=tonumber(v); if n then Config.FlySpeed=n end end,{"fly","speed","unlimited"})

add("Tốc độ bay dọc","Fly & Glide","↕","Nhập tốc độ lên/xuống tùy ý, không đặt trần trong UI.","Input",60,nil,nil,nil,
    function(v) local n=tonumber(v); if n then Config.FlyVertical=n end end,{"fly","vertical","unlimited"})

add("Tốc độ lướt","Fly & Glide","🌬","Điều chỉnh tốc độ rơi khi lướt.","Slider",18,1,100,1,
    function(v) Runtime.GlideFallSpeed=v end,{"glide","speed"})

add("Trọng lực","World","🌎","Điều chỉnh Gravity của Workspace.","Slider",workspace.Gravity,0,500,1,
    function(v) workspace.Gravity=v end,{"gravity"})

add("Ban ngày","World","☀","Đặt ClockTime về ban ngày.","Button",false,nil,nil,nil,
    function() Lighting.ClockTime=14 end,{"day","time"})

add("Ban đêm","World","🌙","Đặt ClockTime về ban đêm.","Button",false,nil,nil,nil,
    function() Lighting.ClockTime=0 end,{"night","time"})

add("Độ sáng","World","💡","Điều chỉnh Brightness của Lighting.","Slider",Lighting.Brightness,0,10,.1,
    function(v) Lighting.Brightness=v end,{"brightness","light"})

add("Sương mù","World","🌫","Điều chỉnh FogEnd của Lighting.","Slider",1000,50,10000,50,
    function(v) Lighting.FogEnd=v end,{"fog","world"})

add("Thông tin Server","Server","🌀","Hiển thị PlaceId, JobId và số người chơi.","Button",false,nil,nil,nil,
    function()
        notify(string.format("Place %s • Players %d",tostring(game.PlaceId),#Players:GetPlayers()))
    end,{"server","info"})

add("Vào lại Server hiện tại","Server","🔄","Yêu cầu Roblox vào lại JobId hiện tại.","Button",false,nil,nil,nil,
    function() TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LocalPlayer) end,{"rejoin","server"})

add("Vào Server mới","Server","🚀","Yêu cầu Roblox tạo phiên mới cho Place hiện tại.","Button",false,nil,nil,nil,
    function() TeleportService:Teleport(game.PlaceId,LocalPlayer) end,{"new","server"})

add("Hiển thị JobId","Server","🆔","Hiển thị JobId trong thông báo.","Button",false,nil,nil,nil,
    function() notify("JobId: "..tostring(game.JobId)) end,{"jobid","server"})

add("Xoay nhân vật","Troll / Admin","🌀","Hiệu ứng xoay cục bộ trên nhân vật.","Toggle",false,nil,nil,nil,
    function(v) setState("Xoay nhân vật",v) end,{"spin","local"})

add("Ngồi","Troll / Admin","🪑","Cho nhân vật ngồi cục bộ.","Button",false,nil,nil,nil,
    function() local h=getHumanoid(); if h then h.Sit=true end end,{"sit"})

add("Ragdoll thử nghiệm","Troll / Admin","🧍","Đưa Humanoid vào trạng thái Physics để thử nghiệm.","Button",false,nil,nil,nil,
    function() local h=getHumanoid(); if h then h:ChangeState(Enum.HumanoidStateType.Physics) end end,{"ragdoll","physics"})

add("Phóng nhân vật","Troll / Admin","🚀","Hiệu ứng đẩy cục bộ để thử nghiệm vật lý.","Slider",80,0,500,5,
    function(v) Runtime.LaunchPower=v end,{"launch","physics"})

add("Confetti","Troll / Admin","🎊","Hiệu ứng confetti cục bộ.","Button",false,nil,nil,nil,
    function() confetti() end,{"confetti","fun"})

add("Vòng năng lượng","Effects","⭕","Hiệu ứng vòng năng lượng quanh giao diện.","Toggle",false,nil,nil,nil,
    function(v) setState("Vòng năng lượng",v) end,{"energy","ring"})

add("Nhịp sáng","Effects","💫","Hiệu ứng pulse trên giao diện.","Toggle",false,nil,nil,nil,
    function(v) setState("Nhịp sáng",v) end,{"pulse","glow"})

add("Lightning","Effects","⚡","Hiệu ứng lightning cục bộ.","Button",false,nil,nil,nil,
    function()
        for i=1,8 do
            local l=Instance.new("Frame")
            l.BackgroundColor3=Theme.Accent2
            l.BorderSizePixel=0
            l.ZIndex=999
            if i%2==0 then
                l.Size=UDim2.fromOffset(2,math.random(20,120))
                l.Position=UDim2.fromScale(math.random(),math.random())
            else
                l.Size=UDim2.fromOffset(math.random(30,150),2)
                l.Position=UDim2.fromScale(math.random(),math.random())
            end
            l.Parent=FX
            tween(l,.12,{BackgroundTransparency=1})
            Debris:AddItem(l,.15)
        end
    end,{"lightning","effect"})

add("Flash màn hình","Effects","✨","Flash màn hình cục bộ.","Button",false,nil,nil,nil,
    function() screenFlash() end,{"flash","screen"})

add("FOV Camera","Camera","🔭","Điều chỉnh FieldOfView.","Slider",70,30,120,1,
    function(v) Config.FOV=v; Camera.FieldOfView=v end,{"fov","camera"})

add("Rung camera","Camera","📳","Bật hiệu ứng rung nhẹ cục bộ.","Toggle",false,nil,nil,nil,
    function(v) Config.CameraShake=v end,{"shake","camera"})

add("Thu phóng camera","Camera","🔎","Điều chỉnh FOV nhanh bằng slider.","Slider",70,30,120,1,
    function(v) Camera.FieldOfView=v end,{"zoom","camera"})

add("Reset Camera","Camera","♻","Đưa camera về Custom và FOV 70.","Button",false,nil,nil,nil,
    function() Camera.CameraType=Enum.CameraType.Custom; Camera.FieldOfView=70 end,{"reset","camera"})

add("FPS","Debug","📊","Hiển thị FPS ở HUD.","Toggle",true,nil,nil,nil,
    function(v) Config.FPS=v end,{"fps"})

add("Tọa độ","Debug","📍","Hiển thị XYZ nhân vật.","Toggle",true,nil,nil,nil,
    function(v) Config.Coordinates=v end,{"coordinates","xyz"})

add("Vận tốc","Debug","💨","Hiển thị vận tốc nhân vật.","Toggle",true,nil,nil,nil,
    function(v) Config.Velocity=v end,{"velocity","speed"})

add("Kiểm tra Humanoid","Debug","🧪","Hiển thị trạng thái Humanoid.","Toggle",false,nil,nil,nil,
    function(v) setState("Kiểm tra Humanoid",v) end,{"humanoid","state"})

add("Đếm Part","Debug","🔢","Đếm BasePart trong Workspace.","Button",false,nil,nil,nil,
    function()
        local n=0
        for _,x in ipairs(workspace:GetDescendants()) do
            if x:IsA("BasePart") then n+=1 end
        end
        notify("BasePart: "..n)
    end,{"part","count"})

add("Máu","Stats","❤️","Hiển thị Health/MaxHealth.","Toggle",true,nil,nil,nil,
    function(v) setState("Máu",v) end,{"health","hp"})

add("Tốc độ","Stats","🏃","Hiển thị WalkSpeed.","Toggle",true,nil,nil,nil,
    function(v) setState("Tốc độ",v) end,{"speed","walk"})

add("Trọng lực","Stats","🌎","Hiển thị Gravity.","Toggle",true,nil,nil,nil,
    function(v) setState("Trọng lực",v) end,{"gravity"})

add("FOV","Stats","🔭","Hiển thị FOV hiện tại.","Toggle",true,nil,nil,nil,
    function(v) setState("FOV",v) end,{"fov","camera"})

add("Kiểm tra hệ thống","Stats","🧪","Hiển thị trạng thái các hệ thống chính.","Button",false,nil,nil,nil,
    function()
        notify(string.format("UI %.2f • Features %d • FPS %.0f",Config.UIScale,#Features,1/RunService.RenderStepped:Wait()))
    end,{"diagnostic","stats"})

add("Thông báo thử","Game Tools","🔔","Kiểm tra hệ thống thông báo.","Button",false,nil,nil,nil,
    function() notify("Thông báo ZAKA đang hoạt động") end,{"notification","test"})

add("Hiệu ứng thử","Game Tools","✨","Kiểm tra hiệu ứng card.","Button",false,nil,nil,nil,
    function() screenFlash(); confetti() end,{"effect","test"})

add("Refresh UI","Game Tools","🔄","Làm mới trang hiện tại.","Button",false,nil,nil,nil,
    function() end,{"refresh","ui"})

add("Kích thước UI","Settings","🔎","Điều chỉnh kích thước toàn bộ menu.","Slider",1,.65,1.5,.05,
    function(v) Config.UIScale=v; UIScale.Scale=v end,{"scale","size","ui"})

add("Độ trong suốt UI","Settings","🫧","Điều chỉnh độ trong suốt của menu.","Slider",.28,.05,.80,.01,
    function(v) Config.UITransparency=v; Main.BackgroundTransparency=v end,{"transparent","glass"})

add("Blur","Settings","🌫","Điều chỉnh blur nền.","Slider",10,0,24,1,
    function(v) Config.Blur=v; if Config.Open then Blur.Size=v end end,{"blur"})

add("Animation Speed","Settings","⚡","Điều chỉnh tốc độ animation.","Slider",1,.5,2.5,.05,
    function(v) Config.AnimationSpeed=v end,{"animation","speed"})

add("Cyber Theme","Settings","🔵","Chuyển sang theme Cyber.","Button",false,nil,nil,nil,
    function() Config.Theme="Cyber" end,{"theme","cyber"})

add("Purple Theme","Settings","🟣","Chuyển sang theme Purple.","Button",false,nil,nil,nil,
    function() Config.Theme="Purple" end,{"theme","purple"})

add("Ice Theme","Settings","❄","Chuyển sang theme Ice.","Button",false,nil,nil,nil,
    function() Config.Theme="Ice" end,{"theme","ice"})

add("Glow UI","Settings","✨","Bật/tắt Bloom glow.","Toggle",true,nil,nil,nil,
    function(v) Config.UIGlow=v; setGlow(v) end,{"glow","bloom"})

add("Night Vision","Settings","🌙","Bật ColorCorrection nhìn đêm cục bộ.","Toggle",false,nil,nil,nil,
    function(v) Config.NightVision=v; setNightVision(v) end,{"night","vision"})

--==========================================================
-- EXTRA REAL CONTROLS: derived diagnostics, not fake skills
--==========================================================
add("Xóa Highlight","ESP / Debug","🧹","Xóa toàn bộ Highlight do ZAKA tạo.","Button",false,nil,nil,nil,
    function() clearHighlights() end,{"clear","highlight"})

add("Xóa hiệu ứng","Effects","🧹","Xóa hiệu ứng UI do ZAKA tạo.","Button",false,nil,nil,nil,
    function()
        for _,x in ipairs(FX:GetChildren()) do x:Destroy() end
    end,{"clear","effects"})

add("Reset nhân vật","Players","♻","Respawn nhân vật hiện tại.","Button",false,nil,nil,nil,
    function() LocalPlayer:LoadCharacter() end,{"reset","character"})

add("Reset chuyển động","Movement","♻","Khôi phục WalkSpeed/JumpPower.","Button",false,nil,nil,nil,
    function()
        Config.WalkSpeed=16
        Config.JumpPower=50
        applyCharacterSettings()
    end,{"reset","movement"})

add("Reset thế giới","World","♻","Khôi phục Gravity và ClockTime.","Button",false,nil,nil,nil,
    function()
        workspace.Gravity=Config.Gravity
        Lighting.ClockTime=14
    end,{"reset","world"})

--==========================================================
-- DEV SECURITY / ANTI-CHEAT DIAGNOSTICS
-- Client-side only: real enforcement belongs on the server.
--==========================================================
local Security = {Enabled=false, MaxSpeed=40, MaxTeleport=120, Sample=.35, LastPos=nil, LastTime=0, Violations=0}
local SecurityConn
local function securityStop()
    if SecurityConn then SecurityConn:Disconnect(); SecurityConn=nil end
end
local function securityStart()
    securityStop()
    Security.LastPos=nil
    Security.LastTime=os.clock()
    Security.Violations=0
    SecurityConn=RunService.Heartbeat:Connect(function()
        if not Security.Enabled then return end
        local r=rootPart()
        if not r then return end
        local now=os.clock()
        local dt=now-Security.LastTime
        if dt<Security.Sample then return end
        if Security.LastPos then
            local dist=(r.Position-Security.LastPos).Magnitude
            local speed=dist/math.max(dt,.001)
            if speed>Security.MaxSpeed and dist>Security.MaxTeleport then
                Security.Violations+=1
                notify((Language=="EN" and "Security warning: abnormal movement " or "Cảnh báo anti-cheat: di chuyển bất thường ")..math.floor(speed).." studs/s")
            end
        end
        Security.LastPos=r.Position
        Security.LastTime=now
    end)
end
add("Anti-Cheat Debug","Debug","🛡","Bật bộ giám sát chuyển động để test trong experience bạn kiểm soát. Đây không phải bypass anti-cheat.","Toggle",false,nil,nil,nil,
    function(v) Security.Enabled=v; if v then securityStart() else securityStop() end end,{"anti","cheat","security","debug"})
add("Ngưỡng tốc độ","Debug","🏃","Ngưỡng tốc độ dùng cho kiểm thử phát hiện chuyển động bất thường.","Input",40,nil,nil,nil,
    function(v) local n=tonumber(v); if n and n>=0 then Security.MaxSpeed=n end end,{"anti","speed","threshold"})
add("Ngưỡng dịch chuyển","Debug","📡","Khoảng cách tối thiểu để phân biệt bước di chuyển lớn khi kiểm thử.","Input",120,nil,nil,nil,
    function(v) local n=tonumber(v); if n and n>=0 then Security.MaxTeleport=n end end,{"anti","teleport","threshold"})
add("Reset cảnh báo Security","Debug","♻","Xóa bộ đếm cảnh báo của phiên debug.","Button",false,nil,nil,nil,
    function() Security.Violations=0; notify(Language=="EN" and "Security violations reset" or "Đã reset cảnh báo Security") end,{"anti","reset","security"})

--==========================================================
-- THEME APPLY
--==========================================================
local function applyTheme()
    Theme=Themes[Config.Theme] or Themes.Cyber
    Main.BackgroundColor3=Theme.Background
    Main.BackgroundTransparency=Config.UITransparency
    Tabs.BackgroundColor3=Theme.Panel
    Search.BackgroundColor3=Theme.Panel
    OpenButton.BackgroundColor3=Theme.Panel
    Title.TextColor3=Theme.Accent2
    Subtitle.TextColor3=Theme.Sub
    Search.TextColor3=Theme.Text
    Search.PlaceholderColor3=Theme.Sub
    HUD.TextColor3=Theme.Accent2
    Close.TextColor3=Theme.Text
    if LangBtn then LangBtn.BackgroundColor3=Theme.Card; LangBtn.TextColor3=Theme.Accent2 end

    for _,b in ipairs(Runtime.TabButtons) do
        b.BackgroundColor3=Theme.Card
        b.TextColor3=Theme.Text
    end

    for _,card in ipairs(Runtime.Cards) do
        if card and card.Parent then
            card.BackgroundColor3=Theme.Card
        end
    end

    if State["Tâm ngắm"] then makeCrosshair(true) end
    if State["Vòng FOV luyện tập"] then makeFOVCircle(true) end
    setGlow(Config.UIGlow)
    setNightVision(Config.NightVision)
end

--==========================================================
-- NOTIFICATION
--==========================================================
notify=function(text)
    local n=Instance.new("TextLabel")
    n.Size=UDim2.fromOffset(330,44)
    n.AnchorPoint=Vector2.new(1,1)
    n.Position=UDim2.new(1,-18,1,20)
    n.BackgroundColor3=Theme.Panel
    n.BackgroundTransparency=.12
    n.Text=text
    n.TextColor3=Theme.Text
    n.TextSize=11
    n.Font=Enum.Font.GothamBold
    n.ZIndex=1000
    n.Parent=Gui
    corner(n,14)
    stroke(n,.35)
    tween(n,.22,{Position=UDim2.new(1,-18,1,-20)})
    task.delay(2.2,function()
        if n.Parent then
            tween(n,.2,{Position=UDim2.new(1,-18,1,20),TextTransparency=1,BackgroundTransparency=1})
            Debris:AddItem(n,.25)
        end
    end)
end

--==========================================================
-- CARD CONTROLS
--==========================================================
local function makeToggle(parent,feature)
    local b=Instance.new("TextButton")
    b.Size=UDim2.fromOffset(58,34)
    b.BackgroundColor3=Theme.Panel
    b.BackgroundTransparency=.08
    b.Text=""
    b.AutoButtonColor=false
    b.Parent=parent
    corner(b,17)

    local knob=Instance.new("Frame")
    knob.Size=UDim2.fromOffset(26,26)
    knob.AnchorPoint=Vector2.new(.5,.5)
    knob.BackgroundColor3=Theme.Sub
    knob.Parent=b
    corner(knob,13)

    local function refresh()
        local on=State[feature.Name] and true or false
        b.BackgroundColor3=on and Theme.Accent or Theme.Panel
        knob.Position=UDim2.new(0,on and 40 or 18,.5,0)
        knob.BackgroundColor3=on and Theme.Accent2 or Theme.Sub
    end
    refresh()

    b.Activated:Connect(function()
        local value=not State[feature.Name]
        State[feature.Name]=value
        refresh()
        if feature.Handler then feature.Handler(value) end
    end)
    return b
end

local function makeSlider(parent,feature)
    local wrap=Instance.new("Frame")
    wrap.Size=UDim2.fromOffset(205,42)
    wrap.BackgroundTransparency=1
    wrap.Parent=parent

    local value=State[feature.Name]
    if value==nil then value=feature.Default or feature.Min or 0; State[feature.Name]=value end

    local valueLabel=Instance.new("TextLabel")
    valueLabel.Size=UDim2.fromOffset(58,18)
    valueLabel.Position=UDim2.new(1,-58,0,0)
    valueLabel.BackgroundTransparency=1
    valueLabel.Text=tostring(value)
    valueLabel.TextColor3=Theme.Accent2
    valueLabel.TextSize=11
    valueLabel.Font=Enum.Font.GothamBold
    valueLabel.TextXAlignment=Enum.TextXAlignment.Right
    valueLabel.Parent=wrap

    local track=Instance.new("Frame")
    track.Size=UDim2.new(1,-66,0,6)
    track.Position=UDim2.new(0,0,0,7)
    track.BackgroundColor3=Theme.Panel
    track.BorderSizePixel=0
    track.Parent=wrap
    corner(track,4)

    local fill=Instance.new("Frame")
    fill.BackgroundColor3=Theme.Accent
    fill.BorderSizePixel=0
    fill.Parent=track
    corner(fill,4)

    local knob=Instance.new("Frame")
    knob.Size=UDim2.fromOffset(14,14)
    knob.AnchorPoint=Vector2.new(.5,.5)
    knob.BackgroundColor3=Theme.Accent2
    knob.Parent=track
    corner(knob,7)

    local dragging=false
    local minValue=feature.Min or 0
    local maxValue=feature.Max or 100
    local step=feature.Step or 1

    local function setX(x)
        local a=math.clamp((x-track.AbsolutePosition.X)/math.max(track.AbsoluteSize.X,1),0,1)
        local v=minValue+(maxValue-minValue)*a
        v=math.floor(v/step+.5)*step
        State[feature.Name]=v
        valueLabel.Text=tostring(v)
        fill.Size=UDim2.new(a,0,1,0)
        knob.Position=UDim2.new(a,0,.5,0)
        if feature.Handler then feature.Handler(v) end
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true
            setX(input.Position.X)
        end
    end)

    connect(UserInputService.InputChanged,function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            setX(input.Position.X)
        end
    end)

    connect(UserInputService.InputEnded,function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=false
        end
    end)

    local a=math.clamp((value-minValue)/math.max(maxValue-minValue,.001),0,1)
    fill.Size=UDim2.new(a,0,1,0)
    knob.Position=UDim2.new(a,0,.5,0)

    return wrap
end

local function makeCard(parent,feature,index)
    local card=Instance.new("Frame")
    card.Size=UDim2.new(1,-4,0,82)
    card.BackgroundColor3=Theme.Card
    card.BackgroundTransparency=.38
    card.BorderSizePixel=0
    card.LayoutOrder=index
    card.Parent=parent
    corner(card,16)
    stroke(card,.64)

    table.insert(Runtime.Cards,card)

    local icon=label(card,feature.Icon,19,true)
    icon.Position=UDim2.new(0,13,0,13)
    icon.Size=UDim2.fromOffset(40,28)
    icon.TextXAlignment=Enum.TextXAlignment.Center

    local name=label(card,featureText(feature),13,true)
    name.Position=UDim2.new(0,62,0,11)
    name.Size=UDim2.new(1,-285,0,22)

    local desc=label(card,featureDesc(feature),10,false)
    desc.Position=UDim2.new(0,63,0,37)
    desc.Size=UDim2.new(1,-285,0,31)
    desc.TextColor3=Theme.Sub
    desc.TextWrapped=true

    local control
    if feature.Kind=="Toggle" then
        control=makeToggle(card,feature)
        control.Position=UDim2.new(1,-92,.5,-17)
    elseif feature.Kind=="Slider" then
        control=makeSlider(card,feature)
        control.Position=UDim2.new(1,-210,.5,-21)
    elseif feature.Kind=="Input" then
        control=Instance.new("TextBox")
        control.Size=UDim2.fromOffset(105,38)
        control.Position=UDim2.new(1,-120,.5,-19)
        control.BackgroundColor3=Theme.Panel
        control.BackgroundTransparency=.08
        control.Text=tostring(State[feature.Name] or feature.Default or 0)
        control.PlaceholderText=Language=="EN" and "Enter number" or "Nhập số"
        control.TextColor3=Theme.Accent2
        control.TextSize=11
        control.Font=Enum.Font.GothamBold
        control.ClearTextOnFocus=false
        control.Parent=card
        corner(control,13)
        stroke(control,.55)
        control.FocusLost:Connect(function()
            local n=tonumber(control.Text)
            if n then
                State[feature.Name]=n
                control.Text=tostring(n)
                if feature.Handler then feature.Handler(n) end
            else
                control.Text=tostring(State[feature.Name] or feature.Default or 0)
            end
        end)
    else
        control=Instance.new("TextButton")
        control.Size=UDim2.fromOffset(76,38)
        control.Position=UDim2.new(1,-92,.5,-19)
        control.BackgroundColor3=Theme.Panel
        control.BackgroundTransparency=.10
        control.Text=uiText("Execute")
        control.TextColor3=Theme.Accent2
        control.TextSize=9
        control.Font=Enum.Font.GothamBold
        control.AutoButtonColor=false
        control.Parent=card
        corner(control,13)
        stroke(control,.65)

        control.Activated:Connect(function()
            if feature.Handler then feature.Handler() end
            tween(card,.07,{Size=UDim2.new(1,-10,0,78)})
            task.delay(.08,function()
                if card.Parent then tween(card,.14,{Size=UDim2.new(1,-4,0,82)}) end
            end)
        end)
    end

    -- Feature animation: hover/touch lift + accent
    local function press(on)
        if on then
            tween(card,.10,{BackgroundTransparency=.18})
        else
            tween(card,.14,{BackgroundTransparency=.38})
        end
    end
    card.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
            press(true)
        end
    end)
    card.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
            press(false)
        end
    end)

    return card
end

--==========================================================
-- SEARCH
--==========================================================
local function normalize(s)
    s=tostring(s or ""):lower()
    s=s:gsub("[%p]"," ")
    s=s:gsub("%s+"," ")
    return s:match("^%s*(.-)%s*$")
end

local function scoreFeature(f,q)
    if q=="" then return 0 end
    local n=normalize(f.Name)
    local en=normalize(ENName[f.Name] or f.Name)
    local d=normalize(f.Description)
    local ed=normalize(f.ENDescription or "")
    if n==q or en==q then return 1000 end
    if n:sub(1,#q)==q or en:sub(1,#q)==q then return 900 end
    if n:find(q,1,true) or en:find(q,1,true) then return 700 end

    local score=0
    for _,k in ipairs(f.Keywords or {}) do
        k=normalize(k)
        if k==q then score=math.max(score,850)
        elseif k:sub(1,#q)==q then score=math.max(score,800)
        elseif k:find(q,1,true) then score=math.max(score,650) end
    end
    if d:find(q,1,true) or ed:find(q,1,true) then score=math.max(score,450) end

    local matched=0
    for token in q:gmatch("%S+") do
        if n:find(token,1,true) or en:find(token,1,true) or d:find(token,1,true) or ed:find(token,1,true) then matched+=1 end
    end
    return math.max(score,matched*120)
end

local function clearPage(page)
    for _,x in ipairs(page:GetChildren()) do
        if not x:IsA("UIListLayout") and not x:IsA("UIPadding") then x:Destroy() end
    end
end

local function buildPage(tabName)
    local old=Runtime.Pages[tabName]
    if old then old:Destroy() end

    local page=Instance.new("ScrollingFrame")
    page.Name="Page_"..tabName
    page.Size=UDim2.fromScale(1,1)
    page.BackgroundTransparency=1
    page.BorderSizePixel=0
    page.ScrollBarThickness=2
    hookScrollBoost(page)
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

    local i=0
    for _,f in ipairs(Features) do
        if f.Tab==tabName then
            i+=1
            local card=makeCard(page,f,i)
            card.BackgroundTransparency=1
            card.Size=UDim2.new(1,-4,0,70)
            task.delay(i*.025,function()
                if card.Parent then
                    tween(card,.24,{BackgroundTransparency=.38,Size=UDim2.new(1,-4,0,82)},Enum.EasingStyle.Quint) 
                end
            end)
        end
    end
    Runtime.Pages[tabName]=page
    return page
end

local function showTab(tabName)
    Runtime.CurrentTab=tabName
    for _,p in pairs(Runtime.Pages) do p.Visible=false end
    local page=Runtime.Pages[tabName] or buildPage(tabName)
    page.Visible=true
end

RefreshLanguage=function()
    LangBtn.Text=uiText("Language")
    Title.Text=uiText("Title")
    Subtitle.Text=uiText("Subtitle")
    Search.PlaceholderText=uiText("Search")
    for _,b in ipairs(Runtime.TabButtons) do
        local tab=b:GetAttribute("ZakaTab")
        if tab then b.Text=b:GetAttribute("ZakaIcon").."  "..tabText(tab) end
    end
    for tab,page in pairs(Runtime.Pages) do
        if page and page.Parent then page:Destroy() end
        Runtime.Pages[tab]=nil
    end
    if Runtime.CurrentTab then showTab(Runtime.CurrentTab) end
    notify(Language=="EN" and "Language: English" or "Ngôn ngữ: Tiếng Việt")
end

local function buildSearch()
    for _,p in pairs(Runtime.Pages) do p.Visible=false end

    local page=Runtime.Pages.__SEARCH
    if page then page:Destroy() end

    page=Instance.new("ScrollingFrame")
    page.Name="SearchResults"
    page.Size=UDim2.fromScale(1,1)
    page.BackgroundTransparency=1
    page.BorderSizePixel=0
    page.ScrollBarThickness=2
    page.AutomaticCanvasSize=Enum.AutomaticSize.Y
    page.CanvasSize=UDim2.new()
    page.Parent=PageArea

    local layout=Instance.new("UIListLayout")
    layout.Padding=UDim.new(0,9)
    layout.Parent=page

    local q=normalize(Search.Text)
    local results={}
    for _,f in ipairs(Features) do
        local score=scoreFeature(f,q)
        if q=="" or score>0 then
            table.insert(results,{f=f,s=score})
        end
    end
    table.sort(results,function(a,b)
        if a.s==b.s then return a.f.Name<b.f.Name end
        return a.s>b.s
    end)

    for i,r in ipairs(results) do
        makeCard(page,r.f,i)
    end

    Runtime.Pages.__SEARCH=page
end

--==========================================================
-- CAROUSEL
--==========================================================
local function refreshCarousel()
    local center=Tabs.AbsolutePosition.Y+Tabs.AbsoluteSize.Y/2
    local half=math.max(Tabs.AbsoluteSize.Y/2,1)

    for _,b in ipairs(Runtime.TabButtons) do
        local y=b.AbsolutePosition.Y+b.AbsoluteSize.Y/2
        local n=math.clamp(math.abs(y-center)/half,0,1)
        local s=1-.48*n
        local h=math.max(30,math.floor(50*s))
        b.Size=UDim2.new(1,-14,0,h)
        b.TextTransparency=.05+.72*n
        b.BackgroundTransparency=.20+.50*n
    end
end

for i,data in ipairs(TabData) do
    local icon,name=table.unpack(data)
    local b=Instance.new("TextButton")
    b.LayoutOrder=i
    b.Size=UDim2.new(1,-14,0,50)
    b.BackgroundColor3=Theme.Card
    b.BackgroundTransparency=.20
    b.Text=icon.."  "..tabText(name)
    b:SetAttribute("ZakaTab",name)
    b:SetAttribute("ZakaIcon",icon)
    b.TextColor3=Theme.Text
    b.TextSize=12
    b.Font=Enum.Font.GothamBold
    b.AutoButtonColor=false
    b.Parent=TabContent
    corner(b,14)
    stroke(b,.55)

    b.Activated:Connect(function()
        Search.Text=""
        showTab(name)
        tween(Tabs,.28,{
            CanvasPosition=Vector2.new(
                0,
                math.max(0,(i-1)*57-Tabs.AbsoluteSize.Y/2+30)
            )
        })
    end)
    table.insert(Runtime.TabButtons,b)
end

connect(Tabs:GetPropertyChangedSignal("CanvasPosition"),refreshCarousel)
connect(Tabs:GetPropertyChangedSignal("AbsoluteSize"),refreshCarousel)

connect(Search:GetPropertyChangedSignal("Text"),function()
    if normalize(Search.Text)~="" then
        buildSearch()
    else
        if Runtime.Pages.__SEARCH then Runtime.Pages.__SEARCH.Visible=false end
        showTab(Runtime.CurrentTab)
    end
end)

--==========================================================
-- OPEN/CLOSE ANIMATION
--==========================================================
local function lightningReveal()
    for i=1,9 do
        local l=Instance.new("Frame")
        l.BackgroundColor3=Theme.Accent2
        l.BorderSizePixel=0
        l.ZIndex=999
        if i%2==0 then
            l.Size=UDim2.fromOffset(2,math.random(30,150))
            l.Position=UDim2.fromScale(math.random(),math.random())
        else
            l.Size=UDim2.fromOffset(math.random(30,180),2)
            l.Position=UDim2.fromScale(math.random(),math.random())
        end
        l.Parent=FX
        tween(l,.10,{BackgroundTransparency=1})
        Debris:AddItem(l,.13)
    end
end

local function menuSize()
    local vp=Camera.ViewportSize
    if vp.X<720 then
        return UDim2.fromOffset(
            math.max(330,vp.X-18),
            math.max(370,vp.Y-42)
        )
    end
    return UDim2.fromOffset(
        math.min(920,vp.X*.74),
        math.min(650,vp.Y*.80)
    )
end

local function openMenu()
    if Config.Open then return end
    Config.Open=true
    Main.Visible=true
    Main.Position=Config.MenuPosition
    Main.Size=UDim2.fromOffset(20,20)
    Blur.Size=0

    lightningReveal()
    task.delay(.08,lightningReveal)
    task.delay(.16,lightningReveal)

    tween(Blur,.32,{Size=Config.Blur})
    local t=tween(Main,.42,{Size=menuSize()},Enum.EasingStyle.Back)
    t.Completed:Connect(function()
        refreshCarousel()
    end)
end

local function closeMenu()
    if not Config.Open then return end
    Config.Open=false
    Config.MenuPosition=Main.Position
    tween(Blur,.24,{Size=0})
    local t=tween(Main,.30,{Size=UDim2.fromOffset(20,20)},Enum.EasingStyle.Back,Enum.EasingDirection.In)
    t.Completed:Connect(function()
        if not Config.Open then Main.Visible=false end
    end)
end

OpenButton.Activated:Connect(function()
    if Config.Open then closeMenu() else openMenu() end
end)
Close.Activated:Connect(closeMenu)

--==========================================================
-- DRAGGING
--==========================================================
local function draggable(obj,callback)
    local dragging=false
    local startInput
    local startPos

    obj.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true
            startInput=input.Position
            startPos=obj.Position
        end
    end)

    connect(UserInputService.InputChanged,function(input)
        if not dragging then return end
        if input.UserInputType~=Enum.UserInputType.MouseMovement and input.UserInputType~=Enum.UserInputType.Touch then return end
        local d=input.Position-startInput
        obj.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
        if callback then callback(obj.Position) end
    end)

    connect(UserInputService.InputEnded,function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=false
        end
    end)
end

draggable(Top,function(pos) Main.Position=pos; Config.MenuPosition=pos end)
draggable(OpenButton,function(pos) Config.OpenButtonPosition=pos end)

--==========================================================
-- INPUT / CHARACTER
--==========================================================
connect(UserInputService.InputBegan,function(input,gp)
    if gp then return end

    if input.KeyCode==AimTrainer.Key and AimTrainer.Enabled then
        if AimTrainer.Mode=="Toggle" then
            AimTrainer.Active=not AimTrainer.Active
        else
            AimTrainer.Active=true
        end
        if AimTouchButton then updateAimTouchButton() end
    end

    if input.UserInputType==Enum.UserInputType.MouseButton1 then
        if State["Bộ đếm combo"] then
            local now=os.clock()
            if now-Runtime.LastClick<1.2 then
                Runtime.Combo+=1
            else
                Runtime.Combo=1
            end
            Runtime.LastClick=now
            if State["Đèn báo thao tác"] then screenFlash() end
        end
    end
end)

connect(UserInputService.InputEnded,function(input,gp)
    if gp then return end
    if input.KeyCode==AimTrainer.Key and AimTrainer.Mode=="Hold" then
        AimTrainer.Active=false
        if AimTouchButton then updateAimTouchButton() end
    end
end)

connect(UserInputService.JumpRequest,function()
    if not Config.DoubleJump then return end
    local h=getHumanoid()
    if h and h:GetState()==Enum.HumanoidStateType.Freefall then
        h:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

Runtime.CharacterConnection=LocalPlayer.CharacterAdded:Connect(function()
    task.wait(.35)
    applyCharacterSettings()
    local h=getHumanoid()
    if h then h.AutoRotate=State["Tự xoay nhân vật"] end
    if Config.Fly then task.wait(.2); startFly() end
end)
table.insert(Connections,Runtime.CharacterConnection)

--==========================================================
-- RUNTIME HUD / EFFECTS
--==========================================================
local accumulator=0
connect(RunService.RenderStepped,function(dt)
    Camera=workspace.CurrentCamera
    accumulator+=dt

    local lines={}
    local fps=math.floor(1/math.max(dt,.001))

    if Config.FPS then table.insert(lines,"FPS "..fps) end

    local root=getRoot()
    local hum=getHumanoid()

    if root and Config.Coordinates then
        local p=root.Position
        table.insert(lines,string.format("XYZ %.0f / %.0f / %.0f",p.X,p.Y,p.Z))
    end
    if root and Config.Velocity then
        table.insert(lines,string.format("VEL %.0f",root.AssemblyLinearVelocity.Magnitude))
    end
    if hum then
        if State["Máu"] then table.insert(lines,string.format("HP %.0f/%.0f",hum.Health,hum.MaxHealth)) end
        if State["Tốc độ"] then table.insert(lines,string.format("SPD %.0f",hum.WalkSpeed)) end
    end
    if State["Trọng lực"] then table.insert(lines,string.format("G %.0f",workspace.Gravity)) end
    if State["FOV"] then table.insert(lines,string.format("FOV %.0f",Camera.FieldOfView)) end
    if State["Bộ đếm combo"] then table.insert(lines,"COMBO "..Runtime.Combo) end
    if State["Kiểm tra Humanoid"] and hum then table.insert(lines,"STATE "..hum:GetState().Name) end

    HUD.Text=table.concat(lines,"  |  ")

    if Config.Glide and root then
        local v=root.AssemblyLinearVelocity
        if v.Y<0 then
            local fall=Runtime.GlideFallSpeed or 18
            root.AssemblyLinearVelocity=Vector3.new(v.X,math.max(v.Y,-fall),v.Z)
        end
    end

    if State["Xoay nhân vật"] and root then
        root.CFrame=root.CFrame*CFrame.Angles(0,math.rad(4),0)
    end

    if Config.CameraShake and Camera then
        local s=math.sin(os.clock()*16)*.0015
        Camera.CFrame=Camera.CFrame*CFrame.Angles(s,s,0)
    end

    if Config.RainbowUI then
        local c=Color3.fromHSV((os.clock()*.12)%1,.8,1)
        Title.TextColor3=c
        OpenButton.TextColor3=c
    else
        Title.TextColor3=Theme.Accent2
        OpenButton.TextColor3=Theme.Text
    end

    if State["Vòng năng lượng"] and accumulator>.25 then
        accumulator=0
        pulse(FX)
    end
end)

--==========================================================
-- RESIZE / THEME BUTTON HANDLERS
--==========================================================
for _,f in ipairs(Features) do
    if f.Name=="Cyber Theme" then
        f.Handler=function() Config.Theme="Cyber"; applyTheme() end
    elseif f.Name=="Purple Theme" then
        f.Handler=function() Config.Theme="Purple"; applyTheme() end
    elseif f.Name=="Ice Theme" then
        f.Handler=function() Config.Theme="Ice"; applyTheme() end
    elseif f.Name=="Refresh UI" then
        f.Handler=function()
            local tab=Runtime.CurrentTab
            if Runtime.Pages[tab] then Runtime.Pages[tab]:Destroy(); Runtime.Pages[tab]=nil end
            showTab(tab)
        end
    elseif f.Name=="Chế độ luyện tập" then
        f.Handler=function(v) State[f.Name]=v end
    end
end

connect(Camera:GetPropertyChangedSignal("ViewportSize"),function()
    if Config.Open then Main.Size=menuSize() end
    if Camera.ViewportSize.X<720 then
        Tabs.Size=UDim2.new(0,128,1,0)
        Pages.Position=UDim2.new(0,138,0,0)
        Pages.Size=UDim2.new(1,-138,1,0)
    else
        Tabs.Size=UDim2.new(0,176,1,0)
        Pages.Position=UDim2.new(0,186,0,0)
        Pages.Size=UDim2.new(1,-186,1,0)
    end
    refreshCarousel()
end)


--==========================================================
-- SIDE RASENGAN EYES: RED, FIXED STYLE, SCROLL BOOST
--==========================================================
local SideEyeBoostUntil=0
local SideEyes={}

local function makeSideEye(name,side)
    local holder=Instance.new("TextButton")
    holder.Name=name
    holder.Size=UDim2.fromOffset(38,38)
    holder.Position=side=="Left" and UDim2.new(0,-43,.5,-19) or UDim2.new(1,5,.5,-19)
    holder.BackgroundTransparency=1
    holder.Text=""
    holder.AutoButtonColor=false
    holder.ZIndex=75
    holder.Parent=Main

    local outer=Instance.new("Frame")
    outer.AnchorPoint=Vector2.new(.5,.5)
    outer.Position=UDim2.fromScale(.5,.5)
    outer.Size=UDim2.fromScale(.9,.9)
    outer.BackgroundColor3=Color3.fromRGB(18,0,3)
    outer.BorderSizePixel=0
    outer.ZIndex=76
    outer.Parent=holder
    local oc=Instance.new("UICorner"); oc.CornerRadius=UDim.new(1,0); oc.Parent=outer
    local os=Instance.new("UIStroke"); os.Color=Color3.fromRGB(255,40,55); os.Thickness=1.7; os.Parent=outer

    local ring=Instance.new("Frame")
    ring.AnchorPoint=Vector2.new(.5,.5); ring.Position=UDim2.fromScale(.5,.5)
    ring.Size=UDim2.fromScale(.67,.67); ring.BackgroundColor3=Color3.fromRGB(205,8,24)
    ring.BorderSizePixel=0; ring.ZIndex=77; ring.Parent=outer
    local rc=Instance.new("UICorner"); rc.CornerRadius=UDim.new(1,0); rc.Parent=ring
    local rs=Instance.new("UIStroke"); rs.Color=Color3.fromRGB(255,80,85); rs.Thickness=1; rs.Parent=ring

    local iris=Instance.new("Frame")
    iris.AnchorPoint=Vector2.new(.5,.5); iris.Position=UDim2.fromScale(.5,.5)
    iris.Size=UDim2.fromScale(.40,.40); iris.BackgroundColor3=Color3.fromRGB(245,22,35)
    iris.BorderSizePixel=0; iris.ZIndex=78; iris.Parent=ring
    local ic=Instance.new("UICorner"); ic.CornerRadius=UDim.new(1,0); ic.Parent=iris

    local detailRing=Instance.new("Frame")
    detailRing.AnchorPoint=Vector2.new(.5,.5); detailRing.Position=UDim2.fromScale(.5,.5)
    detailRing.Size=UDim2.fromScale(.52,.52); detailRing.BackgroundTransparency=1
    detailRing.ZIndex=78; detailRing.Parent=ring
    local drs=Instance.new("UIStroke"); drs.Color=Color3.fromRGB(255,120,125); drs.Thickness=1; drs.Transparency=.18; drs.Parent=detailRing
    local drc=Instance.new("UICorner"); drc.CornerRadius=UDim.new(1,0); drc.Parent=detailRing

    local shine=Instance.new("Frame")
    shine.AnchorPoint=Vector2.new(.5,.5); shine.Position=UDim2.fromScale(.36,.32)
    shine.Size=UDim2.fromOffset(4,4); shine.BackgroundColor3=Color3.fromRGB(255,235,235)
    shine.BorderSizePixel=0; shine.ZIndex=82; shine.Parent=iris
    local shc=Instance.new("UICorner"); shc.CornerRadius=UDim.new(1,0); shc.Parent=shine

    local pupil=Instance.new("Frame")
    pupil.AnchorPoint=Vector2.new(.5,.5); pupil.Position=UDim2.fromScale(.5,.5)
    pupil.Size=UDim2.fromScale(.24,.24); pupil.BackgroundColor3=Color3.fromRGB(3,0,0)
    pupil.BorderSizePixel=0; pupil.ZIndex=80; pupil.Parent=iris
    local pc=Instance.new("UICorner"); pc.CornerRadius=UDim.new(1,0); pc.Parent=pupil

    -- Three small tomoe-like marks, always crimson/red.
    for i=1,3 do
        local a=math.rad((i-1)*120)
        local mark=Instance.new("Frame")
        mark.AnchorPoint=Vector2.new(.5,.5)
        mark.Position=UDim2.fromScale(.5+math.cos(a)*.25,.5+math.sin(a)*.25)
        mark.Size=UDim2.fromOffset(5,9)
        mark.Rotation=math.deg(a)+35
        mark.BackgroundColor3=Color3.fromRGB(255,45,55)
        mark.BorderSizePixel=0
        mark.ZIndex=79
        mark.Parent=iris
        local mc=Instance.new("UICorner"); mc.CornerRadius=UDim.new(1,0); mc.Parent=mark
    end
    return {Holder=holder,Outer=outer,Ring=ring,Iris=iris,Pupil=pupil,Angle=0}
end

SideEyes.Left=makeSideEye("ZakaRasenganEyeLeft","Left")
SideEyes.Right=makeSideEye("ZakaRasenganEyeRight","Right")

local function boostSideEyes()
    SideEyeBoostUntil=os.clock()+.65
end

local function hookScrollBoost(sf)
    if not sf or not sf:IsA("ScrollingFrame") then return end
    sf:GetPropertyChangedSignal("CanvasPosition"):Connect(boostSideEyes)
end
hookScrollBoost(Tabs)

--==========================================================
-- V1 VISUAL UPGRADE: RAINBOW BORDER + ANIME EYE
--==========================================================
local V1RainbowStroke = Main:FindFirstChild("V1RainbowBorder")
if not V1RainbowStroke then
    V1RainbowStroke=Instance.new("UIStroke")
    V1RainbowStroke.Name="V1RainbowBorder"
    V1RainbowStroke.Thickness=2.5
    V1RainbowStroke.Transparency=.05
    V1RainbowStroke.Parent=Main
end

local EyeLayer=Instance.new("Frame")
EyeLayer.Name="ZakaEyeV1"
EyeLayer.AnchorPoint=Vector2.new(.5,.5)
EyeLayer.Position=UDim2.fromScale(.5,.5)
EyeLayer.Size=UDim2.fromScale(.84,.84)
EyeLayer.BackgroundTransparency=1
EyeLayer.Visible=false
EyeLayer.ZIndex=OpenButton.ZIndex+10
EyeLayer.Parent=OpenButton

local EyeOuter=Instance.new("Frame")
EyeOuter.AnchorPoint=Vector2.new(.5,.5)
EyeOuter.Position=UDim2.fromScale(.5,.5)
EyeOuter.Size=UDim2.fromScale(1,1)
EyeOuter.BackgroundTransparency=1
EyeOuter.Parent=EyeLayer

local EyeInner=EyeOuter:Clone(); EyeInner.Parent=EyeLayer
local EyeSymbol=EyeOuter:Clone(); EyeSymbol.Parent=EyeLayer

local function eyeCircle(parent,size,color,transparency,z)
    local f=Instance.new("Frame")
    f.AnchorPoint=Vector2.new(.5,.5)
    f.Position=UDim2.fromScale(.5,.5)
    f.Size=UDim2.fromScale(size,size)
    f.BackgroundColor3=color
    f.BackgroundTransparency=transparency or 0
    f.BorderSizePixel=0
    f.ZIndex=z or 1
    f.Parent=parent
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(1,0)
    c.Parent=f
    return f
end

local EyeGlow=eyeCircle(EyeOuter,1.30,Color3.fromRGB(255,30,45),.88,1)
local EyeGlow2=eyeCircle(EyeOuter,1.08,Color3.fromRGB(255,40,50),.72,2)
local EyeBase=eyeCircle(EyeOuter,.94,Color3.fromRGB(40,2,8),0,3)
local EyeRing1=eyeCircle(EyeOuter,.79,Color3.fromRGB(105,5,15),0,4)
local EyeRing2=eyeCircle(EyeOuter,.62,Color3.fromRGB(210,20,35),0,5)
local EyeIris=eyeCircle(EyeInner,.48,Color3.fromRGB(230,25,45),0,10)
local EyeIris2=eyeCircle(EyeInner,.34,Color3.fromRGB(45,2,7),0,11)
local EyePupil=eyeCircle(EyeInner,.14,Color3.new(0,0,0),0,12)
local EyeCore=eyeCircle(EyeInner,.045,Color3.new(1,1,1),0,13)
local EyeBaseStroke=Instance.new('UIStroke'); EyeBaseStroke.Thickness=2; EyeBaseStroke.Color=Color3.fromRGB(255,55,70); EyeBaseStroke.Parent=EyeBase
local EyeRingStroke=Instance.new('UIStroke'); EyeRingStroke.Thickness=1.5; EyeRingStroke.Color=Color3.fromRGB(255,90,100); EyeRingStroke.Parent=EyeRing1

local EyeMarks={}
local EyeTypes={
    {Name='Sharingan',Main=Color3.fromRGB(235,25,40),Dark=Color3.fromRGB(35,0,5),Kind='Tomoe'},
    {Name='Rinnegan',Main=Color3.fromRGB(175,125,255),Dark=Color3.fromRGB(35,15,70),Kind='Rings'},
    {Name='Mangekyo',Main=Color3.fromRGB(255,35,45),Dark=Color3.fromRGB(35,0,5),Kind='Star'},
    {Name='TriBlade',Main=Color3.fromRGB(255,55,45),Dark=Color3.fromRGB(35,0,5),Kind='Tri'},
    {Name='Crimson6',Main=Color3.fromRGB(255,20,30),Dark=Color3.fromRGB(25,0,0),Kind='Star6'},
    {Name='Cosmic',Main=Color3.fromRGB(70,170,255),Dark=Color3.fromRGB(10,30,70),Kind='Cosmic'},
    {Name='Violet',Main=Color3.fromRGB(180,60,255),Dark=Color3.fromRGB(35,5,65),Kind='Hex'},
    {Name='Orange',Main=Color3.fromRGB(255,100,25),Dark=Color3.fromRGB(50,15,0),Kind='Triple'},
    {Name='Void',Main=Color3.fromRGB(110,100,140),Dark=Color3.fromRGB(8,8,15),Kind='Void'},
    {Name='Spiral',Main=Color3.fromRGB(255,40,100),Dark=Color3.fromRGB(40,0,15),Kind='Spiral'},
}
local EyeIndex=1
local EyeBusy=false
local EyeOpen=false
local EyeLastMenuState=false
local EyeSpinA=0
local EyeSpinB=0
local EyeSpinC=0
local EyeRotationConn=nil
local EyeMorphToken=0

local function clearEyeMarks()
    for _,x in ipairs(EyeMarks) do if x and x.Parent then x:Destroy() end end
    table.clear(EyeMarks)
end
local function eyeLine(parent,angle,length,width,color)
    local l=Instance.new('Frame')
    l.AnchorPoint=Vector2.new(.5,.5); l.Position=UDim2.fromScale(.5,.5)
    l.Size=UDim2.fromOffset(length,width); l.Rotation=angle
    l.BackgroundColor3=color; l.BorderSizePixel=0; l.ZIndex=15; l.Parent=parent
    table.insert(EyeMarks,l); return l
end
local function eyeDot(parent,x,y,size,color)
    local d=Instance.new('Frame')
    d.AnchorPoint=Vector2.new(.5,.5); d.Position=UDim2.fromScale(x,y)
    d.Size=UDim2.fromOffset(size,size); d.BackgroundColor3=color; d.BorderSizePixel=0; d.ZIndex=16; d.Parent=parent
    local c=Instance.new('UICorner'); c.CornerRadius=UDim.new(1,0); c.Parent=d
    table.insert(EyeMarks,d); return d
end
local function buildEyeMarks(data)
    clearEyeMarks()
    local c=data.Dark
    if data.Kind=='Tomoe' then
        for i=1,3 do local a=math.rad((i-1)*120); eyeDot(EyeSymbol,.5+math.cos(a)*.28,.5+math.sin(a)*.28,8,c); eyeLine(EyeSymbol,math.deg(a)+35,20,5,c) end
    elseif data.Kind=='Rings' then
        for i=1,4 do local r=Instance.new('Frame'); r.AnchorPoint=Vector2.new(.5,.5); r.Position=UDim2.fromScale(.5,.5); r.Size=UDim2.fromScale(.16+i*.12,.16+i*.12); r.BackgroundTransparency=1; r.ZIndex=15; r.Parent=EyeSymbol; local s=Instance.new('UIStroke'); s.Thickness=1.2; s.Color=c; s.Parent=r; local q=Instance.new('UICorner'); q.CornerRadius=UDim.new(1,0); q.Parent=r; table.insert(EyeMarks,r) end
        for i=1,6 do local a=math.rad((i-1)*60); eyeDot(EyeSymbol,.5+math.cos(a)*.31,.5+math.sin(a)*.31,5,data.Main) end
    elseif data.Kind=='Star' then for i=1,6 do eyeLine(EyeSymbol,(i-1)*60,50,7,c) end
    elseif data.Kind=='Tri' then for i=1,3 do eyeLine(EyeSymbol,(i-1)*120,50,8,c) end
    elseif data.Kind=='Star6' then for i=1,6 do eyeLine(EyeSymbol,(i-1)*30,52,7,c) end
    elseif data.Kind=='Cosmic' then for i=1,8 do local a=math.rad((i-1)*45); eyeLine(EyeSymbol,(i-1)*45,48,3,c); eyeDot(EyeSymbol,.5+math.cos(a)*.29,.5+math.sin(a)*.29,6,data.Main) end
    elseif data.Kind=='Hex' then for i=1,6 do local a=math.rad((i-1)*60); eyeLine(EyeSymbol,(i-1)*60,42,5,c); eyeDot(EyeSymbol,.5+math.cos(a)*.26,.5+math.sin(a)*.26,8,c) end
    elseif data.Kind=='Triple' then for i=1,3 do eyeLine(EyeSymbol,(i-1)*120,46,9,c) end
    elseif data.Kind=='Void' then for i=1,8 do eyeLine(EyeSymbol,(i-1)*45,48,3,data.Main) end
    elseif data.Kind=='Spiral' then for i=1,7 do local a=(i-1)*48; local l=eyeLine(EyeSymbol,a,20+i*4,4,c); l.Position=UDim2.fromScale(.5+math.cos(math.rad(a))*.1,.5+math.sin(math.rad(a))*.1) end end
end
local function applyEyeColors(data,duration)
    local ti=TweenInfo.new(duration,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
    for _,p in ipairs({{EyeBase,data.Dark},{EyeRing1,data.Dark},{EyeRing2,data.Main},{EyeIris,data.Main},{EyeGlow,data.Main},{EyeGlow2,data.Main},{EyeBaseStroke,data.Main},{EyeRingStroke,data.Main}}) do
        TweenService:Create(p[1],ti,{[p[1]:IsA('UIStroke') and 'Color' or 'BackgroundColor3']=p[2]}):Play()
    end
end
local function startEyeRotation()
    if EyeRotationConn then EyeRotationConn:Disconnect() end
    EyeRotationConn=RunService.RenderStepped:Connect(function(dt)
        if not EyeOpen then return end
        EyeSpinA=(EyeSpinA+dt*20)%360; EyeSpinB=(EyeSpinB-dt*32)%360; EyeSpinC=(EyeSpinC+dt*46)%360
        EyeOuter.Rotation=EyeSpinA; EyeInner.Rotation=EyeSpinB; EyeSymbol.Rotation=EyeSpinC
    end)
end
local function stopEyeRotation()
    if EyeRotationConn then EyeRotationConn:Disconnect(); EyeRotationConn=nil end
end
local function openEye()
    EyeOpen=true; EyeLayer.Visible=true; OpenButton.TextTransparency=1
    EyeLayer.Size=UDim2.fromScale(.03,.03); buildEyeMarks(EyeTypes[EyeIndex]); applyEyeColors(EyeTypes[EyeIndex],.05); startEyeRotation()
    TweenService:Create(EyeLayer,TweenInfo.new(.7,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.fromScale(.84,.84)}):Play()
end
local function closeEye()
    EyeOpen=false
    TweenService:Create(EyeLayer,TweenInfo.new(.58,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Size=UDim2.fromScale(.02,.02)}):Play()
    task.delay(.5,function() stopEyeRotation(); EyeLayer.Visible=false; OpenButton.Text='Z'; TweenService:Create(OpenButton,TweenInfo.new(.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{TextTransparency=0}):Play() end)
end
local function morphEye()
    if EyeBusy or not EyeOpen then return end
    EyeBusy=true; EyeMorphToken+=1; local token=EyeMorphToken
    local nextIndex
    repeat nextIndex=math.random(1,#EyeTypes) until nextIndex~=EyeIndex
    local spinTween=TweenService:Create(EyeSymbol,TweenInfo.new(1.1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Rotation=EyeSymbol.Rotation+360})
    spinTween:Play()
    spinTween.Completed:Wait()
    if token~=EyeMorphToken or not EyeOpen then EyeBusy=false; return end
    applyEyeColors(EyeTypes[nextIndex],1.45)
    for _,x in ipairs(EyeMarks) do if x:IsA('Frame') then TweenService:Create(x,TweenInfo.new(.65,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency=1}):Play() end end
    task.wait(.55)
    if not EyeOpen then EyeBusy=false; return end
    EyeIndex=nextIndex; buildEyeMarks(EyeTypes[EyeIndex])
    for _,x in ipairs(EyeMarks) do if x:IsA('Frame') then x.BackgroundTransparency=1; TweenService:Create(x,TweenInfo.new(.8,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{BackgroundTransparency=0}):Play() end end
    EyeBusy=false
end

-- Smooth rainbow hue around the menu border.
local V1RainbowHue=0
local V1VisualConn
V1VisualConn=RunService.RenderStepped:Connect(function(dt)
    V1RainbowHue=(V1RainbowHue+dt*.10)%1
    local c=Color3.fromHSV(V1RainbowHue,.92,1)
    V1RainbowStroke.Color=c
    if not EyeOpen then OpenButton.TextColor3=c end
    local fast=os.clock()<SideEyeBoostUntil
    local speed=fast and 145 or 18
    for _,eye in pairs(SideEyes) do
        eye.Angle=(eye.Angle+dt*speed)%360
        eye.Outer.Rotation=eye.Angle
        eye.Ring.Rotation=-eye.Angle*1.35
        eye.Iris.Rotation=eye.Angle*1.9
    end
end)

-- Poll Config.Open so the existing menu event handlers remain untouched.
task.spawn(function()
    while Gui.Parent do
        local state=Config.Open==true
        if state and not EyeLastMenuState then openEye() end
        if not state and EyeLastMenuState then closeEye() end
        EyeLastMenuState=state
        if state and not EyeBusy then
            -- 5-second morph cycle is handled below.
        end
        task.wait(.05)
    end
end)

task.spawn(function()
    while Gui.Parent do
        task.wait(5)
        if Config.Open and EyeOpen then morphEye() end
    end
end)

-- Make the visual button match the finished V1 style.
OpenButton.BackgroundTransparency=.04
OpenButton.Size=UDim2.fromOffset(64,64)
corner(OpenButton,999)


--==========================================================
-- INITIALIZE
--==========================================================
Title.Text=uiText("Title")
Subtitle.Text=uiText("Subtitle")
Search.PlaceholderText=uiText("Search")
LangBtn.Text=uiText("Language")
applyCharacterSettings()
setGlow(Config.UIGlow)
showTab("Combat")
refreshCarousel()

task.defer(function()
    task.wait(.25)
    notify("ZAKA PURE V1 • Đã tải "..tostring(#Features).." chức năng")
end)
