import '../models/user.dart';

abstract class UserRepository {
  Future<User?> getCurrentUser();
  Future<User?> getUserById(String id);
  Future<List<User>> getAllUsers();
  Future<void> cacheUser(User user);
}
