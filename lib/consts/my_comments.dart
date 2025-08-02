
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:intetership_project/feature/home/data/models/building_model.dart';
// import 'package:intetership_project/feature/home/data/repos/building_service.dart';
// import 'package:intetership_project/feature/search/data/repos/building_map.dart';

// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   GoogleMapController? mapController;
//   List<BuildingModel> allbuildings = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadCustomIcon().then((_) {
//       fetchBuildingsFromBack();
//     });
//   }

//   Future<void> fetchBuildingsFromBack() async {
//     List<BuildingModel> buildings =
//         await BuildingService().getBuildingsFromBack();

//     Set<Marker> newMarkers =
//         buildings.map((building) {
//           return Marker(
//             markerId: MarkerId(building.id.toString()),
//             position: LatLng(building.latitude, building.longitude),
//             infoWindow: InfoWindow(
//               title: building.name,
//               // snippet: building.address,
//             ),
//             icon: customIcon ?? BitmapDescriptor.defaultMarker,
//             onTap: () {
//               setState(() {
//                 // selectedAddress = building.address;
//               });
//             },
//           );
//         }).toSet();

//     setState(() {
//       allbuildings = buildings;
//       _markers = newMarkers;

//       if (buildings.isNotEmpty) {
//         mapController?.animateCamera(
//           CameraUpdate.newLatLngZoom(
//             LatLng(buildings.first.latitude, buildings.first.longitude),
//             16,
//           ),
//         );
//       }
//     });
//   }

//   final LatLng _cityCenter = LatLng(38.573936, 68.773941);
//   Set<Marker> _markers = {};
//   String? selectedAddress;

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   BitmapDescriptor? customIcon;
//   Future<void> _loadCustomIcon() async {
//     try {
//       customIcon = await BitmapDescriptor.fromAssetImage(
//         const ImageConfiguration(size: Size(32, 32)),
//         'assets/icons/icon_zdaniye.bmp',
//       );
//       print('✅ Кастомная иконка загружена');
//     } catch (e) {
//       print('❌ Ошибка загрузки иконки: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextField(
//                 onSubmitted: (value) {
//                   searchPlaceAndBuildings(value);
//                 },
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   fillColor: Colors.white,
//                   filled: true,
//                   prefixIcon: Padding(
//                     padding: const EdgeInsets.only(left: 20),
//                     child: Icon(Icons.search, size: 35),
//                   ),
//                   hintText: 'Ҷустуҷу',
//                   hintStyle: TextStyle(fontSize: 20),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.circular(13),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.circular(13),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               SizedBox(
//                 height: 500,
//                 child: GoogleMap(
//                   onMapCreated: _onMapCreated,
//                   initialCameraPosition: CameraPosition(
//                     target:
//                         allbuildings.isNotEmpty
//                             ? LatLng(
//                               allbuildings[1].latitude,
//                               allbuildings[1].longitude,
//                             )
//                             : _cityCenter,
//                     zoom: 17.0,
//                   ),
//                   markers: _markers,
//                 ),
//               ),
//               SizedBox(height: 25),
//               if (allbuildings.isNotEmpty) Text(allbuildings.first.name),
//               if (selectedAddress != null)
//                 Container(
//                   color: Colors.white,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 20,
//                     ),
//                     child: Text(
//                       'Адрес: $selectedAddress',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }











  // void searchBuildingsLocally(String query) {
  //   final results =
  //       allbuildings
  //           .where((b) => b.name.toLowerCase().contains(query.toLowerCase()))
  //           .toList();

  //   if (results.isEmpty) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Здание не найдено')));
  //     return;
  //   }

  //   Set<Marker> newMarkers =
  //       results.map((building) {
  //         return Marker(
  //           markerId: MarkerId(building.id.toString()),
  //           position: LatLng(building.latitude, building.longitude),
  //           infoWindow: InfoWindow(
  //             title: building.name,
  //             // snippet: building.address,
  //           ),
  //           icon: customIcon ?? BitmapDescriptor.defaultMarker,
  //           onTap: () {
  //             setState(() {
  //               // selectedAddress = building.address;
  //             });
  //           },
  //         );
  //       }).toSet();

  //   setState(() {
  //     _markers = newMarkers;
  //     // selectedAddress = results.first.address;
  //   });

  //   mapController?.animateCamera(
  //     CameraUpdate.newLatLngZoom(
  //       LatLng(results.first.latitude, results.first.longitude),
  //       16,
  //     ),
  //   );
  // }

