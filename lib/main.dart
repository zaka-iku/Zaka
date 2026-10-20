import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ZakaIOSApp());
}

class ZakaIOSApp extends StatelessWidget {
  const ZakaIOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'zaka.ios',
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: CupertinoColors.systemBlue,
      ),
      home: ZakaHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ZakaHomeScreen extends StatefulWidget {
  const ZakaHomeScreen({super.key});

  @override
  State<ZakaHomeScreen> createState() => _ZakaHomeScreenState();
}

class _ZakaHomeScreenState extends State<ZakaHomeScreen> {
  bool _isIslandExpanded = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          // 1. Hình nền iOS (Wallpaper)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=1000',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Màn hình ứng dụng chính (Grid App Icons)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 20, right: 20),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 25,
                      crossAxisSpacing: 20,
                      children: [
                        _buildAppIcon('Safari', CupertinoIcons.compass, Colors.blue),
                        _buildAppIcon('Ảnh', CupertinoIcons.photo, Colors.multicolor),
                        _buildAppIcon('Cài đặt', CupertinoIcons.gear_solid, Colors.grey),
                        _buildAppIcon('Nhạc', CupertinoIcons.music_note, Colors.red),
                        _buildAppIcon('Thời tiết', CupertinoIcons.cloud_sun_fill, Colors.lightBlue),
                        _buildAppIcon('Ghi chú', CupertinoIcons.doc_plaintext, Colors.orange),
                        _buildAppIcon('Máy tính', CupertinoIcons.number, Colors.black87),
                        _buildAppIcon('Đồng hồ', CupertinoIcons.time, Colors.black),
                      ],
                    ),
                  ),

                  // 3. Thanh Dock mờ phía dưới (iOS Dock)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        height: 95,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        color: Colors.white.withOpacity(0.25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildDockIcon(CupertinoIcons.phone_fill, Colors.green),
                            _buildDockIcon(CupertinoIcons.chat_bubble_2_fill, Colors.greenAccent.shade700),
                            _buildDockIcon(CupertinoIcons.mail_solid, Colors.blueAccent),
                            _buildDockIcon(CupertinoIcons.camera_fill, Colors.grey.shade800),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // 4. Dynamic Island (Đảo thích ứng)
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isIslandExpanded = !_isIslandExpanded;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  width: _isIslandExpanded ? 340 : 120,
                  height: _isIslandExpanded ? 80 : 35,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(_isIslandExpanded ? 35 : 20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: _isIslandExpanded
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(CupertinoIcons.music_note, color: Colors.pinkAccent, size: 28),
                                  SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'zaka.ios Player',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      Text(
                                        'Đang phát nhạc...',
                                        style: TextStyle(color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(CupertinoIcons.backward_fill, color: Colors.white, size: 18),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(CupertinoIcons.pause_fill, color: Colors.white, size: 18),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(CupertinoIcons.forward_fill, color: Colors.white, size: 18),
                                    onPressed: () {},
                                  ),
                                ],
                              )
                            ],
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(CupertinoIcons.sparkles, color: Colors.orange, size: 14),
                              Text(
                                "zaka.ios",
                                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              Icon(CupertinoIcons.battery_100, color: Colors.green, size: 14),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget tạo Icon ứng dụng
  Widget _buildAppIcon(String label, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color == Colors.multicolor ? Colors.white : color,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // Widget tạo Icon trên thanh Dock
  Widget _buildDockIcon(IconData icon, Color color) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, color: Colors.white, size: 30),
    );
  }
}
