import 'package:flutter/material.dart';

import '../../../shared/models/level.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../progress/data/progress_repository.dart';
import '../../progress/presentation/progress_screen.dart';
import '../data/catalog_repository.dart';
import 'topics_screen.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({
    super.key,
    required this.user,
    required this.catalogRepository,
    required this.progressRepository,
  });

  final UserProfile user;
  final CatalogRepository catalogRepository;
  final ProgressRepository progressRepository;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Niveles',
      child: FutureBuilder<List<Level>>(
        future: catalogRepository.getLevels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error cargando niveles: ${snapshot.error}'),
            );
          }

          final levels = snapshot.data ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hola, ${user.name}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 6),
                    const Text('Elige un nivel y avanza paso a paso.'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProgressScreen(
                        user: user,
                        progressRepository: progressRepository,
                      ),
                    ),
                  );
                },
                child: const Text('Ver progreso'),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: levels.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final level = levels[index];
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: Duration(milliseconds: 260 + (index * 120)),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value.clamp(0, 1),
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Card(
                        color: index.isEven
                            ? const Color(0xFFFFF9E8)
                            : const Color(0xFFEAF8FF),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFFF28C28),
                            child: Text(
                              '${level.grade}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(level.name),
                          subtitle: Text('Grado ${level.grade}'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (
                                      pageContext,
                                      animation,
                                      secondaryAnimation,
                                    ) => FadeTransition(
                                      opacity: animation,
                                      child: TopicsScreen(
                                        user: user,
                                        level: level,
                                        catalogRepository: catalogRepository,
                                        progressRepository: progressRepository,
                                      ),
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
