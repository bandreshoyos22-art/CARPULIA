import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../models/viaje.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'map_picker_screen.dart';

class CreateViajeScreen extends StatefulWidget {
  const CreateViajeScreen({super.key});

  @override
  State<CreateViajeScreen> createState() => _CreateViajeScreenState();
}

class _CreateViajeScreenState extends State<CreateViajeScreen> {
  final _origenController = TextEditingController();
  final _destinoController = TextEditingController();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _colorController = TextEditingController();
  final _placaController = TextEditingController();
  final _cuposController = TextEditingController(text: '1');
  final _precioController = TextEditingController(text: '0');
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  double? _origenLat;
  double? _origenLng;
  double? _destinoLat;
  double? _destinoLng;
  bool _loading = false;
  String? _error;

  Future<void> _pickPoint(String label) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => MapPickerScreen(label: label)),
    );
    if (result != null && result.isNotEmpty) {
      final parts = result.split(',');
      if (parts.length == 2) {
        final lat = double.tryParse(parts[0].trim());
        final lng = double.tryParse(parts[1].trim());
        if (lat != null && lng != null) {
          setState(() {
            if (label == 'Origen') {
              _origenLat = lat;
              _origenLng = lng;
              _origenController.text = '$lat, $lng';
            } else {
              _destinoLat = lat;
              _destinoLng = lng;
              _destinoController.text = '$lat, $lng';
            }
          });
        }
      }
    }
  }

  Future<void> _saveTrip() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final user = StorageService().currentUser;
    if (user == null) {
      setState(() {
        _error = 'Necesitas iniciar sesión.';
        _loading = false;
      });
      return;
    }

    final origen = _origenController.text.trim();
    final destino = _destinoController.text.trim();
    final marca = _marcaController.text.trim();
    final modelo = _modeloController.text.trim();
    final color = _colorController.text.trim();
    final placa = _placaController.text.trim();
    final cupos = int.tryParse(_cuposController.text.trim()) ?? 0;
    final precio = double.tryParse(_precioController.text.trim()) ?? 0.0;

    if (origen.isEmpty ||
        destino.isEmpty ||
        marca.isEmpty ||
        modelo.isEmpty ||
        color.isEmpty ||
        placa.isEmpty ||
        cupos <= 0 ||
        precio <= 0) {
      setState(() {
        _error = 'Completa todos los campos y usa valores válidos.';
        _loading = false;
      });
      return;
    }

    final viaje = Viaje(
      id: DateTime.now().millisecondsSinceEpoch,
      vehiculo: 1,
      conductorEmail: user.email,
      origen: origen,
      destino: destino,
      origenLat: _origenLat?.toStringAsFixed(6),
      origenLng: _origenLng?.toStringAsFixed(6),
      destinoLat: _destinoLat?.toStringAsFixed(6),
      destinoLng: _destinoLng?.toStringAsFixed(6),
      fecha: DateFormat('yyyy-MM-dd').format(_selectedDate),
      horaSalida: _selectedTime.format(context),
      cuposDisponibles: cupos,
      precio: precio,
      isLocal: true,
    );

    final trips = await StorageService().loadLocalTrips();
    final updatedTrips = [...trips, viaje];
    await StorageService().saveLocalTrips(updatedTrips);

    final apiResult = await ApiService().createViaje(viaje);
    if (apiResult != null) {
      final newList = updatedTrips.map((item) {
        if (item.id == viaje.id) {
          return item.copyWith(id: apiResult.id);
        }
        return item;
      }).toList();
      await StorageService().saveLocalTrips(newList);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> _selectDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (result != null) {
      setState(() => _selectedDate = result);
    }
  }

  Future<void> _selectTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (result != null) {
      setState(() => _selectedTime = result);
    }
  }

  @override
  void dispose() {
    _origenController.dispose();
    _destinoController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _colorController.dispose();
    _placaController.dispose();
    _cuposController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  Widget _buildRoutePreview() {
    if (_origenLat == null ||
        _origenLng == null ||
        _destinoLat == null ||
        _destinoLng == null) {
      return const SizedBox.shrink();
    }

    final originPoint = LatLng(_origenLat!, _origenLng!);
    final destinationPoint = LatLng(_destinoLat!, _destinoLng!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Vista previa de la ruta',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                (originPoint.latitude + destinationPoint.latitude) / 2,
                (originPoint.longitude + destinationPoint.longitude) / 2,
              ),
              initialZoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [originPoint, destinationPoint],
                    color: Colors.blueAccent.withValues(
                      alpha: 204,
                      red: 33,
                      green: 150,
                      blue: 243,
                    ),
                    strokeWidth: 4,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: originPoint,
                    width: 36,
                    height: 36,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.green,
                      size: 36,
                    ),
                  ),
                  Marker(
                    point: destinationPoint,
                    width: 36,
                    height: 36,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear viaje')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _origenController,
              decoration: const InputDecoration(labelText: 'Origen'),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () => _pickPoint('Origen'),
              child: const Text('Seleccionar origen en el mapa'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _destinoController,
              decoration: const InputDecoration(labelText: 'Destino'),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () => _pickPoint('Destino'),
              child: const Text('Seleccionar destino en el mapa'),
            ),
            _buildRoutePreview(),
            const SizedBox(height: 16),
            TextField(
              controller: _marcaController,
              decoration: const InputDecoration(
                labelText: 'Marca del vehículo',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _modeloController,
              decoration: const InputDecoration(
                labelText: 'Modelo del vehículo',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _colorController,
              decoration: const InputDecoration(
                labelText: 'Color del vehículo',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _placaController,
              decoration: const InputDecoration(labelText: 'Placa'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: _selectDate,
                    child: Text(
                      'Fecha: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: _selectTime,
                    child: Text('Hora: ${_selectedTime.format(context)}'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cuposController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cupos disponibles'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _precioController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Precio (S/)'),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _loading ? null : _saveTrip,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar viaje'),
            ),
          ],
        ),
      ),
    );
  }
}
