-- ZAKA PINK PANTHER DROP FLOWER V4 — FIXED BUILD
-- Repairs: Orb Activated compatibility + CARD_REGISTRY brace syntax.
--[[
=====================================================================
 ZAKA PINK PANTHER — DROP FLOWER V4
 100KB+ REAL ANIMATED MENU EDITION
 ---------------------------------------------------------------------
 UI/animation package only. No gameplay automation is connected here.
 Designed for touch-first Roblox UI prototypes and experiences you own.

 CORE VISUAL PIPELINE
   Z ORB -> LIQUID DROPLET -> FLOWER CORE -> GLASS BODY -> PANTHER

 V4 goals:
 - Circular Z orb, never a plain text Z button.
 - Circle stretches into a droplet before the menu appears.
 - Closing reverses the liquid morph and returns to the orb.
 - Pink Panther is rendered with a transparent local asset when present.
 - 20 animated tabs, curved function rails, glass layers, rings, petals.
 - Mobile touch drag, press ripple, tab growth, search filtering.
 - Reusable UI component system instead of dead placeholder controls.
 - GitHub asset loader hooks are included in CONFIG.
=====================================================================
]]


local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function safeParent(gui)
    local ok = pcall(function() gui.Parent = CoreGui end)
    if not ok or not gui.Parent then gui.Parent = PlayerGui end
end

local OLD_NAMES = {
    "ZAKA_PINK_PANTHER_DROP_FLOWER",
    "ZAKA_PINK_PANTHER_DROP_FLOWER_V3",
    "ZAKA_PINK_PANTHER_DROP_FLOWER_V4",
}
for _,name in ipairs(OLD_NAMES) do
    local old = PlayerGui:FindFirstChild(name)
    if old then old:Destroy() end
    local oldCore = CoreGui:FindFirstChild(name)
    if oldCore then oldCore:Destroy() end
end

local CONFIG = {
    AssetBase = "", -- Example: https://raw.githubusercontent.com/USERNAME/REPO/main/assets
    PantherFile = "ZAKA_PinkPanther_Transparent_V4.png",
    BackgroundFile = "ZAKA_PinkPanther_Background_V4.jpg",
    LocalPantherFile = "PinkPanther_Transparent_V4.png",
    LocalBackgroundFile = "PinkPanther_Background.jpg",
    UseGitHubAssets = false,
    AnimationSpeed = 1.0,
    GlassTransparency = 0.20,
    PanelTransparency = 0.30,
    CardTransparency = 0.42,
    GlowStrength = 0.55,
    CurveAmplitude = 34,
    CurveWidth = 250,
    TouchScale = 1,
    StartWithOrb = true,
    RainbowBorder = true,
    SoftBlur = true,
    EnableUIAudio = false,
}

local C = {
    Pink = Color3.fromRGB(255, 125, 184),
    Pink2 = Color3.fromRGB(255, 170, 210),
    Pink3 = Color3.fromRGB(255, 215, 235),
    DeepPink = Color3.fromRGB(218, 64, 133),
    Rose = Color3.fromRGB(182, 48, 105),
    White = Color3.fromRGB(255, 250, 254),
    Ink = Color3.fromRGB(53, 18, 39),
    Glass = Color3.fromRGB(255, 155, 200),
    GlassDark = Color3.fromRGB(135, 40, 82),
    Shadow = Color3.fromRGB(90, 18, 54),
    Soft = Color3.fromRGB(255, 235, 246),
}

local TAB_DATA = {
    {id=1, name="COMBAT", icon="⚔", description="Khu Combat — đang để dành cho bản sau"},
    {id=2, name="ESP", icon="◉", description="Debug/visual tools an toàn cho trải nghiệm của bạn"},
    {id=3, name="PLAYER", icon="♙", description="Thông tin nhân vật & camera cục bộ"},
    {id=4, name="TROLL", icon="✦", description="Hiệu ứng vui chỉ tác động lên UI của bạn"},
    {id=5, name="ULTRA", icon="⚡", description="Hiệu năng, chất lượng và kiểm tra hệ thống"},
    {id=6, name="SERVER", icon="◎", description="Thông tin phiên/server hiện tại"},
    {id=7, name="SETTING", icon="⚙", description="Điều khiển giao diện Pink Panther"},
    {id=8, name="HOME", icon="⌂", description="Hub tổng hợp 20 module giao diện V4"},
}

-- ZAKA PINK PANTHER DROP FLOWER V4 — FIXED BUILD
-- Repairs: Orb Activated compatibility + CARD_REGISTRY brace syntax.
--[[
=====================================================================
 ZAKA PINK PANTHER — DROP FLOWER V4
 100KB+ REAL ANIMATED MENU EDITION
 ---------------------------------------------------------------------
 UI/animation package only. No gameplay automation is connected here.
 Designed for touch-first Roblox UI prototypes and experiences you own.

 CORE VISUAL PIPELINE
   Z ORB -> LIQUID DROPLET -> FLOWER CORE -> GLASS BODY -> PANTHER

 V4 goals:
 - Circular Z orb, never a plain text Z button.
 - Circle stretches into a droplet before the menu appears.
 - Closing reverses the liquid morph and returns to the orb.
 - Pink Panther is rendered with a transparent local asset when present.
 - 20 animated tabs, curved function rails, glass layers, rings, petals.
 - Mobile touch drag, press ripple, tab growth, search filtering.
 - Reusable UI component system instead of dead placeholder controls.
 - GitHub asset loader hooks are included in CONFIG.
=====================================================================
]]


local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function safeParent(gui)
    local ok = pcall(function() gui.Parent = CoreGui end)
    if not ok or not gui.Parent then gui.Parent = PlayerGui end
end

local OLD_NAMES = {
    "ZAKA_PINK_PANTHER_DROP_FLOWER",
    "ZAKA_PINK_PANTHER_DROP_FLOWER_V3",
    "ZAKA_PINK_PANTHER_DROP_FLOWER_V4",
}
for _,name in ipairs(OLD_NAMES) do
    local old = PlayerGui:FindFirstChild(name)
    if old then old:Destroy() end
    local oldCore = CoreGui:FindFirstChild(name)
    if oldCore then oldCore:Destroy() end
end

local CONFIG = {
    AssetBase = "", -- Example: https://raw.githubusercontent.com/USERNAME/REPO/main/assets
    PantherFile = "ZAKA_PinkPanther_Transparent_V4.png",
    BackgroundFile = "ZAKA_PinkPanther_Background_V4.jpg",
    LocalPantherFile = "PinkPanther_Transparent_V4.png",
    LocalBackgroundFile = "PinkPanther_Background.jpg",
    UseGitHubAssets = false,
    AnimationSpeed = 1.0,
    GlassTransparency = 0.20,
    PanelTransparency = 0.30,
    CardTransparency = 0.42,
    GlowStrength = 0.55,
    CurveAmplitude = 34,
    CurveWidth = 250,
    TouchScale = 1,
    StartWithOrb = true,
    RainbowBorder = true,
    SoftBlur = true,
    EnableUIAudio = false,
}

local C = {
    Pink = Color3.fromRGB(255, 125, 184),
    Pink2 = Color3.fromRGB(255, 170, 210),
    Pink3 = Color3.fromRGB(255, 215, 235),
    DeepPink = Color3.fromRGB(218, 64, 133),
    Rose = Color3.fromRGB(182, 48, 105),
    White = Color3.fromRGB(255, 250, 254),
    Ink = Color3.fromRGB(53, 18, 39),
    Glass = Color3.fromRGB(255, 155, 200),
    GlassDark = Color3.fromRGB(135, 40, 82),
    Shadow = Color3.fromRGB(90, 18, 54),
    Soft = Color3.fromRGB(255, 235, 246),
}

local TAB_DATA = {
    {id=1, name="COMBAT", icon="⚔", description="Khu Combat — đang để dành cho bản sau"},
    {id=2, name="ESP", icon="◉", description="Debug/visual tools an toàn cho trải nghiệm của bạn"},
    {id=3, name="PLAYER", icon="♙", description="Thông tin nhân vật & camera cục bộ"},
    {id=4, name="TROLL", icon="✦", description="Hiệu ứng vui chỉ tác động lên UI của bạn"},
    {id=5, name="ULTRA", icon="⚡", description="Hiệu năng, chất lượng và kiểm tra hệ thống"},
    {id=6, name="SERVER", icon="◎", description="Thông tin phiên/server hiện tại"},
    {id=7, name="SETTING", icon="⚙", description="Điều khiển giao diện Pink Panther"},
    {id=8, name="HOME", icon="⌂", description="Hub tổng hợp 20 module giao diện V4"},
}

local CARD_DATA = {    [1] = {
        {title="HOME", description="Tổng quan menu và trạng thái", mode="ACTION", value=0.72, icon="⌂", action="toast"},
        {title="STYLE", description="Màu sắc và phong cách", mode="ACTION", value=0.72, icon="✦", action="theme"},
        {title="MOTION", description="Animation và chuyển động", mode="ACTION", value=0.72, icon="◌", action="animation"},
        {title="FLOWER", description="Hoa trung tâm", mode="ACTION", value=0.72, icon="✿", action="flower"},
        {title="PANTHER", description="Silhouette và hiệu ứng Panther", mode="ACTION", value=0.72, icon="🐆", action="panther"},
        {title="GLASS", description="Glass và transparency", mode="ACTION", value=0.72, icon="◈", action="glass"},
        {title="LIGHT", description="Glow và ánh sáng", mode="ACTION", value=0.72, icon="☼", action="glow"},
        {title="RINGS", description="Vòng xoay", mode="ACTION", value=0.72, icon="◎", action="rings"},
        {title="DROPLET", description="Liquid droplet", mode="ACTION", value=0.72, icon="◉", action="droplet"},
        {title="CURVE", description="Đường cong UI", mode="ACTION", value=0.72, icon="⌁", action="curve"},
        {title="TABS", description="Hệ thống tab", mode="ACTION", value=0.72, icon="▤", action="tabs"},
        {title="CARDS", description="Function cards", mode="ACTION", value=0.72, icon="▦", action="cards"},
        {title="SEARCH", description="Tìm kiếm", mode="ACTION", value=0.72, icon="⌕", action="search"},
        {title="TOUCH", description="Touch mobile", mode="ACTION", value=0.72, icon="☝", action="touch"},
        {title="DRAG", description="Kéo thả", mode="ACTION", value=0.72, icon="✥", action="dock"},
        {title="SOUND", description="UI audio state", mode="ACTION", value=0.72, icon="♫", action="sound"},
        {title="FX", description="Particle và ripple", mode="ACTION", value=0.72, icon="✧", action="fx"},
        {title="THEME", description="Theme presets", mode="ACTION", value=0.72, icon="◐", action="theme_cycle"},
        {title="PREVIEW", description="Preview animation", mode="ACTION", value=0.72, icon="▣", action="preview"},
        {title="SETTINGS", description="Bảng cài đặt", mode="ACTION", value=0.72, icon="⚙", action="settings"},
    },    [2] = {        {title="Debug Preview", description="Bật lớp preview trực quan của UI", mode="ACTION", value=0.72, icon="◉", action="esp_preview"},        {title="Focus Ring", description="Hiện vòng focus ở tâm menu", mode="ACTION", value=0.72, icon="🎯", action="focus_ring"},        {title="Screen Grid", description="Bật lưới căn chỉnh UI", mode="ACTION", value=0.72, icon="▣", action="grid"},        {title="Crosshair Preview", description="Preview tâm ngắm, chỉ là UI", mode="ACTION", value=0.72, icon="⌖", action="crosshair"},        {title="Distance Ruler", description="Thước khoảng cách trên UI", mode="ACTION", value=0.72, icon="📏", action="ruler"},        {title="Tag Overlay", description="Preview nhãn debug", mode="ACTION", value=0.72, icon="🏷", action="tags"},        {title="Color Scanner", description="Đổi màu accent theo chu kỳ", mode="ACTION", value=0.72, icon="🌈", action="accent_cycle"},        {title="Pulse Scanner", description="Pulse vòng visual", mode="ACTION", value=0.72, icon="◌", action="pulse"},        {title="Opacity Scan", description="Preview độ trong suốt", mode="ACTION", value=0.72, icon="◒", action="glass"},        {title="Outline Scan", description="Tăng viền card", mode="ACTION", value=0.72, icon="◈", action="outline"},        {title="Glow Scan", description="Tăng glow giao diện", mode="ACTION", value=0.72, icon="✦", action="glow"},        {title="Curve Scan", description="Preview curve", mode="ACTION", value=0.72, icon="⌁", action="curve"},        {title="Bounds View", description="Hiện khung căn chỉnh menu", mode="ACTION", value=0.72, icon="☷", action="bounds"},        {title="Center Marker", description="Đánh dấu tâm menu", mode="ACTION", value=0.72, icon="⊙", action="center"},        {title="Horizontal Guide", description="Guide ngang UI", mode="ACTION", value=0.72, icon="↔", action="guide_h"},        {title="Vertical Guide", description="Guide dọc UI", mode="ACTION", value=0.72, icon="↕", action="guide_v"},        {title="Radar Preview", description="Radar vòng tròn UI", mode="ACTION", value=0.72, icon="◍", action="radar"},        {title="Highlight Pulse", description="Pulse highlight", mode="ACTION", value=0.72, icon="⚡", action="highlight"},        {title="Visual Test", description="Chạy visual test", mode="ACTION", value=0.72, icon="🧪", action="visual_test"},        {title="Clear Visuals", description="Xóa preview visual", mode="ACTION", value=0.72, icon="↺", action="clear_visuals"},    },    [3] = {        {title="Player Info", description="Hiện thông tin nhân vật local", mode="ACTION", value=0.72, icon="♙", action="player_info"},        {title="Health Info", description="Hiện máu nhân vật local", mode="ACTION", value=0.72, icon="❤", action="health_info"},        {title="Movement Info", description="Hiện trạng thái di chuyển", mode="ACTION", value=0.72, icon="🏃", action="movement_info"},        {title="Camera Info", description="Hiện FOV camera", mode="ACTION", value=0.72, icon="📷", action="camera_info"},        {title="FOV +", description="Tăng FOV camera local", mode="ACTION", value=0.72, icon="🔭", action="fov_up"},        {title="FOV -", description="Giảm FOV camera local", mode="ACTION", value=0.72, icon="🔎", action="fov_down"},        {title="Reset Camera", description="Đưa FOV về mặc định", mode="ACTION", value=0.72, icon="↺", action="reset_camera"},        {title="Camera Center", description="Đưa UI về tâm", mode="ACTION", value=0.72, icon="◎", action="center"},        {title="Touch Scale +", description="Tăng kích thước touch UI", mode="ACTION", value=0.72, icon="📱", action="touch_up"},        {title="Touch Scale -", description="Giảm kích thước touch UI", mode="ACTION", value=0.72, icon="📱", action="touch_down"},        {title="Dock Menu", description="Ghim orb vào mép gần nhất", mode="ACTION", value=0.72, icon="🧭", action="dock"},        {title="Respawn UI", description="Làm mới UI sau respawn", mode="ACTION", value=0.72, icon="🔄", action="refresh"},        {title="Smooth Motion", description="Bật profile animation mượt", mode="ACTION", value=0.72, icon="⌁", action="smooth"},        {title="Fast Motion", description="Tăng profile animation", mode="ACTION", value=0.72, icon="⚡", action="fast"},        {title="Liquid Preview", description="Preview biến dạng giọt", mode="ACTION", value=0.72, icon="🫧", action="droplet"},        {title="Soft Bounce", description="Bounce toàn menu", mode="ACTION", value=0.72, icon="🎈", action="bounce"},        {title="Glass Player", description="Glass profile nhẹ", mode="ACTION", value=0.72, icon="🧊", action="glass"},        {title="Player Highlight", description="Highlight panel thông tin", mode="ACTION", value=0.72, icon="✨", action="highlight"},        {title="Stats Card", description="Hiện card thống kê local", mode="ACTION", value=0.72, icon="📊", action="stats"},        {title="Reset Player UI", description="Reset các thiết lập UI", mode="ACTION", value=0.72, icon="↺", action="reset"},    },    [4] = {        {title="Fake Alert", description="Thông báo vui trên màn hình", mode="ACTION", value=0.72, icon="😂", action="toast"},        {title="Confetti", description="Bắn confetti UI", mode="ACTION", value=0.72, icon="🎉", action="confetti"},        {title="Screen Shake", description="Rung UI nhẹ", mode="ACTION", value=0.72, icon="📳", action="shake"},        {title="Rainbow Flash", description="Flash màu nhẹ", mode="ACTION", value=0.72, icon="🌈", action="rainbow_flash"},        {title="Impact FX", description="Hiệu ứng impact UI", mode="ACTION", value=0.72, icon="💥", action="impact"},        {title="Drop Splash", description="Splash giọt nước", mode="ACTION", value=0.72, icon="💧", action="splash"},        {title="Heart Pulse", description="Pulse trái tim", mode="ACTION", value=0.72, icon="💗", action="heart"},        {title="Star Burst", description="Burst sao", mode="ACTION", value=0.72, icon="⭐", action="stars"},        {title="Spin UI", description="Xoay panel nhẹ", mode="ACTION", value=0.72, icon="🌀", action="spin"},        {title="Bounce UI", description="Nảy panel", mode="ACTION", value=0.72, icon="🎈", action="bounce"},        {title="Ghost Fade", description="Fade in/out nhẹ", mode="ACTION", value=0.72, icon="👻", action="ghost"},        {title="Ping FX", description="Ping visual", mode="ACTION", value=0.72, icon="🔔", action="ping"},        {title="Sparkle", description="Sparkle quanh menu", mode="ACTION", value=0.72, icon="✨", action="sparkle"},        {title="Petal Rain", description="Mưa cánh hoa UI", mode="ACTION", value=0.72, icon="🌸", action="petals"},        {title="Orbit FX", description="Orbit vòng quanh tâm", mode="ACTION", value=0.72, icon="💫", action="orbit"},        {title="Lightning FX", description="Flash tia UI", mode="ACTION", value=0.72, icon="⚡", action="lightning"},        {title="Prank Theme", description="Đổi theme ngẫu nhiên", mode="ACTION", value=0.72, icon="🎭", action="theme_cycle"},        {title="Sound Ping", description="Bật/tắt UI audio state", mode="ACTION", value=0.72, icon="🔊", action="sound"},        {title="Magic Ripple", description="Ripple lớn", mode="ACTION", value=0.72, icon="🪄", action="ripple"},        {title="Clear Troll FX", description="Xóa hiệu ứng vui", mode="ACTION", value=0.72, icon="↺", action="clear_fx"},    },    [5] = {        {title="Performance Mode", description="Giảm hiệu ứng phụ của UI", mode="ACTION", value=0.72, icon="⚡", action="perf"},        {title="Lite Glass", description="Glass nhẹ hơn", mode="ACTION", value=0.72, icon="🧊", action="lite_glass"},        {title="Fast Tween", description="Animation nhanh", mode="ACTION", value=0.72, icon="🚀", action="fast"},        {title="Cinematic Tween", description="Animation chậm mượt", mode="ACTION", value=0.72, icon="🐢", action="cinematic"},        {title="Soft FX", description="Giảm particle", mode="ACTION", value=0.72, icon="🌫", action="soft_fx"},        {title="Particle Boost", description="Tăng particle UI", mode="ACTION", value=0.72, icon="✧", action="particle_boost"},        {title="UI Diagnostics", description="Kiểm tra thành phần UI", mode="ACTION", value=0.72, icon="📊", action="diagnostics"},        {title="State Check", description="Kiểm tra state menu", mode="ACTION", value=0.72, icon="🧠", action="state_check"},        {title="Layout Check", description="Kiểm tra kích thước UI", mode="ACTION", value=0.72, icon="📐", action="layout_check"},        {title="Preset Memory", description="Lưu preset trong phiên", mode="ACTION", value=0.72, icon="💾", action="preset_memory"},        {title="Restore Preset", description="Khôi phục preset", mode="ACTION", value=0.72, icon="↺", action="restore_preset"},        {title="Accent Cycle", description="Đổi accent", mode="ACTION", value=0.72, icon="🎨", action="accent_cycle"},        {title="Glow Max", description="Tăng glow", mode="ACTION", value=0.72, icon="🔆", action="glow_max"},        {title="Glow Min", description="Giảm glow", mode="ACTION", value=0.72, icon="🔅", action="glow_min"},        {title="Liquid Max", description="Preview liquid mạnh", mode="ACTION", value=0.72, icon="🫧", action="liquid_max"},        {title="Mobile Mode", description="Tối ưu touch scale", mode="ACTION", value=0.72, icon="📱", action="mobile"},        {title="Background Fit", description="Đổi cách hiển thị nền", mode="ACTION", value=0.72, icon="🖼", action="bg_fit"},        {title="Panther Fit", description="Đổi cách hiển thị Panther", mode="ACTION", value=0.72, icon="🐆", action="panther_fit"},        {title="Clean Layers", description="Ẩn lớp trang trí phụ", mode="ACTION", value=0.72, icon="🧹", action="clean_layers"},        {title="Ultra Reset", description="Khôi phục profile", mode="ACTION", value=0.72, icon="↺", action="reset"},    },    [6] = {        {title="Server Info", description="Thông tin phiên hiện tại", mode="ACTION", value=0.72, icon="◎", action="server_info"},        {title="Player Count", description="Số người chơi hiện tại", mode="ACTION", value=0.72, icon="👥", action="player_count"},        {title="Place ID", description="Hiện PlaceId", mode="ACTION", value=0.72, icon="🆔", action="place_id"},        {title="Job ID", description="Hiện JobId", mode="ACTION", value=0.72, icon="🔑", action="job_id"},        {title="Session Time", description="Thời gian phiên UI", mode="ACTION", value=0.72, icon="⏱", action="session_time"},        {title="Local Time", description="Giờ thiết bị", mode="ACTION", value=0.72, icon="🕐", action="local_time"},        {title="Network Note", description="Hiện trạng thái network UI", mode="ACTION", value=0.72, icon="📡", action="network"},        {title="Device Mode", description="Nhận diện touch/mobile", mode="ACTION", value=0.72, icon="📱", action="device"},        {title="Viewport", description="Kích thước màn hình", mode="ACTION", value=0.72, icon="🖥", action="viewport"},        {title="Input Mode", description="Kiểm tra touch/mouse", mode="ACTION", value=0.72, icon="🎮", action="input"},        {title="Camera State", description="Thông tin camera", mode="ACTION", value=0.72, icon="📷", action="camera_info"},        {title="Place Name", description="Hiện tên Place nếu có", mode="ACTION", value=0.72, icon="🌐", action="place_name"},        {title="Local Player", description="Tên người chơi local", mode="ACTION", value=0.72, icon="👤", action="player_info"},        {title="UI Version", description="Hiện phiên bản UI", mode="ACTION", value=0.72, icon="⚙", action="version"},        {title="UI Objects", description="Đếm object trong menu", mode="ACTION", value=0.72, icon="📊", action="ui_objects"},        {title="Refresh Info", description="Làm mới thông tin", mode="ACTION", value=0.72, icon="🔄", action="refresh"},        {title="Dock Orb", description="Ghim orb ra mép", mode="ACTION", value=0.72, icon="📌", action="dock"},        {title="Open Home", description="Về Home", mode="ACTION", value=0.72, icon="🏠", action="home"},        {title="Open Setting", description="Mở Setting", mode="ACTION", value=0.72, icon="⚙", action="setting"},        {title="Clear Status", description="Xóa toast/status", mode="ACTION", value=0.72, icon="↺", action="clear_status"},    },    [7] = {        {title="Glass", description="Độ trong suốt menu", mode="ACTION", value=0.72, icon="◈", action="glass"},        {title="Glow", description="Cường độ glow", mode="ACTION", value=0.72, icon="✦", action="glow"},        {title="Animation", description="Tốc độ animation", mode="ACTION", value=0.72, icon="◌", action="animation"},        {title="Curve", description="Độ cong UI", mode="ACTION", value=0.72, icon="⌁", action="curve"},        {title="Touch Scale", description="Kích thước touch", mode="ACTION", value=0.72, icon="☝", action="touch"},        {title="Rainbow Border", description="Bật/tắt viền rainbow", mode="ACTION", value=0.72, icon="🌈", action="rainbow"},        {title="Particles", description="Bật/tắt particle", mode="ACTION", value=0.72, icon="✧", action="particles"},        {title="Liquid Strength", description="Độ mạnh liquid preview", mode="ACTION", value=0.72, icon="🫧", action="liquid_max"},        {title="Panther", description="Bật/tắt Panther layer", mode="ACTION", value=0.72, icon="🐆", action="panther_toggle"},        {title="Background", description="Bật/tắt background", mode="ACTION", value=0.72, icon="🖼", action="background_toggle"},        {title="Search", description="Focus ô tìm kiếm", mode="ACTION", value=0.72, icon="🔍", action="search"},        {title="Large Cards", description="Tăng card", mode="ACTION", value=0.72, icon="📐", action="cards"},        {title="Mobile Layout", description="Tối ưu layout mobile", mode="ACTION", value=0.72, icon="📱", action="mobile"},        {title="Pink Candy", description="Preset Pink Candy", mode="ACTION", value=0.72, icon="🎨", action="theme_1"},        {title="Rose Glass", description="Preset Rose Glass", mode="ACTION", value=0.72, icon="🌹", action="theme_2"},        {title="Bubblegum", description="Preset Bubblegum", mode="ACTION", value=0.72, icon="🫧", action="theme_3"},        {title="Blossom", description="Preset Blossom", mode="ACTION", value=0.72, icon="🌸", action="theme_4"},        {title="Pearl", description="Preset Pearl", mode="ACTION", value=0.72, icon="☁", action="theme_5"},        {title="Reset Settings", description="Reset setting", mode="ACTION", value=0.72, icon="↺", action="reset"},        {title="Apply", description="Áp dụng state hiện tại", mode="ACTION", value=0.72, icon="💾", action="apply"},    },    [8] = {        {title="⚔  Combat Slot 01", description="Khu Combat để dành cho bản sau; card hiện đang khóa để tránh hành vi gameplay tự động.", mode="Locked", value=0.20, icon="⚔", action="locked"},        {title="⚔  Combat Slot 02", description="Khu Combat để dành cho bản sau; card hiện đang khóa để tránh hành vi gameplay tự động.", mode="Locked", value=0.20, icon="⚔", action="locked"},        {title="⚔  Combat Slot 03", description="Khu Combat để dành cho bản sau; card hiện đang khóa để tránh hành vi gameplay tự động.", mode="Locked", value=0.20, icon="⚔", action="locked"},        {title="⚔  Combat Slot 04", description="Khu Combat để dành cho bản sau; card hiện đang khóa để tránh hành vi gameplay tự động.", mode="Locked", value=0.20, icon="⚔", action="locked"},        {title="⚔  Combat Slot 05", description="Khu Combat để dành cho bản sau; card hiện đang khóa để tránh hành vi gameplay tự động.", mode="Locked", value=0.20, icon="⚔", action="locked"},        {title="⚔  Combat Slot 06", description="Khu Combat để dành cho bản sau; card hiện đang khóa để tránh hành vi gameplay tự động.", mode="Locked", value=0.20, icon="⚔", action="locked"},        {title="⚔  Combat Slot 07", description="Khu Combat để dành cho bản sau; card hiện đang khóa để tránh hành vi gameplay tự động.", mode="Locked", value=0.20, icon="⚔", action="locked"},        {title="⚔  Combat Slot 08", description="Khu Combat để dành cho bản sau; card hiện đang khóa để tránh hành vi gameplay tự động.", mode="Locked", value=0.20, icon="⚔", action="locked"},        {title="⚔  Combat Slot 09", description="Khu Combat để dành cho bản sau; card hiện đang khóa để tránh hành vi gameplay tự động.", mode="Locked", value=0.20, icon="⚔", action="locked"},        {title="⚔  Combat Slot 10", description="Khu Combat để dành cho bản sau; card hiện đang khóa để tránh hành vi gameplay tự động.", mode="Locked", value=0.20, icon="⚔", action="locked"},        {title="⚔  Combat Slot 11", description="Khu Combat để dành cho bản sau; card hiện đang khóa để tránh hành vi gameplay tự động.", mode="Locked", value=0.20, icon="⚔", action="locked"},        {title="⚔  Combat Slot 12", description="Khu Combat để dành cho bản sau; card hiện đang khóa để tránh hành vi gameplay tự động.", mode="Locked", value=0.20, icon="⚔", action="locked"},        {title="⚔  Combat Slot 13", description="Khu Combat để dành cho bản sau; card hiện đang khóa để tránh hành vi gameplay tự động.", mode="Locked", value=0.20, icon="⚔", action="locked"},        {title="⚔  Combat Slot 14", description="Khu Combat để dành cho bản sau; card hiện đang khóa để tránh hành vi gameplay tự động.", mode="Locked", value=0.20, icon="⚔", action="locked"},        {title="⚔  Combat Slot 15", description="Khu Combat để dành cho bản sau; card hiện đang khóa để tránh hành vi gameplay tự động.", mode="Locked", value=0.20, icon="⚔", action="locked"},        {title="⚔  Combat Slot 16", description="Khu Combat để dành cho bản sau; card hiện đang khóa để tránh hành vi gameplay tự động.", mode="Locked", value=0.20, icon="⚔", action="locked"},        {title="⚔  Combat Slot 17", description="Khu Combat để dành cho bản sau; card hiện đang khóa để tránh hành vi gameplay tự động.", mode="Locked", value=0.20, icon="⚔", action="locked"},        {title="⚔  Combat Slot 18", description="Khu Combat để dành cho bản sau; card hiện đang khóa để tránh hành vi gameplay tự động.", mode="Locked", value=0.20, icon="⚔", action="locked"},        {title="⚔  Combat Slot 19", description="Khu Combat để dành cho bản sau; card hiện đang khóa để tránh hành vi gameplay tự động.", mode="Locked", value=0.20, icon="⚔", action="locked"},        {title="⚔  Combat Slot 20", description="Khu Combat để dành cho bản sau; card hiện đang khóa để tránh hành vi gameplay tự động.", mode="Locked", value=0.20, icon="⚔", action="locked"},    },}

--==============================================================
-- FLOWER CORE
--==============================================================
local FlowerArea=newFrame(Menu,"FlowerArea",UDim2.fromScale(.30,.40),UDim2.fromScale(.35,.37),C.Pink,.90,90)
corner(FlowerArea,999)
local Petals={}
for i=1,12 do
    local p=newFrame(FlowerArea,"Petal"..i,UDim2.fromOffset(62,30),UDim2.fromScale(.5,.5),C.Pink3,.78,91)
    corner(p,999)
    p.Rotation=(i-1)*30
    p.Position=UDim2.new(.5,0,.5,0)
    Petals[i]=p
end
local FlowerOuter=newFrame(FlowerArea,"FlowerOuter",UDim2.fromScale(.86,.86),UDim2.fromScale(.07,.07),C.Pink,.83,94)
corner(FlowerOuter,999); stroke(FlowerOuter,C.White,2,.35)
local FlowerRing=newFrame(FlowerArea,"FlowerRing",UDim2.fromScale(.72,.72),UDim2.fromScale(.14,.14),C.Pink2,.86,95)
corner(FlowerRing,999); stroke(FlowerRing,C.Pink3,2,.25)
local FlowerCore=newFrame(FlowerArea,"FlowerCore",UDim2.fromScale(.45,.45),UDim2.fromScale(.275,.275),C.DeepPink,.08,100)
corner(FlowerCore,999); stroke(FlowerCore,C.White,2,.15)
local CoreImage=image(FlowerCore,"CorePanther",UDim2.fromScale(.82,.82),UDim2.fromScale(.09,.09),PantherAsset,101,.08)
local CoreLabel=label(FlowerArea,"TẠM ĐÓNG",8,UDim2.fromScale(0,1.00),Enum.Font.GothamBold,C.White,103)
CoreLabel.Size=UDim2.new(1,0,0,18)
local CoreButton=button(FlowerArea,"",UDim2.fromScale(1,1),UDim2.fromScale(0,0),150)

-- rotating rings around the flower
local RingData={}
for i=1,7 do
    local r=newFrame(FXLayer,"CoreRing"..i,UDim2.fromOffset(230+i*24,230+i*24),UDim2.new(.5,-115-i*12,.5,-115-i*12),C.Pink3,1,45+i)
    corner(r,999); stroke(r,i%2==0 and C.Pink or C.Pink3,1, .70+i*.025)
    RingData[i]=r
end

--==============================================================
-- TAB RAIL + CURVED FUNCTION RAIL
--==============================================================
local TabRail=newFrame(Menu,"TabRail",UDim2.fromScale(.33,.66),UDim2.fromScale(.025,.25),C.Pink,.91,110)
corner(TabRail,52)
TabRail.Active=true
local TabRailStroke=stroke(TabRail,C.White,1,.72)
local TabButtons={}
local TabText={}
local CurrentTab=1

local FunctionRail=newFrame(Menu,"FunctionRail",UDim2.fromScale(.33,.66),UDim2.fromScale(.645,.25),C.Pink,.91,110)
corner(FunctionRail,52)
FunctionRail.Active=true
local FunctionRailStroke=stroke(FunctionRail,C.White,1,.72)
gradient(FunctionRail,{
    ColorSequenceKeypoint.new(0,Color3.fromRGB(255,220,236)),
    ColorSequenceKeypoint.new(.5,Color3.fromRGB(255,142,192)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(245,102,164))
},90,NumberSequence.new({
    NumberSequenceKeypoint.new(0,.82),
    NumberSequenceKeypoint.new(.5,.92),
    NumberSequenceKeypoint.new(1,.96)
}))
gradient(TabRail,{
    ColorSequenceKeypoint.new(0,Color3.fromRGB(255,220,236)),
    ColorSequenceKeypoint.new(.5,Color3.fromRGB(255,142,192)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(245,102,164))
},90,NumberSequence.new({
    NumberSequenceKeypoint.new(0,.82),
    NumberSequenceKeypoint.new(.5,.92),
    NumberSequenceKeypoint.new(1,.96)
}))
local FunctionButtons={}

local function tabPos(i,total)
    local t=(i-1)/math.max(1,total-1)
    local y=.07+t*.86
    local bend=math.sin(t*math.pi)*.055
    local x=.08+bend
    return UDim2.fromScale(x,y)
end

