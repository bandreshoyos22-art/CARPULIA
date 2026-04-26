import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/storage_service.dart';
import 'home_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final AppUser user;
  final String verificationCode;

  const VerifyCodeScreen({super.key, required this.user, required this.verificationCode});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final _codeController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final input = _codeController.text.trim();
    if (input != widget.verificationCode) {
      setState(() {
        _error = 'Código de verificación incorrecto.';
        _loading = false;
      });
      return;
    }

    final users = await StorageService().loadUsers();
    final updatedUsers = [...users, widget.user];
    await StorageService().saveUsers(updatedUsers);
    await StorageService().saveCurrentUser(widget.user);

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verificación del correo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text(
              'Hemos enviado un código de verificación a tu correo institucional. Usa el código para confirmar que eres alumno o conductor.',
            ),
            const SizedBox(height: 16),
            Text('Código de ejemplo: ${widget.verificationCode}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Código de verificación'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _loading ? null : _verify,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Verificar'),
            ),
          ],
        ),
      ),
    );
  }
}
