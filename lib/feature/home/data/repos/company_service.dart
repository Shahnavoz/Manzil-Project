import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intetership_project/feature/home/data/models/company_model.dart';

class CompanyService {
  final storage = FlutterSecureStorage();
  final String baseUrl = 'http://147.45.145.240:8001/companies';

  Future<List<CompanyModel>> getCompaniesFromBack() async {
    try {
      final token = await storage.read(key: 'token');
      final response = await http.get(
        Uri.parse('$baseUrl/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Companies response status: ${response.statusCode}');
      print('Companies response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;
        return results.map((e) => CompanyModel.fromJson(e)).toList();
      } else {
        print('Ошибка загрузки компаний: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Ошибка при получении компаний: $e');
      return [];
    }
  }

  Future<CompanyModel?> getCompanyById(int companyId) async {
    try {
      final token = await storage.read(key: 'token');
      final response = await http.get(
        Uri.parse('$baseUrl/$companyId/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return CompanyModel.fromJson(data);
      } else {
        print('Ошибка получения компании $companyId: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Ошибка получения компании $companyId: $e');
      return null;
    }
  }

  Future<bool> createCompany(CompanyModel company) async {
    final token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'name': company.name,
        'description': company.description,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Ошибка создания компании: ${response.body}');
      return false;
    }
  }

  Future<bool> deleteCompany(int companyId) async {
    final token = await storage.read(key: 'token');
    final response = await http.delete(
      Uri.parse('$baseUrl/$companyId/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      print('Ошибка удаления компании: ${response.body}');
      return false;
    }
  }

  Future<bool> updateCompany(CompanyModel company, int companyId) async {
    final token = await storage.read(key: 'token');
    final response = await http.put(
      Uri.parse('$baseUrl/$companyId/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'name': company.name,
        'description': company.description,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      return true;
    } else {
      print('Ошибка обновления компании: ${response.body}');
      return false;
    }
  }
}
