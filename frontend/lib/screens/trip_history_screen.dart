import 'package:flutter/material.dart';
import '../models/viaje.dart';
import '../services/storage_service.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Viaje> _todosLosViajes = [];
  final String _userEmail = StorageService().currentUser?.email ?? '';
  final String _userRole = StorageService().currentUser?.role ?? '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _cargarViajes();
  }

  Future<void> _cargarViajes() async {
    final viajes = await StorageService().loadLocalTrips();
    setState(() {
      _todosLosViajes = viajes;
    });
  }

  List<Viaje> get _viajesCreados =>
      _todosLosViajes.where((v) => v.conductorEmail == _userEmail).toList();

  List<Viaje> get _viajesComoPassajero =>
      _todosLosViajes.where((v) => v.conductorEmail != _userEmail).toList();

  List<Viaje> get _viajesFinalizados =>
      _todosLosViajes.where((v) => v.cuposDisponibles == 0).toList();

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de viajes'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Creados'),
            Tab(text: 'Tomados'),
            Tab(text: 'Finalizados'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildListaViajes(_viajesCreados, 'No has creado viajes'),
          _buildListaViajes(_viajesComoPassajero, 'No has tomado viajes'),
          _buildListaViajes(_viajesFinalizados, 'No hay viajes finalizados'),
        ],
      ),
    );
  }

  Widget _buildListaViajes(List<Viaje> viajes, String mensajeVacio) {
    if (viajes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.directions_car_outlined,
              size: 60,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(mensajeVacio, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _cargarViajes,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: viajes.length,
        itemBuilder: (context, index) {
          final viaje = viajes[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          viaje.origen,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.flag, color: Colors.red, size: 18),
                      const SizedBox(width: 6),
                      Expanded(child: Text(viaje.destino)),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            viaje.fecha,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            viaje.horaSalida,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.attach_money,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '\$${viaje.precio.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
