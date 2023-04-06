import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertest/auth/login_screen.dart';
import 'package:fluttertest/models/user_model.dart';
import 'package:fluttertest/pages/home_page.dart';

import '../widgets/widgets.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    firebaseAuth: FirebaseAuth.instance,
    firebaseFirestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthRepository({required this.firebaseAuth, required this.firebaseFirestore});

  void login(BuildContext context, String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, Colors.red, e.message);
    }
  }

  void register(BuildContext context, String fullName, String email,
      String username, String password) async {
    try {
      var result = await firebaseFirestore
          .collection('users')
          .where("username", isEqualTo: username)
          .get();

      bool checkUser = result.docs.isNotEmpty;
      if (checkUser) {
        if (context.mounted) {
          showSnackBar(context, Colors.red, "Username Already Exists");
        }
      } else {
        User user = (await firebaseAuth.createUserWithEmailAndPassword(
                email: email, password: password))
            .user!;

        var userModel = UserModel(
            uid: user.uid,
            fullName: fullName,
            email: email,
            profilePic: "",
            username: username,
            password: password,
            isOnline: true,
            groups: []);

        await firebaseFirestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, HomePage.routeName);
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, Colors.red, e.message);
    }
  }

  void signOut(BuildContext context) async {
    firebaseAuth.signOut();
    try {
      await firebaseAuth.signOut();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
        showSnackBar(context, Colors.green, "Logged Out");
      }
    } catch (e) {
      showSnackBar(context, Colors.red, e);
    }
  }

  Future<UserModel?> getUserData() async {
    UserModel? user;

    var userData = await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser?.uid)
        .get();
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }

    return user;
  }
}
