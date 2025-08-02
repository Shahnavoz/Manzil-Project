import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/profile_model.dart';

class ProfileService {
  final storage = FlutterSecureStorage();

  Future<ProfileModel?> getUserInfo() async {
    try {
      var token = await storage.read(key: 'token');

      var response = await http.get(
        Uri.parse('http://147.45.145.240:8001/auth/profile/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return fromBackend(response.body); // ← возвращаем профиль
      } else {
        print('Ошибка: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Ошибка запроса: $e');
      return null;
    }
  }

  Future<ProfileModel?> getProfile() async {
    try {
      var token = await storage.read(key: 'token');
      final response = await http.get(
        Uri.parse('http://147.45.145.240:8001/auth/profile/'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return ProfileModel.fromMap(decoded);
      } else {
        throw Exception('Ошибка загрузки профиля');
      }
    } catch (e) {
      print('Ошибка запроса: $e');
      return null;
    }
  }

  Future<ProfileModel?> getCurrentUser() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse('http://147.45.145.240:8001/auth/user/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Current user response status: ${response.statusCode}');
      print('Current user response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to fetch current user: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching current user: $e');
      return null;
    }
  }

  Future<void> deleteUser(int userId) async {
  final token = await storage.read(key: 'token');

  final response = await http.delete(
    Uri.parse('http://147.45.145.240:8001/auth/profile/$userId/'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 204 && response.statusCode != 200) {
    throw Exception(
      'Не удалось удалить пользователя. Код: ${response.statusCode}',
    );
  }
}

}
