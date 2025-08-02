

import 'dart:convert';

CompanyChatUserModel companyChatUserModelFromJson(String str) => CompanyChatUserModel.fromJson(json.decode(str));

String companyChatUserModelToJson(CompanyChatUserModel data) => json.encode(data.toJson());

class CompanyChatUserModel {
    int userId;
    String username;
    String email;
    String fullName;
    int chatId;
    DateTime lastActive;
    int unreadMessages;
    LastMessage lastMessage;

    CompanyChatUserModel({
        required this.userId,
        required this.username,
        required this.email,
        required this.fullName,
        required this.chatId,
        required this.lastActive,
        required this.unreadMessages,
        required this.lastMessage,
    });

    factory CompanyChatUserModel.fromJson(Map<String, dynamic> json) => CompanyChatUserModel(
        userId: json["user_id"],
        username: json["username"],
        email: json["email"],
        fullName: json["full_name"],
        chatId: json["chat_id"],
        lastActive: DateTime.parse(json["last_active"]),
        unreadMessages: json["unread_messages"],
        lastMessage: LastMessage.fromJson(json["last_message"]),
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "username": username,
        "email": email,
        "full_name": fullName,
        "chat_id": chatId,
        "last_active": lastActive.toIso8601String(),
        "unread_messages": unreadMessages,
        "last_message": lastMessage.toJson(),
    };
}

class LastMessage {
    String content;
    DateTime timestamp;
    String senderType;

    LastMessage({
        required this.content,
        required this.timestamp,
        required this.senderType,
    });

    factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
        content: json["content"],
        timestamp: DateTime.parse(json["timestamp"]),
        senderType: json["sender_type"],
    );

    Map<String, dynamic> toJson() => {
        "content": content,
        "timestamp": timestamp.toIso8601String(),
        "sender_type": senderType,
    };
}
