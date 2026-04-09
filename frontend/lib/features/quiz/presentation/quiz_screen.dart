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
  bool? _lastAnswerCorrect;

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
              LinearProgressIndicator(
                value: (_index + 1) / questions.length,
                minHeight: 12,
                borderRadius: BorderRadius.circular(999),
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                'Pregunta ${_index + 1} de ${questions.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.15, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Container(
                  key: ValueKey(question.id),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    question.question,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(child: _buildDynamicQuestion(question)),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _lastAnswerCorrect == null
                    ? const SizedBox(height: 24)
                    : Container(
                        key: ValueKey(_lastAnswerCorrect),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _lastAnswerCorrect!
                              ? const Color(0xFFD9F7BE)
                              : const Color(0xFFFFD6D6),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          _lastAnswerCorrect!
                              ? 'Muy bien!'
                              : 'Buen intento, sigue asi!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
              ),
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
            return AnimatedScale(
              scale: isSelected ? 1.03 : 1,
              duration: const Duration(milliseconds: 180),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  setState(() {
                    _selectedOption = option;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFFD166)
                        : Colors.white.withValues(alpha: 0.82),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFF28C28)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    option.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
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
    final wasCorrect = _selectedOption == question.correct;
    if (wasCorrect) {
      _hits += 1;
    }

    setState(() {
      _lastAnswerCorrect = wasCorrect;
    });

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
      _lastAnswerCorrect = null;
    });
  }
}
