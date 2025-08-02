import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intetership_project/feature/chat/data/models/chat_company_model.dart';
import 'package:intetership_project/feature/chat/data/models/company_chat_list.dart';

class ChatCompanyService {
  var storage = FlutterSecureStorage();

  Future<List<CompanyChatListModel>> fetchfromBackend() async {
    var token = await storage.read(key: 'token');
    try {
      var response = await http.get(
        Uri.parse('http://147.45.145.240:8001/chat/companies-list/'),

        headers: <String, String>{
          'Content-Type': 'Application/json;Charset=utf-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        print(response.body);
        print(data);
        var results = data as List;
        return results
            .map((element) => CompanyChatListModel.fromJson(element))
            .toList();
      } else {
        return List.empty();
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
