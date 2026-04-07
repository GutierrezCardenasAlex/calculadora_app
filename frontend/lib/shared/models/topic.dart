class Topic {
  const Topic({required this.id, required this.name, required this.levelId});

  final int id;
  final String name;
  final int levelId;

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] as int,
      name: json['name'] as String,
      levelId: json['level_id'] as int,
    );
  }
}
