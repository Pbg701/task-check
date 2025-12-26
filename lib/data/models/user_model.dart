import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 2)
class UserModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String email;
  @HiveField(2)
  String? displayName;
  @HiveField(3)
  String role;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.displayName,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'],
    email: map['email'],
    displayName: map['displayName'],
    role: map['role'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'email': email,
    'displayName': displayName,
    'role': role,
  };
}

