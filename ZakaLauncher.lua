--[[
 ZAKA PURE • iOS LIQUID GLASS / DELTA MOBILE
 Single-file Lua UI overlay. Execute from Delta Mobile.
 UI and local presentation controls only; no game exploit functions.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
if not LP then return end

local GUI_NAME = "ZAKA_PURE_IOS_GLASS"
pcall(function() local x=CoreGui:FindFirstChild(GUI_NAME); if x then x:Destroy() end end)
pcall(function()
    local pg=LP:FindFirstChildOfClass("PlayerGui")
    local x=pg and pg:FindFirstChild(GUI_NAME)
    if x then x:Destroy() end
end)

local gui=Instance.new("ScreenGui")
gui.Name=GUI_NAME
gui.IgnoreGuiInset=true
gui.ResetOnSpawn=false
gui.DisplayOrder=1000000
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
local ok=pcall(function() gui.Parent=CoreGui end)
if not ok or not gui.Parent then
    pcall(function() gui.Parent=LP:WaitForChild("PlayerGui") end)
end
if not gui.Parent then return end

local alive=true
local animOn=true
local glowOn=true
local glassOn=true
local accent=Color3.fromRGB(220,226,238) -- neutral silver, not saturated blue
local active={}
local currentPage="HOME"
local pageObjects={}
local navObjects={}
local allTweens={}
local connections={}
local function conn(c) connections[#connections+1]=c; return c end
local function tw(o,t,p,s,d)
    if not o or not o.Parent then return end
    local x=TweenService:Create(o,TweenInfo.new(t or .3,s or Enum.EasingStyle.Quint,d or Enum.EasingDirection.Out),p)
    allTweens[#allTweens+1]=x; x:Play(); return x
end
local function round(o,r)
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 18); c.Parent=o; return c
end
local function edge(o,color,thick,trans)
    local s=Instance.new("UIStroke"); s.Color=color or Color3.new(1,1,1)
    s.Thickness=thick or 1; s.Transparency=trans or .5; s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; s.Parent=o; return s
end
local function grad(o,a,b,c,rot)
    local g=Instance.new("UIGradient")
    g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,a),ColorSequenceKeypoint.new(.52,b),ColorSequenceKeypoint.new(1,c)})
    g.Rotation=rot or 0; g.Parent=o; return g
end
local function label(parent,str,size,pos,font,color)
    local x=Instance.new("TextLabel"); x.BackgroundTransparency=1; x.Text=str
    x.TextSize=size or 12; x.Font=font or Enum.Font.Gotham
    x.TextColor3=color or Color3.fromRGB(242,245,250)
    x.TextXAlignment=Enum.TextXAlignment.Left; x.TextYAlignment=Enum.TextYAlignment.Center
    x.Position=pos or UDim2.new(); x.Size=UDim2.new(1,0,0,24); x.Parent=parent; return x
end
local function frame(parent,name,size,pos,color,trans,z)
    local x=Instance.new("Frame"); x.Name=name or "Frame"; x.Size=size; x.Position=pos or UDim2.new()
    x.BackgroundColor3=color or Color3.fromRGB(30,35,48); x.BackgroundTransparency=trans or 0
    x.BorderSizePixel=0; x.ZIndex=z or 1; x.Parent=parent; return x
end
local function button(parent,str,size,pos)
    local b=Instance.new("TextButton"); b.AutoButtonColor=false; b.Text=str
    b.TextSize=12; b.Font=Enum.Font.GothamSemibold; b.TextColor3=Color3.fromRGB(245,247,251)
    b.Size=size; b.Position=pos; b.BackgroundColor3=Color3.fromRGB(125,137,157)
    b.BackgroundTransparency=.73; b.BorderSizePixel=0; b.Parent=parent
    round(b,14); local st=edge(b,Color3.fromRGB(255,255,255),1,.83)
    b.Activated:Connect(function()
        local old=b.Size
        tw(b,.08,{Size=UDim2.new(old.X.Scale,old.X.Offset-2,old.Y.Scale,old.Y.Offset-2)},Enum.EasingStyle.Quad)
        task.delay(.09,function() if b.Parent then tw(b,.2,{Size=old},Enum.EasingStyle.Back) end end)
    end)
    return b,st
