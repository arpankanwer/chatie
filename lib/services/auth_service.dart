import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertest/helper/helper_function.dart';
import 'package:fluttertest/services/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future login(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future register(
      String fullName, String email, String username, String password) async {
    try {
      bool checkUser = await DatabaseService().checkUsername(username);
      if (checkUser == true) {
        return "Username Already Exists";
      } else {
        User user = (await firebaseAuth.createUserWithEmailAndPassword(
                email: email, password: password))
            .user!;

        await DatabaseService().savingData(user.uid, fullName, username, email);

        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      await firebaseAuth.signOut();

      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserNameSF("");
      await HelperFunctions.saveUserEmailSF("");
    } catch (e) {
      return null;
    }
  }
}
