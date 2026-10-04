--==============================================================
-- ZAKA PINK UI V17 • LIQUID GLASS / SMART DRAG / ZAKA AI
-- UI + local AI shell only.
--
-- Design goals:
--   * 8 tabs on the left edge
--   * functions on the right edge
--   * center = ZAKA AI workspace
--   * the whole menu moves as ONE object
--   * launcher becomes small when the menu is closed
--   * no image, no Pink Panther asset, no droplet asset
--   * smooth glass / spring / ripple / stagger animations
--
-- ZAKA AI:
--   This build contains a full chat/code/tools interface and a
--   backend hook. A real online model still requires a backend/API.
--   Put your own permitted backend function in:
--       _G.ZAKA_AI_BACKEND = function(payload) return "..." end
--   The UI never executes AI-generated code automatically.
--==============================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Run = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local old = PlayerGui:FindFirstChild("ZAKA_PINK_UI_V17")
if old then old:Destroy() end

-- ---------- Theme ----------
local C = {
    Pink0 = Color3.fromRGB(255, 211, 232),
    Pink1 = Color3.fromRGB(255, 164, 205),
    Pink2 = Color3.fromRGB(245, 91, 164),
    Pink3 = Color3.fromRGB(207, 48, 119),
    Deep  = Color3.fromRGB(73, 12, 43),
    Ink   = Color3.fromRGB(41, 8, 27),
    White = Color3.fromRGB(255, 249, 253),
    Soft  = Color3.fromRGB(255, 222, 238),
    Muted = Color3.fromRGB(255, 190, 216),
}

local TABS = {
    "COMBAT","ESP","PLAYER","TROLL","ULTRA","SERVER","SETTING","HOME"
}

local ICONS = {"⚔","◉","♙","☄","✦","◎","⚙","⌂"}

local DATA = {
    COMBAT = {"Aim UI","Target List","FOV Preview","Hitbox Preview","Crosshair","Combat Layout","Sensitivity","Keybind","Indicator","Preset","Reset Card","Info"},
    ESP    = {"Player List","NPC List","Name Tags","Distance","Health Bar","Boxes","Tracers","Highlight","Color","Range","Preview","Reset Card"},
    PLAYER  = {"Movement UI","Camera","FOV","Jump Preview","Speed Preview","Touch Pad","View Info","State","Scale","Layout","Preset","Reset Card"},
    TROLL   = {"Fun Button","Effect Preview","Sound UI","Emote UI","Spin UI","Screen FX","Popup","Color FX","Shake","Randomizer","Preset","Reset Card"},
    ULTRA   = {"Performance","FPS View","Memory View","Quality","Particles","Glow","Blur","Motion","Shadows","Density","Preset","Reset Card"},
    SERVER  = {"Server Info","Ping View","Region","Job ID","Players","Clock","Session","Refresh","Copy UI","Status","Preset","Reset Card"},
    SETTING = {"Theme","Transparency","Glow","Animation","Touch","Sound","Card Style","Tab Style","Scale","Compact","Search","Reset All"},
    HOME    = {"Overview","Quick Toggle","UI Status","Theme","Animations","Touch Mode","Card Count","Tab Count","Scale","Search","Credits","Reset All"},
}

local MODES = {"CHAT","CODE","TOOLS","EXPLAIN","DEBUG","BRAINSTORM"}

-- ---------- Helpers ----------
local function frame(parent,name,size,pos,color,transparency,z)
    local x = Instance.new("Frame")
    x.Name = name
    x.Size = size
    x.Position = pos
    x.BackgroundColor3 = color or C.Pink2
    x.BackgroundTransparency = transparency == nil and 0 or transparency
    x.BorderSizePixel = 0
    x.ZIndex = z or 1
    x.Parent = parent
    return x
end

local function button(parent,name,size,pos,z)
    local x = Instance.new("TextButton")
    x.Name = name
    x.Size = size
    x.Position = pos
    x.Text = ""
    x.AutoButtonColor = false
    x.BackgroundColor3 = C.Pink1
    x.BackgroundTransparency = .38
    x.BorderSizePixel = 0
    x.ZIndex = z or 10
    x.Parent = parent
    return x
end

local function label(parent,name,size,pos,text,sizeText,color,z)
    local x = Instance.new("TextLabel")
    x.Name = name
    x.Size = size
    x.Position = pos
    x.BackgroundTransparency = 1
    x.Text = text or ""
    x.TextSize = sizeText or 10
    x.Font = Enum.Font.GothamBold
    x.TextColor3 = color or C.White
    x.TextXAlignment = Enum.TextXAlignment.Left
    x.TextYAlignment = Enum.TextYAlignment.Center
    x.ZIndex = z or 20
    x.Parent = parent
    return x
end

local function corner(x,r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,r)
    c.Parent = x
    return c
end