for i,data in ipairs(TAB_DATA) do
    local b=button(TabRail,data.icon.."  "..data.name,UDim2.fromScale(.90,.095),tabPos(i,#TAB_DATA),125)
    b.BackgroundColor3=C.Pink2; b.BackgroundTransparency=.58; b.TextColor3=C.Ink
    b.Font=Enum.Font.GothamBold; b.TextSize=11; b.TextXAlignment=Enum.TextXAlignment.Left
    corner(b,28); stroke(b,C.White,1,.78)
    local pad=Instance.new("UIPadding"); pad.PaddingLeft=UDim.new(0,10); pad.Parent=b
    TabButtons[i]=b
    local tx=b
    TabText[i]=tx
end

local function functionPos(i,total)
    local t=(i-1)/math.max(1,total-1)
    local y=.05+t*.90
    local bend=-math.sin(t*math.pi)*.075
    local x=.08+bend
    return UDim2.fromScale(x,y)
end

local function makeFunctionCard(i)
    local data=CARD_DATA[CurrentTab][i]
    local b=button(FunctionRail,"",UDim2.fromScale(.94,.115),functionPos(i,20),125)
    b.BackgroundColor3=C.Pink2; b.BackgroundTransparency=.48; corner(b,28); stroke(b,C.White,1,.72)
    local iconText=data.icon or "✦"
    local icon=label(b,iconText,18,UDim2.fromOffset(8,3),Enum.Font.GothamBlack,C.White,129)
    icon.Size=UDim2.fromOffset(28,28); icon.TextXAlignment=Enum.TextXAlignment.Center
    corner(icon,999)
    local t=label(b,data.title,11,UDim2.fromOffset(40,2),Enum.Font.GothamBold,C.Ink,127)
    t.Size=UDim2.new(1,-104,0,22); t.TextXAlignment=Enum.TextXAlignment.Left
    local d=label(b,data.description,8,UDim2.fromOffset(40,22),Enum.Font.Gotham, C.Soft,127)
    d.Size=UDim2.new(1,-50,0,18); d.TextXAlignment=Enum.TextXAlignment.Left
    local s=label(b,data.mode,9,UDim2.new(1,-62,0,1),Enum.Font.GothamBold,C.DeepPink,127)
    s.Size=UDim2.fromOffset(48,18); s.TextXAlignment=Enum.TextXAlignment.Right
    local line=newFrame(b,"Progress",UDim2.new(data.value,-10,0,2),UDim2.new(0,8,1,-5),C.Pink3,.15,126)
    corner(line,999)
    FunctionButtons[i]={button=b,title=t,mode=s,line=line}
end
for i=1,20 do makeFunctionCard(i) end

-- Search field floats between header and center.
local SearchWrap=newFrame(Menu,"SearchWrap",UDim2.fromScale(.28,.075),UDim2.fromScale(.36,.11),C.Pink,.48,150)
corner(SearchWrap,20); stroke(SearchWrap,C.White,1,.70)
local Search=Instance.new("TextBox")
Search.BackgroundTransparency=1
Search.Size=UDim2.new(1,-38,1,0)
Search.Position=UDim2.fromOffset(32,0)
Search.PlaceholderText="Tìm trong menu..."
Search.Text=""
Search.ClearTextOnFocus=false
Search.TextColor3=C.White
Search.PlaceholderColor3=C.Soft
Search.Font=Enum.Font.Gotham
Search.TextSize=9
Search.TextXAlignment=Enum.TextXAlignment.Left
Search.ZIndex=152
Search.Parent=SearchWrap
local SearchIcon=label(SearchWrap,"⌕",16,UDim2.fromOffset(8,0),Enum.Font.GothamBold,C.White,152)
SearchIcon.Size=UDim2.fromOffset(22,SearchWrap.AbsoluteSize.Y)

-- top close button and small status capsule
local Close=button(Menu,"×",UDim2.fromOffset(42,42),UDim2.new(1,-52,0,15),180)
Close.TextColor3=C.White; Close.Font=Enum.Font.GothamBlack; Close.TextSize=26
local Status=label(Menu,"8 TABS • 20 FUNCTIONS",10,UDim2.new(0,20,1,-31),Enum.Font.GothamBold,C.White,170)
Status.Size=UDim2.fromOffset(180,20); Status.TextXAlignment=Enum.TextXAlignment.Left

--==============================================================
-- RAINBOW EDGE + LIQUID HIGHLIGHT
--==============================================================
local Edge=newFrame(Menu,"Edge",UDim2.fromScale(1.012,1.012),UDim2.fromScale(-.006,-.006),C.Pink,.96,200)
corner(Edge,72); local EdgeStroke=stroke(Edge,C.Pink3,4,.35)
local LiquidHighlight=newFrame(Menu,"LiquidHighlight",UDim2.fromOffset(180,18),UDim2.fromScale(-.2,.12),C.White,.78,205)
corner(LiquidHighlight,999)
LiquidHighlight.Rotation=-12

--==============================================================
-- PARTICLE POOL
--==============================================================
local ParticlePool={}
local function spawnParticle()
    local p=newFrame(FXLayer,"Particle",UDim2.fromOffset(math.random(3,7),math.random(3,7)),UDim2.fromScale(.5,.5),C.Pink3,.12,130)
    corner(p,999)
    local a=math.random()*math.pi*2
    local d=math.random(90,250)
    local target=UDim2.new(.5,math.cos(a)*d,.5,math.sin(a)*d)
    local t=TweenService:Create(p,tw(math.random(8,16)/10,Enum.EasingStyle.Quad),{Position=target,BackgroundTransparency=1,Size=UDim2.fromOffset(1,1)})
    t:Play(); t.Completed:Connect(function() if p then p:Destroy() end end)
end

--==============================================================
-- RIPPLE SYSTEM
--==============================================================
local function ripple(parent,pos)
    local r=newFrame(parent,"Ripple",UDim2.fromOffset(10,10),UDim2.fromOffset(pos.X-5,pos.Y-5),C.White,.55,300)
    corner(r,999); stroke(r,C.White,1,.25)
    local goal={Size=UDim2.fromOffset(90,90),Position=UDim2.fromOffset(pos.X-45,pos.Y-45),BackgroundTransparency=1}
    local t=TweenService:Create(r,tw(.45,Enum.EasingStyle.Quint),goal)
    t:Play(); t.Completed:Connect(function() r:Destroy() end)
end

local function bindRipple(b)
    b.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            local p=b.AbsolutePosition
            local q=input.Position
            ripple(b,Vector2.new(q.X-p.X,q.Y-p.Y))
        end
    end)
end

for _,b in ipairs(TabButtons) do bindRipple(b) end
for _,x in ipairs(FunctionButtons) do bindRipple(x.button) end
bindRipple(Close); bindRipple(CoreButton)

--==============================================================
-- TAB SELECTION
--==============================================================
local TabScroll=0
local FunctionScroll=0
local ScrollVelocityTab=0
local ScrollVelocityFunction=0

local function smoothScrollValue(current,target)
    return current+(target-current)*.22
end

local function applyRailScroll()
    local tabCount=#TAB_DATA
    local fnCount=20

    for i,b in ipairs(TabButtons) do
        local t=((i-1)+TabScroll)/math.max(1,tabCount-1)
        local y=.07+t*.86
        local bend=math.sin(math.clamp(t,0,1)*math.pi)*.055
        local x=.08+bend
        b.Position=UDim2.fromScale(x,y)
    end

    for i,x in ipairs(FunctionButtons) do
        local t=((i-1)+FunctionScroll)/math.max(1,fnCount-1)
        local y=.05+t*.90
        local bend=-math.sin(math.clamp(t,0,1)*math.pi)*.075
        local px=.08+bend
        x.button.Position=UDim2.fromScale(px,y)
    end
end

local function clampScroll(v,count)
    return math.clamp(v,0,math.max(0,count-1))
end

local function refreshFunctionCards()
    for i,x in ipairs(FunctionButtons) do
        local data=CARD_DATA[CurrentTab][i]
        x.title.Text=data.title
        x.mode.Text=data.mode
        x.line.Size=UDim2.new(data.value,-10,0,2)
        x.button.Position=functionPos(i,20 + 0) 
        local t=((i-1)+FunctionScroll)/19
        x.button.Position=UDim2.fromScale(.08-math.sin(math.clamp(t,0,1)*math.pi)*.075,.05+t*.90)
    end
end

local function selectTab(index,instant)
    index=clamp(index,1,#TAB_DATA)
    CurrentTab=index
    for i,b in ipairs(TabButtons) do
        local selected=i==index
        local targetSize=selected and UDim2.fromScale(.95,.115) or UDim2.fromScale(.90,.095)
        local targetPos=tabPos(i,#TAB_DATA)
        TweenService:Create(b,tw(instant and .05 or .32,Enum.EasingStyle.Quint),{Size=targetSize,Position=targetPos,BackgroundTransparency=selected and .30 or .58}):Play()
        b.TextColor3=selected and C.White or C.Ink
        if selected then
            TweenService:Create(b,TweenInfo.new(.12,Enum.EasingStyle.Quad),{BackgroundColor3=C.DeepPink}):Play()
            task.delay(.13,function()
                if b.Parent then TweenService:Create(b,TweenInfo.new(.25,Enum.EasingStyle.Quint),{BackgroundColor3=C.Pink2}):Play() end
            end)
        end
        local st=b:FindFirstChildOfClass("UIStroke")
        if st then st.Transparency=selected and .25 or .78 end
    end
    refreshFunctionCards()
    -- small panther response animation
    if Panther then
        Panther.Rotation=-4
        TweenService:Create(Panther,tw(.18,Enum.EasingStyle.Quad),{Rotation=4}):Play()
        task.delay(.18,function() if Panther then TweenService:Create(Panther,tw(.35),{Rotation=0}):Play() end end)
    end
    for _,p in ipairs(Petals) do
        local target=p.Rotation+18
        TweenService:Create(p,tw(.55,Enum.EasingStyle.Back),{Rotation=target}):Play()
    end
end
for i,b in ipairs(TabButtons) do
    b.Activated:Connect(function() selectTab(i,false) end)
end

--==============================================================
-- SEARCH FILTER
--==============================================================
local function lower(s) return string.lower(tostring(s or "")) end
local function applySearch(q)
    q=lower(q)
    for i,x in ipairs(FunctionButtons) do
        local d=CARD_DATA[CurrentTab][i]
        local match=q=="" or lower(d.title):find(q,1,true) or lower(d.description):find(q,1,true)
        x.button.Visible=match~=nil
        if match then
            TweenService:Create(x.button,tw(.18,Enum.EasingStyle.Quad),{BackgroundTransparency=.42}):Play()
        end
    end
end
Search:GetPropertyChangedSignal("Text"):Connect(function() applySearch(Search.Text) end)

--==============================================================
-- TOUCH DRAG
--==============================================================
local dragging=false
local dragStart=nil
local menuStart=nil
local dragMoved=false
local function beginDrag(input)
    if input.UserInputType~=Enum.UserInputType.Touch and input.UserInputType~=Enum.UserInputType.MouseButton1 then return end
    dragging=true; dragMoved=false; dragStart=input.Position; menuStart=Menu.Position
end
local function moveDrag(input)
    if not dragging then return end
    if input.UserInputType~=Enum.UserInputType.Touch and input.UserInputType~=Enum.UserInputType.MouseMovement then return end
    local d=input.Position-dragStart
    if d.Magnitude>5 then dragMoved=true end
    Menu.Position=UDim2.new(menuStart.X.Scale,menuStart.X.Offset+d.X,menuStart.Y.Scale,menuStart.Y.Offset+d.Y)
end
Header.InputBegan:Connect(beginDrag)
Header.InputChanged:Connect(moveDrag)
UserInputService.InputChanged:Connect(moveDrag)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
end)

--==============================================================
-- SMOOTH RAIL SCROLL
--==============================================================
local railTouch=nil
local railName=nil
local railLastY=0
local railStartY=0
local railMoved=false

local function railBegin(which,input)
    if input.UserInputType~=Enum.UserInputType.Touch and input.UserInputType~=Enum.UserInputType.MouseButton1 then return end
    railTouch=input
    railName=which
    railLastY=input.Position.Y
    railStartY=input.Position.Y
    railMoved=false
end

local function railMove(input)
    if not railTouch or not railName then return end
    if input.UserInputType~=Enum.UserInputType.Touch and input.UserInputType~=Enum.UserInputType.MouseMovement then return end
    local dy=input.Position.Y-railLastY
    if math.abs(input.Position.Y-railStartY)>5 then railMoved=true end
    railLastY=input.Position.Y
    local step=-dy/42
    if railName=="tabs" then
        TabScroll=clampScroll(TabScroll+step,#TAB_DATA)
    else
        FunctionScroll=clampScroll(FunctionScroll+step,20)
    end
end

local function railEnd()
    railTouch=nil
    railName=nil
end

TabRail.InputBegan:Connect(function(input) railBegin("tabs",input) end)
FunctionRail.InputBegan:Connect(function(input) railBegin("functions",input) end)
UserInputService.InputChanged:Connect(railMove)
UserInputService.InputEnded:Connect(railEnd)

RunService.RenderStepped:Connect(function()
    ScrollVelocityTab=ScrollVelocityTab*.82
    ScrollVelocityFunction=ScrollVelocityFunction*.82
    if math.abs(ScrollVelocityTab)>.001 then TabScroll=clampScroll(TabScroll+ScrollVelocityTab,#TAB_DATA) end
    if math.abs(ScrollVelocityFunction)>.001 then FunctionScroll=clampScroll(FunctionScroll+ScrollVelocityFunction,20) end
    applyRailScroll()
end)

--==============================================================
-- LIQUID MORPH HELPERS
--==============================================================
local function setMenuAlpha(a)
    Menu.BackgroundTransparency=clamp(a,.05,1)
    InnerGlass.BackgroundTransparency=clamp(a+.50,.20,1)
    Veil.BackgroundTransparency=clamp(a+.50,.30,1)
    BackGlow.BackgroundTransparency=clamp(a+.55,.40,1)
end

local function morphToDrop()
    Drop.Visible=true
    DropTail.Visible=false
    local op=Orb.AbsolutePosition
    local os=Orb.AbsoluteSize
    local ox=op.X+os.X/2
    local oy=op.Y+os.Y/2
    Drop.Position=rootPointToPosition(Vector2.new(ox,oy))
    Drop.Size=UDim2.fromOffset(20,20)
    Drop.Rotation=0
    Drop.BackgroundTransparency=.03
    TweenService:Create(Drop,TweenInfo.new(.30,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
        Position=UDim2.new(.5,-10,.5,-10)
    }):Play()
    local a=TweenService:Create(Drop,tw(.28,Enum.EasingStyle.Quint),{Size=UDim2.fromOffset(32,86),Position=UDim2.new(.5,-16,.5,-43),Rotation=-7})
    a:Play(); a.Completed:Wait()
    local b=TweenService:Create(Drop,tw(.38,Enum.EasingStyle.Back),{Size=UDim2.fromOffset(66,106),Position=UDim2.new(.5,-33,.5,-53),Rotation=8})
    b:Play(); b.Completed:Wait()
end

local function openMenu()
    if Menu.Visible then return end
    Orb.Visible=false
    OrbRing1.Visible=false; OrbRing2.Visible=false
    task.spawn(function()
        morphToDrop()
        Menu.Visible=true
        Menu.Size=UDim2.fromScale(.02,.02)
        Menu.Position=UDim2.fromScale(.49,.49)
        Menu.Rotation=-6
        setMenuAlpha(.82)
        FlowerArea.Size=UDim2.fromScale(.05,.05)
        FlowerArea.Position=UDim2.fromScale(.475,.475)
        local menuTween=TweenService:Create(Menu,tw(.82,Enum.EasingStyle.Quint),{Size=UDim2.fromScale(.90,.82),Position=UDim2.fromScale(.05,.09),Rotation=0})
        local alphaTween=TweenService:Create(Menu,tw(.72,Enum.EasingStyle.Quint),{BackgroundTransparency=.24})
        local flowerTween=TweenService:Create(FlowerArea,tw(.75,Enum.EasingStyle.Back),{Size=UDim2.fromScale(.30,.40),Position=UDim2.fromScale(.35,.37)})
        menuTween:Play(); alphaTween:Play(); flowerTween:Play()
        for _,x in ipairs(TabButtons) do x.BackgroundTransparency=1 end
        for _,x in ipairs(FunctionButtons) do x.button.BackgroundTransparency=1 end
        task.wait(.18)
        for i,b in ipairs(TabButtons) do
            task.delay(i*.025,function()
                if b.Parent then TweenService:Create(b,tw(.35,Enum.EasingStyle.Back),{BackgroundTransparency=(i==CurrentTab and .30 or .58)}):Play() end
            end)
        end
        for i,x in ipairs(FunctionButtons) do
            task.delay(i*.018,function()
                if x.button.Parent then TweenService:Create(x.button,tw(.34,Enum.EasingStyle.Back),{BackgroundTransparency=.48}):Play() end
            end)
        end
        task.wait(.68)
        Drop.Visible=false
        for i=1,5 do spawnParticle() end
    end)
end

local function dockOrbToEdge()
    local size=Root.AbsoluteSize
    if size.X<=0 or size.Y<=0 then return end
    local center=Vector2.new(
        Orb.AbsolutePosition.X+Orb.AbsoluteSize.X/2,
        Orb.AbsolutePosition.Y+Orb.AbsoluteSize.Y/2
    )
    local pad=52
    local distances={
        {d=center.X,x=pad,y=math.clamp(center.Y,pad,size.Y-pad)},
        {d=size.X-center.X,x=size.X-pad,y=math.clamp(center.Y,pad,size.Y-pad)},
        {d=center.Y,x=math.clamp(center.X,pad,size.X-pad),y=pad},
        {d=size.Y-center.Y,x=math.clamp(center.X,pad,size.X-pad),y=size.Y-pad},
    }
    table.sort(distances,function(a,b) return a.d<b.d end)
    local p=distances[1]
    TweenService:Create(Orb,TweenInfo.new(.45,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
        Position=UDim2.fromOffset(p.x,p.y)
    }):Play()
end

local function closeMenu()
    if not Menu.Visible then return end
    task.spawn(function()
        local out=TweenService:Create(Menu,tw(.62,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Size=UDim2.fromScale(.025,.025),Position=UDim2.fromScale(.4875,.4875),Rotation=8,BackgroundTransparency=.84})
        local flower=TweenService:Create(FlowerArea,tw(.48,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Size=UDim2.fromScale(.03,.03),Position=UDim2.fromScale(.485,.485)})
        out:Play(); flower:Play(); out.Completed:Wait()
        Menu.Visible=false
        Drop.Visible=true
        Drop.Size=UDim2.fromOffset(68,108)
        Drop.Position=UDim2.new(.5,-34,.5,-54)
        Drop.Rotation=8
        local d1=TweenService:Create(Drop,tw(.42,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Size=UDim2.fromOffset(28,70),Position=UDim2.new(.5,-14,.5,-35),Rotation=-5})
        d1:Play(); d1.Completed:Wait()
        local d2=TweenService:Create(Drop,tw(.28,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.fromOffset(92,92),Position=UDim2.new(.5,-46,.5,-46),Rotation=0})
        d2:Play(); d2.Completed:Wait()
        Drop.Visible=false
        Orb.Visible=true; OrbRing1.Visible=true; OrbRing2.Visible=true
        Orb.Size=UDim2.fromOffset(8,8)
        TweenService:Create(Orb,tw(.45,Enum.EasingStyle.Back),{Size=UDim2.fromOffset(92,92)}):Play()
        dockOrbToEdge()
    end)
end

CoreButton.Activated:Connect(closeMenu)
Close.Activated:Connect(closeMenu)
Orb.Activated:Connect(function()
    if orbDragging or orbMoved then return end
    openMenu()
end)

--==============================================================
-- ORB ROTATION / BREATHING / RINGS / HIGHLIGHT
--==============================================================
local t0=os.clock()
RunService.RenderStepped:Connect(function(dt)
    local t=os.clock()-t0
    ZLabel.Rotation=(t*24)%360
    OrbGrad.Rotation=(t*32)%360
    OrbShine.Position=UDim2.fromOffset(17+math.sin(t*1.7)*4,15+math.cos(t*1.2)*3)
    local pulse=1+math.sin(t*2.2)*.035
    Orb.Size=UDim2.fromOffset(92*pulse,92*pulse)
    OrbRing1.Rotation=(t*18)%360
    OrbRing2.Rotation=(-t*12)%360
    for i,r in ipairs(RingData) do r.Rotation=(i%2==0 and -1 or 1)*t*(8+i*1.8) end
    if Menu.Visible then
        FlowerRing.Rotation=(t*22)%360
        FlowerOuter.Rotation=(-t*10)%360
        for i,p in ipairs(Petals) do
            local base=(i-1)*30
            p.Rotation=base+math.sin(t*1.5+i*.35)*3
            local sc=1+math.sin(t*2+i*.2)*.025
            p.Size=UDim2.fromOffset(62*sc,30*sc)
        end
        local hx=((t*.12)%1)
        LiquidHighlight.Position=UDim2.new(-.25+hx*1.45,0,.12+math.sin(t)*.015,0)
        if CONFIG.RainbowBorder then
            local col=Color3.fromHSV((t*.07)%1,.45,1)
            EdgeStroke.Color=col
            MenuStroke.Color=c3lerp(C.Pink3,col,.25)
        end
        if math.floor(t*2)%2==0 and math.random()<.018 then spawnParticle() end
    end
end)

--==============================================================
-- PRESS FEEDBACK FOR ORB/CLOSE/CORE
--==============================================================
local function pressScale(obj,normal,pressed)
    local original=obj.Size
    obj.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            TweenService:Create(obj,tw(.08,Enum.EasingStyle.Quad),{Size=pressed}):Play()
        end
    end)
    obj.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            TweenService:Create(obj,tw(.22,Enum.EasingStyle.Back),{Size=normal or original}):Play()
        end
    end)
end
pressScale(Orb,UDim2.fromOffset(92,92),UDim2.fromOffset(84,84))
pressScale(FlowerCore,UDim2.fromScale(.45,.45),UDim2.fromScale(.41,.41))

--==============================================================
-- SETTINGS CONTROLS (REAL UI STATE)
--==============================================================
local UI_STATE={
    Glass=CONFIG.GlassTransparency,
    Glow=CONFIG.GlowStrength,
    Animation=CONFIG.AnimationSpeed,
    Curve=CONFIG.CurveAmplitude,
    TouchScale=CONFIG.TouchScale,
    Rainbow=CONFIG.RainbowBorder,
}

local function setGlass(v)
    UI_STATE.Glass=clamp(v,.05,.75)
    Menu.BackgroundTransparency=UI_STATE.Glass
    InnerGlass.BackgroundTransparency=clamp(UI_STATE.Glass+.55,.25,.98)
    Veil.BackgroundTransparency=clamp(UI_STATE.Glass+.50,.25,.98)
end

local function setGlow(v)
    UI_STATE.Glow=clamp(v,0,1)
    BackGlow.BackgroundTransparency=clamp(.98-UI_STATE.Glow*.42,.45,.98)
    EdgeStroke.Transparency=clamp(.75-UI_STATE.Glow*.45,.18,.80)
end

local function setAnimation(v) UI_STATE.Animation=clamp(v,.5,2.5) end
local function setCurve(v) UI_STATE.Curve=clamp(v,0,80) end
local function setTouchScale(v) UI_STATE.TouchScale=clamp(v,.8,1.25) end

-- Reusable slider purely for the menu settings page.
local function makeSlider(parent,titleText,min,max,value,onChanged)
    local row=newFrame(parent,"SliderRow",UDim2.new(1,-24,0,54),UDim2.fromOffset(12,12),C.Pink,.56,220)
    corner(row,18); stroke(row,C.White,1,.82)
    local ttl=label(row,titleText,9,UDim2.fromOffset(10,3),Enum.Font.GothamBold,C.White,222)
    ttl.Size=UDim2.new(1,-20,0,18); ttl.TextXAlignment=Enum.TextXAlignment.Left
    local bar=newFrame(row,"Bar",UDim2.new(1,-24,0,7),UDim2.fromOffset(12,34),C.Rose,.42,222)
    corner(bar,999)
    local fill=newFrame(bar,"Fill",UDim2.new((value-min)/(max-min),0,1,0),UDim2.fromScale(0,0),C.Pink3,.05,223)
    corner(fill,999)
    local hit=button(row,"",UDim2.new(1,0,0,32),UDim2.fromOffset(0,25),225)
    local draggingSlider=false
    local function update(x)
        local pct=clamp((x-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
        local v=min+(max-min)*pct
        fill.Size=UDim2.new(pct,0,1,0)
        onChanged(v)
    end
    hit.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 then
            draggingSlider=true; update(inp.Position.X)
        end
    end)
    hit.InputChanged:Connect(function(inp)
        if draggingSlider and (inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseMovement) then update(inp.Position.X) end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if draggingSlider and (inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseMovement) then update(inp.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 then draggingSlider=false end
    end)
    return row
end

local SettingsOverlay=newFrame(Menu,"SettingsOverlay",UDim2.fromScale(.59,.70),UDim2.fromScale(.205,.23),C.Pink,.88,300)
corner(SettingsOverlay,34); stroke(SettingsOverlay,C.White,1,.70)
SettingsOverlay.Visible=false
local SettingsTitle=label(SettingsOverlay,"LIQUID GLASS CONTROL",14,UDim2.fromOffset(0,10),Enum.Font.GothamBlack,C.White,302)
SettingsTitle.Size=UDim2.new(1,0,0,25)
makeSlider(SettingsOverlay,"Độ trong suốt",.05,.75,UI_STATE.Glass,setGlass).Position=UDim2.fromOffset(12,42)
makeSlider(SettingsOverlay,"Glow",0,1,UI_STATE.Glow,setGlow).Position=UDim2.fromOffset(12,102)
makeSlider(SettingsOverlay,"Animation",.5,2.5,UI_STATE.Animation,setAnimation).Position=UDim2.fromOffset(12,162)
makeSlider(SettingsOverlay,"Curve",0,80,UI_STATE.Curve,setCurve).Position=UDim2.fromOffset(12,222)
makeSlider(SettingsOverlay,"Touch Scale",.8,1.25,UI_STATE.TouchScale,setTouchScale).Position=UDim2.fromOffset(12,282)
local SettingsClose=button(SettingsOverlay,"×",UDim2.fromOffset(38,38),UDim2.new(1,-44,0,7),310)
SettingsClose.TextColor3=C.White; SettingsClose.Font=Enum.Font.GothamBlack; SettingsClose.TextSize=22
SettingsClose.Activated:Connect(function() SettingsOverlay.Visible=false end)

-- Clicking the SETTINGS tab opens a richer overlay while preserving the same tab rail.
local originalSelectTab=selectTab
selectTab=function(index,instant)
    originalSelectTab(index,instant)
    SettingsOverlay.Visible=(TAB_DATA[index].name=="SETTING")
end

--==============================================================
-- MICRO ANIMATION PRESETS
--==============================================================
local Presets={
    Soft={enter=.82,exit=.62,petal=1.5,ring=1.0},
    Liquid={enter=.68,exit=.48,petal=1.8,ring=1.4},
    Elastic={enter=.95,exit=.72,petal=2.1,ring=.8},
    Dream={enter=1.10,exit=.85,petal=1.2,ring=.65},
}
local CurrentPreset="Liquid"
local function applyPreset(name)
    if Presets[name] then CurrentPreset=name end
end

--==============================================================
-- ORB HOLD / DOUBLE TAP FEEDBACK
--==============================================================
local orbPressAt=0
Orb.InputBegan:Connect(function(input)
    if input.UserInputType~=Enum.UserInputType.Touch and input.UserInputType~=Enum.UserInputType.MouseButton1 then return end
    local now=os.clock()
    if now-orbPressAt<.35 then
        for i=1,10 do spawnParticle() end
    end
    orbPressAt=now
    orbDragging=true
    orbMoved=false
    orbStart=input.Position
    orbStartPos=Orb.Position
    orbLastInput=input
    setOrbDropVisual(true)
end)

Orb.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
        orbLastInput=input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not orbDragging then return end
    if input.UserInputType~=Enum.UserInputType.Touch and input.UserInputType~=Enum.UserInputType.MouseMovement then return end
    local d=input.Position-orbStart
    if d.Magnitude>6 then orbMoved=true end
    local p=Vector2.new(
        Orb.AbsolutePosition.X+Orb.AbsoluteSize.X/2+d.X,
        Orb.AbsolutePosition.Y+Orb.AbsoluteSize.Y/2+d.Y
    )
    Orb.Position=rootPointToPosition(p)
    if d.Magnitude>6 then
        local stretch=1+math.clamp(d.Magnitude/170,0,1.9)
        local angle=math.deg(math.atan2(d.Y,d.X))+90
        showLiquidDragFX(Vector2.new(p.X,p.Y),stretch,angle)
        Orb.Rotation=math.clamp(angle-90,-28,28)
        Orb.Size=UDim2.fromOffset(58+math.clamp(d.Magnitude*.16,0,48),82+math.clamp(d.Magnitude*.28,0,78))
        DropTail.Size=UDim2.fromOffset(14+math.clamp(d.Magnitude*.03,0,8),42+math.clamp(d.Magnitude*.16,0,55))
        DropTail.Rotation=angle
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if not orbDragging then return end
    if input.UserInputType~=Enum.UserInputType.Touch and input.UserInputType~=Enum.UserInputType.MouseButton1 then return end
    orbDragging=false
    if orbMoved then
        -- A dragged orb stays where the player released it.
        -- The next close/open cycle can still dock it to the nearest edge.
        setOrbDropVisual(false)
        hideLiquidDragFX()
        for i=1,4 do spawnParticle() end
        task.delay(.12,function() orbMoved=false end)
    else
        setOrbDropVisual(false)
        hideLiquidDragFX()
    end
end)

--==============================================================
-- V6 MAX ACTION SYSTEM — safe client/UI/own-experience tools
-- Combat automation is intentionally locked for a later build.
--==============================================================
local V6 = {
    Rainbow = CONFIG.RainbowBorder,
    Particles = true,
    Panther = true,
    Background = true,
    BigCards = true,
    Grid = false,
    Guide = false,
    Sound = CONFIG.EnableUIAudio,
    SessionStart = os.clock(),
    AccentIndex = 1,
    ThemeIndex = 1,
}

local V6Themes = {
    {name="Pink Candy", hue=.92, sat=.34, glow=.25},
    {name="Rose Glass", hue=.96, sat=.42, glow=.20},
    {name="Cotton", hue=.88, sat=.18, glow=.30},
    {name="Neon Pink", hue=.89, sat=.75, glow=.16},
    {name="Pearl", hue=.98, sat=.08, glow=.42},
    {name="Blossom", hue=.95, sat=.50, glow=.28},
    {name="Bubblegum", hue=.91, sat=.58, glow=.22},
}

local function v6Toast(title,msg)
    local holder=newFrame(FXLayer,"V6Toast",UDim2.fromOffset(280,58),UDim2.new(.5,-140,0,-72),C.Pink2,.16,950)
    corner(holder,22); stroke(holder,C.White,1,.48)
    local h=label(holder,title,11,UDim2.fromOffset(14,7),Enum.Font.GothamBlack,C.White,952)
    h.Size=UDim2.new(1,-28,0,18); h.TextXAlignment=Enum.TextXAlignment.Left
    local m=label(holder,msg,8,UDim2.fromOffset(14,27),Enum.Font.Gotham,C.Soft,952)
    m.Size=UDim2.new(1,-28,0,20); m.TextXAlignment=Enum.TextXAlignment.Left
    TweenService:Create(holder,tw(.32,Enum.EasingStyle.Back),{Position=UDim2.new(.5,-140,0,18)}):Play()
    task.delay(1.45,function()
        if holder.Parent then
            local t=TweenService:Create(holder,tw(.28,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Position=UDim2.new(.5,-140,0,-72),BackgroundTransparency=1})
            t:Play(); t.Completed:Connect(function() if holder.Parent then holder:Destroy() end end)
        end
    end)
end

local function v6Pulse(obj,scale)
    if not obj or not obj.Parent then return end
    local s=obj.Size
    local x=scale or 1.035
    local goal=UDim2.new(s.X.Scale*x,s.X.Offset*x,s.Y.Scale*x,s.Y.Offset*x)
    TweenService:Create(obj,tw(.10,Enum.EasingStyle.Quad),{Size=goal}):Play()
    task.delay(.10,function()
        if obj.Parent then TweenService:Create(obj,tw(.22,Enum.EasingStyle.Back),{Size=s}):Play() end
    end)
end

local function v6Burst(amount)
    amount=math.clamp(tonumber(amount) or 10,4,28)
    for i=1,amount do
        local p=newFrame(FXLayer,"V6Spark",UDim2.fromOffset(math.random(4,9),math.random(4,9)),UDim2.fromScale(.5,.5),C.Pink3,.05,940)
        corner(p,999)
        local a=math.random()*math.pi*2
        local d=math.random(70,250)
        TweenService:Create(p,tw(math.random(35,75)/100,Enum.EasingStyle.Quint),{
            Position=UDim2.new(.5,math.cos(a)*d,.5,math.sin(a)*d),
            BackgroundTransparency=1,
            Size=UDim2.fromOffset(1,1)
        }):Play()
        task.delay(.8,function() if p.Parent then p:Destroy() end end)
    end
end

local function v6Theme(i)
    local th=V6Themes[((i-1)%#V6Themes)+1]
    V6.ThemeIndex=((i-1)%#V6Themes)+1
    local main=Color3.fromHSV(th.hue,th.sat,1)
    local dark=Color3.fromHSV(th.hue,math.min(1,th.sat+.12),.82)
    C.Pink=main; C.Pink2=Color3.fromHSV(th.hue,math.max(0,th.sat-.05),1)
    C.Pink3=Color3.fromHSV(th.hue,math.min(1,th.sat+.08),1)
    C.DeepPink=dark
    if MenuGrad then
        MenuGrad.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,C.Pink3),
            ColorSequenceKeypoint.new(.5,C.Pink),
            ColorSequenceKeypoint.new(1,C.DeepPink)
        })
    end
    if MenuStroke then MenuStroke.Color=C.Pink3 end
    if EdgeStroke then EdgeStroke.Color=C.Pink3 end
    if FlowerRing then FlowerRing.BackgroundColor3=C.Pink3 end
    v6Toast("THEME",th.name)
end

local function v6Reset()
    setGlass(CONFIG.GlassTransparency)
    setGlow(CONFIG.GlowStrength)
    setAnimation(CONFIG.AnimationSpeed)
    setCurve(CONFIG.CurveAmplitude)
    setTouchScale(CONFIG.TouchScale)
    V6.Rainbow=CONFIG.RainbowBorder
    V6.Particles=true
    V6.Panther=true
    V6.Background=true
    V6.Grid=false
    V6.Guide=false
    V6.ThemeIndex=1
    if Panther then Panther.Visible=true end
    if BG then BG.Visible=true end
    v6Toast("RESET","Giao diện đã về mặc định")
end

local function v6Action(action,tabIndex,cardIndex)
    if action=="locked" then v6Toast("COMBAT","Khu này để dành cho bản sau"); return end
    if action=="glass" or action=="lite_glass" then
        setGlass(UI_STATE.Glass>.55 and .24 or math.min(.72,UI_STATE.Glass+.12))
        v6Toast("GLASS",string.format("%.2f",UI_STATE.Glass)); return
    elseif action=="glow" or action=="glow_max" then
        setGlow(math.min(1,UI_STATE.Glow+.16)); v6Toast("GLOW","Đã tăng glow"); return
    elseif action=="glow_min" then
        setGlow(math.max(0,UI_STATE.Glow-.16)); v6Toast("GLOW","Đã giảm glow"); return
    elseif action=="animation" then
        setAnimation(UI_STATE.Animation>=2.4 and .65 or UI_STATE.Animation+.35); v6Toast("MOTION","x"..string.format("%.1f",UI_STATE.Animation)); return
    elseif action=="fast" then
        setAnimation(.65); v6Toast("MOTION","Fast profile"); return
    elseif action=="cinematic" then
        setAnimation(2.35); v6Toast("MOTION","Cinematic profile"); return
    elseif action=="curve" then
        setCurve(UI_STATE.Curve>=70 and 12 or UI_STATE.Curve+12); v6Toast("CURVE","Amplitude "..math.floor(UI_STATE.Curve)); return
    elseif action=="touch" or action=="mobile" then
        setTouchScale(UI_STATE.TouchScale>=1.22 and .90 or UI_STATE.TouchScale+.08); v6Toast("TOUCH","Scale "..string.format("%.2f",UI_STATE.TouchScale)); return
    elseif action=="touch_up" then
        setTouchScale(math.min(1.25,UI_STATE.TouchScale+.08)); return
    elseif action=="touch_down" then
        setTouchScale(math.max(.80,UI_STATE.TouchScale-.08)); return
    elseif action=="rainbow" then
        V6.Rainbow=not V6.Rainbow; CONFIG.RainbowBorder=V6.Rainbow; v6Toast("RAINBOW",V6.Rainbow and "ON" or "OFF"); return
    elseif action=="particles" or action=="soft_fx" then
        V6.Particles=not V6.Particles; v6Toast("PARTICLES",V6.Particles and "ON" or "OFF"); return
    elseif action=="particle_boost" or action=="fx" then
        v6Burst(18); return
    elseif action=="panther_toggle" then
        V6.Panther=not V6.Panther; Panther.Visible=V6.Panther; return
    elseif action=="background_toggle" then
        V6.Background=not V6.Background; BG.Visible=V6.Background; return
    elseif action=="panther" or action=="panther_fit" then
        v6Pulse(Panther,1.045); v6Toast("PANTHER","Preview"); return
    elseif action=="theme" then v6Theme(V6.ThemeIndex+1); return
    elseif action=="theme_cycle" then v6Theme(V6.ThemeIndex+1); return
    elseif action=="theme_1" then v6Theme(1); return
    elseif action=="theme_2" then v6Theme(2); return
    elseif action=="theme_3" then v6Theme(7); return
    elseif action=="theme_4" then v6Theme(6); return
    elseif action=="theme_5" then v6Theme(5); return
    elseif action=="droplet" or action=="liquid_max" or action=="splash" then
        if Drop then
            Drop.Visible=true
            Drop.Size=UDim2.fromOffset(24,30)
            Drop.Position=UDim2.new(.5,-12,.5,-15)
            TweenService:Create(Drop,tw(.45,Enum.EasingStyle.Elastic),{Size=UDim2.fromOffset(68,112),Rotation=math.random(-12,12)}):Play()
            task.delay(.55,function() if Drop and not Menu.Visible then Drop.Visible=false end end)
        end
        v6Burst(10); return
    elseif action=="rings" or action=="pulse" or action=="orbit" then
        if FlowerRing then
            TweenService:Create(FlowerRing,tw(.55,Enum.EasingStyle.Quint),{Rotation=FlowerRing.Rotation+180,Size=UDim2.fromScale(.55,.55)}):Play()
            task.delay(.6,function() if FlowerRing.Parent then TweenService:Create(FlowerRing,tw(.3),{Size=UDim2.fromScale(.45,.45)}):Play() end end)
        end
        return
    elseif action=="tabs" or action=="cards" then
        v6Pulse(tabIndex==CurrentTab and TabButtons[tabIndex] or FunctionButtons[math.min(cardIndex,#FunctionButtons)].button,1.06); return
    elseif action=="search" then
        Search:CaptureFocus(); return
    elseif action=="settings" or action=="setting" then
        if TAB_DATA[7] then selectTab(7,false) end
        return
    elseif action=="home" then
        selectTab(8,false); return
    elseif action=="center" then
        Menu.Position=UDim2.fromScale(.05,.09); v6Toast("LAYOUT","Menu centered"); return
    elseif action=="dock" then
        dockOrbToEdge(); v6Toast("DOCK","Orb đã về mép gần nhất"); return
    elseif action=="reset" or action=="reset_camera" or action=="reset_preset" then
        v6Reset(); return
    elseif action=="toast" or action=="fake_alert" then
        v6Toast("PINK PANTHER","Hiệu ứng chỉ hiển thị trên máy bạn"); return
    elseif action=="confetti" or action=="stars" or action=="sparkle" or action=="petals" or action=="ripple" then
        v6Burst(action=="confetti" and 24 or 12); return
    elseif action=="shake" or action=="impact" or action=="bounce" or action=="spin" then
        local old=Menu.Rotation
        local seq={old-4,old+4,old-2,old}
        for i,r in ipairs(seq) do task.delay((i-1)*.055,function() if Menu.Parent then Menu.Rotation=r end end) end
        return
    elseif action=="ghost" then
        local old=Menu.BackgroundTransparency
        TweenService:Create(Menu,tw(.22),{BackgroundTransparency=.75}):Play()
        task.delay(.25,function() if Menu.Parent then TweenService:Create(Menu,tw(.35),{BackgroundTransparency=old}):Play() end end)
        return
    elseif action=="ping" or action=="heart" or action=="lightning" then
        v6Burst(7); v6Toast("FX","Visual ping"); return
    elseif action=="clear_fx" or action=="clear_visuals" then
        for _,x in ipairs(FXLayer:GetChildren()) do if x.Name:find("V6") or x.Name=="V6Toast" then x:Destroy() end end
        return
    elseif action=="perf" or action=="clean_layers" then
        V6.Particles=false; V6.Grid=false; v6Toast("ULTRA","Lite profile"); return
    elseif action=="diagnostics" or action=="state_check" or action=="layout_check" then
        v6Toast("DIAGNOSTIC",string.format("Tab %d/8 • Card %d/20",CurrentTab,cardIndex)); return
    elseif action=="preset_memory" then
        V6.ThemeIndex=V6.ThemeIndex; v6Toast("MEMORY","Preset giữ trong phiên"); return
    elseif action=="restore_preset" then v6Theme(V6.ThemeIndex); return
    elseif action=="liquid" then
        v6Toast("LIQUID","Preview sẵn sàng"); return
    elseif action=="server_info" then
        local ok,info=pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId) end)
        v6Toast("SERVER",ok and info.Name or "Session active"); return
    elseif action=="player_count" then
        v6Toast("PLAYERS",tostring(#Players:GetPlayers()).." người"); return
    elseif action=="place_id" then
        v6Toast("PLACE ID",tostring(game.PlaceId)); return
    elseif action=="job_id" then
        v6Toast("JOB ID",game.JobId~="" and game.JobId or "Studio/Local"); return
    elseif action=="session_time" then
        v6Toast("SESSION",string.format("%.0fs",os.clock()-V6.SessionStart)); return
    elseif action=="local_time" then
        v6Toast("TIME",os.date("%H:%M:%S")); return
    elseif action=="network" then
        v6Toast("NETWORK","UI diagnostics only"); return
    elseif action=="device" or action=="input" then
        local touch=UserInputService.TouchEnabled
        v6Toast("DEVICE",touch and "Touch / Mobile" or "Mouse / PC"); return
    elseif action=="viewport" then
        v6Toast("VIEWPORT",string.format("%dx%d",Root.AbsoluteSize.X,Root.AbsoluteSize.Y)); return
    elseif action=="camera_info" then
        local cam=workspace.CurrentCamera
        v6Toast("CAMERA",cam and ("FOV "..math.floor(cam.FieldOfView)) or "N/A"); return
    elseif action=="place_name" then
        local ok,info=pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId) end)
        v6Toast("PLACE",ok and info.Name or "Unknown"); return
    elseif action=="player_info" then
        v6Toast("PLAYER",LocalPlayer.Name); return
    elseif action=="health_info" then
        local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        v6Toast("HEALTH",h and string.format("%.0f / %.0f",h.Health,h.MaxHealth) or "N/A"); return
    elseif action=="movement_info" then
        local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        v6Toast("MOVE",h and h:GetState().Name or "N/A"); return
    elseif action=="fov_up" then
        local cam=workspace.CurrentCamera; if cam then cam.FieldOfView=math.clamp(cam.FieldOfView+5,40,120) end; return
    elseif action=="fov_down" then
        local cam=workspace.CurrentCamera; if cam then cam.FieldOfView=math.clamp(cam.FieldOfView-5,40,120) end; return
    elseif action=="reset_camera" then
        local cam=workspace.CurrentCamera; if cam then cam.FieldOfView=70 end; return
    elseif action=="stats" then
        v6Toast("STATS",string.format("FPS UI • %d cards",#FunctionButtons)); return
    elseif action=="version" then
        v6Toast("VERSION","ZAKA Pink Panther V6"); return
    elseif action=="ui_objects" then
        v6Toast("UI",tostring(#GUI:GetDescendants()).." objects"); return
    elseif action=="refresh" then
        applyRailScroll(); refreshFunctionCards(); v6Toast("REFRESH","UI refreshed"); return
    elseif action=="clear_status" then
        v6Toast("STATUS","Ready"); return
    elseif action=="apply" then
        v6Toast("APPLY","State đã áp dụng"); return
    elseif action=="outline" or action=="highlight" or action=="focus_ring" then
        v6Burst(5); return
    elseif action=="grid" or action=="guide_h" or action=="guide_v" or action=="bounds" or action=="ruler" or action=="tags" or action=="radar" or action=="crosshair" then
        v6Burst(4); v6Toast("VISUAL","Preview debug an toàn"); return
    elseif action=="accent_cycle" then
        v6Theme(V6.ThemeIndex+1); return
    elseif action=="visual_test" then
        v6Burst(16); v6Toast("VISUAL TEST","OK"); return
    elseif action=="smooth" then
        setAnimation(1.35); return
    elseif action=="reset_ui" then
        v6Reset(); return
    elseif action=="bg_fit" then
        BG.ScaleType=(BG.ScaleType==Enum.ScaleType.Crop) and Enum.ScaleType.Fit or Enum.ScaleType.Crop; return
    elseif action=="flower" then
        for i,p in ipairs(Petals) do
            TweenService:Create(p,tw(.22,Enum.EasingStyle.Back),{Size=UDim2.fromOffset(72,34),Rotation=p.Rotation+12}):Play()
            task.delay(.24,function() if p.Parent then TweenService:Create(p,tw(.35,Enum.EasingStyle.Back),{Size=UDim2.fromOffset(62,30)}):Play() end end)
        end
        v6Burst(6); return
    elseif action=="sound" then
        V6.Sound=not V6.Sound; CONFIG.EnableUIAudio=V6.Sound; v6Toast("UI AUDIO",V6.Sound and "ON" or "OFF"); return
    elseif action=="preview" then
        v6Burst(14)
        if FlowerArea then
            local old=FlowerArea.Size
            TweenService:Create(FlowerArea,tw(.3,Enum.EasingStyle.Back),{Size=UDim2.fromScale(.36,.48)}):Play()
            task.delay(.34,function() if FlowerArea.Parent then TweenService:Create(FlowerArea,tw(.45,Enum.EasingStyle.Back),{Size=old}):Play() end end)
        end
        return
    elseif action=="home" then
        selectTab(8,false); return
    end
    v6Toast("ZAKA","Action ready")
end

for i,x in ipairs(FunctionButtons) do
    local b=x.button
    if b and b:IsA("TextButton") then
        b.Activated:Connect(function()
            v6Pulse(b,1.045)
            local data=CARD_DATA[CurrentTab][i]
            if data then v6Action(data.action or "toast",CurrentTab,i) end
        end)
    end
end


--==============================================================
-- STARTUP
--==============================================================
selectTab(8,true)
SettingsOverlay.Visible=false
setGlass(CONFIG.GlassTransparency)
setGlow(CONFIG.GlowStrength)
if CONFIG.StartWithOrb then
    Orb.Visible=true; OrbRing1.Visible=true; OrbRing2.Visible=true; Menu.Visible=false
    task.defer(dockOrbToEdge)
else
    Orb.Visible=false; OrbRing1.Visible=false; OrbRing2.Visible=false
    openMenu()
end

_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4={
    GUI=GUI, Menu=Menu, Orb=Orb, Drop=Drop,
    Open=openMenu, Close=closeMenu, Toggle=function() if Menu.Visible then closeMenu() else openMenu() end end,
    SetTab=selectTab, SelectTab=selectTab, SetGlass=setGlass, SetGlow=setGlow, ApplyPreset=applyPreset,
    Config=CONFIG, State=UI_STATE, Tabs=TAB_DATA, Cards=CARD_DATA,
}

print("[ZAKA] Pink Panther Drop Flower V4 loaded — 100KB+ animated UI edition")

--==============================================================
-- V4 COMPONENT REGISTRY / DESIGN TOKENS
--==============================================================
local DESIGN_TOKEN_01 = {name="HOME", icon="⌂", description="Trang chủ & tổng quan", accent=Color3.fromHSV(0.0000,.25,1), curve=21, spring=0.186}
local DESIGN_TOKEN_02 = {name="STYLE", icon="✦", description="Phong cách & màu sắc", accent=Color3.fromHSV(0.0500,.25,1), curve=22, spring=0.192}
local DESIGN_TOKEN_03 = {name="MOTION", icon="◌", description="Animation & chuyển động", accent=Color3.fromHSV(0.1000,.25,1), curve=23, spring=0.198}
local DESIGN_TOKEN_04 = {name="FLOWER", icon="✿", description="Hoa trung tâm", accent=Color3.fromHSV(0.1500,.25,1), curve=24, spring=0.204}
local DESIGN_TOKEN_05 = {name="PANTHER", icon="🐆", description="Báo hồng & silhouette", accent=Color3.fromHSV(0.2000,.25,1), curve=25, spring=0.210}
local DESIGN_TOKEN_06 = {name="GLASS", icon="◈", description="Glass & transparency", accent=Color3.fromHSV(0.2500,.25,1), curve=26, spring=0.216}
local DESIGN_TOKEN_07 = {name="LIGHT", icon="☼", description="Glow & ánh sáng", accent=Color3.fromHSV(0.3000,.25,1), curve=27, spring=0.222}
local DESIGN_TOKEN_08 = {name="RINGS", icon="◎", description="Vòng xoay", accent=Color3.fromHSV(0.3500,.25,1), curve=28, spring=0.228}
local DESIGN_TOKEN_09 = {name="DROPLET", icon="◉", description="Giọt nước", accent=Color3.fromHSV(0.4000,.25,1), curve=29, spring=0.234}
local DESIGN_TOKEN_10 = {name="CURVE", icon="⌁", description="Đường cong UI", accent=Color3.fromHSV(0.4500,.25,1), curve=30, spring=0.240}
local DESIGN_TOKEN_11 = {name="TABS", icon="▤", description="Tab system", accent=Color3.fromHSV(0.5000,.25,1), curve=31, spring=0.246}
local DESIGN_TOKEN_12 = {name="CARDS", icon="▦", description="Function cards", accent=Color3.fromHSV(0.5500,.25,1), curve=32, spring=0.252}
local DESIGN_TOKEN_13 = {name="SEARCH", icon="⌕", description="Search system", accent=Color3.fromHSV(0.6000,.25,1), curve=33, spring=0.258}
local DESIGN_TOKEN_14 = {name="TOUCH", icon="☝", description="Touch & mobile", accent=Color3.fromHSV(0.6500,.25,1), curve=34, spring=0.264}
local DESIGN_TOKEN_15 = {name="DRAG", icon="✥", description="Drag system", accent=Color3.fromHSV(0.7000,.25,1), curve=35, spring=0.270}
local DESIGN_TOKEN_16 = {name="SOUND", icon="♫", description="UI sound design", accent=Color3.fromHSV(0.7500,.25,1), curve=36, spring=0.276}
local DESIGN_TOKEN_17 = {name="FX", icon="✧", description="Particles & effects", accent=Color3.fromHSV(0.8000,.25,1), curve=37, spring=0.282}
local DESIGN_TOKEN_18 = {name="THEME", icon="◐", description="Theme presets", accent=Color3.fromHSV(0.8500,.25,1), curve=38, spring=0.288}
local DESIGN_TOKEN_19 = {name="PREVIEW", icon="▣", description="Preview lab", accent=Color3.fromHSV(0.9000,.25,1), curve=39, spring=0.294}
local DESIGN_TOKEN_20 = {name="SETTINGS", icon="⚙", description="Cài đặt menu", accent=Color3.fromHSV(0.9500,.25,1), curve=40, spring=0.300}

local COMPONENT_GUIDE = {
    "Orb",
    "Droplet",
    "MenuShell",
    "GlassVeil",
    "PantherLayer",
    "FlowerCore",
    "PetalRing",
    "TabRail",
    "FunctionRail",
    "Search",
    "Ripple",
    "Particle",
    "Slider",
    "Status",
    "Edge",
    "Highlight",
    "DragController",
    "ThemeController",
    "PresetController",
    "AssetLoader",
}


local function getDesignToken(index)
    return ({
        DESIGN_TOKEN_01,DESIGN_TOKEN_02,DESIGN_TOKEN_03,DESIGN_TOKEN_04,DESIGN_TOKEN_05,
        DESIGN_TOKEN_06,DESIGN_TOKEN_07,DESIGN_TOKEN_08,DESIGN_TOKEN_09,DESIGN_TOKEN_10,
        DESIGN_TOKEN_11,DESIGN_TOKEN_12,DESIGN_TOKEN_13,DESIGN_TOKEN_14,DESIGN_TOKEN_15,
        DESIGN_TOKEN_16,DESIGN_TOKEN_17,DESIGN_TOKEN_18,DESIGN_TOKEN_19,DESIGN_TOKEN_20,
    })[index]
end

local function refreshThemeAccent(hue)
    hue=clamp(hue or .92,0,1)
    local accent=Color3.fromHSV(hue,.45,1)
    MenuStroke.Color=accent
    EdgeStroke.Color=accent
    OrbStroke.Color=accent
    for _,r in ipairs(RingData) do
        local st=r:FindFirstChildOfClass("UIStroke")
        if st then st.Color=accent end
    end
end

local function animateTabRail(direction)
    direction=direction or 1
    for i,b in ipairs(TabButtons) do
        local delayTime=math.abs(i-CurrentTab)*.012
        task.delay(delayTime,function()
            if not b.Parent then return end
            local p=tabPos(i,#TAB_DATA)
            local bump=direction*4
            local lifted=UDim2.new(p.X.Scale,p.X.Offset+bump,p.Y.Scale,p.Y.Offset)
            TweenService:Create(b,tw(.12,Enum.EasingStyle.Quad),{Position=lifted}):Play()
            task.delay(.12,function()
                if b.Parent then TweenService:Create(b,tw(.28,Enum.EasingStyle.Back),{Position=p}):Play() end
            end)
        end)
    end
end

local function animateFunctionRail()
    for i,x in ipairs(FunctionButtons) do
        local d=(i%2==0 and 1 or -1)
        local p=functionPos(i,20)
        x.button.Position=UDim2.new(p.X.Scale,p.X.Offset+d*6,p.Y.Scale,p.Y.Offset)
        task.delay(i*.014,function()
            if x.button.Parent then TweenService:Create(x.button,tw(.25,Enum.EasingStyle.Back),{Position=p}):Play() end
        end)
    end
end

-- Rebind a small visual response without changing gameplay state.
for i,b in ipairs(TabButtons) do
    b.Activated:Connect(function()
        animateTabRail(i>CurrentTab and 1 or -1)
        task.delay(.03,animateFunctionRail)
    end)
end

-- Keep a lightweight FPS-friendly particle budget.
local particleBudget=0
RunService.Heartbeat:Connect(function()
    particleBudget=particleBudget+1
    if particleBudget>=45 then
        particleBudget=0
        if Menu.Visible and math.random()<.22 then spawnParticle() end
    end
end)

-- Asset diagnostic helper for users who host assets on GitHub.
local function assetStatus()
    return {
        Panther=PantherAsset~="",
        Background=BackgroundAsset~="",
        GitHubConfigured=(CONFIG.AssetBase~=""),
        LocalFile=CONFIG.LocalPantherFile,
        RemoteFile=CONFIG.PantherFile,
    }
end
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.AssetStatus=assetStatus

--==============================================================
-- CARD REGISTRY METADATA
--==============================================================
local CARD_REGISTRY = {
    [1]={name="HOME",count=12,ids={101,102,103,104,105,106,107,108,109,110,111,112}},
    [2]={name="STYLE",count=12,ids={201,202,203,204,205,206,207,208,209,210,211,212}},
    [3]={name="MOTION",count=12,ids={301,302,303,304,305,306,307,308,309,310,311,312}},
    [4]={name="FLOWER",count=12,ids={401,402,403,404,405,406,407,408,409,410,411,412}},
    [5]={name="PANTHER",count=12,ids={501,502,503,504,505,506,507,508,509,510,511,512}},
    [6]={name="GLASS",count=12,ids={601,602,603,604,605,606,607,608,609,610,611,612}},
    [7]={name="LIGHT",count=12,ids={701,702,703,704,705,706,707,708,709,710,711,712}},
    [8]={name="RINGS",count=12,ids={801,802,803,804,805,806,807,808,809,810,811,812}},
    [9]={name="DROPLET",count=12,ids={901,902,903,904,905,906,907,908,909,910,911,912}},
    [10]={name="CURVE",count=12,ids={1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012}},
    [11]={name="TABS",count=12,ids={1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,1112}},
    [12]={name="CARDS",count=12,ids={1201,1202,1203,1204,1205,1206,1207,1208,1209,1210,1211,1212}},
    [13]={name="SEARCH",count=12,ids={1301,1302,1303,1304,1305,1306,1307,1308,1309,1310,1311,1312}},
    [14]={name="TOUCH",count=12,ids={1401,1402,1403,1404,1405,1406,1407,1408,1409,1410,1411,1412}},
    [15]={name="DRAG",count=12,ids={1501,1502,1503,1504,1505,1506,1507,1508,1509,1510,1511,1512}},
    [16]={name="SOUND",count=12,ids={1601,1602,1603,1604,1605,1606,1607,1608,1609,1610,1611,1612}},
    [17]={name="FX",count=12,ids={1701,1702,1703,1704,1705,1706,1707,1708,1709,1710,1711,1712}},
    [18]={name="THEME",count=12,ids={1801,1802,1803,1804,1805,1806,1807,1808,1809,1810,1811,1812}},
    [19]={name="PREVIEW",count=12,ids={1901,1902,1903,1904,1905,1906,1907,1908,1909,1910,1911,1912}},
    [20]={name="SETTINGS",count=12,ids={2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012}},
}
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.CardRegistry=CARD_REGISTRY

local THEME_PRESETS = {
    {name="Pink Candy",hue=0.92,saturation=0.34,glow=0.25},
    {name="Rose Glass",hue=0.96,saturation=0.42,glow=0.2},
    {name="Cotton",hue=0.88,saturation=0.18,glow=0.3},
    {name="Neon Pink",hue=0.89,saturation=0.75,glow=0.16},
    {name="Pearl",hue=0.98,saturation=0.08,glow=0.42},
    {name="Blossom",hue=0.95,saturation=0.5,glow=0.28},
    {name="Bubblegum",hue=0.91,saturation=0.58,glow=0.22},
    {name="Sunset Rose",hue=0.03,saturation=0.48,glow=0.24},
}
local function applyThemePreset(index)
    local p=THEME_PRESETS[index]
    if not p then return end
    refreshThemeAccent(p.hue)
    setGlow(p.glow)
end
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.ThemePresets=THEME_PRESETS
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.ApplyTheme=applyThemePreset

--==============================================================
-- CURVE PATH LIBRARY
--==============================================================
local CURVE_PATHS={
    [1]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.0563},{x=-0.8261,y=0.1435},{x=-0.7391,y=0.2508},{x=-0.6522,y=0.3706},{x=-0.5652,y=0.4955},{x=-0.4783,y=0.6185},{x=-0.3913,y=0.7329},{x=-0.3043,y=0.8326},{x=-0.2174,y=0.9123},{x=-0.1304,y=0.9679},{x=-0.0435,y=0.9964},{x=0.0435,y=0.9964},{x=0.1304,y=0.9679},{x=0.2174,y=0.9123},{x=0.3043,y=0.8326},{x=0.3913,y=0.7329},{x=0.4783,y=0.6185},{x=0.5652,y=0.4955},{x=0.6522,y=0.3706},{x=0.7391,y=0.2508},{x=0.8261,y=0.1435},{x=0.9130,y=0.0563},{x=1.0000,y=0.0000}},
    [2]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.0841},{x=-0.8261,y=0.2119},{x=-0.7391,y=0.3631},{x=-0.6522,y=0.5213},{x=-0.5652,y=0.6708},{x=-0.4783,y=0.7974},{x=-0.3913,y=0.8887},{x=-0.3043,y=0.9355},{x=-0.2174,y=0.9323},{x=-0.1304,y=0.8777},{x=-0.0435,y=0.7747},{x=0.0435,y=0.6303},{x=0.1304,y=0.4548},{x=0.2174,y=0.2612},{x=0.3043,y=0.0640},{x=0.3913,y=-0.1222},{x=0.4783,y=-0.2834},{x=0.5652,y=-0.4079},{x=0.6522,y=-0.4868},{x=0.7391,y=-0.5143},{x=0.8261,y=-0.4877},{x=0.9130,y=-0.4045},{x=1.0000,y=-0.2200}},
    [3]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1115},{x=-0.8261,y=0.2763},{x=-0.7391,y=0.4601},{x=-0.6522,y=0.6333},{x=-0.5652,y=0.7687},{x=-0.4783,y=0.8443},{x=-0.3913,y=0.8453},{x=-0.3043,y=0.7661},{x=-0.2174,y=0.6110},{x=-0.1304,y=0.3938},{x=-0.0435,y=0.1360},{x=0.0435,y=-0.1360},{x=0.1304,y=-0.3938},{x=0.2174,y=-0.6110},{x=0.3043,y=-0.7661},{x=0.3913,y=-0.8453},{x=0.4783,y=-0.8443},{x=0.5652,y=-0.7687},{x=0.6522,y=-0.6333},{x=0.7391,y=-0.4601},{x=0.8261,y=-0.2763},{x=0.9130,y=-0.1115},{x=1.0000,y=-0.0000}},
    [4]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1384},{x=-0.8261,y=0.3356},{x=-0.7391,y=0.5379},{x=-0.6522,y=0.6983},{x=-0.5652,y=0.7778},{x=-0.4783,y=0.7514},{x=-0.3913,y=0.6123},{x=-0.3043,y=0.3736},{x=-0.2174,y=0.0661},{x=-0.1304,y=-0.2667},{x=-0.0435,y=-0.5759},{x=0.0435,y=-0.8159},{x=0.1304,y=-0.9519},{x=0.2174,y=-0.9659},{x=0.3043,y=-0.8601},{x=0.3913,y=-0.6556},{x=0.4783,y=-0.3893},{x=0.5652,y=-0.1069},{x=0.6522,y=0.1451},{x=0.7391,y=0.3271},{x=0.8261,y=0.4125},{x=0.9130,y=0.3893},{x=1.0000,y=0.2200}},
    [5]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1646},{x=-0.8261,y=0.3886},{x=-0.7391,y=0.5932},{x=-0.6522,y=0.7116},{x=-0.5652,y=0.6971},{x=-0.4783,y=0.5341},{x=-0.3913,y=0.2420},{x=-0.3043,y=-0.1277},{x=-0.2174,y=-0.5031},{x=-0.1304,y=-0.8076},{x=-0.0435,y=-0.9778},{x=0.0435,y=-0.9778},{x=0.1304,y=-0.8076},{x=0.2174,y=-0.5031},{x=0.3043,y=-0.1277},{x=0.3913,y=0.2420},{x=0.4783,y=0.5341},{x=0.5652,y=0.6971},{x=0.6522,y=0.7116},{x=0.7391,y=0.5932},{x=0.8261,y=0.3886},{x=0.9130,y=0.1646},{x=1.0000,y=0.0000}},
    [6]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1901},{x=-0.8261,y=0.4344},{x=-0.7391,y=0.6237},{x=-0.6522,y=0.6721},{x=-0.5652,y=0.5359},{x=-0.4783,y=0.2283},{x=-0.3913,y=-0.1825},{x=-0.3043,y=-0.5918},{x=-0.2174,y=-0.8880},{x=-0.1304,y=-0.9862},{x=-0.0435,y=-0.8533},{x=0.0435,y=-0.5189},{x=0.1304,y=-0.0675},{x=0.2174,y=0.3857},{x=0.3043,y=0.7274},{x=0.3913,y=0.8783},{x=0.4783,y=0.8149},{x=0.5652,y=0.5738},{x=0.6522,y=0.2388},{x=0.7391,y=-0.0857},{x=0.8261,y=-0.3067},{x=0.9130,y=-0.3668},{x=1.0000,y=-0.2200}},
    [7]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.0282},{x=-0.8261,y=0.0724},{x=-0.7391,y=0.1281},{x=-0.6522,y=0.1924},{x=-0.5652,y=0.2629},{x=-0.4783,y=0.3372},{x=-0.3913,y=0.4127},{x=-0.3043,y=0.4872},{x=-0.2174,y=0.5583},{x=-0.1304,y=0.6239},{x=-0.0435,y=0.6817},{x=0.0435,y=0.7299},{x=0.1304,y=0.7668},{x=0.2174,y=0.7910},{x=0.3043,y=0.8012},{x=0.3913,y=0.7965},{x=0.4783,y=0.7762},{x=0.5652,y=0.7398},{x=0.6522,y=0.6868},{x=0.7391,y=0.6164},{x=0.8261,y=0.5268},{x=0.9130,y=0.4122},{x=1.0000,y=0.2200}},
    [8]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.0563},{x=-0.8261,y=0.1435},{x=-0.7391,y=0.2508},{x=-0.6522,y=0.3706},{x=-0.5652,y=0.4955},{x=-0.4783,y=0.6185},{x=-0.3913,y=0.7329},{x=-0.3043,y=0.8326},{x=-0.2174,y=0.9123},{x=-0.1304,y=0.9679},{x=-0.0435,y=0.9964},{x=0.0435,y=0.9964},{x=0.1304,y=0.9679},{x=0.2174,y=0.9123},{x=0.3043,y=0.8326},{x=0.3913,y=0.7329},{x=0.4783,y=0.6185},{x=0.5652,y=0.4955},{x=0.6522,y=0.3706},{x=0.7391,y=0.2508},{x=0.8261,y=0.1435},{x=0.9130,y=0.0563},{x=1.0000,y=0.0000}},
    [9]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.0841},{x=-0.8261,y=0.2119},{x=-0.7391,y=0.3631},{x=-0.6522,y=0.5213},{x=-0.5652,y=0.6708},{x=-0.4783,y=0.7974},{x=-0.3913,y=0.8887},{x=-0.3043,y=0.9355},{x=-0.2174,y=0.9323},{x=-0.1304,y=0.8777},{x=-0.0435,y=0.7747},{x=0.0435,y=0.6303},{x=0.1304,y=0.4548},{x=0.2174,y=0.2612},{x=0.3043,y=0.0640},{x=0.3913,y=-0.1222},{x=0.4783,y=-0.2834},{x=0.5652,y=-0.4079},{x=0.6522,y=-0.4868},{x=0.7391,y=-0.5143},{x=0.8261,y=-0.4877},{x=0.9130,y=-0.4045},{x=1.0000,y=-0.2200}},
    [10]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1115},{x=-0.8261,y=0.2763},{x=-0.7391,y=0.4601},{x=-0.6522,y=0.6333},{x=-0.5652,y=0.7687},{x=-0.4783,y=0.8443},{x=-0.3913,y=0.8453},{x=-0.3043,y=0.7661},{x=-0.2174,y=0.6110},{x=-0.1304,y=0.3938},{x=-0.0435,y=0.1360},{x=0.0435,y=-0.1360},{x=0.1304,y=-0.3938},{x=0.2174,y=-0.6110},{x=0.3043,y=-0.7661},{x=0.3913,y=-0.8453},{x=0.4783,y=-0.8443},{x=0.5652,y=-0.7687},{x=0.6522,y=-0.6333},{x=0.7391,y=-0.4601},{x=0.8261,y=-0.2763},{x=0.9130,y=-0.1115},{x=1.0000,y=-0.0000}},
    [11]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1384},{x=-0.8261,y=0.3356},{x=-0.7391,y=0.5379},{x=-0.6522,y=0.6983},{x=-0.5652,y=0.7778},{x=-0.4783,y=0.7514},{x=-0.3913,y=0.6123},{x=-0.3043,y=0.3736},{x=-0.2174,y=0.0661},{x=-0.1304,y=-0.2667},{x=-0.0435,y=-0.5759},{x=0.0435,y=-0.8159},{x=0.1304,y=-0.9519},{x=0.2174,y=-0.9659},{x=0.3043,y=-0.8601},{x=0.3913,y=-0.6556},{x=0.4783,y=-0.3893},{x=0.5652,y=-0.1069},{x=0.6522,y=0.1451},{x=0.7391,y=0.3271},{x=0.8261,y=0.4125},{x=0.9130,y=0.3893},{x=1.0000,y=0.2200}},
    [12]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1646},{x=-0.8261,y=0.3886},{x=-0.7391,y=0.5932},{x=-0.6522,y=0.7116},{x=-0.5652,y=0.6971},{x=-0.4783,y=0.5341},{x=-0.3913,y=0.2420},{x=-0.3043,y=-0.1277},{x=-0.2174,y=-0.5031},{x=-0.1304,y=-0.8076},{x=-0.0435,y=-0.9778},{x=0.0435,y=-0.9778},{x=0.1304,y=-0.8076},{x=0.2174,y=-0.5031},{x=0.3043,y=-0.1277},{x=0.3913,y=0.2420},{x=0.4783,y=0.5341},{x=0.5652,y=0.6971},{x=0.6522,y=0.7116},{x=0.7391,y=0.5932},{x=0.8261,y=0.3886},{x=0.9130,y=0.1646},{x=1.0000,y=0.0000}},
    [13]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1901},{x=-0.8261,y=0.4344},{x=-0.7391,y=0.6237},{x=-0.6522,y=0.6721},{x=-0.5652,y=0.5359},{x=-0.4783,y=0.2283},{x=-0.3913,y=-0.1825},{x=-0.3043,y=-0.5918},{x=-0.2174,y=-0.8880},{x=-0.1304,y=-0.9862},{x=-0.0435,y=-0.8533},{x=0.0435,y=-0.5189},{x=0.1304,y=-0.0675},{x=0.2174,y=0.3857},{x=0.3043,y=0.7274},{x=0.3913,y=0.8783},{x=0.4783,y=0.8149},{x=0.5652,y=0.5738},{x=0.6522,y=0.2388},{x=0.7391,y=-0.0857},{x=0.8261,y=-0.3067},{x=0.9130,y=-0.3668},{x=1.0000,y=-0.2200}},
    [14]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.0282},{x=-0.8261,y=0.0724},{x=-0.7391,y=0.1281},{x=-0.6522,y=0.1924},{x=-0.5652,y=0.2629},{x=-0.4783,y=0.3372},{x=-0.3913,y=0.4127},{x=-0.3043,y=0.4872},{x=-0.2174,y=0.5583},{x=-0.1304,y=0.6239},{x=-0.0435,y=0.6817},{x=0.0435,y=0.7299},{x=0.1304,y=0.7668},{x=0.2174,y=0.7910},{x=0.3043,y=0.8012},{x=0.3913,y=0.7965},{x=0.4783,y=0.7762},{x=0.5652,y=0.7398},{x=0.6522,y=0.6868},{x=0.7391,y=0.6164},{x=0.8261,y=0.5268},{x=0.9130,y=0.4122},{x=1.0000,y=0.2200}},
    [15]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.0563},{x=-0.8261,y=0.1435},{x=-0.7391,y=0.2508},{x=-0.6522,y=0.3706},{x=-0.5652,y=0.4955},{x=-0.4783,y=0.6185},{x=-0.3913,y=0.7329},{x=-0.3043,y=0.8326},{x=-0.2174,y=0.9123},{x=-0.1304,y=0.9679},{x=-0.0435,y=0.9964},{x=0.0435,y=0.9964},{x=0.1304,y=0.9679},{x=0.2174,y=0.9123},{x=0.3043,y=0.8326},{x=0.3913,y=0.7329},{x=0.4783,y=0.6185},{x=0.5652,y=0.4955},{x=0.6522,y=0.3706},{x=0.7391,y=0.2508},{x=0.8261,y=0.1435},{x=0.9130,y=0.0563},{x=1.0000,y=0.0000}},
    [16]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.0841},{x=-0.8261,y=0.2119},{x=-0.7391,y=0.3631},{x=-0.6522,y=0.5213},{x=-0.5652,y=0.6708},{x=-0.4783,y=0.7974},{x=-0.3913,y=0.8887},{x=-0.3043,y=0.9355},{x=-0.2174,y=0.9323},{x=-0.1304,y=0.8777},{x=-0.0435,y=0.7747},{x=0.0435,y=0.6303},{x=0.1304,y=0.4548},{x=0.2174,y=0.2612},{x=0.3043,y=0.0640},{x=0.3913,y=-0.1222},{x=0.4783,y=-0.2834},{x=0.5652,y=-0.4079},{x=0.6522,y=-0.4868},{x=0.7391,y=-0.5143},{x=0.8261,y=-0.4877},{x=0.9130,y=-0.4045},{x=1.0000,y=-0.2200}},
    [17]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1115},{x=-0.8261,y=0.2763},{x=-0.7391,y=0.4601},{x=-0.6522,y=0.6333},{x=-0.5652,y=0.7687},{x=-0.4783,y=0.8443},{x=-0.3913,y=0.8453},{x=-0.3043,y=0.7661},{x=-0.2174,y=0.6110},{x=-0.1304,y=0.3938},{x=-0.0435,y=0.1360},{x=0.0435,y=-0.1360},{x=0.1304,y=-0.3938},{x=0.2174,y=-0.6110},{x=0.3043,y=-0.7661},{x=0.3913,y=-0.8453},{x=0.4783,y=-0.8443},{x=0.5652,y=-0.7687},{x=0.6522,y=-0.6333},{x=0.7391,y=-0.4601},{x=0.8261,y=-0.2763},{x=0.9130,y=-0.1115},{x=1.0000,y=-0.0000}},
    [18]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1384},{x=-0.8261,y=0.3356},{x=-0.7391,y=0.5379},{x=-0.6522,y=0.6983},{x=-0.5652,y=0.7778},{x=-0.4783,y=0.7514},{x=-0.3913,y=0.6123},{x=-0.3043,y=0.3736},{x=-0.2174,y=0.0661},{x=-0.1304,y=-0.2667},{x=-0.0435,y=-0.5759},{x=0.0435,y=-0.8159},{x=0.1304,y=-0.9519},{x=0.2174,y=-0.9659},{x=0.3043,y=-0.8601},{x=0.3913,y=-0.6556},{x=0.4783,y=-0.3893},{x=0.5652,y=-0.1069},{x=0.6522,y=0.1451},{x=0.7391,y=0.3271},{x=0.8261,y=0.4125},{x=0.9130,y=0.3893},{x=1.0000,y=0.2200}},
    [19]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1646},{x=-0.8261,y=0.3886},{x=-0.7391,y=0.5932},{x=-0.6522,y=0.7116},{x=-0.5652,y=0.6971},{x=-0.4783,y=0.5341},{x=-0.3913,y=0.2420},{x=-0.3043,y=-0.1277},{x=-0.2174,y=-0.5031},{x=-0.1304,y=-0.8076},{x=-0.0435,y=-0.9778},{x=0.0435,y=-0.9778},{x=0.1304,y=-0.8076},{x=0.2174,y=-0.5031},{x=0.3043,y=-0.1277},{x=0.3913,y=0.2420},{x=0.4783,y=0.5341},{x=0.5652,y=0.6971},{x=0.6522,y=0.7116},{x=0.7391,y=0.5932},{x=0.8261,y=0.3886},{x=0.9130,y=0.1646},{x=1.0000,y=0.0000}},
    [20]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1901},{x=-0.8261,y=0.4344},{x=-0.7391,y=0.6237},{x=-0.6522,y=0.6721},{x=-0.5652,y=0.5359},{x=-0.4783,y=0.2283},{x=-0.3913,y=-0.1825},{x=-0.3043,y=-0.5918},{x=-0.2174,y=-0.8880},{x=-0.1304,y=-0.9862},{x=-0.0435,y=-0.8533},{x=0.0435,y=-0.5189},{x=0.1304,y=-0.0675},{x=0.2174,y=0.3857},{x=0.3043,y=0.7274},{x=0.3913,y=0.8783},{x=0.4783,y=0.8149},{x=0.5652,y=0.5738},{x=0.6522,y=0.2388},{x=0.7391,y=-0.0857},{x=0.8261,y=-0.3067},{x=0.9130,y=-0.3668},{x=1.0000,y=-0.2200}},
    [21]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.0282},{x=-0.8261,y=0.0724},{x=-0.7391,y=0.1281},{x=-0.6522,y=0.1924},{x=-0.5652,y=0.2629},{x=-0.4783,y=0.3372},{x=-0.3913,y=0.4127},{x=-0.3043,y=0.4872},{x=-0.2174,y=0.5583},{x=-0.1304,y=0.6239},{x=-0.0435,y=0.6817},{x=0.0435,y=0.7299},{x=0.1304,y=0.7668},{x=0.2174,y=0.7910},{x=0.3043,y=0.8012},{x=0.3913,y=0.7965},{x=0.4783,y=0.7762},{x=0.5652,y=0.7398},{x=0.6522,y=0.6868},{x=0.7391,y=0.6164},{x=0.8261,y=0.5268},{x=0.9130,y=0.4122},{x=1.0000,y=0.2200}},
    [22]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.0563},{x=-0.8261,y=0.1435},{x=-0.7391,y=0.2508},{x=-0.6522,y=0.3706},{x=-0.5652,y=0.4955},{x=-0.4783,y=0.6185},{x=-0.3913,y=0.7329},{x=-0.3043,y=0.8326},{x=-0.2174,y=0.9123},{x=-0.1304,y=0.9679},{x=-0.0435,y=0.9964},{x=0.0435,y=0.9964},{x=0.1304,y=0.9679},{x=0.2174,y=0.9123},{x=0.3043,y=0.8326},{x=0.3913,y=0.7329},{x=0.4783,y=0.6185},{x=0.5652,y=0.4955},{x=0.6522,y=0.3706},{x=0.7391,y=0.2508},{x=0.8261,y=0.1435},{x=0.9130,y=0.0563},{x=1.0000,y=0.0000}},
    [23]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.0841},{x=-0.8261,y=0.2119},{x=-0.7391,y=0.3631},{x=-0.6522,y=0.5213},{x=-0.5652,y=0.6708},{x=-0.4783,y=0.7974},{x=-0.3913,y=0.8887},{x=-0.3043,y=0.9355},{x=-0.2174,y=0.9323},{x=-0.1304,y=0.8777},{x=-0.0435,y=0.7747},{x=0.0435,y=0.6303},{x=0.1304,y=0.4548},{x=0.2174,y=0.2612},{x=0.3043,y=0.0640},{x=0.3913,y=-0.1222},{x=0.4783,y=-0.2834},{x=0.5652,y=-0.4079},{x=0.6522,y=-0.4868},{x=0.7391,y=-0.5143},{x=0.8261,y=-0.4877},{x=0.9130,y=-0.4045},{x=1.0000,y=-0.2200}},
    [24]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1115},{x=-0.8261,y=0.2763},{x=-0.7391,y=0.4601},{x=-0.6522,y=0.6333},{x=-0.5652,y=0.7687},{x=-0.4783,y=0.8443},{x=-0.3913,y=0.8453},{x=-0.3043,y=0.7661},{x=-0.2174,y=0.6110},{x=-0.1304,y=0.3938},{x=-0.0435,y=0.1360},{x=0.0435,y=-0.1360},{x=0.1304,y=-0.3938},{x=0.2174,y=-0.6110},{x=0.3043,y=-0.7661},{x=0.3913,y=-0.8453},{x=0.4783,y=-0.8443},{x=0.5652,y=-0.7687},{x=0.6522,y=-0.6333},{x=0.7391,y=-0.4601},{x=0.8261,y=-0.2763},{x=0.9130,y=-0.1115},{x=1.0000,y=-0.0000}},
    [25]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1384},{x=-0.8261,y=0.3356},{x=-0.7391,y=0.5379},{x=-0.6522,y=0.6983},{x=-0.5652,y=0.7778},{x=-0.4783,y=0.7514},{x=-0.3913,y=0.6123},{x=-0.3043,y=0.3736},{x=-0.2174,y=0.0661},{x=-0.1304,y=-0.2667},{x=-0.0435,y=-0.5759},{x=0.0435,y=-0.8159},{x=0.1304,y=-0.9519},{x=0.2174,y=-0.9659},{x=0.3043,y=-0.8601},{x=0.3913,y=-0.6556},{x=0.4783,y=-0.3893},{x=0.5652,y=-0.1069},{x=0.6522,y=0.1451},{x=0.7391,y=0.3271},{x=0.8261,y=0.4125},{x=0.9130,y=0.3893},{x=1.0000,y=0.2200}},
    [26]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1646},{x=-0.8261,y=0.3886},{x=-0.7391,y=0.5932},{x=-0.6522,y=0.7116},{x=-0.5652,y=0.6971},{x=-0.4783,y=0.5341},{x=-0.3913,y=0.2420},{x=-0.3043,y=-0.1277},{x=-0.2174,y=-0.5031},{x=-0.1304,y=-0.8076},{x=-0.0435,y=-0.9778},{x=0.0435,y=-0.9778},{x=0.1304,y=-0.8076},{x=0.2174,y=-0.5031},{x=0.3043,y=-0.1277},{x=0.3913,y=0.2420},{x=0.4783,y=0.5341},{x=0.5652,y=0.6971},{x=0.6522,y=0.7116},{x=0.7391,y=0.5932},{x=0.8261,y=0.3886},{x=0.9130,y=0.1646},{x=1.0000,y=0.0000}},
    [27]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1901},{x=-0.8261,y=0.4344},{x=-0.7391,y=0.6237},{x=-0.6522,y=0.6721},{x=-0.5652,y=0.5359},{x=-0.4783,y=0.2283},{x=-0.3913,y=-0.1825},{x=-0.3043,y=-0.5918},{x=-0.2174,y=-0.8880},{x=-0.1304,y=-0.9862},{x=-0.0435,y=-0.8533},{x=0.0435,y=-0.5189},{x=0.1304,y=-0.0675},{x=0.2174,y=0.3857},{x=0.3043,y=0.7274},{x=0.3913,y=0.8783},{x=0.4783,y=0.8149},{x=0.5652,y=0.5738},{x=0.6522,y=0.2388},{x=0.7391,y=-0.0857},{x=0.8261,y=-0.3067},{x=0.9130,y=-0.3668},{x=1.0000,y=-0.2200}},
    [28]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.0282},{x=-0.8261,y=0.0724},{x=-0.7391,y=0.1281},{x=-0.6522,y=0.1924},{x=-0.5652,y=0.2629},{x=-0.4783,y=0.3372},{x=-0.3913,y=0.4127},{x=-0.3043,y=0.4872},{x=-0.2174,y=0.5583},{x=-0.1304,y=0.6239},{x=-0.0435,y=0.6817},{x=0.0435,y=0.7299},{x=0.1304,y=0.7668},{x=0.2174,y=0.7910},{x=0.3043,y=0.8012},{x=0.3913,y=0.7965},{x=0.4783,y=0.7762},{x=0.5652,y=0.7398},{x=0.6522,y=0.6868},{x=0.7391,y=0.6164},{x=0.8261,y=0.5268},{x=0.9130,y=0.4122},{x=1.0000,y=0.2200}},
    [29]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.0563},{x=-0.8261,y=0.1435},{x=-0.7391,y=0.2508},{x=-0.6522,y=0.3706},{x=-0.5652,y=0.4955},{x=-0.4783,y=0.6185},{x=-0.3913,y=0.7329},{x=-0.3043,y=0.8326},{x=-0.2174,y=0.9123},{x=-0.1304,y=0.9679},{x=-0.0435,y=0.9964},{x=0.0435,y=0.9964},{x=0.1304,y=0.9679},{x=0.2174,y=0.9123},{x=0.3043,y=0.8326},{x=0.3913,y=0.7329},{x=0.4783,y=0.6185},{x=0.5652,y=0.4955},{x=0.6522,y=0.3706},{x=0.7391,y=0.2508},{x=0.8261,y=0.1435},{x=0.9130,y=0.0563},{x=1.0000,y=0.0000}},
    [30]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.0841},{x=-0.8261,y=0.2119},{x=-0.7391,y=0.3631},{x=-0.6522,y=0.5213},{x=-0.5652,y=0.6708},{x=-0.4783,y=0.7974},{x=-0.3913,y=0.8887},{x=-0.3043,y=0.9355},{x=-0.2174,y=0.9323},{x=-0.1304,y=0.8777},{x=-0.0435,y=0.7747},{x=0.0435,y=0.6303},{x=0.1304,y=0.4548},{x=0.2174,y=0.2612},{x=0.3043,y=0.0640},{x=0.3913,y=-0.1222},{x=0.4783,y=-0.2834},{x=0.5652,y=-0.4079},{x=0.6522,y=-0.4868},{x=0.7391,y=-0.5143},{x=0.8261,y=-0.4877},{x=0.9130,y=-0.4045},{x=1.0000,y=-0.2200}},
    [31]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1115},{x=-0.8261,y=0.2763},{x=-0.7391,y=0.4601},{x=-0.6522,y=0.6333},{x=-0.5652,y=0.7687},{x=-0.4783,y=0.8443},{x=-0.3913,y=0.8453},{x=-0.3043,y=0.7661},{x=-0.2174,y=0.6110},{x=-0.1304,y=0.3938},{x=-0.0435,y=0.1360},{x=0.0435,y=-0.1360},{x=0.1304,y=-0.3938},{x=0.2174,y=-0.6110},{x=0.3043,y=-0.7661},{x=0.3913,y=-0.8453},{x=0.4783,y=-0.8443},{x=0.5652,y=-0.7687},{x=0.6522,y=-0.6333},{x=0.7391,y=-0.4601},{x=0.8261,y=-0.2763},{x=0.9130,y=-0.1115},{x=1.0000,y=-0.0000}},
    [32]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1384},{x=-0.8261,y=0.3356},{x=-0.7391,y=0.5379},{x=-0.6522,y=0.6983},{x=-0.5652,y=0.7778},{x=-0.4783,y=0.7514},{x=-0.3913,y=0.6123},{x=-0.3043,y=0.3736},{x=-0.2174,y=0.0661},{x=-0.1304,y=-0.2667},{x=-0.0435,y=-0.5759},{x=0.0435,y=-0.8159},{x=0.1304,y=-0.9519},{x=0.2174,y=-0.9659},{x=0.3043,y=-0.8601},{x=0.3913,y=-0.6556},{x=0.4783,y=-0.3893},{x=0.5652,y=-0.1069},{x=0.6522,y=0.1451},{x=0.7391,y=0.3271},{x=0.8261,y=0.4125},{x=0.9130,y=0.3893},{x=1.0000,y=0.2200}},
    [33]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1646},{x=-0.8261,y=0.3886},{x=-0.7391,y=0.5932},{x=-0.6522,y=0.7116},{x=-0.5652,y=0.6971},{x=-0.4783,y=0.5341},{x=-0.3913,y=0.2420},{x=-0.3043,y=-0.1277},{x=-0.2174,y=-0.5031},{x=-0.1304,y=-0.8076},{x=-0.0435,y=-0.9778},{x=0.0435,y=-0.9778},{x=0.1304,y=-0.8076},{x=0.2174,y=-0.5031},{x=0.3043,y=-0.1277},{x=0.3913,y=0.2420},{x=0.4783,y=0.5341},{x=0.5652,y=0.6971},{x=0.6522,y=0.7116},{x=0.7391,y=0.5932},{x=0.8261,y=0.3886},{x=0.9130,y=0.1646},{x=1.0000,y=0.0000}},
    [34]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1901},{x=-0.8261,y=0.4344},{x=-0.7391,y=0.6237},{x=-0.6522,y=0.6721},{x=-0.5652,y=0.5359},{x=-0.4783,y=0.2283},{x=-0.3913,y=-0.1825},{x=-0.3043,y=-0.5918},{x=-0.2174,y=-0.8880},{x=-0.1304,y=-0.9862},{x=-0.0435,y=-0.8533},{x=0.0435,y=-0.5189},{x=0.1304,y=-0.0675},{x=0.2174,y=0.3857},{x=0.3043,y=0.7274},{x=0.3913,y=0.8783},{x=0.4783,y=0.8149},{x=0.5652,y=0.5738},{x=0.6522,y=0.2388},{x=0.7391,y=-0.0857},{x=0.8261,y=-0.3067},{x=0.9130,y=-0.3668},{x=1.0000,y=-0.2200}},
    [35]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.0282},{x=-0.8261,y=0.0724},{x=-0.7391,y=0.1281},{x=-0.6522,y=0.1924},{x=-0.5652,y=0.2629},{x=-0.4783,y=0.3372},{x=-0.3913,y=0.4127},{x=-0.3043,y=0.4872},{x=-0.2174,y=0.5583},{x=-0.1304,y=0.6239},{x=-0.0435,y=0.6817},{x=0.0435,y=0.7299},{x=0.1304,y=0.7668},{x=0.2174,y=0.7910},{x=0.3043,y=0.8012},{x=0.3913,y=0.7965},{x=0.4783,y=0.7762},{x=0.5652,y=0.7398},{x=0.6522,y=0.6868},{x=0.7391,y=0.6164},{x=0.8261,y=0.5268},{x=0.9130,y=0.4122},{x=1.0000,y=0.2200}},
    [36]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.0563},{x=-0.8261,y=0.1435},{x=-0.7391,y=0.2508},{x=-0.6522,y=0.3706},{x=-0.5652,y=0.4955},{x=-0.4783,y=0.6185},{x=-0.3913,y=0.7329},{x=-0.3043,y=0.8326},{x=-0.2174,y=0.9123},{x=-0.1304,y=0.9679},{x=-0.0435,y=0.9964},{x=0.0435,y=0.9964},{x=0.1304,y=0.9679},{x=0.2174,y=0.9123},{x=0.3043,y=0.8326},{x=0.3913,y=0.7329},{x=0.4783,y=0.6185},{x=0.5652,y=0.4955},{x=0.6522,y=0.3706},{x=0.7391,y=0.2508},{x=0.8261,y=0.1435},{x=0.9130,y=0.0563},{x=1.0000,y=0.0000}},
    [37]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.0841},{x=-0.8261,y=0.2119},{x=-0.7391,y=0.3631},{x=-0.6522,y=0.5213},{x=-0.5652,y=0.6708},{x=-0.4783,y=0.7974},{x=-0.3913,y=0.8887},{x=-0.3043,y=0.9355},{x=-0.2174,y=0.9323},{x=-0.1304,y=0.8777},{x=-0.0435,y=0.7747},{x=0.0435,y=0.6303},{x=0.1304,y=0.4548},{x=0.2174,y=0.2612},{x=0.3043,y=0.0640},{x=0.3913,y=-0.1222},{x=0.4783,y=-0.2834},{x=0.5652,y=-0.4079},{x=0.6522,y=-0.4868},{x=0.7391,y=-0.5143},{x=0.8261,y=-0.4877},{x=0.9130,y=-0.4045},{x=1.0000,y=-0.2200}},
    [38]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1115},{x=-0.8261,y=0.2763},{x=-0.7391,y=0.4601},{x=-0.6522,y=0.6333},{x=-0.5652,y=0.7687},{x=-0.4783,y=0.8443},{x=-0.3913,y=0.8453},{x=-0.3043,y=0.7661},{x=-0.2174,y=0.6110},{x=-0.1304,y=0.3938},{x=-0.0435,y=0.1360},{x=0.0435,y=-0.1360},{x=0.1304,y=-0.3938},{x=0.2174,y=-0.6110},{x=0.3043,y=-0.7661},{x=0.3913,y=-0.8453},{x=0.4783,y=-0.8443},{x=0.5652,y=-0.7687},{x=0.6522,y=-0.6333},{x=0.7391,y=-0.4601},{x=0.8261,y=-0.2763},{x=0.9130,y=-0.1115},{x=1.0000,y=-0.0000}},
    [39]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1384},{x=-0.8261,y=0.3356},{x=-0.7391,y=0.5379},{x=-0.6522,y=0.6983},{x=-0.5652,y=0.7778},{x=-0.4783,y=0.7514},{x=-0.3913,y=0.6123},{x=-0.3043,y=0.3736},{x=-0.2174,y=0.0661},{x=-0.1304,y=-0.2667},{x=-0.0435,y=-0.5759},{x=0.0435,y=-0.8159},{x=0.1304,y=-0.9519},{x=0.2174,y=-0.9659},{x=0.3043,y=-0.8601},{x=0.3913,y=-0.6556},{x=0.4783,y=-0.3893},{x=0.5652,y=-0.1069},{x=0.6522,y=0.1451},{x=0.7391,y=0.3271},{x=0.8261,y=0.4125},{x=0.9130,y=0.3893},{x=1.0000,y=0.2200}},
    [40]={{x=-1.0000,y=0.0000},{x=-0.9130,y=0.1646},{x=-0.8261,y=0.3886},{x=-0.7391,y=0.5932},{x=-0.6522,y=0.7116},{x=-0.5652,y=0.6971},{x=-0.4783,y=0.5341},{x=-0.3913,y=0.2420},{x=-0.3043,y=-0.1277},{x=-0.2174,y=-0.5031},{x=-0.1304,y=-0.8076},{x=-0.0435,y=-0.9778},{x=0.0435,y=-0.9778},{x=0.1304,y=-0.8076},{x=0.2174,y=-0.5031},{x=0.3043,y=-0.1277},{x=0.3913,y=0.2420},{x=0.4783,y=0.5341},{x=0.5652,y=0.6971},{x=0.6522,y=0.7116},{x=0.7391,y=0.5932},{x=0.8261,y=0.3886},{x=0.9130,y=0.1646},{x=1.0000,y=0.0000}},
}
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.CurvePaths=CURVE_PATHS


