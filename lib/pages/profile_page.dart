import 'package:flutter/material.dart';
import 'package:fluttertest/auth/login_page.dart';
import 'package:fluttertest/pages/home_page.dart';
import 'package:fluttertest/services/auth_service.dart';
import 'package:fluttertest/widgets/widgets.dart';

class ProfilePage extends StatelessWidget {
  String userName;
  String email;
  ProfilePage(this.userName, this.email, {super.key});

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      drawer: Drawer(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const Icon(
                Icons.account_circle,
                size: 150,
              ),
              const SizedBox(height: 15),
              Text(
                userName,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                email,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              const Divider(
                height: 2,
              ),
              ListTile(
                selected: true,
                onTap: () {},
                leading: const Icon(Icons.account_circle_outlined),
                title: const Text("Profile"),
              ),
              ListTile(
                onTap: () {
                  nextScreenReplace(context, const HomePage());
                },
                leading: const Icon(Icons.group),
                title: const Text("Groups"),
              ),
              ListTile(
                onTap: () async {
                  authService.signOut().whenComplete(
                      () => nextScreenReplace(context, const LoginPage()));
                },
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
              ),
            ],
          ),
        ),
      )),
      body: const Center(child: Text("Profile")),
    );
  }
}
