import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPickerScreen extends StatefulWidget {
  final String label;

  const MapPickerScreen({
    super.key,
    required this.label,
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {

  // Ubicación inicial (Cali, Colombia)
  LatLng _selectedPoint = const LatLng(3.4516, -76.5320);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar ${widget.label}'),
      ),

      body: Column(
        children: [

          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _selectedPoint,
                initialZoom: 13,

                onTap: (tapPosition, point) {
                  setState(() {
                    _selectedPoint = point;
                  });
                },
              ),

              children: [

                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.carpulia_app',
                ),

                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedPoint,
                      width: 40,
                      height: 40,

                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [

                Text(
                  'Ubicación seleccionada:\n'
                  '${_selectedPoint.latitude.toStringAsFixed(5)}, '
                  '${_selectedPoint.longitude.toStringAsFixed(5)}',
                ),

                const SizedBox(height: 12),

                FilledButton(
                  onPressed: () {

                    final value =
                        '${_selectedPoint.latitude.toStringAsFixed(5)},'
                        '${_selectedPoint.longitude.toStringAsFixed(5)}';

                    Navigator.pop(context, value);
                  },

                  child: const Text('Guardar ubicación'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}