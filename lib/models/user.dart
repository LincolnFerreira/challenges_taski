class User {
  final String email;
  final String name;
  final String? uuid;

  User({required this.email, required this.name, required this.uuid});

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'uuid': uuid,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json['email'],
        name: json['name'],
        uuid: json['uuid'],
      );
}
