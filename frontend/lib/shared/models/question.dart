class Question {
  const Question({
    required this.id,
    required this.topicId,
    required this.type,
    required this.question,
    required this.options,
    required this.correct,
  });

  final int id;
  final int topicId;
  final String type;
  final String question;
  final List<dynamic> options;
  final dynamic correct;

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      topicId: json['topic_id'] as int,
      type: json['type'] as String,
      question: json['question'] as String,
      options: List<dynamic>.from(json['options'] as List<dynamic>),
      correct: json['correct'],
    );
  }
}
