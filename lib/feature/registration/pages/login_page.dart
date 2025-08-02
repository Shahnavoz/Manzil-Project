import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intetership_project/consts/colors.dart';
import 'package:intetership_project/feature/bottom_bar/presentation/pages/bottom__nav_page.dart';
import 'package:intetership_project/feature/home/presentation/pages/home_page.dart';
import 'package:intetership_project/feature/registration/pages/admin_page.dart';
import 'package:intetership_project/feature/registration/pages/registration_page.dart';
import 'package:intetership_project/feature_admin/bottom_nav_page/presentation/pages/bottom__nav_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(text: "admin@gmail.com");
  final passwordController = TextEditingController(text: "1234");
  final storage = const FlutterSecureStorage();
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> login(String email, String password) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final uri = Uri.parse('http://147.45.145.240:8001/auth/login/');
      final headers = {
        'Content-Type': 'application/json; Charset=UTF-8',
        'Accept': 'application/json',
      };
      final body = jsonEncode({'email': email, 'password': password});

      var response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final token = jsonBody['token'] ?? jsonBody['access'] ?? jsonBody['data'];
        final refreshToken =
            jsonBody['token'] ?? jsonBody['refresh'] ?? jsonBody['data'];

        await storage.write(key: 'token', value: token);
        await storage.write(key: 'refresh_token', value: refreshToken);

        if (!mounted) return;
        if (email == 'admin@gmail.com') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => AdminBottomPage()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => BottomNavPage()));
        }

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Успешно: ${response.body}')),
        // );
      } else {
        // Попытка по username
        var usernameResponse = await http.post(
          uri,
          headers: headers,
          body: jsonEncode({'username': email, 'password': password}),
        );
        dynamic bodyDecoded;
        try {
          bodyDecoded = jsonDecode(response.body);
        } catch (_) {
          showError('Пользователь не найден или неверные данные');
          return;
        }

        if (bodyDecoded is Map && bodyDecoded.containsKey('detail')) {
          showError(bodyDecoded['detail'].toString());
        } else if (bodyDecoded is Map &&
            bodyDecoded.values.first is List<dynamic>) {
          final errorMessages = bodyDecoded.entries
              .map((e) => '${e.key}: ${(e.value as List).join(', ')}')
              .join('\n');
          showError(errorMessages);
        } else {
          showError(bodyDecoded.toString());
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка сети: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: const Color(0xFF6D5BFF)),
      suffixIcon: suffixIcon,
      hintText: hint,
      hintStyle: TextStyle(fontSize: 16, color: Colors.grey[500]),
      filled: true,
      fillColor: Colors.white.withOpacity(0.92),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(22),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF6D5BFF), width: 2),
        borderRadius: BorderRadius.circular(22),
      ),
      errorStyle: const TextStyle(color: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final isNarrow = width < 500;
    final formMaxWidth = isNarrow ? width * 0.9 : 480.0;

    return Scaffold(
      body: Stack(
        children: [
          // Градиентный фон
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6D5BFF),
                    Color(0xFF46A0FC),
                    Color(0xFF23D2B7),
                    Color.fromARGB(255, 41, 101, 161),
                    Color.fromARGB(255, 11, 73, 63),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Плавающие фигуры
                  Positioned(
                    top: media.size.height * 0.1,
                    left: width * 0.05,
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 2),
                      width: width * 0.25,
                      height: width * 0.25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.12),
                            blurRadius: 32,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: media.size.height * 0.08,
                    right: width * 0.07,
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 2),
                      width: width * 0.17,
                      height: width * 0.17,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.10),
                            blurRadius: 24,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Форма
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: formMaxWidth),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 58,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.35),
                      width: 1.2,
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Аватар / логотип
                        Container(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6D5BFF)
                                      .withOpacity(0.5),
                                  blurRadius: 36,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(55),
                                  bottomRight: Radius.circular(6),
                                ),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF6D5BFF),
                                    Color.fromARGB(255, 71, 51, 224),
                                    Color(0xFF46A0FC),
                                    Color.fromARGB(255, 30, 103, 176),
                                    Color.fromARGB(255, 21, 105, 92),
                                    Color.fromARGB(255, 175, 211, 206),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(-5, 1),
                                    spreadRadius: 5,
                                    blurRadius: 8,
                                    color: const Color.fromARGB(
                                            255, 103, 214, 197)
                                        .withOpacity(0.9),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(width * 0.02),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Image.asset(
                                  'assets/images/image-removebg-preview (3) 1.png',
                                  height: isNarrow ? 60 : 90,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Заголовок
                        Text(
                          'Хушомадед!',
                          style: TextStyle(
                            fontSize: isNarrow ? 26 : 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Ба аккаунти худ ворид шавед!',
                          style: TextStyle(
                            fontSize: isNarrow ? 16 : 18,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Email
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Лутфан почтаро ворид кунед';
                            }
                            final emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            if (!emailRegex.hasMatch(value)) {
                              return 'Формати почта нодуруст аст';
                            }
                            return null;
                          },
                          decoration: _inputDecoration(
                            hint: 'Почтаи электрони',
                            icon: Icons.email_outlined,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Пароль
                        TextFormField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Лутфан рамзи махфиро ворид кунед';
                            }
                            return null;
                          },
                          decoration: _inputDecoration(
                            hint: 'Рамзи махфи',
                            icon: Icons.lock_outline,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xFF6D5BFF),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Кнопка
                        SizedBox(
                          width: double.infinity,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6D5BFF), Color(0xFF23D2B7)],
                              ),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        login(emailController.text.trim(),
                                            passwordController.text);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 0),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      'Воридшавӣ',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Регистрация
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Аъзо нестед?',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: isNarrow ? 14 : 16,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegistrationPage()),
                                );
                              },
                              child: Text(
                                'Регистрация',
                                style: TextStyle(
                                  color: const Color(0xFF23D2B7),
                                  fontWeight: FontWeight.bold,
                                  fontSize: isNarrow ? 14 : 16,
                                ),
                              ),
                            ),
                          ],
                        ),
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
}
