import 'package:flutter/material.dart';

import '../../../shared/models/level.dart';
import '../../../shared/models/topic.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../progress/data/progress_repository.dart';
import '../../quiz/presentation/quiz_screen.dart';
import '../data/catalog_repository.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({
    super.key,
    required this.user,
    required this.level,
    required this.catalogRepository,
    required this.progressRepository,
  });

  final UserProfile user;
  final Level level;
  final CatalogRepository catalogRepository;
  final ProgressRepository progressRepository;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: level.name,
      child: FutureBuilder<List<Topic>>(
        future: catalogRepository.getTopics(level.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error cargando temas: ${snapshot.error}'),
            );
          }

          final topics = snapshot.data ?? [];

          return ListView.separated(
            itemCount: topics.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final topic = topics[index];
              return Card(
                child: ListTile(
                  title: Text(topic.name),
                  trailing: const Icon(Icons.play_arrow_rounded),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => QuizScreen(
                          user: user,
                          topic: topic,
                          catalogRepository: catalogRepository,
                          progressRepository: progressRepository,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
