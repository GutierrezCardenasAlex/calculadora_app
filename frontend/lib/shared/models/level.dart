class Level {
  const Level({required this.id, required this.name, required this.grade});

  final int id;
  final String name;
  final int grade;

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'] as int,
      name: json['name'] as String,
      grade: json['grade'] as int,
    );
  }
}
