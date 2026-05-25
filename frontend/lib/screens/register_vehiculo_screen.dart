import 'package:flutter/material.dart';
import '../models/vehiculo.dart';
import '../services/storage_service.dart';

class RegisterVehiculoScreen extends StatefulWidget {
  const RegisterVehiculoScreen({super.key});

  @override
  State<RegisterVehiculoScreen> createState() => _RegisterVehiculoScreenState();
}

class _RegisterVehiculoScreenState extends State<RegisterVehiculoScreen> {
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _colorController = TextEditingController();
  final _placaController = TextEditingController();
  final _cuposController = TextEditingController();
  bool _guardando = false;

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _colorController.dispose();
    _placaController.dispose();
    _cuposController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (_marcaController.text.isEmpty ||
        _modeloController.text.isEmpty ||
        _colorController.text.isEmpty ||
        _placaController.text.isEmpty ||
        _cuposController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    setState(() => _guardando = true);

    final user = StorageService().currentUser;
    final vehiculo = Vehiculo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conductorEmail: user?.email ?? '',
      marca: _marcaController.text,
      modelo: _modeloController.text,
      color: _colorController.text,
      placa: _placaController.text,
      cupos: int.tryParse(_cuposController.text) ?? 0,
    );

    await StorageService().saveVehiculo(vehiculo);

    setState(() => _guardando = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vehículo registrado correctamente')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar vehículo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.directions_car, size: 80, color: Colors.grey),
            const SizedBox(height: 20),

            TextField(
              controller: _marcaController,
              decoration: const InputDecoration(
                labelText: 'Marca',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.branding_watermark),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _modeloController,
              decoration: const InputDecoration(
                labelText: 'Modelo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.car_repair),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _colorController,
              decoration: const InputDecoration(
                labelText: 'Color',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.color_lens),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _placaController,
              decoration: const InputDecoration(
                labelText: 'Placa',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.confirmation_number),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _cuposController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número de cupos',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.people),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _guardando ? null : _guardar,
                child: _guardando
                    ? const CircularProgressIndicator()
                    : const Text('Registrar vehículo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
