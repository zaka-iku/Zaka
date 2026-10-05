-- ZAKA DOORS MENU - UI BUILD
-- P = hide/show main menu; active status bar remains visible.
-- UI-only rebuild: fixed crosshair, draggable glass menu, tabs,
-- keyboard/mouse visualizer, rainbow borders.
-- Camera/input exploit engines are intentionally not included.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local old = PlayerGui:FindFirstChild("ZAKA_DOORS_MENU")
if old then old:Destroy() end

local Gui = Instance.new("ScreenGui")
Gui.Name = "ZAKA_DOORS_MENU"
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

local PINK = Color3.fromRGB(255,75,170)
local WHITE = Color3.fromRGB(255,255,255)
local DARK = Color3.fromRGB(12,12,18)
local CARD = Color3.fromRGB(24,24,34)

local function corner(o,r)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r or 8)
    c.Parent=o
end

local function stroke(o,c,t,tr)
    local s=Instance.new("UIStroke")
    s.Color=c
    s.Thickness=t or 1
    s.Transparency=tr or 0
    s.Parent=o
    return s
end

-- Fixed center crosshair
local Crosshair=Instance.new("Frame")
Crosshair.Size=UDim2.fromOffset(4,4)
Crosshair.AnchorPoint=Vector2.new(.5,.5)
Crosshair.Position=UDim2.fromScale(.5,.5)
Crosshair.BackgroundColor3=WHITE
Crosshair.BorderSizePixel=0
Crosshair.ZIndex=50
Crosshair.Parent=Gui
corner(Crosshair,4)
stroke(Crosshair,Color3.fromRGB(0,0,0),1,.35)

-- Notification
local function notify(msg)
    local n=Instance.new("TextLabel")
    n.Size=UDim2.fromOffset(250,38)
    n.AnchorPoint=Vector2.new(.5,0)
    n.Position=UDim2.new(.5,0,.07,0)
    n.BackgroundColor3=DARK
    n.BackgroundTransparency=.12
    n.TextColor3=WHITE
    n.Text=msg
    n.Font=Enum.Font.GothamBold
    n.TextSize=13
    n.ZIndex=100
    n.Parent=Gui
    corner(n,10)
    stroke(n,PINK,1,.15)
    task.delay(1.3,function()
        if n.Parent then
            local t=TweenService:Create(n,TweenInfo.new(.3),{
                TextTransparency=1,BackgroundTransparency=1
            })
            t:Play()
            t.Completed:Connect(function()
                if n then n:Destroy() end
            end)
        end
    end)
end

-- Bottom active-key bar: remains visible while menu is hidden
local Status=Instance.new("Frame")
Status.Size=UDim2.fromOffset(520,58)
Status.AnchorPoint=Vector2.new(.5,1)
Status.Position=UDim2.new(.5,0,1,-18)
Status.BackgroundColor3=Color3.fromRGB(10,10,15)
Status.BackgroundTransparency=.58
Status.ZIndex=30
Status.Parent=Gui
corner(Status,14)
local statusStroke=stroke(Status,PINK,2,.05)

local sl=Instance.new("UIListLayout")
sl.FillDirection=Enum.FillDirection.Horizontal
sl.HorizontalAlignment=Enum.HorizontalAlignment.Center
sl.VerticalAlignment=Enum.VerticalAlignment.Center
sl.Padding=UDim.new(0,8)
sl.Parent=Status

local active={}
local function showKey(name)
    if active[name] then return end
    local b=Instance.new("TextLabel")
    b.Size=UDim2.fromOffset(48,40)
    b.BackgroundColor3=WHITE
    b.BackgroundTransparency=.93
    b.Text=name
    b.TextColor3=WHITE
    b.Font=Enum.Font.GothamBold
    b.TextSize=12
    b.ZIndex=31
    b.Parent=Status
    corner(b,8)
    active[name]={label=b,stroke=stroke(b,PINK,2,.05)}
end

local function hideKey(name)
    local x=active[name]
    if not x then return end
    x.label:Destroy()
    active[name]=nil
end

local hue=0
RunService.RenderStepped:Connect(function(dt)
    hue=(hue+dt*.35)%1
    local c=Color3.fromHSV(hue,1,1)
    statusStroke.Color=c
    for _,x in pairs(active) do
        if x.stroke then x.stroke.Color=c end
    end
end)

-- Main glass menu
local Main=Instance.new("Frame")
Main.Size=UDim2.fromOffset(780,360)
Main.AnchorPoint=Vector2.new(.5,.5)
Main.Position=UDim2.fromScale(.5,.5)
Main.BackgroundColor3=DARK
Main.BackgroundTransparency=.16
Main.ZIndex=10
Main.Parent=Gui
corner(Main,18)
stroke(Main,PINK,2,.12)

