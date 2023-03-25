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
  bool isObsecure = true;
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
      body: SingleChildScrollView(
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
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        colors: [Colors.purple, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: const Text(
                      'Chatie',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: mediaQuery.height * 0.03),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    focusNode: emailFocusNode,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: mediaQuery.height * 0.02,
                          horizontal: mediaQuery.width * 0.01),
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
                    obscureText: isObsecure,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                      label: const Text("Password"),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: isObsecure
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isObsecure = !isObsecure;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: mediaQuery.height * 0.02,
                          horizontal: mediaQuery.width * 0.01),
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
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(width: mediaQuery.width * 0.01),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(
                            context, RegisterPage.routeName),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [
                                  Colors.blue,
                                  Colors.purpleAccent,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0.0, 1.0],
                              ).createShader(
                                  const Rect.fromLTRB(0, 0, 200, 70)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: mediaQuery.height * 0.03),
                  ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: mediaQuery.height * 0.02,
                          horizontal: mediaQuery.width * 0.15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
