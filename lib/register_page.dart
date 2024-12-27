import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';
import 'login_page.dart'; // Import the login page

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  final Box _boxAccounts = Hive.box("accounts"); // Box for storing accounts

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _playMusic(); // Play music on page load
  }

  Future<void> _playMusic() async {
    if (!_isPlaying) {
      await _audioPlayer.play(AssetSource('we_wish_you_a_merry_christmas.mp3'));
      _isPlaying = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background animation using Lottie
          Lottie.asset(
            'assets/christmas_snowfall.json',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 150),
                  Text(
                    "Tạo tài khoản",
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
                    "Đăng ký để bắt đầu thế giới nhạc của bạn",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 60),

                  // Username input
                  _buildInputField(
                    controller: _controllerUsername,
                    labelText: "Tên tài khoản",
                    icon: Icons.person_outline,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Hãy nhập tên tài khoản.";
                      } else if (_boxAccounts.containsKey(value)) {
                        return "Tài khoản đã được đăng ký.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Password input
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
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Hãy nhập mật khẩu.";
                      } else if (value.length < 6) {
                        return "Mật khẩu phải chứa ít nhất 6 ký tự.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Confirm password input
                  _buildInputField(
                    controller: _controllerConfirmPassword,
                    labelText: "Nhập lại mật khẩu",
                    icon: Icons.password_outlined,
                    obscureText: _obscurePassword,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Hãy nhập lại mật khẩu.";
                      } else if (value != _controllerPassword.text) {
                        return "Mật khẩu không khớp.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 60),

                  // Register button
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
                        // Store account in Hive
                        _boxAccounts.put(
                          _controllerUsername.text,
                          _controllerPassword.text,
                        );

                        // Navigate to login page after registration
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Đăng ký",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Link to login page
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
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
                          "Bạn đã có tài khoản?",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Đăng nhập",
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
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    _controllerConfirmPassword.dispose();
    super.dispose();
  }
}
