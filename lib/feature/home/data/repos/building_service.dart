import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intetership_project/feature/home/data/models/building_model.dart';

class BuildingService {
  var storage = FlutterSecureStorage();

  Future<List<BuildingModel?>> getBuildingsFromBack() async {
    try {
      var token = await storage.read(key: 'token');
      print('Token: $token');

      var response = await http.get(
        Uri.parse('http://147.45.145.240:8001/buildings/'),

        headers: <String, String>{
          'Content-Type': 'application/json;charset=utf-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return fromBackend(response.body);
      } else {
        return List.empty();
      }
    } catch (e, s) {
      print(e);
      print(s);
      return [];
    }
  }


    Future<bool> deleteBuilding(int buildingId) async {
    final token = await storage.read(key: 'token');
    final response = await http.delete(
      Uri.parse('http://147.45.145.240:8001/buildings/$buildingId/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      print('Ошибка удаления здания: ${response.body}');
      return false;
    }
  }

  
  Future<bool> createBuilding(BuildingModel building) async {
    try {
      final token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('http://147.45.145.240:8001/buildings/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'name': building.name,
        'description': building.description,
        'flats_count': building.flats_count,
        'floors_count': building.floors_count,
        'longitude': building.longitude,
        'latitude': building.latitude,
        'address': building.address,
        'image': building.image,
        'model_3d': building.model_3d,
        'company': building.company,
      }),
    );
    // Проблема в том, что backend ожидает файлы для полей "image" и "model_3d", а также существующий company (id компании).
    // Если у вас нет файлов для image и model_3d, их лучше не отправлять вообще (или отправлять null, если backend это принимает).
    // Также company не должен быть 0, а должен быть id существующей компании.
    // Исправим формирование body:
    final Map<String, dynamic> body = {
      'name': building.name,
      'description': building.description,
      'flats_count': building.flats_count,
      'floors_count': building.floors_count,
      'longitude': building.longitude,
      'latitude': building.latitude,
      'address': building.address,
      'company': building.company,
    };

    // Добавляем только если есть image (и это не пустая строка)
    if (building.image != null && building.image!.isNotEmpty) {
      body['image'] = building.image;
    }
    // Добавляем только если есть model_3d (и это не пустая строка)
    if (building.model_3d != null && building.model_3d!.isNotEmpty) {
      body['model_3d'] = building.model_3d;
    }
    // company должен быть валидным id (не 0)
    if (building.company != null && building.company != 0) {
      body['company'] = building.company;
    }

    final response2 = await http.post(
      Uri.parse('http://147.45.145.240:8001/buildings/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );
    // Проверяем, что company - это id существующей компании и не равен 0
    if (building.company == null || building.company == 0) {
      print('Ошибка: company должен быть id существующей компании и не равен 0.');
      return false;
    }

    // Не отправляем пустые строки для image/model_3d
    if ((building.image != null && building.image!.isEmpty) ||
        (building.model_3d != null && building.model_3d!.isEmpty)) {
      print('Ошибка: Не отправляйте пустые строки для image/model_3d.');
      return false;
    }
    print('Проверьте, что company - это id существующей компании и не равен 0. Не отправляйте пустые image/model_3d.');
    print('Ответ сервера: ${response2.body}');
    // Проверяем, что company - это id существующей компании и не равен 0
    if (building.company == null || building.company == 0) {
      print('Ошибка: company должен быть id существующей компании и не равен 0.');
      return false;
    }
    // Не отправляем пустые строки для image/model_3d
    if ((building.image != null && building.image!.isEmpty) ||
        (building.model_3d != null && building.model_3d!.isEmpty)) {
      print('Ошибка: Не отправляйте пустые строки для image/model_3d.');
      return false;
    }


    if (response2.statusCode == 200 || response2.statusCode == 201) {
      return true;
    } else {
      // Проверяем, если ошибка связана с отсутствием поля company
      if (response2.body.contains('"company"') && response2.body.contains('required')) {
        print('Ошибка создания здания: Необходимо указать существующий company (id компании).');
      } else {
        print('Ошибка создания здания: ${response2.body}');
      }
      return false;
    }
    } catch (e) {
      print('Ошибка создания здания: Необходимо указать существующий company (id компании).');
      return false;
    }
  }

  
  Future<bool> updateBuilding(BuildingModel building,int buildingId) async {
  final token = await storage.read(key: 'token');
  final response = await http.put(
    Uri.parse('http://147.45.145.240:8001/buildings/$buildingId/'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'name': building.name,
      'description': building.description,
      'address':building.address,
      'flats_count': building.flats_count,
      'floors_count': building.floors_count,
      'longitude': building.longitude,
      'latitude': building.latitude,
      'company': building.company,
    }),
  );

  if (response.statusCode == 200 || response.statusCode == 202) {
    return true;
  } else {
    print('Ошибка обновления здания: ${response.body}');
    return false;
  }
}
}
