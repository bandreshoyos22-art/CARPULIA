import 'package:flutter/material.dart';
import '../models/calificacion.dart';
import '../models/viaje.dart';
import '../services/storage_service.dart';

class CalificacionScreen extends StatefulWidget {
  final Viaje viaje;
  final bool esConductor;

  const CalificacionScreen({
    super.key,
    required this.viaje,
    required this.esConductor,
  });

  @override
  State<CalificacionScreen> createState() => _CalificacionScreenState();
}

class _CalificacionScreenState extends State<CalificacionScreen> {
  int _score = 5;
  final _commentController = TextEditingController();
  bool _guardando = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    setState(() => _guardando = true);

    final user = StorageService().currentUser;
    final calificacion = Calificacion(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      viajeId: widget.viaje.id?.toString() ?? '',
      conductorEmail: widget.viaje.conductorEmail,
      pasajeroEmail: widget.esConductor ? user?.email ?? '' : user?.email ?? '',
      score: _score,
      comment: _commentController.text,
      createdAt: DateTime.now(),
    );

    await StorageService().saveCalificacion(calificacion);

    setState(() => _guardando = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calificación enviada correctamente')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final titulo = widget.esConductor
        ? 'Calificar pasajero'
        : 'Calificar conductor';
    final nombre = widget.esConductor ? 'el pasajero' : 'el conductor';

    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Califica a $nombre',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${widget.viaje.origen} → ${widget.viaje.destino}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Puntuación:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _score ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 40,
                  ),
                  onPressed: () {
                    setState(() {
                      _score = index + 1;
                    });
                  },
                );
              }),
            ),

            const SizedBox(height: 20),

            const Text(
              'Comentario (opcional):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Escribe un comentario...',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _guardando ? null : _guardar,
                child: _guardando
                    ? const CircularProgressIndicator()
                    : Text(titulo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
