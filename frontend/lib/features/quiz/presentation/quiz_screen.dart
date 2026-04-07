import 'package:flutter/material.dart';

import '../../../shared/models/question.dart';
import '../../../shared/models/topic.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../levels/data/catalog_repository.dart';
import '../../progress/data/progress_repository.dart';
import 'results_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.user,
    required this.topic,
    required this.catalogRepository,
    required this.progressRepository,
  });

  final UserProfile user;
  final Topic topic;
  final CatalogRepository catalogRepository;
  final ProgressRepository progressRepository;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _index = 0;
  int _hits = 0;
  dynamic _selectedOption;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: widget.topic.name,
      child: FutureBuilder<List<Question>>(
        future: widget.catalogRepository.getQuestions(widget.topic.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error cargando preguntas: ${snapshot.error}'),
            );
          }

          final questions = snapshot.data ?? [];
          if (questions.isEmpty) {
            return const Center(child: Text('No hay preguntas disponibles.'));
          }

          final question = questions[_index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Pregunta ${_index + 1} de ${questions.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              Text(
                question.question,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              Expanded(child: _buildDynamicQuestion(question)),
              FilledButton(
                onPressed: _selectedOption == null
                    ? null
                    : () => _submitAnswer(context, questions, question),
                child: const Text('Continuar'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDynamicQuestion(Question question) {
    switch (question.type) {
      case 'multiple_choice':
      default:
        return ListView.separated(
          itemCount: question.options.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final option = question.options[index];
            final isSelected = _selectedOption == option;
            return ChoiceChip(
              label: SizedBox(
                width: double.infinity,
                child: Text(option.toString(), textAlign: TextAlign.center),
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedOption = option;
                });
              },
            );
          },
        );
    }
  }

  Future<void> _submitAnswer(
    BuildContext context,
    List<Question> questions,
    Question question,
  ) async {
    if (_selectedOption == question.correct) {
      _hits += 1;
    }

    if (_index == questions.length - 1) {
      final score = ((_hits / questions.length) * 100).round();
      final navigator = Navigator.of(context);
      await widget.progressRepository.saveProgress(
        userId: widget.user.id,
        topicId: widget.topic.id,
        score: score,
      );

      if (!mounted) return;
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultsScreen(
            score: score,
            totalQuestions: questions.length,
            hits: _hits,
          ),
        ),
      );
      return;
    }

    setState(() {
      _index += 1;
      _selectedOption = null;
    });
  }
}
