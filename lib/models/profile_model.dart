// lib/models/profile_model.dart

class Profile {
  final String id;
  final String username;
  final String? avatarUrl;
  final String? name;

  Profile({
    required this.id,
    required this.username,
    this.avatarUrl,
    this.name,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      username: json['username'],
      avatarUrl: json['avatar_url'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar_url': avatarUrl,
      'name': name,
    };
  }
}
