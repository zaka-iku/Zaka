-- ZAKA PINK UI V15 • EDGE / SMART DRAG • 8 TABS
-- UI shell only. No images/assets and no gameplay automation.

local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local TS=game:GetService("TweenService")
local Run=game:GetService("RunService")
local P=Players.LocalPlayer
local PG=P:WaitForChild("PlayerGui")

local OLD=PG:FindFirstChild("ZAKA_PINK_UI_V15") if OLD then OLD:Destroy() end
local C={P=Color3.fromRGB(244,82,155),P2=Color3.fromRGB(255,132,190),P3=Color3.fromRGB(255,190,218),D=Color3.fromRGB(86,19,49),W=Color3.fromRGB(255,247,252),S=Color3.fromRGB(255,220,236),I=Color3.fromRGB(70,17,41),BG=Color3.fromRGB(48,10,28)}
local T={"COMBAT","ESP","PLAYER","TROLL","ULTRA","SERVER","SETTING","HOME"}
local IC={"⚔","◉","♙","☄","✦","◎","⚙","⌂"}
local DATA={
COMBAT={"Aim UI","Target List","FOV Preview","Hitbox Preview","Crosshair","Combat Layout","Sensitivity","Keybind","Indicator","Preset","Reset Card","Info"},
ESP={"Player List","NPC List","Name Tags","Distance","Health Bar","Boxes","Tracers","Highlight","Color","Range","Preview","Reset Card"},
PLAYER={"Movement UI","Camera","FOV","Jump Preview","Speed Preview","Touch Pad","View Info","State","Scale","Layout","Preset","Reset Card"},
TROLL={"Fun Button","Effect Preview","Sound UI","Emote UI","Spin UI","Screen FX","Popup","Color FX","Shake","Randomizer","Preset","Reset Card"},
ULTRA={"Performance","FPS View","Memory View","Quality","Particles","Glow","Blur","Motion","Shadows","Density","Preset","Reset Card"},
SERVER={"Server Info","Ping View","Region","Job ID","Players","Clock","Session","Refresh","Copy UI","Status","Preset","Reset Card"},
SETTING={"Theme","Transparency","Glow","Animation","Touch","Sound","Card Style","Tab Style","Scale","Compact","Search","Reset All"},
HOME={"Overview","Quick Toggle","UI Status","Theme","Animations","Touch Mode","Card Count","Tab Count","Scale","Search","Credits","Reset All"}}

local G=Instance.new("ScreenGui");G.Name="ZAKA_PINK_UI_V15";G.IgnoreGuiInset=true;G.ResetOnSpawn=false;G.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;G.DisplayOrder=999;G.Parent=PG
local function F(p,n,s,pos,col,tr,z)local x=Instance.new("Frame");x.Name=n;x.Size=s;x.Position=pos;x.BackgroundColor3=col or C.P;x.BackgroundTransparency=tr or 0;x.BorderSizePixel=0;x.ZIndex=z or 1;x.Parent=p;return x end
local function B(p,n,s,pos,z)local x=Instance.new("TextButton");x.Name=n;x.Size=s;x.Position=pos;x.Text="";x.AutoButtonColor=false;x.BackgroundColor3=C.P2;x.BackgroundTransparency=.35;x.BorderSizePixel=0;x.ZIndex=z or 10;x.Parent=p;local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,18);u.Parent=x;return x end
local function L(p,n,s,pos,txt,sz,col,z)local x=Instance.new("TextLabel");x.Name=n;x.Size=s;x.Position=pos;x.BackgroundTransparency=1;x.Text=txt;x.TextSize=sz or 10;x.Font=Enum.Font.GothamBold;x.TextColor3=col or C.W;x.TextXAlignment=Enum.TextXAlignment.Left;x.TextYAlignment=Enum.TextYAlignment.Center;x.ZIndex=z or 20;x.Parent=p;return x end
local function Cr(x,r)local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,r);u.Parent=x;return u end
local function St(x,c,w,tr)local u=Instance.new("UIStroke");u.Color=c;u.Thickness=w or 1;u.Transparency=tr or 0;u.Parent=x;return u end
local function Sc(x,v)local s=x:FindFirstChild("SCALE") or Instance.new("UIScale");s.Name="SCALE";s.Parent=x;s.Scale=v;return s end
local function Tw(x,t,g,e,d)return TS:Create(x,TweenInfo.new(t,e or Enum.EasingStyle.Quint,d or Enum.EasingDirection.Out),g) end
local function Play(x,t,g,e,d)local q=Tw(x,t,g,e,d);q:Play();return q end