local function stroke(x,color,thickness,transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or C.Pink0
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = x
    return s
end

local function scaleOf(x,v)
    local s = x:FindFirstChild("ZScale")
    if not s then
        s = Instance.new("UIScale")
        s.Name = "ZScale"
        s.Parent = x
    end
    s.Scale = v
    return s
end

local function tween(x,d,goal,style,direction)
    local info = TweenInfo.new(
        d,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )
    local t = TS:Create(x,info,goal)
    t:Play()
    return t
end

local function glass(x,alpha)
    local g = Instance.new("UIGradient")
    g.Name = "GlassGradient"
    g.Rotation = 16
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,C.Pink0),
        ColorSequenceKeypoint.new(.22,C.Pink1),
        ColorSequenceKeypoint.new(.50,C.Pink2),
        ColorSequenceKeypoint.new(.78,C.Pink1),
        ColorSequenceKeypoint.new(1,C.Pink0),
    })
    g.Transparency = NumberSequence.new(alpha or .84)
    g.Parent = x
    return g
end

local function centerText(x)
    x.TextXAlignment = Enum.TextXAlignment.Center
    x.TextYAlignment = Enum.TextYAlignment.Center
end

-- ---------- Root ----------
local GUI = Instance.new("ScreenGui")
GUI.Name = "ZAKA_PINK_UI_V17"
GUI.IgnoreGuiInset = true
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.DisplayOrder = 999
GUI.Parent = PlayerGui

local Root = frame(GUI,"Root",UDim2.fromScale(1,1),UDim2.fromScale(0,0),C.Pink2,1,1)

-- ---------- Launcher ----------
local Launcher = button(Root,"Launcher",UDim2.fromOffset(60,60),UDim2.fromScale(.06,.50),500)
Launcher.AnchorPoint = Vector2.new(.5,.5)
Launcher.BackgroundColor3 = C.Pink2
Launcher.BackgroundTransparency = .02
corner(Launcher,30)
stroke(Launcher,C.Pink0,2,.18)
local LauncherGlow = frame(Launcher,"Glow",UDim2.fromScale(.72,.72),UDim2.fromScale(.14,.14),C.Pink0,1,501)
corner(LauncherGlow,50)
stroke(LauncherGlow,C.Pink0,2,.35)
local LauncherText = label(Launcher,"Z",UDim2.fromScale(1,1),UDim2.fromScale(0,0),"Z",24,C.White,505)
centerText(LauncherText)

-- ---------- Main menu ----------
local Menu = frame(
    Root,"Menu",
    UDim2.fromScale(.88,.80),
    UDim2.fromScale(.50,.50),
    C.Pink2,.22,100
)
Menu.AnchorPoint = Vector2.new(.5,.5)
Menu.ClipsDescendants = true
corner(Menu,34)
local MenuStroke = stroke(Menu,C.Pink0,2,.20)
local MenuGradient = glass(Menu,.86)
local MenuScale = scaleOf(Menu,1)

-- Soft internal highlight, never full-screen.
local Shine = frame(Menu,"Shine",UDim2.fromScale(.10,.72),UDim2.fromScale(-.16,.12),C.White,.90,101)
corner(Shine,20)
local ShineGradient = Instance.new("UIGradient")
ShineGradient.Rotation = 14
ShineGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0,1),
    NumberSequenceKeypoint.new(.45,.10),
    NumberSequenceKeypoint.new(.55,.10),
    NumberSequenceKeypoint.new(1,1),
})
ShineGradient.Parent = Shine

-- ---------- Header (attached to Menu, never moves independently) ----------
local Header = frame(Menu,"Header",UDim2.fromScale(.94,.145),UDim2.fromScale(.03,.035),C.Pink3,.30,120)
corner(Header,25)
stroke(Header,C.White,1,.66)
local HeaderGradient = glass(Header,.84)

local Brand = label(Header,"Brand",UDim2.fromScale(.14,.70),UDim2.fromScale(.025,.15),"ZAKA",10,C.Soft,125)
local Title = label(Header,"Title",UDim2.fromScale(.50,.72),UDim2.fromScale(.20,.08),"PINK CONTROL",18,C.White,125)
centerText(Title)

local Search = Instance.new("TextBox")
Search.Name = "Search"
Search.Size = UDim2.fromScale(.22,.48)
Search.Position = UDim2.fromScale(.69,.26)
Search.BackgroundColor3 = C.White
Search.BackgroundTransparency = .84
Search.Text = ""
Search.PlaceholderText = "⌕ Search"
Search.PlaceholderColor3 = C.Soft
Search.TextColor3 = C.White
Search.TextSize = 9
Search.Font = Enum.Font.GothamMedium
Search.BorderSizePixel = 0
Search.ClearTextOnFocus = false
Search.ZIndex = 130
Search.Parent = Header
corner(Search,16)
stroke(Search,C.White,1,.72)

local Close = button(Header,"Close",UDim2.fromOffset(34,34),UDim2.fromScale(.945,.20),140)
Close.BackgroundColor3 = C.Deep
Close.BackgroundTransparency = .08
corner(Close,18)
local CloseText = label(Close,"X",UDim2.fromScale(1,1),UDim2.fromScale(0,0),"×",19,C.White,145)
centerText(CloseText)

-- ---------- Body ----------
local Body = frame(Menu,"Body",UDim2.fromScale(.94,.775),UDim2.fromScale(.03,.205),C.Pink2,.60,110)
corner(Body,28)
stroke(Body,C.White,1,.82)
glass(Body,.91)

