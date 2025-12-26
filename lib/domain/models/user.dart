import '../../data/models/user_model.dart';

class User {
  final String id;
  final String email;
  final String? displayName;
  final String role; // 'Admin' or 'Member'

  User({
    required this.id,
    required this.email,
    required this.role,
    this.displayName,
  });

  factory User.fromModel(UserModel m) => User(
    id: m.id,
    email: m.email,
    displayName: m.displayName,
    role: m.role,
  );

  UserModel toModel() => UserModel(
    id: id,
    email: email,
    displayName: displayName,
    role: role,
  );
}

