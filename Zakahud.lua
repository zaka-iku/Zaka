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
local TabRail=newFrame(Menu,"TabRail",UDim2.fromScale(.30,.62),UDim2.fromScale(.035,.28),C.Pink,.91,110)
corner(TabRail,46)
local TabRailStroke=stroke(TabRail,C.White,1,.72)
local TabButtons={}
local TabText={}
local CurrentTab=1

local FunctionRail=newFrame(Menu,"FunctionRail",UDim2.fromScale(.30,.62),UDim2.fromScale(.665,.28),C.Pink,.91,110)
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
-- STARTUP
--==============================================================
selectTab(1,true)
setGlass(CONFIG.GlassTransparency)
setGlow(CONFIG.GlowStrength)
if CONFIG.StartWithOrb then
    Orb.Visible=true; OrbRing1.Visible=true; OrbRing2.Visible=true; Menu.Visible=false
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
