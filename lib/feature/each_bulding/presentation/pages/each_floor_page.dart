import 'package:flutter/material.dart';
import 'package:intetership_project/feature/home/data/models/flat_model.dart';
import 'package:intetership_project/feature/home/data/models/floor_model.dart';

class EachFloorPage extends StatefulWidget {
  final FloorModel floor;
  final String buildingName;
  final List<FlatModel> flat;

  EachFloorPage({
    super.key,
    required this.floor,
    required this.buildingName,
    required this.flat,
  });

  @override
  State<EachFloorPage> createState() => _EachFloorPageState();
}

class _EachFloorPageState extends State<EachFloorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ошёна №${widget.floor.floor_number}', style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back,color: Colors.white,),
        ),
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Название здания
            Text(
              widget.buildingName,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
            const SizedBox(height: 16),

            // Изображение плана этажа с обводкой и тенью
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Image.network(
                    widget.floor.plan_image,
                    width: MediaQuery.of(context).size.width * 0.8,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width * 0.8,
                      color: Colors.grey[200],
                      child: Icon(Icons.broken_image, size: 60, color: Colors.grey[400]),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Заголовок списка квартир
            Text(
              'Хонаҳо дар ошёнаҳо',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),

            const SizedBox(height: 12),

            // Список квартир
            ListView.builder(
              physics: NeverScrollableScrollPhysics(), // отключаем скролл внутри листа
              shrinkWrap: true, // адаптация по размеру
              itemCount: widget.flat.length,
              itemBuilder: (context, index) {
                final flat = widget.flat[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[600],
                      child: Text(
                        flat.number,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      'Ҳуҷраи: ${flat.number}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Масоҳат: ${flat.area} м²',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
