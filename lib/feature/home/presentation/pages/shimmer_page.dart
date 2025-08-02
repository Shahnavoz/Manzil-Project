import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPage extends StatelessWidget {
  const ShimmerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      body: GridView.builder(
        itemCount: 6, // сколько нужно placeholder'ов показать
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          crossAxisCount: 2,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.white,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: media.height / 7.5,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 20,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Container(width: 100, height: 14, color: Colors.grey),
                    const SizedBox(height: 4),
                    Container(width: 80, height: 14, color: Colors.grey),
                    const SizedBox(height: 8),
                    Container(width: 120, height: 14, color: Colors.grey),
                    const SizedBox(height: 12),
                    Container(width: 80, height: 14, color: Colors.grey),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intetership_project/feature/home/data/models/building_model.dart';
import 'package:intetership_project/feature/home/data/models/home_model.dart';
import 'package:intetership_project/feature/home/data/repos/building_service.dart';
import 'package:intetership_project/feature/search/presentation/pages/search_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? onNavigateToSearch;
  HomePage({super.key, this.onNavigateToSearch});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  BitmapDescriptor? _customIcon;
  BitmapDescriptor? _customIconForMyBuildings;

  @override
  void initState() {
    super.initState();
    _initAll();
  }

  Future<void> _initAll() async {
    await _loadCustomIcon();
    await _loadCustomIconForMyBuildings();
    await _loadAllMarkers();
  }

  Future<void> _loadCustomIcon() async {
    final icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/belka_new1.bmp',
    );
    _customIcon = icon;
  }

  Future<void> _loadCustomIconForMyBuildings() async {
    final icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/icons/icon_zdaniye.bmp',
    );
    _customIconForMyBuildings = icon;
  }

  Future<void> _loadAllMarkers() async {
    Set<Marker> newMarkers = {};

    // Загружаем свои здания
    final myBuildings = await BuildingService().getBuildingsFromBack();

    if (myBuildings.isEmpty) return;

    final firstBuilding = myBuildings.first;
    final lat = firstBuilding!.longitude ?? 38.5598;
    final lng = firstBuilding.latitude ?? 68.7870;
    print(firstBuilding.latitude);
    print(firstBuilding.longitude);

    // Задаём центр камеры по первому зданию
    await _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 14.0),
      ),
    );
    for (var building in myBuildings) {
      if (building == null) continue;

      final safeLat =
          (building.longitude != null && building.longitude! > 0)
              ? building.longitude!
              : 38.5598;
      final safeLng =
          (building.latitude != null && building.latitude! > 0)
              ? building.latitude!
              : 68.7870;

      newMarkers.add(
        Marker(
          markerId: MarkerId('my_${building.id}'),
          position: LatLng(safeLat, safeLng),
          icon:
              _customIconForMyBuildings ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: InfoWindow(
            title: building.name ?? 'Моё здание',
            snippet: 'Нажми, чтобы узнать больше',
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: Text(building.name ?? 'Моё здание'),
                      content: const Text('Подробная информация о здании...'),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Закрыть'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                widget.onNavigateToSearch?.call();
                              },
                              child: const Text('Открыть'),
                            ),
                          ],
                        ),
                      ],
                    ),
              );
            },
          ),
        ),
      );
    }

    // Затем добавляем здания из Google Places
    final apiKey = '***REMOVED***';
    final url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=buildings+in+Dushanbe&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;

      for (var result in results) {
        final location = result['geometry']['location'];
        final lat = location['lat'];
        final lng = location['lng'];
        final name = result['name'];

        newMarkers.add(
          Marker(
            markerId: MarkerId('google_$name'),
            position: LatLng(lat, lng),
            icon:
                _customIcon ??
                BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
            infoWindow: InfoWindow(title: name, snippet: 'Google здание'),
          ),
        );
      }
    } else {
      print('Ошибка при загрузке Google Places');
    }

    setState(() {
      _markers = newMarkers;
    });

    // Переместим камеру на центр моих зданий (или на центр Душанбе, если зданий нет)
    _moveCameraToMyBuildings(myBuildings);
  }

  ///////////////////

  Future<void> _moveCameraToMyBuildings(
    List<BuildingModel?> myBuildings,
  ) async {
    if (_mapController == null) return;

    List<LatLng> positions = [];

    for (var building in myBuildings) {
      if (building == null) continue;
      final lat =
          (building.longitude != null && building.longitude! > 0)
              ? building.longitude!
              : 38.5598;
      final lng =
          (building.latitude != null && building.latitude! > 0)
              ? building.latitude!
              : 68.7870;

      positions.add(LatLng(lat, lng));
    }

    if (positions.isEmpty) {
      // Нет координат — ставим камеру в центр Душанбе
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(38.5598, 68.7870), 13),
      );
    } else if (positions.length == 1) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(positions.first, 15),
      );
    } else {
      // Рассчитаем Bounds для всех зданий и переместим туда камеру
      LatLngBounds bounds = _boundsFromLatLngList(positions);
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    }
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0 = list.first.latitude;
    double x1 = list.first.latitude;
    double y0 = list.first.longitude;
    double y1 = list.first.longitude;

    for (LatLng latLng in list) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }
    return LatLngBounds(southwest: LatLng(x0, y0), northeast: LatLng(x1, y1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Карта зданий')),
      body: GoogleMap(
        onMapCreated: (controller) {
          _mapController = controller;
          _loadAllMarkers(); // Загружаем и перемещаем камеру
        },
        markers: Set<Marker>.of(_markers),
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0), // ⛔ не важно, что здесь — она сразу поменяется
          zoom: 1,
        ),
      ),
    );
  }
}
*/