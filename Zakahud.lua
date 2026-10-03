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
-- V8 CINEMATIC MOTION ENGINE
-- UI-only animation layer: spring, squash/stretch, shimmer, parallax,
-- liquid morph, hover, stagger, adaptive quality and touch feedback.
--==============================================================
local V8 = {
    Enabled=true,
    Quality=3,
    Time=0,
    MenuSpring=0,
    MenuVelocity=0,
    HoverPulse=0,
    TouchPulse=0,
    Shimmer=0,
    ParallaxX=0,
    ParallaxY=0,
    LastTouch=Vector2.new(0,0),
}

local V8Profiles={
    [1]={name="Battery",rate=30,particles=4,detail=.45,breath=.012},
    [2]={name="Balanced",rate=45,particles=8,detail=.70,breath=.018},
    [3]={name="Cinematic",rate=60,particles=14,detail=1,breath=.025},
    [4]={name="Ultra",rate=60,particles=22,detail=1.15,breath=.032},
}

local function v8Profile()
    return V8Profiles[math.clamp(V8.Quality,1,4)]
end

local function v8Ease(t,kind)
    t=math.clamp(t,0,1)
    if kind=="sine" then return -(math.cos(math.pi*t)-1)/2 end
    if kind=="quint" then return 1-(1-t)^5 end
    if kind=="expo" then return t==0 and 0 or 2^(10*(t-1)) end
    if kind=="back" then local c=1.70158; local u=t-1; return u*u*((c+1)*u+c)+1 end
    if kind=="elastic" then if t==0 or t==1 then return t end local p=.3; return -(2^(10*(t-1))*math.sin((t-1-p/4)*(2*math.pi)/p)) end
    return t*t*(3-2*t)
end

local function v8Spring(current,target,velocity,stiffness,damping,dt)
    local force=(target-current)*stiffness
    velocity=velocity+force*dt
    velocity=velocity*math.exp(-damping*dt)
    current=current+velocity*dt
    return current,velocity
end

local function v8Scale(obj, sx, sy, duration, style)
    if not obj or not obj.Parent then return end
    local s=obj.Size
    local goal=UDim2.new(s.X.Scale*sx,s.X.Offset*sx,s.Y.Scale*sy,s.Y.Offset*sy)
    TweenService:Create(obj,TweenInfo.new(duration or .12,style or Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=goal}):Play()
end

