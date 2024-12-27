import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicfiy/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Hive và mở box
  await Hive.initFlutter();
  await Hive.openBox("login"); // Box lưu trạng thái đăng nhập
  await Hive.openBox("accounts"); // Box lưu thông tin tài khoản

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng Dụng Phát Nhạc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(), // Điều hướng đến trang đăng nhập
    );
  }
}
