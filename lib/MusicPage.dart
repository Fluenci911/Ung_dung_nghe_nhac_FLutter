import 'package:flutter/material.dart';

class MusicPage extends StatelessWidget {
  // Danh sách các danh mục với tên, màu nền và biểu tượng
  final List<Map<String, dynamic>> categories = [
    {
      "title": "Nhạc trong năm 2024",
      "color": [Colors.green, Colors.lightGreen],
      "icon": Icons.calendar_today,
    },
    {
      "title": "Dành Cho Bạn",
      "color": [Colors.blue, Colors.lightBlueAccent],
      "icon": Icons.person,
    },
    {
      "title": "Mới phát hành",
      "color": [Colors.lightGreen, Colors.teal],
      "icon": Icons.new_releases,
    },
    {
      "title": "Nhạc Việt",
      "color": [Colors.teal, Colors.cyan],
      "icon": Icons.music_video,
    },
    {
      "title": "Pop",
      "color": [Colors.indigo, Colors.purple],
      "icon": Icons.audiotrack,
    },
    {
      "title": "K-Pop",
      "color": [Colors.red, Colors.pink],
      "icon": Icons.star,
    },
    {
      "title": "Hip-Hop",
      "color": [Colors.orange, Colors.deepOrange],
      "icon": Icons.headphones,
    },
    {
      "title": "Bảng xếp hạng",
      "color": [Colors.purple, Colors.deepPurpleAccent],
      "icon": Icons.bar_chart,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục nhạc'),
        backgroundColor: Colors.deepPurpleAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Quay lại HomePage
            Navigator.pop(context);
          },
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Hiển thị 2 cột
          crossAxisSpacing: 16, // Khoảng cách giữa các cột
          mainAxisSpacing: 16, // Khoảng cách giữa các hàng
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              // Hiện thông báo khi nhấn vào danh mục
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Bạn đã chọn: ${category["title"]}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: category["color"], // Gradient màu nền
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: category["color"][0].withOpacity(0.6),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category["icon"], // Biểu tượng danh mục
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    category["title"], // Tên danh mục
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.black, // Nền đen cho toàn màn hình
    );
  }
}