end
local function card(parent,pos,size)
    local c=frame(parent,"GlassCard",size,pos,Color3.fromRGB(175,185,205),.88,2)
    round(c,18); edge(c,Color3.fromRGB(255,255,255),1,.79)
    local shine=frame(c,"TopSheen",UDim2.new(.78,0,0,1),UDim2.new(.11,0,0,1),Color3.new(1,1,1),.62,3)
    round(shine,2)
    return c
end
local function notify(textLine,subLine)
    if not alive then return end
    local n=frame(gui,"iOSNotification",UDim2.new(0,math.min(330,workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X-26 or 300),0,62),
        UDim2.new(0,-360,0,18),Color3.fromRGB(18,19,23),.08,200)
    round(n,22); edge(n,Color3.fromRGB(255,255,255),1,.82)
    local dot=frame(n,"AppIcon",UDim2.fromOffset(34,34),UDim2.fromOffset(12,14),accent,.12,202)
    round(dot,11)
    label(dot,"Z",16,UDim2.new(0,0,0,2),Enum.Font.GothamBlack,Color3.fromRGB(20,23,29)).TextXAlignment=Enum.TextXAlignment.Center
    local title=label(n,textLine or "ZAKA",12,UDim2.fromOffset(56,10),Enum.Font.GothamBold)
    title.Size=UDim2.new(1,-68,0,20); title.ZIndex=203
    local desc=label(n,subLine or "Liquid Glass",10,UDim2.fromOffset(56,31),Enum.Font.Gotham,Color3.fromRGB(185,190,201))
    desc.Size=UDim2.new(1,-68,0,18); desc.ZIndex=203
    tw(n,.58,{Position=UDim2.new(0,13,0,18)},Enum.EasingStyle.Quint)
    task.delay(2.45,function()
        if n.Parent then
            tw(n,.42,{Position=UDim2.new(0,-360,0,18),Size=UDim2.new(0,40,0,40)},Enum.EasingStyle.Quint)
            task.delay(.46,function() if n.Parent then n:Destroy() end end)
        end
    end)
end

-- Full-screen subtle ambient background
local backdrop=frame(gui,"Ambient",UDim2.fromScale(1,1),UDim2.new(),Color3.fromRGB(5,6,10),.68,0)
local ambientGrad=grad(backdrop,Color3.fromRGB(16,20,29),Color3.fromRGB(7,9,15),Color3.fromRGB(18,15,24),25)

