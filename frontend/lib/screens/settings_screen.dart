import 'package:flutter/material.dart';

import '../main.dart';
import '../services/storage_service.dart';

import 'login_screen.dart';
import 'user_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),

      body: ListView(
        children: [
          const SizedBox(height: 12),

          ListTile(
            leading: const Icon(Icons.person),

            title: const Text('Ver información de usuario'),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserProfileScreen()),
              );
            },
          ),
          const Divider(),

          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),

            title: const Text('Modo oscuro'),

            value: _darkMode,

            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });

              MyApp.of(context)?.toggleTheme(value);
            },
          ),

          SwitchListTile(
            secondary: const Icon(Icons.notifications),

            title: const Text('Notificaciones'),

            value: _notifications,

            onChanged: (value) {
              setState(() {
                _notifications = value;
              });
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.lock),

            title: const Text('Cambiar contraseña'),

            onTap: () {
              showDialog(
                context: context,

                builder: (context) {
                  return AlertDialog(
                    title: const Text('Cambiar contraseña'),

                    content: const Text(
                      'Esta función estará disponible próximamente.',
                    ),

                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        child: const Text('Cerrar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.info),

            title: const Text('Acerca de'),

            subtitle: const Text('UniRide v1.0'),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),

            title: const Text(
              'Cerrar sesión',

              style: TextStyle(color: Colors.red),
            ),

            onTap: () async {
              await StorageService().clearCurrentUser();

              if (!mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
