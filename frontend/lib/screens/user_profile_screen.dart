import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = StorageService().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de usuario'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Icon(
              Icons.account_circle,
              size: 100,
            ),

            const SizedBox(height: 20),

            Text(
              'Correo:',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            Text(user?.email ?? 'Sin correo'),

            const SizedBox(height: 20),

            Text(
              'Rol:',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            Text(user?.role ?? 'Sin rol'),
          ],
        ),
      ),
    );
  }
}