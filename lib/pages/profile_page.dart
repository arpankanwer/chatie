import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertest/auth/login_screen.dart';
import 'package:fluttertest/controller/auth_controller.dart';
import 'package:fluttertest/pages/home_page.dart';

class ProfilePage extends ConsumerWidget {
  static const routeName = '/profile-screen';

  const ProfilePage({super.key});

  // String userName;
  // String email;
  // ProfilePage(this.userName, this.email, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              // Text(
              //   userName,
              //   textAlign: TextAlign.center,
              // ),
              const SizedBox(height: 2),
              // Text(
              //   email,
              //   textAlign: TextAlign.center,
              // ),
              // const SizedBox(height: 15),
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
                onTap: () =>
                    Navigator.pushReplacementNamed(context, HomePage.routeName),
                leading: const Icon(Icons.group),
                title: const Text("Groups"),
              ),
              ListTile(
                onTap: () => ref.read(authControllerProvider).signOut(context),
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
