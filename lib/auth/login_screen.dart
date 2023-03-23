import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';

import 'register_screen.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox(
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
                    focusNode: emailFocusNode,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Email',
                      label: Text("Email"),
                    ),
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(passwordFocusNode);
                      emailController.text = value;
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
                    focusNode: passwordFocusNode,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Password',
                      label: Text("Password"),
                    ),
                    onFieldSubmitted: (value) {
                      TextInput.finishAutofillContext();

                      FocusScope.of(context).unfocus();
                      passwordController.text = value;
                      login();
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
                        onTap: () => Navigator.pushReplacementNamed(
                            context, RegisterPage.routeName),
                        child: const Text(
                          "Register",
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: mediaQuery.height * 0.02),
                  ElevatedButton(onPressed: login, child: const Text("Login")),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  void login() {
    if (formKey.currentState!.validate()) {
      ref
          .read(authControllerProvider)
          .login(context, emailController.text, passwordController.text);
    }
  }
}
