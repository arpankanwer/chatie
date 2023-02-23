import 'package:flutter/material.dart';
import 'package:fluttertest/auth/login_page.dart';
import 'package:fluttertest/helper/helper_function.dart';
import 'package:fluttertest/pages/home_page.dart';
import 'package:fluttertest/services/auth_service.dart';
import 'package:fluttertest/widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernammeController = TextEditingController();

  bool isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Register", style: TextStyle(fontSize: 40)),
                        SizedBox(height: mediaQuery.height * 0.02),
                        TextFormField(
                          controller: fullNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Full Name',
                            label: Text("Full Name"),
                          ),
                          onFieldSubmitted: (value) {
                            setState(() {
                              fullNameController.text = value;
                            });
                          },
                        ),
                        SizedBox(height: mediaQuery.height * 0.02),
                        TextFormField(
                          controller: usernammeController,
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
                            setState(() {
                              usernammeController.text = value;
                            });
                          },
                        ),
                        SizedBox(height: mediaQuery.height * 0.02),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
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
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Password',
                            label: Text("Password"),
                          ),
                          onFieldSubmitted: (value) {
                            setState(() {
                              passwordController.text = value;
                            });
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
                              onTap: () {
                                nextScreenReplace(context, const LoginPage());
                              },
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
                            onPressed: () {
                              register();
                            },
                            child: const Text("Register")),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      authService
          .register(fullNameController.text, emailController.text,
              usernammeController.text, passwordController.text)
          .then((value) {
        if (value == true) {
          HelperFunctions.saveUserLoggedInStatus(true);
          HelperFunctions.saveUserNameSF(usernammeController.text);
          HelperFunctions.saveUserEmailSF(emailController.text);

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