local Root=F(G,"Root",UDim2.fromScale(1,1),UDim2.fromOffset(0,0),C.P,1,1)

-- Compact launcher: no image, draggable anywhere, opens the menu.
local Launcher=B(Root,"Launcher",UDim2.fromOffset(58,58),UDim2.fromScale(.05,.50),300);Launcher.BackgroundColor3=C.P;Launcher.BackgroundTransparency=.03;Cr(Launcher,29);St(Launcher,C.P3,2,.25)
local LZ=L(Launcher,"Z",UDim2.fromScale(1,1),UDim2.fromScale(0,0),"Z",23,C.W,305);LZ.TextXAlignment=Enum.TextXAlignment.Center;LZ.TextYAlignment=Enum.TextYAlignment.Center
local LR=F(Launcher,"Ring",UDim2.fromScale(.78,.78),UDim2.fromScale(.11,.11),C.P3,1,301);Cr(LR,50);St(LR,C.P3,2,.38)

-- Main menu: slightly curved, glass-pink, no giant overlay.
local Menu=F(Root,"Menu",UDim2.fromScale(.88,.78),UDim2.fromScale(.06,.11),C.P,.22,100);Cr(Menu,34);local MS=St(Menu,C.P3,2,.18);local MScale=Sc(Menu,1)
local Header=F(Menu,"Header",UDim2.fromScale(.94,.145),UDim2.fromScale(.03,.035),C.P,.34,120);Cr(Header,25);St(Header,C.W,1,.64)
L(Header,"Brand",UDim2.fromScale(.14,.75),UDim2.fromScale(.025,.10),"ZAKA",10,C.S,125)
local Title=L(Header,"Title",UDim2.fromScale(.50,.75),UDim2.fromScale(.18,.08),"PINK CONTROL",18,C.W,125);Title.TextXAlignment=Enum.TextXAlignment.Center
local Search=Instance.new("TextBox");Search.Size=UDim2.fromScale(.22,.48);Search.Position=UDim2.fromScale(.69,.26);Search.BackgroundColor3=C.W;Search.BackgroundTransparency=.84;Search.Text="";Search.PlaceholderText="⌕ Search";Search.TextColor3=C.W;Search.PlaceholderColor3=C.S;Search.TextSize=9;Search.Font=Enum.Font.GothamMedium;Search.BorderSizePixel=0;Search.ZIndex=130;Search.Parent=Header;Cr(Search,16);St(Search,C.W,1,.72)
local Close=B(Header,"Close",UDim2.fromOffset(32,32),UDim2.fromScale(.945,.22),140);Close.BackgroundColor3=C.D;Close.BackgroundTransparency=.08;local XX=L(Close,"X",UDim2.fromScale(1,1),UDim2.fromScale(0,0),"×",19,C.W,145);XX.TextXAlignment=Enum.TextXAlignment.Center

local Body=F(Menu,"Body",UDim2.fromScale(.94,.775),UDim2.fromScale(.03,.205),C.P,.58,110);Cr(Body,28);St(Body,C.W,1,.80)
-- Left edge = tabs; center = control core; right edge = functions.
local Left=F(Body,"LeftRail",UDim2.fromScale(.205,.91),UDim2.fromScale(.018,.045),C.D,.32,115);Cr(Left,23);St(Left,C.P3,1,.58)
local Center=F(Body,"Center",UDim2.fromScale(.50,.91),UDim2.fromScale(.25,.045),C.P,.69,116);Cr(Center,27);St(Center,C.W,1,.84)
local Right=F(Body,"RightRail",UDim2.fromScale(.255,.91),UDim2.fromScale(.73,.045),C.D,.32,115);Cr(Right,23);St(Right,C.P3,1,.58)

L(Left,"LT",UDim2.fromScale(.80,.055),UDim2.fromScale(.10,.025),"TABS",8,C.S,125)
L(Right,"RT",UDim2.fromScale(.82,.055),UDim2.fromScale(.09,.025),"FUNCTIONS",8,C.S,125)
L(Center,"Hint",UDim2.fromScale(.84,.06),UDim2.fromScale(.08,.035),"GIỮ + KÉO  •  CHẠM ĐỂ CHỌN",8,C.S,125).TextXAlignment=Enum.TextXAlignment.Center

