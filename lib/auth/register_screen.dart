import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'login_screen.dart';

import '../controller/auth_controller.dart';

class RegisterPage extends ConsumerStatefulWidget {
  static const routeName = '/register-screen';

  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernammeController = TextEditingController();

  FocusNode fullNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode usernameFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    fullNameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    usernameFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: mediaQuery.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.width * 0.1,
                vertical: mediaQuery.height * 0.1),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Register", style: TextStyle(fontSize: 40)),
                  SizedBox(height: mediaQuery.height * 0.02),
                  TextFormField(
                    controller: fullNameController,
                    keyboardType: TextInputType.text,
                    focusNode: fullNameFocusNode,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Full Name',
                      label: Text("Full Name"),
                    ),
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(usernameFocusNode);
                      fullNameController.text = value;
                    },
                  ),
                  SizedBox(height: mediaQuery.height * 0.02),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: usernammeController,
                    focusNode: usernameFocusNode,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Username can't be empty";
                      } else if (value.contains(' ')) {
                        return 'Username cannot contains spaces';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Username',
                      label: Text("User Name"),
                    ),
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(emailFocusNode);
                      usernammeController.text = value;
                    },
                  ),
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
                      register();
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
                          "Have an account !",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(
                            context, LoginPage.routeName),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: mediaQuery.height * 0.02),
                  ElevatedButton(
                      onPressed: register, child: const Text("Register")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void register() {
    if (formKey.currentState!.validate()) {
      ref.read(authControllerProvider).register(
          context,
          fullNameController.text.trim(),
          emailController.text.trim(),
          usernammeController.text.trim(),
          passwordController.text);
    }
  }
}
