import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intetership_project/feature/registration/pages/login_page.dart';

final storage = FlutterSecureStorage();

/// Вызывает запрос к бэкенду для выхода
Future<void> logout() async {
  final accessToken = await storage.read(key: 'token');
  final refreshToken = await storage.read(key: 'refresh_token');

  if (refreshToken == null) {
    throw Exception('❌ Refresh token отсутствует');
  }

  final url = Uri.parse('http://147.45.145.240:8001/auth/logout/');

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'refresh': refreshToken}),
  );

  print('Статус ответа: ${response.statusCode}');
  print('Ответ: ${response.body}');

  if (response.statusCode == 200) {
    await storage.delete(key: 'token');
    await storage.delete(key: 'refresh_token');
    print('✅ Успешный выход');
  } else {
    throw Exception('❌ Ошибка выхода: ${response.statusCode}');
  }
}

/// Показывает диалог подтверждения выхода
Future<void> confirmLogout(BuildContext context) async {
  final shouldLogout = await showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text('Подтверждение'),
          content: Text('Вы уверены, что хотите выйти?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Выйти'),
            ),
          ],
        ),
  );

  if (shouldLogout == true) {
    try {
      await logout();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    }
  }
}
