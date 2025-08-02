import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:intetership_project/feature_admin/chats/data/models/company_get_chat_model.dart';

class CompanyChatService {
  var storage = FlutterSecureStorage();
  Future<List<CompanyGetChatModel>> fetchCompanyChat(int chatId) async {
    final token = await storage.read(key: 'token');

    try {
      final response = await http.get(
        Uri.parse('http://147.45.145.240:8001/company-chats/$chatId/'),
        headers: <String, String>{
          'Content-Type': 'Application/json;Charset=utf-8',
          'Accept': "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        final decoded = json.decode(response.body);
        print(decoded);
        final messages =decoded['results'] as List;
        return messages
            .map((message) => CompanyGetChatModel.fromJson(message))
            .toList();
      } else {
        throw Exception('Failed to load messages.');
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
