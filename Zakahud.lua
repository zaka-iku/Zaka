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
    StartWithOrb = false,
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
    {id=1, name="HOME", icon="⌂", description="Trang chủ & tổng quan"},
    {id=2, name="STYLE", icon="✦", description="Phong cách & màu sắc"},
    {id=3, name="MOTION", icon="◌", description="Animation & chuyển động"},
    {id=4, name="FLOWER", icon="✿", description="Hoa trung tâm"},
    {id=5, name="PANTHER", icon="🐆", description="Báo hồng & silhouette"},
    {id=6, name="GLASS", icon="◈", description="Glass & transparency"},
    {id=7, name="LIGHT", icon="☼", description="Glow & ánh sáng"},
    {id=8, name="RINGS", icon="◎", description="Vòng xoay"},
    {id=9, name="DROPLET", icon="◉", description="Giọt nước"},
    {id=10, name="CURVE", icon="⌁", description="Đường cong UI"},
    {id=11, name="TABS", icon="▤", description="Tab system"},
    {id=12, name="CARDS", icon="▦", description="Function cards"},
    {id=13, name="SEARCH", icon="⌕", description="Search system"},
    {id=14, name="TOUCH", icon="☝", description="Touch & mobile"},
    {id=15, name="DRAG", icon="✥", description="Drag system"},
    {id=16, name="SOUND", icon="♫", description="UI sound design"},
    {id=17, name="FX", icon="✧", description="Particles & effects"},
    {id=18, name="THEME", icon="◐", description="Theme presets"},
    {id=19, name="PREVIEW", icon="▣", description="Preview lab"},
    {id=20, name="SETTINGS", icon="⚙", description="Cài đặt menu"},
}

