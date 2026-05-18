import 'dart:math';

import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/storage_service.dart';
import 'verify_code_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String _selectedRole = 'pasajero';
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool _isInstitutionalEmail(String email) {
  return true;
}

  int _generateCode() {
    return Random().nextInt(900000) + 100000;
  }

  Future<void> _register() async {
    setState(() {
      _error = null;
      _loading = true;
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      setState(() {
        _error = 'Todos los campos son obligatorios.';
        _loading = false;
      });
      return;
    }
    if (password.length < 6) {
      setState(() {
        _error = 'La contraseña debe tener al menos 6 caracteres.';
        _loading = false;
      });
      return;
    }
    if (password != confirm) {
      setState(() {
        _error = 'Las contraseñas no coinciden.';
        _loading = false;
      });
      return;
    }
    if (!_isInstitutionalEmail(email)) {
      setState(() {
        _error = 'Usa un correo institucional de Carpulia.';
        _loading = false;
      });
      return;
    }

    final users = await StorageService().loadUsers();
    final alreadyExists = users.any((user) => user.email == email);
    if (alreadyExists) {
      setState(() {
        _error = 'Ya existe una cuenta con ese correo.';
        _loading = false;
      });
      return;
    }

    final code = _generateCode();
    final newUser = AppUser(
      name: name,
      email: email,
      password: password,
      role: _selectedRole,
    );

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            VerifyCodeScreen(user: newUser, verificationCode: code.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carpulia - Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Image.asset('assets/images/Logo_V.png', height: 120),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre completo'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo institucional',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedRole,
              decoration: const InputDecoration(labelText: 'Registrarse como'),
              items: const [
                DropdownMenuItem(value: 'pasajero', child: Text('Pasajero')),
                DropdownMenuItem(value: 'conductor', child: Text('Conductor')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedRole = value);
                }
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar contraseña',
              ),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _loading ? null : _register,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Continuar con verificación'),
            ),
          ],
        ),
      ),
    );
  }
}
