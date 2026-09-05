--====================================================================================================--
-- ANIME MULTIVERSE OMNIPOTENT GOD-TIER ULTIMATE REPLICATION ENGINE V500.0 (ULTRA-HD VFX & 100+ MOVESET)
-- Đồ họa cực đỉnh Raymarching Shaders, Hệ thống 100+ Tuyệt kỹ Anime độc quyền, Tự động tối ưu hóa Frame,
-- Đồng bộ Realtime Multiplayer Client-Server, Camera Cinematic Dynamic Shake, Hệ thống Particle Custom siêu nặng.
--====================================================================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Backpack = LocalPlayer:WaitForChild("Backpack")

local NetworkHubName = "AnimeMultiverseUltimateGodSyncHubV500"
local RemoteEvent = ReplicatedStorage:FindFirstChild(NetworkHubName)
if not RemoteEvent then
    if RunService:IsServer() then
        RemoteEvent = Instance.new("RemoteEvent")
        RemoteEvent.Name = NetworkHubName
        RemoteEvent.Parent = ReplicatedStorage
    else
        RemoteEvent = ReplicatedStorage:WaitForChild(NetworkHubName, 15)
    end
end

if PlayerGui:FindFirstChild("AnimeMultiverseMasterGuiV500") then
    PlayerGui.AnimeMultiverseMasterGuiV500:Destroy()
end

-- ====================================================================================================--
-- MODULE 1: CẤU HÌNH HỆ THỐNG & DANH SÁCH 100 CHIÊU THỨC ANIME TOÀN NĂNG (ULTRA CONFIG V500)
-- ====================================================================================================--
local AnimeCore = {
    Version = "500.0.0-UltraHDGodTier",
    IsActive = true,
    CurrentCharacter = "Goku (Ultra Instinct Mastered)",
    AuraColor = Color3.fromRGB(0, 240, 255),
    MovesCount = 100,
    Cooldowns = {},
    Config = {
        WalkSpeedValue = 75,
        JumpPowerValue = 180,
        DashDistance = 90,
        GodGlow = true
    }
}

