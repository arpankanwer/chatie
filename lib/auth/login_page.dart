import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertest/helper/helper_function.dart';
import 'package:fluttertest/pages/home_page.dart';
import 'package:fluttertest/services/auth_service.dart';
import 'package:fluttertest/services/database_service.dart';
import 'package:fluttertest/widgets/widgets.dart';

import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : SizedBox(
              height: mediaQuery.height,
              child: SingleChildScrollView(
                  child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.width * 0.1,
                    vertical: mediaQuery.height * 0.1),
                child: Form(
                  key: formKey,
                  child: AutofillGroup(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Chat App", style: TextStyle(fontSize: 40)),
                        SizedBox(height: mediaQuery.height * 0.02),
                        const Text("Login", style: TextStyle(fontSize: 20)),
                        SizedBox(height: mediaQuery.height * 0.02),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          autofillHints: const [AutofillHints.email],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Email',
                            label: Text("Email"),
                          ),
                          onFieldSubmitted: (value) {
                            setState(() {
                              emailController.text = value;
                            });
                          },
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Please enter a valid email";
                          },
                        ),
                        SizedBox(height: mediaQuery.height * 0.02),
                        TextFormField(
                          controller: passwordController,
                          autofillHints: const [AutofillHints.password],
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Password',
                            label: Text("Password"),
                          ),
                          onFieldSubmitted: (value) {
                            setState(() {
                              passwordController.text = value;
                            });
                            TextInput.finishAutofillContext();
                          },
                          validator: (value) {
                            if (value!.length < 6) {
                              return "Must be at least 6 characters";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: mediaQuery.height * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Flexible(
                              child: Text(
                                "Don't have an account yet ?",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            SizedBox(width: mediaQuery.width * 0.01),
                            GestureDetector(
                              onTap: () {
                                nextScreenReplace(
                                    context, const RegisterPage());
                              },
                              child: const Text(
                                "Register",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: mediaQuery.height * 0.02),
                        ElevatedButton(
                            onPressed: () {
                              login();
                            },
                            child: const Text("Login")),
                      ],
                    ),
                  ),
                ),
              )),
            ),
    );
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authService
          .login(emailController.text, passwordController.text)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot = await DatabaseService().getData(
              FirebaseAuth.instance.currentUser!.uid, emailController.text);

          HelperFunctions.saveUserLoggedInStatus(true);
          HelperFunctions.saveUserEmailSF(emailController.text);
          HelperFunctions.saveUserNameSF(snapshot.docs[0]['username']);

          nextScreenReplace(context, const HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }
}
