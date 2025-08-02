import 'package:intetership_project/feature_admin/chats/data/models/company_last_message_model.dart';

class CompanyGetChatModel {
  final int id;
  final int user;
  final String userEmail;
  final String userName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final CompanyLastMessageModel? lastMessage;
  final int unreadCount;

  CompanyGetChatModel({
    required this.id,
    required this.user,
    required this.userEmail,
    required this.userName,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.lastMessage,
    required this.unreadCount,
  });

  factory CompanyGetChatModel.fromJson(Map<String, dynamic> json) {
    return CompanyGetChatModel(
      id: json['id'],
      user: json['user'],
      userEmail: json['user_email'],
      userName: json['user_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isActive: json['is_active'],
      lastMessage:
          json['last_message'] != null
              ? CompanyLastMessageModel.fromJson(json['last_message'])
              : null,
      unreadCount: json['unread_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'user_email': userEmail,
      'user_name': userName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
      'last_message': lastMessage?.toJson(),
      'unread_count': unreadCount,
    };
  }
}
