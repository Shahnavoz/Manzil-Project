import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intetership_project/feature/profile/data/models/profile_model.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final user = await getUserInfo();
    if (!mounted) return;
    if (user != null) {
      firstNameController.text = user.firstName ?? '';
      lastNameController.text = user.lastName ?? '';
      emailController.text = user.email;
      phoneController.text = user.phoneNumber ?? '';
    }
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> saveChanges() async {
    final success = await updateProfile({
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'phone_number': phoneController.text,
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Профиль обновлён' : 'Ошибка при обновлении'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final isNarrow = width < 600;

    final double avatarRadius = isNarrow ? 36 : 44;
    final double spacingLarge = isNarrow ? 16 : 24;
    final double spacingMid = isNarrow ? 14 : 20;
    final double inputVertical = isNarrow ? 12 : 16;
    final double buttonHeight = isNarrow ? 50 : 56;
    final double fontSizeTitle = isNarrow ? 18 : 20;

    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Загрузка профиля...',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Редактировать профиль',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: fontSizeTitle),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: spacingLarge, vertical: spacingMid),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Header
            Container(
              padding: EdgeInsets.all(spacingMid),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: Colors.blue[100],
                    child: Icon(
                      Icons.person,
                      size: avatarRadius,
                      color: Colors.blue[600],
                    ),
                  ),
                  SizedBox(height: spacingMid / 1.5),
                  Text(
                    'Личная информация',
                    style: TextStyle(
                      fontSize: isNarrow ? 16 : 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Обновите свои данные',
                    style: TextStyle(fontSize: isNarrow ? 12 : 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            SizedBox(height: spacingLarge),

            // Form Fields
            Container(
              padding: EdgeInsets.all(spacingMid),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildTextField(
                    controller: firstNameController,
                    label: 'Имя',
                    icon: Icons.person_outline,
                    verticalPadding: inputVertical,
                  ),
                  SizedBox(height: spacingMid),
                  _buildTextField(
                    controller: lastNameController,
                    label: 'Фамилия',
                    icon: Icons.person_outline,
                    verticalPadding: inputVertical,
                  ),
                  SizedBox(height: spacingMid),
                  _buildTextField(
                    controller: emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    verticalPadding: inputVertical,
                  ),
                  SizedBox(height: spacingMid),
                  _buildTextField(
                    controller: phoneController,
                    label: 'Телефон',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    verticalPadding: inputVertical,
                  ),
                ],
              ),
            ),

            SizedBox(height: spacingLarge),

            // Save Button
            SizedBox(
              height: buttonHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.blue[600]!, Colors.blue[700]!],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    saveChanges();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save_outlined, color: Colors.white, size: isNarrow ? 18 : 20),
                      SizedBox(width: 8),
                      Text(
                        'Сохранить изменения',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isNarrow ? 14 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    double verticalPadding = 16,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: verticalPadding,
        ),
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
      style: const TextStyle(fontSize: 16, color: Colors.black87),
    );
  }
}

final storage = FlutterSecureStorage();
Future<ProfileModel?> getUserInfo() async {
  try {
    var token = await storage.read(key: 'token');
    var response = await http.get(
      Uri.parse('http://147.45.145.240:8001/auth/profile/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProfileModel.fromMap(data);
    } else {
      return null;
    }
  } catch (e) {
    debugPrint('Ошибка загрузки профиля: $e');
    return null;
  }
}

Future<bool> updateProfile(Map<String, dynamic> updateData) async {
  try {
    var token = await storage.read(key: 'token');
    var response = await http.patch(
      Uri.parse('http://147.45.145.240:8001/auth/profile/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(updateData),
    );
    debugPrint(response.body);

    return response.statusCode == 200;
  } catch (e) {
    debugPrint('Ошибка обновления профиля: $e');
    return false;
  }
}
