import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intetership_project/feature/home/data/models/flat_model.dart';

class FlatService {
  var storage = FlutterSecureStorage();

  Future<List<FlatModel>> getFlatsFromBack() async {
    try {
      var token = await storage.read(key: 'token');
      var response = await http.get(
        Uri.parse('http://147.45.145.240:8001/flats/'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=utf-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Flats response status: ${response.statusCode}');
      print('Flats response body: ${response.body}');

      if (response.statusCode == 200) {
        List<FlatModel> flats = [];
        var data = jsonDecode(response.body);

        if (data is Map && data.containsKey('results')) {
          final results = data['results'] as List;
          for (var element in results) {
            print('element: $element');
            try {
              var flat = FlatModel.getFromJson(element);
              flats.add(flat);
            } catch (e) {
              print('Ошибка при разборе flat: $e');
            }
          }
          flats =
              results.map((element) => FlatModel.getFromJson(element)).toList();
        } else if (data is List) {
          flats =
              data.map((element) => FlatModel.getFromJson(element)).toList();
        }

        return flats;
      } else {
        print('Failed to fetch flats: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching flats: $e');
      return [];
    }
  }

  Future<List<FlatModel>> getFlatsByFloor(
    String buildingName,
    int floorNumber,
  ) async {
    try {
      var token = await storage.read(key: 'token');
      var response = await http.get(
        Uri.parse('http://147.45.145.240:8001/flats/'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=utf-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Flats by floor response status: ${response.statusCode}');
      print('Flats by floor response body: ${response.body}');

      if (response.statusCode == 200) {
        List<FlatModel> flats = [];
        var data = jsonDecode(response.body);

        if (data is Map && data.containsKey('results')) {
          final results = data['results'] as List;
          flats =
              results.map((element) => FlatModel.getFromJson(element)).toList();
        } else if (data is List) {
          flats =
              data.map((element) => FlatModel.getFromJson(element)).toList();
        }

        // Filter by building name and floor number
        return flats
            .where(
              (flat) =>
                  flat.building_name == buildingName &&
                  flat.floor == floorNumber,
            )
            .toList();
      } else {
        print('Failed to fetch flats by floor: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching flats by floor: $e');
      return [];
    }
  }
}
