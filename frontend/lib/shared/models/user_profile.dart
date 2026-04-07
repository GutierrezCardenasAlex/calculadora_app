class UserProfile {
  const UserProfile({required this.id, required this.name});

  final int id;
  final String name;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(id: json['id'] as int, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
