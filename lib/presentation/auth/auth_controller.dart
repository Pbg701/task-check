import 'dart:developer';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

import '../../data/models/user_model.dart';
import '../../data/remote/firebase_service.dart';
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  // STATE

  final RxBool isLoading = false.obs;
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoggedIn = false.obs;
  final RxString authError = ''.obs;
  bool _isForceLoggingOut = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseService _service = FirebaseService();
  late Box<UserModel> _userBox;

  // INIT

  @override
  void onInit() {
    super.onInit();
    _userBox = Hive.box<UserModel>('userBox');

    _auth.idTokenChanges().listen((user) async {
      if (user == null && !_isForceLoggingOut) {
        log('Token expired / revoked');
        _isForceLoggingOut = true;
        await _handleTokenExpired();
      } else {
        firebaseUser.value = user;
      }
    });
  }

  Future<void> _handleTokenExpired() async {
    await _clearSession();
    Get.offAllNamed(AppRoutes.roleSelection);
    // allow future logins
    _isForceLoggingOut = false;
  }

  // CHECK SESSION ON APP LAUNCH

  Future<void> checkAuthOnLaunch() async {
    final fbUser = _auth.currentUser;

    // No Firebase session → try offline cache
    if (fbUser == null) {
      _loadOfflineUserOrLogout();
      return;
    }

    try {
      // Validate token
      await fbUser.getIdToken(true);
    } catch (_) {
      _loadOfflineUserOrLogout();
      return;
    }

    // Fetch Firestore profile
    final appUser = await _service.getUserById(fbUser.uid);

    if (appUser == null) {
      await _forceLogout();
      return;
    }

    // Save to Hive
    await _userBox.put('currentUser', appUser);

    firebaseUser.value = fbUser;
    currentUser.value = appUser;
    isLoggedIn.value = true;

    _navigateByRole(appUser.role);
  }

  Future<void> login(String email, String password, String role) async {
    isLoading.value = true;
    authError.value = '';

    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _handlePostLogin(cred.user!, email, role);
    } on FirebaseAuthException catch (e) {
      log('Auth error code: ${e.code}');

      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        try {
          final cred = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          await _handlePostLogin(cred.user!, email, role);
        } on FirebaseAuthException catch (e) {
          authError.value = e.message ?? 'Account creation failed';
        }
      } else if (e.code == 'wrong-password') {
        authError.value = 'Incorrect password';
      } else {
        authError.value = e.message ?? 'Login failed';
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handlePostLogin(
    User fbUser,
    String email,
    String role,
  ) async {
    firebaseUser.value = fbUser;

    UserModel? appUser = await _service.getUserById(fbUser.uid);

    if (appUser == null) {
      appUser = UserModel(
        id: fbUser.uid,
        email: fbUser.email ?? email,
        role: role, // 🔐
        displayName: email.split('@').first,
      );
      await _service.createUser(appUser);
    }

    await _userBox.put('currentUser', appUser);

    currentUser.value = appUser;
    isLoggedIn.value = true;

    _navigateByRole(appUser.role);
  }

  // -----------------------------
  // LOGOUT
  // -----------------------------
  Future<void> logout() async {
    await _auth.signOut();
    await _clearSession();
    Get.offAllNamed(AppRoutes.roleSelection);
  }

  // FORCE LOGOUT (TOKEN EXPIRED)

  Future<void> _forceLogout() async {
    await _auth.signOut();
    await _clearSession();
    Get.offAllNamed(AppRoutes.roleSelection);
  }

  // OFFLINE FALLBACK

  void _loadOfflineUserOrLogout() {
    final cachedUser = _userBox.get('currentUser');

    if (cachedUser != null) {
      _navigateByRole(cachedUser.role);
    } else {
      Get.offAllNamed(AppRoutes.roleSelection);
    }
  }

  // HELPERS

  Future<void> _clearSession() async {
    firebaseUser.value = null;
    currentUser.value = null;
    isLoggedIn.value = false;
    authError.value = '';
    await _userBox.clear();
  }

  // void _navigateByRole(String role) {
  //   if (role == 'admin') {
  //     Get.offAllNamed(AppRoutes.adminTaskForm);
  //   } else {
  //     Get.offAllNamed(AppRoutes.taskList);
  //   }
  // }
  void _navigateByRole(String role) {
    Get.offAllNamed(AppRoutes.taskList);
  }
}
