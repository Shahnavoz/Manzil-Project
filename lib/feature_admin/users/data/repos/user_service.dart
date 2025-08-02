import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intetership_project/feature_admin/users/data/models/company_chat_user_model.dart';
import 'package:intetership_project/feature_admin/users/data/models/user_model.dart';

class UserService {
  var storage = FlutterSecureStorage();

//  Future<List<CompanyChatUserModel>> getUsers() async {
//   try {
//     var token = await storage.read(key: 'token');
//     var response = await http.get(
//       Uri.parse('http://147.45.145.240:8001/chat/company-owner/users/'),
//       headers: <String, String>{
//         'Content-Type': 'Application/json;Charset=utf-8',
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       print(response.body);
//       var decode = jsonDecode(response.body);
//       print(decode);

//       List<CompanyChatUserModel> allUsers =
//           (decode as List).map((e) => CompanyChatUserModel.fromJson(e)).toList();

//       return allUsers;
//     } else {
//       return [];
//     }
//   } catch (e) {
//     print(e);
//     return [];
//   }
// }

  Future<List<UserModel>> getUsers() async {
    try {
      var token = await storage.read(key: 'token');
      var response = await http.get(
        Uri.parse('http://147.45.145.240:8001/auth/users/all/'),
        headers: <String, String>{
          'Content-Type': 'Application/json;Charset=utf-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decode = jsonDecode(response.body);
        var data=decode['results'] as List;
        print(data);
        List<UserModel> allUsers = [];
        allUsers.addAll(data.map((e) => UserModel.fromJson(e)));
        return allUsers;
      } else {
        return List.empty();
      }
    } catch (e) {
      return [];
    }
  }
}
