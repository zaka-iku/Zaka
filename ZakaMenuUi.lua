-- ZAKA PINK UI V14 • ANIMATION UPGRADE • 8 TABS • MOBILE
-- UI shell only. No images/assets and no gameplay automation.

local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
local pg=player:WaitForChild("PlayerGui")

local old=pg:FindFirstChild("ZAKA_PINK_UI_V14")
if old then old:Destroy() end

local C={Pink=Color3.fromRGB(244,82,155),Pink2=Color3.fromRGB(255,137,191),Dark=Color3.fromRGB(104,23,58),White=Color3.fromRGB(255,248,252),Soft=Color3.fromRGB(255,218,236),Ink=Color3.fromRGB(70,18,42)}
local TAB={"COMBAT","ESP","PLAYER","TROLL","ULTRA","SERVER","SETTING","HOME"}
local ICON={"⚔","◉","♙","☄","✦","◎","⚙","⌂"}
local ITEMS={
 COMBAT={"Aim UI","Target List","FOV Preview","Hitbox Preview","Crosshair","Combat Layout","Sensitivity","Keybind","Indicator","Preset","Reset Card","Info"},
 ESP={"Player List","NPC List","Name Tags","Distance","Health Bar","Boxes","Tracers","Highlight","Color","Range","Preview","Reset Card"},
 PLAYER={"Movement UI","Camera","FOV","Jump Preview","Speed Preview","Touch Pad","View Info","State","Scale","Layout","Preset","Reset Card"},
 TROLL={"Fun Button","Effect Preview","Sound UI","Emote UI","Spin UI","Screen FX","Popup","Color FX","Shake","Randomizer","Preset","Reset Card"},
 ULTRA={"Performance","FPS View","Memory View","Quality","Particles","Glow","Blur","Motion","Shadows","Density","Preset","Reset Card"},
 SERVER={"Server Info","Ping View","Region","Job ID","Players","Clock","Session","Refresh","Copy UI","Status","Preset","Reset Card"},
 SETTING={"Theme","Transparency","Glow","Animation","Touch","Sound","Card Style","Tab Style","Scale","Compact","Search","Reset All"},
 HOME={"Overview","Quick Toggle","UI Status","Theme","Animations","Touch Mode","Card Count","Tab Count","Scale","Search","Credits","Reset All"},
}

local GUI=Instance.new("ScreenGui")
GUI.Name="ZAKA_PINK_UI_V14";GUI.IgnoreGuiInset=true;GUI.ResetOnSpawn=false;GUI.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;GUI.DisplayOrder=999;GUI.Parent=pg

local function frame(parent,name,size,pos,color,trans,z)
 local x=Instance.new("Frame");x.Name=name;x.Size=size;x.Position=pos;x.BackgroundColor3=color or C.Pink;x.BackgroundTransparency=trans or 0;x.BorderSizePixel=0;x.ZIndex=z or 1;x.Parent=parent;return x
end
local function corner(x,r)local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,r);u.Parent=x;return u end
local function stroke(x,color,t,trans)local u=Instance.new("UIStroke");u.Color=color;u.Thickness=t or 1;u.Transparency=trans or 0;u.Parent=x;return u end
local function label(parent,name,size,pos,text,ts,color,z)
 local x=Instance.new("TextLabel");x.Name=name;x.Size=size;x.Position=pos;x.BackgroundTransparency=1;x.Text=text;x.TextSize=ts or 10;x.Font=Enum.Font.GothamBold;x.TextColor3=color or C.White;x.TextXAlignment=Enum.TextXAlignment.Left;x.TextYAlignment=Enum.TextYAlignment.Center;x.ZIndex=z or 10;x.Parent=parent;return x
end
local function button(parent,name,size,pos,z)
 local x=Instance.new("TextButton");x.Name=name;x.Size=size;x.Position=pos;x.Text="";x.AutoButtonColor=false;x.BackgroundColor3=C.Pink2;x.BackgroundTransparency=.35;x.BorderSizePixel=0;x.ZIndex=z or 20;x.Parent=parent;corner(x,22);return x
end
local function tween(x,t,goal,style,dir)
 local tw=TweenService:Create(x,TweenInfo.new(t,style or Enum.EasingStyle.Quint,dir or Enum.EasingDirection.Out),goal);tw:Play();return tw
end
local function scaleOf(x,v)
 local s=x:FindFirstChild("AnimScale") or Instance.new("UIScale")
 s.Name="AnimScale";s.Parent=x;s.Scale=v;return s
end

-- Root is fully transparent: no giant pink overlay.
local Root=frame(GUI,"Root",UDim2.fromScale(1,1),UDim2.fromScale(0,0),C.Pink,1,1)

