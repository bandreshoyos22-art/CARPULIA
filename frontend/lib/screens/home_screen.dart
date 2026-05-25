import 'package:flutter/material.dart';

import '../models/solicitud.dart';
import '../models/user.dart';
import '../models/viaje.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

import 'chat_screen.dart';
import 'create_viaje_screen.dart';
import 'login_screen.dart';
import 'settings_screen.dart';
import 'trip_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final ApiService _api = ApiService();
  AppUser? _user;
  List<Viaje> _serverTrips = <Viaje>[];
  List<Viaje> _localTrips = <Viaje>[];
  List<JoinRequest> _requests = <JoinRequest>[];
  String _filterDestino = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final user =
        StorageService().currentUser ??
        await StorageService().loadCurrentUser();
    final localTrips = await StorageService().loadLocalTrips();
    final requests = await StorageService().loadRequests();
    List<Viaje> serverTrips = <Viaje>[];
    try {
      serverTrips = await _api.fetchViajes();
    } catch (_) {
      serverTrips = <Viaje>[];
    }
    setState(() {
      _user = user;
      _serverTrips = serverTrips;
      _localTrips = localTrips;
      _requests = requests;
      _selectedIndex = user?.role == 'pasajero' ? 1 : 0;
      _loading = false;
    });
  }

  Future<void> _saveLocalTrips(List<Viaje> trips) async {
    await StorageService().saveLocalTrips(trips);
    setState(() => _localTrips = trips);
  }

  Future<void> _saveRequests(List<JoinRequest> requests) async {
    await StorageService().saveRequests(requests);
    setState(() => _requests = requests);
  }

  Future<void> _onCreateTrip() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const CreateViajeScreen()),
    );
    if (result == true) {
      await _loadData();
    }
  }

  void _acceptRequest(JoinRequest request) async {
    final trip = _localTrips.firstWhere(
      (viaje) => viaje.id == request.viajeId,
      orElse: () => Viaje(
        id: null,
        vehiculo: 1,
        conductorEmail: '',
        origen: '',
        destino: '',
        fecha: '',
        horaSalida: '',
        cuposDisponibles: 0,
        precio: 0,
      ),
    );
    if (trip.id == null) return;
    if (trip.cuposDisponibles < request.seatsRequested) {
      return;
    }
    final updatedTrip = trip.copyWith(
      cuposDisponibles: trip.cuposDisponibles - request.seatsRequested,
    );
    final updatedTrips = _localTrips.map((item) {
      return item.id == updatedTrip.id ? updatedTrip : item;
    }).toList();
    final updatedRequests = _requests.map((item) {
      return item.requestId == request.requestId
          ? JoinRequest(
              requestId: item.requestId,
              viajeId: item.viajeId,
              pasajeroEmail: item.pasajeroEmail,
              seatsRequested: item.seatsRequested,
              status: 'Aceptada',
            )
          : item;
    }).toList();
    await _saveLocalTrips(updatedTrips);
    await _saveRequests(updatedRequests);
    final updatedViaje = await _api.updateViaje(updatedTrip);
    if (updatedViaje != null) {
      await _loadData();
    }
  }

  Widget _buildConductorTab() {
    final userEmail = _user?.email ?? '';
    final conductorTrips = _localTrips
        .where((trip) => trip.conductorEmail == userEmail)
        .toList();
    final pendingRequests = _requests.where((request) {
      final trip = _localTrips.firstWhere(
        (item) => item.id == request.viajeId,
        orElse: () => Viaje(
          id: null,
          vehiculo: 1,
          conductorEmail: '',
          origen: '',
          destino: '',
          fecha: '',
          horaSalida: '',
          cuposDisponibles: 0,
          precio: 0,
        ),
      );
      return request.status == 'Pendiente' && trip.conductorEmail == userEmail;
    }).toList();

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            icon: const Icon(Icons.add),
            label: const Text('Crear viaje'),
            onPressed: _onCreateTrip,
          ),
          const SizedBox(height: 24),
          const Text(
            'Tus viajes como conductor',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (conductorTrips.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Aún no has creado viajes. Usa el botón para agregar uno.',
              ),
            ),
          ...conductorTrips.map((trip) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text('${trip.origen} → ${trip.destino}'),
                subtitle: Text(
                  'Salida: ${trip.fecha} ${trip.horaSalida} · Cupos: ${trip.cuposDisponibles} · Precio: S/ ${trip.precio.toStringAsFixed(2)}',
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          const Text(
            'Solicitudes pendientes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (pendingRequests.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('No hay solicitudes pendientes por aceptar.'),
            ),
          ...pendingRequests.map((request) {
            final trip = _localTrips.firstWhere(
              (item) => item.id == request.viajeId,
              orElse: () => Viaje(
                id: null,
                vehiculo: 1,
                conductorEmail: '',
                origen: '',
                destino: '',
                fecha: '',
                horaSalida: '',
                cuposDisponibles: 0,
                precio: 0,
              ),
            );
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text('${trip.origen} → ${trip.destino}'),
                subtitle: Text(
                  'Pasajero: ${request.pasajeroEmail} · Asientos: ${request.seatsRequested}',
                ),
                trailing: FilledButton(
                  onPressed: trip.id == null
                      ? null
                      : () => _acceptRequest(request),
                  child: const Text('Aceptar'),
                ),
              ),
            );
          }),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildPasajeroTab() {
    final search = _filterDestino.trim().toLowerCase();
    final allTrips = <Viaje>[..._serverTrips, ..._localTrips];
    final filtered = allTrips.where((trip) {
      return search.isEmpty || trip.destino.toLowerCase().contains(search);
    }).toList();
    final userEmail = _user?.email ?? '';
    final myRequests = _requests
        .where((request) => request.pasajeroEmail == userEmail)
        .toList();

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Filtrar por destino',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) => setState(() => _filterDestino = value),
          ),
          const SizedBox(height: 16),
          if (myRequests.isNotEmpty) ...[
            const Text(
              'Mis solicitudes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...myRequests.map((request) {
              final trip = allTrips.firstWhere(
                (item) => item.id == request.viajeId,
                orElse: () => Viaje(
                  id: null,
                  vehiculo: 1,
                  conductorEmail: '',
                  origen: '',
                  destino: '',
                  fecha: '',
                  horaSalida: '',
                  cuposDisponibles: 0,
                  precio: 0,
                ),
              );
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text('${trip.origen} → ${trip.destino}'),
                  subtitle: Text(
                    'Asientos: ${request.seatsRequested} · Estado: ${request.status}',
                  ),
                ),
              );
            }),
            const Divider(height: 32),
          ],
          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text('No se encontraron viajes para ese destino.'),
            ),
          ...filtered.map(
            (trip) => _TripCard(trip: trip, onRequestJoin: _createRequest),
          ),
        ],
      ),
    );
  }

  Future<void> _createRequest(Viaje trip, int seats) async {
    if (_user == null) return;
    if (trip.cuposDisponibles < seats) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay suficientes cupos disponibles.')),
      );
      return;
    }
    final request = JoinRequest(
      requestId: DateTime.now().millisecondsSinceEpoch.toString(),
      viajeId: trip.id ?? 0,
      pasajeroEmail: _user!.email,
      seatsRequested: seats,
      status: 'Pendiente',
    );

    final updated = [..._requests, request];
    await _saveRequests(updated);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Solicitud enviada al conductor.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/Logo_H.png', height: 36),

        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TripHistoryScreen()),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),

          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.logout),

            onPressed: () async {
              final navigator = Navigator.of(context);

              await StorageService().clearCurrentUser();

              if (!mounted) return;

              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),

      body: _user?.role == 'conductor'
          ? _buildConductorTab()
          : _buildPasajeroTab(),
    );
  }
}