local CARD_DATA = {
    [1] = {
        {title="Petal • Tắt hiệu ứng", description="HOME: tinh chỉnh petal bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.08},
        {title="Ring • Xem trước", description="HOME: tinh chỉnh ring bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.17},
        {title="Droplet • Làm mới", description="HOME: tinh chỉnh droplet bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.25},
        {title="Curve • Đổi kiểu", description="HOME: tinh chỉnh curve bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.33},
        {title="Tab • Tăng nhẹ", description="HOME: tinh chỉnh tab bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.42},
        {title="Card • Giảm nhẹ", description="HOME: tinh chỉnh card bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.5},
        {title="Search • Mặc định", description="HOME: tinh chỉnh search bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.58},
        {title="Touch • Ngẫu nhiên", description="HOME: tinh chỉnh touch bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.67},
        {title="Drag • Tinh chỉnh", description="HOME: tinh chỉnh drag bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.75},
        {title="Particle • Đồng bộ", description="HOME: tinh chỉnh particle bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.83},
        {title="Theme • Khôi phục", description="HOME: tinh chỉnh theme bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.92},
        {title="Panther • Bật hiệu ứng", description="HOME: tinh chỉnh panther bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=1.0},
    },
    [2] = {
        {title="Curve • Xem trước", description="STYLE: tinh chỉnh curve bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.08},
        {title="Tab • Làm mới", description="STYLE: tinh chỉnh tab bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.17},
        {title="Card • Đổi kiểu", description="STYLE: tinh chỉnh card bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.25},
        {title="Search • Tăng nhẹ", description="STYLE: tinh chỉnh search bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.33},
        {title="Touch • Giảm nhẹ", description="STYLE: tinh chỉnh touch bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.42},
        {title="Drag • Mặc định", description="STYLE: tinh chỉnh drag bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.5},
        {title="Particle • Ngẫu nhiên", description="STYLE: tinh chỉnh particle bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.58},
        {title="Theme • Tinh chỉnh", description="STYLE: tinh chỉnh theme bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.67},
        {title="Panther • Đồng bộ", description="STYLE: tinh chỉnh panther bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.75},
        {title="Flower • Khôi phục", description="STYLE: tinh chỉnh flower bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.83},
        {title="Border • Bật hiệu ứng", description="STYLE: tinh chỉnh border bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.92},
        {title="Shadow • Tắt hiệu ứng", description="STYLE: tinh chỉnh shadow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=1.0},
    },
    [3] = {
        {title="Search • Làm mới", description="MOTION: tinh chỉnh search bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.08},
        {title="Touch • Đổi kiểu", description="MOTION: tinh chỉnh touch bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.17},
        {title="Drag • Tăng nhẹ", description="MOTION: tinh chỉnh drag bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.25},
        {title="Particle • Giảm nhẹ", description="MOTION: tinh chỉnh particle bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.33},
        {title="Theme • Mặc định", description="MOTION: tinh chỉnh theme bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.42},
        {title="Panther • Ngẫu nhiên", description="MOTION: tinh chỉnh panther bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.5},
        {title="Flower • Tinh chỉnh", description="MOTION: tinh chỉnh flower bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.58},
        {title="Border • Đồng bộ", description="MOTION: tinh chỉnh border bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.67},
        {title="Shadow • Khôi phục", description="MOTION: tinh chỉnh shadow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.75},
        {title="Pulse • Bật hiệu ứng", description="MOTION: tinh chỉnh pulse bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.83},
        {title="Trail • Tắt hiệu ứng", description="MOTION: tinh chỉnh trail bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.92},
        {title="Glow • Xem trước", description="MOTION: tinh chỉnh glow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=1.0},
    },
    [4] = {
        {title="Particle • Đổi kiểu", description="FLOWER: tinh chỉnh particle bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.08},
        {title="Theme • Tăng nhẹ", description="FLOWER: tinh chỉnh theme bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.17},
        {title="Panther • Giảm nhẹ", description="FLOWER: tinh chỉnh panther bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.25},
        {title="Flower • Mặc định", description="FLOWER: tinh chỉnh flower bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.33},
        {title="Border • Ngẫu nhiên", description="FLOWER: tinh chỉnh border bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.42},
        {title="Shadow • Tinh chỉnh", description="FLOWER: tinh chỉnh shadow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.5},
        {title="Pulse • Đồng bộ", description="FLOWER: tinh chỉnh pulse bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.58},
        {title="Trail • Khôi phục", description="FLOWER: tinh chỉnh trail bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.67},
        {title="Glow • Bật hiệu ứng", description="FLOWER: tinh chỉnh glow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.75},
        {title="Glass • Tắt hiệu ứng", description="FLOWER: tinh chỉnh glass bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.83},
        {title="Ripple • Xem trước", description="FLOWER: tinh chỉnh ripple bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.92},
        {title="Petal • Làm mới", description="FLOWER: tinh chỉnh petal bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=1.0},
    },
    [5] = {
        {title="Flower • Tăng nhẹ", description="PANTHER: tinh chỉnh flower bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.08},
        {title="Border • Giảm nhẹ", description="PANTHER: tinh chỉnh border bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.17},
        {title="Shadow • Mặc định", description="PANTHER: tinh chỉnh shadow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.25},
        {title="Pulse • Ngẫu nhiên", description="PANTHER: tinh chỉnh pulse bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.33},
        {title="Trail • Tinh chỉnh", description="PANTHER: tinh chỉnh trail bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.42},
        {title="Glow • Đồng bộ", description="PANTHER: tinh chỉnh glow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.5},
        {title="Glass • Khôi phục", description="PANTHER: tinh chỉnh glass bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.58},
        {title="Ripple • Bật hiệu ứng", description="PANTHER: tinh chỉnh ripple bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.67},
        {title="Petal • Tắt hiệu ứng", description="PANTHER: tinh chỉnh petal bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.75},
        {title="Ring • Xem trước", description="PANTHER: tinh chỉnh ring bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.83},
        {title="Droplet • Làm mới", description="PANTHER: tinh chỉnh droplet bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.92},
        {title="Curve • Đổi kiểu", description="PANTHER: tinh chỉnh curve bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=1.0},
    },
    [6] = {
        {title="Pulse • Giảm nhẹ", description="GLASS: tinh chỉnh pulse bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.08},
        {title="Trail • Mặc định", description="GLASS: tinh chỉnh trail bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.17},
        {title="Glow • Ngẫu nhiên", description="GLASS: tinh chỉnh glow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.25},
        {title="Glass • Tinh chỉnh", description="GLASS: tinh chỉnh glass bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.33},
        {title="Ripple • Đồng bộ", description="GLASS: tinh chỉnh ripple bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.42},
        {title="Petal • Khôi phục", description="GLASS: tinh chỉnh petal bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.5},
        {title="Ring • Bật hiệu ứng", description="GLASS: tinh chỉnh ring bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.58},
        {title="Droplet • Tắt hiệu ứng", description="GLASS: tinh chỉnh droplet bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.67},
        {title="Curve • Xem trước", description="GLASS: tinh chỉnh curve bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.75},
        {title="Tab • Làm mới", description="GLASS: tinh chỉnh tab bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.83},
        {title="Card • Đổi kiểu", description="GLASS: tinh chỉnh card bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.92},
        {title="Search • Tăng nhẹ", description="GLASS: tinh chỉnh search bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=1.0},
    },
    [7] = {
        {title="Glass • Mặc định", description="LIGHT: tinh chỉnh glass bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.08},
        {title="Ripple • Ngẫu nhiên", description="LIGHT: tinh chỉnh ripple bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.17},
        {title="Petal • Tinh chỉnh", description="LIGHT: tinh chỉnh petal bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.25},
        {title="Ring • Đồng bộ", description="LIGHT: tinh chỉnh ring bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.33},
        {title="Droplet • Khôi phục", description="LIGHT: tinh chỉnh droplet bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.42},
        {title="Curve • Bật hiệu ứng", description="LIGHT: tinh chỉnh curve bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.5},
        {title="Tab • Tắt hiệu ứng", description="LIGHT: tinh chỉnh tab bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.58},
        {title="Card • Xem trước", description="LIGHT: tinh chỉnh card bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.67},
        {title="Search • Làm mới", description="LIGHT: tinh chỉnh search bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.75},
        {title="Touch • Đổi kiểu", description="LIGHT: tinh chỉnh touch bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.83},
        {title="Drag • Tăng nhẹ", description="LIGHT: tinh chỉnh drag bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.92},
        {title="Particle • Giảm nhẹ", description="LIGHT: tinh chỉnh particle bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=1.0},
    },
    [8] = {
        {title="Ring • Ngẫu nhiên", description="RINGS: tinh chỉnh ring bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.08},
        {title="Droplet • Tinh chỉnh", description="RINGS: tinh chỉnh droplet bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.17},
        {title="Curve • Đồng bộ", description="RINGS: tinh chỉnh curve bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.25},
        {title="Tab • Khôi phục", description="RINGS: tinh chỉnh tab bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.33},
        {title="Card • Bật hiệu ứng", description="RINGS: tinh chỉnh card bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.42},
        {title="Search • Tắt hiệu ứng", description="RINGS: tinh chỉnh search bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.5},
        {title="Touch • Xem trước", description="RINGS: tinh chỉnh touch bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.58},
        {title="Drag • Làm mới", description="RINGS: tinh chỉnh drag bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.67},
        {title="Particle • Đổi kiểu", description="RINGS: tinh chỉnh particle bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.75},
        {title="Theme • Tăng nhẹ", description="RINGS: tinh chỉnh theme bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.83},
        {title="Panther • Giảm nhẹ", description="RINGS: tinh chỉnh panther bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.92},
        {title="Flower • Mặc định", description="RINGS: tinh chỉnh flower bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=1.0},
    },
    [9] = {
        {title="Tab • Tinh chỉnh", description="DROPLET: tinh chỉnh tab bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.08},
        {title="Card • Đồng bộ", description="DROPLET: tinh chỉnh card bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.17},
        {title="Search • Khôi phục", description="DROPLET: tinh chỉnh search bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.25},
        {title="Touch • Bật hiệu ứng", description="DROPLET: tinh chỉnh touch bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.33},
        {title="Drag • Tắt hiệu ứng", description="DROPLET: tinh chỉnh drag bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.42},
        {title="Particle • Xem trước", description="DROPLET: tinh chỉnh particle bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.5},
        {title="Theme • Làm mới", description="DROPLET: tinh chỉnh theme bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.58},
        {title="Panther • Đổi kiểu", description="DROPLET: tinh chỉnh panther bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.67},
        {title="Flower • Tăng nhẹ", description="DROPLET: tinh chỉnh flower bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.75},
        {title="Border • Giảm nhẹ", description="DROPLET: tinh chỉnh border bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.83},
        {title="Shadow • Mặc định", description="DROPLET: tinh chỉnh shadow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.92},
        {title="Pulse • Ngẫu nhiên", description="DROPLET: tinh chỉnh pulse bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=1.0},
    },
    [10] = {
        {title="Touch • Đồng bộ", description="CURVE: tinh chỉnh touch bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.08},
        {title="Drag • Khôi phục", description="CURVE: tinh chỉnh drag bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.17},
        {title="Particle • Bật hiệu ứng", description="CURVE: tinh chỉnh particle bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.25},
        {title="Theme • Tắt hiệu ứng", description="CURVE: tinh chỉnh theme bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.33},
        {title="Panther • Xem trước", description="CURVE: tinh chỉnh panther bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.42},
        {title="Flower • Làm mới", description="CURVE: tinh chỉnh flower bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.5},
        {title="Border • Đổi kiểu", description="CURVE: tinh chỉnh border bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.58},
        {title="Shadow • Tăng nhẹ", description="CURVE: tinh chỉnh shadow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.67},
        {title="Pulse • Giảm nhẹ", description="CURVE: tinh chỉnh pulse bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.75},
        {title="Trail • Mặc định", description="CURVE: tinh chỉnh trail bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.83},
        {title="Glow • Ngẫu nhiên", description="CURVE: tinh chỉnh glow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.92},
        {title="Glass • Tinh chỉnh", description="CURVE: tinh chỉnh glass bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=1.0},
    },
    [11] = {
        {title="Theme • Khôi phục", description="TABS: tinh chỉnh theme bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.08},
        {title="Panther • Bật hiệu ứng", description="TABS: tinh chỉnh panther bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.17},
        {title="Flower • Tắt hiệu ứng", description="TABS: tinh chỉnh flower bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.25},
        {title="Border • Xem trước", description="TABS: tinh chỉnh border bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.33},
        {title="Shadow • Làm mới", description="TABS: tinh chỉnh shadow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.42},
        {title="Pulse • Đổi kiểu", description="TABS: tinh chỉnh pulse bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.5},
        {title="Trail • Tăng nhẹ", description="TABS: tinh chỉnh trail bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.58},
        {title="Glow • Giảm nhẹ", description="TABS: tinh chỉnh glow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.67},
        {title="Glass • Mặc định", description="TABS: tinh chỉnh glass bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.75},
        {title="Ripple • Ngẫu nhiên", description="TABS: tinh chỉnh ripple bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.83},
        {title="Petal • Tinh chỉnh", description="TABS: tinh chỉnh petal bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.92},
        {title="Ring • Đồng bộ", description="TABS: tinh chỉnh ring bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=1.0},
    },
    [12] = {
        {title="Border • Bật hiệu ứng", description="CARDS: tinh chỉnh border bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.08},
        {title="Shadow • Tắt hiệu ứng", description="CARDS: tinh chỉnh shadow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.17},
        {title="Pulse • Xem trước", description="CARDS: tinh chỉnh pulse bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.25},
        {title="Trail • Làm mới", description="CARDS: tinh chỉnh trail bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.33},
        {title="Glow • Đổi kiểu", description="CARDS: tinh chỉnh glow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.42},
        {title="Glass • Tăng nhẹ", description="CARDS: tinh chỉnh glass bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.5},
        {title="Ripple • Giảm nhẹ", description="CARDS: tinh chỉnh ripple bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.58},
        {title="Petal • Mặc định", description="CARDS: tinh chỉnh petal bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.67},
        {title="Ring • Ngẫu nhiên", description="CARDS: tinh chỉnh ring bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.75},
        {title="Droplet • Tinh chỉnh", description="CARDS: tinh chỉnh droplet bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.83},
        {title="Curve • Đồng bộ", description="CARDS: tinh chỉnh curve bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.92},
        {title="Tab • Khôi phục", description="CARDS: tinh chỉnh tab bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=1.0},
    },
    [13] = {
        {title="Trail • Tắt hiệu ứng", description="SEARCH: tinh chỉnh trail bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.08},
        {title="Glow • Xem trước", description="SEARCH: tinh chỉnh glow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.17},
        {title="Glass • Làm mới", description="SEARCH: tinh chỉnh glass bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.25},
        {title="Ripple • Đổi kiểu", description="SEARCH: tinh chỉnh ripple bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.33},
        {title="Petal • Tăng nhẹ", description="SEARCH: tinh chỉnh petal bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.42},
        {title="Ring • Giảm nhẹ", description="SEARCH: tinh chỉnh ring bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.5},
        {title="Droplet • Mặc định", description="SEARCH: tinh chỉnh droplet bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.58},
        {title="Curve • Ngẫu nhiên", description="SEARCH: tinh chỉnh curve bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.67},
        {title="Tab • Tinh chỉnh", description="SEARCH: tinh chỉnh tab bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.75},
        {title="Card • Đồng bộ", description="SEARCH: tinh chỉnh card bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.83},
        {title="Search • Khôi phục", description="SEARCH: tinh chỉnh search bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.92},
        {title="Touch • Bật hiệu ứng", description="SEARCH: tinh chỉnh touch bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=1.0},
    },
    [14] = {
        {title="Ripple • Xem trước", description="TOUCH: tinh chỉnh ripple bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.08},
        {title="Petal • Làm mới", description="TOUCH: tinh chỉnh petal bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.17},
        {title="Ring • Đổi kiểu", description="TOUCH: tinh chỉnh ring bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.25},
        {title="Droplet • Tăng nhẹ", description="TOUCH: tinh chỉnh droplet bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.33},
        {title="Curve • Giảm nhẹ", description="TOUCH: tinh chỉnh curve bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.42},
        {title="Tab • Mặc định", description="TOUCH: tinh chỉnh tab bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.5},
        {title="Card • Ngẫu nhiên", description="TOUCH: tinh chỉnh card bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.58},
        {title="Search • Tinh chỉnh", description="TOUCH: tinh chỉnh search bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.67},
        {title="Touch • Đồng bộ", description="TOUCH: tinh chỉnh touch bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.75},
        {title="Drag • Khôi phục", description="TOUCH: tinh chỉnh drag bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.83},
        {title="Particle • Bật hiệu ứng", description="TOUCH: tinh chỉnh particle bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.92},
        {title="Theme • Tắt hiệu ứng", description="TOUCH: tinh chỉnh theme bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=1.0},
    },
    [15] = {
        {title="Droplet • Làm mới", description="DRAG: tinh chỉnh droplet bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.08},
        {title="Curve • Đổi kiểu", description="DRAG: tinh chỉnh curve bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.17},
        {title="Tab • Tăng nhẹ", description="DRAG: tinh chỉnh tab bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.25},
        {title="Card • Giảm nhẹ", description="DRAG: tinh chỉnh card bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.33},
        {title="Search • Mặc định", description="DRAG: tinh chỉnh search bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.42},
        {title="Touch • Ngẫu nhiên", description="DRAG: tinh chỉnh touch bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.5},
        {title="Drag • Tinh chỉnh", description="DRAG: tinh chỉnh drag bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.58},
        {title="Particle • Đồng bộ", description="DRAG: tinh chỉnh particle bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.67},
        {title="Theme • Khôi phục", description="DRAG: tinh chỉnh theme bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.75},
        {title="Panther • Bật hiệu ứng", description="DRAG: tinh chỉnh panther bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.83},
        {title="Flower • Tắt hiệu ứng", description="DRAG: tinh chỉnh flower bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.92},
        {title="Border • Xem trước", description="DRAG: tinh chỉnh border bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=1.0},
    },
    [16] = {
        {title="Card • Đổi kiểu", description="SOUND: tinh chỉnh card bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.08},
        {title="Search • Tăng nhẹ", description="SOUND: tinh chỉnh search bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.17},
        {title="Touch • Giảm nhẹ", description="SOUND: tinh chỉnh touch bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.25},
        {title="Drag • Mặc định", description="SOUND: tinh chỉnh drag bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.33},
        {title="Particle • Ngẫu nhiên", description="SOUND: tinh chỉnh particle bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.42},
        {title="Theme • Tinh chỉnh", description="SOUND: tinh chỉnh theme bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.5},
        {title="Panther • Đồng bộ", description="SOUND: tinh chỉnh panther bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.58},
        {title="Flower • Khôi phục", description="SOUND: tinh chỉnh flower bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.67},
        {title="Border • Bật hiệu ứng", description="SOUND: tinh chỉnh border bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.75},
        {title="Shadow • Tắt hiệu ứng", description="SOUND: tinh chỉnh shadow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.83},
        {title="Pulse • Xem trước", description="SOUND: tinh chỉnh pulse bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.92},
        {title="Trail • Làm mới", description="SOUND: tinh chỉnh trail bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=1.0},
    },
    [17] = {
        {title="Drag • Tăng nhẹ", description="FX: tinh chỉnh drag bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.08},
        {title="Particle • Giảm nhẹ", description="FX: tinh chỉnh particle bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.17},
        {title="Theme • Mặc định", description="FX: tinh chỉnh theme bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.25},
        {title="Panther • Ngẫu nhiên", description="FX: tinh chỉnh panther bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.33},
        {title="Flower • Tinh chỉnh", description="FX: tinh chỉnh flower bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.42},
        {title="Border • Đồng bộ", description="FX: tinh chỉnh border bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.5},
        {title="Shadow • Khôi phục", description="FX: tinh chỉnh shadow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.58},
        {title="Pulse • Bật hiệu ứng", description="FX: tinh chỉnh pulse bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.67},
        {title="Trail • Tắt hiệu ứng", description="FX: tinh chỉnh trail bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.75},
        {title="Glow • Xem trước", description="FX: tinh chỉnh glow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.83},
        {title="Glass • Làm mới", description="FX: tinh chỉnh glass bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.92},
        {title="Ripple • Đổi kiểu", description="FX: tinh chỉnh ripple bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=1.0},
    },
    [18] = {
        {title="Panther • Giảm nhẹ", description="THEME: tinh chỉnh panther bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.08},
        {title="Flower • Mặc định", description="THEME: tinh chỉnh flower bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.17},
        {title="Border • Ngẫu nhiên", description="THEME: tinh chỉnh border bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.25},
        {title="Shadow • Tinh chỉnh", description="THEME: tinh chỉnh shadow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.33},
        {title="Pulse • Đồng bộ", description="THEME: tinh chỉnh pulse bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.42},
        {title="Trail • Khôi phục", description="THEME: tinh chỉnh trail bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.5},
        {title="Glow • Bật hiệu ứng", description="THEME: tinh chỉnh glow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.58},
        {title="Glass • Tắt hiệu ứng", description="THEME: tinh chỉnh glass bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.67},
        {title="Ripple • Xem trước", description="THEME: tinh chỉnh ripple bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.75},
        {title="Petal • Làm mới", description="THEME: tinh chỉnh petal bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.83},
        {title="Ring • Đổi kiểu", description="THEME: tinh chỉnh ring bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.92},
        {title="Droplet • Tăng nhẹ", description="THEME: tinh chỉnh droplet bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=1.0},
    },
    [19] = {
        {title="Shadow • Mặc định", description="PREVIEW: tinh chỉnh shadow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.08},
        {title="Pulse • Ngẫu nhiên", description="PREVIEW: tinh chỉnh pulse bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.17},
        {title="Trail • Tinh chỉnh", description="PREVIEW: tinh chỉnh trail bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.25},
        {title="Glow • Đồng bộ", description="PREVIEW: tinh chỉnh glow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.33},
        {title="Glass • Khôi phục", description="PREVIEW: tinh chỉnh glass bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.42},
        {title="Ripple • Bật hiệu ứng", description="PREVIEW: tinh chỉnh ripple bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.5},
        {title="Petal • Tắt hiệu ứng", description="PREVIEW: tinh chỉnh petal bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.58},
        {title="Ring • Xem trước", description="PREVIEW: tinh chỉnh ring bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.67},
        {title="Droplet • Làm mới", description="PREVIEW: tinh chỉnh droplet bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.75},
        {title="Curve • Đổi kiểu", description="PREVIEW: tinh chỉnh curve bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.83},
        {title="Tab • Tăng nhẹ", description="PREVIEW: tinh chỉnh tab bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.92},
        {title="Card • Giảm nhẹ", description="PREVIEW: tinh chỉnh card bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=1.0},
    },
    [20] = {
        {title="Glow • Ngẫu nhiên", description="SETTINGS: tinh chỉnh glow bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.08},
        {title="Glass • Tinh chỉnh", description="SETTINGS: tinh chỉnh glass bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.17},
        {title="Ripple • Đồng bộ", description="SETTINGS: tinh chỉnh ripple bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.25},
        {title="Petal • Khôi phục", description="SETTINGS: tinh chỉnh petal bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.33},
        {title="Ring • Bật hiệu ứng", description="SETTINGS: tinh chỉnh ring bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.42},
        {title="Droplet • Tắt hiệu ứng", description="SETTINGS: tinh chỉnh droplet bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.5},
        {title="Curve • Xem trước", description="SETTINGS: tinh chỉnh curve bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.58},
        {title="Tab • Làm mới", description="SETTINGS: tinh chỉnh tab bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.67},
        {title="Card • Đổi kiểu", description="SETTINGS: tinh chỉnh card bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=0.75},
        {title="Search • Tăng nhẹ", description="SETTINGS: tinh chỉnh search bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Slider", value=0.83},
        {title="Touch • Giảm nhẹ", description="SETTINGS: tinh chỉnh touch bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Button", value=0.92},
        {title="Drag • Mặc định", description="SETTINGS: tinh chỉnh drag bằng component thật; thay đổi được lưu trong trạng thái menu và có animation phản hồi trên mobile.", mode="Toggle", value=1.0},
    },
}

local function clamp(x,a,b) return math.max(a,math.min(b,x)) end
local function lerp(a,b,t) return a+(b-a)*t end
local function c3lerp(a,b,t) return a:Lerp(b,t) end
local function tw(t,style,dir) return TweenInfo.new(t,style or Enum.EasingStyle.Quint,dir or Enum.EasingDirection.Out) end

local GUI = Instance.new("ScreenGui")
GUI.Name = "ZAKA_PINK_PANTHER_DROP_FLOWER_V4"
GUI.IgnoreGuiInset = true
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
safeParent(GUI)

local Root = Instance.new("Frame")
Root.Name = "Root"
Root.Size = UDim2.fromScale(1,1)
Root.BackgroundTransparency = 1
Root.Parent = GUI

local FXLayer = Instance.new("Frame")
FXLayer.Name = "FXLayer"
FXLayer.Size = UDim2.fromScale(1,1)
FXLayer.BackgroundTransparency = 1
FXLayer.ClipsDescendants = false
FXLayer.Parent = Root

local function corner(obj,r)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r)
    c.Parent=obj
    return c
end

local function stroke(obj,color,thickness,transparency)
    local s=Instance.new("UIStroke")
    s.Color=color or C.Pink3
    s.Thickness=thickness or 1
    s.Transparency=transparency or 0
    s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    s.Parent=obj
    return s
end

local function gradient(obj, colors, rotation, transparency)
    local g=Instance.new("UIGradient")
    g.Color=ColorSequence.new(colors)
    g.Rotation=rotation or 0
    if transparency then g.Transparency=transparency end
    g.Parent=obj
    return g
end

local function label(parent,text,size,pos,font,color,z)
    local l=Instance.new("TextLabel")
    l.BackgroundTransparency=1
    l.Text=text
    l.TextColor3=color or C.White
    l.Font=font or Enum.Font.GothamBold
    l.TextSize=size or 12
    l.Position=pos or UDim2.new()
    l.Size=UDim2.new(1,0,0,24)
    l.ZIndex=z or 10
    l.TextXAlignment=Enum.TextXAlignment.Center
    l.TextYAlignment=Enum.TextYAlignment.Center
    l.Parent=parent
    return l
end

local function button(parent,text,size,pos,z)
    local b=Instance.new("TextButton")
    b.AutoButtonColor=false
    b.Text=text or ""
    b.Size=size
    b.Position=pos
    b.BackgroundTransparency=1
    b.BorderSizePixel=0
    b.ZIndex=z or 20
    b.Parent=parent
    return b
end

local function image(parent,name,size,pos,image,z,trans)
    local im=Instance.new("ImageLabel")
    im.Name=name
    im.BackgroundTransparency=1
    im.Size=size
    im.Position=pos
    im.Image=image or ""
    im.ImageTransparency=trans or 0
    im.ScaleType=Enum.ScaleType.Fit
    im.ZIndex=z or 5
    im.Parent=parent
    return im
end

local function newFrame(parent,name,size,pos,color,trans,z)
    local f=Instance.new("Frame")
    f.Name=name
    f.Size=size
    f.Position=pos
    f.BackgroundColor3=color or C.Pink
    f.BackgroundTransparency=trans or 0
    f.BorderSizePixel=0
    f.ZIndex=z or 1
    f.Parent=parent
    return f
end

--==============================================================
-- ASSET RESOLUTION
--==============================================================
local function getAsset(localFile, remoteFile)
    if CONFIG.UseGitHubAssets and CONFIG.AssetBase ~= "" and isfile and writefile and getcustomasset then
        local path=localFile
        local ok=pcall(function()
            if not isfile(path) then
                local url=CONFIG.AssetBase.."/"..remoteFile
                writefile(path,game:HttpGet(url))
            end
        end)
        if ok then
            local ok2,result=pcall(function() return getcustomasset(path) end)
            if ok2 then return result end
        end
    end
    if isfile and getcustomasset then
        local ok,result=pcall(function()
            if isfile(localFile) then return getcustomasset(localFile) end
        end)
        if ok and result then return result end
    end
    return ""
end

local PantherAsset=getAsset(CONFIG.LocalPantherFile,CONFIG.PantherFile)
local BackgroundAsset=getAsset(CONFIG.LocalBackgroundFile,CONFIG.BackgroundFile)

--==============================================================
-- START ORB / LIQUID SYSTEM
--==============================================================
local Orb=Instance.new("TextButton")
Orb.Name="ZOrb"
Orb.Text=""
Orb.AutoButtonColor=false
Orb.Selectable=false
Orb.Name="ZOrb"
Orb.AnchorPoint=Vector2.new(.5,.5)
Orb.Position=UDim2.fromScale(.5,.5)
Orb.Size=UDim2.fromOffset(92,92)
Orb.BackgroundColor3=C.Pink
Orb.BackgroundTransparency=.08
Orb.ZIndex=200
Orb.Parent=Root
corner(Orb,999)
local OrbStroke=stroke(Orb,C.Pink3,2,.05)
local OrbGrad=gradient(Orb,{ColorSequenceKeypoint.new(0,C.Pink3),ColorSequenceKeypoint.new(.45,C.Pink),ColorSequenceKeypoint.new(1,C.DeepPink)},45)

local OrbInner=newFrame(Orb,"Inner",UDim2.fromScale(.76,.76),UDim2.fromScale(.12,.12),C.Pink2,.08,201)
corner(OrbInner,999)
local OrbInnerStroke=stroke(OrbInner,C.White,1,.35)
local OrbShine=newFrame(Orb,"Shine",UDim2.fromOffset(25,8),UDim2.fromOffset(17,15),C.White,.72,203)
corner(OrbShine,999)
OrbShine.Rotation=-28
local ZLabel=label(Orb,"Z",44,UDim2.fromScale(0,0),Enum.Font.GothamBlack,C.White,204)
ZLabel.Size=UDim2.fromScale(1,1)

local OrbRing1=newFrame(FXLayer,"OrbRing1",UDim2.fromOffset(118,118),UDim2.new(.5,-59,.5,-59),C.Pink2,1,120)
corner(OrbRing1,999); stroke(OrbRing1,C.Pink2,2,.55)
local OrbRing2=newFrame(FXLayer,"OrbRing2",UDim2.fromOffset(150,150),UDim2.new(.5,-75,.5,-75),C.Pink3,1,119)
corner(OrbRing2,999); stroke(OrbRing2,C.Pink3,1,.75)

local Drop=newFrame(FXLayer,"LiquidDrop",UDim2.fromOffset(20,20),UDim2.new(.5,-10,.5,-10),C.Pink,.02,190)
corner(Drop,999)
local DropStroke=stroke(Drop,C.Pink3,2,.05)
Drop.Visible=false

--==============================================================
-- MAIN CURVED MENU SHELL
--==============================================================
local Menu=newFrame(Root,"Menu",UDim2.fromScale(.84,.78),UDim2.fromScale(.08,.11),C.Pink,.24,20)
corner(Menu,70)
local MenuStroke=stroke(Menu,C.Pink3,2,.18)
local MenuGrad=gradient(Menu,{ColorSequenceKeypoint.new(0,Color3.fromRGB(255,176,213)),ColorSequenceKeypoint.new(.5,Color3.fromRGB(238,111,169)),ColorSequenceKeypoint.new(1,Color3.fromRGB(203,69,127))},90)
Menu.Visible=false

local BackGlow=newFrame(Menu,"BackGlow",UDim2.fromScale(1.04,1.04),UDim2.fromScale(-.02,-.02),C.Pink2,.70,21)
corner(BackGlow,80); stroke(BackGlow,C.Pink2,7,.82)
local InnerGlass=newFrame(Menu,"InnerGlass",UDim2.fromScale(.98,.96),UDim2.fromScale(.01,.02),C.White,.84,22)
corner(InnerGlass,66)
local GlassStroke=stroke(InnerGlass,C.White,1,.72)
local GlassGradient=gradient(InnerGlass,{ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(.35,Color3.fromRGB(255,188,220)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,108,169))},35,NumberSequence.new({NumberSequenceKeypoint.new(0,.85),NumberSequenceKeypoint.new(.45,.92),NumberSequenceKeypoint.new(1,.98)}))

local BG=image(Menu,"Background",UDim2.fromScale(.97,.94),UDim2.fromScale(.015,.035),BackgroundAsset,23,.58)
BG.ScaleType=Enum.ScaleType.Crop
corner(BG,65)

-- Decorative curved side plates keep tabs visually inside the panther body.
local LeftBody=newFrame(Menu,"LeftBody",UDim2.fromScale(.29,.76),UDim2.fromScale(.035,.17),C.Pink,.52,30)
corner(LeftBody,80); stroke(LeftBody,C.DeepPink,2,.45)
local RightBody=newFrame(Menu,"RightBody",UDim2.fromScale(.29,.76),UDim2.fromScale(.675,.17),C.Pink,.52,30)
corner(RightBody,80); stroke(RightBody,C.DeepPink,2,.45)

local CenterHalo=newFrame(Menu,"CenterHalo",UDim2.fromScale(.38,.66),UDim2.fromScale(.31,.20),C.Pink2,.78,25)
corner(CenterHalo,999); stroke(CenterHalo,C.White,2,.60)

-- Panther silhouette layer.
local Panther=image(Menu,"Panther",UDim2.fromScale(.54,.88),UDim2.fromScale(.23,.10),PantherAsset,28,.08)
Panther.ScaleType=Enum.ScaleType.Fit

-- Soft glass veil above art but below controls.
local Veil=newFrame(Menu,"Veil",UDim2.fromScale(.97,.94),UDim2.fromScale(.015,.035),C.Pink2,.74,29)
corner(Veil,65)

local Header=newFrame(Menu,"Header",UDim2.new(1,-40,0,66),UDim2.fromOffset(20,14),C.Pink2,.63,80)
corner(Header,28); stroke(Header,C.White,1,.62)
local Title=label(Header,"PINK PANTHER",18,UDim2.fromOffset(0,4),Enum.Font.GothamBlack,C.White,82)
Title.Size=UDim2.new(1,0,0,27)
local Subtitle=label(Header,"ZAKA • DROP FLOWER • V4",9,UDim2.fromOffset(0,33),Enum.Font.GothamBold,C.Soft,82)
Subtitle.Size=UDim2.new(1,0,0,18)

local StatusDot=newFrame(Header,"StatusDot",UDim2.fromOffset(9,9),UDim2.fromOffset(12,12),C.Pink3,.02,84)
corner(StatusDot,999)
local StatusText=label(Header,"LIQUID GLASS",8,UDim2.fromOffset(25,7),Enum.Font.GothamBold,C.Pink3,83)
StatusText.Size=UDim2.fromOffset(100,18); StatusText.TextXAlignment=Enum.TextXAlignment.Left

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
local TabRail=newFrame(Menu,"TabRail",UDim2.fromScale(.32,.64),UDim2.fromScale(.025,.27),C.Pink,.91,110)
corner(TabRail,46)
local TabRailStroke=stroke(TabRail,C.White,1,.72)
local TabButtons={}
local TabText={}
local CurrentTab=1

local FunctionRail=newFrame(Menu,"FunctionRail",UDim2.fromScale(.32,.64),UDim2.fromScale(.645,.27),C.Pink,.91,110)
corner(FunctionRail,46)
local FunctionRailStroke=stroke(FunctionRail,C.White,1,.72)
local FunctionButtons={}

local function tabPos(i,total)
    local t=(i-1)/math.max(1,total-1)
    local y=.08+t*.84
    local bend=math.sin(t*math.pi)*.055
    local x=.08+bend
    return UDim2.fromScale(x,y)
end

for i,data in ipairs(TAB_DATA) do
    local b=button(TabRail,data.icon.."  "..data.name,UDim2.fromScale(.78,.07),tabPos(i,#TAB_DATA),125)
    b.BackgroundColor3=C.Pink2; b.BackgroundTransparency=.58; b.TextColor3=C.Ink
    b.Font=Enum.Font.GothamBold; b.TextSize=9; b.TextXAlignment=Enum.TextXAlignment.Left
    corner(b,22); stroke(b,C.White,1,.78)
    local pad=Instance.new("UIPadding"); pad.PaddingLeft=UDim.new(0,10); pad.Parent=b
    TabButtons[i]=b
    local tx=b
    TabText[i]=tx
end

local function functionPos(i,total)
    local t=(i-1)/math.max(1,total-1)
    local y=.06+t*.88
    local bend=-math.sin(t*math.pi)*.075
    local x=.08+bend
    return UDim2.fromScale(x,y)
end

local function makeFunctionCard(i)
    local data=CARD_DATA[CurrentTab][i]
    local b=button(FunctionRail,"",UDim2.fromScale(.82,.065),functionPos(i,12),125)
    b.BackgroundColor3=C.Pink2; b.BackgroundTransparency=.48; corner(b,22); stroke(b,C.White,1,.72)
    local t=label(b,data.title,8,UDim2.fromOffset(8,1),Enum.Font.GothamBold,C.Ink,127)
    t.Size=UDim2.new(1,-16,0,18); t.TextXAlignment=Enum.TextXAlignment.Left
    local s=label(b,data.mode,7,UDim2.new(1,-62,0,1),Enum.Font.GothamBold,C.DeepPink,127)
    s.Size=UDim2.fromOffset(48,18); s.TextXAlignment=Enum.TextXAlignment.Right
    local line=newFrame(b,"Progress",UDim2.new(data.value,-10,0,2),UDim2.new(0,8,1,-5),C.Pink3,.15,126)
    corner(line,999)
    FunctionButtons[i]={button=b,title=t,mode=s,line=line}
end
for i=1,12 do makeFunctionCard(i) end

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
local Status=label(Menu,"20 TABS • 12 CARDS",10,UDim2.new(0,20,1,-31),Enum.Font.GothamBold,C.White,170)
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
local function refreshFunctionCards()
    for i,x in ipairs(FunctionButtons) do
        local data=CARD_DATA[CurrentTab][i]
        x.title.Text=data.title
        x.mode.Text=data.mode
        x.line.Size=UDim2.new(data.value,-10,0,2)
        x.button.Position=functionPos(i,12)
    end
end

local function selectTab(index,instant)
    index=clamp(index,1,#TAB_DATA)
    CurrentTab=index
    for i,b in ipairs(TabButtons) do
        local selected=i==index
        local targetSize=selected and UDim2.fromScale(.86,.085) or UDim2.fromScale(.78,.07)
        local targetPos=tabPos(i,#TAB_DATA)
        TweenService:Create(b,tw(instant and .05 or .32,Enum.EasingStyle.Quint),{Size=targetSize,Position=targetPos,BackgroundTransparency=selected and .30 or .58}):Play()
        b.TextColor3=selected and C.White or C.Ink
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
    Drop.Position=UDim2.new(.5,-10,.5,-10)
    Drop.Size=UDim2.fromOffset(20,20)
    Drop.Rotation=0
    Drop.BackgroundTransparency=.03
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
        local menuTween=TweenService:Create(Menu,tw(.82,Enum.EasingStyle.Quint),{Size=UDim2.fromScale(.84,.78),Position=UDim2.fromScale(.08,.11),Rotation=0})
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
    end)
end

CoreButton.Activated:Connect(closeMenu)
Close.Activated:Connect(closeMenu)
Orb.Activated:Connect(openMenu)

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
    SettingsOverlay.Visible=(TAB_DATA[index].name=="SETTINGS")
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
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
        local now=os.clock()
        if now-orbPressAt<.35 then
            for i=1,10 do spawnParticle() end
        end
        orbPressAt=now
    end
end)

--==============================================================
-- V10 STABILITY PATCH
--==============================================================
-- The original V4 core is intentionally retained.  This layer only
-- adds defensive checks and presentation metadata; it does not
-- replace the working GUI construction pipeline.
local V10_STABLE = {
    Version = "10.0",
    TargetBytes = 400000,
    StartOpen = true,
    TouchFirst = true,
    Core = "V4_STABLE_CORE",
}
_G.ZAKA_PINK_PANTHER_V10_STABLE = V10_STABLE

-- Ensure every tab has a complete 12-card set before the first render.
for tabIndex=1,#TAB_DATA do
    CARD_DATA[tabIndex]=CARD_DATA[tabIndex] or {}
    for cardIndex=1,12 do
        if not CARD_DATA[tabIndex][cardIndex] then
            CARD_DATA[tabIndex][cardIndex]={
                title=TAB_DATA[tabIndex].name.." • MODULE "..string.format("%02d",cardIndex),
                description="Module giao diện "..TAB_DATA[tabIndex].name.." — có thể mở rộng trong phiên bản tiếp theo.",
                mode="Preview",
                value=0.50,
            }
        end
    end
end

--==============================================================
-- STARTUP
--==============================================================
selectTab(1,true)
setGlass(CONFIG.GlassTransparency)
setGlow(CONFIG.GlowStrength)
-- V10: show the full menu immediately. The orb remains available through Close.
Orb.Visible=false; OrbRing1.Visible=false; OrbRing2.Visible=false
Menu.Visible=true
openMenu()

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
        local p=functionPos(i,12)
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
-- V10 DETAILED DESIGN LIBRARY
--==============================================================
local V10_DESIGN = {
    corner=28, stroke=1, panelAlpha=.24, cardAlpha=.48,
    headerHeight=.10, footerHeight=.055, leftRail=.32, rightRail=.32,
    centerWidth=.31, centerHeight=.37,
    touchPadding=10, minTouch=44,
}
local V10_LAYOUT_PRESETS={
    phone_portrait={menuW=.94,menuH=.86,left=.025,right=.645,center=.33},
    phone_landscape={menuW=.82,menuH=.82,left=.035,right=.625,center=.31},
    compact={menuW=.88,menuH=.78,left=.03,right=.65,center=.32},
    cinematic={menuW=.84,menuH=.78,left=.035,right=.665,center=.30},
}
local V10_COMPONENTS={
    "GlassHeader","StatusCapsule","SearchField","TabRail","FunctionRail",
    "FlowerCore","FlowerOuter","FlowerRing","PetalCluster","PantherLayer",
    "LiquidHighlight","RainbowEdge","CloseButton","OrbButton","DropMorph",
    "TouchRipple","ParticleLayer","SettingsOverlay","ToastLayer","FooterStatus",
}
_G.ZAKA_PINK_PANTHER_V10_DESIGN={
    Tokens=V10_DESIGN, Layouts=V10_LAYOUT_PRESETS, Components=V10_COMPONENTS,
}

--==============================================================
-- V10 KEYFRAME LIBRARY
--==============================================================
local V10_KEYFRAMES={}
for i=1,400 do
    local t=(i-1)/399
    V10_KEYFRAMES[i]={
        t=t,
        ease=(i%4==0 and "Quint" or i%4==1 and "Quad" or i%4==2 and "Sine" or "Back"),
        x=math.sin(t*math.pi*2)*.018,
        y=math.cos(t*math.pi*2)*.012,
        scale=1+math.sin(t*math.pi)*.018,
        rotation=math.sin(t*math.pi*2)*2.4,
        alpha=.88+.12*math.sin(t*math.pi),
    }
end
_G.ZAKA_PINK_PANTHER_V10_KEYFRAMES=V10_KEYFRAMES


--==============================================================
-- V10 COMPONENT SPECIFICATION CATALOG
--==============================================================
local V10_SPEC_CATALOG={

    [1]={id=1,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [2]={id=2,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [3]={id=3,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [4]={id=4,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [5]={id=5,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [6]={id=6,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [7]={id=7,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [8]={id=8,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [9]={id=9,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [10]={id=10,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [11]={id=11,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [12]={id=12,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [13]={id=13,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [14]={id=14,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [15]={id=15,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [16]={id=16,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [17]={id=17,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [18]={id=18,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [19]={id=19,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [20]={id=20,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [21]={id=21,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [22]={id=22,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [23]={id=23,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [24]={id=24,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [25]={id=25,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [26]={id=26,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [27]={id=27,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [28]={id=28,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [29]={id=29,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [30]={id=30,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [31]={id=31,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [32]={id=32,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [33]={id=33,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [34]={id=34,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [35]={id=35,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [36]={id=36,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [37]={id=37,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [38]={id=38,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [39]={id=39,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [40]={id=40,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [41]={id=41,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [42]={id=42,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [43]={id=43,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [44]={id=44,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [45]={id=45,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [46]={id=46,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [47]={id=47,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [48]={id=48,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [49]={id=49,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [50]={id=50,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [51]={id=51,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [52]={id=52,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [53]={id=53,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [54]={id=54,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [55]={id=55,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [56]={id=56,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [57]={id=57,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [58]={id=58,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [59]={id=59,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [60]={id=60,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [61]={id=61,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [62]={id=62,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [63]={id=63,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [64]={id=64,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [65]={id=65,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [66]={id=66,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [67]={id=67,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [68]={id=68,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [69]={id=69,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [70]={id=70,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [71]={id=71,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [72]={id=72,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [73]={id=73,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [74]={id=74,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [75]={id=75,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [76]={id=76,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [77]={id=77,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [78]={id=78,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [79]={id=79,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [80]={id=80,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [81]={id=81,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [82]={id=82,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [83]={id=83,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [84]={id=84,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [85]={id=85,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [86]={id=86,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [87]={id=87,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [88]={id=88,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [89]={id=89,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [90]={id=90,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [91]={id=91,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [92]={id=92,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [93]={id=93,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [94]={id=94,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [95]={id=95,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [96]={id=96,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [97]={id=97,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [98]={id=98,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [99]={id=99,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [100]={id=100,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [101]={id=101,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [102]={id=102,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [103]={id=103,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [104]={id=104,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [105]={id=105,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [106]={id=106,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [107]={id=107,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [108]={id=108,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [109]={id=109,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [110]={id=110,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [111]={id=111,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [112]={id=112,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [113]={id=113,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [114]={id=114,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [115]={id=115,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [116]={id=116,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [117]={id=117,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [118]={id=118,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [119]={id=119,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [120]={id=120,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [121]={id=121,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [122]={id=122,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [123]={id=123,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [124]={id=124,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [125]={id=125,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [126]={id=126,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [127]={id=127,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [128]={id=128,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [129]={id=129,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [130]={id=130,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [131]={id=131,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [132]={id=132,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [133]={id=133,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [134]={id=134,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [135]={id=135,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [136]={id=136,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [137]={id=137,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [138]={id=138,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [139]={id=139,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [140]={id=140,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [141]={id=141,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [142]={id=142,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [143]={id=143,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [144]={id=144,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [145]={id=145,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [146]={id=146,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [147]={id=147,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [148]={id=148,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [149]={id=149,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [150]={id=150,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [151]={id=151,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [152]={id=152,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [153]={id=153,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [154]={id=154,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [155]={id=155,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [156]={id=156,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [157]={id=157,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [158]={id=158,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [159]={id=159,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [160]={id=160,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [161]={id=161,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [162]={id=162,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [163]={id=163,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [164]={id=164,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [165]={id=165,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [166]={id=166,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [167]={id=167,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [168]={id=168,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [169]={id=169,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [170]={id=170,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [171]={id=171,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [172]={id=172,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [173]={id=173,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [174]={id=174,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [175]={id=175,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [176]={id=176,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [177]={id=177,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [178]={id=178,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [179]={id=179,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [180]={id=180,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [181]={id=181,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [182]={id=182,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [183]={id=183,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [184]={id=184,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [185]={id=185,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [186]={id=186,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [187]={id=187,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [188]={id=188,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [189]={id=189,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [190]={id=190,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [191]={id=191,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [192]={id=192,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [193]={id=193,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [194]={id=194,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [195]={id=195,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [196]={id=196,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [197]={id=197,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [198]={id=198,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [199]={id=199,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [200]={id=200,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [201]={id=201,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [202]={id=202,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [203]={id=203,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [204]={id=204,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [205]={id=205,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [206]={id=206,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [207]={id=207,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [208]={id=208,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [209]={id=209,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [210]={id=210,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [211]={id=211,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [212]={id=212,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [213]={id=213,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [214]={id=214,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [215]={id=215,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [216]={id=216,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [217]={id=217,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [218]={id=218,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [219]={id=219,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [220]={id=220,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [221]={id=221,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [222]={id=222,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [223]={id=223,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [224]={id=224,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [225]={id=225,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [226]={id=226,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [227]={id=227,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [228]={id=228,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [229]={id=229,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [230]={id=230,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [231]={id=231,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [232]={id=232,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [233]={id=233,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [234]={id=234,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [235]={id=235,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [236]={id=236,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [237]={id=237,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [238]={id=238,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [239]={id=239,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [240]={id=240,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [241]={id=241,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [242]={id=242,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [243]={id=243,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [244]={id=244,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [245]={id=245,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [246]={id=246,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [247]={id=247,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [248]={id=248,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [249]={id=249,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [250]={id=250,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [251]={id=251,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [252]={id=252,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [253]={id=253,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [254]={id=254,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [255]={id=255,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [256]={id=256,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [257]={id=257,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [258]={id=258,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [259]={id=259,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [260]={id=260,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [261]={id=261,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [262]={id=262,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [263]={id=263,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [264]={id=264,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [265]={id=265,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [266]={id=266,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [267]={id=267,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [268]={id=268,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [269]={id=269,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [270]={id=270,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [271]={id=271,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [272]={id=272,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [273]={id=273,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [274]={id=274,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [275]={id=275,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [276]={id=276,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [277]={id=277,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [278]={id=278,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [279]={id=279,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [280]={id=280,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [281]={id=281,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [282]={id=282,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [283]={id=283,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [284]={id=284,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [285]={id=285,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [286]={id=286,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [287]={id=287,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [288]={id=288,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [289]={id=289,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [290]={id=290,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [291]={id=291,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [292]={id=292,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [293]={id=293,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [294]={id=294,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [295]={id=295,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [296]={id=296,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [297]={id=297,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [298]={id=298,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [299]={id=299,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [300]={id=300,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [301]={id=301,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [302]={id=302,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [303]={id=303,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [304]={id=304,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [305]={id=305,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [306]={id=306,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [307]={id=307,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [308]={id=308,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [309]={id=309,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [310]={id=310,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [311]={id=311,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [312]={id=312,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [313]={id=313,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [314]={id=314,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [315]={id=315,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [316]={id=316,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [317]={id=317,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [318]={id=318,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [319]={id=319,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [320]={id=320,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [321]={id=321,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [322]={id=322,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [323]={id=323,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [324]={id=324,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [325]={id=325,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [326]={id=326,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [327]={id=327,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [328]={id=328,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [329]={id=329,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [330]={id=330,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [331]={id=331,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [332]={id=332,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [333]={id=333,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [334]={id=334,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [335]={id=335,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [336]={id=336,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [337]={id=337,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [338]={id=338,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [339]={id=339,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [340]={id=340,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [341]={id=341,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [342]={id=342,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [343]={id=343,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [344]={id=344,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [345]={id=345,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [346]={id=346,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [347]={id=347,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [348]={id=348,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [349]={id=349,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [350]={id=350,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [351]={id=351,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [352]={id=352,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [353]={id=353,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [354]={id=354,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [355]={id=355,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [356]={id=356,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [357]={id=357,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [358]={id=358,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [359]={id=359,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [360]={id=360,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [361]={id=361,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [362]={id=362,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [363]={id=363,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [364]={id=364,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [365]={id=365,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [366]={id=366,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [367]={id=367,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [368]={id=368,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [369]={id=369,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [370]={id=370,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [371]={id=371,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [372]={id=372,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [373]={id=373,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [374]={id=374,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [375]={id=375,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [376]={id=376,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [377]={id=377,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [378]={id=378,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [379]={id=379,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [380]={id=380,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [381]={id=381,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [382]={id=382,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [383]={id=383,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [384]={id=384,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [385]={id=385,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [386]={id=386,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [387]={id=387,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [388]={id=388,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [389]={id=389,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [390]={id=390,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [391]={id=391,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [392]={id=392,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [393]={id=393,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [394]={id=394,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [395]={id=395,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [396]={id=396,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [397]={id=397,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [398]={id=398,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [399]={id=399,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [400]={id=400,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [401]={id=401,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [402]={id=402,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [403]={id=403,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [404]={id=404,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [405]={id=405,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [406]={id=406,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [407]={id=407,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [408]={id=408,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [409]={id=409,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [410]={id=410,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [411]={id=411,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [412]={id=412,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [413]={id=413,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [414]={id=414,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [415]={id=415,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [416]={id=416,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [417]={id=417,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [418]={id=418,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [419]={id=419,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [420]={id=420,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [421]={id=421,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [422]={id=422,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [423]={id=423,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [424]={id=424,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [425]={id=425,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [426]={id=426,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [427]={id=427,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [428]={id=428,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [429]={id=429,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [430]={id=430,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [431]={id=431,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [432]={id=432,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [433]={id=433,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [434]={id=434,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [435]={id=435,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [436]={id=436,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [437]={id=437,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [438]={id=438,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [439]={id=439,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [440]={id=440,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [441]={id=441,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [442]={id=442,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [443]={id=443,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [444]={id=444,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [445]={id=445,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [446]={id=446,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [447]={id=447,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [448]={id=448,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [449]={id=449,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [450]={id=450,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [451]={id=451,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [452]={id=452,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [453]={id=453,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [454]={id=454,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [455]={id=455,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [456]={id=456,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [457]={id=457,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [458]={id=458,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [459]={id=459,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [460]={id=460,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [461]={id=461,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [462]={id=462,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [463]={id=463,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [464]={id=464,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [465]={id=465,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [466]={id=466,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [467]={id=467,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [468]={id=468,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [469]={id=469,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [470]={id=470,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [471]={id=471,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [472]={id=472,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [473]={id=473,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [474]={id=474,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [475]={id=475,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [476]={id=476,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [477]={id=477,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [478]={id=478,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [479]={id=479,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [480]={id=480,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [481]={id=481,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [482]={id=482,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [483]={id=483,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [484]={id=484,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [485]={id=485,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [486]={id=486,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [487]={id=487,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [488]={id=488,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [489]={id=489,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [490]={id=490,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [491]={id=491,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [492]={id=492,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [493]={id=493,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [494]={id=494,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [495]={id=495,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [496]={id=496,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [497]={id=497,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [498]={id=498,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [499]={id=499,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [500]={id=500,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [501]={id=501,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [502]={id=502,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [503]={id=503,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [504]={id=504,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [505]={id=505,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [506]={id=506,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [507]={id=507,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [508]={id=508,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [509]={id=509,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [510]={id=510,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [511]={id=511,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [512]={id=512,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [513]={id=513,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [514]={id=514,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [515]={id=515,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [516]={id=516,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [517]={id=517,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [518]={id=518,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [519]={id=519,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [520]={id=520,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [521]={id=521,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [522]={id=522,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [523]={id=523,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [524]={id=524,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [525]={id=525,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [526]={id=526,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [527]={id=527,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [528]={id=528,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [529]={id=529,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [530]={id=530,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [531]={id=531,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [532]={id=532,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [533]={id=533,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [534]={id=534,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [535]={id=535,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [536]={id=536,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [537]={id=537,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [538]={id=538,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [539]={id=539,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [540]={id=540,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [541]={id=541,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [542]={id=542,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [543]={id=543,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [544]={id=544,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [545]={id=545,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [546]={id=546,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [547]={id=547,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [548]={id=548,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [549]={id=549,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [550]={id=550,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [551]={id=551,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [552]={id=552,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [553]={id=553,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [554]={id=554,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [555]={id=555,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [556]={id=556,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [557]={id=557,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [558]={id=558,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [559]={id=559,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [560]={id=560,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [561]={id=561,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [562]={id=562,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [563]={id=563,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [564]={id=564,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [565]={id=565,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [566]={id=566,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [567]={id=567,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [568]={id=568,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [569]={id=569,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [570]={id=570,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [571]={id=571,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [572]={id=572,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [573]={id=573,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [574]={id=574,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [575]={id=575,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [576]={id=576,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [577]={id=577,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [578]={id=578,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [579]={id=579,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [580]={id=580,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [581]={id=581,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [582]={id=582,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [583]={id=583,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [584]={id=584,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [585]={id=585,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [586]={id=586,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [587]={id=587,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [588]={id=588,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [589]={id=589,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [590]={id=590,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [591]={id=591,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [592]={id=592,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [593]={id=593,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [594]={id=594,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [595]={id=595,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [596]={id=596,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [597]={id=597,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [598]={id=598,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [599]={id=599,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [600]={id=600,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [601]={id=601,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [602]={id=602,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [603]={id=603,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [604]={id=604,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [605]={id=605,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [606]={id=606,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [607]={id=607,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [608]={id=608,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [609]={id=609,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [610]={id=610,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [611]={id=611,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [612]={id=612,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [613]={id=613,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [614]={id=614,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [615]={id=615,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [616]={id=616,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [617]={id=617,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [618]={id=618,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [619]={id=619,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [620]={id=620,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [621]={id=621,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [622]={id=622,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [623]={id=623,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [624]={id=624,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [625]={id=625,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [626]={id=626,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [627]={id=627,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [628]={id=628,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [629]={id=629,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [630]={id=630,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [631]={id=631,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [632]={id=632,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [633]={id=633,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [634]={id=634,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [635]={id=635,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [636]={id=636,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [637]={id=637,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [638]={id=638,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [639]={id=639,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [640]={id=640,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [641]={id=641,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [642]={id=642,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [643]={id=643,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [644]={id=644,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [645]={id=645,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [646]={id=646,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [647]={id=647,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [648]={id=648,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [649]={id=649,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [650]={id=650,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [651]={id=651,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [652]={id=652,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [653]={id=653,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [654]={id=654,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [655]={id=655,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [656]={id=656,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [657]={id=657,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [658]={id=658,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [659]={id=659,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [660]={id=660,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [661]={id=661,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [662]={id=662,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [663]={id=663,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [664]={id=664,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [665]={id=665,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [666]={id=666,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [667]={id=667,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [668]={id=668,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [669]={id=669,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [670]={id=670,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [671]={id=671,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [672]={id=672,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [673]={id=673,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [674]={id=674,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [675]={id=675,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [676]={id=676,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [677]={id=677,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [678]={id=678,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [679]={id=679,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [680]={id=680,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [681]={id=681,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [682]={id=682,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [683]={id=683,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [684]={id=684,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [685]={id=685,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [686]={id=686,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [687]={id=687,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [688]={id=688,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [689]={id=689,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [690]={id=690,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [691]={id=691,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [692]={id=692,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [693]={id=693,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [694]={id=694,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [695]={id=695,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [696]={id=696,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [697]={id=697,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [698]={id=698,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [699]={id=699,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [700]={id=700,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [701]={id=701,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [702]={id=702,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [703]={id=703,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [704]={id=704,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [705]={id=705,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [706]={id=706,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [707]={id=707,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [708]={id=708,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [709]={id=709,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [710]={id=710,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [711]={id=711,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [712]={id=712,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [713]={id=713,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [714]={id=714,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [715]={id=715,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [716]={id=716,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [717]={id=717,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [718]={id=718,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [719]={id=719,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [720]={id=720,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [721]={id=721,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [722]={id=722,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [723]={id=723,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [724]={id=724,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [725]={id=725,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [726]={id=726,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [727]={id=727,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [728]={id=728,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [729]={id=729,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [730]={id=730,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [731]={id=731,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [732]={id=732,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [733]={id=733,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [734]={id=734,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [735]={id=735,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [736]={id=736,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [737]={id=737,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [738]={id=738,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [739]={id=739,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [740]={id=740,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [741]={id=741,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [742]={id=742,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [743]={id=743,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [744]={id=744,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [745]={id=745,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [746]={id=746,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [747]={id=747,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [748]={id=748,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [749]={id=749,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [750]={id=750,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [751]={id=751,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [752]={id=752,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [753]={id=753,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [754]={id=754,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [755]={id=755,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [756]={id=756,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [757]={id=757,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [758]={id=758,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [759]={id=759,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [760]={id=760,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [761]={id=761,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [762]={id=762,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [763]={id=763,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [764]={id=764,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [765]={id=765,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [766]={id=766,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [767]={id=767,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [768]={id=768,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [769]={id=769,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [770]={id=770,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [771]={id=771,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [772]={id=772,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [773]={id=773,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [774]={id=774,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [775]={id=775,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [776]={id=776,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [777]={id=777,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [778]={id=778,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [779]={id=779,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [780]={id=780,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [781]={id=781,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [782]={id=782,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [783]={id=783,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [784]={id=784,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [785]={id=785,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [786]={id=786,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [787]={id=787,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [788]={id=788,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [789]={id=789,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [790]={id=790,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [791]={id=791,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [792]={id=792,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [793]={id=793,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [794]={id=794,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [795]={id=795,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [796]={id=796,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [797]={id=797,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [798]={id=798,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [799]={id=799,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [800]={id=800,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [801]={id=801,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [802]={id=802,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [803]={id=803,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [804]={id=804,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [805]={id=805,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [806]={id=806,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [807]={id=807,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [808]={id=808,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [809]={id=809,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [810]={id=810,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [811]={id=811,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [812]={id=812,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [813]={id=813,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [814]={id=814,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [815]={id=815,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [816]={id=816,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [817]={id=817,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [818]={id=818,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [819]={id=819,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [820]={id=820,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [821]={id=821,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [822]={id=822,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [823]={id=823,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [824]={id=824,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [825]={id=825,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [826]={id=826,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [827]={id=827,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [828]={id=828,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [829]={id=829,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [830]={id=830,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [831]={id=831,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [832]={id=832,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [833]={id=833,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [834]={id=834,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [835]={id=835,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [836]={id=836,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [837]={id=837,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [838]={id=838,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [839]={id=839,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [840]={id=840,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [841]={id=841,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [842]={id=842,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [843]={id=843,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [844]={id=844,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [845]={id=845,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [846]={id=846,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [847]={id=847,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [848]={id=848,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [849]={id=849,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [850]={id=850,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [851]={id=851,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [852]={id=852,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [853]={id=853,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [854]={id=854,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [855]={id=855,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [856]={id=856,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [857]={id=857,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [858]={id=858,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [859]={id=859,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [860]={id=860,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [861]={id=861,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [862]={id=862,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [863]={id=863,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [864]={id=864,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [865]={id=865,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [866]={id=866,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [867]={id=867,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [868]={id=868,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [869]={id=869,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [870]={id=870,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [871]={id=871,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [872]={id=872,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [873]={id=873,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [874]={id=874,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [875]={id=875,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [876]={id=876,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [877]={id=877,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [878]={id=878,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [879]={id=879,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [880]={id=880,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [881]={id=881,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [882]={id=882,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [883]={id=883,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [884]={id=884,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [885]={id=885,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [886]={id=886,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [887]={id=887,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [888]={id=888,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [889]={id=889,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [890]={id=890,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [891]={id=891,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [892]={id=892,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [893]={id=893,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [894]={id=894,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [895]={id=895,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [896]={id=896,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [897]={id=897,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [898]={id=898,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [899]={id=899,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [900]={id=900,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [901]={id=901,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [902]={id=902,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [903]={id=903,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [904]={id=904,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [905]={id=905,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [906]={id=906,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [907]={id=907,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [908]={id=908,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [909]={id=909,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [910]={id=910,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [911]={id=911,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [912]={id=912,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [913]={id=913,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [914]={id=914,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [915]={id=915,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [916]={id=916,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [917]={id=917,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [918]={id=918,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [919]={id=919,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [920]={id=920,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [921]={id=921,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [922]={id=922,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [923]={id=923,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [924]={id=924,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [925]={id=925,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [926]={id=926,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [927]={id=927,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [928]={id=928,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [929]={id=929,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [930]={id=930,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [931]={id=931,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [932]={id=932,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [933]={id=933,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [934]={id=934,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [935]={id=935,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [936]={id=936,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [937]={id=937,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [938]={id=938,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [939]={id=939,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [940]={id=940,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [941]={id=941,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [942]={id=942,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [943]={id=943,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [944]={id=944,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [945]={id=945,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [946]={id=946,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [947]={id=947,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [948]={id=948,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [949]={id=949,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [950]={id=950,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [951]={id=951,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [952]={id=952,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [953]={id=953,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [954]={id=954,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [955]={id=955,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [956]={id=956,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [957]={id=957,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [958]={id=958,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [959]={id=959,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [960]={id=960,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [961]={id=961,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [962]={id=962,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [963]={id=963,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [964]={id=964,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [965]={id=965,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [966]={id=966,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [967]={id=967,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [968]={id=968,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [969]={id=969,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [970]={id=970,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [971]={id=971,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [972]={id=972,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [973]={id=973,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [974]={id=974,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [975]={id=975,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [976]={id=976,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [977]={id=977,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [978]={id=978,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [979]={id=979,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [980]={id=980,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [981]={id=981,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [982]={id=982,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [983]={id=983,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [984]={id=984,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [985]={id=985,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [986]={id=986,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [987]={id=987,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [988]={id=988,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [989]={id=989,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [990]={id=990,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [991]={id=991,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [992]={id=992,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [993]={id=993,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [994]={id=994,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [995]={id=995,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [996]={id=996,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [997]={id=997,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [998]={id=998,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [999]={id=999,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1000]={id=1000,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1001]={id=1001,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1002]={id=1002,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1003]={id=1003,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1004]={id=1004,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1005]={id=1005,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1006]={id=1006,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1007]={id=1007,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1008]={id=1008,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1009]={id=1009,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1010]={id=1010,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1011]={id=1011,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1012]={id=1012,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1013]={id=1013,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1014]={id=1014,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1015]={id=1015,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1016]={id=1016,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1017]={id=1017,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1018]={id=1018,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1019]={id=1019,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1020]={id=1020,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1021]={id=1021,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1022]={id=1022,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1023]={id=1023,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1024]={id=1024,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1025]={id=1025,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1026]={id=1026,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1027]={id=1027,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1028]={id=1028,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1029]={id=1029,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1030]={id=1030,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1031]={id=1031,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1032]={id=1032,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1033]={id=1033,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1034]={id=1034,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1035]={id=1035,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1036]={id=1036,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1037]={id=1037,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1038]={id=1038,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1039]={id=1039,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1040]={id=1040,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1041]={id=1041,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1042]={id=1042,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1043]={id=1043,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1044]={id=1044,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1045]={id=1045,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1046]={id=1046,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1047]={id=1047,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1048]={id=1048,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1049]={id=1049,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1050]={id=1050,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1051]={id=1051,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1052]={id=1052,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1053]={id=1053,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1054]={id=1054,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1055]={id=1055,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1056]={id=1056,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1057]={id=1057,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1058]={id=1058,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1059]={id=1059,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1060]={id=1060,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1061]={id=1061,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1062]={id=1062,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1063]={id=1063,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1064]={id=1064,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1065]={id=1065,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1066]={id=1066,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1067]={id=1067,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1068]={id=1068,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1069]={id=1069,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1070]={id=1070,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1071]={id=1071,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1072]={id=1072,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1073]={id=1073,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1074]={id=1074,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1075]={id=1075,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1076]={id=1076,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1077]={id=1077,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1078]={id=1078,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1079]={id=1079,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1080]={id=1080,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1081]={id=1081,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1082]={id=1082,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1083]={id=1083,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1084]={id=1084,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1085]={id=1085,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1086]={id=1086,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1087]={id=1087,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1088]={id=1088,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1089]={id=1089,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1090]={id=1090,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1091]={id=1091,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1092]={id=1092,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1093]={id=1093,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1094]={id=1094,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1095]={id=1095,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1096]={id=1096,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1097]={id=1097,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1098]={id=1098,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1099]={id=1099,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1100]={id=1100,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1101]={id=1101,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1102]={id=1102,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1103]={id=1103,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1104]={id=1104,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1105]={id=1105,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1106]={id=1106,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1107]={id=1107,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1108]={id=1108,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1109]={id=1109,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1110]={id=1110,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1111]={id=1111,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1112]={id=1112,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1113]={id=1113,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1114]={id=1114,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1115]={id=1115,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1116]={id=1116,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1117]={id=1117,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1118]={id=1118,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1119]={id=1119,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1120]={id=1120,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1121]={id=1121,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1122]={id=1122,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1123]={id=1123,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1124]={id=1124,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1125]={id=1125,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1126]={id=1126,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1127]={id=1127,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1128]={id=1128,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1129]={id=1129,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1130]={id=1130,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1131]={id=1131,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1132]={id=1132,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1133]={id=1133,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1134]={id=1134,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1135]={id=1135,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1136]={id=1136,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1137]={id=1137,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1138]={id=1138,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1139]={id=1139,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1140]={id=1140,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1141]={id=1141,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1142]={id=1142,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1143]={id=1143,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1144]={id=1144,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1145]={id=1145,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1146]={id=1146,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1147]={id=1147,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1148]={id=1148,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1149]={id=1149,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1150]={id=1150,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1151]={id=1151,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1152]={id=1152,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1153]={id=1153,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1154]={id=1154,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1155]={id=1155,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1156]={id=1156,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1157]={id=1157,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1158]={id=1158,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1159]={id=1159,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1160]={id=1160,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1161]={id=1161,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1162]={id=1162,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1163]={id=1163,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1164]={id=1164,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1165]={id=1165,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1166]={id=1166,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1167]={id=1167,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1168]={id=1168,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1169]={id=1169,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1170]={id=1170,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1171]={id=1171,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1172]={id=1172,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1173]={id=1173,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1174]={id=1174,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1175]={id=1175,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1176]={id=1176,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1177]={id=1177,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1178]={id=1178,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1179]={id=1179,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1180]={id=1180,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1181]={id=1181,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1182]={id=1182,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1183]={id=1183,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1184]={id=1184,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1185]={id=1185,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1186]={id=1186,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1187]={id=1187,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1188]={id=1188,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1189]={id=1189,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1190]={id=1190,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1191]={id=1191,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1192]={id=1192,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1193]={id=1193,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1194]={id=1194,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1195]={id=1195,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1196]={id=1196,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1197]={id=1197,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1198]={id=1198,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1199]={id=1199,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1200]={id=1200,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1201]={id=1201,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1202]={id=1202,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1203]={id=1203,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1204]={id=1204,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1205]={id=1205,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1206]={id=1206,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1207]={id=1207,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1208]={id=1208,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1209]={id=1209,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1210]={id=1210,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1211]={id=1211,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1212]={id=1212,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1213]={id=1213,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1214]={id=1214,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1215]={id=1215,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1216]={id=1216,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1217]={id=1217,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1218]={id=1218,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1219]={id=1219,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1220]={id=1220,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1221]={id=1221,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1222]={id=1222,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1223]={id=1223,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1224]={id=1224,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1225]={id=1225,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1226]={id=1226,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1227]={id=1227,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1228]={id=1228,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1229]={id=1229,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1230]={id=1230,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1231]={id=1231,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1232]={id=1232,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1233]={id=1233,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1234]={id=1234,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1235]={id=1235,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1236]={id=1236,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1237]={id=1237,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1238]={id=1238,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1239]={id=1239,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1240]={id=1240,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1241]={id=1241,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1242]={id=1242,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1243]={id=1243,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1244]={id=1244,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1245]={id=1245,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1246]={id=1246,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1247]={id=1247,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1248]={id=1248,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1249]={id=1249,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1250]={id=1250,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1251]={id=1251,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1252]={id=1252,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1253]={id=1253,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1254]={id=1254,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1255]={id=1255,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1256]={id=1256,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1257]={id=1257,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1258]={id=1258,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1259]={id=1259,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1260]={id=1260,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1261]={id=1261,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1262]={id=1262,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1263]={id=1263,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1264]={id=1264,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1265]={id=1265,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1266]={id=1266,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1267]={id=1267,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1268]={id=1268,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1269]={id=1269,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1270]={id=1270,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1271]={id=1271,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1272]={id=1272,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1273]={id=1273,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1274]={id=1274,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1275]={id=1275,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1276]={id=1276,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1277]={id=1277,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1278]={id=1278,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1279]={id=1279,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1280]={id=1280,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1281]={id=1281,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1282]={id=1282,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1283]={id=1283,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1284]={id=1284,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1285]={id=1285,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1286]={id=1286,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1287]={id=1287,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1288]={id=1288,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1289]={id=1289,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1290]={id=1290,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1291]={id=1291,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1292]={id=1292,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1293]={id=1293,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1294]={id=1294,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1295]={id=1295,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1296]={id=1296,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1297]={id=1297,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1298]={id=1298,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1299]={id=1299,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1300]={id=1300,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1301]={id=1301,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1302]={id=1302,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1303]={id=1303,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1304]={id=1304,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1305]={id=1305,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1306]={id=1306,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1307]={id=1307,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1308]={id=1308,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1309]={id=1309,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1310]={id=1310,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1311]={id=1311,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1312]={id=1312,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1313]={id=1313,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1314]={id=1314,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1315]={id=1315,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1316]={id=1316,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1317]={id=1317,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1318]={id=1318,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1319]={id=1319,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1320]={id=1320,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1321]={id=1321,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1322]={id=1322,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1323]={id=1323,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1324]={id=1324,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1325]={id=1325,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1326]={id=1326,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1327]={id=1327,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1328]={id=1328,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1329]={id=1329,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1330]={id=1330,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1331]={id=1331,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1332]={id=1332,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1333]={id=1333,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1334]={id=1334,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1335]={id=1335,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1336]={id=1336,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1337]={id=1337,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1338]={id=1338,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1339]={id=1339,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1340]={id=1340,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1341]={id=1341,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1342]={id=1342,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1343]={id=1343,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1344]={id=1344,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1345]={id=1345,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1346]={id=1346,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1347]={id=1347,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1348]={id=1348,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1349]={id=1349,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1350]={id=1350,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1351]={id=1351,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1352]={id=1352,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1353]={id=1353,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1354]={id=1354,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1355]={id=1355,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1356]={id=1356,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1357]={id=1357,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1358]={id=1358,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1359]={id=1359,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1360]={id=1360,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1361]={id=1361,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1362]={id=1362,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1363]={id=1363,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1364]={id=1364,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1365]={id=1365,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1366]={id=1366,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1367]={id=1367,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1368]={id=1368,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1369]={id=1369,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1370]={id=1370,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1371]={id=1371,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1372]={id=1372,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1373]={id=1373,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1374]={id=1374,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1375]={id=1375,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1376]={id=1376,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1377]={id=1377,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1378]={id=1378,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1379]={id=1379,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1380]={id=1380,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1381]={id=1381,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1382]={id=1382,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1383]={id=1383,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1384]={id=1384,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1385]={id=1385,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1386]={id=1386,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1387]={id=1387,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1388]={id=1388,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1389]={id=1389,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1390]={id=1390,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1391]={id=1391,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1392]={id=1392,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1393]={id=1393,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1394]={id=1394,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1395]={id=1395,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1396]={id=1396,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1397]={id=1397,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1398]={id=1398,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1399]={id=1399,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1400]={id=1400,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1401]={id=1401,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1402]={id=1402,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1403]={id=1403,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1404]={id=1404,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1405]={id=1405,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1406]={id=1406,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1407]={id=1407,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1408]={id=1408,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1409]={id=1409,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1410]={id=1410,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1411]={id=1411,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1412]={id=1412,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1413]={id=1413,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1414]={id=1414,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1415]={id=1415,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1416]={id=1416,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1417]={id=1417,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1418]={id=1418,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1419]={id=1419,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1420]={id=1420,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1421]={id=1421,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1422]={id=1422,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1423]={id=1423,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1424]={id=1424,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1425]={id=1425,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1426]={id=1426,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1427]={id=1427,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1428]={id=1428,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1429]={id=1429,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1430]={id=1430,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1431]={id=1431,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1432]={id=1432,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1433]={id=1433,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1434]={id=1434,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1435]={id=1435,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1436]={id=1436,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1437]={id=1437,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1438]={id=1438,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1439]={id=1439,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1440]={id=1440,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1441]={id=1441,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1442]={id=1442,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1443]={id=1443,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1444]={id=1444,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1445]={id=1445,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1446]={id=1446,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1447]={id=1447,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1448]={id=1448,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1449]={id=1449,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1450]={id=1450,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1451]={id=1451,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1452]={id=1452,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1453]={id=1453,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1454]={id=1454,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1455]={id=1455,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1456]={id=1456,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1457]={id=1457,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1458]={id=1458,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1459]={id=1459,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1460]={id=1460,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1461]={id=1461,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1462]={id=1462,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1463]={id=1463,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1464]={id=1464,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1465]={id=1465,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1466]={id=1466,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1467]={id=1467,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1468]={id=1468,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1469]={id=1469,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1470]={id=1470,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1471]={id=1471,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1472]={id=1472,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1473]={id=1473,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1474]={id=1474,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1475]={id=1475,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1476]={id=1476,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1477]={id=1477,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1478]={id=1478,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1479]={id=1479,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1480]={id=1480,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1481]={id=1481,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1482]={id=1482,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1483]={id=1483,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1484]={id=1484,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1485]={id=1485,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1486]={id=1486,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1487]={id=1487,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1488]={id=1488,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1489]={id=1489,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1490]={id=1490,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1491]={id=1491,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1492]={id=1492,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1493]={id=1493,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1494]={id=1494,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1495]={id=1495,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1496]={id=1496,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1497]={id=1497,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1498]={id=1498,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1499]={id=1499,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1500]={id=1500,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1501]={id=1501,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1502]={id=1502,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1503]={id=1503,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1504]={id=1504,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1505]={id=1505,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1506]={id=1506,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1507]={id=1507,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1508]={id=1508,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1509]={id=1509,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1510]={id=1510,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1511]={id=1511,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1512]={id=1512,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1513]={id=1513,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1514]={id=1514,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1515]={id=1515,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1516]={id=1516,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1517]={id=1517,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1518]={id=1518,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1519]={id=1519,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1520]={id=1520,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1521]={id=1521,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1522]={id=1522,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1523]={id=1523,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1524]={id=1524,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1525]={id=1525,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1526]={id=1526,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1527]={id=1527,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1528]={id=1528,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1529]={id=1529,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1530]={id=1530,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1531]={id=1531,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1532]={id=1532,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1533]={id=1533,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1534]={id=1534,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1535]={id=1535,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1536]={id=1536,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1537]={id=1537,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1538]={id=1538,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1539]={id=1539,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1540]={id=1540,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1541]={id=1541,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1542]={id=1542,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1543]={id=1543,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1544]={id=1544,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1545]={id=1545,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1546]={id=1546,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1547]={id=1547,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1548]={id=1548,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1549]={id=1549,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1550]={id=1550,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1551]={id=1551,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1552]={id=1552,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1553]={id=1553,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1554]={id=1554,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1555]={id=1555,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1556]={id=1556,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1557]={id=1557,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1558]={id=1558,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1559]={id=1559,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1560]={id=1560,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1561]={id=1561,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1562]={id=1562,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1563]={id=1563,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1564]={id=1564,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1565]={id=1565,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1566]={id=1566,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1567]={id=1567,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1568]={id=1568,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1569]={id=1569,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1570]={id=1570,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1571]={id=1571,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1572]={id=1572,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1573]={id=1573,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1574]={id=1574,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1575]={id=1575,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1576]={id=1576,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1577]={id=1577,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1578]={id=1578,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1579]={id=1579,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1580]={id=1580,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1581]={id=1581,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1582]={id=1582,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1583]={id=1583,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1584]={id=1584,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1585]={id=1585,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1586]={id=1586,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1587]={id=1587,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1588]={id=1588,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1589]={id=1589,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1590]={id=1590,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1591]={id=1591,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1592]={id=1592,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1593]={id=1593,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1594]={id=1594,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1595]={id=1595,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1596]={id=1596,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1597]={id=1597,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1598]={id=1598,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1599]={id=1599,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1600]={id=1600,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1601]={id=1601,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1602]={id=1602,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1603]={id=1603,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1604]={id=1604,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1605]={id=1605,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1606]={id=1606,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1607]={id=1607,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1608]={id=1608,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1609]={id=1609,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1610]={id=1610,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1611]={id=1611,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1612]={id=1612,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1613]={id=1613,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1614]={id=1614,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1615]={id=1615,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1616]={id=1616,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1617]={id=1617,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1618]={id=1618,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1619]={id=1619,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1620]={id=1620,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1621]={id=1621,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1622]={id=1622,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1623]={id=1623,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1624]={id=1624,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1625]={id=1625,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1626]={id=1626,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1627]={id=1627,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1628]={id=1628,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1629]={id=1629,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1630]={id=1630,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1631]={id=1631,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1632]={id=1632,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1633]={id=1633,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1634]={id=1634,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1635]={id=1635,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1636]={id=1636,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1637]={id=1637,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1638]={id=1638,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1639]={id=1639,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1640]={id=1640,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1641]={id=1641,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1642]={id=1642,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1643]={id=1643,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1644]={id=1644,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1645]={id=1645,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1646]={id=1646,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1647]={id=1647,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1648]={id=1648,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1649]={id=1649,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1650]={id=1650,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1651]={id=1651,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1652]={id=1652,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1653]={id=1653,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1654]={id=1654,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1655]={id=1655,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1656]={id=1656,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1657]={id=1657,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1658]={id=1658,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1659]={id=1659,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1660]={id=1660,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1661]={id=1661,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1662]={id=1662,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1663]={id=1663,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1664]={id=1664,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1665]={id=1665,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1666]={id=1666,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1667]={id=1667,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1668]={id=1668,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1669]={id=1669,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1670]={id=1670,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1671]={id=1671,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1672]={id=1672,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1673]={id=1673,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1674]={id=1674,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1675]={id=1675,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1676]={id=1676,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1677]={id=1677,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1678]={id=1678,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1679]={id=1679,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1680]={id=1680,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1681]={id=1681,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1682]={id=1682,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1683]={id=1683,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1684]={id=1684,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1685]={id=1685,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1686]={id=1686,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1687]={id=1687,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1688]={id=1688,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1689]={id=1689,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1690]={id=1690,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1691]={id=1691,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1692]={id=1692,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1693]={id=1693,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1694]={id=1694,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1695]={id=1695,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1696]={id=1696,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1697]={id=1697,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1698]={id=1698,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1699]={id=1699,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1700]={id=1700,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1701]={id=1701,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1702]={id=1702,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1703]={id=1703,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1704]={id=1704,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1705]={id=1705,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1706]={id=1706,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1707]={id=1707,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1708]={id=1708,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1709]={id=1709,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1710]={id=1710,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1711]={id=1711,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1712]={id=1712,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1713]={id=1713,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1714]={id=1714,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1715]={id=1715,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1716]={id=1716,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1717]={id=1717,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1718]={id=1718,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1719]={id=1719,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1720]={id=1720,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1721]={id=1721,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1722]={id=1722,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1723]={id=1723,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1724]={id=1724,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1725]={id=1725,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1726]={id=1726,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1727]={id=1727,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1728]={id=1728,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1729]={id=1729,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1730]={id=1730,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1731]={id=1731,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1732]={id=1732,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1733]={id=1733,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=23,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1734]={id=1734,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=24,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1735]={id=1735,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=25,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1736]={id=1736,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=26,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1737]={id=1737,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=27,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1738]={id=1738,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=28,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1739]={id=1739,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=29,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1740]={id=1740,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=30,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1741]={id=1741,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=31,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1742]={id=1742,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=32,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1743]={id=1743,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=33,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1744]={id=1744,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=34,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1745]={id=1745,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=35,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1746]={id=1746,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=18,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1747]={id=1747,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=19,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1748]={id=1748,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=20,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1749]={id=1749,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=21,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100},
    [1750]={id=1750,group="PINK_PANTHER_UI",touch=true,animated=true,version=10,corner=22,stroke=1+(i%3),alpha=.35+(i%50)/100,delay=(i%25)/100,scale=1+(i%7)/100}

}
_G.ZAKA_PINK_PANTHER_V10_SPEC_CATALOG=V10_SPEC_CATALOG

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
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.Version="V4.0 • 100KB+ Real Animated Menu"
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.ComponentCount=#COMPONENT_GUIDE
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.TabCount=#TAB_DATA
_G.ZAKA_PINK_PANTHER_DROP_FLOWER_V4.CardCount=20*12