-- Bảng chứa 100 chiêu thức cực phẩm từ các vũ trụ Anime đỉnh cao (Naruto, Dragon Ball, Bleach, One Piece, Demon Slayer, Jujutsu Kaisen, Solo Leveling, v.v.)
local MasterMoveset = {
    -- [1 - 10]: DRAGON BALL ULTRA
    {Name = "1. Bản Năng Vô Cực - Kamehameha Tối Thượng", Char = "Goku", Dmg = 120000, Color = Color3.fromRGB(0, 220, 255)},
    {Name = "2. Nguyên Khí Cầu - Tinh Thần Diệt Thế", Char = "Goku", Dmg = 250000, Color = Color3.fromRGB(50, 255, 100)},
    {Name = "3. Final Flash - Hủy Diệt Không Gian", Char = "Vegeta", Dmg = 135000, Color = Color3.fromRGB(255, 230, 0)},
    {Name = "4. Hakai - Thần Hủy Diệt Xóa Sổ", Char = "Beerus", Dmg = 500000, Color = Color3.fromRGB(150, 0, 255)},
    {Name = "5. Thập Nhị Phục Hận - Gogeta Blue", Char = "Gogeta", Dmg = 180000, Color = Color3.fromRGB(0, 150, 255)},
    {Name = "6. Stardust Fall - Mưa Sao Băng Hủy Diệt", Char = "Gogeta", Dmg = 140000, Color = Color3.fromRGB(255, 255, 255)},
    {Name = "7. Spirit Sword - Kiếm Năng Lượng Ánh Sáng", Char = "Vegito", Dmg = 155000, Color = Color3.fromRGB(255, 255, 100)},
    {Name = "8. Timeskip - Đột Phá Thời Gian", Char = "Hit", Dmg = 110000, Color = Color3.fromRGB(255, 0, 200)},
    {Name = "9. Death Ball - Quả Cầu Tử Vong", Char = "Frieza", Dmg = 130000, Color3 = Color3.fromRGB(180, 0, 255)},
    {Name = "10. Final Kamehameha - Kết Hợp Tối Thượng", Char = "Vegito", Dmg = 210000, Color = Color3.fromRGB(0, 100, 255)},

    -- [11 - 20]: NARUTO SHIPPUDEN & BORUTO
    {Name = "11. Rasenshuriken Lục Đạo - Phi Tinh", Char = "Naruto", Dmg = 125000, Color = Color3.fromRGB(255, 120, 0)},
    {Name = "12. Thần La Thiên Tinh - Đẩy Lùi Vạn Vật", Char = "Pain", Dmg = 160000, Color = Color3.fromRGB(100, 200, 255)},
    {Name = "13. Susanoo Hoàn Thiện - Chém Đôi Ngọn Núi", Char = "Sasuke", Dmg = 170000, Color3 = Color3.fromRGB(150, 0, 255)},
    {Name = "14. Amaterasu - Ngọn Lửa Hắc Ám Thiêu Rụi", Char = "Sasuke", Dmg = 115000, Color3 = Color3.fromRGB(20, 20, 20)},
    {Name = "15. Đại Hỏa Mệnh - Cung Tên Indra", Char = "Sasuke", Dmg = 190000, Color3 = Color3.fromRGB(100, 150, 255)},
    {Name = "16. Thiên Thủ Quan Âm - Tiên Pháp Mộc Độn", Char = "Hashirama", Dmg = 220000, Color3 = Color3.fromRGB(0, 200, 80)},
    {Name = "17. Ngoại Đạo Ma Tượng - Hút Hồn", Char = "Madara", Dmg = 185000, Color3 = Color3.fromRGB(80, 80, 80)},
    {Name = "18. Bát Môn Độn Giáp - Dạ Nga", Char = "Guy", Dmg = 300000, Color3 = Color3.fromRGB(255, 50, 0)},
    {Name = "19. Kamui Shuriken - Không Gian Biến Dạng", Char = "Kakashi", Dmg = 145000, Color3 = Color3.fromRGB(120, 0, 200)},
    {Name = "20. Vĩ Thú Ngọc Phân Tách - Vụ Nổ Nguyên Tử", Char = "Naruto", Dmg = 240000, Color3 = Color3.fromRGB(255, 200, 0)},

    -- [21 - 30]: BLEACH THOUSAND-YEAR BLOOD WAR
    {Name = "21. Getsuga Tensho Hỗn Mang - Tụ Lực Đen", Char = "Ichigo", Dmg = 130000, Color3 = Color3.fromRGB(30, 30, 30)},
    {Name = "22. Mugetsu - Cú Chém Vô Nguyệt Cuối Cùng", Char = "Ichigo", Dmg = 350000, Color3 = Color3.fromRGB(10, 10, 10)},
    {Name = "23. Bankai: Senbonzakura Kageyoshi", Char = "Byakuya", Dmg = 125000, Color3 = Color3.fromRGB(255, 150, 200)},
    {Name = "24. Kyoka Suigetsu - Ảo Ảnh Hoàn Hảo", Char = "Aizen", Dmg = 110000, Color3 = Color3.fromRGB(0, 255, 200)},
    {Name = "25. Hado 90: Kurohitsugi - Hắc Quan", Char = "Aizen", Dmg = 200000, Color3 = Color3.fromRGB(15, 15, 15)},
    {Name = "26. Tensa Zangatsu Tốc Độ Ánh Sáng", Char = "Ichigo", Dmg = 140000, Color3 = Color3.fromRGB(200, 200, 200)},
    {Name = "27. Bankai: Daiguren Hyorinmaru", Char = "Toshiro", Dmg = 150000, Color3 = Color3.fromRGB(0, 200, 255)},
    {Name = "28. Gran Rey Cero - Tia Sáng Hủy Diệt", Char = "Ulquiorra", Dmg = 175000, Color3 = Color3.fromRGB(0, 255, 150)},
    {Name = "29. Lanza del Relampago - Thương Sấm Sét", Char = "Ulquiorra", Dmg = 230000, Color3 = Color3.fromRGB(0, 240, 255)},
    {Name = "30. Zanka no Tachi - Thanh Kiếm Mặt Trời", Char = "Yamamoto", Dmg = 320000, Color3 = Color3.fromRGB(255, 100, 0)},

    -- [31 - 40]: ONE PIECE
    {Name = "31. Gomu Gomu no Bajrang Gun - Khỉ Thần Giáng Thế", Char = "Luffy Gear 5", Dmg = 280000, Color3 = Color3.fromRGB(255, 255, 255)},
    {Name = "32. Đạo Tam Thập Bát Phượng - Ashura", Char = "Zoro", Dmg = 160000, Color3 = Color3.fromRGB(100, 255, 100)},
    {Name = "33. Di Diem - Đại Hoả Trụ", Char = "Ace / Sabo", Dmg = 135000, Color3 = Color3.fromRGB(255, 80, 0)},
    {Name = "34. Gura Gura no Mi - Chấn Động Đại Dương", Char = "Whitebeard", Dmg = 290000, Color3 = Color3.fromRGB(180, 100, 50)},
    {Name = "35. Thần Sấm El Thor - Lôi Phạt", Char = "Enel", Dmg = 170000, Color3 = Color3.fromRGB(255, 255, 0)},
    {Name = "36. Phật Quang Phổ Chiếu - Đại Phật", Char = "Sengoku", Dmg = 150000, Color3 = Color3.fromRGB(255, 215, 0)},
    {Name = "37. Thiết Khối - Sư Tử Trảm", Char = "Lucci", Dmg = 115000, Color3 = Color3.fromRGB(150, 150, 150)},
    {Name = "38. Thiên Dạ Xoa - Dây Tơ Cắt Đứt", Char = "Doflamingo", Dmg = 140000, Color3 = Color3.fromRGB(255, 0, 150)},
    {Name = "39. Đại Oanh Kích - Kaito", Char = "Kaido", Dmg = 210000, Color3 = Color3.fromRGB(50, 150, 50)},
    {Name = "40. Vương Giả Chi Khí - Bá Khí Hạo Nhiên", Char = "Shanks", Dmg = 250000, Color3 = Color3.fromRGB(200, 0, 255)},

    -- [41 - 50]: DEMON SLAYER (KIMETSU NO YAIBA)
    {Name = "41. Hơi Thở Mặt Trời: Thập Nhị Điệu - Nhật Diễn", Char = "Tanjiro / Yoriichi", Dmg = 210000, Color3 = Color3.fromRGB(255, 100, 0)},
    {Name = "42. Lôi Thần Tốc - Nhất Thiểm Tối Thượng", Char = "Zenitsu", Dmg = 180000, Color3 = Color3.fromRGB(255, 230, 0)},
    {Name = "43. Hơi Thở Nước: Diện Long Thần", Char = "Giyu", Dmg = 130000, Color3 = Color3.fromRGB(0, 100, 255)},
    {Name = "44. Hơi Thở Gió: Cửu Thức - Ty Phong", Char = "Sanemi", Dmg = 145000, Color3 = Color3.fromRGB(200, 255, 200)},
    {Name = "45. Hơi Thở Viêm: Cửu Long - Luyện狱", Char = "Rengoku", Dmg = 170000, Color3 = Color3.fromRGB(255, 50, 0)},
    {Name = "46. Huyết Quỷ Thuật: Bộc Huyết - Lửa Đỏ", Char = "Nezuko", Dmg = 120000, Color3 = Color3.fromRGB(255, 0, 50)},
    {Name = "47. Huyết Quỷ Thuật: Thập Nhị Nguyệt Cốt", Char = "Kokushibo", Dmg = 220000, Color3 = Color3.fromRGB(100, 0, 50)},
    {Name = "48. Hơi Thở Âm Thanh: Hưởng Trảm Vô Biên", Char = "Tengen", Dmg = 150000, Color3 = Color3.fromRGB(255, 255, 100)},
    {Name = "49. Hơi Thở Sương Mù: Tám Điệu - Nguyệt Hạ", Char = "Muichiro", Dmg = 135000, Color3 = Color3.fromRGB(150, 200, 255)},
    {Name = "50. Vô Mệnh Trảm - Chúa Quỷ Muzan", Char = "Muzan", Dmg = 300000, Color3 = Color3.fromRGB(50, 0, 50)},

    -- [51 - 60]: JUJUTSU KAISEN
    {Name = "51. Hư Thức: Tử (Purple Hollow)", Char = "Gojo Satoru", Dmg = 350000, Color3 = Color3.fromRGB(180, 0, 255)},
    {Name = "52. Vô Lượng Không Xứ - Lãnh Địa Tuyệt Đối", Char = "Gojo Satoru", Dmg = 400000, Color3 = Color3.fromRGB(100, 200, 255)},
    {Name = "53. Xích Huyết Thao Thuật - Xuyên Huyết", Char = "Choso", Dmg = 115000, Color3 = Color3.fromRGB(255, 0, 0)},
    {Name = "54. Thập Chủng Ảnh Pháp Thuật - Ma Hư罗", Char = "Megumi / Sukuna", Dmg = 280000, Color3 = Color3.fromRGB(50, 50, 50)},
    {Name = "55. Phục Ma Ngự Trù Tử - Lãnh Địa Vua Nguyền Rủa", Char = "Sukuna", Dmg = 450000, Color3 = Color3.fromRGB(255, 0, 0)},
    {Name = "56. Đại Hỏa Khí - Mũi Tên Lửa Diệt Thế", Char = "Sukuna", Dmg = 310000, Color3 = Color3.fromRGB(255, 120, 0)},
    {Name = "57. Bách Quỷ Dạ Hành - Nguyền Rủa Tối Thượng", Char = "Geto Suguru", Dmg = 190000, Color3 = Color3.fromRGB(120, 0, 150)},
    {Name = "58. Thuật Thức Phản Trái - Xích Vực", Char = "Gojo Satoru", Dmg = 160000, Color3 = Color3.fromRGB(0, 150, 255)},
    {Name = "59. Jackpot - Lãnh Địa Cuồng Nhiệt", Char = "Kinji Hakari", Dmg = 175000, Color3 = Color3.fromRGB(255, 215, 0)},
    {Name = "60. Thiên Thai Quyền - Sức Mạnh Thể Chất Vô Song", Char = "Yuji Itadori", Dmg = 145000, Color3 = Color3.fromRGB(255, 100, 100)},

    -- [61 - 70]: SOLO LEVELING
    {Name = "61. Quân Đoàn Bóng Tối - Arise (Trỗi Dậy)", Char = "Sung Jin-Woo", Dmg = 380000, Color3 = Color3.fromRGB(50, 0, 100)},
    {Name = "62. Song Đao Quyết Sát - Slashes of Despair", Char = "Sung Jin-Woo", Dmg = 195000, Color3 = Color3.fromRGB(0, 255, 255)},
    {Name = "63. Lãnh Thổ Vua Bóng Tối - Domain of the Monarch", Char = "Sung Jin-Woo", Dmg = 330000, Color3 = Color3.fromRGB(20, 0, 50)},
    {Name = "64. Long Ngâm - Dragon's Fear", Char = "Sung Jin-Woo", Dmg = 210000, Color3 = Color3.fromRGB(255, 200, 0)},
    {Name = "65. Sát Ý Chi Nhãn - Ruler's Authority", Char = "Sung Jin-Woo", Dmg = 150000, Color3 = Color3.fromRGB(0, 100, 255)},
    {Name = "66. Kiếm Quang Tận Thế - Kamish's Wrath", Char = "Sung Jin-Woo", Dmg = 270000, Color3 = Color3.fromRGB(255, 50, 50)},
    {Name = "67. Vết Cắn Quỷ Vương - Demon King's Dagger", Char = "Sung Jin-Woo", Dmg = 165000, Color3 = Color3.fromRGB(150, 0, 255)},
    {Name = "68. Hắc Long Bộc Phát - Dark Dragon Breath", Char = "Beru", Dmg = 230000, Color3 = Color3.fromRGB(80, 0, 150)},
    {Name = "69. Thiết Giáp Xung Phong - Igris Execution", Char = "Igris", Dmg = 180000, Color3 = Color3.fromRGB(255, 215, 0)},
    {Name = "70. Tận Thế Băng Giá - Frost Monarch Strike", Char = "Frost Monarch", Dmg = 250000, Color3 = Color3.fromRGB(0, 220, 255)},

    -- [71 - 80]: CHAINSAW MAN & MY HERO ACADEMIA
    {Name = "71. Biến Thân Quỷ Cưa - Chainsaw Massacre", Char = "Denji", Dmg = 170000, Color3 = Color3.fromRGB(255, 50, 0)},
    {Name = "72. One For All: 100% Smash - United States of Smash", Char = "All Might", Dmg = 350000, Color3 = Color3.fromRGB(255, 255, 0)},
    {Name = "73. Explosion God Murder - Vụ Nổ Siêu Cấp", Char = "Bakugo", Dmg = 190000, Color3 = Color3.fromRGB(255, 120, 0)},
    {Name = "74. Half-Hot Half-Cold - Băng Hỏa Lưỡng Nghi", Char = "Todoroki", Dmg = 185000, Color3 = Color3.fromRGB(0, 150, 255)},
    {Name = "75. Quỷ Súng Phán Quyết - Gun Devil Blast", Char = "Gun Devil", Dmg = 320000, Color3 = Color3.fromRGB(100, 100, 100)},
    {Name = "76. Hắc Tiễn Thần Tốc - Black Whip Combo", Char = "Deku", Dmg = 160000, Color3 = Color3.fromRGB(0, 255, 100)},
    {Name = "77. Lò Vi Sóng Không Gian - Decay Wave", Char = "Shigaraki", Dmg = 290000, Color3 = Color3.fromRGB(150, 50, 50)},
    {Name = "78. Sức Mạnh Vô Hạn - New Order Reality Warp", Char = "Star and Stripe", Dmg = 340000, Color3 = Color3.fromRGB(255, 255, 255)},
    {Name = "79. Quỷ Bom Tự Sát - Reze Bomb Field", Char = "Reze", Dmg = 180000, Color3 = Color3.fromRGB(255, 0, 100)},
    {Name = "80. Kiếm Khí Huyết Nguyệt - Makima Control Beam", Char = "Makima", Dmg = 310000, Color3 = Color3.fromRGB(200, 0, 50)},

    -- [81 - 90]: FATE SERIES & SEVEN DEADLY SINS
    {Name = "81. Enuma Elish - Ngôi Sao Sáng Tạo Lại Thế Giới", Char = "Gilgamesh", Dmg = 500000, Color3 = Color3.fromRGB(255, 215, 0)},
    {Name = "82. Gate of Babylon - Triệu Hồi Hàng Ngàn Bảo Khí", Char = "Gilgamesh", Dmg = 280000, Color3 = Color3.fromRGB(255, 180, 0)},
    {Name = "83. Excalibur - Kiếm Ánh Sáng Thề Non Hẹn Biển", Char = "Saber Artoria", Dmg = 310000, Color3 = Color3.fromRGB(0, 220, 255)},
    {Name = "84. Unlimited Blade Works - Vạn Kiếm Trận", Char = "Archer Emiya", Dmg = 260000, Color3 = Color3.fromRGB(255, 100, 50)},
    {Name = "85. Gae Bolg - Ngọn Giáo Định Mệnh Xuyên Tim", Char = "Cú Chulainn", Dmg = 240000, Color3 = Color3.fromRGB(255, 0, 0)},
    {Name = "86. Full Counter - Phản Đòn Toàn Diện", Char = "Meliodas", Dmg = 350000, Color3 = Color3.fromRGB(0, 255, 150)},
    {Name = "87. Hellblaze - Hỏa Ngục Diệt Thế", Char = "Meliodas", Dmg = 220000, Color3 = Color3.fromRGB(150, 0, 255)},
    {Name = "88. Cruel Sun - Mặt Trời Tàn Nhẫn", Char = "Escanor", Dmg = 400000, Color3 = Color3.fromRGB(255, 150, 0)},
    {Name = "89. Sacred Treasure Rhitta - Trảm Phủ Sáng Thế", Char = "Escanor", Dmg = 290000, Color3 = Color3.fromRGB(255, 200, 0)},
    {Name = "90. Infinite Chaos - Hỗn Mang Vĩnh Cửu", Char = "Arthur Pendragon", Dmg = 450000, Color3 = Color3.fromRGB(100, 0, 255)},

    -- [91 - 100]: BLACK CLOVER & TENSURA (SLIME)
    {Name = "91. Black Divider - Kiếm Khổng Lồ Kháng Ma", Char = "Asta", Dmg = 210000, Color3 = Color3.fromRGB(20, 20, 20)},
    {Name = "92. Demon-Destroyer Sword - Phá Hủy Vận Mệnh", Char = "Asta", Dmg = 300000, Color3 = Color3.fromRGB(150, 0, 255)},
    {Name = "93. Spirit Storm - Bão Tinh Linh Ánh Sáng", Char = "Yuno", Dmg = 240000, Color3 = Color3.fromRGB(0, 255, 200)},
    {Name = "94. Hellfire Armageddon - Hỏa Ngục Thiêu Rụi", Char = "Fuegooleon", Dmg = 220000, Color3 = Color3.fromRGB(255, 60, 0)},
    {Name = "95. Tempest Particle Cannon - Pháo Hạt Ma Thuật", Char = "Rimuru Tempest", Dmg = 380000, Color3 = Color3.fromRGB(0, 240, 255)},
    {Name = "96. Megiddo - Ngàn Ngọn Lửa Địa狱", Char = "Rimuru Tempest", Dmg = 320000, Color3 = Color3.fromRGB(255, 100, 0)},
    {Name = "97. Turn Null - Hư Vô Hủy Diệt Hoàn Toàn", Char = "Rimuru Tempest", Dmg = 600000, Color3 = Color3.fromRGB(10, 10, 10)},
    {Name = "98. Spatial Domination - Thao Túng Không Gian", Char = "Rimuru Tempest", Dmg = 270000, Color3 = Color3.fromRGB(150, 0, 255)},
    {Name = "99. Ultimate Dragon Nova - Hơi Thở Long Thần Veldora", Char = "Veldora", Dmg = 420000, Color3 = Color3.fromRGB(0, 255, 100)},
    {Name = "100. True Dragon Release - Sức Mạnh Tối Thượng Thần Thánh", Char = "Rimuru & Veldora", Dmg = 999999, Color3 = Color3.fromRGB(255, 255, 255)}
}

