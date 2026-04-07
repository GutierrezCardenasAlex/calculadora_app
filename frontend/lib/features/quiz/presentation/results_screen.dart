import 'package:flutter/material.dart';

import '../../../shared/widgets/app_scaffold.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.hits,
  });

  final int score;
  final int totalQuestions;
  final int hits;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Resultados',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Puntaje: $score%',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text('Respuestas correctas: $hits de $totalQuestions'),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