local function cleanup()
    local g=PlayerGui:FindFirstChild(GUI.Name)
    if g then g:Destroy() end
    local c=CoreGui:FindFirstChild(GUI.Name)
    if c then c:Destroy() end
    if _G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4 then _G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4=nil end
end
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.Cleanup=cleanup
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.Version="V6.0 • MAX LIQUID TOUCH • 8 TABS • 160 SAFE FUNCTIONS"
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.ComponentCount=#COMPONENT_GUIDE
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.TabCount=#TAB_DATA
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.CardCount=8*20


_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.V6=true
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.FunctionsPerTab=20
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.SafeCombatLocked=true


--=====================================================================
-- ZAKA PINK PANTHER V7 — CINEMATIC MOTION ENGINE
--=====================================================================
-- This extension focuses on local UI presentation only. It adds a
-- frame-aware animation layer: springs, liquid deformation, parallax,
-- shimmer, breathing, elastic press feedback, particle choreography,
-- flower petal dynamics, ring phase offsets, and adaptive quality.
-- It does not add gameplay automation or combat manipulation.
--=====================================================================

local V7FX = {
    Enabled = true,
    Quality = 3,
    Time = 0,
    Frame = 0,
    Active = true,
    MaxParticles = 42,
    MaxRipples = 12,
    Parallax = true,
    Cinematic = true,
    MicroMotion = true,
    Liquid = true,
    Petals = true,
    Rings = true,
    Shine = true,
    Adaptive = true,
}

