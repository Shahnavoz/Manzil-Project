import 'dart:convert';

import 'package:intetership_project/feature/home/data/models/company_model.dart';

List<BuildingModel?> fromBackend(String response) {
  final data = jsonDecode(response);
  final results = data['results'] as List;
  return results.map((e) {
    try {
      return BuildingModel.fromJson(e);
    } catch (error, stackTrace) {
      print('Ошибка при парсинге элемента: $e');
      print('Exception: $error');
      print('StackTrace: $stackTrace');
      // Можно вернуть null или заглушку, чтобы список не ломался:
      return null;
    }
  }).toList();
}

class BuildingModel {
  int id;
  String name;
  String address;
  String description;
  String? image;
  double latitude;
  double longitude;
  int floors_count;
  int flats_count;
  String? model_3d;
  int company;
  // CompanyModel company;

  BuildingModel({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.floors_count,
    required this.flats_count,
    required this.model_3d,
    required this.company,
  });

  factory BuildingModel.fromJson(Map<String, dynamic> fromJson) {
    return BuildingModel(
      id: fromJson['id'],
      name: fromJson['name'] ?? 'No name',
      address: fromJson['address'] ?? 'No address',
      description: fromJson['description'] ?? 'No description',
      image: fromJson['image'] ?? 'No image',
      latitude: (fromJson['latitude'] as num).toDouble(),
      longitude: (fromJson['longitude'] as num).toDouble(),
      floors_count: int.parse(fromJson['floors_count'].toString()),
      flats_count: int.parse(fromJson['flats_count'].toString()),
      model_3d: fromJson['model_3d'],
      company: fromJson['company'],
    );
  }
}
