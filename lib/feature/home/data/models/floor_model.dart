class FloorModel {
  int id;
  int floor_number;
  String plan_image;
  int building;

  FloorModel({
    this.id = 1,
    required this.floor_number,
    required this.plan_image,
    required this.building,
  });

  
  factory FloorModel.fromJson(Map<String, dynamic> fromJson) {
    return FloorModel(
      id: fromJson['id'],
      floor_number: fromJson['floor_number'],
      plan_image: fromJson['plan_image'],
      building: fromJson['building'],
    );
  }
}
