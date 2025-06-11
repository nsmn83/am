import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';

class RideMap extends StatefulWidget {
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;

  const RideMap({
    super.key,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
  });

  @override
  State<RideMap> createState() => _RideMapState();
}

class _RideMapState extends State<RideMap> {
  List<LatLng> routePoints = [];

  @override
  void initState() {
    super.initState();
    fetchRoute();
  }

 Future<void> fetchRoute() async {
  final dio = Dio();
  final url =
      'https://router.project-osrm.org/route/v1/driving/${widget.startLng},${widget.startLat};${widget.endLng},${widget.endLat}?overview=full&geometries=geojson';

  try {
    final response = await dio.get(url);

    if (response.statusCode == 200) {
      final data = response.data;
      final coords = data['routes'][0]['geometry']['coordinates'] as List;

      setState(() {
        routePoints = coords
            .map<LatLng>((c) => LatLng(c[1], c[0])) // [lng, lat] -> LatLng
            .toList();
      });
    } else {
      debugPrint('OSRM error: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Failed to fetch route: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    final LatLng start = LatLng(widget.startLat, widget.startLng);
    final LatLng end = LatLng(widget.endLat, widget.endLng);

    return SizedBox(
      height: 250,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: start,
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.your_app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: start,
                width: 40,
                height: 40,
                child: const Icon(Icons.location_on, color: Colors.green, size: 30),
              ),
              Marker(
                point: end,
                width: 40,
                height: 40,
                child: const Icon(Icons.flag, color: Colors.red, size: 30),
              ),
            ],
          ),
          if (routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: routePoints,
                  color: Colors.blue,
                  strokeWidth: 4,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