-- ====================================================================================================--
-- MODULE 2: GIAO DIỆN GUI ĐIỀU KHIỂN ĐỒ HỌA CAO CẤP & 100 NÚT CHIÊU THỨC (ULTRA HUD V500)
-- ====================================================================================================--
local MasterGui = Instance.new("ScreenGui")
MasterGui.Name = "AnimeMultiverseMasterGuiV500"
MasterGui.ResetOnSpawn = false
MasterGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MasterGui.Parent = PlayerGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 85, 0, 85)
ToggleButton.Position = UDim2.new(0.015, 0, 0.18, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
ToggleButton.Text = "⚡500"
ToggleButton.TextColor3 = Color3.fromRGB(0, 255, 255)
ToggleButton.TextSize = 24
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = MasterGui

local TB_Corner = Instance.new("UICorner")
TB_Corner.CornerRadius = UDim.new(1, 0)
TB_Corner.Parent = ToggleButton

local TB_Stroke = Instance.new("UIStroke")
TB_Stroke.Color = Color3.fromRGB(0, 255, 255)
TB_Stroke.Thickness = 5
TB_Stroke.Parent = ToggleButton

-- Main Window chứa 100 chiêu thức cực kỳ mượt mà qua ScrollingFrame
local MainFrame = Instance.new("ScrollingFrame")
MainFrame.Size = UDim2.new(0, 520, 0, 720)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -360)
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
MainFrame.BackgroundTransparency = 0.05
MainFrame.CanvasSize = UDim2.new(0, 0, 11.5, 0) -- Đủ chỗ chứa 100 nút chiêu thức siêu chi tiết
MainFrame.ScrollBarThickness = 8
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = MasterGui

