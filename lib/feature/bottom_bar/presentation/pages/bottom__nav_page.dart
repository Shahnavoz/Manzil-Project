import 'package:flutter/material.dart';
import 'package:intetership_project/feature/chat/presentation/pages/chat_page.dart';
import 'package:intetership_project/feature/chat/presentation/pages/company_page.dart';
import 'package:intetership_project/feature/favourite/presentation/pages/favourite_page.dart';
import 'package:intetership_project/feature/home/presentation/pages/home_page.dart';
import 'package:intetership_project/feature/profile/presentation/pages/profile_page.dart';
import 'package:intetership_project/feature/search/presentation/pages/search_page.dart';

class BottomNavPage extends StatefulWidget {
  BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int _currentIndex = 0;
  int? _selectedBuildingId;

  double _iconSizeForWidth(double width) {
    // от 28 до 38 в зависимости от ширины
    final size = width * 0.07;
    return size.clamp(28.0, 38.0);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final isNarrow = width < 500;

    final iconSize = _iconSizeForWidth(width);
    final barPadding = EdgeInsets.symmetric(
      horizontal: isNarrow ? 8 : 16,
      vertical: isNarrow ? 6 : 10,
    );
    final borderRadius = BorderRadius.vertical(top: Radius.circular(isNarrow ? 16 : 24));

    List<Widget> pages = [
      HomePage(
        onNavigateToSearch: (int buildingId) {
          setState(() {
            _currentIndex = 1;
            _selectedBuildingId = buildingId;
          });
        },
      ),
      SearchPage(
        key: ValueKey(_selectedBuildingId),
        selectedBuildingId: _selectedBuildingId,
      ),
      FavouritePage(),
      CompanyPage(currentUserId: 1),
      ProfilePage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        padding: barPadding,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 134, 176, 239),
              Color.fromARGB(255, 79, 89, 107),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: borderRadius,
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: _currentIndex,
            onTap: (value) {
              setState(() {
                _currentIndex = value;
              });
            },
            selectedItemColor: const Color.fromARGB(255, 15, 50, 79),
            unselectedItemColor: Colors.grey.shade400,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
            showUnselectedLabels: true,
            iconSize: iconSize,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: iconSize),
                label: 'Асосӣ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search, size: iconSize),
                label: 'Ҷӯстуҷу',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline, size: iconSize),
                label: 'Маъқулҳо',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message_outlined, size: iconSize),
                label: 'Чат',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined, size: iconSize),
                label: 'Профил',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