local function v8Squash(obj, amount)
    if not obj or not obj.Parent then return end
    amount=amount or .055
    local s=obj.Size
    local a=TweenService:Create(obj,TweenInfo.new(.075,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{
        Size=UDim2.new(s.X.Scale*(1+amount),s.X.Offset*(1+amount),s.Y.Scale*(1-amount),s.Y.Offset*(1-amount))
    })
    a:Play()
    task.delay(.075,function()
        if obj.Parent then TweenService:Create(obj,TweenInfo.new(.26,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=s}):Play() end
    end)
end

local function v8RippleAt(parent,pos,size)
    if not parent or not parent.Parent then return end
    local r=newFrame(parent,"V8Ripple",UDim2.fromOffset(8,8),UDim2.fromOffset(pos.X-4,pos.Y-4),C.White,.58,980)
    corner(r,999)
    stroke(r,C.Pink3,2,.20)
    TweenService:Create(r,TweenInfo.new(.55,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
        Size=UDim2.fromOffset(size or 100,size or 100),
        Position=UDim2.fromOffset(pos.X-(size or 100)/2,pos.Y-(size or 100)/2),
        BackgroundTransparency=1,
    }):Play()
    task.delay(.6,function() if r.Parent then r:Destroy() end end)
end

local function v8SparkBurst(origin,count,power)
    count=math.clamp(count or v8Profile().particles,2,28)
    power=power or 180
    for i=1,count do
        local p=newFrame(FXLayer,"V8Spark",UDim2.fromOffset(math.random(3,7),math.random(3,7)),
            UDim2.fromOffset(origin.X,origin.Y),C.Pink3,.05,970)
        corner(p,999)
        local a=(i/count)*math.pi*2+math.random()*.45
        local d=power*(.55+math.random()*.55)
        TweenService:Create(p,TweenInfo.new(.45+math.random()*.35,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
            Position=UDim2.fromOffset(origin.X+math.cos(a)*d,origin.Y+math.sin(a)*d),
            BackgroundTransparency=1,Size=UDim2.fromOffset(1,1)
        }):Play()
        task.delay(1,function() if p.Parent then p:Destroy() end end)
    end
end

local function v8PetalPulse(strength)
    strength=strength or .05
    for i,p in ipairs(Petals) do
        if p.Parent then
            local base=p.Size
            local s=1+strength*(1+(i%3)*.12)
            TweenService:Create(p,TweenInfo.new(.16,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{
                Size=UDim2.fromOffset(62*s,30*s),
                BackgroundTransparency=math.max(.55,p.BackgroundTransparency-.12)
            }):Play()
            task.delay(.18,function()
                if p.Parent then TweenService:Create(p,TweenInfo.new(.42,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=base,BackgroundTransparency=.78}):Play() end
            end)
        end
    end
end

local function v8RingShock()
    for i,r in ipairs(RingData) do
        if r.Parent then
            local base=r.Size
            local mul=1.06+i*.006
            TweenService:Create(r,TweenInfo.new(.20,Enum.EasingStyle.Quint),{
                Size=UDim2.new(base.X.Scale*mul,base.X.Offset*mul,base.Y.Scale*mul,base.Y.Offset*mul),
                BackgroundTransparency=.92
            }):Play()
            task.delay(.22,function()
                if r.Parent then TweenService:Create(r,TweenInfo.new(.55,Enum.EasingStyle.Back),{Size=base,BackgroundTransparency=1}):Play() end
            end)
        end
    end
end

local function v8LiquidOpen()
    if not Menu or not Menu.Parent then return end
    local center=UDim2.fromScale(.5,.5)
    local original=Menu.Size
    Menu.AnchorPoint=Vector2.new(.5,.5)
    Menu.Position=center
    Menu.Size=UDim2.fromScale(.045,.045)
    Menu.Rotation=-10
    Menu.BackgroundTransparency=.78
    local seq={
        {t=.16,size=.075,rot=-6},
        {t=.14,size=.19,rot=4},
        {t=.17,size=.42,rot=-3},
        {t=.20,size=.72,rot=1},
        {t=.32,size=.90,rot=0},
    }
    for _,s in ipairs(seq) do
        TweenService:Create(Menu,TweenInfo.new(s.t,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
            Size=UDim2.fromScale(s.size,s.size*.91),Rotation=s.rot,BackgroundTransparency=math.max(.24,Menu.BackgroundTransparency-.13)
        }):Play()
        task.wait(s.t*.78)
    end
    Menu.Size=original
    Menu.Position=UDim2.fromScale(.05,.09)
    Menu.Rotation=0
end

local function v8LiquidClose()
    if not Menu or not Menu.Parent then return end
    local center=UDim2.fromScale(.5,.5)
    TweenService:Create(Menu,TweenInfo.new(.13,Enum.EasingStyle.Quad),{Rotation=5}):Play()
    task.wait(.08)
    TweenService:Create(Menu,TweenInfo.new(.42,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{
        Size=UDim2.fromScale(.055,.055),Position=center,Rotation=-8,BackgroundTransparency=.86
    }):Play()
end

local function v8StaggerIn()
    for i,b in ipairs(TabButtons) do
        if b.Parent then
            b.BackgroundTransparency=1
            b.Position=UDim2.new(b.Position.X.Scale-.035,b.Position.X.Offset,b.Position.Y.Scale+.025,b.Position.Y.Offset)
            task.delay((i-1)*.035,function()
                if b.Parent then
                    TweenService:Create(b,TweenInfo.new(.42,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
                        BackgroundTransparency=(i==CurrentTab and .30 or .58),
                        Position=UDim2.new(b.Position.X.Scale+.035,b.Position.X.Offset,b.Position.Y.Scale-.025,b.Position.Y.Offset)
                    }):Play()
                end
            end)
        end
    end
    for i,x in ipairs(FunctionButtons) do
        local b=x.button
        if b and b.Parent then
            b.BackgroundTransparency=1
            task.delay((i-1)*.022,function()
                if b.Parent then TweenService:Create(b,TweenInfo.new(.36,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{BackgroundTransparency=.48}):Play() end
            end)
        end
    end
end

local function v8Hover(button)
    if not button or not button.Parent then return end
    local normal=button.Size
    button.MouseEnter:Connect(function()
        TweenService:Create(button,TweenInfo.new(.12,Enum.EasingStyle.Quad),{BackgroundTransparency=math.max(.18,button.BackgroundTransparency-.12)}):Play()
        TweenService:Create(button,TweenInfo.new(.20,Enum.EasingStyle.Back),{Size=UDim2.new(normal.X.Scale*1.025,normal.X.Offset*1.025,normal.Y.Scale*1.025,normal.Y.Offset*1.025)}):Play()
    end)
    button.MouseLeave:Connect(function()
        if button.Parent then TweenService:Create(button,TweenInfo.new(.20,Enum.EasingStyle.Back),{Size=normal}):Play() end
    end)
end

for _,b in ipairs(TabButtons) do v8Hover(b) end
for _,x in ipairs(FunctionButtons) do v8Hover(x.button) end

local v8Bound=false
local function v8BindTouch()
    if v8Bound then return end
    v8Bound=true
    local function bind(obj)
        if not obj or not obj.Parent then return end
        obj.InputBegan:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 then
                local q=inp.Position
                local p=obj.AbsolutePosition
                v8RippleAt(obj,Vector2.new(q.X-p.X,q.Y-p.Y),92)
                v8Squash(obj,.035)
                V8.TouchPulse=1
            end
        end)
    end
    bind(Orb); bind(Close); bind(CoreButton)
    for _,b in ipairs(TabButtons) do bind(b) end
    for _,x in ipairs(FunctionButtons) do bind(x.button) end
end
v8BindTouch()

local v8Last=0
RunService.RenderStepped:Connect(function(dt)
    if not V8.Enabled then return end
    V8.Time=V8.Time+dt
    local t=V8.Time
    local profile=v8Profile()
    V8.TouchPulse=V8.TouchPulse*math.exp(-9*dt)
    V8.HoverPulse=V8.HoverPulse*math.exp(-7*dt)
    V8.MenuSpring,V8.MenuVelocity=v8Spring(V8.MenuSpring,Menu.Visible and 1 or 0,V8.MenuVelocity,30,9,dt)
    if Menu.Visible then
        local breath=math.sin(t*1.55)*profile.breath
        local sway=math.sin(t*.72)*profile.detail
        FlowerArea.Rotation=math.sin(t*.85)*1.2
        FlowerArea.Size=UDim2.fromScale(.30+breath,.40+breath)
        for i,p in ipairs(Petals) do
            local phase=t*(1.35+(i%4)*.08)+i*.32
            p.Rotation=(i-1)*30+math.sin(phase)*3.5
            local s=1+math.sin(phase*1.3)*.018*profile.detail
            p.Size=UDim2.fromOffset(62*s,30*s)
        end
        FlowerRing.Rotation=(t*22)%360
        FlowerOuter.Rotation=(-t*10)%360
        for i,r in ipairs(RingData) do
            r.Rotation=(i%2==0 and -1 or 1)*t*(7+i*1.65)
            local pulse=1+math.sin(t*(.75+i*.07))*0.008*profile.detail
            r.Size=UDim2.fromOffset((230+i*24)*pulse,(230+i*24)*pulse)
        end
        local shimmer=(math.sin(t*.55)+1)/2
        LiquidHighlight.Position=UDim2.new(-.28+shimmer*1.52,0,.12+math.sin(t*.9)*.018,0)
        LiquidHighlight.Rotation=-12+math.sin(t*.7)*4
        Menu.Rotation=math.sin(t*.42)*.25
        if Panther and Panther.Visible then
            Panther.Position=UDim2.new(Panther.Position.X.Scale,Panther.Position.X.Offset+math.sin(t*.9)*sway,
                Panther.Position.Y.Scale,Panther.Position.Y.Offset+math.cos(t*1.1)*sway)
            Panther.Rotation=math.sin(t*.72)*.55
        end
        if t-v8Last>(1/profile.rate) then
            v8Last=t
            if math.random()<.20*profile.detail then
                local p=profile.particles>12 and 2 or 1
                for _=1,p do spawnParticle() end
            end
        end
    end
end)

-- A small public controller for the menu itself.
local V8MotionAPI={}
function V8MotionAPI.Quality(n)
    V8.Quality=math.clamp(math.floor(tonumber(n) or 3),1,4)
    v6Toast("MOTION",v8Profile().name)
end
function V8MotionAPI.PlayIntro()
    task.spawn(function()
        v8LiquidOpen(); v8StaggerIn(); v8PetalPulse(.10); v8RingShock(); v8SparkBurst(Vector2.new(Root.AbsoluteSize.X*.5,Root.AbsoluteSize.Y*.5),v8Profile().particles,220)
    end)
end
function V8MotionAPI.PlayImpact()
    v8PetalPulse(.08); v8RingShock(); v8SparkBurst(Vector2.new(Root.AbsoluteSize.X*.5,Root.AbsoluteSize.Y*.5),math.min(18,v8Profile().particles+4),200)
end
function V8MotionAPI.PlayRipple(x,y)
    v8RippleAt(FXLayer,Vector2.new(x,y),130)
end
function V8MotionAPI.PlayClose()
    task.spawn(v8LiquidClose)
end
_G.ZAKA_PINK_PANTHER_MOTION_V8=V8MotionAPI

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
-- V8 MOTION LIBRARY: deterministic keyframe metadata
--==============================================================
local V8_MOTION_LIBRARY={}
V8_MOTION_LIBRARY[1]={phase=0.0417,spring=11,damping=0.65,scale=1.004,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[2]={phase=0.0833,spring=12,damping=0.66,scale=1.008,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[3]={phase=0.1250,spring=13,damping=0.67,scale=1.012,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[4]={phase=0.1667,spring=14,damping=0.68,scale=1.016,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[5]={phase=0.2083,spring=15,damping=0.69,scale=1.020,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[6]={phase=0.2500,spring=16,damping=0.70,scale=1.024,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[7]={phase=0.2917,spring=17,damping=0.71,scale=1.028,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[8]={phase=0.3333,spring=18,damping=0.72,scale=1.032,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[9]={phase=0.3750,spring=19,damping=0.73,scale=1.000,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[10]={phase=0.4167,spring=20,damping=0.74,scale=1.004,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[11]={phase=0.4583,spring=21,damping=0.75,scale=1.008,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[12]={phase=0.5000,spring=22,damping=0.76,scale=1.012,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[13]={phase=0.5417,spring=23,damping=0.77,scale=1.016,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[14]={phase=0.5833,spring=24,damping=0.78,scale=1.020,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[15]={phase=0.6250,spring=25,damping=0.79,scale=1.024,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[16]={phase=0.6667,spring=26,damping=0.80,scale=1.028,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[17]={phase=0.7083,spring=10,damping=0.81,scale=1.032,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[18]={phase=0.7500,spring=11,damping=0.82,scale=1.000,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[19]={phase=0.7917,spring=12,damping=0.83,scale=1.004,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[20]={phase=0.8333,spring=13,damping=0.84,scale=1.008,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[21]={phase=0.8750,spring=14,damping=0.85,scale=1.012,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[22]={phase=0.9167,spring=15,damping=0.86,scale=1.016,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[23]={phase=0.9583,spring=16,damping=0.87,scale=1.020,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[24]={phase=0.0000,spring=17,damping=0.64,scale=1.024,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[25]={phase=0.0417,spring=18,damping=0.65,scale=1.028,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[26]={phase=0.0833,spring=19,damping=0.66,scale=1.032,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[27]={phase=0.1250,spring=20,damping=0.67,scale=1.000,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[28]={phase=0.1667,spring=21,damping=0.68,scale=1.004,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[29]={phase=0.2083,spring=22,damping=0.69,scale=1.008,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[30]={phase=0.2500,spring=23,damping=0.70,scale=1.012,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[31]={phase=0.2917,spring=24,damping=0.71,scale=1.016,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[32]={phase=0.3333,spring=25,damping=0.72,scale=1.020,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[33]={phase=0.3750,spring=26,damping=0.73,scale=1.024,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[34]={phase=0.4167,spring=10,damping=0.74,scale=1.028,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[35]={phase=0.4583,spring=11,damping=0.75,scale=1.032,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[36]={phase=0.5000,spring=12,damping=0.76,scale=1.000,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[37]={phase=0.5417,spring=13,damping=0.77,scale=1.004,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[38]={phase=0.5833,spring=14,damping=0.78,scale=1.008,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[39]={phase=0.6250,spring=15,damping=0.79,scale=1.012,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[40]={phase=0.6667,spring=16,damping=0.80,scale=1.016,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[41]={phase=0.7083,spring=17,damping=0.81,scale=1.020,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[42]={phase=0.7500,spring=18,damping=0.82,scale=1.024,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[43]={phase=0.7917,spring=19,damping=0.83,scale=1.028,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[44]={phase=0.8333,spring=20,damping=0.84,scale=1.032,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[45]={phase=0.8750,spring=21,damping=0.85,scale=1.000,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[46]={phase=0.9167,spring=22,damping=0.86,scale=1.004,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[47]={phase=0.9583,spring=23,damping=0.87,scale=1.008,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[48]={phase=0.0000,spring=24,damping=0.64,scale=1.012,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[49]={phase=0.0417,spring=25,damping=0.65,scale=1.016,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[50]={phase=0.0833,spring=26,damping=0.66,scale=1.020,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[51]={phase=0.1250,spring=10,damping=0.67,scale=1.024,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[52]={phase=0.1667,spring=11,damping=0.68,scale=1.028,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[53]={phase=0.2083,spring=12,damping=0.69,scale=1.032,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[54]={phase=0.2500,spring=13,damping=0.70,scale=1.000,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[55]={phase=0.2917,spring=14,damping=0.71,scale=1.004,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[56]={phase=0.3333,spring=15,damping=0.72,scale=1.008,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[57]={phase=0.3750,spring=16,damping=0.73,scale=1.012,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[58]={phase=0.4167,spring=17,damping=0.74,scale=1.016,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[59]={phase=0.4583,spring=18,damping=0.75,scale=1.020,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[60]={phase=0.5000,spring=19,damping=0.76,scale=1.024,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[61]={phase=0.5417,spring=20,damping=0.77,scale=1.028,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[62]={phase=0.5833,spring=21,damping=0.78,scale=1.032,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[63]={phase=0.6250,spring=22,damping=0.79,scale=1.000,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[64]={phase=0.6667,spring=23,damping=0.80,scale=1.004,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[65]={phase=0.7083,spring=24,damping=0.81,scale=1.008,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[66]={phase=0.7500,spring=25,damping=0.82,scale=1.012,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[67]={phase=0.7917,spring=26,damping=0.83,scale=1.016,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[68]={phase=0.8333,spring=10,damping=0.84,scale=1.020,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[69]={phase=0.8750,spring=11,damping=0.85,scale=1.024,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[70]={phase=0.9167,spring=12,damping=0.86,scale=1.028,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[71]={phase=0.9583,spring=13,damping=0.87,scale=1.032,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[72]={phase=0.0000,spring=14,damping=0.64,scale=1.000,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[73]={phase=0.0417,spring=15,damping=0.65,scale=1.004,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[74]={phase=0.0833,spring=16,damping=0.66,scale=1.008,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[75]={phase=0.1250,spring=17,damping=0.67,scale=1.012,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[76]={phase=0.1667,spring=18,damping=0.68,scale=1.016,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[77]={phase=0.2083,spring=19,damping=0.69,scale=1.020,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[78]={phase=0.2500,spring=20,damping=0.70,scale=1.024,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[79]={phase=0.2917,spring=21,damping=0.71,scale=1.028,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[80]={phase=0.3333,spring=22,damping=0.72,scale=1.032,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[81]={phase=0.3750,spring=23,damping=0.73,scale=1.000,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[82]={phase=0.4167,spring=24,damping=0.74,scale=1.004,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[83]={phase=0.4583,spring=25,damping=0.75,scale=1.008,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[84]={phase=0.5000,spring=26,damping=0.76,scale=1.012,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[85]={phase=0.5417,spring=10,damping=0.77,scale=1.016,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[86]={phase=0.5833,spring=11,damping=0.78,scale=1.020,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[87]={phase=0.6250,spring=12,damping=0.79,scale=1.024,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[88]={phase=0.6667,spring=13,damping=0.80,scale=1.028,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[89]={phase=0.7083,spring=14,damping=0.81,scale=1.032,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[90]={phase=0.7500,spring=15,damping=0.82,scale=1.000,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[91]={phase=0.7917,spring=16,damping=0.83,scale=1.004,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[92]={phase=0.8333,spring=17,damping=0.84,scale=1.008,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[93]={phase=0.8750,spring=18,damping=0.85,scale=1.012,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[94]={phase=0.9167,spring=19,damping=0.86,scale=1.016,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[95]={phase=0.9583,spring=20,damping=0.87,scale=1.020,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[96]={phase=0.0000,spring=21,damping=0.64,scale=1.024,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[97]={phase=0.0417,spring=22,damping=0.65,scale=1.028,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[98]={phase=0.0833,spring=23,damping=0.66,scale=1.032,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[99]={phase=0.1250,spring=24,damping=0.67,scale=1.000,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[100]={phase=0.1667,spring=25,damping=0.68,scale=1.004,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[101]={phase=0.2083,spring=26,damping=0.69,scale=1.008,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[102]={phase=0.2500,spring=10,damping=0.70,scale=1.012,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[103]={phase=0.2917,spring=11,damping=0.71,scale=1.016,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[104]={phase=0.3333,spring=12,damping=0.72,scale=1.020,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[105]={phase=0.3750,spring=13,damping=0.73,scale=1.024,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[106]={phase=0.4167,spring=14,damping=0.74,scale=1.028,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[107]={phase=0.4583,spring=15,damping=0.75,scale=1.032,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[108]={phase=0.5000,spring=16,damping=0.76,scale=1.000,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[109]={phase=0.5417,spring=17,damping=0.77,scale=1.004,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[110]={phase=0.5833,spring=18,damping=0.78,scale=1.008,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[111]={phase=0.6250,spring=19,damping=0.79,scale=1.012,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[112]={phase=0.6667,spring=20,damping=0.80,scale=1.016,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[113]={phase=0.7083,spring=21,damping=0.81,scale=1.020,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[114]={phase=0.7500,spring=22,damping=0.82,scale=1.024,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[115]={phase=0.7917,spring=23,damping=0.83,scale=1.028,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[116]={phase=0.8333,spring=24,damping=0.84,scale=1.032,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[117]={phase=0.8750,spring=25,damping=0.85,scale=1.000,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[118]={phase=0.9167,spring=26,damping=0.86,scale=1.004,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[119]={phase=0.9583,spring=10,damping=0.87,scale=1.008,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[120]={phase=0.0000,spring=11,damping=0.64,scale=1.012,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[121]={phase=0.0417,spring=12,damping=0.65,scale=1.016,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[122]={phase=0.0833,spring=13,damping=0.66,scale=1.020,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[123]={phase=0.1250,spring=14,damping=0.67,scale=1.024,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[124]={phase=0.1667,spring=15,damping=0.68,scale=1.028,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[125]={phase=0.2083,spring=16,damping=0.69,scale=1.032,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[126]={phase=0.2500,spring=17,damping=0.70,scale=1.000,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[127]={phase=0.2917,spring=18,damping=0.71,scale=1.004,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[128]={phase=0.3333,spring=19,damping=0.72,scale=1.008,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[129]={phase=0.3750,spring=20,damping=0.73,scale=1.012,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[130]={phase=0.4167,spring=21,damping=0.74,scale=1.016,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[131]={phase=0.4583,spring=22,damping=0.75,scale=1.020,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[132]={phase=0.5000,spring=23,damping=0.76,scale=1.024,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[133]={phase=0.5417,spring=24,damping=0.77,scale=1.028,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[134]={phase=0.5833,spring=25,damping=0.78,scale=1.032,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[135]={phase=0.6250,spring=26,damping=0.79,scale=1.000,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[136]={phase=0.6667,spring=10,damping=0.80,scale=1.004,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[137]={phase=0.7083,spring=11,damping=0.81,scale=1.008,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[138]={phase=0.7500,spring=12,damping=0.82,scale=1.012,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[139]={phase=0.7917,spring=13,damping=0.83,scale=1.016,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[140]={phase=0.8333,spring=14,damping=0.84,scale=1.020,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[141]={phase=0.8750,spring=15,damping=0.85,scale=1.024,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[142]={phase=0.9167,spring=16,damping=0.86,scale=1.028,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[143]={phase=0.9583,spring=17,damping=0.87,scale=1.032,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[144]={phase=0.0000,spring=18,damping=0.64,scale=1.000,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[145]={phase=0.0417,spring=19,damping=0.65,scale=1.004,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[146]={phase=0.0833,spring=20,damping=0.66,scale=1.008,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[147]={phase=0.1250,spring=21,damping=0.67,scale=1.012,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[148]={phase=0.1667,spring=22,damping=0.68,scale=1.016,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[149]={phase=0.2083,spring=23,damping=0.69,scale=1.020,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[150]={phase=0.2500,spring=24,damping=0.70,scale=1.024,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[151]={phase=0.2917,spring=25,damping=0.71,scale=1.028,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[152]={phase=0.3333,spring=26,damping=0.72,scale=1.032,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[153]={phase=0.3750,spring=10,damping=0.73,scale=1.000,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[154]={phase=0.4167,spring=11,damping=0.74,scale=1.004,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[155]={phase=0.4583,spring=12,damping=0.75,scale=1.008,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[156]={phase=0.5000,spring=13,damping=0.76,scale=1.012,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[157]={phase=0.5417,spring=14,damping=0.77,scale=1.016,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[158]={phase=0.5833,spring=15,damping=0.78,scale=1.020,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[159]={phase=0.6250,spring=16,damping=0.79,scale=1.024,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[160]={phase=0.6667,spring=17,damping=0.80,scale=1.028,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[161]={phase=0.7083,spring=18,damping=0.81,scale=1.032,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[162]={phase=0.7500,spring=19,damping=0.82,scale=1.000,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[163]={phase=0.7917,spring=20,damping=0.83,scale=1.004,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[164]={phase=0.8333,spring=21,damping=0.84,scale=1.008,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[165]={phase=0.8750,spring=22,damping=0.85,scale=1.012,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[166]={phase=0.9167,spring=23,damping=0.86,scale=1.016,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[167]={phase=0.9583,spring=24,damping=0.87,scale=1.020,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[168]={phase=0.0000,spring=25,damping=0.64,scale=1.024,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[169]={phase=0.0417,spring=26,damping=0.65,scale=1.028,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[170]={phase=0.0833,spring=10,damping=0.66,scale=1.032,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[171]={phase=0.1250,spring=11,damping=0.67,scale=1.000,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[172]={phase=0.1667,spring=12,damping=0.68,scale=1.004,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[173]={phase=0.2083,spring=13,damping=0.69,scale=1.008,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[174]={phase=0.2500,spring=14,damping=0.70,scale=1.012,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[175]={phase=0.2917,spring=15,damping=0.71,scale=1.016,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[176]={phase=0.3333,spring=16,damping=0.72,scale=1.020,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[177]={phase=0.3750,spring=17,damping=0.73,scale=1.024,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[178]={phase=0.4167,spring=18,damping=0.74,scale=1.028,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[179]={phase=0.4583,spring=19,damping=0.75,scale=1.032,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[180]={phase=0.5000,spring=20,damping=0.76,scale=1.000,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[181]={phase=0.5417,spring=21,damping=0.77,scale=1.004,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[182]={phase=0.5833,spring=22,damping=0.78,scale=1.008,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[183]={phase=0.6250,spring=23,damping=0.79,scale=1.012,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[184]={phase=0.6667,spring=24,damping=0.80,scale=1.016,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[185]={phase=0.7083,spring=25,damping=0.81,scale=1.020,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[186]={phase=0.7500,spring=26,damping=0.82,scale=1.024,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[187]={phase=0.7917,spring=10,damping=0.83,scale=1.028,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[188]={phase=0.8333,spring=11,damping=0.84,scale=1.032,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[189]={phase=0.8750,spring=12,damping=0.85,scale=1.000,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[190]={phase=0.9167,spring=13,damping=0.86,scale=1.004,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[191]={phase=0.9583,spring=14,damping=0.87,scale=1.008,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[192]={phase=0.0000,spring=15,damping=0.64,scale=1.012,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[193]={phase=0.0417,spring=16,damping=0.65,scale=1.016,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[194]={phase=0.0833,spring=17,damping=0.66,scale=1.020,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[195]={phase=0.1250,spring=18,damping=0.67,scale=1.024,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[196]={phase=0.1667,spring=19,damping=0.68,scale=1.028,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[197]={phase=0.2083,spring=20,damping=0.69,scale=1.032,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[198]={phase=0.2500,spring=21,damping=0.70,scale=1.000,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[199]={phase=0.2917,spring=22,damping=0.71,scale=1.004,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[200]={phase=0.3333,spring=23,damping=0.72,scale=1.008,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[201]={phase=0.3750,spring=24,damping=0.73,scale=1.012,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[202]={phase=0.4167,spring=25,damping=0.74,scale=1.016,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[203]={phase=0.4583,spring=26,damping=0.75,scale=1.020,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[204]={phase=0.5000,spring=10,damping=0.76,scale=1.024,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[205]={phase=0.5417,spring=11,damping=0.77,scale=1.028,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[206]={phase=0.5833,spring=12,damping=0.78,scale=1.032,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[207]={phase=0.6250,spring=13,damping=0.79,scale=1.000,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[208]={phase=0.6667,spring=14,damping=0.80,scale=1.004,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[209]={phase=0.7083,spring=15,damping=0.81,scale=1.008,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[210]={phase=0.7500,spring=16,damping=0.82,scale=1.012,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[211]={phase=0.7917,spring=17,damping=0.83,scale=1.016,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[212]={phase=0.8333,spring=18,damping=0.84,scale=1.020,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[213]={phase=0.8750,spring=19,damping=0.85,scale=1.024,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[214]={phase=0.9167,spring=20,damping=0.86,scale=1.028,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[215]={phase=0.9583,spring=21,damping=0.87,scale=1.032,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[216]={phase=0.0000,spring=22,damping=0.64,scale=1.000,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[217]={phase=0.0417,spring=23,damping=0.65,scale=1.004,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[218]={phase=0.0833,spring=24,damping=0.66,scale=1.008,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[219]={phase=0.1250,spring=25,damping=0.67,scale=1.012,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[220]={phase=0.1667,spring=26,damping=0.68,scale=1.016,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[221]={phase=0.2083,spring=10,damping=0.69,scale=1.020,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[222]={phase=0.2500,spring=11,damping=0.70,scale=1.024,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[223]={phase=0.2917,spring=12,damping=0.71,scale=1.028,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[224]={phase=0.3333,spring=13,damping=0.72,scale=1.032,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[225]={phase=0.3750,spring=14,damping=0.73,scale=1.000,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[226]={phase=0.4167,spring=15,damping=0.74,scale=1.004,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[227]={phase=0.4583,spring=16,damping=0.75,scale=1.008,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[228]={phase=0.5000,spring=17,damping=0.76,scale=1.012,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[229]={phase=0.5417,spring=18,damping=0.77,scale=1.016,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[230]={phase=0.5833,spring=19,damping=0.78,scale=1.020,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[231]={phase=0.6250,spring=20,damping=0.79,scale=1.024,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[232]={phase=0.6667,spring=21,damping=0.80,scale=1.028,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[233]={phase=0.7083,spring=22,damping=0.81,scale=1.032,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[234]={phase=0.7500,spring=23,damping=0.82,scale=1.000,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[235]={phase=0.7917,spring=24,damping=0.83,scale=1.004,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[236]={phase=0.8333,spring=25,damping=0.84,scale=1.008,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[237]={phase=0.8750,spring=26,damping=0.85,scale=1.012,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[238]={phase=0.9167,spring=10,damping=0.86,scale=1.016,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[239]={phase=0.9583,spring=11,damping=0.87,scale=1.020,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[240]={phase=0.0000,spring=12,damping=0.64,scale=1.024,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[241]={phase=0.0417,spring=13,damping=0.65,scale=1.028,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[242]={phase=0.0833,spring=14,damping=0.66,scale=1.032,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[243]={phase=0.1250,spring=15,damping=0.67,scale=1.000,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[244]={phase=0.1667,spring=16,damping=0.68,scale=1.004,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[245]={phase=0.2083,spring=17,damping=0.69,scale=1.008,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[246]={phase=0.2500,spring=18,damping=0.70,scale=1.012,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[247]={phase=0.2917,spring=19,damping=0.71,scale=1.016,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[248]={phase=0.3333,spring=20,damping=0.72,scale=1.020,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[249]={phase=0.3750,spring=21,damping=0.73,scale=1.024,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[250]={phase=0.4167,spring=22,damping=0.74,scale=1.028,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[251]={phase=0.4583,spring=23,damping=0.75,scale=1.032,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[252]={phase=0.5000,spring=24,damping=0.76,scale=1.000,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[253]={phase=0.5417,spring=25,damping=0.77,scale=1.004,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[254]={phase=0.5833,spring=26,damping=0.78,scale=1.008,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[255]={phase=0.6250,spring=10,damping=0.79,scale=1.012,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[256]={phase=0.6667,spring=11,damping=0.80,scale=1.016,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[257]={phase=0.7083,spring=12,damping=0.81,scale=1.020,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[258]={phase=0.7500,spring=13,damping=0.82,scale=1.024,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[259]={phase=0.7917,spring=14,damping=0.83,scale=1.028,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[260]={phase=0.8333,spring=15,damping=0.84,scale=1.032,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[261]={phase=0.8750,spring=16,damping=0.85,scale=1.000,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[262]={phase=0.9167,spring=17,damping=0.86,scale=1.004,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[263]={phase=0.9583,spring=18,damping=0.87,scale=1.008,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[264]={phase=0.0000,spring=19,damping=0.64,scale=1.012,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[265]={phase=0.0417,spring=20,damping=0.65,scale=1.016,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[266]={phase=0.0833,spring=21,damping=0.66,scale=1.020,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[267]={phase=0.1250,spring=22,damping=0.67,scale=1.024,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[268]={phase=0.1667,spring=23,damping=0.68,scale=1.028,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[269]={phase=0.2083,spring=24,damping=0.69,scale=1.032,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[270]={phase=0.2500,spring=25,damping=0.70,scale=1.000,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[271]={phase=0.2917,spring=26,damping=0.71,scale=1.004,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[272]={phase=0.3333,spring=10,damping=0.72,scale=1.008,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[273]={phase=0.3750,spring=11,damping=0.73,scale=1.012,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[274]={phase=0.4167,spring=12,damping=0.74,scale=1.016,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[275]={phase=0.4583,spring=13,damping=0.75,scale=1.020,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[276]={phase=0.5000,spring=14,damping=0.76,scale=1.024,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[277]={phase=0.5417,spring=15,damping=0.77,scale=1.028,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[278]={phase=0.5833,spring=16,damping=0.78,scale=1.032,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[279]={phase=0.6250,spring=17,damping=0.79,scale=1.000,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[280]={phase=0.6667,spring=18,damping=0.80,scale=1.004,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[281]={phase=0.7083,spring=19,damping=0.81,scale=1.008,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[282]={phase=0.7500,spring=20,damping=0.82,scale=1.012,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[283]={phase=0.7917,spring=21,damping=0.83,scale=1.016,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[284]={phase=0.8333,spring=22,damping=0.84,scale=1.020,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[285]={phase=0.8750,spring=23,damping=0.85,scale=1.024,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[286]={phase=0.9167,spring=24,damping=0.86,scale=1.028,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[287]={phase=0.9583,spring=25,damping=0.87,scale=1.032,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[288]={phase=0.0000,spring=26,damping=0.64,scale=1.000,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[289]={phase=0.0417,spring=10,damping=0.65,scale=1.004,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[290]={phase=0.0833,spring=11,damping=0.66,scale=1.008,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[291]={phase=0.1250,spring=12,damping=0.67,scale=1.012,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[292]={phase=0.1667,spring=13,damping=0.68,scale=1.016,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[293]={phase=0.2083,spring=14,damping=0.69,scale=1.020,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[294]={phase=0.2500,spring=15,damping=0.70,scale=1.024,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[295]={phase=0.2917,spring=16,damping=0.71,scale=1.028,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[296]={phase=0.3333,spring=17,damping=0.72,scale=1.032,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[297]={phase=0.3750,spring=18,damping=0.73,scale=1.000,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[298]={phase=0.4167,spring=19,damping=0.74,scale=1.004,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[299]={phase=0.4583,spring=20,damping=0.75,scale=1.008,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[300]={phase=0.5000,spring=21,damping=0.76,scale=1.012,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[301]={phase=0.5417,spring=22,damping=0.77,scale=1.016,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[302]={phase=0.5833,spring=23,damping=0.78,scale=1.020,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[303]={phase=0.6250,spring=24,damping=0.79,scale=1.024,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[304]={phase=0.6667,spring=25,damping=0.80,scale=1.028,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[305]={phase=0.7083,spring=26,damping=0.81,scale=1.032,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[306]={phase=0.7500,spring=10,damping=0.82,scale=1.000,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[307]={phase=0.7917,spring=11,damping=0.83,scale=1.004,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[308]={phase=0.8333,spring=12,damping=0.84,scale=1.008,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[309]={phase=0.8750,spring=13,damping=0.85,scale=1.012,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[310]={phase=0.9167,spring=14,damping=0.86,scale=1.016,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[311]={phase=0.9583,spring=15,damping=0.87,scale=1.020,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[312]={phase=0.0000,spring=16,damping=0.64,scale=1.024,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[313]={phase=0.0417,spring=17,damping=0.65,scale=1.028,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[314]={phase=0.0833,spring=18,damping=0.66,scale=1.032,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[315]={phase=0.1250,spring=19,damping=0.67,scale=1.000,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[316]={phase=0.1667,spring=20,damping=0.68,scale=1.004,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[317]={phase=0.2083,spring=21,damping=0.69,scale=1.008,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[318]={phase=0.2500,spring=22,damping=0.70,scale=1.012,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[319]={phase=0.2917,spring=23,damping=0.71,scale=1.016,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[320]={phase=0.3333,spring=24,damping=0.72,scale=1.020,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[321]={phase=0.3750,spring=25,damping=0.73,scale=1.024,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[322]={phase=0.4167,spring=26,damping=0.74,scale=1.028,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[323]={phase=0.4583,spring=10,damping=0.75,scale=1.032,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[324]={phase=0.5000,spring=11,damping=0.76,scale=1.000,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[325]={phase=0.5417,spring=12,damping=0.77,scale=1.004,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[326]={phase=0.5833,spring=13,damping=0.78,scale=1.008,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[327]={phase=0.6250,spring=14,damping=0.79,scale=1.012,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[328]={phase=0.6667,spring=15,damping=0.80,scale=1.016,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[329]={phase=0.7083,spring=16,damping=0.81,scale=1.020,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[330]={phase=0.7500,spring=17,damping=0.82,scale=1.024,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[331]={phase=0.7917,spring=18,damping=0.83,scale=1.028,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[332]={phase=0.8333,spring=19,damping=0.84,scale=1.032,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[333]={phase=0.8750,spring=20,damping=0.85,scale=1.000,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[334]={phase=0.9167,spring=21,damping=0.86,scale=1.004,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[335]={phase=0.9583,spring=22,damping=0.87,scale=1.008,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[336]={phase=0.0000,spring=23,damping=0.64,scale=1.012,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[337]={phase=0.0417,spring=24,damping=0.65,scale=1.016,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[338]={phase=0.0833,spring=25,damping=0.66,scale=1.020,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[339]={phase=0.1250,spring=26,damping=0.67,scale=1.024,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[340]={phase=0.1667,spring=10,damping=0.68,scale=1.028,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[341]={phase=0.2083,spring=11,damping=0.69,scale=1.032,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[342]={phase=0.2500,spring=12,damping=0.70,scale=1.000,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[343]={phase=0.2917,spring=13,damping=0.71,scale=1.004,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[344]={phase=0.3333,spring=14,damping=0.72,scale=1.008,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[345]={phase=0.3750,spring=15,damping=0.73,scale=1.012,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[346]={phase=0.4167,spring=16,damping=0.74,scale=1.016,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[347]={phase=0.4583,spring=17,damping=0.75,scale=1.020,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[348]={phase=0.5000,spring=18,damping=0.76,scale=1.024,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[349]={phase=0.5417,spring=19,damping=0.77,scale=1.028,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[350]={phase=0.5833,spring=20,damping=0.78,scale=1.032,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[351]={phase=0.6250,spring=21,damping=0.79,scale=1.000,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[352]={phase=0.6667,spring=22,damping=0.80,scale=1.004,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[353]={phase=0.7083,spring=23,damping=0.81,scale=1.008,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[354]={phase=0.7500,spring=24,damping=0.82,scale=1.012,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[355]={phase=0.7917,spring=25,damping=0.83,scale=1.016,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[356]={phase=0.8333,spring=26,damping=0.84,scale=1.020,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[357]={phase=0.8750,spring=10,damping=0.85,scale=1.024,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[358]={phase=0.9167,spring=11,damping=0.86,scale=1.028,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[359]={phase=0.9583,spring=12,damping=0.87,scale=1.032,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[360]={phase=0.0000,spring=13,damping=0.64,scale=1.000,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[361]={phase=0.0417,spring=14,damping=0.65,scale=1.004,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[362]={phase=0.0833,spring=15,damping=0.66,scale=1.008,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[363]={phase=0.1250,spring=16,damping=0.67,scale=1.012,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[364]={phase=0.1667,spring=17,damping=0.68,scale=1.016,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[365]={phase=0.2083,spring=18,damping=0.69,scale=1.020,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[366]={phase=0.2500,spring=19,damping=0.70,scale=1.024,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[367]={phase=0.2917,spring=20,damping=0.71,scale=1.028,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[368]={phase=0.3333,spring=21,damping=0.72,scale=1.032,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[369]={phase=0.3750,spring=22,damping=0.73,scale=1.000,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[370]={phase=0.4167,spring=23,damping=0.74,scale=1.004,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[371]={phase=0.4583,spring=24,damping=0.75,scale=1.008,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[372]={phase=0.5000,spring=25,damping=0.76,scale=1.012,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[373]={phase=0.5417,spring=26,damping=0.77,scale=1.016,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[374]={phase=0.5833,spring=10,damping=0.78,scale=1.020,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[375]={phase=0.6250,spring=11,damping=0.79,scale=1.024,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[376]={phase=0.6667,spring=12,damping=0.80,scale=1.028,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[377]={phase=0.7083,spring=13,damping=0.81,scale=1.032,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[378]={phase=0.7500,spring=14,damping=0.82,scale=1.000,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[379]={phase=0.7917,spring=15,damping=0.83,scale=1.004,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[380]={phase=0.8333,spring=16,damping=0.84,scale=1.008,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[381]={phase=0.8750,spring=17,damping=0.85,scale=1.012,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[382]={phase=0.9167,spring=18,damping=0.86,scale=1.016,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[383]={phase=0.9583,spring=19,damping=0.87,scale=1.020,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[384]={phase=0.0000,spring=20,damping=0.64,scale=1.024,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[385]={phase=0.0417,spring=21,damping=0.65,scale=1.028,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[386]={phase=0.0833,spring=22,damping=0.66,scale=1.032,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[387]={phase=0.1250,spring=23,damping=0.67,scale=1.000,rotation=4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[388]={phase=0.1667,spring=24,damping=0.68,scale=1.004,rotation=5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[389]={phase=0.2083,spring=25,damping=0.69,scale=1.008,rotation=6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[390]={phase=0.2500,spring=26,damping=0.70,scale=1.012,rotation=-6,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[391]={phase=0.2917,spring=10,damping=0.71,scale=1.016,rotation=-5,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[392]={phase=0.3333,spring=11,damping=0.72,scale=1.020,rotation=-4,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[393]={phase=0.3750,spring=12,damping=0.73,scale=1.024,rotation=-3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[394]={phase=0.4167,spring=13,damping=0.74,scale=1.028,rotation=-2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[395]={phase=0.4583,spring=14,damping=0.75,scale=1.032,rotation=-1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[396]={phase=0.5000,spring=15,damping=0.76,scale=1.000,rotation=0,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[397]={phase=0.5417,spring=16,damping=0.77,scale=1.004,rotation=1,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[398]={phase=0.5833,spring=17,damping=0.78,scale=1.008,rotation=2,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[399]={phase=0.6250,spring=18,damping=0.79,scale=1.012,rotation=3,curve="quint_back",visual="liquid_glass"}
V8_MOTION_LIBRARY[400]={phase=0.6667,spring=19,damping=0.80,scale=1.016,rotation=4,curve="quint_back",visual="liquid_glass"}

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

-- V8 CINEMATIC FRAME NOTES
-- frame 00001: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00002: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00003: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00004: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00005: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00006: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00007: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00008: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00009: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00010: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00011: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00012: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00013: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00014: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00015: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00016: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00017: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00018: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00019: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00020: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00021: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00022: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00023: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00024: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00025: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00026: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00027: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00028: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00029: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00030: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00031: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00032: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00033: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00034: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00035: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00036: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00037: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00038: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00039: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00040: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00041: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00042: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00043: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00044: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00045: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00046: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00047: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00048: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00049: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00050: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00051: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00052: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00053: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00054: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00055: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00056: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00057: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00058: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00059: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00060: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00061: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00062: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00063: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00064: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00065: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00066: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00067: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00068: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00069: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00070: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00071: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00072: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00073: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00074: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00075: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00076: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00077: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00078: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00079: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00080: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00081: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00082: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00083: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00084: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00085: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00086: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00087: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00088: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00089: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00090: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00091: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00092: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00093: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00094: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00095: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00096: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00097: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00098: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00099: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00100: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00101: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00102: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00103: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00104: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00105: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00106: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00107: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00108: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00109: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00110: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00111: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00112: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00113: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00114: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00115: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00116: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00117: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00118: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00119: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00120: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00121: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00122: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00123: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00124: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00125: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00126: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00127: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00128: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00129: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00130: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00131: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00132: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00133: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00134: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00135: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00136: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00137: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00138: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00139: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00140: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00141: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00142: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00143: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00144: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00145: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00146: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00147: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00148: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00149: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00150: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00151: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00152: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00153: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00154: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00155: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00156: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00157: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00158: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00159: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00160: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00161: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00162: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00163: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00164: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00165: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00166: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00167: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00168: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00169: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00170: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00171: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00172: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00173: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00174: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00175: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00176: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00177: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00178: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00179: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00180: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00181: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00182: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00183: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00184: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00185: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00186: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00187: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00188: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00189: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00190: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00191: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00192: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00193: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00194: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00195: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00196: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00197: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00198: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00199: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00200: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00201: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00202: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00203: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00204: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00205: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00206: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00207: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00208: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00209: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00210: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00211: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00212: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00213: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00214: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00215: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00216: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00217: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00218: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00219: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00220: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00221: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00222: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00223: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00224: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00225: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00226: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00227: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00228: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00229: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00230: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00231: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00232: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00233: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00234: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00235: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00236: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00237: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00238: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00239: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00240: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00241: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00242: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00243: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00244: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00245: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00246: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00247: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00248: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00249: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00250: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00251: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00252: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00253: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00254: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00255: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00256: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00257: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00258: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00259: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00260: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00261: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00262: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00263: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00264: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00265: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00266: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00267: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00268: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00269: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00270: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00271: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00272: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00273: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00274: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00275: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00276: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00277: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00278: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00279: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00280: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00281: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00282: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00283: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00284: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00285: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00286: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00287: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00288: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00289: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00290: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00291: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00292: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00293: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00294: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00295: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00296: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00297: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00298: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00299: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00300: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00301: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00302: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00303: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00304: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00305: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00306: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00307: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00308: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00309: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00310: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00311: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00312: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00313: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00314: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00315: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00316: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00317: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00318: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00319: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00320: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00321: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00322: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00323: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00324: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00325: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00326: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00327: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00328: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00329: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00330: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00331: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00332: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00333: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00334: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00335: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00336: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00337: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00338: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00339: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00340: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00341: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00342: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00343: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00344: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00345: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00346: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00347: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00348: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00349: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00350: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00351: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00352: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00353: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00354: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00355: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00356: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00357: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00358: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00359: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00360: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00361: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00362: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00363: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00364: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00365: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00366: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00367: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00368: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00369: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00370: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00371: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00372: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00373: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00374: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00375: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00376: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00377: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00378: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00379: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00380: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00381: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00382: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00383: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00384: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00385: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00386: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00387: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00388: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00389: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00390: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00391: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00392: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00393: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00394: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00395: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00396: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00397: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00398: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00399: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00400: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00401: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00402: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00403: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00404: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00405: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00406: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00407: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00408: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00409: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00410: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00411: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00412: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00413: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00414: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00415: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00416: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00417: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00418: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00419: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00420: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00421: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00422: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00423: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00424: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00425: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00426: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00427: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00428: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00429: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00430: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00431: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00432: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00433: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00434: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00435: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00436: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00437: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00438: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00439: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00440: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00441: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00442: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00443: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00444: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00445: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00446: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00447: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00448: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00449: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00450: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00451: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00452: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00453: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00454: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00455: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00456: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00457: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00458: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00459: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00460: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00461: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00462: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00463: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00464: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00465: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00466: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00467: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00468: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00469: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00470: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00471: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00472: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00473: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00474: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00475: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00476: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00477: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00478: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00479: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00480: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00481: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00482: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00483: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00484: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00485: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00486: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00487: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00488: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00489: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00490: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00491: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00492: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00493: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00494: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00495: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00496: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00497: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00498: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00499: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00500: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00501: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00502: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00503: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00504: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00505: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00506: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00507: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00508: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00509: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00510: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00511: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00512: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00513: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00514: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00515: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00516: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00517: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00518: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00519: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00520: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00521: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00522: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00523: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00524: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00525: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00526: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00527: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00528: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00529: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00530: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00531: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00532: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00533: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00534: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00535: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00536: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00537: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00538: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00539: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00540: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00541: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00542: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00543: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00544: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00545: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00546: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00547: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00548: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00549: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00550: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00551: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00552: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00553: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00554: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00555: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00556: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00557: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00558: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00559: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00560: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00561: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00562: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00563: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00564: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00565: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00566: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00567: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00568: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00569: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00570: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00571: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00572: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00573: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00574: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00575: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00576: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00577: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00578: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00579: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00580: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00581: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00582: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00583: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00584: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00585: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00586: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00587: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00588: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00589: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00590: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00591: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00592: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00593: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00594: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00595: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00596: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00597: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00598: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00599: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00600: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00601: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00602: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00603: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00604: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00605: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00606: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00607: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00608: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00609: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00610: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00611: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00612: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00613: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00614: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00615: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00616: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00617: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00618: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00619: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00620: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00621: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00622: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00623: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00624: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00625: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00626: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00627: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00628: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00629: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00630: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00631: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00632: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00633: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00634: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00635: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00636: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00637: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00638: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00639: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00640: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00641: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00642: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00643: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00644: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00645: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00646: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00647: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00648: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00649: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00650: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00651: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00652: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00653: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00654: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00655: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00656: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00657: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00658: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00659: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00660: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00661: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00662: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00663: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00664: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00665: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00666: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00667: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00668: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00669: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00670: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00671: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00672: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00673: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00674: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00675: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00676: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00677: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00678: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00679: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00680: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00681: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00682: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00683: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00684: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00685: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00686: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00687: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00688: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00689: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00690: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00691: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00692: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00693: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00694: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00695: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00696: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00697: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00698: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00699: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00700: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00701: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00702: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00703: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00704: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00705: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00706: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00707: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00708: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00709: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00710: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00711: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00712: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00713: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00714: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00715: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00716: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00717: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00718: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00719: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00720: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00721: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00722: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00723: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00724: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00725: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00726: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00727: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00728: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00729: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00730: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00731: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00732: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00733: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00734: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00735: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00736: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00737: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00738: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00739: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00740: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00741: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00742: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00743: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00744: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00745: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00746: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00747: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00748: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00749: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00750: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00751: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00752: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00753: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00754: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00755: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00756: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00757: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00758: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00759: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00760: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00761: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00762: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00763: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00764: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00765: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00766: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00767: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00768: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00769: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00770: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00771: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00772: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00773: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00774: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00775: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00776: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00777: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00778: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00779: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00780: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00781: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00782: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00783: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00784: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00785: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00786: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00787: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00788: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00789: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00790: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00791: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00792: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00793: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00794: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00795: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00796: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00797: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00798: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00799: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00800: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00801: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00802: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00803: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00804: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00805: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00806: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00807: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00808: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00809: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00810: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00811: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00812: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00813: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00814: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00815: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00816: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00817: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00818: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00819: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00820: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00821: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00822: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00823: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00824: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00825: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00826: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00827: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00828: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00829: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00830: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00831: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00832: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00833: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00834: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00835: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00836: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00837: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00838: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00839: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00840: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00841: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00842: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00843: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00844: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00845: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00846: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00847: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00848: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00849: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00850: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00851: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00852: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00853: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00854: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00855: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00856: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00857: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00858: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00859: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00860: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00861: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00862: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00863: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00864: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00865: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00866: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00867: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00868: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00869: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00870: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00871: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00872: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00873: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00874: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00875: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00876: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00877: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00878: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00879: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00880: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00881: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00882: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00883: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00884: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00885: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00886: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00887: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00888: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00889: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00890: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00891: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00892: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00893: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00894: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00895: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00896: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00897: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00898: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00899: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00900: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00901: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00902: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00903: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00904: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00905: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00906: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00907: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00908: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00909: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00910: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00911: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00912: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00913: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00914: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00915: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00916: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00917: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00918: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00919: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00920: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00921: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00922: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00923: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00924: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00925: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00926: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00927: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00928: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00929: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00930: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00931: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00932: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00933: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00934: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00935: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00936: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00937: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00938: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00939: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00940: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00941: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00942: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00943: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00944: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00945: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00946: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00947: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00948: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00949: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00950: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00951: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00952: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00953: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00954: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00955: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00956: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00957: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00958: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00959: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00960: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00961: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00962: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00963: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00964: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00965: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00966: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00967: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00968: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00969: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00970: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00971: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00972: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00973: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00974: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00975: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00976: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00977: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00978: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00979: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00980: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00981: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00982: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00983: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00984: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00985: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00986: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00987: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00988: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00989: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00990: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00991: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00992: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00993: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00994: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00995: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00996: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
-- frame 00997: spring interpolation, liquid squash, glass shimmer, petal sway, ring orbit, touch ripple, mobile-safe composition
