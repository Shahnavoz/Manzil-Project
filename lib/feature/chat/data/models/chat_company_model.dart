class ChatCompanyModel {
  int id;
  String name;
  String description;

  ChatCompanyModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory ChatCompanyModel.fromJson(Map<String, dynamic> fromJson) {
    return ChatCompanyModel(
      id: fromJson['id'],
      name: fromJson['name'],
      description: fromJson['description'],
    );
  }
}