//   Future<void> searchPlaceAndBuildings(String query) async {
//     const apiKey = '***REMOVED***';

//     // 1. Text Search — ищем место по названию
//     final searchUrl = Uri.parse(
//       'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey',
//     );

//     final searchResponse = await http.get(searchUrl);

//     if (searchResponse.statusCode == 200) {
//       final searchData = json.decode(searchResponse.body);

//       if (searchData['status'] == 'OK' && searchData['results'].isNotEmpty) {
//         final place = searchData['results'][0];
//         final lat = place['geometry']['location']['lat'];
//         final lng = place['geometry']['location']['lng'];

//         final center = LatLng(lat, lng);

//         // 2. Nearby Search — ищем здания вокруг найденного центра
//         final nearbyUrl = Uri.parse(
//           'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
//           '?location=${lat},${lng}'
//           '&radius=2000'
//           '&keyword=building'
//           '&key=$apiKey',
//         );

//         final nearbyResponse = await http.get(nearbyUrl);

//         if (nearbyResponse.statusCode == 200) {
//           final nearbyData = json.decode(nearbyResponse.body);
//           final results = nearbyData['results'] as List;

//           Set<Marker> newMarkers = {};
//           // Попытка получить адрес
//           String address = '';
//           if (place.containsKey('vicinity')) {
//             address = place['vicinity'];
//           } else if (place.containsKey('formatted_address')) {
//             address = place['formatted_address'];
//           }

//           for (var place in results) {
//             final lat = place['geometry']['location']['lat'];
//             final lng = place['geometry']['location']['lng'];
//             final name = place['name'];

//             newMarkers.add(
//               Marker(
//                 markerId: MarkerId(name),
//                 position: LatLng(lat, lng),
//                 infoWindow: InfoWindow(title: name),
//                 onTap: () {
//                   setState(() {
//                     selectedAddress = address;
//                   });
//                 },
//               ),
//             );
//           }
//         }
//       }
//     }
//   }
// }

  //         // 3. Обновляем карту
  //         setState(() {
  //           _markers = newMarkers;
  //         });

  //         mapController?.animateCamera(CameraUpdate.newLatLngZoom(center, 16));
  //       }
  //     } else {
  //       print('Место не найдено');
  //     }
  //   } else {
  //     print('Ошибка запроса: ${searchResponse.statusCode}');
  //   }
  // }


 // Future<void> fetchBuildings() async {
  //   const apiKey =
  //       '***REMOVED***'; // ⬅️ Вставь сюда свой API-ключ
  //   final url =
  //       'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_cityCenter.latitude},${_cityCenter.longitude}&radius=2000&keyword=building&key=$apiKey';
  //   // 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=buildings+in+$_cityCenter&key=$apiKey';

  //   final response = await http.get(Uri.parse(url));

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final results = data['results'] as List;

  //     Set<Marker> newMarkers = {};

  //     for (var place in results) {
  //       final lat = place['geometry']['location']['lat'];
  //       final lng = place['geometry']['location']['lng'];
  //       final name = place['name'];

  //       // Попытка получить адрес
  //       String address = '';
  //       if (place.containsKey('vicinity')) {
  //         address = place['vicinity'];
  //       } else if (place.containsKey('formatted_address')) {
  //         address = place['formatted_address'];
  //       }

  //       // print(address);

  //       newMarkers.add(
  //         Marker(
  //           markerId: MarkerId(name),
  //           position: LatLng(lat, lng),
  //           infoWindow: InfoWindow(title: name, snippet: address),
  //           icon: customIcon ?? BitmapDescriptor.defaultMarker,
  //           onTap: () {
  //             setState(() {
  //               selectedAddress = address;
  //             });
  //           },
  //         ),
  //       );
  //     }
  //     setState(() {
  //       _markers = newMarkers;
  //     });
  //   } else {
  //     print('Ошибка: ${response.statusCode}');
  //   }
  // }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';

// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   final LatLng _cityCenter = LatLng(38.573936, 68.773941);
//   List<Marker> _markers = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchBuildings();
//   }

//   Future<void> fetchBuildings() async {
//     const apiKey = '***REMOVED***'; // Твой ключ
//     final url =
//         'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_cityCenter.latitude},${_cityCenter.longitude}&radius=2000&keyword=building&key=$apiKey';

//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final results = data['results'] as List;

//       List<Marker> newMarkers = [];

//       for (var place in results) {
//         final lat = place['geometry']['location']['lat'];
//         final lng = place['geometry']['location']['lng'];
//         final name = place['name'];

//         newMarkers.add(
//           Marker(
//             point: LatLng(lat, lng),
//             width: 40,
//             height: 40,
//             child: Tooltip(
//               message: name,
//               child: Image.asset(
//                 'assets/images/belka.png',
//                 width: 35,
//                 height: 35,
//               ),
//             ),
//           ),
//         );
//       }

//       setState(() {
//         _markers = newMarkers;
//       });
//     } else {
//       print('Ошибка: ${response.statusCode}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//           child: Column(
//             children: [
//               TextField(
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   fillColor: Colors.white,
//                   filled: true,
//                   prefixIcon: Padding(
//                     padding: const EdgeInsets.only(left: 20),
//                     child: Icon(Icons.search, size: 35),
//                   ),
//                   hintText: 'Ҷустуҷу',
//                   hintStyle: TextStyle(fontSize: 20),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.circular(13),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.circular(13),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: FlutterMap(
//                   options: MapOptions(initialCenter: _cityCenter, initialZoom: 16.5),
//                   children: [
//                     TileLayer(
//                       urlTemplate:
//                           'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                       // subdomains: ['a', 'b', 'c'],
//                     ),
//                     MarkerLayer(markers: _markers),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




//HOME PAGE
// import 'package:flutter/material.dart';
// import 'package:intetership_project/feature/each_bulding/presentation/pages/each_building_page.dart';
// import 'package:intetership_project/feature/home/data/models/building_model.dart';
// import 'package:intetership_project/feature/home/data/models/home_model.dart';
// import 'package:intetership_project/feature/home/data/repos/building_service.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<String> images = [
//     'assets/images/image 5.png',
//     'assets/images/image 6.png',
//     'assets/images/image 7 (3).png',
//     'assets/images/image (14).png',
//     'assets/images/image (15).png',
//     'assets/images/image (16).png',
//   ];

//   List<BuildingModel> allBuildings = [];

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   getBuildingsFromService();
//   // }

//   // getBuildingsFromService() async {
//   //   var buildings = await BuildingService().getBuildingsFromBack();

//   //   setState(() {
//   //     allBuildings = buildings;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     var media = MediaQuery.of(context).size;
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   SizedBox(),
//                   Icon(Icons.favorite_outline_rounded, size: 35),
//                 ],
//               ),
//               SizedBox(height: 15),
//               Expanded(
//                 child: GridView.builder(
//                   itemCount: buildings.length,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     mainAxisSpacing: 10,
//                     crossAxisSpacing: 10,
//                     crossAxisCount: 2,
//                     childAspectRatio: 0.85,
//                   ),
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder:
//                                 (context) => EachBuildingPage(
//                                   // index: index,
//                                   model: buildings[index],
//                                 ),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 26,
//                             vertical: 20,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 width: media.width / 2.5,

//                                 child: Image.asset(
//                                   buildings[index].building_img,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               SizedBox(height: 10),
//                               Text(
//                                 buildings[index].building_adress,
//                                 style: TextStyle(
//                                   fontSize: 25,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 buildings[index].building_street,
//                                 style: TextStyle(
//                                   fontSize: 22,
//                                   color: Color(0xFF000000),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
