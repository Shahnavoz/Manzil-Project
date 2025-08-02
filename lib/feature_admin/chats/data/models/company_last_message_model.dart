class CompanyLastMessageModel {
  final String content;
  final DateTime timestamp;
  final String senderType;

  CompanyLastMessageModel({
    required this.content,
    required this.timestamp,
    required this.senderType,
  });

  factory CompanyLastMessageModel.fromJson(Map<String, dynamic> json) {
    return CompanyLastMessageModel(
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      senderType: json['sender_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'sender_type': senderType,
    };
  }
}
