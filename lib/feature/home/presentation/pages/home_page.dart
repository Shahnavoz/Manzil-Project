import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intetership_project/feature/home/data/models/building_model.dart';
import 'package:intetership_project/feature/home/data/models/home_model.dart';
import 'package:intetership_project/feature/home/data/repos/building_service.dart';
import 'package:intetership_project/feature/search/presentation/pages/search_page.dart';

class HomePage extends StatefulWidget {
  final void Function(int buildingId)? onNavigateToSearch;
  HomePage({super.key, this.onNavigateToSearch});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  BitmapDescriptor? _customIcon;
  BitmapDescriptor? _customIconForMyBuildings;
  String? selectedAddress;
  List<BuildingModel?> allBuildings = [];

  @override
  void initState() {
    super.initState();
    _initAll();
  }

  Future<void> _initAll() async {
    // await _loadCustomIcon();
    await _loadCustomIconForMyBuildings();
    await _loadAllMarkers();
  }

  // Future<void> _loadCustomIcon() async {
  //   final icon = await BitmapDescriptor.fromAssetImage(
  //     const ImageConfiguration(size: Size(48, 48)),
  //     'assets/images/belka_new1.bmp',
  //   );
  //   _customIcon = icon;
  // }

  Future<void> _loadCustomIconForMyBuildings() async {
    final icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/icons/icon_zdaniye_new.bmp',
    );
    _customIconForMyBuildings = icon;
  }

  Future<void> _loadAllMarkers() async {
    Set<Marker> newMarkers = {};

    // Загружаем свои здания
    final myBuildings = await BuildingService().getBuildingsFromBack();
    setState(() {
      allBuildings = myBuildings;
    });

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
            snippet: 'Пахш кунед барои маълумоти бештар',
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: Text(building.name ?? 'Моё здание'),
                      content: const Text('Маълумоти бештар дар бораи бино...',style: TextStyle(overflow: TextOverflow.ellipsis),),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Пӯшидан'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                final callback = widget.onNavigateToSearch;
                                if (callback != null) {
                                  callback(building.id);
                                }
                              },
                              child: const Text('Кушодан'),
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
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Карта зданий')),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: TextField(
          //     onSubmitted: (value) {
          //       searchPlaceAndBuildings(value);
          //     },
          //     decoration: InputDecoration(
          //       border: InputBorder.none,
          //       fillColor: Colors.white,
          //       filled: true,
          //       prefixIcon: Padding(
          //         padding: const EdgeInsets.only(left: 20),
          //         child: Icon(Icons.search, size: 35),
          //       ),
          //       hintText: 'Ҷустуҷу',
          //       hintStyle: TextStyle(fontSize: 20),
          //       enabledBorder: OutlineInputBorder(
          //         borderSide: BorderSide.none,
          //         borderRadius: BorderRadius.circular(13),
          //       ),
          //       focusedBorder: OutlineInputBorder(
          //         borderSide: BorderSide.none,
          //         borderRadius: BorderRadius.circular(13),
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
                _loadAllMarkers(); // Загружаем и перемещаем камеру
              },
              markers: Set<Marker>.of(_markers),
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  0,
                  0,
                ), // ⛔ не важно, что здесь — она сразу поменяется
                zoom: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> searchPlaceAndBuildings(String query) async {
    const apiKey = '***REMOVED***';

    final searchUrl = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey',
    );

    final searchResponse = await http.get(searchUrl);

    if (searchResponse.statusCode == 200) {
      final searchData = json.decode(searchResponse.body);

      if (searchData['status'] == 'OK' && searchData['results'].isNotEmpty) {
        final place = searchData['results'][0];
        final lat = place['geometry']['location']['lat'];
        final lng = place['geometry']['location']['lng'];

        final center = LatLng(lat, lng);

        final nearbyUrl = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
          '?location=${lat},${lng}'
          '&radius=2000'
          '&keyword=building'
          '&key=$apiKey',
        );

        final nearbyResponse = await http.get(nearbyUrl);

        Set<Marker> googleMarkers = {};

        if (nearbyResponse.statusCode == 200) {
          final nearbyData = json.decode(nearbyResponse.body);
          final results = nearbyData['results'] as List;

          for (var place in results) {
            final lat = place['geometry']['location']['lat'];
            final lng = place['geometry']['location']['lng'];
            final name = place['name'];

            googleMarkers.add(
              Marker(
                markerId: MarkerId('google_$name'),
                position: LatLng(lat, lng),
                icon:
                    _customIcon ??
                    BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                infoWindow: InfoWindow(title: name),
                onTap: () {
                  setState(() {
                    selectedAddress =
                        place['vicinity'] ?? place['formatted_address'] ?? '';
                  });
                },
              ),
            );
          }
        }

        // Отфильтруем свои здания по имени
        final filteredBuildings =
            allBuildings.where((building) {
              final nameLower = building!.name?.toLowerCase() ?? '';
              final queryLower = query.toLowerCase();
              return nameLower.contains(queryLower);
            }).toList();

        Set<Marker> myMarkers = {};

        for (var building in filteredBuildings) {
          if (building!.latitude != null && building.longitude != null) {
            myMarkers.add(
              Marker(
                markerId: MarkerId('my_building_${building.id}'),
                position: LatLng(building.latitude!, building.longitude!),
                infoWindow: InfoWindow(
                  title: building.name ?? 'My Building',
                  snippet: building.address ?? '',
                ),
                icon: _customIcon ?? BitmapDescriptor.defaultMarker,
                onTap: () {
                  setState(() {
                    selectedAddress = building.address ?? '';
                  });
                },
              ),
            );
          }
        }

        // Объединяем маркеры Google и свои
        final combinedMarkers = {...googleMarkers, ...myMarkers};

        setState(() {
          _markers = combinedMarkers;
        });

        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(center, 16));
      } else {
        // Если не нашли в Google, показываем только свои здания по фильтру
        final filteredBuildings =
            allBuildings.where((building) {
              final nameLower = building!.name?.toLowerCase() ?? '';
              final queryLower = query.toLowerCase();
              return nameLower.contains(queryLower);
            }).toList();

        Set<Marker> myMarkers = {};

        for (var building in filteredBuildings) {
          if (building!.latitude != null && building.longitude != null) {
            myMarkers.add(
              Marker(
                markerId: MarkerId('my_building_${building.id}'),
                position: LatLng(building.latitude!, building.longitude!),
                infoWindow: InfoWindow(
                  title: building.name ?? 'My Building',
                  snippet: building.address ?? '',
                ),
                icon: _customIcon ?? BitmapDescriptor.defaultMarker,
                onTap: () {
                  setState(() {
                    selectedAddress = building.address ?? '';
                  });
                },
              ),
            );
          }
        }

        setState(() {
          _markers = myMarkers;
        });
      }
    } else {
      print('Ошибка запроса: ${searchResponse.statusCode}');
    }
  }
}
