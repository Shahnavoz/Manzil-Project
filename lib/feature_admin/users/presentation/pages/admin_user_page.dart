// import 'package:flutter/material.dart';
// import 'package:intetership_project/feature/profile/data/models/profile_model.dart';
// import 'package:intetership_project/feature/profile/data/repos/profile_service.dart';
// import 'package:intetership_project/feature_admin/users/data/models/company_chat_user_model.dart';
// import 'package:intetership_project/feature_admin/users/data/models/user_model.dart';
// import 'package:intetership_project/feature_admin/users/data/repos/user_service.dart';

// class AdminUsersPage extends StatefulWidget {
//   final void Function()? onNavigateToSearch;
//   AdminUsersPage({Key? key, this.onNavigateToSearch}) : super(key: key);

//   @override
//   State<AdminUsersPage> createState() => _AdminUsersPageState();
// }

// class _AdminUsersPageState extends State<AdminUsersPage> {
//   List<UserModel> users = [];
//   List<UserModel>? filteredUsers;
//   final TextEditingController searchController = TextEditingController();
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchUsers();
//   }

//   Future<void> fetchUsers() async {
//     users = await UserService().getCOmpanyChatUsers();
//     setState(() {
//       filteredUsers = users;
//       isLoading = false;
//     });
//   }

//   void _searchUser(String query) {
//     if (users.isEmpty) return;

//     final lowerQuery = query.toLowerCase();

//     final result = users.where((user) {
//       final name = user.fullName.toLowerCase();
//       final username = user.username.toLowerCase();
//       final email = user.email?.toLowerCase() ?? '';

//       return name.contains(lowerQuery) ||
//           email.contains(lowerQuery) ||
//           username.contains(lowerQuery);
//     }).toList();

//     setState(() {
//       filteredUsers = result;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 36, 119, 187),
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
//           splashRadius: 24,
//         ),
//         title: const Text(
//           'Управление пользователями',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
//         ),
//         elevation: 2,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                   child: TextField(
//                     controller: searchController,
//                     decoration: InputDecoration(
//                       prefixIcon: const Icon(Icons.search, size: 24),
//                       labelText: 'Поиск по имени или email',
//                       labelStyle: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey[800],
//                         fontWeight: FontWeight.w500,
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                       contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14),
//                         borderSide: BorderSide.none,
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14),
//                         borderSide: BorderSide(color: Colors.grey.shade300),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14),
//                         borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
//                       ),
//                     ),
//                     onChanged: _searchUser,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//                 Expanded(
//                   child: filteredUsers == null || filteredUsers!.isEmpty
//                       ? Center(
//                           child: Text(
//                             'Пользователи не найдены',
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Colors.grey[600],
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         )
//                       : ListView.builder(
//                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                           itemCount: filteredUsers!.length,
//                           itemBuilder: (context, index) {
//                             final user = filteredUsers![index];
//                             return GestureDetector(
//                               onTap: () {
//                                 final callback = widget.onNavigateToSearch;
//                                 if (callback != null) {
//                                   callback();
//                                 }
//                               },
//                               child: Card(
//                                 color: Colors.white,
//                                 margin: const EdgeInsets.symmetric(vertical: 6),
//                                 elevation: 3,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(14),
//                                 ),
//                                 child: ListTile(
//                                   contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                                   leading: CircleAvatar(
//                                     radius: 30,
//                                     backgroundColor: Colors.blueAccent.shade700,
//                                     child: Text(
//                                       user.fullName.isNotEmpty
//                                           ? user.fullName[0].toUpperCase()
//                                           : 'U',
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 22,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   title: Text(
//                                     user.username,
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                   subtitle: Text(
//                                     user.email ?? 'Нет email',
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.black54,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