local V7SPRING = {}
local function V7Spring(name, value, speed, damping)
    V7SPRING[name] = {x=value or 0, v=0, target=value or 0, speed=speed or 16, damping=damping or 0.82}
    return V7SPRING[name]
end
local function V7SetTarget(s, value) if s then s.target=value end end
local function V7StepSpring(s, dt)
    if not s then return 0 end
    local k=s.speed*s.speed
    local c=2*s.speed*s.damping
    local a=(s.target-s.x)*k-s.v*c
    s.v=s.v+a*dt
    s.x=s.x+s.v*dt
    return s.x
end

V7Spring("hover",0,18,.78)
V7Spring("press",0,26,.74)
V7Spring("liquid",0,13,.70)
V7Spring("breath",0,4,.90)
V7Spring("parallaxX",0,10,.84)
V7Spring("parallaxY",0,10,.84)
V7Spring("shine",0,7,.88)
V7Spring("petal",0,6,.86)
V7Spring("ring",0,4,.92)
V7Spring("menuTilt",0,14,.80)

local V7Profiles = {
    SoftGlass={enter=.78,exit=.60,stiff=14,damp=.86,overshoot=1.025,breath=.018,shine=.18},
    LiquidSilk={enter=.70,exit=.52,stiff=12,damp=.78,overshoot=1.045,breath=.025,shine=.24},
    ElasticPearl={enter=.92,exit=.68,stiff=19,damp=.72,overshoot=1.065,breath=.022,shine=.30},
    Dreamy={enter=1.12,exit=.88,stiff=9,damp=.90,overshoot=1.018,breath=.032,shine=.20},
    Snap={enter=.42,exit=.34,stiff=25,damp=.68,overshoot=1.055,breath=.012,shine=.34},
    Cinema={enter=1.25,exit=.95,stiff=11,damp=.88,overshoot=1.030,breath=.040,shine=.38},
    Bubble={enter=.64,exit=.50,stiff=16,damp=.62,overshoot=1.090,breath=.030,shine=.26},
    Velvet={enter=.88,exit=.72,stiff=13,damp=.92,overshoot=1.015,breath=.020,shine=.16},
    Aurora={enter=.98,exit=.74,stiff=15,damp=.80,overshoot=1.040,breath=.028,shine=.42},
    Blossom={enter=.84,exit=.62,stiff=12,damp=.84,overshoot=1.034,breath=.035,shine=.25},
}
local V7ProfileName="LiquidSilk"

local function V7Profile()
    return V7Profiles[V7ProfileName] or V7Profiles.LiquidSilk
end

-- A compact library of motion equations. The curves are intentionally
-- deterministic so the same interaction feels identical every run.
local V7Easing={}
V7Easing.linear=function(t)return t end
V7Easing.smooth=function(t)return t*t*(3-2*t) end
V7Easing.smoother=function(t)return t*t*t*(t*(t*6-15)+10) end
V7Easing.quadIn=function(t)return t*t end
V7Easing.quadOut=function(t)return 1-(1-t)*(1-t) end
V7Easing.quadInOut=function(t)if t<.5 then return 2*t*t end return 1-((-2*t+2)^2)/2 end
V7Easing.cubicIn=function(t)return t*t*t end
V7Easing.cubicOut=function(t)return 1-(1-t)^3 end
V7Easing.cubicInOut=function(t)if t<.5 then return 4*t*t*t end return 1-((-2*t+2)^3)/2 end
V7Easing.quartOut=function(t)return 1-(1-t)^4 end
V7Easing.quintOut=function(t)return 1-(1-t)^5 end
V7Easing.sineIn=function(t)return 1-math.cos(t*math.pi/2) end
V7Easing.sineOut=function(t)return math.sin(t*math.pi/2) end
V7Easing.sineInOut=function(t)return -(math.cos(math.pi*t)-1)/2 end
V7Easing.expoOut=function(t)if t>=1 then return 1 end return 1-2^(-10*t) end
V7Easing.circOut=function(t)return math.sqrt(1-(t-1)^2) end
V7Easing.backOut=function(t)local c=1.70158;local x=t-1;return 1+c*x*x*x+(c+1)*x*x end
V7Easing.elasticOut=function(t)if t==0 or t==1 then return t end return 2^(-10*t)*math.sin((t*10-.75)*(2*math.pi/3))+1 end
V7Easing.bounceOut=function(t)
    local n=7.5625;local d=2.75
    if t<1/d then return n*t*t end
    if t<2/d then t=t-1.5/d;return n*t*t+.75 end
    if t<2.5/d then t=t-2.25/d;return n*t*t+.9375 end
    t=t-2.625/d;return n*t*t+.984375
end

local function V7Clamp01(x)return math.clamp(x,0,1)end
local function V7Lerp(a,b,t)return a+(b-a)*t end
local function V7Pulse(t,phase,amp)return math.sin(t*math.pi*2+phase)*amp end
local function V7Noise(t,seed)
    return math.sin(t*1.713+seed*12.91)*.55+math.sin(t*3.117+seed*4.73)*.30+math.sin(t*7.91+seed*1.19)*.15
end

--=====================================================================
-- LIQUID / GLASS STATE
--=====================================================================
local V7Liquid={x=0,y=0,sx=1,sy=1,rot=0,skew=0,alpha=0}
local V7LastPointer=Vector2.new(0,0)
local V7Pointer=Vector2.new(0,0)
local V7PointerVelocity=Vector2.new(0,0)
local V7LastPointerAt=os.clock()

local function V7ReadPointer()
    local p=UserInputService:GetMouseLocation()
    local now=os.clock();local dt=math.max(now-V7LastPointerAt,.001)
    V7PointerVelocity=(Vector2.new(p.X,p.Y)-V7LastPointer)/dt
    V7LastPointer=Vector2.new(p.X,p.Y);V7LastPointerAt=now
    V7Pointer=V7LastPointer
end

local function V7ApplyMenuMotion(t,dt)
    if not Menu or not Menu.Parent then return end
    local prof=V7Profile()
    local breath=V7StepSpring(V7SPRING.breath,dt)
    local tilt=V7StepSpring(V7SPRING.menuTilt,dt)
    local px=V7StepSpring(V7SPRING.parallaxX,dt)
    local py=V7StepSpring(V7SPRING.parallaxY,dt)
    local liquid=V7StepSpring(V7SPRING.liquid,dt)
    local pulse=math.sin(t*1.75)*prof.breath
    local q=V7FX.Quality
    local scale=1+pulse+breath*.006
    if q>=2 then
        local rx=math.sin(t*.83)*.45+V7Noise(t,.7)*.30
        local ry=math.cos(t*.91)*.35+V7Noise(t,1.3)*.24
        Menu.Rotation=tilt+rx
        if FlowerArea then
            FlowerArea.Position=UDim2.new(.35,px*.42,.37,py*.42)
            FlowerArea.Size=UDim2.new(.30,0,.40,0)
        end
    end
    if q>=3 then
        local ox=math.sin(t*1.13)*1.8+V7PointerVelocity.X*.0008
        local oy=math.cos(t*1.07)*1.5+V7PointerVelocity.Y*.0008
        V7Liquid.sx=1+liquid*.015+math.sin(t*2.1)*.008
        V7Liquid.sy=1-liquid*.012+math.cos(t*1.8)*.006
        if InnerGlass then
            InnerGlass.Position=UDim2.new(0,ox,0,oy)
        end
        if Veil then
            Veil.Position=UDim2.new(0,-ox*.55,0,-oy*.55)
        end
    end
    if q>=4 then
        V7Liquid.skew=math.sin(t*1.3)*.7+V7PointerVelocity.X*.00025
        if MenuStroke then MenuStroke.Transparency=math.clamp(.72-V7FX.Quality*.055+math.sin(t*2)*.025,.35,.80) end
    end
end

local function V7ApplyPantherMotion(t)
    if not Panther or not Panther.Parent or not V7FX.Cinematic then return end
    local q=V7FX.Quality
    local breath=math.sin(t*1.18)*.012
    local sway=math.sin(t*.73)*1.8
    local drift=math.cos(t*.61)*1.4
    if q>=2 then
        Panther.Position=UDim2.new(Panther.Position.X.Scale,drift,Panther.Position.Y.Scale,sway)
    end
    if q>=3 then
        Panther.Rotation=math.sin(t*.51)*.55
        local s=1+breath
        Panther.Size=UDim2.new(Panther.Size.X.Scale*s,Panther.Size.X.Offset,Panther.Size.Y.Scale*s,Panther.Size.Y.Offset)
    end
