import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();
  LocationData? currentLocation;
  List<LatLng> routePoints = [];
  List<Marker> markers = [];
  final String orsApiKey = '5b3ce3597851110001cf624895474e85b34b4602a7b6fa5d51ed4339';
  final LatLng palestineLocation = LatLng(31.7683, 35.2137); // موقع في فلسطين (القدس)

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    var location = Location();
    try {
      var userLocation = await location.getLocation();
      setState(() {
        currentLocation = userLocation;
        markers.add(
          Marker(
            width: 80,
            height: 80,
            point: LatLng(userLocation.latitude!, userLocation.longitude!),
            child: const Icon(Icons.location_on, color: Colors.blue, size: 40),
          ),
        );
        markers.add(
          Marker(
            width: 80,
            height: 80,
            point: palestineLocation,
            child: const Icon(Icons.flag, color: Colors.green, size: 40),
          ),
        );
      });
      _getRoute(palestineLocation);
    } catch (e) {
      currentLocation = null;
    }
  }

  Future<void> _getRoute(LatLng destination) async {
    if (currentLocation == null) return;
    final start = LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
    final response = await http.get(
      Uri.parse(
          'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$orsApiKey&start=${start.longitude},${start.latitude}&end=${destination.longitude},${destination.latitude}'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> coords = data['features'][0]['geometry']['coordinates'];
      setState(() {
        routePoints = coords.map((coord) => LatLng(coord[1], coord[0])).toList();
      });
    } else {
      print('فشل في جلب المسار');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Location'),
      ),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          initialZoom: 10.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: markers,
          ),
          if (routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: routePoints,
                  strokeWidth: 2.0,
                  color: Colors.yellow,
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentLocation != null) {
            mapController.move(
              LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
              12.0,
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