local Z=B(Center,"CenterToggle",UDim2.fromOffset(92,92),UDim2.fromScale(.50,.51),150);Z.AnchorPoint=Vector2.new(.5,.5);Z.BackgroundColor3=C.P2;Z.BackgroundTransparency=.06;Cr(Z,46);St(Z,C.P3,2,.15);Sc(Z,1)
local ZZ=L(Z,"Z",UDim2.fromScale(1,1),UDim2.fromScale(0,0),"Z",34,C.W,155);ZZ.TextXAlignment=Enum.TextXAlignment.Center;ZZ.TextYAlignment=Enum.TextYAlignment.Center
local ZSub=L(Center,"ZSub",UDim2.fromScale(.80,.07),UDim2.fromScale(.10,.79),"ĐÓNG / MỞ MENU",8,C.S,125);ZSub.TextXAlignment=Enum.TextXAlignment.Center
local Page=L(Center,"Page",UDim2.fromScale(.82,.07),UDim2.fromScale(.09,.13),"COMBAT",15,C.W,125);Page.TextXAlignment=Enum.TextXAlignment.Center
local Desc=L(Center,"Desc",UDim2.fromScale(.80,.055),UDim2.fromScale(.10,.21),"8 TAB • UI CONTROL",8,C.S,125);Desc.TextXAlignment=Enum.TextXAlignment.Center
local CenterLine=F(Center,"Line",UDim2.fromScale(.72,.008),UDim2.fromScale(.14,.30),C.P3,.35,124);Cr(CenterLine,5)
local Status=L(Center,"Status",UDim2.fromScale(.80,.08),UDim2.fromScale(.10,.86),"READY",9,C.W,125);Status.TextXAlignment=Enum.TextXAlignment.Center

local Tabs=Instance.new("ScrollingFrame");Tabs.Name="Tabs";Tabs.Size=UDim2.fromScale(.86,.84);Tabs.Position=UDim2.fromScale(.07,.11);Tabs.BackgroundTransparency=1;Tabs.BorderSizePixel=0;Tabs.ScrollBarThickness=0;Tabs.ScrollingDirection=Enum.ScrollingDirection.Y;Tabs.ZIndex=122;Tabs.Parent=Left
local TL=Instance.new("UIListLayout");TL.Padding=UDim.new(0,7);TL.HorizontalAlignment=Enum.HorizontalAlignment.Center;TL.Parent=Tabs

local Funcs=Instance.new("ScrollingFrame");Funcs.Name="Functions";Funcs.Size=UDim2.fromScale(.86,.84);Funcs.Position=UDim2.fromScale(.07,.11);Funcs.BackgroundTransparency=1;Funcs.BorderSizePixel=0;Funcs.ScrollBarThickness=0;Funcs.ScrollingDirection=Enum.ScrollingDirection.Y;Funcs.ZIndex=122;Funcs.Parent=Right
local FL=Instance.new("UIListLayout");FL.Padding=UDim.new(0,7);FL.HorizontalAlignment=Enum.HorizontalAlignment.Center;FL.Parent=Funcs

local tabBtns,tabLabels,funcBtns,funcLabels={}, {}, {}, {}
local currentTab=1;local currentFunc=1;local open=true;local busy=false;local settings={motion=true,glow=true}

local function ripple(btn,pos)
 local ap=btn.AbsolutePosition;local as=btn.AbsoluteSize;local x=(pos and pos.X or ap.X+as.X/2)-ap.X-5;local y=(pos and pos.Y or ap.Y+as.Y/2)-ap.Y-5
 local r=F(btn,"Ripple",UDim2.fromOffset(10,10),UDim2.fromOffset(x,y),C.W,.72,btn.ZIndex+3);Cr(r,50);local s=Sc(r,.2);Play(r,.34,{BackgroundTransparency=1},Enum.EasingStyle.Quad);Play(s,.34,{Scale=8},Enum.EasingStyle.Quart);task.delay(.37,function()if r.Parent then r:Destroy()end end)
end
local function press(btn)
 local s=Sc(btn,1);Play(s,.07,{Scale=.93},Enum.EasingStyle.Quad);task.delay(.08,function()if s.Parent then Play(s,.16,{Scale=1.045},Enum.EasingStyle.Back);task.delay(.09,function()if s.Parent then Play(s,.10,{Scale=1},Enum.EasingStyle.Quad)end end)end end)
end
local function touchAnim(btn)
 btn.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then ripple(btn,i.Position);press(btn)end end)
end

