import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('API Tests', () {
    test('Registration endpoint test', () async {
      final response = await http.post(
        Uri.parse('http://147.45.145.240:8001/auth/register/'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': 'testuser${DateTime.now().millisecondsSinceEpoch}',
          'email': 'test${DateTime.now().millisecondsSinceEpoch}@example.com',
          'first_name': 'Test',
          'last_name': 'User',
          'phone_number': '+1234567890',
          'password': 'testpass123',
          'password2': 'testpass123',
        }),
      );

      print('Registration test - Status: ${response.statusCode}');
      print('Registration test - Body: ${response.body}');
      
      expect(response.statusCode, anyOf(200, 201));
    });

    test('Login endpoint test with email', () async {
      final response = await http.post(
        Uri.parse('http://147.45.145.240:8001/auth/login/'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': 'admin@gmail.com',
          'password': '1234',
        }),
      );

      print('Login test with email - Status: ${response.statusCode}');
      print('Login test with email - Body: ${response.body}');
    });

    test('Login endpoint test with username', () async {
      final response = await http.post(
        Uri.parse('http://147.45.145.240:8001/auth/login/'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': 'admin@gmail.com',
          'password': '1234',
        }),
      );

      print('Login test with username - Status: ${response.statusCode}');
      print('Login test with username - Body: ${response.body}');
    });

    test('Register and login with same credentials', () async {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final testEmail = 'testlogin$timestamp@example.com';
      final testPassword = 'testpass123';
      final testUsername = 'testuser$timestamp';

      // Register a new user
      final registerResponse = await http.post(
        Uri.parse('http://147.45.145.240:8001/auth/register/'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': testUsername,
          'email': testEmail,
          'first_name': 'Test',
          'last_name': 'User',
          'phone_number': '+1234567890',
          'password': testPassword,
          'password2': testPassword,
        }),
      );

      print('Register test - Status: ${registerResponse.statusCode}');
      print('Register test - Body: ${registerResponse.body}');
      
      expect(registerResponse.statusCode, anyOf(200, 201));

      // Try to login with the same credentials
      final loginResponse = await http.post(
        Uri.parse('http://147.45.145.240:8001/auth/login/'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': testEmail,
          'password': testPassword,
        }),
      );

      print('Login test with registered user - Status: ${loginResponse.statusCode}');
      print('Login test with registered user - Body: ${loginResponse.body}');
      
      expect(loginResponse.statusCode, 200);
    });

    test('Companies endpoint test', () async {
      final response = await http.get(
        Uri.parse('http://147.45.145.240:8001/companies/'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
        },
      );

      print('Companies test - Status: ${response.statusCode}');
      print('Companies test - Body: ${response.body}');
    });

    test('Buildings endpoint test', () async {
      final response = await http.get(
        Uri.parse('http://147.45.145.240:8001/buildings/'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
        },
      );

      print('Buildings test - Status: ${response.statusCode}');
      print('Buildings test - Body: ${response.body}');
    });

    test('Flats endpoint test', () async {
      final response = await http.get(
        Uri.parse('http://147.45.145.240:8001/flats/'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
        },
      );

      print('Flats test - Status: ${response.statusCode}');
      print('Flats test - Body: ${response.body}');
    });

    test('Flats by building and floor test', () async {
      final response = await http.get(
        Uri.parse('http://147.45.145.240:8001/flats/?building=2&floor=1'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
        },
      );

      print('Flats by building and floor test - Status: ${response.statusCode}');
      print('Flats by building and floor test - Body: ${response.body}');
    });
  });
} 