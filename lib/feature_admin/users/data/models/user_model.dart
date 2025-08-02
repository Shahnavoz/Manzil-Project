class UserModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? profilePicture;
  final bool isVerified;
  final DateTime dateJoined;
  final bool isActive;
  final int? company;
  final String? companyName;
  final bool isStaff;
  final bool isSuperuser;
  final DateTime? lastLogin;
  final String? lastLoginDisplay;
  final int chatCount;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.profilePicture,
    required this.isVerified,
    required this.dateJoined,
    required this.isActive,
    required this.company,
    required this.companyName,
    required this.isStaff,
    required this.isSuperuser,
    required this.lastLogin,
    required this.lastLoginDisplay,
    required this.chatCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'] ?? 'Last Name',
      phoneNumber: json['phone_number'] ?? '995841236',
      profilePicture: json['profile_picture'],
      isVerified: json['is_verified'],
      dateJoined: DateTime.parse(json['date_joined']),
      isActive: json['is_active'],
      company: json['company'],
      companyName: json['company_name'],
      isStaff: json['is_staff'],
      isSuperuser: json['is_superuser'],
      lastLogin:
          json['last_login'] != null
              ? DateTime.parse(json['last_login'])
              : null,
      lastLoginDisplay: json['last_login_display'],
      chatCount: json['chat_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'profile_picture': profilePicture,
      'is_verified': isVerified,
      'date_joined': dateJoined.toIso8601String(),
      'is_active': isActive,
      'company': company,
      'company_name': companyName,
      'is_staff': isStaff,
      'is_superuser': isSuperuser,
      'last_login': lastLogin?.toIso8601String(),
      'last_login_display': lastLoginDisplay,
      'chat_count': chatCount,
    };
  }
}