local function makeTab(i,n)
 local b=B(Tabs,"Tab"..i,UDim2.new(.88,0,0,38),UDim2.new(),124);b.LayoutOrder=i;b.BackgroundColor3=C.P2;b.BackgroundTransparency=.65
 local ic=L(b,"Icon",UDim2.fromScale(.22,.82),UDim2.fromScale(.03,.09),IC[i],13,C.S,130);ic.TextXAlignment=Enum.TextXAlignment.Center
 local tx=L(b,"Text",UDim2.fromScale(.68,.82),UDim2.fromScale(.25,.09),n,8,C.S,130);tabLabels[i]=tx;tabBtns[i]=b;touchAnim(b)
 b.Activated:Connect(function()selectTab(i)end)
 return b
end

local function makeFunc(i,n)
 local b=B(Funcs,"Func"..i,UDim2.new(.88,0,0,46),UDim2.new(),124);b.LayoutOrder=i;b.BackgroundColor3=C.P2;b.BackgroundTransparency=.64
 local dot=F(b,"Dot",UDim2.fromOffset(6,6),UDim2.fromScale(.035,.42),C.P3,.05,130);Cr(dot,5)
 local tx=L(b,"Text",UDim2.fromScale(.70,.75),UDim2.fromScale(.12,.12),n,8,C.S,130);funcLabels[i]=tx;funcBtns[i]=b;touchAnim(b)
 b.Activated:Connect(function()selectFunc(i,true)end)
 return b
end

function selectFunc(i,flash)
 currentFunc=math.clamp(i,1,#DATA[T[currentTab]]);local list=DATA[T[currentTab]]
 for k,b in ipairs(funcBtns)do local on=k==currentFunc;Play(b,.18,{BackgroundTransparency=on and .12 or .64},Enum.EasingStyle.Quint);local s=Sc(b,1);Play(s,.18,{Scale=on and 1.045 or 1},Enum.EasingStyle.Back);if funcLabels[k] then funcLabels[k].TextColor3=on and C.W or C.S end end
 Status.Text="SELECTED  •  "..list[currentFunc]
 if flash then Play(CenterLine,.12,{Size=UDim2.fromScale(.80,.008)},Enum.EasingStyle.Quint);task.delay(.14,function()if CenterLine.Parent then Play(CenterLine,.25,{Size=UDim2.fromScale(.72,.008)},Enum.EasingStyle.Quint)end end)end
end

function selectTab(i)
 currentTab=math.clamp(i,1,#T);currentFunc=1;Page.Text=T[currentTab];Desc.Text=tostring(#DATA[T[currentTab]]).." FUNCTIONS  •  SMART DRAG"
 for k,b in ipairs(tabBtns)do local on=k==currentTab;Play(b,.20,{BackgroundTransparency=on and .10 or .65},Enum.EasingStyle.Quint);local s=Sc(b,1);Play(s,.20,{Scale=on and 1.055 or 1},Enum.EasingStyle.Back);if tabLabels[k] then tabLabels[k].TextColor3=on and C.W or C.S end end
 for _,b in ipairs(funcBtns)do b:Destroy()end;funcBtns={};funcLabels={}
 for j,n in ipairs(DATA[T[currentTab]])do makeFunc(j,n) end
 task.defer(function()Funcs.CanvasSize=UDim2.new(0,0,0,FL.AbsoluteContentSize.Y+8)end)
 selectFunc(1,false)
end
for i,n in ipairs(T)do makeTab(i,n)end
TL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()Tabs.CanvasSize=UDim2.new(0,0,0,TL.AbsoluteContentSize.Y+8)end)
FL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()Funcs.CanvasSize=UDim2.new(0,0,0,FL.AbsoluteContentSize.Y+8)end)

-- Smart rail gesture: tap selects; vertical hold+drag changes the active item.
local function smartRail(obj,count,getIndex,setIndex,threshold)
 local down=false;local startY=0;local startX=0;local moved=false;local last=0
 obj.InputBegan:Connect(function(i)
  if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then down=true;startY=i.Position.Y;startX=i.Position.X;moved=false;last=0 end
 end)
 UIS.InputChanged:Connect(function(i)
  if not down or (i.UserInputType~=Enum.UserInputType.Touch and i.UserInputType~=Enum.UserInputType.MouseMovement) then return end
  local dy=i.Position.Y-startY
  if math.abs(dy)>8 then moved=true end
  local step=math.floor(math.abs(dy)/threshold)
  if step~=last and step>0 then
   local idx=getIndex();idx=math.clamp(idx+(dy<0 and 1 or -1),1,count);setIndex(idx);last=step
  end
 end)
 UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then down=false end end)
