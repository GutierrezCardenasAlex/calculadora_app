import 'package:flutter/material.dart';

import '../../../shared/models/app_config.dart';
import '../../../shared/models/user_profile.dart';
import '../auth/data/auth_repository.dart';
import '../auth/presentation/login_screen.dart';
import '../config/data/config_repository.dart';
import '../levels/data/catalog_repository.dart';
import '../levels/presentation/levels_screen.dart';
import '../progress/data/progress_repository.dart';

class StartupGate extends StatefulWidget {
  const StartupGate({
    super.key,
    required this.configRepository,
    required this.authRepository,
    required this.catalogRepository,
    required this.progressRepository,
  });

  final ConfigRepository configRepository;
  final AuthRepository authRepository;
  final CatalogRepository catalogRepository;
  final ProgressRepository progressRepository;

  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {
  AppConfig? _config;
  UserProfile? _user;
  String? _error;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final config = await widget.configRepository.fetchRemoteConfig();
      final user = widget.authRepository.getCachedUser();
      if (!mounted) return;
      setState(() {
        _config = config;
        _user = user;
      });
    } catch (_) {
      final cachedConfig = widget.configRepository.getCachedConfig();
      final cachedUser = widget.authRepository.getCachedUser();
      if (!mounted) return;
      if (cachedConfig != null) {
        setState(() {
          _config = cachedConfig;
          _user = cachedUser;
        });
      } else {
        setState(() {
          _error = 'No fue posible cargar la configuracion.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _StatusScreen(
        title: 'Sin conexion',
        message: _error!,
        actionLabel: 'Reintentar',
        onPressed: _bootstrap,
      );
    }

    if (_config == null) {
      return const _LoadingScreen();
    }

    if (_config!.maintenance) {
      return _StatusScreen(
        title: 'Mantenimiento',
        message: _config!.appMessage,
      );
    }

    if (_config!.forceUpdate) {
      return _StatusScreen(
        title: 'Actualizacion requerida',
        message: _config!.appMessage,
      );
    }

    if (_user == null) {
      return LoginScreen(
        authRepository: widget.authRepository,
        onLoggedIn: (user) {
          setState(() {
            _user = user;
          });
        },
      );
    }

    return LevelsScreen(
      user: _user!,
      catalogRepository: widget.catalogRepository,
      progressRepository: widget.progressRepository,
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Buscando actualizaciones...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusScreen extends StatelessWidget {
  const _StatusScreen({
    required this.title,
    required this.message,
    this.actionLabel,
    this.onPressed,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              if (actionLabel != null && onPressed != null) ...[
                const SizedBox(height: 20),
                FilledButton(onPressed: onPressed, child: Text(actionLabel!)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
