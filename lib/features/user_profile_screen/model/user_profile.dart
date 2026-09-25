class UserProfile {
  final String name;
  final String email;
  final String bio;
  final String imageUrl;

  const UserProfile({
    this.name = '',
    this.email = '',
    this.bio = '',
    this.imageUrl = '',
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'bio': bio,
    'imageUrl': imageUrl,
  };

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
    name: map['name'] as String? ?? '',
    email: map['email'] as String? ?? '',
    bio: map['bio'] as String? ?? '',
    imageUrl: map['imageUrl'] as String? ?? '',
  );
}
