class User {
  final int id;
  final String username;
  final String email;
  final String image;
  final String bio;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.image,
    required this.bio
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      image: json['profile_image_url'] ?? 'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
      bio: (json['bio'] as String?) ?? 'Brak opisu',
    );
  }
}