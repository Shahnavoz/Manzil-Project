class LastMessageModel {
  final String? content;
  final DateTime timestamp;
  final String? senderType;

  LastMessageModel({this.content, required this.timestamp, this.senderType});

  factory LastMessageModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return LastMessageModel(
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      senderType: json['sender_type'],
    );
  }
}
