import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService().init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _darkMode = false;

  void toggleTheme(bool value) {
    setState(() {
      _darkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carpulia',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),

      themeMode:
          _darkMode ? ThemeMode.dark : ThemeMode.light,

      home: const SplashScreen(),
    );
  }
}