// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:intetership_project/feature/each_bulding/presentation/pages/each_building_page.dart';
// import 'package:intetership_project/feature/home/data/models/building_model.dart';
// import 'package:intetership_project/feature/home/data/models/company_model.dart';
// import 'package:intetership_project/feature/home/data/models/home_model.dart';
// import 'package:intetership_project/feature/home/data/repos/building_service.dart';
// import 'package:intetership_project/feature/home/data/repos/company_service.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intetership_project/feature/favourite/data/favourite_provider.dart';
// import 'package:intetership_project/feature/home/presentation/pages/shimmer_page.dart';
// import 'package:shimmer/shimmer.dart';

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

//   List<BuildingModel?> allBuildings = [];
//   List<CompanyModel> allCompanies = [];
//   List<BuildingModel?> filteredBuildings = [];
//   int _selectedIndex = 0;
//   String? selectedAddress;
//   String searchQuery = '';

//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     getBuildingsFromService();
//     getCompaniesFromService();
//   }

//   getBuildingsFromService() async {
//     var buildings = await BuildingService().getBuildingsFromBack();
//     await Future.delayed(Duration(seconds: 3));
//     setState(() {
//       allBuildings = buildings;
//       filteredBuildings = buildings;
//       isLoading = false;
//     });
//   }

//   getCompaniesFromService() async {
//     var companies = await CompanyService().getCompaniesFromBack();

//     setState(() {
//       allCompanies = companies;
//     });
//   }

