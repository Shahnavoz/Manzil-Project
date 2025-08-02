import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intetership_project/consts/colors.dart';
import 'package:intetership_project/feature_admin/users/data/models/company_chat_user_model.dart';
import 'package:intetership_project/feature_admin/users/data/models/user_model.dart';

class CompanyUserChatPage extends StatefulWidget {
  final UserModel companyUser;
  const CompanyUserChatPage({super.key, required this.companyUser});

  @override
  State<CompanyUserChatPage> createState() => _CompanyUserChatPageState();
}

class _CompanyUserChatPageState extends State<CompanyUserChatPage> {
  var messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final isNarrow = width < 600;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 79, 115, 183),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          widget.companyUser.firstName.isNotEmpty
              ? widget.companyUser.firstName
              : 'User',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isNarrow ? 8 : 12,
              vertical: isNarrow ? 14 : 20,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Введите сообщение...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: isNarrow ? 10 : 12,
                        vertical: isNarrow ? 6 : 8,
                      ),
                    ),
                    onSubmitted: (_) => null,
                  ),
                ),
                SizedBox(width: isNarrow ? 6 : 8),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.blue,
                    size: isNarrow ? 24 : 28,
                  ),
                  onPressed: null,
                  splashRadius: 22,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
