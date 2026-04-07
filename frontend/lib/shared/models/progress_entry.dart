class ProgressEntry {
  const ProgressEntry({
    required this.id,
    required this.userId,
    required this.topicId,
    required this.topicName,
    required this.score,
    required this.updatedAt,
  });

  final int id;
  final int userId;
  final int topicId;
  final String topicName;
  final int score;
  final DateTime updatedAt;

  factory ProgressEntry.fromJson(Map<String, dynamic> json) {
    return ProgressEntry(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      topicId: json['topic_id'] as int,
      topicName: json['topic_name'] as String? ?? 'Tema',
      score: json['score'] as int,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
