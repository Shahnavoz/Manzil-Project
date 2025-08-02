class ChatMessageByIdModel {
  int id;
  int chat;
  String sender_type;
  String content;
  DateTime timestamp;
  bool is_read;

  ChatMessageByIdModel({
    required this.id,
    required this.chat,
    required this.sender_type,
    required this.content,
    required this.timestamp,
    required this.is_read,
  });

  factory ChatMessageByIdModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageByIdModel(
      id: json['id'],
      chat: json['chat'],
      sender_type: json['sender_type'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      is_read: json['is_read'],
    );
  }
}