local Left = frame(Body,"TabsRail",UDim2.fromScale(.205,.91),UDim2.fromScale(.018,.045),C.Deep,.45,115)
corner(Left,23)
stroke(Left,C.Pink0,1,.58)
glass(Left,.86)

local Center = frame(Body,"Center",UDim2.fromScale(.50,.91),UDim2.fromScale(.25,.045),C.Pink2,.77,116)
corner(Center,27)
stroke(C.White,1,.84)
glass(Center,.92)

local Right = frame(Body,"FunctionsRail",UDim2.fromScale(.255,.91),UDim2.fromScale(.73,.045),C.Deep,.45,115)
corner(Right,23)
stroke(Right,C.Pink0,1,.58)
glass(Right,.86)

local LeftTitle = label(Left,"Title",UDim2.fromScale(.80,.055),UDim2.fromScale(.10,.025),"TABS",8,C.Soft,125)
local RightTitle = label(Right,"Title",UDim2.fromScale(.82,.055),UDim2.fromScale(.09,.025),"FUNCTIONS",8,C.Soft,125)

-- ---------- Center AI workspace ----------
local AI = frame(Center,"ZAKA_AI",UDim2.fromScale(.92,.92),UDim2.fromScale(.04,.04),C.Pink2,.66,126)
corner(AI,24)
stroke(AI,C.Pink0,1,.72)

local AIHead = label(AI,"AIHead",UDim2.fromScale(.84,.065),UDim2.fromScale(.08,.018),"ZAKA AI",13,C.White,130)
centerText(AIHead)
local AISub = label(AI,"AISub",UDim2.fromScale(.86,.05),UDim2.fromScale(.07,.075),"CHAT • CODE • TOOLS • SMART MODES",7,C.Soft,130)
centerText(AISub)

-- Mode row
local ModeRow = frame(AI,"ModeRow",UDim2.fromScale(.90,.08),UDim2.fromScale(.05,.13),C.Pink3,.72,128)
corner(ModeRow,15)

local ModeButtons = {}
local CurrentMode = 1

