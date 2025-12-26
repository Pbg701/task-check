import '../../domain/repositories/user_repository.dart';
import '../../domain/models/user.dart';
import '../remote/firebase_service.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseService _firebase = FirebaseService();

  @override
  Future<User?> getCurrentUser() async {

    throw UnimplementedError('Use AuthController for current user in session.');
  }

  @override
  Future<User?> getUserById(String id) async {
    final userModel = await _firebase.getUserById(id);
    if (userModel == null) return null;
    return User(
      id: userModel.id,
      //name: userModel.name,
      email: userModel.email,
      role: userModel.role,

    );
  }

  @override
  Future<List<User>> getAllUsers() async {
    return await _firebase.getAllUsers();
  }

  @override
  Future<void> cacheUser(User user) async {

  }
}