-- Independent iOS-style Dynamic Island at the top of the SCREEN, not attached to menu.
local island=frame(gui,"DynamicIsland",UDim2.fromOffset(48,34),UDim2.new(.5,-24,0,9),Color3.fromRGB(0,0,0),0,300)
round(island,20)
edge(island,Color3.fromRGB(85,88,96),1,.72)
local islandDot=frame(island,"IslandDot",UDim2.fromOffset(7,7),UDim2.new(1,-15,.5,-3),Color3.fromRGB(62,205,135),0,302)
round(islandDot,8)
local islandTitle=label(island,"",10,UDim2.fromOffset(14,0),Enum.Font.GothamSemibold,Color3.new(1,1,1))
islandTitle.Size=UDim2.new(1,-30,1,0); islandTitle.TextTransparency=1; islandTitle.ZIndex=303
local islandExpanded=false
local islandPanel
local function refreshIsland()
    local names={}
    for k,v in pairs(active) do if v then names[#names+1]=k end end
    table.sort(names)
    islandTitle.Text=#names>0 and (tostring(#names).." ACTIVE") or "ZAKA"
    islandTitle.TextTransparency=.05
    islandDot.BackgroundColor3=#names>0 and Color3.fromRGB(80,225,155) or Color3.fromRGB(145,150,160)
end
local function expandIsland()
    islandExpanded=not islandExpanded
    if islandPanel and islandPanel.Parent then islandPanel:Destroy(); islandPanel=nil end
    if not islandExpanded then
        tw(island,.32,{Size=UDim2.fromOffset(48,34),Position=UDim2.new(.5,-24,0,9)},Enum.EasingStyle.Back)
        return
    end
    tw(island,.34,{Size=UDim2.fromOffset(276, math.min(210, 76 + math.max(1,#active)*29)),
        Position=UDim2.new(.5,-138,0,9)},Enum.EasingStyle.Back)
    islandPanel=frame(island,"ActiveList",UDim2.new(1,-22,1,-48),UDim2.fromOffset(11,40),Color3.fromRGB(12,13,17),.02,304)
    islandPanel.BackgroundTransparency=1
    local head=label(islandPanel,"ĐANG HOẠT ĐỘNG",9,UDim2.new(0,0,0,0),Enum.Font.GothamBold,Color3.fromRGB(155,161,174))
    head.Size=UDim2.new(1,0,0,18); head.ZIndex=305
    local y=22
    local found=false
    for name,on in pairs(active) do
        if on then
            found=true
            local row=frame(islandPanel,"Active_"..name,UDim2.new(1,0,0,25),UDim2.fromOffset(0,y),Color3.fromRGB(255,255,255),.94,305)
            round(row,9)
            local tx=label(row,"●  "..name,10,UDim2.fromOffset(7,0),Enum.Font.Gotham,Color3.fromRGB(237,240,246))
            tx.Size=UDim2.new(1,-58,1,0); tx.ZIndex=306
            local off=button(row,"TẮT",UDim2.fromOffset(43,21),UDim2.new(1,-47,.5,-10))
            off.TextSize=8; off.ZIndex=307
            off.Activated:Connect(function()
                active[name]=false
                local switch=_G["ZAKA_SWITCH_"..name]
                if switch then switch.Text="OFF"; switch.BackgroundTransparency=.75 end
                refreshIsland(); expandIsland(); expandIsland()
                notify("Đã tắt "..name,"Đã cập nhật trạng thái")
            end)
            y=y+29; found=true
        end
    end
    if not found then
        local empty=label(islandPanel,"Chưa có chức năng nào đang bật",10,UDim2.new(0,0,0,25),Enum.Font.Gotham)
        empty.Size=UDim2.new(1,0,0,24); empty.ZIndex=306
    end
end
local islandHit=Instance.new("TextButton")
islandHit.BackgroundTransparency=1; islandHit.Text=""; islandHit.Size=UDim2.fromScale(1,1); islandHit.ZIndex=301; islandHit.Parent=island
islandHit.Activated:Connect(expandIsland)

-- Main window, restrained graphite/silver glass instead of blue tint.
local shell=frame(gui,"MainGlass",UDim2.new(.91,0,.78,0),UDim2.new(.045,0,.17,0),Color3.fromRGB(29,31,38),.34,10)
round(shell,28)
local shellEdge=edge(shell,Color3.fromRGB(244,246,250),1.35,.48)
local inner=frame(shell,"InnerRim",UDim2.new(1,-6,1,-6),UDim2.fromOffset(3,3),Color3.new(1,1,1),1,11)
inner.BackgroundTransparency=1; round(inner,25); edge(inner,Color3.fromRGB(255,255,255),1,.83)
local shellGrad=grad(shell,Color3.fromRGB(80,84,97),Color3.fromRGB(25,27,34),Color3.fromRGB(62,52,66),30)

-- Three layered specular glass ribbons.
local ribbons={}
for i=1,3 do
    local r=frame(shell,"SpecularRibbon"..i,UDim2.new(.16+(i%2)*.08,0,1.55,0),
        UDim2.new(-.3+(i-1)*.4,0,-.25,0),Color3.fromRGB(255,255,255),.94,12)
    r.Rotation=15+(i*7); round(r,90)
    grad(r,Color3.fromRGB(255,255,255),Color3.fromRGB(205,220,245),Color3.fromRGB(255,255,255),0)
    ribbons[#ribbons+1]=r
end

-- Floating blurred-looking light droplets; neutral pearlescent.
local droplets={}
for i=1,5 do
    local d=frame(shell,"PearlLight"..i,UDim2.fromOffset(90+i*12,90+i*12),
        UDim2.new((i-1)*.22,0,(i%2)*.48,0),i%2==0 and Color3.fromRGB(180,165,205) or Color3.fromRGB(190,205,220),.94,11)
    round(d,100)
    grad(d,Color3.fromRGB(255,255,255),Color3.fromRGB(180,190,215),Color3.fromRGB(255,255,255),i*40)
    droplets[#droplets+1]=d
end

-- Header. Holding blank glass/header and dragging moves the entire menu.
local header=frame(shell,"Header",UDim2.new(1,-28,0,48),UDim2.fromOffset(14,8),Color3.new(1,1,1),1,20)
header.BackgroundTransparency=1
local brand=label(header,"ZAKA",19,UDim2.fromOffset(2,0),Enum.Font.GothamBlack)
brand.Size=UDim2.fromOffset(80,26)
local caption=label(header,"PURE  /  LIQUID GLASS",8,UDim2.fromOffset(3,25),Enum.Font.GothamMedium,Color3.fromRGB(185,188,199))
caption.Size=UDim2.fromOffset(145,14)
local topLeft=label(header,"●  READY",8,UDim2.fromOffset(155,10),Enum.Font.GothamBold,Color3.fromRGB(168,228,190))
topLeft.Size=UDim2.fromOffset(75,20)
local mini=button(header,"–",UDim2.fromOffset(31,29),UDim2.new(1,-68,0,6)); mini.TextSize=17
local close=button(header,"×",UDim2.fromOffset(31,29),UDim2.new(1,-32,0,6)); close.TextSize=18

-- Top-left quick function chips under header.
local quick=frame(shell,"QuickFunctions",UDim2.new(1,-28,0,33),UDim2.fromOffset(14,58),Color3.new(1,1,1),1,20)
quick.BackgroundTransparency=1
local quickDefs={{"ANIM","Animation"},{"GLOW","Glow"},{"GLASS","Glass"}}
local quickButtons={}
for i,def in ipairs(quickDefs) do
    local b=button(quick,def[1],UDim2.fromOffset(65,27),UDim2.fromOffset((i-1)*72,2))
    b.TextSize=8
    quickButtons[def[2]]=b
end

-- Content area above the bottom dock.
local content=frame(shell,"Content",UDim2.new(1,-28,1,-151),UDim2.fromOffset(14,99),Color3.new(1,1,1),1,20)
content.BackgroundTransparency=1

local function title(page,main,sub)
    local a=label(page,main,20,UDim2.fromOffset(4,0),Enum.Font.GothamBold)
    a.Size=UDim2.new(1,-8,0,29)
    local b=label(page,sub,10,UDim2.fromOffset(5,30),Enum.Font.Gotham,Color3.fromRGB(185,189,201))
    b.Size=UDim2.new(1,-10,0,20)
end
local function page(name)
    local p=frame(content,name,UDim2.fromScale(1,1),UDim2.new(),Color3.new(1,1,1),1,21)
    p.BackgroundTransparency=1; p.Visible=false; pageObjects[name]=p; return p
end
local home=page("HOME"); title(home,"Good to see you.","A calmer, more fluid interface — built for touch.")
local hero=card(home,UDim2.fromOffset(3,62),UDim2.new(1,-6,0,104))
label(hero,"ZAKA  /  PURE EXPERIENCE",14,UDim2.fromOffset(14,13),Enum.Font.GothamBold)
label(hero,"Layered glass • soft light • fluid motion",10,UDim2.fromOffset(14,42),Enum.Font.Gotham,Color3.fromRGB(205,209,220))
label(hero,"Hold the top area to move the menu.",9,UDim2.fromOffset(14,69),Enum.Font.Gotham,Color3.fromRGB(161,169,184))
local stats=card(home,UDim2.fromOffset(3,178),UDim2.new(.49,-4,0,67))
local stats2=card(home,UDim2.new(.51,1,0,178),UDim2.new(.49,-4,0,67))
label(stats,"✧  GLASS ENGINE",10,UDim2.fromOffset(10,9),Enum.Font.GothamBold)
label(stats,"LIVE",15,UDim2.fromOffset(10,31),Enum.Font.GothamBlack,Color3.fromRGB(174,232,203))
label(stats2,"◈  MOTION",10,UDim2.fromOffset(10,9),Enum.Font.GothamBold)
label(stats2,"FLUID",15,UDim2.fromOffset(10,31),Enum.Font.GothamBlack,Color3.fromRGB(218,205,241))

local function buildToggle(parent,y,name,detail)
    local c=card(parent,UDim2.fromOffset(3,y),UDim2.new(1,-6,0,55))
    local t=label(c,name,11,UDim2.fromOffset(11,5),Enum.Font.GothamSemibold)
    t.Size=UDim2.new(1,-90,0,19)
    local d=label(c,detail,8,UDim2.fromOffset(11,27),Enum.Font.Gotham,Color3.fromRGB(173,180,194))
    d.Size=UDim2.new(1,-90,0,16)
    local b=button(c,"OFF",UDim2.fromOffset(54,29),UDim2.new(1,-65,.5,-14))
    b.TextSize=9
    _G["ZAKA_SWITCH_"..name]=b
    b.Activated:Connect(function()
        active[name]=not active[name]
        b.Text=active[name] and "ON" or "OFF"
        b.BackgroundTransparency=active[name] and .35 or .75
        refreshIsland()
        notify(active[name] and (name.." đã bật") or (name.." đã tắt"),
            active[name] and "Đang hoạt động • chạm Dynamic Island để quản lý" or "Đã dừng chức năng")
    end)
    return b
end

local functions=page("FUNCTIONS"); title(functions,"Quick Functions","Bật / tắt từng mục; quản lý tất cả ở Dynamic Island.")
buildToggle(functions,62,"Smooth Motion","Hiệu ứng chuyển cảnh mượt")
buildToggle(functions,123,"Glass Shine","Dải sáng phản chiếu")
buildToggle(functions,184,"Edge Aura","Viền sáng nhịp nhàng")

local visuals=page("VISUAL"); title(visuals,"Visual Studio","Tùy chọn phong cách của giao diện.")
local palette={{"Pearl",Color3.fromRGB(220,226,238)},{"Rose",Color3.fromRGB(239,190,207)},{"Violet",Color3.fromRGB(204,190,239)},{"Ice",Color3.fromRGB(190,220,230)}}
for i,v in ipairs(palette) do
    local b=button(visuals,v[1],UDim2.new(.47,0,0,42),UDim2.new((i-1)%2*.51,0,0,62+math.floor((i-1)/2)*51))
    b.Activated:Connect(function()
        accent=v[2]; brand.TextColor3=accent; shellEdge.Color=accent
        notify(v[1].." theme","Accent color updated")
    end)
end
local info=card(visuals,UDim2.fromOffset(3,176),UDim2.new(1,-6,0,76))
label(info,"LIQUID SURFACE",11,UDim2.fromOffset(12,9),Enum.Font.GothamBold)
label(info,"Pearlescent layers • specular ribbons • floating light",9,UDim2.fromOffset(12,34),Enum.Font.Gotham,Color3.fromRGB(183,190,205))

local profile=page("PROFILE"); title(profile,"Profile","Tài khoản Roblox đang sử dụng.")
local profileCard=card(profile,UDim2.fromOffset(3,62),UDim2.new(1,-6,0,104))
local uname=label(profileCard,LP.DisplayName,15,UDim2.fromOffset(13,18),Enum.Font.GothamBold)
uname.Size=UDim2.new(1,-25,0,24)
label(profileCard,"@"..LP.Name,10,UDim2.fromOffset(13,48),Enum.Font.Gotham,Color3.fromRGB(184,191,207))
label(profileCard,"USER ID  •  "..tostring(LP.UserId),9,UDim2.fromOffset(13,70),Enum.Font.GothamMedium,accent)

local settings=page("SETTINGS"); title(settings,"Settings","Điều khiển tổng thể.")
local function settingsAction(y,txt,fn)
    local b=button(settings,txt,UDim2.new(1,-6,0,40),UDim2.fromOffset(3,y))
    b.TextXAlignment=Enum.TextXAlignment.Left
    b.Text="   "..txt.."     ›"
    b.Activated:Connect(fn)
end
settingsAction(62,"Bật / tắt toàn bộ animation",function()
    animOn=not animOn; notify(animOn and "Animation ON" or "Animation OFF","Liquid motion preference")
end)
settingsAction(111,"Dynamic Island: mở bảng trạng thái",expandIsland)
settingsAction(160,"Căn giữa menu",function()
    tw(shell,.35,{Position=UDim2.new(.045,0,.17,0)},Enum.EasingStyle.Back)
    notify("Đã căn lại menu")
end)
settingsAction(209,"Đóng menu",function() close:Activate() end)

-- Five-section bottom dock.
local dock=frame(shell,"BottomDock",UDim2.new(1,-26,0,57),UDim2.new(0,13,1,-66),Color3.fromRGB(180,190,210),.91,40)
round(dock,21); edge(dock,Color3.fromRGB(255,255,255),1,.75)
local dockInner=frame(dock,"DockInner",UDim2.new(1,-6,1,-6),UDim2.fromOffset(3,3),Color3.fromRGB(255,255,255),.96,41)
round(dockInner,18)
local dockDefs={{"⌂","HOME"},{"✦","FUNCTIONS"},{"◈","VISUAL"},{"◉","PROFILE"},{"⚙","SETTINGS"}}
for i,v in ipairs(dockDefs) do
    local w=1/5
    local b=Instance.new("TextButton"); b.AutoButtonColor=false; b.Text=v[1].."\n"..v[2]
    b.TextSize=8; b.Font=Enum.Font.GothamSemibold; b.TextColor3=Color3.fromRGB(190,195,207)
    b.BackgroundTransparency=1; b.Size=UDim2.new(w,0,1,0); b.Position=UDim2.new((i-1)*w,0,0,0); b.ZIndex=43; b.Parent=dock
    navObjects[v[2]]=b
    b.Activated:Connect(function()
        currentPage=v[2]
        for name,obj in pairs(pageObjects) do obj.Visible=(name==currentPage) end
        for name,obj in pairs(navObjects) do
            obj.TextColor3=(name==currentPage) and Color3.fromRGB(255,255,255) or Color3.fromRGB(175,181,194)
        end
        notify(v[2],"Section opened")
    end)
end
home.Visible=true; navObjects.HOME.TextColor3=Color3.new(1,1,1)

-- Top quick switches also work.
quickButtons.Animation.Activated:Connect(function()
    animOn=not animOn; quickButtons.Animation.Text=animOn and "ANIM ✓" or "ANIM —"
    notify("Animation "..(animOn and "ON" or "OFF"))
end)
quickButtons.Glow.Activated:Connect(function()
    glowOn=not glowOn; quickButtons.Glow.Text=glowOn and "GLOW ✓" or "GLOW —"
    notify("Glow "..(glowOn and "ON" or "OFF"))
end)
quickButtons.Glass.Activated:Connect(function()
    glassOn=not glassOn; quickButtons.Glass.Text=glassOn and "GLASS ✓" or "GLASS —"
    notify("Glass "..(glassOn and "ON" or "OFF"))
end)

-- Collapse to a small floating orb; restore by tapping.
local collapsed=false
local restore=button(gui,"Z",UDim2.fromOffset(52,52),UDim2.new(0,14,.52,0))
restore.Visible=false; restore.TextSize=20; restore.BackgroundTransparency=.14; restore.ZIndex=500
edge(restore,accent,1.5,.22)
mini.Activated:Connect(function()
    if collapsed then return end
    collapsed=true
    tw(shell,.3,{Size=UDim2.fromOffset(0,0)},Enum.EasingStyle.Back)
    task.delay(.32,function() if shell.Parent then shell.Visible=false; restore.Visible=true end end)
end)
restore.Activated:Connect(function()
    restore.Visible=false; shell.Visible=true; shell.Size=UDim2.fromOffset(0,0)
    tw(shell,.38,{Size=UDim2.new(.91,0,.78,0)},Enum.EasingStyle.Back); collapsed=false
end)
close.Activated:Connect(function()
    alive=false
    for _,c in ipairs(connections) do pcall(function() c:Disconnect() end) end
    for _,t in ipairs(allTweens) do pcall(function() t:Cancel() end) end
    gui:Destroy()
end)

-- Drag by holding the header or any empty part of the shell. Buttons remain clickable.
local dragging=false
local dragStart, shellStart
local function beginDrag(input)
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=true; dragStart=input.Position; shellStart=shell.Position
        input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
    end
end
header.InputBegan:Connect(beginDrag)
quick.InputBegan:Connect(beginDrag)
conn(UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then
        local delta=input.Position-dragStart
        shell.Position=UDim2.new(shellStart.X.Scale,shellStart.X.Offset+delta.X,
            shellStart.Y.Scale,shellStart.Y.Offset+delta.Y)
    end
end))

-- Tap Dynamic Island once at startup: it grows, confirms menu launch, then returns to pill.
refreshIsland()
tw(island,.5,{Size=UDim2.fromOffset(180,36),Position=UDim2.new(.5,-90,0,8)},Enum.EasingStyle.Back)
islandTitle.Text="ZAKA  •  ACTIVE"; islandTitle.TextTransparency=0
task.delay(1.7,function()
    if island.Parent and not islandExpanded then
        tw(island,.4,{Size=UDim2.fromOffset(48,34),Position=UDim2.new(.5,-24,0,9)},Enum.EasingStyle.Back)
    end
end)
notify("ZAKA is ready","Liquid Glass interface activated")

local elapsed=0
conn(RunService.RenderStepped:Connect(function(dt)
    if not alive then return end
    elapsed+=dt
    if animOn then
        shellGrad.Rotation=(shellGrad.Rotation+dt*3.2)%360
        for i,r in ipairs(ribbons) do
            r.Position=UDim2.new(-.35+((elapsed*.11+i*.31)%1.25),0,-.25+math.sin(elapsed*.4+i)*.035,0)
            r.BackgroundTransparency=glassOn and (.94+math.sin(elapsed*1.7+i)*.018) or 1
        end
        for i,d in ipairs(droplets) do
            local ox=math.sin(elapsed*.35+i*1.7)*9
            local oy=math.cos(elapsed*.29+i*1.3)*8
            d.Position=UDim2.new((i-1)*.22,ox,(i%2)*.48,oy)
        end
    end
    shellEdge.Transparency=glowOn and (.38+math.sin(elapsed*1.5)*.08) or .78
    shellEdge.Color=glowOn and accent:Lerp(Color3.new(1,1,1),.25+math.sin(elapsed)*.1) or Color3.fromRGB(130,132,140)
    backdrop.BackgroundTransparency= .68 + (math.sin(elapsed*.2)*.025)
end))

notify("Hold & drag","Giữ phần đầu menu rồi kéo để di chuyển")
