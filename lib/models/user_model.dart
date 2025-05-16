import 'dart:convert';

class UserModel {
  final String id;
  final String email;
  final String name;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
  });

    // Copy method for creating a modified instance
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());
  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

    @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.name == name &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        createdAt.hashCode;
  }
}
