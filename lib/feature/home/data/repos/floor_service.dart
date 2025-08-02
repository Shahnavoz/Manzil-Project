import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intetership_project/feature/home/data/models/floor_model.dart';

class FloorService {
  var storage = FlutterSecureStorage();
  Future<List<FloorModel>> getFloors() async {
    try {
      var token = await storage.read(key: 'token');
      var response = await http.get(
        Uri.parse('http://147.45.145.240:8001/floors/'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=utf-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        List<FloorModel> floors = [];
        var data = jsonDecode(response.body);
        final result = data['results'] as List;
        floors.addAll(
          result.map((element) => FloorModel.fromJson(element)).toList(),
        );
        return floors;
      } else {
        return List.empty();
      }
    } catch (e) {
      return [];
    }
  }
}
