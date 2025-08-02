import 'package:intetership_project/feature/chat/data/models/last_message_model.dart';

class ChatModel {
  final int? id;
  final int? user;
  final int? company;
  final String? companyName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final LastMessageModel? lastMessage;
  final int? unreadCount;

  ChatModel({
    this.id,
    this.user,
    this.company,
    this.companyName,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    this.lastMessage,
    this.unreadCount,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return ChatModel(
      id: json['id'],
      user: json['user'],
      company: json['company'] ?? "lll",
      companyName: json['company_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isActive: json['is_active'],
      lastMessage:
          json['last_message'] != null
              ? LastMessageModel.fromJson(json['last_message'])
              : null,
      unreadCount: json['unread_count'],
    );
  }
}
