import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intetership_project/feature/home/data/models/building_model.dart';
import 'package:intetership_project/feature/home/data/repos/building_service.dart';
import 'package:intetership_project/feature_admin/controll_buildings/presentation/pages/add_edit_building_page.dart';

class AdminControlBuildingPage extends StatefulWidget {
  const AdminControlBuildingPage({super.key});

  @override
  State<AdminControlBuildingPage> createState() =>
      _AdminControlBuildingPageState();
}

class _AdminControlBuildingPageState extends State<AdminControlBuildingPage> {
  List<BuildingModel?> buildings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBuildings();
  }

  Future<void> _loadBuildings() async {
    setState(() => isLoading = true);
    try {
      buildings = await BuildingService().getBuildingsFromBack();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Ошибка загрузки зданий")));
    }
    setState(() => isLoading = false);
  }

  Future<void> _deleteBuilding(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Удалить здание'),
            content: const Text('Вы уверены, что хотите удалить это здание?'),
            actionsPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            actions: [
              SizedBox(
                height: 44,
                width: 120,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey.shade600,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Отмена'),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 44,
                width: 120,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Удалить'),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await BuildingService().deleteBuilding(id);
      _loadBuildings(); // обновление списка
    }
  }

  _openAddEditPage({BuildingModel? building}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditBuildingPage(building: building),
      ),
    );

    if (result == true) {
      await _loadBuildings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Размер иконки: 7% ширины, но не больше 40, не меньше 24
    final iconSize = min(max(screenWidth * 0.015, 24), 40);
    final imageSize = min(max(screenWidth * 0.07, 24), 40);

    // Размер шрифта заголовка: 5% ширины, максимум 20, минимум 14
    final titleFontSize = min(max(screenWidth * 0.05, 14), 20);

    // Размер шрифта подзаголовка: 4% ширины, максимум 16, минимум 12
    final subtitleFontSize = min(max(screenWidth * 0.04, 12), 16);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_back,
            size: iconSize.toDouble(),
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(
          'Управление зданиями',
          style: TextStyle(
            color: Colors.white,
            fontSize: titleFontSize.toDouble(),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 36, 119, 187),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : buildings.isEmpty
              ? const Center(child: Text('Нет зданий'))
              : ListView.builder(
                itemCount: buildings.length,
                itemBuilder: (context, index) {
                  final building = buildings[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: min(screenWidth * 0.05, 20),
                      vertical: min(screenWidth * 0.025, 10),
                    ),
                    child: Card(
                      child: ListTile(
                        leading: Image.asset(
                          'assets/images/image 7 (3).png',
                          width: imageSize.toDouble(),
                          height: imageSize.toDouble(),
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          building!.name ?? "Без названия",
                          style: TextStyle(fontSize: titleFontSize.toDouble()),
                        ),
                        subtitle: Text(
                          'ID: ${building.id}',
                          style: TextStyle(
                            fontSize: subtitleFontSize.toDouble(),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue,
                                size: iconSize.toDouble(),
                              ),
                              onPressed:
                                  () => _openAddEditPage(building: building),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: iconSize.toDouble(),
                              ),
                              onPressed: () => _deleteBuilding(building.id),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'Buiding',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditBuildingPage()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 36, 119, 187),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