local function modeButton(i,name)
    local b = button(ModeRow,"Mode"..i,UDim2.new(1/#MODES,-5,1,-8),UDim2.new((i-1)/#MODES,3,0,4),132)
    corner(b,12)
    b.BackgroundColor3 = C.Pink1
    b.BackgroundTransparency = .72
    local tx = label(b,"Text",UDim2.fromScale(.96,.86),UDim2.fromScale(.02,.07),name,7,C.Soft,136)
    centerText(tx)
    ModeButtons[i] = {button=b,label=tx}
    return b
end

for i,n in ipairs(MODES) do modeButton(i,n) end

-- Chat / Code / Tools pages
local Pages = {}
for i,n in ipairs(MODES) do
    local page = frame(AI,n.."Page",UDim2.fromScale(.90,.65),UDim2.fromScale(.05,.225),C.Pink3,.86,127)
    corner(page,19)
    stroke(page,C.White,1,.88)
    Pages[i] = page
end

-- Chat page
local Chat = Instance.new("ScrollingFrame")
Chat.Name = "Chat"
Chat.Size = UDim2.fromScale(.92,.66)
Chat.Position = UDim2.fromScale(.04,.04)
Chat.BackgroundColor3 = C.Ink
Chat.BackgroundTransparency = .48
Chat.BorderSizePixel = 0
Chat.ScrollBarThickness = 2
Chat.ScrollBarImageColor3 = C.Pink0
Chat.AutomaticCanvasSize = Enum.AutomaticSize.Y
Chat.CanvasSize = UDim2.new()
Chat.ZIndex = 130
Chat.Parent = Pages[1]
corner(Chat,17)

local ChatLayout = Instance.new("UIListLayout")
ChatLayout.Padding = UDim.new(0,7)
ChatLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ChatLayout.Parent = Chat

local function bubble(textValue,isUser)
    local b = frame(
        Chat,"Bubble",
        UDim2.new(.90,0,0,44),
        UDim2.new(),
        isUser and C.Pink2 or C.Deep,
        isUser and .18 or .24,
        131
    )
    corner(b,15)
    stroke(b,C.Pink0,1,.84)
    local tx = label(b,"Text",UDim2.fromScale(.92,.84),UDim2.fromScale(.04,.08),textValue,8,C.White,132)
    tx.TextWrapped = true
    tx.TextYAlignment = Enum.TextYAlignment.Center
    return b
end

bubble("Xin chào 👋 Mình là ZAKA AI. Chọn CHAT/CODE/TOOLS hoặc nhập câu hỏi.",false)

local Prompt = Instance.new("TextBox")
Prompt.Name = "Prompt"
Prompt.Size = UDim2.fromScale(.72,.20)
Prompt.Position = UDim2.fromScale(.04,.73)
Prompt.BackgroundColor3 = C.White
Prompt.BackgroundTransparency = .84
Prompt.Text = ""
Prompt.PlaceholderText = "Hỏi ZAKA AI…"
Prompt.PlaceholderColor3 = C.Soft
Prompt.TextColor3 = C.White
Prompt.TextSize = 9
Prompt.Font = Enum.Font.GothamMedium
Prompt.ClearTextOnFocus = false
Prompt.MultiLine = true
Prompt.TextWrapped = true
Prompt.ZIndex = 135
Prompt.Parent = Pages[1]
corner(Prompt,15)
stroke(Prompt,C.White,1,.76)

local Send = button(Pages[1],"Send",UDim2.fromScale(.19,.20),UDim2.fromScale(.77,.73),136)
Send.BackgroundColor3 = C.Pink1
Send.BackgroundTransparency = .14
corner(Send,15)
local SendText = label(Send,"Text",UDim2.fromScale(1,1),UDim2.fromScale(0,0),"SEND",8,C.White,140)
centerText(SendText)

-- Code page
local CodeTitle = label(Pages[2],"Title",UDim2.fromScale(.88,.06),UDim2.fromScale(.06,.025),"LONG-FORM CODE WORKSPACE",9,C.White,130)
local CodeBox = Instance.new("TextBox")
CodeBox.Name = "CodeBox"
CodeBox.Size = UDim2.fromScale(.88,.72)
CodeBox.Position = UDim2.fromScale(.06,.105)
CodeBox.BackgroundColor3 = C.Ink
CodeBox.BackgroundTransparency = .30
CodeBox.Text = "-- ZAKA AI CODE WORKSPACE\n-- Paste or generate long-form code here.\n"
CodeBox.PlaceholderText = "Long-form code…"
CodeBox.PlaceholderColor3 = C.Soft
CodeBox.TextColor3 = C.White
CodeBox.TextSize = 8
CodeBox.Font = Enum.Font.Code
CodeBox.ClearTextOnFocus = false
CodeBox.MultiLine = true
CodeBox.TextWrapped = false
CodeBox.TextXAlignment = Enum.TextXAlignment.Left
CodeBox.TextYAlignment = Enum.TextYAlignment.Top
CodeBox.ZIndex = 131
CodeBox.Parent = Pages[2]
corner(CodeBox,15)
stroke(CodeBox,C.Pink0,1,.82)

local CodeHint = label(Pages[2],"Hint",UDim2.fromScale(.88,.10),UDim2.fromScale(.06,.84),
    "Không tự chạy code AI. Dùng ô này để soạn, xem và chỉnh code dài.",7,C.Soft,132)
CodeHint.TextWrapped = true

-- Tools page
local ToolTitle = label(Pages[3],"Title",UDim2.fromScale(.88,.07),UDim2.fromScale(.06,.03),"ZAKA UTILITIES",11,C.White,130)
local ToolList = {
    "Prompt Builder",
    "Text Counter",
    "JSON Notes",
    "Lua Notes",
    "Code Checklist",
    "Session Info",
}
for i,n in ipairs(ToolList) do
    local b = button(Pages[3],"Tool"..i,UDim2.fromScale(.88,.085),UDim2.fromScale(.06,.12+(i-1)*.105),132)
    corner(b,13)
    b.BackgroundColor3 = C.Pink1
    b.BackgroundTransparency = .62
    local tx = label(b,"Text",UDim2.fromScale(.90,1),UDim2.fromScale(.05,0),n,8,C.Soft,135)
    centerText(tx)
end

-- Explain / Debug / Brainstorm pages use a shared long-form area.
for i = 4,6 do
    local title = (i == 4 and "EXPLAIN MODE") or (i == 5 and "DEBUG MODE") or "BRAINSTORM MODE"
    local info = (i == 4 and "Dán nội dung vào Prompt để nhận giải thích có cấu trúc.") or
                 (i == 5 and "Dán lỗi + code vào Prompt để backend AI phân tích.") or
                 "Dùng Prompt để mở rộng ý tưởng, kế hoạch hoặc kiến trúc."
    local t = label(Pages[i],"Title",UDim2.fromScale(.88,.07),UDim2.fromScale(.06,.04),title,11,C.White,130)
    centerText(t)
    local d = label(Pages[i],"Info",UDim2.fromScale(.88,.20),UDim2.fromScale(.06,.14),info,8,C.Soft,130)
    d.TextWrapped = true
end

-- Center Z button
local ZButton = button(Center,"ZButton",UDim2.fromOffset(82,82),UDim2.fromScale(.50,.90),150)
ZButton.AnchorPoint = Vector2.new(.5,.5)
ZButton.BackgroundColor3 = C.Pink1
ZButton.BackgroundTransparency = .04
corner(ZButton,41)
stroke(ZButton,C.Pink0,2,.12)
local ZText = label(ZButton,"Z",UDim2.fromScale(1,1),UDim2.fromScale(0,0),"Z",28,C.White,155)
centerText(ZText)

local Status = label(Center,"Status",UDim2.fromScale(.76,.055),UDim2.fromScale(.12,.95),"READY • ZAKA AI",7,C.Soft,130)
centerText(Status)

-- ---------- Rails ----------
local Tabs = Instance.new("ScrollingFrame")
Tabs.Name = "Tabs"
Tabs.Size = UDim2.fromScale(.86,.84)
Tabs.Position = UDim2.fromScale(.07,.11)
Tabs.BackgroundTransparency = 1
Tabs.BorderSizePixel = 0
Tabs.ScrollBarThickness = 0
Tabs.ScrollingDirection = Enum.ScrollingDirection.Y
Tabs.AutomaticCanvasSize = Enum.AutomaticSize.Y
Tabs.CanvasSize = UDim2.new()
Tabs.ZIndex = 122
Tabs.Parent = Left

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0,7)
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.Parent = Tabs

local Funcs = Instance.new("ScrollingFrame")
Funcs.Name = "Functions"
Funcs.Size = UDim2.fromScale(.86,.84)
Funcs.Position = UDim2.fromScale(.07,.11)
Funcs.BackgroundTransparency = 1
Funcs.BorderSizePixel = 0
Funcs.ScrollBarThickness = 0
Funcs.ScrollingDirection = Enum.ScrollingDirection.Y
Funcs.AutomaticCanvasSize = Enum.AutomaticSize.Y
Funcs.CanvasSize = UDim2.new()
Funcs.ZIndex = 122
Funcs.Parent = Right

local FuncLayout = Instance.new("UIListLayout")
FuncLayout.Padding = UDim.new(0,7)
FuncLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
FuncLayout.Parent = Funcs

local tabButtons, tabLabels = {}, {}
local funcButtons, funcLabels = {}, {}
local currentTab = 1
local currentFunc = 1
local isOpen = true
local animBusy = false

-- ---------- Animation ----------
local function ripple(btn,pos)
    if not btn or not btn.Parent then return end
    local ap = btn.AbsolutePosition
    local as = btn.AbsoluteSize
    local px = (pos and pos.X or ap.X + as.X/2) - ap.X
    local py = (pos and pos.Y or ap.Y + as.Y/2) - ap.Y

    local r = frame(btn,"Ripple",UDim2.fromOffset(10,10),UDim2.fromOffset(px-5,py-5),C.White,.72,btn.ZIndex+5)
    corner(r,50)
    local rs = scaleOf(r,.15)
    tween(r,.34,{BackgroundTransparency=1},Enum.EasingStyle.Quad)
    tween(rs,.34,{Scale=8},Enum.EasingStyle.Quart)
    task.delay(.38,function()
        if r.Parent then r:Destroy() end
    end)
end

local function press(btn)
    if not btn or not btn.Parent then return end
    local s = scaleOf(btn,1)
    tween(s,.07,{Scale=.94},Enum.EasingStyle.Quad)
    task.delay(.075,function()
        if s.Parent then
            tween(s,.16,{Scale=1.055},Enum.EasingStyle.Back)
            task.delay(.10,function()
                if s.Parent then tween(s,.12,{Scale=1},Enum.EasingStyle.Quint) end
            end)
        end
    end)
end

local function bindTouch(btn)
    btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            ripple(btn,i.Position)
            press(btn)
        end
    end)
