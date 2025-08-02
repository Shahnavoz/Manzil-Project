class CompanyModel {
  int id;
  String name;
  String description;

  CompanyModel({this.id = 1, required this.name, required this.description});

  factory CompanyModel.fromJson(Map<String, dynamic> fromJson) {
    return CompanyModel(
      id: fromJson['id'],
      name: fromJson['name'],
      description: fromJson['description'],
    );
  }
}