-- Floating menu button: plain pink Z, draggable anywhere.
local Launcher=button(Root,"MenuButton",UDim2.fromOffset(64,64),UDim2.fromScale(.05,.50),200)
Launcher.BackgroundColor3=C.Pink;Launcher.BackgroundTransparency=.06
local launcherStroke=stroke(Launcher,C.White,2,.48)
local zmark=label(Launcher,"Z",UDim2.fromScale(1,1),UDim2.fromScale(0,0),"Z",23,C.White,205);zmark.TextXAlignment=Enum.TextXAlignment.Center;zmark.TextYAlignment=Enum.TextYAlignment.Center
scaleOf(Launcher,1)

-- Main glass shell.
local Menu=frame(Root,"Menu",UDim2.fromScale(.86,.80),UDim2.fromScale(.07,.10),C.Pink,.23,50)
corner(Menu,42);local menuStroke=stroke(Menu,C.Pink2,2,.16);local menuScale=scaleOf(Menu,1)

local Header=frame(Menu,"Header",UDim2.fromScale(.94,.14),UDim2.fromScale(.03,.035),C.Pink,.30,60)
corner(Header,26);local headerStroke=stroke(Header,C.White,1,.62)
label(Header,"Brand",UDim2.fromScale(.12,.7),UDim2.fromScale(.025,.15),"ZAKA",10,C.Soft,65)
local title=label(Header,"Title",UDim2.fromScale(.50,.75),UDim2.fromScale(.17,.08),"PINK UI",19,C.White,65);title.TextXAlignment=Enum.TextXAlignment.Center
local search=Instance.new("TextBox");search.Name="Search";search.Size=UDim2.fromScale(.24,.50);search.Position=UDim2.fromScale(.66,.25);search.BackgroundColor3=C.White;search.BackgroundTransparency=.83;search.BorderSizePixel=0;search.Text="";search.PlaceholderText="⌕  Tìm chức năng";search.TextColor3=C.White;search.PlaceholderColor3=C.Soft;search.TextSize=10;search.Font=Enum.Font.GothamMedium;search.ZIndex=70;search.Parent=Header;corner(search,18);stroke(search,C.White,1,.7)
local close=button(Header,"Close",UDim2.fromOffset(34,34),UDim2.fromScale(.935,.22),80);close.BackgroundColor3=C.Dark;close.BackgroundTransparency=.15
local cx=label(close,"X",UDim2.fromScale(1,1),UDim2.fromScale(0,0),"×",20,C.White,85);cx.TextXAlignment=Enum.TextXAlignment.Center

local Body=frame(Menu,"Body",UDim2.fromScale(.94,.77),UDim2.fromScale(.03,.205),C.Pink,.56,55);corner(Body,30);stroke(Body,C.White,1,.78)
local Rail=frame(Body,"Rail",UDim2.fromScale(.235,.92),UDim2.fromScale(.018,.04),C.Dark,.60,58);corner(Rail,24);stroke(Rail,C.Pink2,1,.55)
local Tabs=Instance.new("ScrollingFrame");Tabs.Name="Tabs";Tabs.Size=UDim2.fromScale(.90,.92);Tabs.Position=UDim2.fromScale(.05,.04);Tabs.BackgroundTransparency=1;Tabs.BorderSizePixel=0;Tabs.ScrollBarThickness=2;Tabs.ScrollBarImageColor3=C.Soft;Tabs.ZIndex=62;Tabs.Parent=Rail
local tabLayout=Instance.new("UIListLayout");tabLayout.Padding=UDim.new(0,7);tabLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center;tabLayout.Parent=Tabs
local Content=frame(Body,"Content",UDim2.fromScale(.705,.92),UDim2.fromScale(.275,.04),C.Pink,.63,58);corner(Content,26);stroke(Content,C.White,1,.80)
local pageTitle=label(Content,"PageTitle",UDim2.fromScale(.70,.08),UDim2.fromScale(.04,.035),"COMBAT",16,C.White,70)
local pageSub=label(Content,"PageSub",UDim2.fromScale(.88,.055),UDim2.fromScale(.04,.105),"12 UI controls",9,C.Soft,70)
local Cards=Instance.new("ScrollingFrame");Cards.Name="Cards";Cards.Size=UDim2.fromScale(.94,.80);Cards.Position=UDim2.fromScale(.03,.18);Cards.BackgroundTransparency=1;Cards.BorderSizePixel=0;Cards.ScrollBarThickness=3;Cards.ScrollBarImageColor3=C.Soft;Cards.ZIndex=62;Cards.Parent=Content
local grid=Instance.new("UIGridLayout");grid.CellSize=UDim2.fromScale(.47,.205);grid.CellPadding=UDim2.fromScale(.025,.025);grid.SortOrder=Enum.SortOrder.LayoutOrder;grid.Parent=Cards

