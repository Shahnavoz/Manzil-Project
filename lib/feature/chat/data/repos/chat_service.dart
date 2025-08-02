import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intetership_project/feature/chat/data/models/chat_company_model.dart';
import 'package:intetership_project/feature/chat/data/models/chat_list_response.dart';
import 'package:intetership_project/feature/chat/data/models/chat_message_by_id_model.dart';
import 'package:intetership_project/feature/chat/data/models/chat_model.dart';
import 'package:intetership_project/feature/chat/data/models/company_chat_list.dart';
import 'package:intetership_project/feature/chat/data/models/last_message_model.dart';
import 'package:intetership_project/feature/chat/presentation/pages/chat_page.dart';
import 'package:intetership_project/feature/home/data/models/company_model.dart';

class ChatService {
  var storage = FlutterSecureStorage();

  Future<List<ChatMessageByIdModel>> fetchAllMessages(int chatId) async {
    final token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('http://147.45.145.240:8001/chats/$chatId/messages/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      decoded as List;
      return decoded.map((json) => ChatMessageByIdModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<ChatListResponse> fetchChats() async {
    var token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('http://147.45.145.240:8001/chats/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ChatListResponse.fromJson(data);
    } else {
      throw Exception('Ошибка загрузки чатов');
    }
  }

  Future<int?> getExistingChatId(int companyId, String token) async {
    final response = await http.get(
      Uri.parse('http://147.45.145.240:8001/chats/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];

      for (var chat in results) {
        if (chat['company'] == companyId) {
          return chat['id']; // Возвращаем id существующего чата
        }
      }
    }
    return null;
  }

  Future<void> handleCompanyTap(
    BuildContext context,
    CompanyChatListModel company,
    String currentUserId,
  ) async {
    final token = await storage.read(key: 'token');

    // Проверяем, есть ли чат с этой компанией
    int? chatId = await getExistingChatId(company.id, token!);

    if (chatId == null) {
      // Если нет — создаём новый чат
      final response = await http.post(
        Uri.parse('http://147.45.145.240:8001/chats/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"company": company.id}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        chatId =
            data['id']; // Обрати внимание, возможно ключ 'id' или 'chat_id'
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка при создании чата')));
        return;
      }
    }
    // Переход на страницу чата с chatId
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ChatPage(
              chatId: chatId!,
              senderId: currentUserId,
              companyId: company.id,
              company: company,
            ),
      ),
    );
  }
  /// Отправить сообщение в чат
  Future<ChatMessageByIdModel> sendMessage({
    required int chatId,
    required String text,
    required int companyId,
  }) async {
    final token = await storage.read(key: 'token');

    final url =
        'http://147.45.145.240:8001/chats/$chatId/send_message/'; // ← правильный endpoint

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'content': text,
        'company': companyId, 
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Message sent: ${response.body}');
      return ChatMessageByIdModel.fromJson(json.decode(response.body));
    } else {
      print('Ошибка: ${response.statusCode}, body: ${response.body}');
      throw Exception('Failed to send message, code: ${response.statusCode}');
    }
  }
  /// Получить список всех чатов пользователя
  Future<List<ChatModel>> fetchUserChats(int chatId) async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('http://147.45.145.240:8001/chats/$chatId/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('fetchUserChats status: ${response.statusCode}');
    print('fetchUserChats body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        return data
            .map((json) => ChatModel.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      } else if (data is Map) {
        return [ChatModel.fromJson(Map<String, dynamic>.from(data))];
      } else {
        throw Exception('Unexpected response format');
      }
    } else if (response.statusCode == 404) {
      // Впервые открыл чат, сообщений ещё нет
      return [];
    } else {
      throw Exception('Failed to fetch user chats');
    }
  }

  Future<ChatModel> createOrGetChat(int userId, int companyId) async {
    final token = await storage.read(key: 'token');

    final response = await http.post(
      Uri.parse('http://147.45.145.240:8001/chats/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'user': userId, 'company': companyId}),
    );

    print('createOrGetChat status: ${response.statusCode}');
    print('createOrGetChat body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ChatModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create or get chat');
    }
  }

  Future<ChatModel> getOrCreateChat(int userId, int companyId) async {
    final chats = await fetchUserChats(userId);

    try {
      // Ищем чат, где company совпадает с нужной
      final existingChat = chats.firstWhere(
        (chat) => chat.company == companyId,
        orElse: () => throw Exception('Chat not found'),
      );
      return existingChat;
    } catch (_) {
      // Если чат не найден — создаём
      return await createOrGetChat(userId, companyId);
    }
  }
}