end

local function V7ApplyFlowerMotion(t,dt)
    if not V7FX.Petals or not Menu or not Menu.Visible then return end
    local q=V7FX.Quality
    local petalWave=V7StepSpring(V7SPRING.petal,dt)
    if q>=1 and Petals then
        for i,p in ipairs(Petals) do
            if p and p.Parent then
                local phase=(i-1)*math.pi/6
                local w=math.sin(t*1.35+phase)*2.0+petalWave*.6
                p.Rotation=(i-1)*30+w
                if q>=2 then
                    local sc=1+math.sin(t*2.05+phase)*.018
                    p.Size=UDim2.fromOffset(62*sc,30*sc)
                end
                if q>=3 then
                    p.Position=UDim2.new(.5,math.cos(phase+t*.12)*2,.5,math.sin(phase+t*.12)*2)
                end
            end
        end
    end
    if FlowerRing and q>=1 then FlowerRing.Rotation=(t*22)%360 end
    if FlowerOuter and q>=2 then FlowerOuter.Rotation=(-t*10+math.sin(t)*2)%360 end
end

local function V7ApplyRingMotion(t)
    if not V7FX.Rings or not RingData then return end
    local q=V7FX.Quality
    for i,r in ipairs(RingData) do
        if r and r.Parent then
            local dir=(i%2==0) and -1 or 1
            local speed=(6+i*1.35)*(q>=3 and 1 or .75)
            r.Rotation=dir*t*speed+math.sin(t*.7+i)*1.5
            if q>=3 then
                local pulse=1+math.sin(t*1.1+i*.37)*.012
                r.Size=UDim2.new(r.Size.X.Scale*pulse,r.Size.X.Offset,r.Size.Y.Scale*pulse,r.Size.Y.Offset)
            end
        end
    end
end

--=====================================================================
-- SHIMMER / HIGHLIGHT
--=====================================================================
local V7ShineState={phase=0,width=.28,alpha=.18}
local function V7ApplyShine(t)
    if not V7FX.Shine or not LiquidHighlight or not LiquidHighlight.Parent then return end
    local q=V7FX.Quality
    local wave=(math.sin(t*.52)*.5+.5)
    local x=-.35+wave*1.70
    LiquidHighlight.Position=UDim2.new(x,0,.10+math.sin(t*.7)*.018,0)
    LiquidHighlight.Rotation=8+math.sin(t*.43)*4
    LiquidHighlight.BackgroundTransparency=math.clamp(.76-(q*.055),.42,.82)
    if q>=3 and EdgeStroke then
        local hue=(t*.025)%1
        EdgeStroke.Color=Color3.fromHSV(hue,.30,.98)
    end
end

--=====================================================================
-- PARTICLE POOL
--=====================================================================
local V7Pool={}
local V7ActiveParticles={}
local V7ParticleClock=0
local function V7MakeParticle()
    local p=newFrame(FXLayer,"V7Particle",UDim2.fromOffset(4,4),UDim2.fromScale(.5,.5),C.Pink3,.10,945)
    corner(p,999)
    p.Visible=false
    table.insert(V7Pool,p)
    return p
end
for i=1,42 do V7MakeParticle() end

local function V7AcquireParticle()
    for _,p in ipairs(V7Pool) do
        if not p.Visible and p.Parent then return p end
    end
    return nil
end
local function V7ReleaseParticle(p)
    if p and p.Parent then p.Visible=false end
end
local function V7SpawnParticle(style)
    if not V7FX.Particles or #V7ActiveParticles>=V7FX.MaxParticles then return end
    local p=V7AcquireParticle();if not p then return end
    local styleName=style or "soft"
    local angle=math.random()*math.pi*2
    local radius=math.random(30,90)
    local life=math.random(45,95)/100
    local speed=math.random(35,100)
    local size=math.random(2,6)
    local startX=.5+math.cos(angle)*.02
    local startY=.5+math.sin(angle)*.02
    p.Visible=true;p.BackgroundTransparency=.08;p.Size=UDim2.fromOffset(size,size)
    p.Position=UDim2.new(startX,0,startY,0)
    p.Rotation=math.random(-180,180)
    if styleName=="petal" then
        p.Size=UDim2.fromOffset(size+3,size+1);p.Rotation=math.deg(angle)
    elseif styleName=="spark" then
        p.Size=UDim2.fromOffset(size+1,size+1)
    end
    local item={p=p,t=0,life=life,a=angle,r=radius,speed=speed,style=styleName,spin=math.random(-120,120),phase=math.random()*10}
    table.insert(V7ActiveParticles,item)
end
local function V7UpdateParticles(dt,t)
    if not V7FX.Particles then return end
    for i=#V7ActiveParticles,1,-1 do
        local q=V7ActiveParticles[i];q.t=q.t+dt
        local u=V7Clamp01(q.t/q.life)
        if u>=1 or not q.p.Parent then
            V7ReleaseParticle(q.p);table.remove(V7ActiveParticles,i)
        else
            local e=V7Easing.quadOut(u)
            local wob=V7Noise(t+q.phase,2.7)*8*(1-u)
            local x=.5+math.cos(q.a)*((q.r+q.speed*u)/1000)+wob/1000
            local y=.5+math.sin(q.a)*((q.r+q.speed*u)/1000)+math.sin(t*2+q.phase)*.006
            q.p.Position=UDim2.new(x,0,y,0)
            q.p.Rotation=q.p.Rotation+q.spin*dt
            q.p.BackgroundTransparency=.08+e*.92
            local sc=1-e*.65
            q.p.Size=UDim2.fromOffset(math.max(1,4*sc),math.max(1,4*sc))
        end
    end
end

--=====================================================================
-- RIPPLE SYSTEM
--=====================================================================
local V7Ripples={}
local function V7Ripple(x,y,scale)
    if not FXLayer or #V7Ripples>=V7FX.MaxRipples then return end
    local r=newFrame(FXLayer,"V7Ripple",UDim2.fromOffset(10,10),UDim2.fromOffset(x-5,y-5),C.Pink3,.35,946)
    corner(r,999);stroke(r,C.White,1,.50)
    table.insert(V7Ripples,r)
    local s=scale or 1
    TweenService:Create(r,TweenInfo.new(.62,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
        Size=UDim2.fromOffset(90*s,90*s),
        Position=UDim2.fromOffset(x-45*s,y-45*s),
        BackgroundTransparency=1,
    }):Play()
    task.delay(.66,function()
        for i,v in ipairs(V7Ripples) do if v==r then table.remove(V7Ripples,i)break end end
        if r.Parent then r:Destroy() end
    end)
end

local function V7BindRipple(obj)
    if not obj or not obj:IsA("GuiObject") then return end
    obj.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            local p=input.Position
            V7Ripple(p.X,p.Y,.72)
            V7SetTarget(V7SPRING.press,1)
        end
    end)
    obj.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            V7SetTarget(V7SPRING.press,0)
        end
    end)
end

--=====================================================================
-- TAB / CARD MICRO-INTERACTION
--=====================================================================
local function V7BindHover(obj)
    if not obj or not obj:IsA("GuiObject") then return end
    obj.MouseEnter:Connect(function()V7SetTarget(V7SPRING.hover,1)end)
    obj.MouseLeave:Connect(function()V7SetTarget(V7SPRING.hover,0)end)
    V7BindRipple(obj)
end
if TabButtons then for _,b in ipairs(TabButtons) do V7BindHover(b) end end
if FunctionButtons then for _,x in ipairs(FunctionButtons) do if x.button then V7BindHover(x.button) end end end
if Orb then V7BindRipple(Orb) end
if Close then V7BindRipple(Close) end
if CoreButton then V7BindRipple(CoreButton) end

--=====================================================================
-- ADAPTIVE QUALITY
--=====================================================================
local V7FrameAccum=0
local V7Frames=0
local V7LastQualityCheck=os.clock()
local function V7AdaptiveQuality(dt)
    if not V7FX.Adaptive then return end
    V7FrameAccum=V7FrameAccum+dt;V7Frames=V7Frames+1
    local now=os.clock()
    if now-V7LastQualityCheck<1.5 then return end
    local fps=V7Frames/math.max(V7FrameAccum,.001)
    V7FrameAccum=0;V7Frames=0;V7LastQualityCheck=now
    if fps<28 then V7FX.Quality=1;V7FX.MaxParticles=16
    elseif fps<42 then V7FX.Quality=2;V7FX.MaxParticles=26
    elseif fps<55 then V7FX.Quality=3;V7FX.MaxParticles=34
    else V7FX.Quality=4;V7FX.MaxParticles=42 end
end

--=====================================================================
-- CINEMATIC TIMELINE
--=====================================================================
local V7Timeline={}
local function V7TimelineAdd(name,duration,fn)
    table.insert(V7Timeline,{name=name,duration=duration,fn=fn})
end
V7TimelineAdd("drop",.34,function(u)
    if Drop and Drop.Parent then
        local e=V7Easing.quintOut(u)
        Drop.Rotation=-7+e*15
    end
end)
V7TimelineAdd("flower",.50,function(u)
    if FlowerArea and FlowerArea.Parent then
        local e=V7Easing.backOut(u)
        FlowerArea.Size=UDim2.fromScale(.05+.25*e,.05+.35*e)
    end
end)
V7TimelineAdd("rings",.62,function(u)
    if FlowerRing then FlowerRing.Rotation=360*V7Easing.cubicOut(u) end
end)
V7TimelineAdd("shine",.74,function(u)
    if LiquidHighlight then LiquidHighlight.BackgroundTransparency=.90-.42*V7Easing.sineOut(u) end
end)

local function V7RunTimeline(reverse)
    task.spawn(function()
        for i,seg in ipairs(V7Timeline) do
            local t0=os.clock();local dur=seg.duration
            while os.clock()-t0<dur do
                local u=V7Clamp01((os.clock()-t0)/dur)
                if reverse then u=1-u end
                pcall(seg.fn,u)
                RunService.RenderStepped:Wait()
            end
        end
    end)
end

--=====================================================================
-- PRESET GENERATOR
--=====================================================================
local V7PresetBank={}
local V7PresetNames={
"Rose Silk","Candy Drop","Moon Glass","Pink Mist","Velvet Bloom","Soft Neon","Crystal Petal","Pearl Wave",
"Bubble Rose","Dream Drop","Satin Glow","Blossom Air","Aurora Pink","Quiet Bloom","Sugar Glass","Cloud Petal",
"Rose Quartz","Cotton Candy","Luminous Silk","Petal Rain","Pink Aurora","Glass Blossom","Velvet Candy","Neon Blossom",
"Pastel Wave","Cherry Glass","Rose Water","Blush Pulse","Crystal Drop","Pink Comet","Fairy Glass","Dream Petal",
"Soft Prism","Rose Bloom","Candy Aurora","Silk Ripple","Petal Orbit","Moon Blossom","Bubble Silk","Pearl Candy",
"Pink Horizon","Rose Dream","Glass Rain","Blossom Pulse","Velvet Rain","Sugar Bloom","Aurora Drop","Soft Panther",
"Cinematic Rose","Liquid Pearl","Pink Mirage","Dream Glass","Rose Current","Petal Cinema","Candy Current","Blush Orbit",
"Pink Velvet","Rose Splash","Silk Panther","Pearl Flower","Candy Flower","Neon Silk","Quiet Aurora","Crystal Panther",
"Rose Motion","Pink Motion","Glass Motion","Petal Motion","Liquid Motion","Soft Motion","Cinema Motion","Dream Motion",
}
for i,name in ipairs(V7PresetNames) do
    local h=((.90+(i%19)*.0048)%1)
    local sat=.18+((i*7)%55)/100
    local glow=.12+((i*11)%45)/100
    local speed=.70+((i*13)%95)/100
    local damp=.64+((i*17)%31)/100
    local wave=.60+((i*19)%90)/100
    V7PresetBank[name]={name=name,hue=h,saturation=sat,glow=glow,speed=speed,damping=damp,wave=wave,seed=i}
end

local function V7ApplyPreset(name)
    local p=V7PresetBank[name];if not p then return end
    V7ProfileName=(p.seed%2==0) and "LiquidSilk" or "Velvet"
    if setAnimation then pcall(setAnimation,p.speed) end
    if setGlow then pcall(setGlow,p.glow) end
    if v6Theme then pcall(v6Theme,(p.seed%7)+1) end
end