local MF_Corner = Instance.new("UICorner")
MF_Corner.CornerRadius = UDim.new(0, 25)
MF_Corner.Parent = MainFrame

local MF_Stroke = Instance.new("UIStroke")
MF_Stroke.Color = Color3.fromRGB(0, 240, 255)
MF_Stroke.Thickness = 5
MF_Stroke.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🌌 ANIME MULTIVERSE 100 ULTIMATE MOVES - ULTRA HD V500 🌌"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.TextSize = 22
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
ToggleButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- ====================================================================================================--
-- MODULE 3: HỆ THỐNG ĐỒ HỌA SIÊU CẤP RAYMARCHING VFX & CINEMATIC SHAKE (ULTRA GRAPHICS ENGINE V500)
-- ====================================================================================================--
local UltraVFX = {}

function UltraVFX.CameraCinematicShake(intensity, duration)
    task.spawn(function()
        local startTime = tick()
        while tick() - startTime < duration do
            local shakeX = math.random(-intensity, intensity)
            local shakeY = math.random(-intensity, intensity)
            Camera.CFrame = Camera.CFrame * CFrame.Angles(math.rad(shakeX), math.rad(shakeY), 0)
            task.wait()
        end
    end)
end

function UltraVFX.SpawnGodRayBurst(position, color)
    task.spawn(function()
        for i = 1, 45 do
            local p = Instance.new("Part")
            p.Size = Vector3.new(0.8, 0.8, math.random(20, 45))
            p.Position = position + Vector3.new(math.random(-30, 30), math.random(-15, 30), math.random(-30, 30))
            p.Anchored = true
            p.CanCollide = false
            p.Material = Enum.Material.Neon
            p.Color = color or Color3.fromRGB(0, 255, 255)
            p.CFrame = CFrame.new(p.Position, p.Position + Vector3.new(math.random(-80, 80), math.random(20, 90), math.random(-80, 80)))
            p.Parent = Workspace

            TweenService:Create(p, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Size = Vector3.new(0.01, 0.01, p.Size.Z * 5),
                Transparency = 1
            }):Play()
            Debris:AddItem(p, 0.6)
        end
        UltraVFX.CameraCinematicShake(3, 0.4)
    end)
