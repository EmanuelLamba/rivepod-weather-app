// ignore_for_file: always_specify_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error_handling/app_exceptions/app_exception.dart';
import '../../core/error_handling/app_exceptions/error_types.dart';

// import '../../core/error_handling/snackbar_controller.dart';

final authRepositoryProvider =
    Provider<AuthRepository>((final ref) => AuthRepository());

class AuthRepository {
  AuthRepository();

  final FirebaseAuth _instance = FirebaseAuth.instance;

  Future<User> signInWithEmail(
    final String email,
    final String password,
  ) async {
    final userCredential = await _instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user != null) {
      return userCredential.user!;
    }
    throw AppException.getFirebaseException(
      noUserDataCode,
    );
  }

  Future<User> signUpWithEmail(
    final String email,
    final String password,
  ) async {
    final userCredential = await _instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user != null) {
      return userCredential.user!;
    }
    throw AppException.getFirebaseException(
      noUserDataCode,
    );
  }

  Future<void> signOut() async {
    await _instance.signOut();
  }

  Future<void> deleteUser() async {
    if (_instance.currentUser != null) {
      await _instance.currentUser!.delete();
    }
  }

  User? isLoggedIn() {
    return _instance.currentUser;
  }
}