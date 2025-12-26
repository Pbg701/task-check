import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:offline_task_checkin_app/data/models/user_model.dart';
import '../../domain/models/user.dart';

class FirebaseService {
  final usersCol = FirebaseFirestore.instance.collection('users');
  final tasksCol = FirebaseFirestore.instance.collection('tasks');
  final checkinsCol = FirebaseFirestore.instance.collection('checkins');

  Future<void> createUser(UserModel user) async {
    await usersCol.doc(user.id).set(user.toMap());
  }

  Future<UserModel?> getUserById(String userId) async {
    final doc = await usersCol.doc(userId).get();

    if (!doc.exists) return null;

    final data = doc.data()!;
    return UserModel(
      id: userId,
      email: data['email'],
      displayName: data['displayName'],
      role: data['role'] ?? 'member',
    );
  }

  Future<List<User>> getAllUsers() async {
    final snap = await usersCol.get();
    return snap.docs
        .map((d) => User(
              id: d.id,
              email: d.data()['email'],
              role: d.data()['role'],
              displayName: d.data()['displayName'],
            ))
        .toList();
  }

  // --- Task CRUD ---
  Future<List<Map<String, dynamic>>> fetchRemoteTasks() async {
    final snap = await tasksCol.orderBy('dueDate').get();
    return snap.docs
        .map((d) => {
              ...d.data(),
              'id': d.id,
            })
        .toList();
  }

  Future<void> uploadTask(Map<String, dynamic> data) async {
    if (data['id'] != null && data['id'].toString().isNotEmpty) {
      await tasksCol.doc(data['id']).set(data, SetOptions(merge: true));
    } else {
      await tasksCol.add(data);
    }
  }

  // --- Checkin CRUD ---
  Future<List<Map<String, dynamic>>> fetchRemoteCheckins(String taskId) async {
    final snap = await checkinsCol.where('taskId', isEqualTo: taskId).get();
    return snap.docs
        .map((d) => {
              ...d.data(),
              'id': d.id,
            })
        .toList();
  }

  Future<void> uploadCheckin(Map<String, dynamic> data, String id) async {
    // Client always wins: overwrite always
    await checkinsCol.doc(id).set(data, SetOptions(merge: true));
  }
}