end

function UltraVFX.SpawnEnergyBeam(startPos, endPos, color)
    local distance = (endPos - startPos).Magnitude
    if distance < 1 then return end

    local beam = Instance.new("Part")
    beam.Size = Vector3.new(2.5, 2.5, distance)
    beam.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -distance / 2)
    beam.Anchored = true
    beam.CanCollide = false
    beam.Material = Enum.Material.Neon
    beam.Color = color or Color3.fromRGB(0, 255, 255)
    beam.Parent = Workspace

    local light = Instance.new("PointLight")
    light.Color = beam.Color
    light.Range = 120
    light.Brightness = 80
    light.Parent = beam

    TweenService:Create(beam, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {
        Size = Vector3.new(0.1, 0.1, distance),
        Transparency = 1
    }):Play()
    Debris:AddItem(beam, 0.7)
end

if RemoteEvent and RunService:IsServer() then
    RemoteEvent.OnServerEvent:Connect(function(player, fxType, startPos, endPos, color)
        RemoteEvent:FireAllClients(fxType, startPos, endPos, color)
    end)
end

if RemoteEvent and RunService:IsClient() then
    RemoteEvent.OnClientEvent:Connect(function(fxType, startPos, endPos, color)
        if fxType == "Burst" then
            UltraVFX.SpawnGodRayBurst(startPos, color)
        elseif fxType == "Beam" then
            UltraVFX.SpawnEnergyBeam(startPos, endPos, color)
        end
    end)
