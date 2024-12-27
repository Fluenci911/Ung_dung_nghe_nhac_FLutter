import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart'; // Updated import to ProfilePage
import 'register_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final FocusNode _focusNodePassword = FocusNode();

  bool _obscurePassword = true;
  final Box _boxLogin = Hive.box("login");
  final Box _boxAccounts = Hive.box("accounts");
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _playMusic(); // Tự động phát nhạc khi vào trang
  }

  Future<void> _playMusic() async {
    if (!_isPlaying) {
      await _audioPlayer.play(AssetSource('we_wish_you_a_merry_christmas.mp3'));
      _isPlaying = true;
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dừng nhạc khi rời khỏi trang
    _focusNodePassword.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_boxLogin.get("loginStatus") ?? false) {
      return HomePage();
    }

    return Scaffold(
      body: Stack(
        children: [
          // Nền động Lottie
          Lottie.asset(
            'assets/christmas_snowfall.json', // Đường dẫn đến tệp hoạt ảnh
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Nội dung chính
          SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 150),
                  Text(
                    "Chào mừng",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(3.0, 3.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Đăng nhập tài khoản để đến thế giới nhạc",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 60),
                  _buildInputField(
                    controller: _controllerUsername,
                    labelText: "Tên tài khoản",
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Hãy nhập tên tài khoản.";
                      } else if (!_boxAccounts.containsKey(value)) {
                        return "Tài khoản chưa được đăng ký.";
                      }
                      return null;
                    },
                    onEditingComplete: () => _focusNodePassword.requestFocus(),
                  ),
                  const SizedBox(height: 10),
                  _buildInputField(
                    controller: _controllerPassword,
                    labelText: "Mật khẩu",
                    icon: Icons.password_outlined,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: _obscurePassword
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Hãy nhập mật khẩu.";
                      } else if (value !=
                          _boxAccounts.get(_controllerUsername.text)) {
                        return "Mật khẩu sai.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.purpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shadowColor: Colors.black.withOpacity(0.5),
                      elevation: 10,
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _boxLogin.put("loginStatus", true);
                        _boxLogin.put("userName", _controllerUsername.text);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ));
                      }
                    },
                    child: const Text(
                      "Đăng nhập",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Link to Register page
                  Container(
                    decoration: BoxDecoration(
                      color:
                          Colors.black.withOpacity(0.5), // Nền bán trong suốt
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Bạn không có tài khoản?",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () {
                            _formKey.currentState?.reset();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()),
                            );
                          },
                          child: const Text(
                            "Đăng ký",
                            style: TextStyle(
                                color: Colors.purpleAccent, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    required String? Function(String?) validator,
    Function()? onEditingComplete,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.7),
      ),
      validator: validator,
      onEditingComplete: onEditingComplete,
    );
  }
}