local Header=Instance.new("Frame")
Header.Size=UDim2.new(1,0,0,54)
Header.BackgroundTransparency=1
Header.Parent=Main

local Title=Instance.new("TextLabel")
Title.Size=UDim2.new(1,-30,1,0)
Title.Position=UDim2.fromOffset(15,0)
Title.BackgroundTransparency=1
Title.Text="ZAKA • DOORS CONTROL"
Title.TextColor3=WHITE
Title.Font=Enum.Font.GothamBold
Title.TextSize=19
Title.TextXAlignment=Enum.TextXAlignment.Left
Title.Parent=Header

local Sub=Instance.new("TextLabel")
Sub.Size=UDim2.new(1,-30,0,20)
Sub.Position=UDim2.fromOffset(15,29)
Sub.BackgroundTransparency=1
Sub.Text="P = Hide / Show  •  Active controls stay visible"
Sub.TextColor3=Color3.fromRGB(190,190,205)
Sub.Font=Enum.Font.Gotham
Sub.TextSize=10
Sub.TextXAlignment=Enum.TextXAlignment.Left
Sub.Parent=Header

-- Drag whole menu
local dragging=false
local dragStart
local startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
    or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        dragStart=input.Position
        startPos=Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement
    or input.UserInputType==Enum.UserInputType.Touch) then
        local d=input.Position-dragStart
        Main.Position=UDim2.new(
            startPos.X.Scale,startPos.X.Offset+d.X,
            startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
    or input.UserInputType==Enum.UserInputType.Touch then
        dragging=false
    end
end)

-- Left tabs
local Rail=Instance.new("ScrollingFrame")
Rail.Size=UDim2.fromOffset(145,285)
Rail.Position=UDim2.fromOffset(12,65)
Rail.BackgroundTransparency=1
Rail.BorderSizePixel=0
Rail.ScrollBarThickness=2
Rail.Parent=Main

local rl=Instance.new("UIListLayout")
rl.Padding=UDim.new(0,7)
rl.Parent=Rail

-- Content
local Content=Instance.new("Frame")
Content.Size=UDim2.fromOffset(585,285)
Content.Position=UDim2.fromOffset(172,65)
Content.BackgroundColor3=CARD
Content.BackgroundTransparency=.27
Content.Parent=Main
corner(Content,14)
stroke(Content,WHITE,1,.82)

local ContentTitle=Instance.new("TextLabel")
ContentTitle.Size=UDim2.new(1,-24,0,35)
ContentTitle.Position=UDim2.fromOffset(12,5)
ContentTitle.BackgroundTransparency=1
ContentTitle.TextColor3=WHITE
ContentTitle.Font=Enum.Font.GothamBold
ContentTitle.TextSize=16
ContentTitle.TextXAlignment=Enum.TextXAlignment.Left
ContentTitle.Parent=Content

local Body=Instance.new("ScrollingFrame")
Body.Size=UDim2.new(1,-20,1,-48)
Body.Position=UDim2.fromOffset(10,42)
Body.BackgroundTransparency=1
Body.BorderSizePixel=0
Body.ScrollBarThickness=3
Body.Parent=Content

local bl=Instance.new("UIListLayout")
bl.Padding=UDim.new(0,8)
bl.Parent=Body

local function clearBody()
    for _,x in ipairs(Body:GetChildren()) do
        if x:IsA("GuiObject") then x:Destroy() end
    end
end

local function info(text)
    local l=Instance.new("TextLabel")
    l.Size=UDim2.new(1,-4,0,48)
    l.BackgroundColor3=WHITE
    l.BackgroundTransparency=.94
    l.Text=text
    l.TextColor3=WHITE
    l.Font=Enum.Font.Gotham
    l.TextSize=12
    l.TextWrapped=true
    l.Parent=Body
    corner(l,9)
end

local function toggle(text,initial,callback)
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(1,-4,0,42)
    b.BackgroundColor3=initial and Color3.fromRGB(50,150,100) or Color3.fromRGB(40,40,52)
    b.BackgroundTransparency=.18
    b.TextColor3=WHITE
    b.Font=Enum.Font.GothamBold
    b.TextSize=12
    b.Parent=Body
    corner(b,9)
    local state=initial
    local function refresh()
        b.Text=text.."   ["..(state and "ON" or "OFF").."]"
        b.BackgroundColor3=state and Color3.fromRGB(50,150,100) or Color3.fromRGB(40,40,52)
    end
    refresh()
    b.MouseButton1Click:Connect(function()
        state=not state
        refresh()
        if callback then callback(state) end
    end)