//   String getCompanyName(int companyId) {
//     try {
//       final company = allCompanies.firstWhere((c) => c.id == companyId);
//       return company.name;
//     } catch (e) {
//       return 'Company $companyId';
//     }
//   }

  
//   GoogleMapController? mapController;

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   final LatLng _cityCenter = LatLng(38.573936, 68.773941);
//   Set<Marker> _markers = {};

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
//     var media = MediaQuery.of(context).size;
//     return Scaffold(
//       extendBody: true,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title:
//             isLoading == true
//                 ? Shimmer.fromColors(
//                   baseColor: Colors.grey.shade400,
//                   highlightColor: Colors.grey.shade100,
//                   child: Text(
//                     'Buildings',
//                     style: TextStyle(color: Colors.white, fontSize: 26),
//                   ),
//                 )
//                 : Text(
//                   'Buildings',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 26,
//                   ),
//                 ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blue.shade50, Colors.white],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextField(
//                   onSubmitted: (value) {
//                     searchPlaceAndBuildings(value);
//                   },
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     fillColor: Colors.white,
//                     filled: true,
//                     prefixIcon: Padding(
//                       padding: const EdgeInsets.only(left: 20),
//                       child: Icon(Icons.search, size: 35),
//                     ),
//                     hintText: 'Ҷустуҷу',
//                     hintStyle: TextStyle(fontSize: 20),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide.none,
//                       borderRadius: BorderRadius.circular(13),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide.none,
//                       borderRadius: BorderRadius.circular(13),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 SizedBox(
//                   height: 500,
//                   child: GoogleMap(
//                     onMapCreated: _onMapCreated,
//                     initialCameraPosition: CameraPosition(
//                       target: _cityCenter,
//                       zoom: 17.0,
//                     ),
//                     markers: _markers,
//                   ),
//                 ),
//                 SizedBox(height: 25),
//                 SizedBox(
//                   height: 500,
//                   child: Expanded(
//                     child: Consumer(
//                       builder: (context, ref, _) {
//                         final favourites = ref.watch(
//                           favouriteBuildingsProvider,
//                         );
//                         final notifier = ref.read(
//                           favouriteBuildingsProvider.notifier,
//                         );
//                         final buildingsToShow =
//                             searchQuery.isEmpty
//                                 ? allBuildings
//                                 : filteredBuildings;
//                         return filteredBuildings.isEmpty
//                             ? ShimmerPage()
//                             : GridView.builder(
//                               itemCount: buildingsToShow.length,
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                     mainAxisSpacing: 16,
//                                     crossAxisSpacing: 16,
//                                     crossAxisCount: 2,
//                                     childAspectRatio: 0.75,
//                                   ),
//                               itemBuilder: (context, index) {
//                                 final building = buildingsToShow[index]!;
//                                 final isFav = favourites.any(
//                                   (b) => b.id == building.id,
//                                 );
//                                 return GestureDetector(
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder:
//                                             (context) => EachBuildingPage(
//                                               building: building,
//                                             ),
//                                       ),
//                                     );
//                                   },
//                                   child: Card(
//                                     elevation: 5,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(18),
//                                     ),
//                                     child: Stack(
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.all(12.0),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(12),
//                                                 child: Container(
//                                                   width: double.infinity,
//                                                   height: media.height / 7.5,
//                                                   color: Colors.grey.shade200,
//                                                   child: Image.asset(
//                                                     images[index %
//                                                         images.length],
//                                                     fit: BoxFit.cover,
//                                                     errorBuilder:
//                                                         (
//                                                           context,
//                                                           error,
//                                                           stackTrace,
//                                                         ) => Icon(
//                                                           Icons.image,
//                                                           size: 48,
//                                                           color: Colors.grey,
//                                                         ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(height: 10),
//                                               Text(
//                                                 building.name ?? 'No Name',
//                                                 style: TextStyle(
//                                                   fontSize: 18,
//                                                   fontWeight: FontWeight.bold,
//                                                   color:
//                                                       Colors.blueGrey.shade900,
//                                                 ),
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                               SizedBox(height: 4),
//                                               Row(
//                                                 children: [
//                                                   Icon(
//                                                     Icons.location_on,
//                                                     size: 16,
//                                                     color: Colors.blueAccent,
//                                                   ),
//                                                   SizedBox(width: 4),
//                                                   Expanded(
//                                                     child: Text(
//                                                       building.address ?? '',
//                                                       style: TextStyle(
//                                                         fontSize: 13,
//                                                         color:
//                                                             Colors
//                                                                 .blueGrey
//                                                                 .shade600,
//                                                       ),
//                                                       maxLines: 1,
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               SizedBox(height: 4),
//                                               Row(
//                                                 children: [
//                                                   Icon(
//                                                     Icons.business,
//                                                     size: 16,
//                                                     color: Colors.orange,
//                                                   ),
//                                                   SizedBox(width: 4),
//                                                   Expanded(
//                                                     child: Text(
//                                                       getCompanyName(
//                                                         building.company,
//                                                       ),
//                                                       style: TextStyle(
//                                                         fontSize: 13,
//                                                         color:
//                                                             Colors
//                                                                 .blueGrey
//                                                                 .shade600,
//                                                       ),
//                                                       maxLines: 1,
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               SizedBox(height: 8),
//                                               SizedBox(
//                                                 height: 70,
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Row(
//                                                       children: [
//                                                         Icon(
//                                                           Icons.apartment,
//                                                           size: 16,
//                                                           color:
//                                                               Colors
//                                                                   .amber
//                                                                   .shade700,
//                                                         ),
//                                                         SizedBox(width: 4),
//                                                         Text(
//                                                           'Flats:${building.flats_count}',
//                                                           style: TextStyle(
//                                                             fontSize: 13,
//                                                             color:
//                                                                 Colors
//                                                                     .blueGrey
//                                                                     .shade700,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     SizedBox(height: 12),
//                                                     // Spacer(),
//                                                     Row(
//                                                       children: [
//                                                         Icon(
//                                                           Icons.stairs,
//                                                           size: 16,
//                                                           color:
//                                                               Colors
//                                                                   .green
//                                                                   .shade700,
//                                                         ),
//                                                         SizedBox(width: 4),
//                                                         Text(
//                                                           'Floors:${building.floors_count}',
//                                                           style: TextStyle(
//                                                             fontSize: 13,
//                                                             color:
//                                                                 Colors
//                                                                     .blueGrey
//                                                                     .shade700,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Positioned(
//                                           top: 8,
//                                           right: 8,
//                                           child: IconButton(
//                                             icon: Icon(
//                                               isFav
//                                                   ? Icons.favorite
//                                                   : Icons.favorite_border,
//                                               color: Colors.redAccent,
//                                             ),
//                                             onPressed: () {
//                                               notifier.toggleFavourite(
//                                                 building,
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> searchPlaceAndBuildings(String query) async {
//     const apiKey = '***REMOVED***';

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

//         final nearbyUrl = Uri.parse(
//           'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
//           '?location=${lat},${lng}'
//           '&radius=2000'
//           '&keyword=building'
//           '&key=$apiKey',
//         );

//         final nearbyResponse = await http.get(nearbyUrl);

//         Set<Marker> googleMarkers = {};

//         if (nearbyResponse.statusCode == 200) {
//           final nearbyData = json.decode(nearbyResponse.body);
//           final results = nearbyData['results'] as List;

//           for (var place in results) {
//             final lat = place['geometry']['location']['lat'];
//             final lng = place['geometry']['location']['lng'];
//             final name = place['name'];

//             googleMarkers.add(
//               Marker(
//                 markerId: MarkerId('google_$name'),
//                 position: LatLng(lat, lng),
//                 icon: BitmapDescriptor.defaultMarkerWithHue(
//                   BitmapDescriptor.hueRed,
//                 ),
//                 infoWindow: InfoWindow(title: name),
//                 onTap: () {
//                   setState(() {
//                     selectedAddress =
//                         place['vicinity'] ?? place['formatted_address'] ?? '';
//                   });
//                 },
//               ),
//             );
//           }
//         }

//         // Отфильтруем свои здания по имени
//         final filteredBuildings =
//             allBuildings.where((building) {
//               final nameLower = building!.name?.toLowerCase() ?? '';
//               final queryLower = query.toLowerCase();
//               return nameLower.contains(queryLower);
//             }).toList();

//         Set<Marker> myMarkers = {};

//         for (var building in filteredBuildings) {
//           if (building!.latitude != null && building.longitude != null) {
//             myMarkers.add(
//               Marker(
//                 markerId: MarkerId('my_building_${building.id}'),
//                 position: LatLng(building.latitude!, building.longitude!),
//                 infoWindow: InfoWindow(
//                   title: building.name ?? 'My Building',
//                   snippet: building.address ?? '',
//                 ),
//                 icon: customIcon ?? BitmapDescriptor.defaultMarker,
//                 onTap: () {
//                   setState(() {
//                     selectedAddress = building.address ?? '';
//                   });
//                 },
//               ),
//             );
//           }
//         }

//         // Объединяем маркеры Google и свои
//         final combinedMarkers = {...googleMarkers, ...myMarkers};

//         setState(() {
//           _markers = combinedMarkers;
//         });

//         mapController?.animateCamera(CameraUpdate.newLatLngZoom(center, 16));
//       } else {
//         // Если не нашли в Google, показываем только свои здания по фильтру
//         final filteredBuildings =
//             allBuildings.where((building) {
//               final nameLower = building!.name?.toLowerCase() ?? '';
//               final queryLower = query.toLowerCase();
//               return nameLower.contains(queryLower);
//             }).toList();

//         Set<Marker> myMarkers = {};

//         for (var building in filteredBuildings) {
//           if (building!.latitude != null && building.longitude != null) {
//             myMarkers.add(
//               Marker(
//                 markerId: MarkerId('my_building_${building.id}'),
//                 position: LatLng(building.latitude!, building.longitude!),
//                 infoWindow: InfoWindow(
//                   title: building.name ?? 'My Building',
//                   snippet: building.address ?? '',
//                 ),
//                 icon: customIcon ?? BitmapDescriptor.defaultMarker,
//                 onTap: () {
//                   setState(() {
//                     selectedAddress = building.address ?? '';
//                   });
//                 },
//               ),
//             );
//           }
//         }

//         setState(() {
//           _markers = myMarkers;
//         });
//       }
//     } else {
//       print('Ошибка запроса: ${searchResponse.statusCode}');
//     }
//   }
// } 