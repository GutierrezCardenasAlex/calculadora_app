import 'package:flutter/material.dart';

import '../../core/config/app_environment.dart';
import '../../core/network/api_client.dart';
import '../auth/data/auth_repository.dart';
import '../config/data/config_repository.dart';
import '../levels/data/catalog_repository.dart';
import '../progress/data/progress_repository.dart';
import 'startup_gate.dart';

class MathApp extends StatelessWidget {
  const MathApp({super.key, required this.environment});

  final AppEnvironment environment;

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient(baseUrl: environment.apiBaseUrl);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Matemagica',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF28C28),
          primary: const Color(0xFFF28C28),
          secondary: const Color(0xFF2A9D8F),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFBF0),
        useMaterial3: true,
      ),
      home: StartupGate(
        configRepository: ConfigRepository(apiClient),
        authRepository: AuthRepository(apiClient),
        catalogRepository: CatalogRepository(apiClient),
        progressRepository: ProgressRepository(apiClient),
      ),
    );
  }
}
