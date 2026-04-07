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
              Text(
                'Hola, ${user.name}',
                style: Theme.of(context).textTheme.headlineSmall,
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
                    return Card(
                      child: ListTile(
                        title: Text(level.name),
                        subtitle: Text('Grado ${level.grade}'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => TopicsScreen(
                                user: user,
                                level: level,
                                catalogRepository: catalogRepository,
                                progressRepository: progressRepository,
                              ),
                            ),
                          );
                        },
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
