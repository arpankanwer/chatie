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
  bool isObsecure = true;
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
      body: SingleChildScrollView(
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
                    'Register',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: mediaQuery.height * 0.03),
                TextFormField(
                  controller: fullNameController,
                  keyboardType: TextInputType.text,
                  focusNode: fullNameFocusNode,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Enter your Full Name',
                    label: const Text("Full Name"),
                    prefixIcon: const Icon(Icons.person),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: mediaQuery.height * 0.02,
                        horizontal: mediaQuery.width * 0.01),
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
                  decoration: InputDecoration(
                    hintText: 'Enter your Username',
                    label: const Text("User Name"),
                    prefixIcon: const Icon(Icons.account_box),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: mediaQuery.height * 0.02,
                        horizontal: mediaQuery.width * 0.01),
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
                  decoration: InputDecoration(
                    hintText: 'Enter your Email',
                    label: const Text("Email"),
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
                    hintText: 'Enter your Password',
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
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                          context, LoginPage.routeName),
                      child: Text(
                        'Login',
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
                            ).createShader(const Rect.fromLTRB(0, 0, 200, 70)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: mediaQuery.height * 0.02),
                ElevatedButton(
                  onPressed: register,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: mediaQuery.height * 0.02,
                        horizontal: mediaQuery.width * 0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
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
