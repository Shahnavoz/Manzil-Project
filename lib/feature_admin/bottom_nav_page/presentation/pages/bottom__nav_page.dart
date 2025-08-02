import 'package:flutter/material.dart';
import 'package:intetership_project/feature/chat/presentation/pages/chat_page.dart';
import 'package:intetership_project/feature/chat/presentation/pages/company_page.dart';
import 'package:intetership_project/feature/favourite/presentation/pages/favourite_page.dart';
import 'package:intetership_project/feature/home/presentation/pages/home_page.dart';
import 'package:intetership_project/feature/profile/presentation/pages/profile_page.dart';
import 'package:intetership_project/feature/search/presentation/pages/search_page.dart';
import 'package:intetership_project/feature_admin/chats/presentation/pages/admin_chat_page.dart';
import 'package:intetership_project/feature_admin/controll_buildings/presentation/pages/admin_control_building_page.dart';
import 'package:intetership_project/feature_admin/controll_companies/presentation/pages/admin_control_company_page.dart';
import 'package:intetership_project/feature_admin/main_admin_page/presentation/pages/admin_main_page.dart';
import 'package:intetership_project/feature_admin/statistic/presentation/pages/admin_statistic_page.dart';
import 'package:intetership_project/feature_admin/users/presentation/pages/admin_user_page.dart';

class AdminBottomPage extends StatefulWidget {
  int initialIndex;

  AdminBottomPage({super.key, this.initialIndex = 0});

  @override
  State<AdminBottomPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<AdminBottomPage> {
  int _selectedIndex = 0;

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _pages = [
      AdminMainPage(onNavigateToTab: _changeTab),
      AdminControlBuildingPage(),
      AdminControlCompanyPage(),
      // AdminUsersPage(
      //   onNavigateToSearch: () {
      //     setState(() {
      //       _selectedIndex = 4;
      //     });
      //   },
      // ),
      AdminChatPage(),
      AdminStatisticPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Рассчитаем размер иконки (например, 7% ширины экрана)
    final iconSize = screenWidth * 0.050;

    // Рассчитаем размер шрифта (например, 3.5% ширины экрана)
    final selectedFontSize = screenWidth * 0.020;
    final unselectedFontSize = screenWidth * 0.020;

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 134, 176, 239), // light blueish
              Color.fromARGB(255, 79, 89, 107), // even lighter
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: Offset(0, -2),
            ),
          ],
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          selectedItemColor: const Color.fromARGB(255, 15, 50, 79),
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: selectedFontSize,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: unselectedFontSize,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.control_camera, size: iconSize),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: iconSize),
              label: 'Buildings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: iconSize),
              label: 'Companies',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.person, size: iconSize),
            //   label: 'Users',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined, size: iconSize),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.graphic_eq, size: iconSize),
              label: 'Statistics',
            ),
          ],
        ),
      ),
    );
  }
}
