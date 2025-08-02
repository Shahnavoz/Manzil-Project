import 'package:flutter/material.dart';

class AdminStatisticPage extends StatefulWidget {
  const AdminStatisticPage({Key? key}) : super(key: key);

  @override
  State<AdminStatisticPage> createState() => _AdminStatisticPageState();
}

class _AdminStatisticPageState extends State<AdminStatisticPage> {
  // Пример статистики, обычно загружается с backend
  int totalUsers = 0;
  int totalCompanies = 0;
  int totalBuildings = 0;
  int totalMessages = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStatistics();
  }

  Future<void> loadStatistics() async {
    // Здесь надо сделать запросы к backend и получить реальные данные
    await Future.delayed(Duration(seconds: 2)); // имитация загрузки

    setState(() {
      totalUsers = 123;
      totalCompanies = 45;
      totalBuildings = 67;
      totalMessages = 890;
      isLoading = false;
    });
  }

  Widget _buildStatisticCard(String title, int value, Color color) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text('Статистика администратора',style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 36, 119, 187),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildStatisticCard('Пользователей', totalUsers, Colors.blue),
                _buildStatisticCard('Компаний', totalCompanies, Colors.green),
                _buildStatisticCard('Зданий', totalBuildings, Colors.orange),
                _buildStatisticCard('Сообщений', totalMessages, Colors.red),
              ],
            ),
    );
  }
}
