import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicfiy/login_page.dart'; // Import LoginPage
import 'music.dart'; // Import MusicScr để điều hướng
import 'PodcastPage.dart' as podcast; // Import PodcastPage để điều hướng
import 'hosocanhan.dart'; // Import ProfilePage để điều hướng
import 'MusicPage.dart'; // Import MusicPage để điều hướng

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String query = "";
  List<String> categories = [
    'Nhạc',
    'Podcasts',
    'Sự kiện trực tiếp',
    'Nhạc trong năm 2024',
    'Podcast hay nhất năm 2024',
    'Dành Cho Bạn',
    'Mới phát hành',
    'Nhạc Việt'
  ];
  List<String> filteredCategories = [];

  final Box _boxLogin = Hive.box("login"); // Lưu trữ trạng thái đăng nhập

  @override
  void initState() {
    super.initState();
    filteredCategories = categories; // Initially, all categories are shown
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      query = newQuery;
      filteredCategories = categories
          .where((category) =>
              category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra trạng thái đăng nhập, nếu chưa đăng nhập thì chuyển về trang Login
    if (_boxLogin.get("loginStatus") == null ||
        _boxLogin.get("loginStatus") == false) {
      return LoginPage(); // Nếu chưa đăng nhập, chuyển về trang đăng nhập
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Tìm kiếm...",
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              border: InputBorder.none,
            ),
            onChanged: (value) {
              updateSearchQuery(value);
            },
          ),
        ),
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4ECDC4), Color(0xFF556270)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4ECDC4), Color(0xFF556270)],
                ),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.favorite,
              text: 'Bài hát yêu thích',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MusicScr()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.person,
              text: 'Hồ sơ cá nhân',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(username: _boxLogin.get("userName"))),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.logout,
              text: 'Đăng xuất',
              onTap: () {
                _boxLogin.put("loginStatus", false);
                _boxLogin.delete("userName");

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'Bạn muốn nghe gì hôm nay?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3 / 2,
              ),
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                return _buildTile(filteredCategories[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(String title) {
    Color tileColor;
    IconData icon;

    switch (title) {
      case 'Nhạc':
        tileColor = Colors.blueAccent;
        icon = Icons.music_note;
        break;
      case 'Podcasts':
        tileColor = Colors.deepPurple;
        icon = Icons.mic;
        break;
      case 'Sự kiện trực tiếp':
        tileColor = Colors.orange;
        icon = Icons.event;
        break;
      case 'Nhạc trong năm 2024':
        tileColor = Colors.teal;
        icon = Icons.calendar_today;
        break;
      case 'Podcast hay nhất năm 2024':
        tileColor = Colors.pinkAccent;
        icon = Icons.stars;
        break;
      case 'Dành Cho Bạn':
        tileColor = Colors.blue;
        icon = Icons.person;
        break;
      case 'Mới phát hành':
        tileColor = Colors.green;
        icon = Icons.new_releases;
        break;
      case 'Nhạc Việt':
        tileColor = Colors.indigo;
        icon = Icons.music_video;
        break;
      default:
        tileColor = Colors.grey;
        icon = Icons.category;
    }

    return GestureDetector(
      onTap: () {
        // Điều hướng dựa trên tiêu đề danh mục
        if (title == 'Nhạc') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MusicPage()), // Điều hướng tới MusicPage
          );
        } else if (title == 'Podcasts') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    podcast.PodcastPage()), // Điều hướng tới PodcastPage
          );
        } else if (title == 'Sự kiện trực tiếp') {
          // Điều hướng tới trang sự kiện trực tiếp (nếu có)
          print('Điều hướng tới trang sự kiện trực tiếp');
        } else if (title == 'Nhạc trong năm 2024') {
          // Điều hướng tới danh sách nhạc trong năm 2024
          print('Điều hướng tới danh sách nhạc trong năm 2024');
        } else if (title == 'Podcast hay nhất năm 2024') {
          // Điều hướng tới danh sách podcast hay nhất năm 2024
          print('Điều hướng tới danh sách podcast hay nhất năm 2024');
        } else if (title == 'Dành Cho Bạn') {
          // Điều hướng tới nội dung dành cho bạn
          print('Điều hướng tới nội dung dành cho bạn');
        } else if (title == 'Mới phát hành') {
          // Điều hướng tới danh sách mới phát hành
          print('Điều hướng tới danh sách mới phát hành');
        } else if (title == 'Nhạc Việt') {
          // Điều hướng tới danh sách nhạc Việt
          print('Điều hướng tới danh sách nhạc Việt');
        } else {
          // Xử lý khi nhấn vào danh mục không xác định
          print('Danh mục không xác định: $title');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [tileColor.withOpacity(0.8), tileColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
