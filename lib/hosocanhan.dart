import 'package:flutter/material.dart';
import 'music.dart'; // Import file music.dart

class ProfilePage extends StatefulWidget {
  final String username;

  ProfilePage({Key? key, required this.username}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _name;
  late String _email;
  late String _dob;
  late String _sothich;

  @override
  void initState() {
    super.initState();
    _name = widget.username;
    _email = 'phuc@gmail.com';
    _dob = '09/05/2003';
    _sothich = 'Nghe nhạc, đọc sách, chơi game';
  }

  void _editProfile() async {
    TextEditingController nameController = TextEditingController(text: _name);
    TextEditingController emailController = TextEditingController(text: _email);
    TextEditingController dobController = TextEditingController(text: _dob);
    TextEditingController sothichController =
        TextEditingController(text: _sothich);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Chỉnh sửa thông tin",
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Tên",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: nameController,
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: emailController,
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: "Ngày sinh",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: dobController,
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: "Sở thích",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: sothichController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Thoát", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _name = nameController.text;
                  _email = emailController.text;
                  _dob = dobController.text;
                  _sothich = sothichController.text;
                });
                Navigator.pop(context);
              },
              child: Text("Lưu"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToFavoriteSongs() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MusicScr()), // Điều hướng tới MusicPage
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE3FDFD), // Màu pastel nhẹ
              Color(0xFFFFE6FA), // Màu pastel nhạt
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                "Thông tin cá nhân",
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withOpacity(0.8),
              backgroundImage: AssetImage('assets/images/imageAVT.jpg'),
            ),
            SizedBox(height: 20),
            Text(
              _name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Text(
              _email,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Divider(
              thickness: 1,
              color: Colors.grey.withOpacity(0.5),
              indent: 30,
              endIndent: 30,
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Sở thích:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                _sothich,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
            SizedBox(height: 20),
            Divider(thickness: 1, color: Colors.grey),
            ListTile(
              leading: Icon(Icons.favorite, color: Colors.green),
              title: Text(
                "Danh sách phát - Bài hát yêu thích",
                style: TextStyle(color: Colors.black87),
              ),
              trailing: Icon(Icons.arrow_forward, color: Colors.grey),
              onTap: _navigateToFavoriteSongs, // Gọi hàm điều hướng
            ),
            Spacer(),
            ElevatedButton.icon(
              onPressed: _editProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              icon: Icon(Icons.edit, color: Colors.black),
              label: Text(
                "Chỉnh sửa thông tin",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