end

-- ---------- Tabs / Functions ----------
local function refreshFunctions()
    for _,b in ipairs(funcButtons) do
        if b then b:Destroy() end
    end
    funcButtons,funcLabels = {},{}
    local list = DATA[TABS[currentTab]]

    for i,n in ipairs(list) do
        local b = button(Funcs,"Func"..i,UDim2.new(.88,0,0,44),UDim2.new(),124)
        b.LayoutOrder = i
        b.BackgroundColor3 = C.Pink1
        b.BackgroundTransparency = .68
        corner(b,15)
        stroke(b,C.Pink0,1,.82)

        local dot = frame(b,"Dot",UDim2.fromOffset(6,6),UDim2.fromScale(.035,.43),C.Pink0,.02,130)
        corner(dot,5)

        local tx = label(b,"Text",UDim2.fromScale(.78,.80),UDim2.fromScale(.12,.10),n,8,C.Soft,130)
        tx.TextWrapped = true

        funcButtons[i] = b
        funcLabels[i] = tx
        bindTouch(b)

        b.Activated:Connect(function()
            currentFunc = i
            for k,x in ipairs(funcButtons) do
                local on = k == currentFunc
                tween(x,.18,{BackgroundTransparency=on and .14 or .68},Enum.EasingStyle.Quint)
                tween(scaleOf(x,1),.18,{Scale=on and 1.045 or 1},Enum.EasingStyle.Back)
                if funcLabels[k] then
                    funcLabels[k].TextColor3 = on and C.White or C.Soft
                end
            end
            Status.Text = "FUNCTION • "..list[currentFunc]
        end)

        -- Stagger entrance
        scaleOf(b,.88)
        task.delay(i*.025,function()
            if b.Parent then
                tween(scaleOf(b,.88),.22,{Scale=1},Enum.EasingStyle.Back)
                tween(b,.22,{BackgroundTransparency=.68},Enum.EasingStyle.Quint)
            end
        end)
    end

    currentFunc = math.clamp(currentFunc,1,#list)
    for k,x in ipairs(funcButtons) do
        local on = k == currentFunc
        x.BackgroundTransparency = on and .14 or .68
        scaleOf(x,on and 1.045 or 1)
        if funcLabels[k] then
            funcLabels[k].TextColor3 = on and C.White or C.Soft
        end
    end
    Status.Text = "TAB • "..TABS[currentTab].."   •   "..list[currentFunc]
end

local function selectTab(i)
    currentTab = math.clamp(i,1,#TABS)
    currentFunc = 1
    local name = TABS[currentTab]

    for k,b in ipairs(tabButtons) do
        local on = k == currentTab
        tween(b,.20,{BackgroundTransparency=on and .10 or .68},Enum.EasingStyle.Quint)
        tween(scaleOf(b,1),.20,{Scale=on and 1.055 or 1},Enum.EasingStyle.Back)
        if tabLabels[k] then
            tabLabels[k].TextColor3 = on and C.White or C.Soft
        end
    end

    refreshFunctions()
    Status.Text = "TAB • "..name
end

for i,name in ipairs(TABS) do
    local b = button(Tabs,"Tab"..i,UDim2.new(.88,0,0,39),UDim2.new(),124)
    b.LayoutOrder = i
    b.BackgroundColor3 = C.Pink1
    b.BackgroundTransparency = .68
    corner(b,16)
    stroke(b,C.Pink0,1,.82)

    local icon = label(b,"Icon",UDim2.fromScale(.20,.82),UDim2.fromScale(.03,.09),ICONS[i],12,C.Soft,130)
    centerText(icon)

    local tx = label(b,"Text",UDim2.fromScale(.70,.82),UDim2.fromScale(.25,.09),name,8,C.Soft,130)
    tabButtons[i] = b
    tabLabels[i] = tx
    bindTouch(b)

    b.Activated:Connect(function()
        selectTab(i)
    end)

    scaleOf(b,.90)
    task.delay(i*.03,function()
        if b.Parent then tween(scaleOf(b,.90),.24,{Scale=1},Enum.EasingStyle.Back) end
    end)
end

-- ---------- Smart vertical rail drag ----------
local function railGesture(obj,count,getIndex,setIndex,stepPx)
    local active = false
    local startY = 0
    local lastStep = 0

    obj.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            active = true
            startY = i.Position.Y
            lastStep = 0
        end
    end)

    UIS.InputChanged:Connect(function(i)
        if not active then return end
        if i.UserInputType ~= Enum.UserInputType.Touch and i.UserInputType ~= Enum.UserInputType.MouseMovement then return end

        local dy = i.Position.Y - startY
        local step = math.floor(math.abs(dy)/stepPx)

        if step > lastStep then
            local idx = getIndex()
            idx = math.clamp(idx + (dy < 0 and 1 or -1),1,count)
            setIndex(idx)
            lastStep = step
        end
    end)

    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            active = false
        end
    end)
