import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intetership_project/consts/colors.dart';
import 'package:intetership_project/feature/registration/pages/login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final nickNameController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> register(
    String nickName,
    String email,
    String name,
    String lastName,
    String phoneNumber,
    String password,
    String confirmPassword,
  ) async {
    try {
      var response = await http.post(
        Uri.parse('http://147.45.145.240:8001/auth/register/'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': nickName,
          'email': email,
          'first_name': name,
          'last_name': lastName,
          'phone_number': phoneNumber,
          'password': password,
          'password2': confirmPassword,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showError('You registered successfully!');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        var body = jsonDecode(response.body);
        if (body is Map && body.containsKey('errors')) {
          final errors = body['errors'] as Map<String, dynamic>;
          final errorMessages = errors.values
              .map((e) => e is List ? e.join(', ') : e.toString())
              .join('\n');
          showError(errorMessages);
        } else if (body is Map && body.values.first is List) {
          final errorMessages = body.entries
              .map((e) => '${e.key}: ${(e.value as List).join(', ')}')
              .join('\n');
          showError(errorMessages);
        } else {
          showError(body.toString());
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    nickNameController.dispose();
    emailController.dispose();
    nameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildTextFormField(
    String hint,
    TextEditingController controller, {
    bool isPassword = false,
    bool isRequired = false,
    bool validateMatch = false,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF4A90E2)) : null,
          hintText: hint,
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey[500]),
          fillColor: Colors.grey[100],
          filled: true,
          errorStyle: TextStyle(
            color: Colors.red[400],
            fontWeight: FontWeight.bold,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        validator: (value) {
          if (isRequired && (value == null || value.trim().isEmpty)) {
            return 'Лутфан ин майдонро пур кунед';
          }
          if (validateMatch && value != passwordController.text) {
            return 'Паролҳо мувофиқ нестанд';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final isNarrow = width < 500;
    final formHorizontalPadding = isNarrow ? 16.0 : 24.0;
    final headerHeight = media.size.height * 0.24;
    final avatarRadius = isNarrow ? 72.0 : 94.0;

    return Scaffold(
      // backgroundColor: backLearGradient1,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
             Color.fromARGB(255, 46, 123, 211),
                        Color(0xFF50E3C2),
          ])
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: headerHeight,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 46, 123, 211),
                        Color(0xFF50E3C2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: media.size.height * 0.015),
                        CircleAvatar(
                          radius: avatarRadius,
                          // backgroundColor: backLearGradient2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
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
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(-5, 1),
                                  spreadRadius: 5,
                                  blurRadius: 8,
                                  color: Color.fromARGB(255, 103, 214, 197),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(width * 0.02),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Image.asset(
                                'assets/images/image-removebg-preview (3) 1.png',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: media.size.height * 0.008),
                        const Text(
                          'Аккаунт созед!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: formHorizontalPadding,
                    vertical: 18,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 100, 87, 192),
                          // Color.fromARGB(255, 69, 57, 161),
                          Color.fromARGB(255, 34, 88, 142),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextFormField(
                            'NickName',
                            nickNameController,
                            icon: Icons.person_outline,
                            isRequired: true,
                          ),
                          _buildTextFormField(
                            'Почтаи электрони',
                            emailController,
                            isRequired: true,
                            icon: Icons.email_outlined,
                          ),
                          _buildTextFormField(
                            'Ном',
                            nameController,
                            icon: Icons.account_circle_outlined,
                          ),
                          _buildTextFormField(
                            'Фамилия',
                            lastNameController,
                            icon: Icons.account_box_outlined,
                          ),
                          _buildTextFormField(
                            'Рақами телефон',
                            phoneNumberController,
                            icon: Icons.phone_outlined,
                          ),
                          _buildTextFormField(
                            'Рамзи махфӣ',
                            passwordController,
                            isPassword: true,
                            isRequired: true,
                            icon: Icons.lock_outline,
                          ),
                          _buildTextFormField(
                            'Такрори рамзи махфи',
                            confirmPasswordController,
                            isPassword: true,
                            isRequired: true,
                            validateMatch: true,
                            icon: Icons.lock_reset_outlined,
                          ),
                          SizedBox(height: media.size.height * 0.02),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await register(
                                    nickNameController.text,
                                    emailController.text,
                                    nameController.text,
                                    lastNameController.text,
                                    phoneNumberController.text,
                                    passwordController.text,
                                    confirmPasswordController.text,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                backgroundColor: const Color(0xFF4A90E2),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text(
                                'Регистрация',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Divider(color: Colors.white70, thickness: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'ё',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Colors.white70, thickness: 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Аллакай аккаунт доред?',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Ворид шавед',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: media.size.height * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