-- Lightweight ambient shine: only moves a few small layers, never covers controls.
local shine=frame(Header,"Shine",UDim2.fromScale(.12,.70),UDim2.fromScale(-.16,.15),C.White,.88,64);corner(shine,30)
local shine2=frame(Content,"Shine",UDim2.fromScale(.10,.02),UDim2.fromScale(-.12,.02),C.White,.90,63);corner(shine2,10)

local tabs,tabText,cards={}, {}, {}
local current=1
local settings={touch=true,motion=true,glow=true}
local animToken=0

local function ripple(btn,input)
 if not settings.motion then return end
 local p=input and input.Position
 if not p then return end
 local ap=btn.AbsolutePosition;local as=btn.AbsoluteSize
 local r=frame(btn,"Ripple",UDim2.fromOffset(12,12),UDim2.fromOffset(p.X-ap.X-6,p.Y-ap.Y-6),C.White,.72,btn.ZIndex+2)
 corner(r,50);scaleOf(r,.2)
 tween(r,.32,{BackgroundTransparency=1},Enum.EasingStyle.Quad)
 local s=r:FindFirstChild("AnimScale");tween(s,.34,{Scale=7},Enum.EasingStyle.Quart)
 task.delay(.36,function()if r.Parent then r:Destroy()end end)
end

local function press(btn)
 if not settings.touch then return end
 local s=scaleOf(btn,1)
 tween(s,.07,{Scale=.94},Enum.EasingStyle.Quad)
 task.delay(.075,function()if s.Parent then tween(s,.20,{Scale=1.045},Enum.EasingStyle.Back);task.delay(.11,function()if s.Parent then tween(s,.12,{Scale=1},Enum.EasingStyle.Quad)end end)end end)
end

local function makeCard(i,name,tabName,delayTime)
 local c=button(Cards,"Card"..i,UDim2.fromScale(.47,.205),UDim2.new(),65);c.BackgroundColor3=C.Pink2;c.BackgroundTransparency=.78;c.LayoutOrder=i
 local cs=scaleOf(c,.86);stroke(c,C.White,1,.78)
 local dot=frame(c,"Dot",UDim2.fromOffset(6,6),UDim2.fromScale(.035,.20),C.White,.05,70);corner(dot,10)
 local a=label(c,"Name",UDim2.fromScale(.84,.32),UDim2.fromScale(.08,.08),name,10,C.White,70)
 local b=label(c,"State",UDim2.fromScale(.84,.28),UDim2.fromScale(.08,.44),"READY  •  "..tabName,7,C.Soft,70)
 if settings.motion then
  task.delay(delayTime,function()
   if c.Parent then tween(cs,.28,{Scale=1},Enum.EasingStyle.Back);tween(c,.25,{BackgroundTransparency=.48},Enum.EasingStyle.Quint) end
  end)
 else cs.Scale=1;c.BackgroundTransparency=.48 end
 c.InputBegan:Connect(function(inp)
  if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 then ripple(c,inp) end
 end)
 c.Activated:Connect(function()
  press(c)
  local on=not b.Text:find("ON")
  b.Text=(on and "ON  •  " or "READY  •  ")..tabName
  tween(c,.10,{BackgroundTransparency=.25},Enum.EasingStyle.Quad)
  task.delay(.13,function()if c.Parent then tween(c,.18,{BackgroundTransparency=.48},Enum.EasingStyle.Quad)end end)
 end)
 return c
end

local function selectTab(i)
 current=i;animToken+=1;local token=animToken
 pageTitle.Text=TAB[i];pageSub.Text=tostring(#ITEMS[TAB[i]]).." UI controls"
 for k,b in ipairs(tabs)do
  local on=k==i;local s=scaleOf(b,1)
  tween(s,.20,{Scale=on and 1.045 or 1},Enum.EasingStyle.Back)
  tween(b,.20,{BackgroundTransparency=on and .14 or .62},Enum.EasingStyle.Quint)
  tabText[k].TextColor3=on and C.White or C.Soft
 end
 for _,c in ipairs(cards)do c:Destroy()end
 cards={}
 for j,n in ipairs(ITEMS[TAB[i]])do cards[j]=makeCard(j,n,TAB[i],settings.motion and (j-1)*.035 or 0) end
 task.defer(function()Cards.CanvasSize=UDim2.new(0,0,0,grid.AbsoluteContentSize.Y+10)end)
end

for i,n in ipairs(TAB)do
 local b=button(Tabs,"Tab"..i,UDim2.new(.84,0,0,34),UDim2.new(),62);b.LayoutOrder=i;b.BackgroundColor3=C.Pink2
 local s=scaleOf(b,1)
 local icon=label(b,"Icon",UDim2.fromScale(.20,.82),UDim2.fromScale(.035,.08),ICON[i],13,C.Soft,70);icon.TextXAlignment=Enum.TextXAlignment.Center
 local txt=label(b,"Text",UDim2.fromScale(.68,.82),UDim2.fromScale(.25,.08),n,9,C.Soft,70);tabText[i]=txt;tabs[i]=b
 b.InputBegan:Connect(function(inp)if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 then ripple(b,inp)end end)
 b.Activated:Connect(function()press(b);selectTab(i)end)
end

tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()Tabs.CanvasSize=UDim2.new(0,0,0,tabLayout.AbsoluteContentSize.Y+8)end)
grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()Cards.CanvasSize=UDim2.new(0,0,0,grid.AbsoluteContentSize.Y+10)end)

