class CompanyChatListModel {
  int id;
  String name;
  String description;
  bool has_chat;
  int? chat_id; // теперь может быть null
  int unread_count;

  CompanyChatListModel({
    required this.id,
    required this.name,
    required this.description,
    required this.has_chat,
    required this.chat_id,
    required this.unread_count,
  });

  factory CompanyChatListModel.fromJson(Map<String, dynamic> json) {
    return CompanyChatListModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      has_chat: json['has_chat'],
      chat_id: json['chat_id'], // может быть null
      unread_count: json['unread_count'],
    );
  }
}