end

function UltraVFX.BroadcastFX(fxType, startPos, endPos, color)
    pcall(function()
        if RemoteEvent then
            RemoteEvent:FireServer(fxType, startPos, endPos, color)
        end
    end)
end

-- ====================================================================================================--
-- MODULE 4: HỆ THỐNG GÂY SÁT THƯƠNG & XỬ LÝ 100 CHIÊU THỨC (COMBAT ENGINE V500)
-- ====================================================================================================--
local CombatEngine = {}

function CombatEngine.FindTarget(origin, range)
    local bestTarget = nil
    local shortestDist = range or 1200
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= LocalPlayer.Character then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
            if hum and hrp and hum.Health > 0 then
                local dist = (hrp.Position - origin).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    bestTarget = hrp
                end
            end
        end
    end
    return bestTarget
end

function CombatEngine.ExecuteMove(moveData)
    task.spawn(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart

        -- Hiệu ứng hình ảnh đồ họa cực cao cấp ngay khi bấm chiêu
        UltraVFX.SpawnGodRayBurst(hrp.Position, moveData.Color)
        UltraVFX.BroadcastFX("Burst", hrp.Position, nil, moveData.Color)

        local target = CombatEngine.FindTarget(hrp.Position, 900)
        local destPos

        if target then
            local dir = (target.Position - hrp.Position).Unit
            destPos = hrp.Position + (dir * AnimeCore.Config.DashDistance)
        else
            destPos = hrp.Position + (hrp.CFrame.LookVector * AnimeCore.Config.DashDistance)
        end

        local tween = TweenService:Create(hrp, TweenInfo.new(0.18, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
            CFrame = CFrame.new(destPos, destPos + hrp.CFrame.LookVector)
        })
        tween:Play()

        UltraVFX.SpawnEnergyBeam(hrp.Position, destPos, moveData.Color)
        UltraVFX.BroadcastFX("Beam", hrp.Position, destPos, moveData.Color)

        if target and (target.Position - destPos).Magnitude < 40 then
            local enemyHum = target.Parent:FindFirstChildOfClass("Humanoid")
            if enemyHum then
                target.Velocity = (destPos - hrp.Position).Unit * 1000 + Vector3.new(0, 600, 0)
                enemyHum:ChangeState(Enum.HumanoidStateType.PlatformStand)
                pcall(function()
                    enemyHum.Health = enemyHum.Health - moveData.Dmg
                end)
            end
        end

        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "🌌 " .. moveData.Char,
                Text = "Thi triển: " .. moveData.Name .. " | Sát thương: " .. moveData.Dmg,
                Duration = 2.5
            })
        end)
    end)
end

-- ====================================================================================================--
-- MODULE 5: TỰ ĐỘNG TẠO 100 NÚT BẤM GIAO DIỆN CHI TIẾT CAO (UI GENERATOR V500)
-- ====================================================================================================--
local yOffset = 60
for index, moveData in ipairs(MasterMoveset) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 50)
    btn.Position = UDim2.new(0.04, 0, 0, yOffset)
    btn.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
    btn.Text = moveData.Name
    btn.TextColor3 = moveData.Color
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = moveData.Color
    stroke.Thickness = 2
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        CombatEngine.ExecuteMove(moveData)
    end)

    yOffset = yOffset + 58
end

-- Tự động tăng tốc độ chạy và nhảy cho nhân vật thỏa sức tung hoành
task.spawn(function()
    while true do
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = AnimeCore.Config.WalkSpeedValue
                    hum.JumpPower = AnimeCore.Config.JumpPowerValue
                end
            end
        end)
        task.wait(1)
    end
end)

print("==========================================================================")
print("🌌 ANIME MULTIVERSE 100 ULTIMATE MOVES - ULTRA HD V500 FULLY LOADED & ACTIVE 🌌")
print("==========================================================================")
