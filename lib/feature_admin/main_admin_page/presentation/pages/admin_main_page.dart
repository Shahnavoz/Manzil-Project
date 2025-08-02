import 'package:flutter/material.dart';
import 'package:intetership_project/feature/registration/pages/login_page.dart';

class AdminMainPage extends StatelessWidget {
  final void Function(int) onNavigateToTab;

  const AdminMainPage({super.key, required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Размер иконки примерно 8% ширины экрана
    final iconSize = screenWidth * 0.038;

    // Размер шрифта примерно 4.5% ширины экрана
    final fontSize = screenWidth * 0.025;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Company Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildAdminCard(
            context,
            title: 'Идоракунии биноҳо',
            icon: Icons.apartment,
            iconSize: iconSize,
            fontSize: fontSize,
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onNavigateToTab(1);
              });
            },
          ),
          _buildAdminCard(
            context,
            title: 'Идоракунии компанияҳо',
            icon: Icons.business,
            iconSize: iconSize,
            fontSize: fontSize,
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onNavigateToTab(2);
              });
            },
          ),
          _buildAdminCard(
            context,
            title: 'Истифодабарандаҳо',
            icon: Icons.people,
            iconSize: iconSize,
            fontSize: fontSize,
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onNavigateToTab(3);
              });
            },
          ),
          _buildAdminCard(
            context,
            title: 'Паёмҳо',
            icon: Icons.feedback,
            iconSize: iconSize,
            fontSize: fontSize,
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onNavigateToTab(4);
              });
            },
          ),
          _buildAdminCard(
            context,
            title: 'Статистика',
            icon: Icons.bar_chart,
            iconSize: iconSize,
            fontSize: fontSize,
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onNavigateToTab(5);
              });
            },
          ),
          const Divider(),
          _buildAdminCard(
            context,
            title: 'Баромадан',
            icon: Icons.logout,
            color: Colors.red,
            iconSize: iconSize,
            fontSize: fontSize,
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required double iconSize,
    required double fontSize,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.teal, size: iconSize),
        title: Text(title, style: TextStyle(fontSize: fontSize)),
        trailing: Icon(Icons.arrow_forward_ios, size: iconSize * 0.7),
        onTap: onTap,
      ),
    );
  }
}