end
smartRail(Tabs,#T,function()return currentTab end,selectTab,42)
smartRail(Funcs,#DATA[T[currentTab]],function()return currentFunc end,function(i)selectFunc(i,true)end,50)

-- Search filters the right-side function rail.
Search:GetPropertyChangedSignal("Text"):Connect(function()
 local q=string.lower(Search.Text or "")
 for _,b in ipairs(funcBtns)do local tx=b:FindFirstChild("Text");b.Visible=(q=="" or (tx and string.find(string.lower(tx.Text),q,1,true)~=nil))end
end)

-- Drag menu by header; clamp to viewport. Launcher is independently draggable everywhere.
local function dragAnywhere(obj,clampIt)
 local active=false;local start;local base;local moved=false
 obj.InputBegan:Connect(function(i)
  if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then active=true;moved=false;start=i.Position;base=obj.Position end
 end)
 UIS.InputChanged:Connect(function(i)
  if not active or (i.UserInputType~=Enum.UserInputType.Touch and i.UserInputType~=Enum.UserInputType.MouseMovement) then return end
  local d=i.Position-start;if math.abs(d.X)+math.abs(d.Y)>4 then moved=true end
  local x=base.X.Offset+d.X;local y=base.Y.Offset+d.Y
  if clampIt then
   local cam=workspace.CurrentCamera;local v=cam and cam.ViewportSize or Vector2.new(1000,700);local sz=obj.AbsoluteSize
   x=math.clamp(x,-v.X+72,v.X-72-sz.X);y=math.clamp(y,-v.Y+72,v.Y-72-sz.Y)
  end
  obj.Position=UDim2.new(base.X.Scale,x,base.Y.Scale,y)
 end)
 UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then active=false end end)
end
dragAnywhere(Header,true);dragAnywhere(Launcher,true)

local function openMenu()
 if open or busy then return end;busy=true;open=true;Menu.Visible=true;Launcher.Visible=false
 local p=Menu.Position;MScale.Scale=.72;Menu.Position=UDim2.new(p.X.Scale,p.X.Offset,p.Y.Scale+.025,p.Y.Offset+14);Menu.BackgroundTransparency=.72
 Play(MScale,.42,{Scale=1},Enum.EasingStyle.Back);Play(Menu,.42,{Position=p,BackgroundTransparency=.22},Enum.EasingStyle.Quint)
 Play(Header,.28,{BackgroundTransparency=.34},Enum.EasingStyle.Quint);Play(Body,.34,{BackgroundTransparency=.58},Enum.EasingStyle.Quint)
 task.delay(.44,function()busy=false end)
end
local function closeMenu()
 if not open or busy then return end;busy=true;open=false
 Play(MScale,.23,{Scale=.72},Enum.EasingStyle.Quint);Play(Menu,.23,{Position=UDim2.new(Menu.Position.X.Scale,Menu.Position.X.Offset,Menu.Position.Y.Scale+.018,Menu.Position.Y.Offset+10),BackgroundTransparency=.78},Enum.EasingStyle.Quad)
 task.delay(.24,function()if not open then Menu.Visible=false;Launcher.Visible=true;local s=Sc(Launcher,.72);Play(s,.30,{Scale=1},Enum.EasingStyle.Back)end;busy=false end)
end
Close.Activated:Connect(function()ripple(Close);press(Close);closeMenu()end)
Z.Activated:Connect(function()ripple(Z);press(Z);closeMenu()end)
Launcher.Activated:Connect(function()ripple(Launcher);press(Launcher);openMenu()end)

-- Small ambient breathing animation; never creates a full-screen layer.
local t=0
Run.RenderStepped:Connect(function(dt)
 if not G.Parent then return end;t+=dt
 if settings.glow then local q=(math.sin(t*2)+1)/2;MS.Transparency=.10+.15*q end
 local q=(math.sin(t*1.8)+1)/2
 local zs=Z:FindFirstChild("SCALE");if zs and open then zs.Scale=1+q*.025 end
 local rs=LR:FindFirstChildOfClass("UIStroke");if rs then rs.Transparency=.28+.16*q end
end)

selectTab(1);Menu.Visible=true;Launcher.Visible=false
_G.ZAKA_PINK_UI_V15={Gui=G,Menu=Menu,Launcher=Launcher,Open=openMenu,Close=closeMenu,SelectTab=selectTab,SelectFunction=selectFunc}
