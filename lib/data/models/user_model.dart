class UserModel {
  final String uid;
  final String name;
  final String email;
  final String avatarUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.avatarUrl = '',
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'email': email,
    'avatarUrl': avatarUrl,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json['uid'] ?? '',
    name: json['name'] ?? 'Lit User',
    email: json['email'] ?? 'user@listenlit.com',
    avatarUrl: json['avatarUrl'] ?? '',
  );
}