end

railGesture(Tabs,#TABS,function() return currentTab end,selectTab,42)

-- Function rail count changes with the selected tab.
local function functionRailGesture()
    local active = false
    local startY = 0
    local lastStep = 0

    Funcs.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            active = true
            startY = i.Position.Y
            lastStep = 0
        end
    end)

    UIS.InputChanged:Connect(function(i)
        if not active then return end
        if i.UserInputType ~= Enum.UserInputType.Touch and i.UserInputType ~= Enum.UserInputType.MouseMovement then return end

        local dy = i.Position.Y - startY
        local step = math.floor(math.abs(dy)/46)
        if step > lastStep then
            local list = DATA[TABS[currentTab]]
            local idx = math.clamp(currentFunc + (dy < 0 and 1 or -1),1,#list)
            currentFunc = idx
            refreshFunctions()
            lastStep = step
        end
    end)

    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            active = false
        end
    end)
end
functionRailGesture()

-- ---------- Search ----------
Search:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower(Search.Text or "")
    for _,b in ipairs(funcButtons) do
        local tx = b:FindFirstChild("Text")
        b.Visible = q == "" or (tx and string.find(string.lower(tx.Text),q,1,true) ~= nil)
    end
end)

-- ---------- Whole menu drag ----------
-- Start from ANY blank area of the menu. Header/body/rails remain attached
-- because they are children of Menu. Vertical drag on a rail is reserved
-- for rail selection; horizontal/blank-area drag moves the whole menu.
local dragging = false
local dragStart
local menuStart

local function inside(guiObject,p)
    local a = guiObject.AbsolutePosition
    local s = guiObject.AbsoluteSize
    return p.X >= a.X and p.X <= a.X+s.X and p.Y >= a.Y and p.Y <= a.Y+s.Y
end

local function setMenuOffset(dx,dy)
    local cam = workspace.CurrentCamera
    local v = cam and cam.ViewportSize or Vector2.new(1000,700)
    local halfW = Menu.AbsoluteSize.X/2
    local halfH = Menu.AbsoluteSize.Y/2

    local x = math.clamp(menuStart.X.Offset + dx,-v.X/2 + 40 + halfW,v.X/2 - 40 - halfW)
    local y = math.clamp(menuStart.Y.Offset + dy,-v.Y/2 + 45 + halfH,v.Y/2 - 45 - halfH)

    Menu.Position = UDim2.new(.5,x,.5,y)
end

Menu.InputBegan:Connect(function(i)
    if i.UserInputType ~= Enum.UserInputType.Touch and i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

    local p = i.Position
    -- If the press is on an editable field or an actual button, let that control receive it.
    if inside(Search,p) or inside(Prompt,p) or inside(CodeBox,p) or inside(Send,p) then return end

    -- Vertical gesture on either rail belongs to the rail.
    if inside(Tabs,p) or inside(Funcs,p) then
        return
    end

    dragging = true
    dragStart = p
    menuStart = Menu.Position
end)