end

local tabs={"HOME","CROSSHAIR","CONTROLS","VISUALIZER","CAMERA","SETTINGS","ABOUT"}

local function selectTab(name)
    ContentTitle.Text=name
    clearBody()

    if name=="HOME" then
        info("ZAKA DOORS MENU\nPress P to hide/show the main menu.")
        info("The bottom active-key bar stays visible when the menu is hidden.")
        toggle("Active-key bar",true,function(v) Status.Visible=v end)
    elseif name=="CROSSHAIR" then
        info("Fixed center crosshair")
        toggle("Crosshair",true,function(v) Crosshair.Visible=v end)
    elseif name=="CONTROLS" then
        info("Keyboard/mouse visualizer. Held inputs appear in the bottom bar.")
        info("This rebuild keeps the UI separate from synthetic game input.")
    elseif name=="VISUALIZER" then
        info("Rainbow-border active status bar is always independent from the menu.")
    elseif name=="CAMERA" then
        info("Camera panel reserved for a clean single-controller setup in a game you own. Multiple competing camera engines are avoided.")
    elseif name=="SETTINGS" then
        info("P = hide/show. Menu visibility does not change active-key states.")
    elseif name=="ABOUT" then
        info("ZAKA glass UI • mobile-friendly • draggable • fixed center crosshair")
    end
    Body.CanvasSize=UDim2.new(0,0,0,bl.AbsoluteContentSize.Y+10)
end

for _,name in ipairs(tabs) do
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(1,-5,0,35)
    b.BackgroundColor3=Color3.fromRGB(28,28,40)
    b.BackgroundTransparency=.2
    b.Text=name
    b.TextColor3=WHITE
    b.Font=Enum.Font.GothamBold
    b.TextSize=11
    b.Parent=Rail
    corner(b,9)
    stroke(b,WHITE,1,.9)
    b.MouseButton1Click:Connect(function() selectTab(name) end)
end
Rail.CanvasSize=UDim2.new(0,0,0,rl.AbsoluteContentSize.Y+5)

-- Menu toggle button
local Toggle=Instance.new("TextButton")
Toggle.Size=UDim2.fromOffset(82,38)
Toggle.Position=UDim2.fromOffset(16,16)
Toggle.BackgroundColor3=DARK
Toggle.BackgroundTransparency=.18
Toggle.Text="HIDE"
Toggle.TextColor3=WHITE
Toggle.Font=Enum.Font.GothamBold
Toggle.TextSize=12
Toggle.ZIndex=40
Toggle.Parent=Gui
corner(Toggle,10)
stroke(Toggle,PINK,2,.05)

local menuVisible=true
local function setMenuVisible(v)
    menuVisible=v
    if v then
        Main.Visible=true
        Toggle.Text="HIDE"
        TweenService:Create(Main,TweenInfo.new(.18),{BackgroundTransparency=.16}):Play()
    else
        Toggle.Text="MENU"
        local t=TweenService:Create(Main,TweenInfo.new(.14),{BackgroundTransparency=1})
        t:Play()
        t.Completed:Connect(function()
            if not menuVisible then Main.Visible=false end
        end)
    end
end

Toggle.MouseButton1Click:Connect(function()
    setMenuVisible(not menuVisible)
end)

-- P = hide/show
UserInputService.InputBegan:Connect(function(input,processed)
    if processed then return end
    if input.UserInputType==Enum.UserInputType.Keyboard
    and input.KeyCode==Enum.KeyCode.P then
        setMenuVisible(not menuVisible)
    end
end)

-- Input visualizer
local watched={
    W=true,A=true,S=true,D=true,E=true,Q=true,R=true,
    F=true,G=true,H=true,J=true,K=true,L=true,
    Space=true,LeftShift=true,Escape=true,Tab=true
}

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Keyboard then
        local n=input.KeyCode.Name
        if watched[n] then showKey(n) end
    elseif input.UserInputType==Enum.UserInputType.MouseButton1 then
        showKey("L-Mouse")
    elseif input.UserInputType==Enum.UserInputType.MouseButton2 then
        showKey("R-Mouse")
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Keyboard then
        hideKey(input.KeyCode.Name)
    elseif input.UserInputType==Enum.UserInputType.MouseButton1 then
        hideKey("L-Mouse")
    elseif input.UserInputType==Enum.UserInputType.MouseButton2 then
        hideKey("R-Mouse")
    end
end)

selectTab("HOME")
notify("ZAKA menu loaded • Press P to hide")
