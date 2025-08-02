import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intetership_project/feature_admin/chats/data/models/company_get_chat_model.dart';
import 'package:intetership_project/feature_admin/chats/presentation/blocs/company_chat_provider.dart';
import 'package:intetership_project/feature_admin/chats/presentation/pages/company_user_chat_page.dart';
import 'package:intetership_project/feature_admin/users/data/models/company_chat_user_model.dart';
import 'package:intetership_project/feature_admin/users/data/models/user_model.dart';
import 'package:intetership_project/feature_admin/users/data/repos/user_service.dart';
import 'package:intetership_project/feature_admin/users/presentation/pages/admin_user_page.dart';

class AdminChatPage extends ConsumerStatefulWidget {
  const AdminChatPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminChatPage> createState() => _AdminChatPageState();
}

class _AdminChatPageState extends ConsumerState<AdminChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<UserModel> users = [];
  List<UserModel>? filteredUsers;
  final TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchUsers() async {
    // users = await UserService().getUsers();
    users = await UserService().getUsers();
    setState(() {
      filteredUsers = users;
      isLoading = false;
    });
  }

  void _searchUser(String query) {
    if (users.isEmpty) return;

    final lowerQuery = query.toLowerCase();

    final result =
        users.where((user) {
          final name = user.firstName.toLowerCase();
          final username = user.username.toLowerCase();
          final email = user.email?.toLowerCase() ?? '';

          return name.contains(lowerQuery) ||
              email.contains(lowerQuery) ||
              username.contains(lowerQuery);
        }).toList();

    setState(() {
      filteredUsers = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 36, 119, 187),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          splashRadius: 24,
        ),
        title: const Text(
          'Управление пользователями',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        elevation: 2,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, size: 24),
                        labelText: 'Поиск по имени или email',
                        labelStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: _searchUser,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child:
                        filteredUsers == null || filteredUsers!.isEmpty
                            ? Center(
                              child: Text(
                                'Пользователи не найдены',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                            : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              itemCount: filteredUsers!.length,
                              itemBuilder: (context, index) {
                                final user = filteredUsers![index];
                                return GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder:
                                    //         (context) => CompanyUserChatPage(
                                    //           companyUser: user,
                                    //         ),
                                    //   ),
                                    // );
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 12,
                                          ),
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundColor:
                                            Colors.blueAccent.shade700,
                                        child: Text(
                                          user.firstName.isNotEmpty
                                              ? user.firstName[0].toUpperCase()
                                              : 'U',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        user.username,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      ),
                                      subtitle: Text(
                                        user.email ?? 'Нет email',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }
}