UIS.InputChanged:Connect(function(i)
    if not dragging then return end
    if i.UserInputType ~= Enum.UserInputType.Touch and i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
    local d = i.Position - dragStart
    setMenuOffset(d.X,d.Y)
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Header is an explicit drag handle too.
Header.InputBegan:Connect(function(i)
    if i.UserInputType ~= Enum.UserInputType.Touch and i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    if inside(Search,i.Position) or inside(Close,i.Position) then return end
    dragging = true
    dragStart = i.Position
    menuStart = Menu.Position
end)

-- ---------- Launcher drag ----------
local launchDrag = false
local launchStart
local launchBase

Launcher.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        launchDrag = true
        launchStart = i.Position
        launchBase = Launcher.Position
        ripple(Launcher,i.Position)
        press(Launcher)
    end
end)

UIS.InputChanged:Connect(function(i)
    if not launchDrag then return end
    if i.UserInputType ~= Enum.UserInputType.Touch and i.UserInputType ~= Enum.UserInputType.MouseMovement then return end

    local d = i.Position - launchStart
    local cam = workspace.CurrentCamera
    local v = cam and cam.ViewportSize or Vector2.new(1000,700)
    local r = Launcher.AbsoluteSize.X/2

    local x = math.clamp(launchBase.X.Offset+d.X,-v.X/2+r,v.X/2-r)
    local y = math.clamp(launchBase.Y.Offset+d.Y,-v.Y/2+r,v.Y/2-r)

    Launcher.Position = UDim2.new(.5,x,.5,y)
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        launchDrag = false
    end
end)

-- ---------- Open / Close ----------
local function openMenu()
    if isOpen or animBusy then return end
    animBusy = true
    isOpen = true
    Menu.Visible = true
    Launcher.Visible = false

    MenuScale.Scale = .78
    Menu.BackgroundTransparency = .72
    Menu.Position = UDim2.new(.5,Menu.Position.X.Offset,.5,Menu.Position.Y.Offset+14)

    tween(MenuScale,.46,{Scale=1},Enum.EasingStyle.Back)
    tween(Menu,.46,{BackgroundTransparency=.22,Position=UDim2.new(.5,Menu.Position.X.Offset,.5,Menu.Position.Y.Offset-14)},Enum.EasingStyle.Quint)

    task.delay(.06,function()
        for i,b in ipairs(tabButtons) do
            if b.Parent then
                scaleOf(b,.86)
                task.delay(i*.025,function()
                    if b.Parent then tween(scaleOf(b,.86),.20,{Scale=1},Enum.EasingStyle.Back) end
                end)
            end
        end
    end)

    task.delay(.50,function() animBusy=false end)
end

local function closeMenu()
    if not isOpen or animBusy then return end
    animBusy = true
    isOpen = false

    tween(MenuScale,.24,{Scale=.78},Enum.EasingStyle.Quint)
    tween(Menu,.24,{BackgroundTransparency=.78},Enum.EasingStyle.Quad)

    task.delay(.25,function()
        if not isOpen then
            Menu.Visible = false
            Launcher.Visible = true
            local s = scaleOf(Launcher,.78)
            tween(s,.30,{Scale=1},Enum.EasingStyle.Back)
        end
        animBusy=false
    end)
end

Close.Activated:Connect(function()
    ripple(Close)
    press(Close)
    closeMenu()
end)

ZButton.Activated:Connect(function()
    ripple(ZButton)
    press(ZButton)
    closeMenu()
end)

-- ---------- AI backend ----------
-- A permitted external backend can be connected by assigning:
-- _G.ZAKA_AI_BACKEND = function(payload) return "answer text" end
-- Payload fields:
--   prompt, mode, tab, functionName, code
--
-- The UI never executes returned code.
local function localAI(q,mode)
    q = q or ""
    local low = string.lower(q)

    if q == "" then
        return "Hãy nhập câu hỏi trước nhé."
    end

    if mode == "CODE" then
        return "CODE MODE: mình có thể nhận yêu cầu dài, chia file thành từng phần, giải thích từng đoạn và trả về code dạng văn bản. Bản UI này không tự chạy code do AI tạo."
    elseif mode == "DEBUG" then
        return "DEBUG MODE: gửi lỗi + đoạn code + hành vi mong đợi. ZAKA sẽ ưu tiên tìm lỗi cú pháp, lỗi logic và lỗi runtime theo từng bước."
    elseif mode == "EXPLAIN" then
        return "EXPLAIN MODE: gửi chủ đề hoặc đoạn code. ZAKA có thể trình bày theo kiểu từng bước, ví dụ và checklist."
    elseif mode == "BRAINSTORM" then
        return "BRAINSTORM MODE: mô tả mục tiêu. ZAKA sẽ có thể chia mục tiêu thành ý tưởng, kiến trúc, task và thứ tự triển khai khi có backend AI."
    elseif mode == "TOOLS" then
        return "TOOLS: Prompt Builder, Text Counter, JSON Notes, Lua Notes, Code Checklist và Session Info."
    end

    if string.find(low,"tab",1,true) then
        return "ZAKA UI hiện có 8 tab: COMBAT, ESP, PLAYER, TROLL, ULTRA, SERVER, SETTING và HOME."
    end

    if string.find(low,"kéo",1,true) or string.find(low,"drag",1,true) then
        return "Giữ vùng trống/header để kéo cả menu. Tab và Functions giữ rồi kéo dọc sẽ đổi mục."
    end

    if string.find(low,"ai",1,true) then
        return "ZAKA AI có CHAT, CODE, TOOLS, EXPLAIN, DEBUG và BRAINSTORM. Để có năng lực model thật, hãy nối một backend/API AI được bạn cấp quyền sử dụng."
    end

    return "Mình đã nhận câu hỏi. Đây là local fallback của ZAKA AI; để có câu trả lời sinh động như model online, hãy kết nối _G.ZAKA_AI_BACKEND."
