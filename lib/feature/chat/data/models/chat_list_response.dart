import 'package:intetership_project/feature/chat/data/models/chat_message_by_id_model.dart';
import 'package:intetership_project/feature/chat/data/models/chat_model.dart';

class ChatListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<ChatMessageByIdModel> results;

  ChatListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory ChatListResponse.fromJson(Map<String, dynamic> json) {
    return ChatListResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((item) => ChatMessageByIdModel.fromJson(item))
          .toList(),
    );
  }
}
