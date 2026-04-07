import 'package:flutter/material.dart';

import '../../../shared/models/progress_entry.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../data/progress_repository.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({
    super.key,
    required this.user,
    required this.progressRepository,
  });

  final UserProfile user;
  final ProgressRepository progressRepository;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Mi progreso',
      child: FutureBuilder<List<ProgressEntry>>(
        future: progressRepository.getProgress(user.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error cargando progreso: ${snapshot.error}'),
            );
          }

          final entries = snapshot.data ?? [];
          if (entries.isEmpty) {
            return const Center(child: Text('Aun no hay puntajes guardados.'));
          }

          return ListView.separated(
            itemCount: entries.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = entries[index];
              return Card(
                child: ListTile(
                  title: Text(item.topicName),
                  subtitle: Text('Actualizado: ${item.updatedAt.toLocal()}'),
                  trailing: Text(
                    '${item.score}%',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