end

local function askAI(prompt)
    local mode = MODES[CurrentMode]
    local backend = rawget(_G,"ZAKA_AI_BACKEND")

    if type(backend) == "function" then
        local ok,res = pcall(backend,{
            prompt = prompt,
            mode = mode,
            tab = TABS[currentTab],
            functionName = DATA[TABS[currentTab]][currentFunc],
            code = CodeBox.Text,
        })
        if ok and type(res) == "string" and #res > 0 then
            return res
        end
    end

    return localAI(prompt,mode)
end

local function sendAI()
    local q = Prompt.Text
    if q == "" then return end

    bubble(q,true)
    Prompt.Text = ""
    Status.Text = "ZAKA AI • ĐANG XỬ LÝ…"

    task.spawn(function()
        local answer = askAI(q)
        local b = bubble(answer,false)
        task.wait()
        Chat.CanvasPosition = Vector2.new(0,math.max(0,Chat.AbsoluteCanvasSize.Y-Chat.AbsoluteWindowSize.Y))
        Status.Text = "ZAKA AI • "..MODES[CurrentMode]
        -- Soft answer reveal
        local s = scaleOf(b,.94)
        tween(s,.22,{Scale=1},Enum.EasingStyle.Back)
    end)
end

Send.Activated:Connect(function()
    ripple(Send)
    press(Send)
    sendAI()
end)

Prompt.FocusLost:Connect(function(enter)
    if enter and not UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
        sendAI()
    end
end)

-- ---------- Mode switching ----------
local function setMode(i)
    CurrentMode = math.clamp(i,1,#MODES)

    for k,v in ipairs(ModeButtons) do
        local on = k == CurrentMode
        tween(v.button,.18,{BackgroundTransparency=on and .12 or .72},Enum.EasingStyle.Quint)
        tween(scaleOf(v.button,1),.18,{Scale=on and 1.045 or 1},Enum.EasingStyle.Back)
        v.label.TextColor3 = on and C.White or C.Soft
    end

    for k,page in ipairs(Pages) do
        page.Visible = (k == CurrentMode)
    end

    if CurrentMode ~= 1 then
        Pages[CurrentMode].Visible = true
    end

    Status.Text = "ZAKA AI • "..MODES[CurrentMode]
end

for i,v in ipairs(ModeButtons) do
    bindTouch(v.button)
    v.button.Activated:Connect(function()
        setMode(i)
    end)
end

-- ---------- Ambient liquid-glass motion ----------
local clock = 0
Run.RenderStepped:Connect(function(dt)
    if not GUI.Parent then return end
    clock += dt

    local pulse = (math.sin(clock*1.7)+1)/2
    local micro = (math.sin(clock*2.8)+1)/2

    -- Glass breathing: very small, designed for mobile.
    MenuStroke.Transparency = .16 + pulse*.12
    HeaderGradient.Rotation = 12 + math.sin(clock*.45)*7
    MenuGradient.Rotation = 12 + math.sin(clock*.30)*6
    Shine.Position = UDim2.fromScale(((clock/4.6)%1)*1.20-.16,.12)

    -- Center Z breathing.
    if ZButton.Visible then
        local z = ZButton:FindFirstChild("ZScale")
        if z and isOpen then
            z.Scale = 1 + pulse*.025
        end
    end

    -- Launcher breathing while closed.
    if Launcher.Visible then
        local s = Launcher:FindFirstChild("ZScale")
        if s then s.Scale = 1 + micro*.035 end
    end
end)

-- ---------- Initial state ----------
selectTab(1)
setMode(1)
Menu.Visible = true
Launcher.Visible = false

_G.ZAKA_PINK_UI_V17 = {
    Gui = GUI,
    Menu = Menu,
    Launcher = Launcher,
    AI = AI,
    AskAI = askAI,
    Open = openMenu,
    Close = closeMenu,
    SelectTab = selectTab,
    SelectFunction = function(i)
        currentFunc = math.clamp(i,1,#DATA[TABS[currentTab]])
        refreshFunctions()
    end,
    SetAIMode = setMode,
    WriteCode = function(code)
        CodeBox.Text = tostring(code or "")
        setMode(2)
    end,
}