search:GetPropertyChangedSignal("Text"):Connect(function()
 local q=string.lower(search.Text or "")
 for _,c in ipairs(cards)do local n=c:FindFirstChild("Name");c.Visible=(q=="" or (n and string.find(string.lower(n.Text),q,1,true)~=nil)) end
end)

-- Smooth drag with touch/mouse; menu can be moved anywhere.
local dragConnections={}
local function drag(obj,allowTap)
 local active=false;local start;local base;local moved=false
 obj.InputBegan:Connect(function(i)
  if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then active=true;moved=false;start=i.Position;base=obj.Position end
 end)
 UIS.InputChanged:Connect(function(i)
  if active and (i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then
   local d=i.Position-start
   if math.abs(d.X)+math.abs(d.Y)>4 then moved=true end
   obj.Position=UDim2.new(base.X.Scale,base.X.Offset+d.X,base.Y.Scale,base.Y.Offset+d.Y)
  end
 end)
 UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then active=false end end)
end
drag(Header);drag(Launcher)

local open=false
local function showMenu()
 if open then return end
 open=true;Menu.Visible=true;Launcher.Visible=false
 local target=Menu.Position
 menuScale.Scale=.78;Menu.Position=UDim2.new(target.X.Scale,target.X.Offset,target.Y.Scale+0.035,target.Y.Offset+18)
 Menu.BackgroundTransparency=.72
 tween(menuScale,.48,{Scale=1},Enum.EasingStyle.Back)
 tween(Menu,.48,{Position=target,BackgroundTransparency=.23},Enum.EasingStyle.Quint)
 for _,x in ipairs({Header,Body})do x.BackgroundTransparency=.80 end
 task.delay(.08,function()if open then tween(Header,.30,{BackgroundTransparency=.30},Enum.EasingStyle.Quint);tween(Body,.36,{BackgroundTransparency=.56},Enum.EasingStyle.Quint)end end)
end
local function hideMenu()
 if not open then return end
 open=false
 tween(menuScale,.22,{Scale=.82},Enum.EasingStyle.Quint)
 tween(Menu,.22,{Position=UDim2.new(Menu.Position.X.Scale,Menu.Position.X.Offset,Menu.Position.Y.Scale+.02,Menu.Position.Y.Offset+10),BackgroundTransparency=.78},Enum.EasingStyle.Quad)
 task.delay(.23,function()if not open then Menu.Visible=false;Launcher.Visible=true;scaleOf(Launcher,1).Scale=.82;tween(scaleOf(Launcher,1),.28,{Scale=1},Enum.EasingStyle.Back)end end)
end
close.InputBegan:Connect(function(inp)if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 then ripple(close,inp) end end)
close.Activated:Connect(function()press(close);hideMenu()end)
Launcher.InputBegan:Connect(function(inp)if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 then ripple(Launcher,inp)end end)
Launcher.Activated:Connect(function()press(Launcher);showMenu()end)

-- Ambient animation: tiny pulses only; no full-screen overlays.
local t0=0
RunService.RenderStepped:Connect(function(dt)
 if not GUI.Parent then return end
 t0+=dt
 if settings.glow then
  local pulse=(math.sin(t0*2.2)+1)/2
  menuStroke.Transparency=.12+.18*pulse
  headerStroke.Transparency=.48+.20*(1-pulse)
  launcherStroke.Transparency=.34+.20*(1-pulse)
 end
 if settings.motion and Menu.Visible then
  local sweep=(t0%3.8)/3.8
  shine.Position=UDim2.fromScale(-.16+sweep*1.25,.15)
  shine2.Position=UDim2.fromScale(-.12+sweep*1.22,.02)
 end
end)

selectTab(1)
Menu.Visible=true;Launcher.Visible=false
_G.ZAKA_PINK_UI_V14={Gui=GUI,Menu=Menu,Launcher=Launcher,Open=showMenu,Close=hideMenu,SelectTab=selectTab}
