// import 'dart:convert';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;

// Future<void> fetchBuildings() async {
//     const apiKey = 'ТВОЙ_API_КЛЮЧ'; // ⬅️ Вставь сюда свой API-ключ
//     final url =
//         'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_cityCenter.latitude},${_cityCenter.longitude}&radius=2000&keyword=building&key=$apiKey';

//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final results = data['results'] as List;

//       Set<Marker> newMarkers = {};

//       for (var place in results) {
//         final lat = place['geometry']['location']['lat'];
//         final lng = place['geometry']['location']['lng'];
//         final name = place['name'];

//         newMarkers.add(
//           Marker(
//             markerId: MarkerId(name),
//             position: LatLng(lat, lng),
//             infoWindow: InfoWindow(title: name),
//           ),
//         );
//       }
//     }
// }
