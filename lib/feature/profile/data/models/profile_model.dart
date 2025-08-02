import 'dart:convert';
ProfileModel fromBackend(String response) {
  try {
    final data = jsonDecode(response);

    if (data is Map<String, dynamic>) {
      return ProfileModel.fromMap(data);
    } else {
      throw FormatException("Ожидался объект, а не список или другое");
    }
  } catch (e) {
    throw Exception('Ошибка при парсинге профиля: $e');
  }
}


// final result = data['result'] as List;
// return result.map((e) {
//   try {
//     return ProfileModel.fromMap(e);
//   } catch (error, stackTrace) {
//     print('Ошибка при парсинге элемента: $e');
//     print('Exception: $error');
//     print('StackTrace: $stackTrace');
//     // Можно вернуть null или заглушку, чтобы список не ломался:
//     return null;
//   }
// }).toList();

class ProfileModel {
  int id;
  String userName;
  String email;
  String firstName;
  String lastName;
  String? phoneNumber;
  String? profilePicture;
  bool isVerified;
  String dateJoined;

  ProfileModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.profilePicture,
    required this.isVerified,
    required this.dateJoined,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> fromJson) {
    return ProfileModel(
      id: fromJson['id'],
      userName: fromJson['username'],
      email: fromJson['email'],
      firstName: fromJson['first_name'],
      lastName: fromJson['last_name'],
      phoneNumber: fromJson['phone_number'] ?? '925478654',
      profilePicture: fromJson['profile_picture'] ?? "assets/images/image-removebg-preview (3) 1.png",
      isVerified: fromJson['is_verified'],
      dateJoined: fromJson['date_joined'],
    );
  }
}
