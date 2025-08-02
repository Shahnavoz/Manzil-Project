class FlatModel {
  int id;
  String building_name;
  String floor_number;
  String number;
  int area;
  int floor;

  FlatModel({
    this.id = 1,
    required this.building_name,
    required this.floor_number,
    required this.number,
    required this.area,
    required this.floor,
  });

  factory FlatModel.getFromJson(Map<String, dynamic> fromJson) {
    return FlatModel(
      id: fromJson['id'] ?? 0,
      building_name: fromJson['building_name']?.toString() ?? '',
      floor_number: fromJson['floor_number']?.toString() ?? '',
      number: fromJson['number']?.toString() ?? '',
      area: (fromJson['area'] as num?)?.toInt() ?? 0,   // ← исправлено
      floor: (fromJson['floor'] as num?)?.toInt() ?? 0, // ← исправлено
    );
  }
}
