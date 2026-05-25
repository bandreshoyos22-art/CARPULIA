import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final user = StorageService().currentUser;
    _nameController.text = user?.name ?? '';
    _phoneController.text = user?.phone ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = StorageService().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de usuario'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () async {
              if (_isEditing) {
                if (user != null) {
                  final updatedUser = AppUser(
                    name: _nameController.text,
                    email: user.email,
                    password: user.password,
                    role: user.role,
                    phone: _phoneController.text,
                  );
                  await StorageService().saveCurrentUser(updatedUser);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Perfil guardado')),
                );
              }
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 55,
                    child: Icon(Icons.account_circle, size: 80),
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Text('Nombre:', style: Theme.of(context).textTheme.titleMedium),
            _isEditing
                ? TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Ingresa tu nombre',
                      border: OutlineInputBorder(),
                    ),
                  )
                : Text(user?.name ?? 'Sin nombre'),

            const SizedBox(height: 20),

            Text('Teléfono:', style: Theme.of(context).textTheme.titleMedium),
            _isEditing
                ? TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Ingresa tu teléfono',
                      border: OutlineInputBorder(),
                    ),
                  )
                : Text(
                    user?.phone.isEmpty == true
                        ? 'Sin teléfono'
                        : user?.phone ?? 'Sin teléfono',
                  ),

            const SizedBox(height: 20),

            Text('Correo:', style: Theme.of(context).textTheme.titleMedium),
            Text(user?.email ?? 'Sin correo'),

            const SizedBox(height: 20),

            Text('Rol:', style: Theme.of(context).textTheme.titleMedium),
            Text(user?.role ?? 'Sin rol'),
          ],
        ),
      ),
    );
  }
}
