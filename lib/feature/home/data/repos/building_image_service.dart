import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intetership_project/feature/home/data/models/building_image_model.dart';

class BuildingImageService {
  Future<List<BuildingImageModel>> getImagesFromBackend() async {
    var storage = FlutterSecureStorage();
    try {
      var token = await storage.read(key: 'token');

      var response = await http.get(
        Uri.parse('http://147.45.145.240:8001/building-images/'),
        headers: <String, String>{
          'Content-Type': 'Application/json;charset=utf-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        var images = data['results'] as List;
        return images.map((image) => BuildingImageModel.from(image)).toList();
      } else {
        return List.empty();
      }
    } catch (e) {
      return [];
    }
  }
}