class _TripCard extends StatefulWidget {
  final Viaje trip;
  final void Function(Viaje trip, int seats) onRequestJoin;

  const _TripCard({super.key, required this.trip, required this.onRequestJoin});

  @override
  State<_TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<_TripCard> {
  int _selectedSeats = 1;

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;

    final dateLabel = trip.fecha.isNotEmpty ? trip.fecha : '-';
    final timeLabel = trip.horaSalida.isNotEmpty ? trip.horaSalida : '-';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${trip.origen} → ${trip.destino}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 8),

            Text('Salida: $dateLabel · $timeLabel'),

            const SizedBox(height: 4),

            Text(
              'Cupos disponibles: ${trip.cuposDisponibles} · Precio: \$ ${trip.precio.toStringAsFixed(2)}',
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Text('Asientos:'),

                const SizedBox(width: 12),

                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _selectedSeats > 1
                      ? () {
                          setState(() {
                            _selectedSeats--;
                          });
                        }
                      : null,
                ),

                Text('$_selectedSeats'),

                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _selectedSeats < trip.cuposDisponibles
                      ? () {
                          setState(() {
                            _selectedSeats++;
                          });
                        }
                      : null,
                ),

                const Spacer(),

                FilledButton(
                  onPressed: trip.cuposDisponibles > 0
                      ? () {
                          widget.onRequestJoin(trip, _selectedSeats);
                        }
                      : null,
                  child: const Text('Solicitar'),
                ),

                const SizedBox(width: 8),

                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ChatScreen(userEmail: trip.conductorEmail),
                      ),
                    );
                  },
                  child: const Text('Chat'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