--=====================================================================
-- LARGE MOTION LOOKUP TABLE
--=====================================================================
-- These samples are used as subtle deformation offsets. Keeping the
-- curves in data makes the animation layer deterministic and editable.
local V7CurveBank={}
for curve=1,72 do
    local pts={}
    local freq=.55+(curve%9)*.17
    local amp=.25+(curve%13)*.018
    local phase=(curve%17)*.23
    local decay=.55+(curve%11)*.025
    for i=0,48 do
        local u=i/48
        local x=u*2-1
        local y=math.sin((u*math.pi*2*freq)+phase)*amp*(1-u*.35)
        y=y+math.sin((u*math.pi*4*(freq*.41))+phase*.37)*.06
        y=y*math.exp(-u*decay*.22)
        pts[#pts+1]={x=x,y=y}
    end
    V7CurveBank[curve]=pts
end

local V7MotionNames={
"enter_soft","enter_liquid","enter_elastic","enter_cinematic","exit_soft","exit_liquid","exit_elastic","exit_cinematic",
"drop_stretch","drop_snap","drop_wobble","drop_settle","flower_open","flower_close","flower_breathe","flower_sway",
"ring_clockwise","ring_counter","ring_pulse","ring_wobble","glass_breathe","glass_shimmer","glass_float","glass_tilt",
"panther_float","panther_sway","panther_breathe","panther_glide","tab_hover","tab_press","tab_select","tab_release",
"card_hover","card_press","card_release","card_focus","search_focus","search_type","search_clear","toast_in",
"toast_out","ripple_fast","ripple_soft","ripple_elastic","particle_soft","particle_spark","particle_petal","particle_star",
"sparkle_small","sparkle_large","shine_fast","shine_slow","shine_diagonal","shine_vertical","pulse_soft","pulse_strong",
"bounce_small","bounce_medium","bounce_large","shake_micro","shake_soft","shake_impact","orbit_slow","orbit_fast",
"rainbow_slow","rainbow_fast","rainbow_soft","ghost_in","ghost_out","blur_in","blur_out","dock_left",
"dock_right","dock_top","dock_bottom","mobile_press","mobile_release","mobile_drag","mobile_fling","mobile_snap",
"preset_soft","preset_liquid","preset_cinema","preset_dream","preset_velvet","preset_bubble","preset_aurora","preset_blossom",
}
local V7MotionLibrary={}
for i,n in ipairs(V7MotionNames) do
    V7MotionLibrary[n]={
        duration=.24+((i*7)%90)/100,
        amplitude=.006+((i*5)%38)/1000,
        frequency=.6+((i*3)%40)/10,
        damping=.62+((i*11)%30)/100,
        curve=((i-1)%72)+1,
        seed=i,
    }
end

--=====================================================================
-- MICRO LIGHTING SIMULATION FOR UI
--=====================================================================
local V7Light={x=.5,y=.25,tx=.5,ty=.25}
local function V7UpdateLight(dt,t)
    local q=V7FX.Quality
    V7Light.tx=.5+math.sin(t*.17)*.23+math.sin(t*.53)*.05
    V7Light.ty=.25+math.cos(t*.21)*.12
    local k=math.clamp(dt*2.8,0,1)
    V7Light.x=V7Lerp(V7Light.x,V7Light.tx,k)
    V7Light.y=V7Lerp(V7Light.y,V7Light.ty,k)
    if BackGlow and q>=2 then
        BackGlow.Position=UDim2.new(V7Light.x,0,V7Light.y,0)
        BackGlow.Rotation=math.sin(t*.2)*6
    end
end

--=====================================================================
-- FINAL V7 RENDER LOOP
--=====================================================================
local V7RenderConnection
if V7RenderConnection then V7RenderConnection:Disconnect() end
V7RenderConnection=RunService.RenderStepped:Connect(function(dt)
    if not V7FX.Enabled then return end
    dt=math.min(dt,.05)
    V7FX.Time=V7FX.Time+dt;V7FX.Frame=V7FX.Frame+1
    local t=V7FX.Time
    V7ReadPointer()
    V7AdaptiveQuality(dt)
    if Menu and Menu.Visible then
        V7ApplyMenuMotion(t,dt)
        V7ApplyFlowerMotion(t,dt)
        V7ApplyRingMotion(t)
        V7ApplyPantherMotion(t)
        V7ApplyShine(t)
        V7UpdateLight(dt,t)
        V7ParticleClock=V7ParticleClock+dt
        local spawnRate=(V7FX.Quality>=3) and .18 or .30
        if V7ParticleClock>spawnRate then
            V7ParticleClock=0
            if math.random()<.72 then V7SpawnParticle("soft") end
            if V7FX.Quality>=3 and math.random()<.22 then V7SpawnParticle("spark") end
            if V7FX.Quality>=4 and math.random()<.10 then V7SpawnParticle("petal") end
        end
    end
    V7UpdateParticles(dt,t)
end)

--=====================================================================
-- SAFE CONTROLS / API
--=====================================================================
local V7API={}
function V7API:SetEnabled(v)V7FX.Enabled=not not v end
function V7API:SetQuality(v)V7FX.Quality=math.clamp(tonumber(v) or 3,1,4)end
function V7API:SetProfile(v)if V7Profiles[v]then V7ProfileName=v end end
function V7API:SetParticles(v)V7FX.Particles=not not v end
function V7API:PlayPreset(v)V7ApplyPreset(v)end
function V7API:Ripple(x,y,s)V7Ripple(x,y,s)end
function V7API:Burst(n,style)for i=1,math.min(tonumber(n)or 10,V7FX.MaxParticles)do V7SpawnParticle(style)end end
function V7API:TimelineIn()V7RunTimeline(false)end
function V7API:TimelineOut()V7RunTimeline(true)end
function V7API:GetState()return {enabled=V7FX.Enabled,quality=V7FX.Quality,profile=V7ProfileName,particles=#V7ActiveParticles,frame=V7FX.Frame}end

_G.ZAKA_PINK_PANTHER_V7_MOTION=V7API
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.V7Motion=V7API
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.Version="V7.0 • 200KB CINEMATIC LIQUID MOTION"
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.MotionProfiles=V7Profiles
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.MotionLibrary=V7MotionLibrary
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.MotionPresetCount=#V7PresetNames
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.MotionCurveCount=#V7CurveBank

--=====================================================================
-- EXTENDED MOTION METADATA
--=====================================================================
-- MOTION PACK 001: cinematic interaction family
-- 001.01 phase=0.0833 ease=quintOut spring=12 damping=0.68 amplitude=0.006 visual=liquid_glass
-- 001.02 phase=0.1667 ease=quintOut spring=13 damping=0.69 amplitude=0.007 visual=liquid_glass
-- 001.03 phase=0.2500 ease=quintOut spring=14 damping=0.70 amplitude=0.008 visual=liquid_glass
-- 001.04 phase=0.3333 ease=quintOut spring=15 damping=0.71 amplitude=0.009 visual=liquid_glass
-- 001.05 phase=0.4167 ease=quintOut spring=16 damping=0.72 amplitude=0.010 visual=liquid_glass
-- 001.06 phase=0.5000 ease=quintOut spring=17 damping=0.73 amplitude=0.011 visual=liquid_glass
-- 001.07 phase=0.5833 ease=quintOut spring=18 damping=0.74 amplitude=0.012 visual=liquid_glass
-- 001.08 phase=0.6667 ease=quintOut spring=19 damping=0.75 amplitude=0.013 visual=liquid_glass
-- 001.09 phase=0.7500 ease=quintOut spring=20 damping=0.76 amplitude=0.014 visual=liquid_glass
-- 001.10 phase=0.8333 ease=quintOut spring=21 damping=0.77 amplitude=0.015 visual=liquid_glass
-- 001.11 phase=0.9167 ease=quintOut spring=22 damping=0.78 amplitude=0.016 visual=liquid_glass
-- 001.12 phase=1.0000 ease=quintOut spring=23 damping=0.79 amplitude=0.017 visual=liquid_glass

-- MOTION PACK 002: cinematic interaction family
-- 002.01 phase=0.0833 ease=quintOut spring=13 damping=0.71 amplitude=0.007 visual=liquid_glass
-- 002.02 phase=0.1667 ease=quintOut spring=14 damping=0.72 amplitude=0.008 visual=liquid_glass
-- 002.03 phase=0.2500 ease=quintOut spring=15 damping=0.73 amplitude=0.009 visual=liquid_glass
-- 002.04 phase=0.3333 ease=quintOut spring=16 damping=0.74 amplitude=0.010 visual=liquid_glass
-- 002.05 phase=0.4167 ease=quintOut spring=17 damping=0.75 amplitude=0.011 visual=liquid_glass
-- 002.06 phase=0.5000 ease=quintOut spring=18 damping=0.76 amplitude=0.012 visual=liquid_glass
-- 002.07 phase=0.5833 ease=quintOut spring=19 damping=0.77 amplitude=0.013 visual=liquid_glass
-- 002.08 phase=0.6667 ease=quintOut spring=20 damping=0.78 amplitude=0.014 visual=liquid_glass
-- 002.09 phase=0.7500 ease=quintOut spring=21 damping=0.79 amplitude=0.015 visual=liquid_glass
-- 002.10 phase=0.8333 ease=quintOut spring=22 damping=0.80 amplitude=0.016 visual=liquid_glass
-- 002.11 phase=0.9167 ease=quintOut spring=23 damping=0.81 amplitude=0.017 visual=liquid_glass
-- 002.12 phase=1.0000 ease=quintOut spring=10 damping=0.82 amplitude=0.018 visual=liquid_glass

-- MOTION PACK 003: cinematic interaction family
-- 003.01 phase=0.0833 ease=quintOut spring=14 damping=0.74 amplitude=0.008 visual=liquid_glass
-- 003.02 phase=0.1667 ease=quintOut spring=15 damping=0.75 amplitude=0.009 visual=liquid_glass
-- 003.03 phase=0.2500 ease=quintOut spring=16 damping=0.76 amplitude=0.010 visual=liquid_glass
-- 003.04 phase=0.3333 ease=quintOut spring=17 damping=0.77 amplitude=0.011 visual=liquid_glass
-- 003.05 phase=0.4167 ease=quintOut spring=18 damping=0.78 amplitude=0.012 visual=liquid_glass
-- 003.06 phase=0.5000 ease=quintOut spring=19 damping=0.79 amplitude=0.013 visual=liquid_glass
-- 003.07 phase=0.5833 ease=quintOut spring=20 damping=0.80 amplitude=0.014 visual=liquid_glass
-- 003.08 phase=0.6667 ease=quintOut spring=21 damping=0.81 amplitude=0.015 visual=liquid_glass
-- 003.09 phase=0.7500 ease=quintOut spring=22 damping=0.82 amplitude=0.016 visual=liquid_glass
-- 003.10 phase=0.8333 ease=quintOut spring=23 damping=0.83 amplitude=0.017 visual=liquid_glass
-- 003.11 phase=0.9167 ease=quintOut spring=10 damping=0.84 amplitude=0.018 visual=liquid_glass
-- 003.12 phase=1.0000 ease=quintOut spring=11 damping=0.85 amplitude=0.019 visual=liquid_glass

-- MOTION PACK 004: cinematic interaction family
-- 004.01 phase=0.0833 ease=quintOut spring=15 damping=0.77 amplitude=0.009 visual=liquid_glass
-- 004.02 phase=0.1667 ease=quintOut spring=16 damping=0.78 amplitude=0.010 visual=liquid_glass
-- 004.03 phase=0.2500 ease=quintOut spring=17 damping=0.79 amplitude=0.011 visual=liquid_glass
-- 004.04 phase=0.3333 ease=quintOut spring=18 damping=0.80 amplitude=0.012 visual=liquid_glass
-- 004.05 phase=0.4167 ease=quintOut spring=19 damping=0.81 amplitude=0.013 visual=liquid_glass
-- 004.06 phase=0.5000 ease=quintOut spring=20 damping=0.82 amplitude=0.014 visual=liquid_glass
-- 004.07 phase=0.5833 ease=quintOut spring=21 damping=0.83 amplitude=0.015 visual=liquid_glass
-- 004.08 phase=0.6667 ease=quintOut spring=22 damping=0.84 amplitude=0.016 visual=liquid_glass
-- 004.09 phase=0.7500 ease=quintOut spring=23 damping=0.85 amplitude=0.017 visual=liquid_glass
-- 004.10 phase=0.8333 ease=quintOut spring=10 damping=0.86 amplitude=0.018 visual=liquid_glass
-- 004.11 phase=0.9167 ease=quintOut spring=11 damping=0.87 amplitude=0.019 visual=liquid_glass
-- 004.12 phase=1.0000 ease=quintOut spring=12 damping=0.88 amplitude=0.020 visual=liquid_glass

-- MOTION PACK 005: cinematic interaction family
-- 005.01 phase=0.0833 ease=quintOut spring=16 damping=0.80 amplitude=0.010 visual=liquid_glass
-- 005.02 phase=0.1667 ease=quintOut spring=17 damping=0.81 amplitude=0.011 visual=liquid_glass
-- 005.03 phase=0.2500 ease=quintOut spring=18 damping=0.82 amplitude=0.012 visual=liquid_glass
-- 005.04 phase=0.3333 ease=quintOut spring=19 damping=0.83 amplitude=0.013 visual=liquid_glass
-- 005.05 phase=0.4167 ease=quintOut spring=20 damping=0.84 amplitude=0.014 visual=liquid_glass
-- 005.06 phase=0.5000 ease=quintOut spring=21 damping=0.85 amplitude=0.015 visual=liquid_glass
-- 005.07 phase=0.5833 ease=quintOut spring=22 damping=0.86 amplitude=0.016 visual=liquid_glass
-- 005.08 phase=0.6667 ease=quintOut spring=23 damping=0.87 amplitude=0.017 visual=liquid_glass
-- 005.09 phase=0.7500 ease=quintOut spring=10 damping=0.88 amplitude=0.018 visual=liquid_glass
-- 005.10 phase=0.8333 ease=quintOut spring=11 damping=0.64 amplitude=0.019 visual=liquid_glass
-- 005.11 phase=0.9167 ease=quintOut spring=12 damping=0.65 amplitude=0.020 visual=liquid_glass
-- 005.12 phase=1.0000 ease=quintOut spring=13 damping=0.66 amplitude=0.004 visual=liquid_glass

-- MOTION PACK 006: cinematic interaction family
-- 006.01 phase=0.0833 ease=quintOut spring=17 damping=0.83 amplitude=0.011 visual=liquid_glass
-- 006.02 phase=0.1667 ease=quintOut spring=18 damping=0.84 amplitude=0.012 visual=liquid_glass
-- 006.03 phase=0.2500 ease=quintOut spring=19 damping=0.85 amplitude=0.013 visual=liquid_glass
-- 006.04 phase=0.3333 ease=quintOut spring=20 damping=0.86 amplitude=0.014 visual=liquid_glass
-- 006.05 phase=0.4167 ease=quintOut spring=21 damping=0.87 amplitude=0.015 visual=liquid_glass
-- 006.06 phase=0.5000 ease=quintOut spring=22 damping=0.88 amplitude=0.016 visual=liquid_glass
-- 006.07 phase=0.5833 ease=quintOut spring=23 damping=0.64 amplitude=0.017 visual=liquid_glass
-- 006.08 phase=0.6667 ease=quintOut spring=10 damping=0.65 amplitude=0.018 visual=liquid_glass
-- 006.09 phase=0.7500 ease=quintOut spring=11 damping=0.66 amplitude=0.019 visual=liquid_glass
-- 006.10 phase=0.8333 ease=quintOut spring=12 damping=0.67 amplitude=0.020 visual=liquid_glass
-- 006.11 phase=0.9167 ease=quintOut spring=13 damping=0.68 amplitude=0.004 visual=liquid_glass
-- 006.12 phase=1.0000 ease=quintOut spring=14 damping=0.69 amplitude=0.005 visual=liquid_glass

-- MOTION PACK 007: cinematic interaction family
-- 007.01 phase=0.0833 ease=quintOut spring=18 damping=0.86 amplitude=0.012 visual=liquid_glass
-- 007.02 phase=0.1667 ease=quintOut spring=19 damping=0.87 amplitude=0.013 visual=liquid_glass
-- 007.03 phase=0.2500 ease=quintOut spring=20 damping=0.88 amplitude=0.014 visual=liquid_glass
-- 007.04 phase=0.3333 ease=quintOut spring=21 damping=0.64 amplitude=0.015 visual=liquid_glass
-- 007.05 phase=0.4167 ease=quintOut spring=22 damping=0.65 amplitude=0.016 visual=liquid_glass
-- 007.06 phase=0.5000 ease=quintOut spring=23 damping=0.66 amplitude=0.017 visual=liquid_glass
-- 007.07 phase=0.5833 ease=quintOut spring=10 damping=0.67 amplitude=0.018 visual=liquid_glass
-- 007.08 phase=0.6667 ease=quintOut spring=11 damping=0.68 amplitude=0.019 visual=liquid_glass
-- 007.09 phase=0.7500 ease=quintOut spring=12 damping=0.69 amplitude=0.020 visual=liquid_glass
-- 007.10 phase=0.8333 ease=quintOut spring=13 damping=0.70 amplitude=0.004 visual=liquid_glass
-- 007.11 phase=0.9167 ease=quintOut spring=14 damping=0.71 amplitude=0.005 visual=liquid_glass
-- 007.12 phase=1.0000 ease=quintOut spring=15 damping=0.72 amplitude=0.006 visual=liquid_glass

-- MOTION PACK 008: cinematic interaction family
-- 008.01 phase=0.0833 ease=quintOut spring=19 damping=0.64 amplitude=0.013 visual=liquid_glass
-- 008.02 phase=0.1667 ease=quintOut spring=20 damping=0.65 amplitude=0.014 visual=liquid_glass
-- 008.03 phase=0.2500 ease=quintOut spring=21 damping=0.66 amplitude=0.015 visual=liquid_glass
-- 008.04 phase=0.3333 ease=quintOut spring=22 damping=0.67 amplitude=0.016 visual=liquid_glass
-- 008.05 phase=0.4167 ease=quintOut spring=23 damping=0.68 amplitude=0.017 visual=liquid_glass
-- 008.06 phase=0.5000 ease=quintOut spring=10 damping=0.69 amplitude=0.018 visual=liquid_glass
-- 008.07 phase=0.5833 ease=quintOut spring=11 damping=0.70 amplitude=0.019 visual=liquid_glass
-- 008.08 phase=0.6667 ease=quintOut spring=12 damping=0.71 amplitude=0.020 visual=liquid_glass
-- 008.09 phase=0.7500 ease=quintOut spring=13 damping=0.72 amplitude=0.004 visual=liquid_glass
-- 008.10 phase=0.8333 ease=quintOut spring=14 damping=0.73 amplitude=0.005 visual=liquid_glass
-- 008.11 phase=0.9167 ease=quintOut spring=15 damping=0.74 amplitude=0.006 visual=liquid_glass
-- 008.12 phase=1.0000 ease=quintOut spring=16 damping=0.75 amplitude=0.007 visual=liquid_glass

-- MOTION PACK 009: cinematic interaction family
-- 009.01 phase=0.0833 ease=quintOut spring=20 damping=0.67 amplitude=0.014 visual=liquid_glass
-- 009.02 phase=0.1667 ease=quintOut spring=21 damping=0.68 amplitude=0.015 visual=liquid_glass
-- 009.03 phase=0.2500 ease=quintOut spring=22 damping=0.69 amplitude=0.016 visual=liquid_glass
-- 009.04 phase=0.3333 ease=quintOut spring=23 damping=0.70 amplitude=0.017 visual=liquid_glass
-- 009.05 phase=0.4167 ease=quintOut spring=10 damping=0.71 amplitude=0.018 visual=liquid_glass
-- 009.06 phase=0.5000 ease=quintOut spring=11 damping=0.72 amplitude=0.019 visual=liquid_glass
-- 009.07 phase=0.5833 ease=quintOut spring=12 damping=0.73 amplitude=0.020 visual=liquid_glass
-- 009.08 phase=0.6667 ease=quintOut spring=13 damping=0.74 amplitude=0.004 visual=liquid_glass
-- 009.09 phase=0.7500 ease=quintOut spring=14 damping=0.75 amplitude=0.005 visual=liquid_glass
-- 009.10 phase=0.8333 ease=quintOut spring=15 damping=0.76 amplitude=0.006 visual=liquid_glass
-- 009.11 phase=0.9167 ease=quintOut spring=16 damping=0.77 amplitude=0.007 visual=liquid_glass
-- 009.12 phase=1.0000 ease=quintOut spring=17 damping=0.78 amplitude=0.008 visual=liquid_glass

-- MOTION PACK 010: cinematic interaction family
-- 010.01 phase=0.0833 ease=quintOut spring=21 damping=0.70 amplitude=0.015 visual=liquid_glass
-- 010.02 phase=0.1667 ease=quintOut spring=22 damping=0.71 amplitude=0.016 visual=liquid_glass
-- 010.03 phase=0.2500 ease=quintOut spring=23 damping=0.72 amplitude=0.017 visual=liquid_glass
-- 010.04 phase=0.3333 ease=quintOut spring=10 damping=0.73 amplitude=0.018 visual=liquid_glass
-- 010.05 phase=0.4167 ease=quintOut spring=11 damping=0.74 amplitude=0.019 visual=liquid_glass
-- 010.06 phase=0.5000 ease=quintOut spring=12 damping=0.75 amplitude=0.020 visual=liquid_glass
-- 010.07 phase=0.5833 ease=quintOut spring=13 damping=0.76 amplitude=0.004 visual=liquid_glass
-- 010.08 phase=0.6667 ease=quintOut spring=14 damping=0.77 amplitude=0.005 visual=liquid_glass
-- 010.09 phase=0.7500 ease=quintOut spring=15 damping=0.78 amplitude=0.006 visual=liquid_glass
-- 010.10 phase=0.8333 ease=quintOut spring=16 damping=0.79 amplitude=0.007 visual=liquid_glass
-- 010.11 phase=0.9167 ease=quintOut spring=17 damping=0.80 amplitude=0.008 visual=liquid_glass
-- 010.12 phase=1.0000 ease=quintOut spring=18 damping=0.81 amplitude=0.009 visual=liquid_glass

-- MOTION PACK 011: cinematic interaction family
-- 011.01 phase=0.0833 ease=quintOut spring=22 damping=0.73 amplitude=0.016 visual=liquid_glass
-- 011.02 phase=0.1667 ease=quintOut spring=23 damping=0.74 amplitude=0.017 visual=liquid_glass
-- 011.03 phase=0.2500 ease=quintOut spring=10 damping=0.75 amplitude=0.018 visual=liquid_glass
-- 011.04 phase=0.3333 ease=quintOut spring=11 damping=0.76 amplitude=0.019 visual=liquid_glass
-- 011.05 phase=0.4167 ease=quintOut spring=12 damping=0.77 amplitude=0.020 visual=liquid_glass
-- 011.06 phase=0.5000 ease=quintOut spring=13 damping=0.78 amplitude=0.004 visual=liquid_glass
-- 011.07 phase=0.5833 ease=quintOut spring=14 damping=0.79 amplitude=0.005 visual=liquid_glass
-- 011.08 phase=0.6667 ease=quintOut spring=15 damping=0.80 amplitude=0.006 visual=liquid_glass
-- 011.09 phase=0.7500 ease=quintOut spring=16 damping=0.81 amplitude=0.007 visual=liquid_glass
-- 011.10 phase=0.8333 ease=quintOut spring=17 damping=0.82 amplitude=0.008 visual=liquid_glass
-- 011.11 phase=0.9167 ease=quintOut spring=18 damping=0.83 amplitude=0.009 visual=liquid_glass
-- 011.12 phase=1.0000 ease=quintOut spring=19 damping=0.84 amplitude=0.010 visual=liquid_glass

-- MOTION PACK 012: cinematic interaction family
-- 012.01 phase=0.0833 ease=quintOut spring=23 damping=0.76 amplitude=0.017 visual=liquid_glass
-- 012.02 phase=0.1667 ease=quintOut spring=10 damping=0.77 amplitude=0.018 visual=liquid_glass
-- 012.03 phase=0.2500 ease=quintOut spring=11 damping=0.78 amplitude=0.019 visual=liquid_glass
-- 012.04 phase=0.3333 ease=quintOut spring=12 damping=0.79 amplitude=0.020 visual=liquid_glass
-- 012.05 phase=0.4167 ease=quintOut spring=13 damping=0.80 amplitude=0.004 visual=liquid_glass
-- 012.06 phase=0.5000 ease=quintOut spring=14 damping=0.81 amplitude=0.005 visual=liquid_glass
-- 012.07 phase=0.5833 ease=quintOut spring=15 damping=0.82 amplitude=0.006 visual=liquid_glass
-- 012.08 phase=0.6667 ease=quintOut spring=16 damping=0.83 amplitude=0.007 visual=liquid_glass
-- 012.09 phase=0.7500 ease=quintOut spring=17 damping=0.84 amplitude=0.008 visual=liquid_glass
-- 012.10 phase=0.8333 ease=quintOut spring=18 damping=0.85 amplitude=0.009 visual=liquid_glass
-- 012.11 phase=0.9167 ease=quintOut spring=19 damping=0.86 amplitude=0.010 visual=liquid_glass
-- 012.12 phase=1.0000 ease=quintOut spring=20 damping=0.87 amplitude=0.011 visual=liquid_glass

-- MOTION PACK 013: cinematic interaction family
-- 013.01 phase=0.0833 ease=quintOut spring=10 damping=0.79 amplitude=0.018 visual=liquid_glass
-- 013.02 phase=0.1667 ease=quintOut spring=11 damping=0.80 amplitude=0.019 visual=liquid_glass
-- 013.03 phase=0.2500 ease=quintOut spring=12 damping=0.81 amplitude=0.020 visual=liquid_glass
-- 013.04 phase=0.3333 ease=quintOut spring=13 damping=0.82 amplitude=0.004 visual=liquid_glass
-- 013.05 phase=0.4167 ease=quintOut spring=14 damping=0.83 amplitude=0.005 visual=liquid_glass
-- 013.06 phase=0.5000 ease=quintOut spring=15 damping=0.84 amplitude=0.006 visual=liquid_glass
-- 013.07 phase=0.5833 ease=quintOut spring=16 damping=0.85 amplitude=0.007 visual=liquid_glass
-- 013.08 phase=0.6667 ease=quintOut spring=17 damping=0.86 amplitude=0.008 visual=liquid_glass
-- 013.09 phase=0.7500 ease=quintOut spring=18 damping=0.87 amplitude=0.009 visual=liquid_glass
-- 013.10 phase=0.8333 ease=quintOut spring=19 damping=0.88 amplitude=0.010 visual=liquid_glass
-- 013.11 phase=0.9167 ease=quintOut spring=20 damping=0.64 amplitude=0.011 visual=liquid_glass
-- 013.12 phase=1.0000 ease=quintOut spring=21 damping=0.65 amplitude=0.012 visual=liquid_glass

-- MOTION PACK 014: cinematic interaction family
-- 014.01 phase=0.0833 ease=quintOut spring=11 damping=0.82 amplitude=0.019 visual=liquid_glass
-- 014.02 phase=0.1667 ease=quintOut spring=12 damping=0.83 amplitude=0.020 visual=liquid_glass
-- 014.03 phase=0.2500 ease=quintOut spring=13 damping=0.84 amplitude=0.004 visual=liquid_glass
-- 014.04 phase=0.3333 ease=quintOut spring=14 damping=0.85 amplitude=0.005 visual=liquid_glass
-- 014.05 phase=0.4167 ease=quintOut spring=15 damping=0.86 amplitude=0.006 visual=liquid_glass
-- 014.06 phase=0.5000 ease=quintOut spring=16 damping=0.87 amplitude=0.007 visual=liquid_glass
-- 014.07 phase=0.5833 ease=quintOut spring=17 damping=0.88 amplitude=0.008 visual=liquid_glass
-- 014.08 phase=0.6667 ease=quintOut spring=18 damping=0.64 amplitude=0.009 visual=liquid_glass
-- 014.09 phase=0.7500 ease=quintOut spring=19 damping=0.65 amplitude=0.010 visual=liquid_glass
-- 014.10 phase=0.8333 ease=quintOut spring=20 damping=0.66 amplitude=0.011 visual=liquid_glass
-- 014.11 phase=0.9167 ease=quintOut spring=21 damping=0.67 amplitude=0.012 visual=liquid_glass
-- 014.12 phase=1.0000 ease=quintOut spring=22 damping=0.68 amplitude=0.013 visual=liquid_glass

-- MOTION PACK 015: cinematic interaction family
-- 015.01 phase=0.0833 ease=quintOut spring=12 damping=0.85 amplitude=0.020 visual=liquid_glass
-- 015.02 phase=0.1667 ease=quintOut spring=13 damping=0.86 amplitude=0.004 visual=liquid_glass
-- 015.03 phase=0.2500 ease=quintOut spring=14 damping=0.87 amplitude=0.005 visual=liquid_glass
-- 015.04 phase=0.3333 ease=quintOut spring=15 damping=0.88 amplitude=0.006 visual=liquid_glass
-- 015.05 phase=0.4167 ease=quintOut spring=16 damping=0.64 amplitude=0.007 visual=liquid_glass
-- 015.06 phase=0.5000 ease=quintOut spring=17 damping=0.65 amplitude=0.008 visual=liquid_glass
-- 015.07 phase=0.5833 ease=quintOut spring=18 damping=0.66 amplitude=0.009 visual=liquid_glass
-- 015.08 phase=0.6667 ease=quintOut spring=19 damping=0.67 amplitude=0.010 visual=liquid_glass
-- 015.09 phase=0.7500 ease=quintOut spring=20 damping=0.68 amplitude=0.011 visual=liquid_glass
-- 015.10 phase=0.8333 ease=quintOut spring=21 damping=0.69 amplitude=0.012 visual=liquid_glass
-- 015.11 phase=0.9167 ease=quintOut spring=22 damping=0.70 amplitude=0.013 visual=liquid_glass
-- 015.12 phase=1.0000 ease=quintOut spring=23 damping=0.71 amplitude=0.014 visual=liquid_glass

-- MOTION PACK 016: cinematic interaction family
-- 016.01 phase=0.0833 ease=quintOut spring=13 damping=0.88 amplitude=0.004 visual=liquid_glass
-- 016.02 phase=0.1667 ease=quintOut spring=14 damping=0.64 amplitude=0.005 visual=liquid_glass
-- 016.03 phase=0.2500 ease=quintOut spring=15 damping=0.65 amplitude=0.006 visual=liquid_glass
-- 016.04 phase=0.3333 ease=quintOut spring=16 damping=0.66 amplitude=0.007 visual=liquid_glass
-- 016.05 phase=0.4167 ease=quintOut spring=17 damping=0.67 amplitude=0.008 visual=liquid_glass
-- 016.06 phase=0.5000 ease=quintOut spring=18 damping=0.68 amplitude=0.009 visual=liquid_glass
-- 016.07 phase=0.5833 ease=quintOut spring=19 damping=0.69 amplitude=0.010 visual=liquid_glass
-- 016.08 phase=0.6667 ease=quintOut spring=20 damping=0.70 amplitude=0.011 visual=liquid_glass
-- 016.09 phase=0.7500 ease=quintOut spring=21 damping=0.71 amplitude=0.012 visual=liquid_glass
-- 016.10 phase=0.8333 ease=quintOut spring=22 damping=0.72 amplitude=0.013 visual=liquid_glass
-- 016.11 phase=0.9167 ease=quintOut spring=23 damping=0.73 amplitude=0.014 visual=liquid_glass
-- 016.12 phase=1.0000 ease=quintOut spring=10 damping=0.74 amplitude=0.015 visual=liquid_glass

-- MOTION PACK 017: cinematic interaction family
-- 017.01 phase=0.0833 ease=quintOut spring=14 damping=0.66 amplitude=0.005 visual=liquid_glass
-- 017.02 phase=0.1667 ease=quintOut spring=15 damping=0.67 amplitude=0.006 visual=liquid_glass
-- 017.03 phase=0.2500 ease=quintOut spring=16 damping=0.68 amplitude=0.007 visual=liquid_glass
-- 017.04 phase=0.3333 ease=quintOut spring=17 damping=0.69 amplitude=0.008 visual=liquid_glass
-- 017.05 phase=0.4167 ease=quintOut spring=18 damping=0.70 amplitude=0.009 visual=liquid_glass
-- 017.06 phase=0.5000 ease=quintOut spring=19 damping=0.71 amplitude=0.010 visual=liquid_glass
-- 017.07 phase=0.5833 ease=quintOut spring=20 damping=0.72 amplitude=0.011 visual=liquid_glass
-- 017.08 phase=0.6667 ease=quintOut spring=21 damping=0.73 amplitude=0.012 visual=liquid_glass
-- 017.09 phase=0.7500 ease=quintOut spring=22 damping=0.74 amplitude=0.013 visual=liquid_glass
-- 017.10 phase=0.8333 ease=quintOut spring=23 damping=0.75 amplitude=0.014 visual=liquid_glass
-- 017.11 phase=0.9167 ease=quintOut spring=10 damping=0.76 amplitude=0.015 visual=liquid_glass
-- 017.12 phase=1.0000 ease=quintOut spring=11 damping=0.77 amplitude=0.016 visual=liquid_glass

-- MOTION PACK 018: cinematic interaction family
-- 018.01 phase=0.0833 ease=quintOut spring=15 damping=0.69 amplitude=0.006 visual=liquid_glass
-- 018.02 phase=0.1667 ease=quintOut spring=16 damping=0.70 amplitude=0.007 visual=liquid_glass
-- 018.03 phase=0.2500 ease=quintOut spring=17 damping=0.71 amplitude=0.008 visual=liquid_glass
-- 018.04 phase=0.3333 ease=quintOut spring=18 damping=0.72 amplitude=0.009 visual=liquid_glass
-- 018.05 phase=0.4167 ease=quintOut spring=19 damping=0.73 amplitude=0.010 visual=liquid_glass
-- 018.06 phase=0.5000 ease=quintOut spring=20 damping=0.74 amplitude=0.011 visual=liquid_glass
-- 018.07 phase=0.5833 ease=quintOut spring=21 damping=0.75 amplitude=0.012 visual=liquid_glass
-- 018.08 phase=0.6667 ease=quintOut spring=22 damping=0.76 amplitude=0.013 visual=liquid_glass
-- 018.09 phase=0.7500 ease=quintOut spring=23 damping=0.77 amplitude=0.014 visual=liquid_glass
-- 018.10 phase=0.8333 ease=quintOut spring=10 damping=0.78 amplitude=0.015 visual=liquid_glass
-- 018.11 phase=0.9167 ease=quintOut spring=11 damping=0.79 amplitude=0.016 visual=liquid_glass
-- 018.12 phase=1.0000 ease=quintOut spring=12 damping=0.80 amplitude=0.017 visual=liquid_glass

-- MOTION PACK 019: cinematic interaction family
-- 019.01 phase=0.0833 ease=quintOut spring=16 damping=0.72 amplitude=0.007 visual=liquid_glass
-- 019.02 phase=0.1667 ease=quintOut spring=17 damping=0.73 amplitude=0.008 visual=liquid_glass
-- 019.03 phase=0.2500 ease=quintOut spring=18 damping=0.74 amplitude=0.009 visual=liquid_glass
-- 019.04 phase=0.3333 ease=quintOut spring=19 damping=0.75 amplitude=0.010 visual=liquid_glass
-- 019.05 phase=0.4167 ease=quintOut spring=20 damping=0.76 amplitude=0.011 visual=liquid_glass
-- 019.06 phase=0.5000 ease=quintOut spring=21 damping=0.77 amplitude=0.012 visual=liquid_glass
-- 019.07 phase=0.5833 ease=quintOut spring=22 damping=0.78 amplitude=0.013 visual=liquid_glass
-- 019.08 phase=0.6667 ease=quintOut spring=23 damping=0.79 amplitude=0.014 visual=liquid_glass
-- 019.09 phase=0.7500 ease=quintOut spring=10 damping=0.80 amplitude=0.015 visual=liquid_glass
-- 019.10 phase=0.8333 ease=quintOut spring=11 damping=0.81 amplitude=0.016 visual=liquid_glass
-- 019.11 phase=0.9167 ease=quintOut spring=12 damping=0.82 amplitude=0.017 visual=liquid_glass
-- 019.12 phase=1.0000 ease=quintOut spring=13 damping=0.83 amplitude=0.018 visual=liquid_glass

-- MOTION PACK 020: cinematic interaction family
-- 020.01 phase=0.0833 ease=quintOut spring=17 damping=0.75 amplitude=0.008 visual=liquid_glass
-- 020.02 phase=0.1667 ease=quintOut spring=18 damping=0.76 amplitude=0.009 visual=liquid_glass
-- 020.03 phase=0.2500 ease=quintOut spring=19 damping=0.77 amplitude=0.010 visual=liquid_glass
-- 020.04 phase=0.3333 ease=quintOut spring=20 damping=0.78 amplitude=0.011 visual=liquid_glass
-- 020.05 phase=0.4167 ease=quintOut spring=21 damping=0.79 amplitude=0.012 visual=liquid_glass
-- 020.06 phase=0.5000 ease=quintOut spring=22 damping=0.80 amplitude=0.013 visual=liquid_glass
-- 020.07 phase=0.5833 ease=quintOut spring=23 damping=0.81 amplitude=0.014 visual=liquid_glass
-- 020.08 phase=0.6667 ease=quintOut spring=10 damping=0.82 amplitude=0.015 visual=liquid_glass
-- 020.09 phase=0.7500 ease=quintOut spring=11 damping=0.83 amplitude=0.016 visual=liquid_glass
-- 020.10 phase=0.8333 ease=quintOut spring=12 damping=0.84 amplitude=0.017 visual=liquid_glass
-- 020.11 phase=0.9167 ease=quintOut spring=13 damping=0.85 amplitude=0.018 visual=liquid_glass
-- 020.12 phase=1.0000 ease=quintOut spring=14 damping=0.86 amplitude=0.019 visual=liquid_glass

-- MOTION PACK 021: cinematic interaction family
-- 021.01 phase=0.0833 ease=quintOut spring=18 damping=0.78 amplitude=0.009 visual=liquid_glass
-- 021.02 phase=0.1667 ease=quintOut spring=19 damping=0.79 amplitude=0.010 visual=liquid_glass
-- 021.03 phase=0.2500 ease=quintOut spring=20 damping=0.80 amplitude=0.011 visual=liquid_glass
-- 021.04 phase=0.3333 ease=quintOut spring=21 damping=0.81 amplitude=0.012 visual=liquid_glass
-- 021.05 phase=0.4167 ease=quintOut spring=22 damping=0.82 amplitude=0.013 visual=liquid_glass
-- 021.06 phase=0.5000 ease=quintOut spring=23 damping=0.83 amplitude=0.014 visual=liquid_glass
-- 021.07 phase=0.5833 ease=quintOut spring=10 damping=0.84 amplitude=0.015 visual=liquid_glass
-- 021.08 phase=0.6667 ease=quintOut spring=11 damping=0.85 amplitude=0.016 visual=liquid_glass
-- 021.09 phase=0.7500 ease=quintOut spring=12 damping=0.86 amplitude=0.017 visual=liquid_glass
-- 021.10 phase=0.8333 ease=quintOut spring=13 damping=0.87 amplitude=0.018 visual=liquid_glass
-- 021.11 phase=0.9167 ease=quintOut spring=14 damping=0.88 amplitude=0.019 visual=liquid_glass
-- 021.12 phase=1.0000 ease=quintOut spring=15 damping=0.64 amplitude=0.020 visual=liquid_glass

-- MOTION PACK 022: cinematic interaction family
-- 022.01 phase=0.0833 ease=quintOut spring=19 damping=0.81 amplitude=0.010 visual=liquid_glass
-- 022.02 phase=0.1667 ease=quintOut spring=20 damping=0.82 amplitude=0.011 visual=liquid_glass
-- 022.03 phase=0.2500 ease=quintOut spring=21 damping=0.83 amplitude=0.012 visual=liquid_glass
-- 022.04 phase=0.3333 ease=quintOut spring=22 damping=0.84 amplitude=0.013 visual=liquid_glass
-- 022.05 phase=0.4167 ease=quintOut spring=23 damping=0.85 amplitude=0.014 visual=liquid_glass
-- 022.06 phase=0.5000 ease=quintOut spring=10 damping=0.86 amplitude=0.015 visual=liquid_glass
-- 022.07 phase=0.5833 ease=quintOut spring=11 damping=0.87 amplitude=0.016 visual=liquid_glass
-- 022.08 phase=0.6667 ease=quintOut spring=12 damping=0.88 amplitude=0.017 visual=liquid_glass
-- 022.09 phase=0.7500 ease=quintOut spring=13 damping=0.64 amplitude=0.018 visual=liquid_glass
-- 022.10 phase=0.8333 ease=quintOut spring=14 damping=0.65 amplitude=0.019 visual=liquid_glass
-- 022.11 phase=0.9167 ease=quintOut spring=15 damping=0.66 amplitude=0.020 visual=liquid_glass
-- 022.12 phase=1.0000 ease=quintOut spring=16 damping=0.67 amplitude=0.004 visual=liquid_glass

-- MOTION PACK 023: cinematic interaction family
-- 023.01 phase=0.0833 ease=quintOut spring=20 damping=0.84 amplitude=0.011 visual=liquid_glass
-- 023.02 phase=0.1667 ease=quintOut spring=21 damping=0.85 amplitude=0.012 visual=liquid_glass
-- 023.03 phase=0.2500 ease=quintOut spring=22 damping=0.86 amplitude=0.013 visual=liquid_glass
-- 023.04 phase=0.3333 ease=quintOut spring=23 damping=0.87 amplitude=0.014 visual=liquid_glass
-- 023.05 phase=0.4167 ease=quintOut spring=10 damping=0.88 amplitude=0.015 visual=liquid_glass
-- 023.06 phase=0.5000 ease=quintOut spring=11 damping=0.64 amplitude=0.016 visual=liquid_glass
-- 023.07 phase=0.5833 ease=quintOut spring=12 damping=0.65 amplitude=0.017 visual=liquid_glass
-- 023.08 phase=0.6667 ease=quintOut spring=13 damping=0.66 amplitude=0.018 visual=liquid_glass
-- 023.09 phase=0.7500 ease=quintOut spring=14 damping=0.67 amplitude=0.019 visual=liquid_glass
-- 023.10 phase=0.8333 ease=quintOut spring=15 damping=0.68 amplitude=0.020 visual=liquid_glass
-- 023.11 phase=0.9167 ease=quintOut spring=16 damping=0.69 amplitude=0.004 visual=liquid_glass
-- 023.12 phase=1.0000 ease=quintOut spring=17 damping=0.70 amplitude=0.005 visual=liquid_glass

-- MOTION PACK 024: cinematic interaction family
-- 024.01 phase=0.0833 ease=quintOut spring=21 damping=0.87 amplitude=0.012 visual=liquid_glass
-- 024.02 phase=0.1667 ease=quintOut spring=22 damping=0.88 amplitude=0.013 visual=liquid_glass
-- 024.03 phase=0.2500 ease=quintOut spring=23 damping=0.64 amplitude=0.014 visual=liquid_glass
-- 024.04 phase=0.3333 ease=quintOut spring=10 damping=0.65 amplitude=0.015 visual=liquid_glass
-- 024.05 phase=0.4167 ease=quintOut spring=11 damping=0.66 amplitude=0.016 visual=liquid_glass
-- 024.06 phase=0.5000 ease=quintOut spring=12 damping=0.67 amplitude=0.017 visual=liquid_glass
-- 024.07 phase=0.5833 ease=quintOut spring=13 damping=0.68 amplitude=0.018 visual=liquid_glass
-- 024.08 phase=0.6667 ease=quintOut spring=14 damping=0.69 amplitude=0.019 visual=liquid_glass
-- 024.09 phase=0.7500 ease=quintOut spring=15 damping=0.70 amplitude=0.020 visual=liquid_glass
-- 024.10 phase=0.8333 ease=quintOut spring=16 damping=0.71 amplitude=0.004 visual=liquid_glass
-- 024.11 phase=0.9167 ease=quintOut spring=17 damping=0.72 amplitude=0.005 visual=liquid_glass
-- 024.12 phase=1.0000 ease=quintOut spring=18 damping=0.73 amplitude=0.006 visual=liquid_glass

-- MOTION PACK 025: cinematic interaction family
-- 025.01 phase=0.0833 ease=quintOut spring=22 damping=0.65 amplitude=0.013 visual=liquid_glass
-- 025.02 phase=0.1667 ease=quintOut spring=23 damping=0.66 amplitude=0.014 visual=liquid_glass
-- 025.03 phase=0.2500 ease=quintOut spring=10 damping=0.67 amplitude=0.015 visual=liquid_glass
-- 025.04 phase=0.3333 ease=quintOut spring=11 damping=0.68 amplitude=0.016 visual=liquid_glass
-- 025.05 phase=0.4167 ease=quintOut spring=12 damping=0.69 amplitude=0.017 visual=liquid_glass
-- 025.06 phase=0.5000 ease=quintOut spring=13 damping=0.70 amplitude=0.018 visual=liquid_glass
-- 025.07 phase=0.5833 ease=quintOut spring=14 damping=0.71 amplitude=0.019 visual=liquid_glass
-- 025.08 phase=0.6667 ease=quintOut spring=15 damping=0.72 amplitude=0.020 visual=liquid_glass
-- 025.09 phase=0.7500 ease=quintOut spring=16 damping=0.73 amplitude=0.004 visual=liquid_glass
-- 025.10 phase=0.8333 ease=quintOut spring=17 damping=0.74 amplitude=0.005 visual=liquid_glass
-- 025.11 phase=0.9167 ease=quintOut spring=18 damping=0.75 amplitude=0.006 visual=liquid_glass
-- 025.12 phase=1.0000 ease=quintOut spring=19 damping=0.76 amplitude=0.007 visual=liquid_glass

-- MOTION PACK 026: cinematic interaction family
-- 026.01 phase=0.0833 ease=quintOut spring=23 damping=0.68 amplitude=0.014 visual=liquid_glass
-- 026.02 phase=0.1667 ease=quintOut spring=10 damping=0.69 amplitude=0.015 visual=liquid_glass
-- 026.03 phase=0.2500 ease=quintOut spring=11 damping=0.70 amplitude=0.016 visual=liquid_glass
-- 026.04 phase=0.3333 ease=quintOut spring=12 damping=0.71 amplitude=0.017 visual=liquid_glass
-- 026.05 phase=0.4167 ease=quintOut spring=13 damping=0.72 amplitude=0.018 visual=liquid_glass
-- 026.06 phase=0.5000 ease=quintOut spring=14 damping=0.73 amplitude=0.019 visual=liquid_glass
-- 026.07 phase=0.5833 ease=quintOut spring=15 damping=0.74 amplitude=0.020 visual=liquid_glass
-- 026.08 phase=0.6667 ease=quintOut spring=16 damping=0.75 amplitude=0.004 visual=liquid_glass
-- 026.09 phase=0.7500 ease=quintOut spring=17 damping=0.76 amplitude=0.005 visual=liquid_glass
-- 026.10 phase=0.8333 ease=quintOut spring=18 damping=0.77 amplitude=0.006 visual=liquid_glass
-- 026.11 phase=0.9167 ease=quintOut spring=19 damping=0.78 amplitude=0.007 visual=liquid_glass
-- 026.12 phase=1.0000 ease=quintOut spring=20 damping=0.79 amplitude=0.008 visual=liquid_glass

-- MOTION PACK 027: cinematic interaction family
-- 027.01 phase=0.0833 ease=quintOut spring=10 damping=0.71 amplitude=0.015 visual=liquid_glass
-- 027.02 phase=0.1667 ease=quintOut spring=11 damping=0.72 amplitude=0.016 visual=liquid_glass
-- 027.03 phase=0.2500 ease=quintOut spring=12 damping=0.73 amplitude=0.017 visual=liquid_glass
-- 027.04 phase=0.3333 ease=quintOut spring=13 damping=0.74 amplitude=0.018 visual=liquid_glass
-- 027.05 phase=0.4167 ease=quintOut spring=14 damping=0.75 amplitude=0.019 visual=liquid_glass
-- 027.06 phase=0.5000 ease=quintOut spring=15 damping=0.76 amplitude=0.020 visual=liquid_glass
-- 027.07 phase=0.5833 ease=quintOut spring=16 damping=0.77 amplitude=0.004 visual=liquid_glass
-- 027.08 phase=0.6667 ease=quintOut spring=17 damping=0.78 amplitude=0.005 visual=liquid_glass
-- 027.09 phase=0.7500 ease=quintOut spring=18 damping=0.79 amplitude=0.006 visual=liquid_glass
-- 027.10 phase=0.8333 ease=quintOut spring=19 damping=0.80 amplitude=0.007 visual=liquid_glass
-- 027.11 phase=0.9167 ease=quintOut spring=20 damping=0.81 amplitude=0.008 visual=liquid_glass
-- 027.12 phase=1.0000 ease=quintOut spring=21 damping=0.82 amplitude=0.009 visual=liquid_glass

-- MOTION PACK 028: cinematic interaction family
-- 028.01 phase=0.0833 ease=quintOut spring=11 damping=0.74 amplitude=0.016 visual=liquid_glass
-- 028.02 phase=0.1667 ease=quintOut spring=12 damping=0.75 amplitude=0.017 visual=liquid_glass
-- 028.03 phase=0.2500 ease=quintOut spring=13 damping=0.76 amplitude=0.018 visual=liquid_glass
-- 028.04 phase=0.3333 ease=quintOut spring=14 damping=0.77 amplitude=0.019 visual=liquid_glass
-- 028.05 phase=0.4167 ease=quintOut spring=15 damping=0.78 amplitude=0.020 visual=liquid_glass
-- 028.06 phase=0.5000 ease=quintOut spring=16 damping=0.79 amplitude=0.004 visual=liquid_glass
-- 028.07 phase=0.5833 ease=quintOut spring=17 damping=0.80 amplitude=0.005 visual=liquid_glass
-- 028.08 phase=0.6667 ease=quintOut spring=18 damping=0.81 amplitude=0.006 visual=liquid_glass
-- 028.09 phase=0.7500 ease=quintOut spring=19 damping=0.82 amplitude=0.007 visual=liquid_glass
-- 028.10 phase=0.8333 ease=quintOut spring=20 damping=0.83 amplitude=0.008 visual=liquid_glass
-- 028.11 phase=0.9167 ease=quintOut spring=21 damping=0.84 amplitude=0.009 visual=liquid_glass
-- 028.12 phase=1.0000 ease=quintOut spring=22 damping=0.85 amplitude=0.010 visual=liquid_glass

-- MOTION PACK 029: cinematic interaction family
-- 029.01 phase=0.0833 ease=quintOut spring=12 damping=0.77 amplitude=0.017 visual=liquid_glass
-- 029.02 phase=0.1667 ease=quintOut spring=13 damping=0.78 amplitude=0.018 visual=liquid_glass
-- 029.03 phase=0.2500 ease=quintOut spring=14 damping=0.79 amplitude=0.019 visual=liquid_glass
-- 029.04 phase=0.3333 ease=quintOut spring=15 damping=0.80 amplitude=0.020 visual=liquid_glass
-- 029.05 phase=0.4167 ease=quintOut spring=16 damping=0.81 amplitude=0.004 visual=liquid_glass
-- 029.06 phase=0.5000 ease=quintOut spring=17 damping=0.82 amplitude=0.005 visual=liquid_glass
-- 029.07 phase=0.5833 ease=quintOut spring=18 damping=0.83 amplitude=0.006 visual=liquid_glass
-- 029.08 phase=0.6667 ease=quintOut spring=19 damping=0.84 amplitude=0.007 visual=liquid_glass
-- 029.09 phase=0.7500 ease=quintOut spring=20 damping=0.85 amplitude=0.008 visual=liquid_glass
-- 029.10 phase=0.8333 ease=quintOut spring=21 damping=0.86 amplitude=0.009 visual=liquid_glass
-- 029.11 phase=0.9167 ease=quintOut spring=22 damping=0.87 amplitude=0.010 visual=liquid_glass
-- 029.12 phase=1.0000 ease=quintOut spring=23 damping=0.88 amplitude=0.011 visual=liquid_glass

-- MOTION PACK 030: cinematic interaction family
-- 030.01 phase=0.0833 ease=quintOut spring=13 damping=0.80 amplitude=0.018 visual=liquid_glass
-- 030.02 phase=0.1667 ease=quintOut spring=14 damping=0.81 amplitude=0.019 visual=liquid_glass
-- 030.03 phase=0.2500 ease=quintOut spring=15 damping=0.82 amplitude=0.020 visual=liquid_glass
-- 030.04 phase=0.3333 ease=quintOut spring=16 damping=0.83 amplitude=0.004 visual=liquid_glass
-- 030.05 phase=0.4167 ease=quintOut spring=17 damping=0.84 amplitude=0.005 visual=liquid_glass
-- 030.06 phase=0.5000 ease=quintOut spring=18 damping=0.85 amplitude=0.006 visual=liquid_glass
-- 030.07 phase=0.5833 ease=quintOut spring=19 damping=0.86 amplitude=0.007 visual=liquid_glass
-- 030.08 phase=0.6667 ease=quintOut spring=20 damping=0.87 amplitude=0.008 visual=liquid_glass
-- 030.09 phase=0.7500 ease=quintOut spring=21 damping=0.88 amplitude=0.009 visual=liquid_glass
-- 030.10 phase=0.8333 ease=quintOut spring=22 damping=0.64 amplitude=0.010 visual=liquid_glass
-- 030.11 phase=0.9167 ease=quintOut spring=23 damping=0.65 amplitude=0.011 visual=liquid_glass
-- 030.12 phase=1.0000 ease=quintOut spring=10 damping=0.66 amplitude=0.012 visual=liquid_glass

-- MOTION PACK 031: cinematic interaction family
-- 031.01 phase=0.0833 ease=quintOut spring=14 damping=0.83 amplitude=0.019 visual=liquid_glass
-- 031.02 phase=0.1667 ease=quintOut spring=15 damping=0.84 amplitude=0.020 visual=liquid_glass
-- 031.03 phase=0.2500 ease=quintOut spring=16 damping=0.85 amplitude=0.004 visual=liquid_glass
-- 031.04 phase=0.3333 ease=quintOut spring=17 damping=0.86 amplitude=0.005 visual=liquid_glass
-- 031.05 phase=0.4167 ease=quintOut spring=18 damping=0.87 amplitude=0.006 visual=liquid_glass
-- 031.06 phase=0.5000 ease=quintOut spring=19 damping=0.88 amplitude=0.007 visual=liquid_glass
-- 031.07 phase=0.5833 ease=quintOut spring=20 damping=0.64 amplitude=0.008 visual=liquid_glass
-- 031.08 phase=0.6667 ease=quintOut spring=21 damping=0.65 amplitude=0.009 visual=liquid_glass
-- 031.09 phase=0.7500 ease=quintOut spring=22 damping=0.66 amplitude=0.010 visual=liquid_glass
-- 031.10 phase=0.8333 ease=quintOut spring=23 damping=0.67 amplitude=0.011 visual=liquid_glass
-- 031.11 phase=0.9167 ease=quintOut spring=10 damping=0.68 amplitude=0.012 visual=liquid_glass
-- 031.12 phase=1.0000 ease=quintOut spring=11 damping=0.69 amplitude=0.013 visual=liquid_glass

-- MOTION PACK 032: cinematic interaction family
-- 032.01 phase=0.0833 ease=quintOut spring=15 damping=0.86 amplitude=0.020 visual=liquid_glass
-- 032.02 phase=0.1667 ease=quintOut spring=16 damping=0.87 amplitude=0.004 visual=liquid_glass
-- 032.03 phase=0.2500 ease=quintOut spring=17 damping=0.88 amplitude=0.005 visual=liquid_glass
-- 032.04 phase=0.3333 ease=quintOut spring=18 damping=0.64 amplitude=0.006 visual=liquid_glass
-- 032.05 phase=0.4167 ease=quintOut spring=19 damping=0.65 amplitude=0.007 visual=liquid_glass
-- 032.06 phase=0.5000 ease=quintOut spring=20 damping=0.66 amplitude=0.008 visual=liquid_glass
-- 032.07 phase=0.5833 ease=quintOut spring=21 damping=0.67 amplitude=0.009 visual=liquid_glass
-- 032.08 phase=0.6667 ease=quintOut spring=22 damping=0.68 amplitude=0.010 visual=liquid_glass
-- 032.09 phase=0.7500 ease=quintOut spring=23 damping=0.69 amplitude=0.011 visual=liquid_glass
-- 032.10 phase=0.8333 ease=quintOut spring=10 damping=0.70 amplitude=0.012 visual=liquid_glass
-- 032.11 phase=0.9167 ease=quintOut spring=11 damping=0.71 amplitude=0.013 visual=liquid_glass
-- 032.12 phase=1.0000 ease=quintOut spring=12 damping=0.72 amplitude=0.014 visual=liquid_glass

-- MOTION PACK 033: cinematic interaction family
-- 033.01 phase=0.0833 ease=quintOut spring=16 damping=0.64 amplitude=0.004 visual=liquid_glass
-- 033.02 phase=0.1667 ease=quintOut spring=17 damping=0.65 amplitude=0.005 visual=liquid_glass
-- 033.03 phase=0.2500 ease=quintOut spring=18 damping=0.66 amplitude=0.006 visual=liquid_glass
-- 033.04 phase=0.3333 ease=quintOut spring=19 damping=0.67 amplitude=0.007 visual=liquid_glass
-- 033.05 phase=0.4167 ease=quintOut spring=20 damping=0.68 amplitude=0.008 visual=liquid_glass
-- 033.06 phase=0.5000 ease=quintOut spring=21 damping=0.69 amplitude=0.009 visual=liquid_glass
-- 033.07 phase=0.5833 ease=quintOut spring=22 damping=0.70 amplitude=0.010 visual=liquid_glass
-- 033.08 phase=0.6667 ease=quintOut spring=23 damping=0.71 amplitude=0.011 visual=liquid_glass
-- 033.09 phase=0.7500 ease=quintOut spring=10 damping=0.72 amplitude=0.012 visual=liquid_glass
-- 033.10 phase=0.8333 ease=quintOut spring=11 damping=0.73 amplitude=0.013 visual=liquid_glass
-- 033.11 phase=0.9167 ease=quintOut spring=12 damping=0.74 amplitude=0.014 visual=liquid_glass
-- 033.12 phase=1.0000 ease=quintOut spring=13 damping=0.75 amplitude=0.015 visual=liquid_glass

-- MOTION PACK 034: cinematic interaction family
-- 034.01 phase=0.0833 ease=quintOut spring=17 damping=0.67 amplitude=0.005 visual=liquid_glass
-- 034.02 phase=0.1667 ease=quintOut spring=18 damping=0.68 amplitude=0.006 visual=liquid_glass
-- 034.03 phase=0.2500 ease=quintOut spring=19 damping=0.69 amplitude=0.007 visual=liquid_glass
-- 034.04 phase=0.3333 ease=quintOut spring=20 damping=0.70 amplitude=0.008 visual=liquid_glass
-- 034.05 phase=0.4167 ease=quintOut spring=21 damping=0.71 amplitude=0.009 visual=liquid_glass
-- 034.06 phase=0.5000 ease=quintOut spring=22 damping=0.72 amplitude=0.010 visual=liquid_glass
-- 034.07 phase=0.5833 ease=quintOut spring=23 damping=0.73 amplitude=0.011 visual=liquid_glass
-- 034.08 phase=0.6667 ease=quintOut spring=10 damping=0.74 amplitude=0.012 visual=liquid_glass
-- 034.09 phase=0.7500 ease=quintOut spring=11 damping=0.75 amplitude=0.013 visual=liquid_glass
-- 034.10 phase=0.8333 ease=quintOut spring=12 damping=0.76 amplitude=0.014 visual=liquid_glass
-- 034.11 phase=0.9167 ease=quintOut spring=13 damping=0.77 amplitude=0.015 visual=liquid_glass
-- 034.12 phase=1.0000 ease=quintOut spring=14 damping=0.78 amplitude=0.016 visual=liquid_glass

-- MOTION PACK 035: cinematic interaction family
-- 035.01 phase=0.0833 ease=quintOut spring=18 damping=0.70 amplitude=0.006 visual=liquid_glass
-- 035.02 phase=0.1667 ease=quintOut spring=19 damping=0.71 amplitude=0.007 visual=liquid_glass
-- 035.03 phase=0.2500 ease=quintOut spring=20 damping=0.72 amplitude=0.008 visual=liquid_glass
-- 035.04 phase=0.3333 ease=quintOut spring=21 damping=0.73 amplitude=0.009 visual=liquid_glass
-- 035.05 phase=0.4167 ease=quintOut spring=22 damping=0.74 amplitude=0.010 visual=liquid_glass
-- 035.06 phase=0.5000 ease=quintOut spring=23 damping=0.75 amplitude=0.011 visual=liquid_glass
-- 035.07 phase=0.5833 ease=quintOut spring=10 damping=0.76 amplitude=0.012 visual=liquid_glass
-- 035.08 phase=0.6667 ease=quintOut spring=11 damping=0.77 amplitude=0.013 visual=liquid_glass
-- 035.09 phase=0.7500 ease=quintOut spring=12 damping=0.78 amplitude=0.014 visual=liquid_glass
-- 035.10 phase=0.8333 ease=quintOut spring=13 damping=0.79 amplitude=0.015 visual=liquid_glass
-- 035.11 phase=0.9167 ease=quintOut spring=14 damping=0.80 amplitude=0.016 visual=liquid_glass
-- 035.12 phase=1.0000 ease=quintOut spring=15 damping=0.81 amplitude=0.017 visual=liquid_glass

-- MOTION PACK 036: cinematic interaction family
-- 036.01 phase=0.0833 ease=quintOut spring=19 damping=0.73 amplitude=0.007 visual=liquid_glass
-- 036.02 phase=0.1667 ease=quintOut spring=20 damping=0.74 amplitude=0.008 visual=liquid_glass
-- 036.03 phase=0.2500 ease=quintOut spring=21 damping=0.75 amplitude=0.009 visual=liquid_glass
-- 036.04 phase=0.3333 ease=quintOut spring=22 damping=0.76 amplitude=0.010 visual=liquid_glass
-- 036.05 phase=0.4167 ease=quintOut spring=23 damping=0.77 amplitude=0.011 visual=liquid_glass
-- 036.06 phase=0.5000 ease=quintOut spring=10 damping=0.78 amplitude=0.012 visual=liquid_glass
-- 036.07 phase=0.5833 ease=quintOut spring=11 damping=0.79 amplitude=0.013 visual=liquid_glass
-- 036.08 phase=0.6667 ease=quintOut spring=12 damping=0.80 amplitude=0.014 visual=liquid_glass
-- 036.09 phase=0.7500 ease=quintOut spring=13 damping=0.81 amplitude=0.015 visual=liquid_glass
-- 036.10 phase=0.8333 ease=quintOut spring=14 damping=0.82 amplitude=0.016 visual=liquid_glass
-- 036.11 phase=0.9167 ease=quintOut spring=15 damping=0.83 amplitude=0.017 visual=liquid_glass
-- 036.12 phase=1.0000 ease=quintOut spring=16 damping=0.84 amplitude=0.018 visual=liquid_glass

-- MOTION PACK 037: cinematic interaction family
-- 037.01 phase=0.0833 ease=quintOut spring=20 damping=0.76 amplitude=0.008 visual=liquid_glass
-- 037.02 phase=0.1667 ease=quintOut spring=21 damping=0.77 amplitude=0.009 visual=liquid_glass
-- 037.03 phase=0.2500 ease=quintOut spring=22 damping=0.78 amplitude=0.010 visual=liquid_glass
-- 037.04 phase=0.3333 ease=quintOut spring=23 damping=0.79 amplitude=0.011 visual=liquid_glass
-- 037.05 phase=0.4167 ease=quintOut spring=10 damping=0.80 amplitude=0.012 visual=liquid_glass
-- 037.06 phase=0.5000 ease=quintOut spring=11 damping=0.81 amplitude=0.013 visual=liquid_glass
-- 037.07 phase=0.5833 ease=quintOut spring=12 damping=0.82 amplitude=0.014 visual=liquid_glass
-- 037.08 phase=0.6667 ease=quintOut spring=13 damping=0.83 amplitude=0.015 visual=liquid_glass
-- 037.09 phase=0.7500 ease=quintOut spring=14 damping=0.84 amplitude=0.016 visual=liquid_glass
-- 037.10 phase=0.8333 ease=quintOut spring=15 damping=0.85 amplitude=0.017 visual=liquid_glass
-- 037.11 phase=0.9167 ease=quintOut spring=16 damping=0.86 amplitude=0.018 visual=liquid_glass
-- 037.12 phase=1.0000 ease=quintOut spring=17 damping=0.87 amplitude=0.019 visual=liquid_glass

-- MOTION PACK 038: cinematic interaction family
-- 038.01 phase=0.0833 ease=quintOut spring=21 damping=0.79 amplitude=0.009 visual=liquid_glass
-- 038.02 phase=0.1667 ease=quintOut spring=22 damping=0.80 amplitude=0.010 visual=liquid_glass
-- 038.03 phase=0.2500 ease=quintOut spring=23 damping=0.81 amplitude=0.011 visual=liquid_glass
-- 038.04 phase=0.3333 ease=quintOut spring=10 damping=0.82 amplitude=0.012 visual=liquid_glass
-- 038.05 phase=0.4167 ease=quintOut spring=11 damping=0.83 amplitude=0.013 visual=liquid_glass
-- 038.06 phase=0.5000 ease=quintOut spring=12 damping=0.84 amplitude=0.014 visual=liquid_glass
-- 038.07 phase=0.5833 ease=quintOut spring=13 damping=0.85 amplitude=0.015 visual=liquid_glass
-- 038.08 phase=0.6667 ease=quintOut spring=14 damping=0.86 amplitude=0.016 visual=liquid_glass
-- 038.09 phase=0.7500 ease=quintOut spring=15 damping=0.87 amplitude=0.017 visual=liquid_glass
-- 038.10 phase=0.8333 ease=quintOut spring=16 damping=0.88 amplitude=0.018 visual=liquid_glass
-- 038.11 phase=0.9167 ease=quintOut spring=17 damping=0.64 amplitude=0.019 visual=liquid_glass
-- 038.12 phase=1.0000 ease=quintOut spring=18 damping=0.65 amplitude=0.020 visual=liquid_glass

-- MOTION PACK 039: cinematic interaction family
-- 039.01 phase=0.0833 ease=quintOut spring=22 damping=0.82 amplitude=0.010 visual=liquid_glass
-- 039.02 phase=0.1667 ease=quintOut spring=23 damping=0.83 amplitude=0.011 visual=liquid_glass
-- 039.03 phase=0.2500 ease=quintOut spring=10 damping=0.84 amplitude=0.012 visual=liquid_glass
-- 039.04 phase=0.3333 ease=quintOut spring=11 damping=0.85 amplitude=0.013 visual=liquid_glass
-- 039.05 phase=0.4167 ease=quintOut spring=12 damping=0.86 amplitude=0.014 visual=liquid_glass
-- 039.06 phase=0.5000 ease=quintOut spring=13 damping=0.87 amplitude=0.015 visual=liquid_glass
-- 039.07 phase=0.5833 ease=quintOut spring=14 damping=0.88 amplitude=0.016 visual=liquid_glass
-- 039.08 phase=0.6667 ease=quintOut spring=15 damping=0.64 amplitude=0.017 visual=liquid_glass
-- 039.09 phase=0.7500 ease=quintOut spring=16 damping=0.65 amplitude=0.018 visual=liquid_glass
-- 039.10 phase=0.8333 ease=quintOut spring=17 damping=0.66 amplitude=0.019 visual=liquid_glass
-- 039.11 phase=0.9167 ease=quintOut spring=18 damping=0.67 amplitude=0.020 visual=liquid_glass
-- 039.12 phase=1.0000 ease=quintOut spring=19 damping=0.68 amplitude=0.004 visual=liquid_glass

-- MOTION PACK 040: cinematic interaction family
-- 040.01 phase=0.0833 ease=quintOut spring=23 damping=0.85 amplitude=0.011 visual=liquid_glass
-- 040.02 phase=0.1667 ease=quintOut spring=10 damping=0.86 amplitude=0.012 visual=liquid_glass
-- 040.03 phase=0.2500 ease=quintOut spring=11 damping=0.87 amplitude=0.013 visual=liquid_glass
-- 040.04 phase=0.3333 ease=quintOut spring=12 damping=0.88 amplitude=0.014 visual=liquid_glass
-- 040.05 phase=0.4167 ease=quintOut spring=13 damping=0.64 amplitude=0.015 visual=liquid_glass
-- 040.06 phase=0.5000 ease=quintOut spring=14 damping=0.65 amplitude=0.016 visual=liquid_glass
-- 040.07 phase=0.5833 ease=quintOut spring=15 damping=0.66 amplitude=0.017 visual=liquid_glass
-- 040.08 phase=0.6667 ease=quintOut spring=16 damping=0.67 amplitude=0.018 visual=liquid_glass
-- 040.09 phase=0.7500 ease=quintOut spring=17 damping=0.68 amplitude=0.019 visual=liquid_glass
-- 040.10 phase=0.8333 ease=quintOut spring=18 damping=0.69 amplitude=0.020 visual=liquid_glass
-- 040.11 phase=0.9167 ease=quintOut spring=19 damping=0.70 amplitude=0.004 visual=liquid_glass
-- 040.12 phase=1.0000 ease=quintOut spring=20 damping=0.71 amplitude=0.005 visual=liquid_glass

-- MOTION PACK 041: cinematic interaction family
-- 041.01 phase=0.0833 ease=quintOut spring=10 damping=0.88 amplitude=0.012 visual=liquid_glass
-- 041.02 phase=0.1667 ease=quintOut spring=11 damping=0.64 amplitude=0.013 visual=liquid_glass
-- 041.03 phase=0.2500 ease=quintOut spring=12 damping=0.65 amplitude=0.014 visual=liquid_glass
-- 041.04 phase=0.3333 ease=quintOut spring=13 damping=0.66 amplitude=0.015 visual=liquid_glass
-- 041.05 phase=0.4167 ease=quintOut spring=14 damping=0.67 amplitude=0.016 visual=liquid_glass
-- 041.06 phase=0.5000 ease=quintOut spring=15 damping=0.68 amplitude=0.017 visual=liquid_glass
-- 041.07 phase=0.5833 ease=quintOut spring=16 damping=0.69 amplitude=0.018 visual=liquid_glass
-- 041.08 phase=0.6667 ease=quintOut spring=17 damping=0.70 amplitude=0.019 visual=liquid_glass
-- 041.09 phase=0.7500 ease=quintOut spring=18 damping=0.71 amplitude=0.020 visual=liquid_glass
-- 041.10 phase=0.8333 ease=quintOut spring=19 damping=0.72 amplitude=0.004 visual=liquid_glass
-- 041.11 phase=0.9167 ease=quintOut spring=20 damping=0.73 amplitude=0.005 visual=liquid_glass
-- 041.12 phase=1.0000 ease=quintOut spring=21 damping=0.74 amplitude=0.006 visual=liquid_glass

-- MOTION PACK 042: cinematic interaction family
-- 042.01 phase=0.0833 ease=quintOut spring=11 damping=0.66 amplitude=0.013 visual=liquid_glass
-- 042.02 phase=0.1667 ease=quintOut spring=12 damping=0.67 amplitude=0.014 visual=liquid_glass
-- 042.03 phase=0.2500 ease=quintOut spring=13 damping=0.68 amplitude=0.015 visual=liquid_glass
-- 042.04 phase=0.3333 ease=quintOut spring=14 damping=0.69 amplitude=0.016 visual=liquid_glass
-- 042.05 phase=0.4167 ease=quintOut spring=15 damping=0.70 amplitude=0.017 visual=liquid_glass
-- 042.06 phase=0.5000 ease=quintOut spring=16 damping=0.71 amplitude=0.018 visual=liquid_glass
-- 042.07 phase=0.5833 ease=quintOut spring=17 damping=0.72 amplitude=0.019 visual=liquid_glass
-- 042.08 phase=0.6667 ease=quintOut spring=18 damping=0.73 amplitude=0.020 visual=liquid_glass
-- 042.09 phase=0.7500 ease=quintOut spring=19 damping=0.74 amplitude=0.004 visual=liquid_glass
-- 042.10 phase=0.8333 ease=quintOut spring=20 damping=0.75 amplitude=0.005 visual=liquid_glass
-- 042.11 phase=0.9167 ease=quintOut spring=21 damping=0.76 amplitude=0.006 visual=liquid_glass
-- 042.12 phase=1.0000 ease=quintOut spring=22 damping=0.77 amplitude=0.007 visual=liquid_glass

-- MOTION PACK 043: cinematic interaction family
-- 043.01 phase=0.0833 ease=quintOut spring=12 damping=0.69 amplitude=0.014 visual=liquid_glass
-- 043.02 phase=0.1667 ease=quintOut spring=13 damping=0.70 amplitude=0.015 visual=liquid_glass
-- 043.03 phase=0.2500 ease=quintOut spring=14 damping=0.71 amplitude=0.016 visual=liquid_glass
-- 043.04 phase=0.3333 ease=quintOut spring=15 damping=0.72 amplitude=0.017 visual=liquid_glass
-- 043.05 phase=0.4167 ease=quintOut spring=16 damping=0.73 amplitude=0.018 visual=liquid_glass
-- 043.06 phase=0.5000 ease=quintOut spring=17 damping=0.74 amplitude=0.019 visual=liquid_glass
-- 043.07 phase=0.5833 ease=quintOut spring=18 damping=0.75 amplitude=0.020 visual=liquid_glass
-- 043.08 phase=0.6667 ease=quintOut spring=19 damping=0.76 amplitude=0.004 visual=liquid_glass
-- 043.09 phase=0.7500 ease=quintOut spring=20 damping=0.77 amplitude=0.005 visual=liquid_glass
-- 043.10 phase=0.8333 ease=quintOut spring=21 damping=0.78 amplitude=0.006 visual=liquid_glass
-- 043.11 phase=0.9167 ease=quintOut spring=22 damping=0.79 amplitude=0.007 visual=liquid_glass
-- 043.12 phase=1.0000 ease=quintOut spring=23 damping=0.80 amplitude=0.008 visual=liquid_glass

-- MOTION PACK 044: cinematic interaction family
-- 044.01 phase=0.0833 ease=quintOut spring=13 damping=0.72 amplitude=0.015 visual=liquid_glass
-- 044.02 phase=0.1667 ease=quintOut spring=14 damping=0.73 amplitude=0.016 visual=liquid_glass
-- 044.03 phase=0.2500 ease=quintOut spring=15 damping=0.74 amplitude=0.017 visual=liquid_glass
-- 044.04 phase=0.3333 ease=quintOut spring=16 damping=0.75 amplitude=0.018 visual=liquid_glass
-- 044.05 phase=0.4167 ease=quintOut spring=17 damping=0.76 amplitude=0.019 visual=liquid_glass
-- 044.06 phase=0.5000 ease=quintOut spring=18 damping=0.77 amplitude=0.020 visual=liquid_glass
-- 044.07 phase=0.5833 ease=quintOut spring=19 damping=0.78 amplitude=0.004 visual=liquid_glass
-- 044.08 phase=0.6667 ease=quintOut spring=20 damping=0.79 amplitude=0.005 visual=liquid_glass
-- 044.09 phase=0.7500 ease=quintOut spring=21 damping=0.80 amplitude=0.006 visual=liquid_glass
-- 044.10 phase=0.8333 ease=quintOut spring=22 damping=0.81 amplitude=0.007 visual=liquid_glass
-- 044.11 phase=0.9167 ease=quintOut spring=23 damping=0.82 amplitude=0.008 visual=liquid_glass
-- 044.12 phase=1.0000 ease=quintOut spring=10 damping=0.83 amplitude=0.009 visual=liquid_glass

-- MOTION PACK 045: cinematic interaction family
-- 045.01 phase=0.0833 ease=quintOut spring=14 damping=0.75 amplitude=0.016 visual=liquid_glass
-- 045.02 phase=0.1667 ease=quintOut spring=15 damping=0.76 amplitude=0.017 visual=liquid_glass
-- 045.03 phase=0.2500 ease=quintOut spring=16 damping=0.77 amplitude=0.018 visual=liquid_glass
-- 045.04 phase=0.3333 ease=quintOut spring=17 damping=0.78 amplitude=0.019 visual=liquid_glass
-- 045.05 phase=0.4167 ease=quintOut spring=18 damping=0.79 amplitude=0.020 visual=liquid_glass
-- 045.06 phase=0.5000 ease=quintOut spring=19 damping=0.80 amplitude=0.004 visual=liquid_glass
-- 045.07 phase=0.5833 ease=quintOut spring=20 damping=0.81 amplitude=0.005 visual=liquid_glass
-- 045.08 phase=0.6667 ease=quintOut spring=21 damping=0.82 amplitude=0.006 visual=liquid_glass
-- 045.09 phase=0.7500 ease=quintOut spring=22 damping=0.83 amplitude=0.007 visual=liquid_glass
-- 045.10 phase=0.8333 ease=quintOut spring=23 damping=0.84 amplitude=0.008 visual=liquid_glass
-- 045.11 phase=0.9167 ease=quintOut spring=10 damping=0.85 amplitude=0.009 visual=liquid_glass
-- 045.12 phase=1.0000 ease=quintOut spring=11 damping=0.86 amplitude=0.010 visual=liquid_glass

-- MOTION PACK 046: cinematic interaction family
-- 046.01 phase=0.0833 ease=quintOut spring=15 damping=0.78 amplitude=0.017 visual=liquid_glass
-- 046.02 phase=0.1667 ease=quintOut spring=16 damping=0.79 amplitude=0.018 visual=liquid_glass
-- 046.03 phase=0.2500 ease=quintOut spring=17 damping=0.80 amplitude=0.019 visual=liquid_glass
-- 046.04 phase=0.3333 ease=quintOut spring=18 damping=0.81 amplitude=0.020 visual=liquid_glass
-- 046.05 phase=0.4167 ease=quintOut spring=19 damping=0.82 amplitude=0.004 visual=liquid_glass
-- 046.06 phase=0.5000 ease=quintOut spring=20 damping=0.83 amplitude=0.005 visual=liquid_glass
-- 046.07 phase=0.5833 ease=quintOut spring=21 damping=0.84 amplitude=0.006 visual=liquid_glass
-- 046.08 phase=0.6667 ease=quintOut spring=22 damping=0.85 amplitude=0.007 visual=liquid_glass
-- 046.09 phase=0.7500 ease=quintOut spring=23 damping=0.86 amplitude=0.008 visual=liquid_glass
-- 046.10 phase=0.8333 ease=quintOut spring=10 damping=0.87 amplitude=0.009 visual=liquid_glass
-- 046.11 phase=0.9167 ease=quintOut spring=11 damping=0.88 amplitude=0.010 visual=liquid_glass
-- 046.12 phase=1.0000 ease=quintOut spring=12 damping=0.64 amplitude=0.011 visual=liquid_glass

-- MOTION PACK 047: cinematic interaction family
-- 047.01 phase=0.0833 ease=quintOut spring=16 damping=0.81 amplitude=0.018 visual=liquid_glass
-- 047.02 phase=0.1667 ease=quintOut spring=17 damping=0.82 amplitude=0.019 visual=liquid_glass
-- 047.03 phase=0.2500 ease=quintOut spring=18 damping=0.83 amplitude=0.020 visual=liquid_glass
-- 047.04 phase=0.3333 ease=quintOut spring=19 damping=0.84 amplitude=0.004 visual=liquid_glass
-- 047.05 phase=0.4167 ease=quintOut spring=20 damping=0.85 amplitude=0.005 visual=liquid_glass
-- 047.06 phase=0.5000 ease=quintOut spring=21 damping=0.86 amplitude=0.006 visual=liquid_glass
-- 047.07 phase=0.5833 ease=quintOut spring=22 damping=0.87 amplitude=0.007 visual=liquid_glass
-- 047.08 phase=0.6667 ease=quintOut spring=23 damping=0.88 amplitude=0.008 visual=liquid_glass
-- 047.09 phase=0.7500 ease=quintOut spring=10 damping=0.64 amplitude=0.009 visual=liquid_glass
-- 047.10 phase=0.8333 ease=quintOut spring=11 damping=0.65 amplitude=0.010 visual=liquid_glass
-- 047.11 phase=0.9167 ease=quintOut spring=12 damping=0.66 amplitude=0.011 visual=liquid_glass
-- 047.12 phase=1.0000 ease=quintOut spring=13 damping=0.67 amplitude=0.012 visual=liquid_glass

-- MOTION PACK 048: cinematic interaction family
-- 048.01 phase=0.0833 ease=quintOut spring=17 damping=0.84 amplitude=0.019 visual=liquid_glass
-- 048.02 phase=0.1667 ease=quintOut spring=18 damping=0.85 amplitude=0.020 visual=liquid_glass
-- 048.03 phase=0.2500 ease=quintOut spring=19 damping=0.86 amplitude=0.004 visual=liquid_glass
-- 048.04 phase=0.3333 ease=quintOut spring=20 damping=0.87 amplitude=0.005 visual=liquid_glass
-- 048.05 phase=0.4167 ease=quintOut spring=21 damping=0.88 amplitude=0.006 visual=liquid_glass
-- 048.06 phase=0.5000 ease=quintOut spring=22 damping=0.64 amplitude=0.007 visual=liquid_glass
-- 048.07 phase=0.5833 ease=quintOut spring=23 damping=0.65 amplitude=0.008 visual=liquid_glass
-- 048.08 phase=0.6667 ease=quintOut spring=10 damping=0.66 amplitude=0.009 visual=liquid_glass
-- 048.09 phase=0.7500 ease=quintOut spring=11 damping=0.67 amplitude=0.010 visual=liquid_glass
-- 048.10 phase=0.8333 ease=quintOut spring=12 damping=0.68 amplitude=0.011 visual=liquid_glass
-- 048.11 phase=0.9167 ease=quintOut spring=13 damping=0.69 amplitude=0.012 visual=liquid_glass
-- 048.12 phase=1.0000 ease=quintOut spring=14 damping=0.70 amplitude=0.013 visual=liquid_glass

-- MOTION PACK 049: cinematic interaction family
-- 049.01 phase=0.0833 ease=quintOut spring=18 damping=0.87 amplitude=0.020 visual=liquid_glass
-- 049.02 phase=0.1667 ease=quintOut spring=19 damping=0.88 amplitude=0.004 visual=liquid_glass
-- 049.03 phase=0.2500 ease=quintOut spring=20 damping=0.64 amplitude=0.005 visual=liquid_glass
-- 049.04 phase=0.3333 ease=quintOut spring=21 damping=0.65 amplitude=0.006 visual=liquid_glass
-- 049.05 phase=0.4167 ease=quintOut spring=22 damping=0.66 amplitude=0.007 visual=liquid_glass
-- 049.06 phase=0.5000 ease=quintOut spring=23 damping=0.67 amplitude=0.008 visual=liquid_glass
-- 049.07 phase=0.5833 ease=quintOut spring=10 damping=0.68 amplitude=0.009 visual=liquid_glass
-- 049.08 phase=0.6667 ease=quintOut spring=11 damping=0.69 amplitude=0.010 visual=liquid_glass
-- 049.09 phase=0.7500 ease=quintOut spring=12 damping=0.70 amplitude=0.011 visual=liquid_glass
-- 049.10 phase=0.8333 ease=quintOut spring=13 damping=0.71 amplitude=0.012 visual=liquid_glass
-- 049.11 phase=0.9167 ease=quintOut spring=14 damping=0.72 amplitude=0.013 visual=liquid_glass
-- 049.12 phase=1.0000 ease=quintOut spring=15 damping=0.73 amplitude=0.014 visual=liquid_glass

-- MOTION PACK 050: cinematic interaction family
-- 050.01 phase=0.0833 ease=quintOut spring=19 damping=0.65 amplitude=0.004 visual=liquid_glass
-- 050.02 phase=0.1667 ease=quintOut spring=20 damping=0.66 amplitude=0.005 visual=liquid_glass
-- 050.03 phase=0.2500 ease=quintOut spring=21 damping=0.67 amplitude=0.006 visual=liquid_glass
-- 050.04 phase=0.3333 ease=quintOut spring=22 damping=0.68 amplitude=0.007 visual=liquid_glass
-- 050.05 phase=0.4167 ease=quintOut spring=23 damping=0.69 amplitude=0.008 visual=liquid_glass
-- 050.06 phase=0.5000 ease=quintOut spring=10 damping=0.70 amplitude=0.009 visual=liquid_glass
-- 050.07 phase=0.5833 ease=quintOut spring=11 damping=0.71 amplitude=0.010 visual=liquid_glass
-- 050.08 phase=0.6667 ease=quintOut spring=12 damping=0.72 amplitude=0.011 visual=liquid_glass
-- 050.09 phase=0.7500 ease=quintOut spring=13 damping=0.73 amplitude=0.012 visual=liquid_glass
-- 050.10 phase=0.8333 ease=quintOut spring=14 damping=0.74 amplitude=0.013 visual=liquid_glass
-- 050.11 phase=0.9167 ease=quintOut spring=15 damping=0.75 amplitude=0.014 visual=liquid_glass
-- 050.12 phase=1.0000 ease=quintOut spring=16 damping=0.76 amplitude=0.015 visual=liquid_glass

-- MOTION PACK 051: cinematic interaction family
-- 051.01 phase=0.0833 ease=quintOut spring=20 damping=0.68 amplitude=0.005 visual=liquid_glass
-- 051.02 phase=0.1667 ease=quintOut spring=21 damping=0.69 amplitude=0.006 visual=liquid_glass
-- 051.03 phase=0.2500 ease=quintOut spring=22 damping=0.70 amplitude=0.007 visual=liquid_glass
-- 051.04 phase=0.3333 ease=quintOut spring=23 damping=0.71 amplitude=0.008 visual=liquid_glass
-- 051.05 phase=0.4167 ease=quintOut spring=10 damping=0.72 amplitude=0.009 visual=liquid_glass
-- 051.06 phase=0.5000 ease=quintOut spring=11 damping=0.73 amplitude=0.010 visual=liquid_glass
-- 051.07 phase=0.5833 ease=quintOut spring=12 damping=0.74 amplitude=0.011 visual=liquid_glass
-- 051.08 phase=0.6667 ease=quintOut spring=13 damping=0.75 amplitude=0.012 visual=liquid_glass
-- 051.09 phase=0.7500 ease=quintOut spring=14 damping=0.76 amplitude=0.013 visual=liquid_glass
-- 051.10 phase=0.8333 ease=quintOut spring=15 damping=0.77 amplitude=0.014 visual=liquid_glass
-- 051.11 phase=0.9167 ease=quintOut spring=16 damping=0.78 amplitude=0.015 visual=liquid_glass
-- 051.12 phase=1.0000 ease=quintOut spring=17 damping=0.79 amplitude=0.016 visual=liquid_glass

-- MOTION PACK 052: cinematic interaction family
-- 052.01 phase=0.0833 ease=quintOut spring=21 damping=0.71 amplitude=0.006 visual=liquid_glass
-- 052.02 phase=0.1667 ease=quintOut spring=22 damping=0.72 amplitude=0.007 visual=liquid_glass
-- 052.03 phase=0.2500 ease=quintOut spring=23 damping=0.73 amplitude=0.008 visual=liquid_glass
-- 052.04 phase=0.3333 ease=quintOut spring=10 damping=0.74 amplitude=0.009 visual=liquid_glass
-- 052.05 phase=0.4167 ease=quintOut spring=11 damping=0.75 amplitude=0.010 visual=liquid_glass
-- 052.06 phase=0.5000 ease=quintOut spring=12 damping=0.76 amplitude=0.011 visual=liquid_glass
-- 052.07 phase=0.5833 ease=quintOut spring=13 damping=0.77 amplitude=0.012 visual=liquid_glass
-- 052.08 phase=0.6667 ease=quintOut spring=14 damping=0.78 amplitude=0.013 visual=liquid_glass
-- 052.09 phase=0.7500 ease=quintOut spring=15 damping=0.79 amplitude=0.014 visual=liquid_glass
-- 052.10 phase=0.8333 ease=quintOut spring=16 damping=0.80 amplitude=0.015 visual=liquid_glass
-- 052.11 phase=0.9167 ease=quintOut spring=17 damping=0.81 amplitude=0.016 visual=liquid_glass
-- 052.12 phase=1.0000 ease=quintOut spring=18 damping=0.82 amplitude=0.017 visual=liquid_glass

-- MOTION PACK 053: cinematic interaction family
-- 053.01 phase=0.0833 ease=quintOut spring=22 damping=0.74 amplitude=0.007 visual=liquid_glass
-- 053.02 phase=0.1667 ease=quintOut spring=23 damping=0.75 amplitude=0.008 visual=liquid_glass
-- 053.03 phase=0.2500 ease=quintOut spring=10 damping=0.76 amplitude=0.009 visual=liquid_glass
-- 053.04 phase=0.3333 ease=quintOut spring=11 damping=0.77 amplitude=0.010 visual=liquid_glass
-- 053.05 phase=0.4167 ease=quintOut spring=12 damping=0.78 amplitude=0.011 visual=liquid_glass
-- 053.06 phase=0.5000 ease=quintOut spring=13 damping=0.79 amplitude=0.012 visual=liquid_glass
-- 053.07 phase=0.5833 ease=quintOut spring=14 damping=0.80 amplitude=0.013 visual=liquid_glass
-- 053.08 phase=0.6667 ease=quintOut spring=15 damping=0.81 amplitude=0.014 visual=liquid_glass
-- 053.09 phase=0.7500 ease=quintOut spring=16 damping=0.82 amplitude=0.015 visual=liquid_glass
-- 053.10 phase=0.8333 ease=quintOut spring=17 damping=0.83 amplitude=0.016 visual=liquid_glass
-- 053.11 phase=0.9167 ease=quintOut spring=18 damping=0.84 amplitude=0.017 visual=liquid_glass
-- 053.12 phase=1.0000 ease=quintOut spring=19 damping=0.85 amplitude=0.018 visual=liquid_glass

-- MOTION PACK 054: cinematic interaction family
-- 054.01 phase=0.0833 ease=quintOut spring=23 damping=0.77 amplitude=0.008 visual=liquid_glass
-- 054.02 phase=0.1667 ease=quintOut spring=10 damping=0.78 amplitude=0.009 visual=liquid_glass
-- 054.03 phase=0.2500 ease=quintOut spring=11 damping=0.79 amplitude=0.010 visual=liquid_glass
-- 054.04 phase=0.3333 ease=quintOut spring=12 damping=0.80 amplitude=0.011 visual=liquid_glass
-- 054.05 phase=0.4167 ease=quintOut spring=13 damping=0.81 amplitude=0.012 visual=liquid_glass
-- 054.06 phase=0.5000 ease=quintOut spring=14 damping=0.82 amplitude=0.013 visual=liquid_glass
-- 054.07 phase=0.5833 ease=quintOut spring=15 damping=0.83 amplitude=0.014 visual=liquid_glass
-- 054.08 phase=0.6667 ease=quintOut spring=16 damping=0.84 amplitude=0.015 visual=liquid_glass
-- 054.09 phase=0.7500 ease=quintOut spring=17 damping=0.85 amplitude=0.016 visual=liquid_glass
-- 054.10 phase=0.8333 ease=quintOut spring=18 damping=0.86 amplitude=0.017 visual=liquid_glass
-- 054.11 phase=0.9167 ease=quintOut spring=19 damping=0.87 amplitude=0.018 visual=liquid_glass
-- 054.12 phase=1.0000 ease=quintOut spring=20 damping=0.88 amplitude=0.019 visual=liquid_glass

-- MOTION PACK 055: cinematic interaction family
-- 055.01 phase=0.0833 ease=quintOut spring=10 damping=0.80 amplitude=0.009 visual=liquid_glass
-- 055.02 phase=0.1667 ease=quintOut spring=11 damping=0.81 amplitude=0.010 visual=liquid_glass
-- 055.03 phase=0.2500 ease=quintOut spring=12 damping=0.82 amplitude=0.011 visual=liquid_glass
-- 055.04 phase=0.3333 ease=quintOut spring=13 damping=0.83 amplitude=0.012 visual=liquid_glass
-- 055.05 phase=0.4167 ease=quintOut spring=14 damping=0.84 amplitude=0.013 visual=liquid_glass
-- 055.06 phase=0.5000 ease=quintOut spring=15 damping=0.85 amplitude=0.014 visual=liquid_glass
-- 055.07 phase=0.5833 ease=quintOut spring=16 damping=0.86 amplitude=0.015 visual=liquid_glass
-- 055.08 phase=0.6667 ease=quintOut spring=17 damping=0.87 amplitude=0.016 visual=liquid_glass
-- 055.09 phase=0.7500 ease=quintOut spring=18 damping=0.88 amplitude=0.017 visual=liquid_glass
-- 055.10 phase=0.8333 ease=quintOut spring=19 damping=0.64 amplitude=0.018 visual=liquid_glass
-- 055.11 phase=0.9167 ease=quintOut spring=20 damping=0.65 amplitude=0.019 visual=liquid_glass
-- 055.12 phase=1.0000 ease=quintOut spring=21 damping=0.66 amplitude=0.020 visual=liquid_glass

-- MOTION PACK 056: cinematic interaction family
-- 056.01 phase=0.0833 ease=quintOut spring=11 damping=0.83 amplitude=0.010 visual=liquid_glass
-- 056.02 phase=0.1667 ease=quintOut spring=12 damping=0.84 amplitude=0.011 visual=liquid_glass
-- 056.03 phase=0.2500 ease=quintOut spring=13 damping=0.85 amplitude=0.012 visual=liquid_glass
-- 056.04 phase=0.3333 ease=quintOut spring=14 damping=0.86 amplitude=0.013 visual=liquid_glass
-- 056.05 phase=0.4167 ease=quintOut spring=15 damping=0.87 amplitude=0.014 visual=liquid_glass
-- 056.06 phase=0.5000 ease=quintOut spring=16 damping=0.88 amplitude=0.015 visual=liquid_glass
-- 056.07 phase=0.5833 ease=quintOut spring=17 damping=0.64 amplitude=0.016 visual=liquid_glass
-- 056.08 phase=0.6667 ease=quintOut spring=18 damping=0.65 amplitude=0.017 visual=liquid_glass
-- 056.09 phase=0.7500 ease=quintOut spring=19 damping=0.66 amplitude=0.018 visual=liquid_glass
-- 056.10 phase=0.8333 ease=quintOut spring=20 damping=0.67 amplitude=0.019 visual=liquid_glass
-- 056.11 phase=0.9167 ease=quintOut spring=21 damping=0.68 amplitude=0.020 visual=liquid_glass
-- 056.12 phase=1.0000 ease=quintOut spring=22 damping=0.69 amplitude=0.004 visual=liquid_glass

-- MOTION PACK 057: cinematic interaction family
-- 057.01 phase=0.0833 ease=quintOut spring=12 damping=0.86 amplitude=0.011 visual=liquid_glass
-- 057.02 phase=0.1667 ease=quintOut spring=13 damping=0.87 amplitude=0.012 visual=liquid_glass
-- 057.03 phase=0.2500 ease=quintOut spring=14 damping=0.88 amplitude=0.013 visual=liquid_glass
-- 057.04 phase=0.3333 ease=quintOut spring=15 damping=0.64 amplitude=0.014 visual=liquid_glass
-- 057.05 phase=0.4167 ease=quintOut spring=16 damping=0.65 amplitude=0.015 visual=liquid_glass
-- 057.06 phase=0.5000 ease=quintOut spring=17 damping=0.66 amplitude=0.016 visual=liquid_glass
-- 057.07 phase=0.5833 ease=quintOut spring=18 damping=0.67 amplitude=0.017 visual=liquid_glass
-- 057.08 phase=0.6667 ease=quintOut spring=19 damping=0.68 amplitude=0.018 visual=liquid_glass
-- 057.09 phase=0.7500 ease=quintOut spring=20 damping=0.69 amplitude=0.019 visual=liquid_glass
-- 057.10 phase=0.8333 ease=quintOut spring=21 damping=0.70 amplitude=0.020 visual=liquid_glass
-- 057.11 phase=0.9167 ease=quintOut spring=22 damping=0.71 amplitude=0.004 visual=liquid_glass
-- 057.12 phase=1.0000 ease=quintOut spring=23 damping=0.72 amplitude=0.005 visual=liquid_glass

-- MOTION PACK 058: cinematic interaction family
-- 058.01 phase=0.0833 ease=quintOut spring=13 damping=0.64 amplitude=0.012 visual=liquid_glass
-- 058.02 phase=0.1667 ease=quintOut spring=14 damping=0.65 amplitude=0.013 visual=liquid_glass
-- 058.03 phase=0.2500 ease=quintOut spring=15 damping=0.66 amplitude=0.014 visual=liquid_glass
-- 058.04 phase=0.3333 ease=quintOut spring=16 damping=0.67 amplitude=0.015 visual=liquid_glass
-- 058.05 phase=0.4167 ease=quintOut spring=17 damping=0.68 amplitude=0.016 visual=liquid_glass
-- 058.06 phase=0.5000 ease=quintOut spring=18 damping=0.69 amplitude=0.017 visual=liquid_glass
-- 058.07 phase=0.5833 ease=quintOut spring=19 damping=0.70 amplitude=0.018 visual=liquid_glass
-- 058.08 phase=0.6667 ease=quintOut spring=20 damping=0.71 amplitude=0.019 visual=liquid_glass
-- 058.09 phase=0.7500 ease=quintOut spring=21 damping=0.72 amplitude=0.020 visual=liquid_glass
-- 058.10 phase=0.8333 ease=quintOut spring=22 damping=0.73 amplitude=0.004 visual=liquid_glass
-- 058.11 phase=0.9167 ease=quintOut spring=23 damping=0.74 amplitude=0.005 visual=liquid_glass
-- 058.12 phase=1.0000 ease=quintOut spring=10 damping=0.75 amplitude=0.006 visual=liquid_glass

-- MOTION PACK 059: cinematic interaction family
-- 059.01 phase=0.0833 ease=quintOut spring=14 damping=0.67 amplitude=0.013 visual=liquid_glass
-- 059.02 phase=0.1667 ease=quintOut spring=15 damping=0.68 amplitude=0.014 visual=liquid_glass
-- 059.03 phase=0.2500 ease=quintOut spring=16 damping=0.69 amplitude=0.015 visual=liquid_glass
-- 059.04 phase=0.3333 ease=quintOut spring=17 damping=0.70 amplitude=0.016 visual=liquid_glass
-- 059.05 phase=0.4167 ease=quintOut spring=18 damping=0.71 amplitude=0.017 visual=liquid_glass
-- 059.06 phase=0.5000 ease=quintOut spring=19 damping=0.72 amplitude=0.018 visual=liquid_glass
-- 059.07 phase=0.5833 ease=quintOut spring=20 damping=0.73 amplitude=0.019 visual=liquid_glass
-- 059.08 phase=0.6667 ease=quintOut spring=21 damping=0.74 amplitude=0.020 visual=liquid_glass
-- 059.09 phase=0.7500 ease=quintOut spring=22 damping=0.75 amplitude=0.004 visual=liquid_glass
-- 059.10 phase=0.8333 ease=quintOut spring=23 damping=0.76 amplitude=0.005 visual=liquid_glass
-- 059.11 phase=0.9167 ease=quintOut spring=10 damping=0.77 amplitude=0.006 visual=liquid_glass
-- 059.12 phase=1.0000 ease=quintOut spring=11 damping=0.78 amplitude=0.007 visual=liquid_glass

-- MOTION PACK 060: cinematic interaction family
-- 060.01 phase=0.0833 ease=quintOut spring=15 damping=0.70 amplitude=0.014 visual=liquid_glass
-- 060.02 phase=0.1667 ease=quintOut spring=16 damping=0.71 amplitude=0.015 visual=liquid_glass
-- 060.03 phase=0.2500 ease=quintOut spring=17 damping=0.72 amplitude=0.016 visual=liquid_glass
-- 060.04 phase=0.3333 ease=quintOut spring=18 damping=0.73 amplitude=0.017 visual=liquid_glass
-- 060.05 phase=0.4167 ease=quintOut spring=19 damping=0.74 amplitude=0.018 visual=liquid_glass
-- 060.06 phase=0.5000 ease=quintOut spring=20 damping=0.75 amplitude=0.019 visual=liquid_glass
-- 060.07 phase=0.5833 ease=quintOut spring=21 damping=0.76 amplitude=0.020 visual=liquid_glass
-- 060.08 phase=0.6667 ease=quintOut spring=22 damping=0.77 amplitude=0.004 visual=liquid_glass
-- 060.09 phase=0.7500 ease=quintOut spring=23 damping=0.78 amplitude=0.005 visual=liquid_glass
-- 060.10 phase=0.8333 ease=quintOut spring=10 damping=0.79 amplitude=0.006 visual=liquid_glass
-- 060.11 phase=0.9167 ease=quintOut spring=11 damping=0.80 amplitude=0.007 visual=liquid_glass
-- 060.12 phase=1.0000 ease=quintOut spring=12 damping=0.81 amplitude=0.008 visual=liquid_glass

-- MOTION PACK 061: cinematic interaction family
-- 061.01 phase=0.0833 ease=quintOut spring=16 damping=0.73 amplitude=0.015 visual=liquid_glass
-- 061.02 phase=0.1667 ease=quintOut spring=17 damping=0.74 amplitude=0.016 visual=liquid_glass
-- 061.03 phase=0.2500 ease=quintOut spring=18 damping=0.75 amplitude=0.017 visual=liquid_glass
-- 061.04 phase=0.3333 ease=quintOut spring=19 damping=0.76 amplitude=0.018 visual=liquid_glass
-- 061.05 phase=0.4167 ease=quintOut spring=20 damping=0.77 amplitude=0.019 visual=liquid_glass
-- 061.06 phase=0.5000 ease=quintOut spring=21 damping=0.78 amplitude=0.020 visual=liquid_glass
-- 061.07 phase=0.5833 ease=quintOut spring=22 damping=0.79 amplitude=0.004 visual=liquid_glass
-- 061.08 phase=0.6667 ease=quintOut spring=23 damping=0.80 amplitude=0.005 visual=liquid_glass
-- 061.09 phase=0.7500 ease=quintOut spring=10 damping=0.81 amplitude=0.006 visual=liquid_glass
-- 061.10 phase=0.8333 ease=quintOut spring=11 damping=0.82 amplitude=0.007 visual=liquid_glass
-- 061.11 phase=0.9167 ease=quintOut spring=12 damping=0.83 amplitude=0.008 visual=liquid_glass
-- 061.12 phase=1.0000 ease=quintOut spring=13 damping=0.84 amplitude=0.009 visual=liquid_glass

-- MOTION PACK 062: cinematic interaction family
-- 062.01 phase=0.0833 ease=quintOut spring=17 damping=0.76 amplitude=0.016 visual=liquid_glass
-- 062.02 phase=0.1667 ease=quintOut spring=18 damping=0.77 amplitude=0.017 visual=liquid_glass
-- 062.03 phase=0.2500 ease=quintOut spring=19 damping=0.78 amplitude=0.018 visual=liquid_glass
-- 062.04 phase=0.3333 ease=quintOut spring=20 damping=0.79 amplitude=0.019 visual=liquid_glass
-- 062.05 phase=0.4167 ease=quintOut spring=21 damping=0.80 amplitude=0.020 visual=liquid_glass
-- 062.06 phase=0.5000 ease=quintOut spring=22 damping=0.81 amplitude=0.004 visual=liquid_glass
-- 062.07 phase=0.5833 ease=quintOut spring=23 damping=0.82 amplitude=0.005 visual=liquid_glass
-- 062.08 phase=0.6667 ease=quintOut spring=10 damping=0.83 amplitude=0.006 visual=liquid_glass
-- 062.09 phase=0.7500 ease=quintOut spring=11 damping=0.84 amplitude=0.007 visual=liquid_glass
-- 062.10 phase=0.8333 ease=quintOut spring=12 damping=0.85 amplitude=0.008 visual=liquid_glass
-- 062.11 phase=0.9167 ease=quintOut spring=13 damping=0.86 amplitude=0.009 visual=liquid_glass
-- 062.12 phase=1.0000 ease=quintOut spring=14 damping=0.87 amplitude=0.010 visual=liquid_glass

-- MOTION PACK 063: cinematic interaction family
-- 063.01 phase=0.0833 ease=quintOut spring=18 damping=0.79 amplitude=0.017 visual=liquid_glass
-- 063.02 phase=0.1667 ease=quintOut spring=19 damping=0.80 amplitude=0.018 visual=liquid_glass
-- 063.03 phase=0.2500 ease=quintOut spring=20 damping=0.81 amplitude=0.019 visual=liquid_glass
-- 063.04 phase=0.3333 ease=quintOut spring=21 damping=0.82 amplitude=0.020 visual=liquid_glass
-- 063.05 phase=0.4167 ease=quintOut spring=22 damping=0.83 amplitude=0.004 visual=liquid_glass
-- 063.06 phase=0.5000 ease=quintOut spring=23 damping=0.84 amplitude=0.005 visual=liquid_glass
-- 063.07 phase=0.5833 ease=quintOut spring=10 damping=0.85 amplitude=0.006 visual=liquid_glass
-- 063.08 phase=0.6667 ease=quintOut spring=11 damping=0.86 amplitude=0.007 visual=liquid_glass
-- 063.09 phase=0.7500 ease=quintOut spring=12 damping=0.87 amplitude=0.008 visual=liquid_glass
-- 063.10 phase=0.8333 ease=quintOut spring=13 damping=0.88 amplitude=0.009 visual=liquid_glass
-- 063.11 phase=0.9167 ease=quintOut spring=14 damping=0.64 amplitude=0.010 visual=liquid_glass
-- 063.12 phase=1.0000 ease=quintOut spring=15 damping=0.65 amplitude=0.011 visual=liquid_glass

-- MOTION PACK 064: cinematic interaction family
-- 064.01 phase=0.0833 ease=quintOut spring=19 damping=0.82 amplitude=0.018 visual=liquid_glass
-- 064.02 phase=0.1667 ease=quintOut spring=20 damping=0.83 amplitude=0.019 visual=liquid_glass
-- 064.03 phase=0.2500 ease=quintOut spring=21 damping=0.84 amplitude=0.020 visual=liquid_glass
-- 064.04 phase=0.3333 ease=quintOut spring=22 damping=0.85 amplitude=0.004 visual=liquid_glass
-- 064.05 phase=0.4167 ease=quintOut spring=23 damping=0.86 amplitude=0.005 visual=liquid_glass
-- 064.06 phase=0.5000 ease=quintOut spring=10 damping=0.87 amplitude=0.006 visual=liquid_glass
-- 064.07 phase=0.5833 ease=quintOut spring=11 damping=0.88 amplitude=0.007 visual=liquid_glass
-- 064.08 phase=0.6667 ease=quintOut spring=12 damping=0.64 amplitude=0.008 visual=liquid_glass
-- 064.09 phase=0.7500 ease=quintOut spring=13 damping=0.65 amplitude=0.009 visual=liquid_glass
-- 064.10 phase=0.8333 ease=quintOut spring=14 damping=0.66 amplitude=0.010 visual=liquid_glass
-- 064.11 phase=0.9167 ease=quintOut spring=15 damping=0.67 amplitude=0.011 visual=liquid_glass
-- 064.12 phase=1.0000 ease=quintOut spring=16 damping=0.68 amplitude=0.012 visual=liquid_glass

-- MOTION PACK 065: cinematic interaction family
-- 065.01 phase=0.0833 ease=quintOut spring=20 damping=0.85 amplitude=0.019 visual=liquid_glass
-- 065.02 phase=0.1667 ease=quintOut spring=21 damping=0.86 amplitude=0.020 visual=liquid_glass
-- 065.03 phase=0.2500 ease=quintOut spring=22 damping=0.87 amplitude=0.004 visual=liquid_glass
-- 065.04 phase=0.3333 ease=quintOut spring=23 damping=0.88 amplitude=0.005 visual=liquid_glass
-- 065.05 phase=0.4167 ease=quintOut spring=10 damping=0.64 amplitude=0.006 visual=liquid_glass
-- 065.06 phase=0.5000 ease=quintOut spring=11 damping=0.65 amplitude=0.007 visual=liquid_glass
-- 065.07 phase=0.5833 ease=quintOut spring=12 damping=0.66 amplitude=0.008 visual=liquid_glass
-- 065.08 phase=0.6667 ease=quintOut spring=13 damping=0.67 amplitude=0.009 visual=liquid_glass
-- 065.09 phase=0.7500 ease=quintOut spring=14 damping=0.68 amplitude=0.010 visual=liquid_glass
-- 065.10 phase=0.8333 ease=quintOut spring=15 damping=0.69 amplitude=0.011 visual=liquid_glass
-- 065.11 phase=0.9167 ease=quintOut spring=16 damping=0.70 amplitude=0.012 visual=liquid_glass
-- 065.12 phase=1.0000 ease=quintOut spring=17 damping=0.71 amplitude=0.013 visual=liquid_glass

-- MOTION PACK 066: cinematic interaction family
-- 066.01 phase=0.0833 ease=quintOut spring=21 damping=0.88 amplitude=0.020 visual=liquid_glass
-- 066.02 phase=0.1667 ease=quintOut spring=22 damping=0.64 amplitude=0.004 visual=liquid_glass
-- 066.03 phase=0.2500 ease=quintOut spring=23 damping=0.65 amplitude=0.005 visual=liquid_glass
-- 066.04 phase=0.3333 ease=quintOut spring=10 damping=0.66 amplitude=0.006 visual=liquid_glass
-- 066.05 phase=0.4167 ease=quintOut spring=11 damping=0.67 amplitude=0.007 visual=liquid_glass
-- 066.06 phase=0.5000 ease=quintOut spring=12 damping=0.68 amplitude=0.008 visual=liquid_glass
-- 066.07 phase=0.5833 ease=quintOut spring=13 damping=0.69 amplitude=0.009 visual=liquid_glass
-- 066.08 phase=0.6667 ease=quintOut spring=14 damping=0.70 amplitude=0.010 visual=liquid_glass
-- 066.09 phase=0.7500 ease=quintOut spring=15 damping=0.71 amplitude=0.011 visual=liquid_glass
-- 066.10 phase=0.8333 ease=quintOut spring=16 damping=0.72 amplitude=0.012 visual=liquid_glass
-- 066.11 phase=0.9167 ease=quintOut spring=17 damping=0.73 amplitude=0.013 visual=liquid_glass
-- 066.12 phase=1.0000 ease=quintOut spring=18 damping=0.74 amplitude=0.014 visual=liquid_glass

-- MOTION PACK 067: cinematic interaction family
-- 067.01 phase=0.0833 ease=quintOut spring=22 damping=0.66 amplitude=0.004 visual=liquid_glass
-- 067.02 phase=0.1667 ease=quintOut spring=23 damping=0.67 amplitude=0.005 visual=liquid_glass
-- 067.03 phase=0.2500 ease=quintOut spring=10 damping=0.68 amplitude=0.006 visual=liquid_glass
-- 067.04 phase=0.3333 ease=quintOut spring=11 damping=0.69 amplitude=0.007 visual=liquid_glass
-- 067.05 phase=0.4167 ease=quintOut spring=12 damping=0.70 amplitude=0.008 visual=liquid_glass
-- 067.06 phase=0.5000 ease=quintOut spring=13 damping=0.71 amplitude=0.009 visual=liquid_glass
-- 067.07 phase=0.5833 ease=quintOut spring=14 damping=0.72 amplitude=0.010 visual=liquid_glass
-- 067.08 phase=0.6667 ease=quintOut spring=15 damping=0.73 amplitude=0.011 visual=liquid_glass
-- 067.09 phase=0.7500 ease=quintOut spring=16 damping=0.74 amplitude=0.012 visual=liquid_glass
-- 067.10 phase=0.8333 ease=quintOut spring=17 damping=0.75 amplitude=0.013 visual=liquid_glass
-- 067.11 phase=0.9167 ease=quintOut spring=18 damping=0.76 amplitude=0.014 visual=liquid_glass
-- 067.12 phase=1.0000 ease=quintOut spring=19 damping=0.77 amplitude=0.015 visual=liquid_glass

-- MOTION PACK 068: cinematic interaction family
-- 068.01 phase=0.0833 ease=quintOut spring=23 damping=0.69 amplitude=0.005 visual=liquid_glass
-- 068.02 phase=0.1667 ease=quintOut spring=10 damping=0.70 amplitude=0.006 visual=liquid_glass
-- 068.03 phase=0.2500 ease=quintOut spring=11 damping=0.71 amplitude=0.007 visual=liquid_glass
-- 068.04 phase=0.3333 ease=quintOut spring=12 damping=0.72 amplitude=0.008 visual=liquid_glass
-- 068.05 phase=0.4167 ease=quintOut spring=13 damping=0.73 amplitude=0.009 visual=liquid_glass
-- 068.06 phase=0.5000 ease=quintOut spring=14 damping=0.74 amplitude=0.010 visual=liquid_glass
-- 068.07 phase=0.5833 ease=quintOut spring=15 damping=0.75 amplitude=0.011 visual=liquid_glass
-- 068.08 phase=0.6667 ease=quintOut spring=16 damping=0.76 amplitude=0.012 visual=liquid_glass
-- 068.09 phase=0.7500 ease=quintOut spring=17 damping=0.77 amplitude=0.013 visual=liquid_glass
-- 068.10 phase=0.8333 ease=quintOut spring=18 damping=0.78 amplitude=0.014 visual=liquid_glass
-- 068.11 phase=0.9167 ease=quintOut spring=19 damping=0.79 amplitude=0.015 visual=liquid_glass
-- 068.12 phase=1.0000 ease=quintOut spring=20 damping=0.80 amplitude=0.016 visual=liquid_glass

-- MOTION PACK 069: cinematic interaction family
-- 069.01 phase=0.0833 ease=quintOut spring=10 damping=0.72 amplitude=0.006 visual=liquid_glass
-- 069.02 phase=0.1667 ease=quintOut spring=11 damping=0.73 amplitude=0.007 visual=liquid_glass
-- 069.03 phase=0.2500 ease=quintOut spring=12 damping=0.74 amplitude=0.008 visual=liquid_glass
-- 069.04 phase=0.3333 ease=quintOut spring=13 damping=0.75 amplitude=0.009 visual=liquid_glass
-- 069.05 phase=0.4167 ease=quintOut spring=14 damping=0.76 amplitude=0.010 visual=liquid_glass
-- 069.06 phase=0.5000 ease=quintOut spring=15 damping=0.77 amplitude=0.011 visual=liquid_glass
-- 069.07 phase=0.5833 ease=quintOut spring=16 damping=0.78 amplitude=0.012 visual=liquid_glass
-- 069.08 phase=0.6667 ease=quintOut spring=17 damping=0.79 amplitude=0.013 visual=liquid_glass
-- 069.09 phase=0.7500 ease=quintOut spring=18 damping=0.80 amplitude=0.014 visual=liquid_glass
-- 069.10 phase=0.8333 ease=quintOut spring=19 damping=0.81 amplitude=0.015 visual=liquid_glass
-- 069.11 phase=0.9167 ease=quintOut spring=20 damping=0.82 amplitude=0.016 visual=liquid_glass
-- 069.12 phase=1.0000 ease=quintOut spring=21 damping=0.83 amplitude=0.017 visual=liquid_glass

-- MOTION PACK 070: cinematic interaction family
-- 070.01 phase=0.0833 ease=quintOut spring=11 damping=0.75 amplitude=0.007 visual=liquid_glass
-- 070.02 phase=0.1667 ease=quintOut spring=12 damping=0.76 amplitude=0.008 visual=liquid_glass
-- 070.03 phase=0.2500 ease=quintOut spring=13 damping=0.77 amplitude=0.009 visual=liquid_glass
-- 070.04 phase=0.3333 ease=quintOut spring=14 damping=0.78 amplitude=0.010 visual=liquid_glass
-- 070.05 phase=0.4167 ease=quintOut spring=15 damping=0.79 amplitude=0.011 visual=liquid_glass
-- 070.06 phase=0.5000 ease=quintOut spring=16 damping=0.80 amplitude=0.012 visual=liquid_glass
-- 070.07 phase=0.5833 ease=quintOut spring=17 damping=0.81 amplitude=0.013 visual=liquid_glass
-- 070.08 phase=0.6667 ease=quintOut spring=18 damping=0.82 amplitude=0.014 visual=liquid_glass
-- 070.09 phase=0.7500 ease=quintOut spring=19 damping=0.83 amplitude=0.015 visual=liquid_glass
-- 070.10 phase=0.8333 ease=quintOut spring=20 damping=0.84 amplitude=0.016 visual=liquid_glass
-- 070.11 phase=0.9167 ease=quintOut spring=21 damping=0.85 amplitude=0.017 visual=liquid_glass
-- 070.12 phase=1.0000 ease=quintOut spring=22 damping=0.86 amplitude=0.018 visual=liquid_glass

-- MOTION PACK 071: cinematic interaction family
-- 071.01 phase=0.0833 ease=quintOut spring=12 damping=0.78 amplitude=0.008 visual=liquid_glass
-- 071.02 phase=0.1667 ease=quintOut spring=13 damping=0.79 amplitude=0.009 visual=liquid_glass
-- 071.03 phase=0.2500 ease=quintOut spring=14 damping=0.80 amplitude=0.010 visual=liquid_glass
-- 071.04 phase=0.3333 ease=quintOut spring=15 damping=0.81 amplitude=0.011 visual=liquid_glass
-- 071.05 phase=0.4167 ease=quintOut spring=16 damping=0.82 amplitude=0.012 visual=liquid_glass
-- 071.06 phase=0.5000 ease=quintOut spring=17 damping=0.83 amplitude=0.013 visual=liquid_glass
-- 071.07 phase=0.5833 ease=quintOut spring=18 damping=0.84 amplitude=0.014 visual=liquid_glass
-- 071.08 phase=0.6667 ease=quintOut spring=19 damping=0.85 amplitude=0.015 visual=liquid_glass
-- 071.09 phase=0.7500 ease=quintOut spring=20 damping=0.86 amplitude=0.016 visual=liquid_glass
-- 071.10 phase=0.8333 ease=quintOut spring=21 damping=0.87 amplitude=0.017 visual=liquid_glass
-- 071.11 phase=0.9167 ease=quintOut spring=22 damping=0.88 amplitude=0.018 visual=liquid_glass
-- 071.12 phase=1.0000 ease=quintOut spring=23 damping=0.64 amplitude=0.019 visual=liquid_glass

-- MOTION PACK 072: cinematic interaction family
-- 072.01 phase=0.0833 ease=quintOut spring=13 damping=0.81 amplitude=0.009 visual=liquid_glass
-- 072.02 phase=0.1667 ease=quintOut spring=14 damping=0.82 amplitude=0.010 visual=liquid_glass
-- 072.03 phase=0.2500 ease=quintOut spring=15 damping=0.83 amplitude=0.011 visual=liquid_glass
-- 072.04 phase=0.3333 ease=quintOut spring=16 damping=0.84 amplitude=0.012 visual=liquid_glass
-- 072.05 phase=0.4167 ease=quintOut spring=17 damping=0.85 amplitude=0.013 visual=liquid_glass
-- 072.06 phase=0.5000 ease=quintOut spring=18 damping=0.86 amplitude=0.014 visual=liquid_glass
-- 072.07 phase=0.5833 ease=quintOut spring=19 damping=0.87 amplitude=0.015 visual=liquid_glass
-- 072.08 phase=0.6667 ease=quintOut spring=20 damping=0.88 amplitude=0.016 visual=liquid_glass
-- 072.09 phase=0.7500 ease=quintOut spring=21 damping=0.64 amplitude=0.017 visual=liquid_glass
-- 072.10 phase=0.8333 ease=quintOut spring=22 damping=0.65 amplitude=0.018 visual=liquid_glass
-- 072.11 phase=0.9167 ease=quintOut spring=23 damping=0.66 amplitude=0.019 visual=liquid_glass
-- 072.12 phase=1.0000 ease=quintOut spring=10 damping=0.67 amplitude=0.020 visual=liquid_glass

-- MOTION PACK 073: cinematic interaction family
-- 073.01 phase=0.0833 ease=quintOut spring=14 damping=0.84 amplitude=0.010 visual=liquid_glass
-- 073.02 phase=0.1667 ease=quintOut spring=15 damping=0.85 amplitude=0.011 visual=liquid_glass
-- 073.03 phase=0.2500 ease=quintOut spring=16 damping=0.86 amplitude=0.012 visual=liquid_glass
-- 073.04 phase=0.3333 ease=quintOut spring=17 damping=0.87 amplitude=0.013 visual=liquid_glass
-- 073.05 phase=0.4167 ease=quintOut spring=18 damping=0.88 amplitude=0.014 visual=liquid_glass
-- 073.06 phase=0.5000 ease=quintOut spring=19 damping=0.64 amplitude=0.015 visual=liquid_glass
-- 073.07 phase=0.5833 ease=quintOut spring=20 damping=0.65 amplitude=0.016 visual=liquid_glass
-- 073.08 phase=0.6667 ease=quintOut spring=21 damping=0.66 amplitude=0.017 visual=liquid_glass
-- 073.09 phase=0.7500 ease=quintOut spring=22 damping=0.67 amplitude=0.018 visual=liquid_glass
-- 073.10 phase=0.8333 ease=quintOut spring=23 damping=0.68 amplitude=0.019 visual=liquid_glass
-- 073.11 phase=0.9167 ease=quintOut spring=10 damping=0.69 amplitude=0.020 visual=liquid_glass
-- 073.12 phase=1.0000 ease=quintOut spring=11 damping=0.70 amplitude=0.004 visual=liquid_glass

-- MOTION PACK 074: cinematic interaction family
-- 074.01 phase=0.0833 ease=quintOut spring=15 damping=0.87 amplitude=0.011 visual=liquid_glass
-- 074.02 phase=0.1667 ease=quintOut spring=16 damping=0.88 amplitude=0.012 visual=liquid_glass
-- 074.03 phase=0.2500 ease=quintOut spring=17 damping=0.64 amplitude=0.013 visual=liquid_glass
-- 074.04 phase=0.3333 ease=quintOut spring=18 damping=0.65 amplitude=0.014 visual=liquid_glass
-- 074.05 phase=0.4167 ease=quintOut spring=19 damping=0.66 amplitude=0.015 visual=liquid_glass
-- 074.06 phase=0.5000 ease=quintOut spring=20 damping=0.67 amplitude=0.016 visual=liquid_glass
-- 074.07 phase=0.5833 ease=quintOut spring=21 damping=0.68 amplitude=0.017 visual=liquid_glass
-- 074.08 phase=0.6667 ease=quintOut spring=22 damping=0.69 amplitude=0.018 visual=liquid_glass
-- 074.09 phase=0.7500 ease=quintOut spring=23 damping=0.70 amplitude=0.019 visual=liquid_glass
-- 074.10 phase=0.8333 ease=quintOut spring=10 damping=0.71 amplitude=0.020 visual=liquid_glass
-- 074.11 phase=0.9167 ease=quintOut spring=11 damping=0.72 amplitude=0.004 visual=liquid_glass
-- 074.12 phase=1.0000 ease=quintOut spring=12 damping=0.73 amplitude=0.005 visual=liquid_glass

-- MOTION PACK 075: cinematic interaction family
-- 075.01 phase=0.0833 ease=quintOut spring=16 damping=0.65 amplitude=0.012 visual=liquid_glass
-- 075.02 phase=0.1667 ease=quintOut spring=17 damping=0.66 amplitude=0.013 visual=liquid_glass
-- 075.03 phase=0.2500 ease=quintOut spring=18 damping=0.67 amplitude=0.014 visual=liquid_glass
-- 075.04 phase=0.3333 ease=quintOut spring=19 damping=0.68 amplitude=0.015 visual=liquid_glass
-- 075.05 phase=0.4167 ease=quintOut spring=20 damping=0.69 amplitude=0.016 visual=liquid_glass
-- 075.06 phase=0.5000 ease=quintOut spring=21 damping=0.70 amplitude=0.017 visual=liquid_glass
-- 075.07 phase=0.5833 ease=quintOut spring=22 damping=0.71 amplitude=0.018 visual=liquid_glass
-- 075.08 phase=0.6667 ease=quintOut spring=23 damping=0.72 amplitude=0.019 visual=liquid_glass
-- 075.09 phase=0.7500 ease=quintOut spring=10 damping=0.73 amplitude=0.020 visual=liquid_glass
-- 075.10 phase=0.8333 ease=quintOut spring=11 damping=0.74 amplitude=0.004 visual=liquid_glass
-- 075.11 phase=0.9167 ease=quintOut spring=12 damping=0.75 amplitude=0.005 visual=liquid_glass
-- 075.12 phase=1.0000 ease=quintOut spring=13 damping=0.76 amplitude=0.006 visual=liquid_glass
