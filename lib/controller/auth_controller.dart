import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatie/repository/auth_repository.dart';

import '../models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository);
});

final FutureProvider<UserModel?> userDataProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});
  Future<UserModel?> getUserData() {
    return authRepository.getUserData();
  }

  void login(BuildContext context, String email, String password) {
    authRepository.login(context, email, password);
  }

  void register(BuildContext context, String fullName, String email,
      String username, String password) {
    authRepository.register(context, fullName, email, username, password);
  }

  void signOut(BuildContext context) {
    authRepository.signOut(context);
  }
}
