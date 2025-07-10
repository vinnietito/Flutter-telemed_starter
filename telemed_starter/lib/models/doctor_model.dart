class Doctor {
  final String name;
  final String email;

  Doctor({
    required this.name,
    required this.email,
  });

  factory Doctor.fromMap(Map<String, dynamic> data) {
    return Doctor(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }
}
