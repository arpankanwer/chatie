import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertest/group/controller/group_controller.dart';
import 'package:fluttertest/models/group_model.dart';

import '../commom/loader.dart';
import '/controller/auth_controller.dart';
import '/models/user_model.dart';
import '/pages/profile_page.dart';
import '/widgets/group_tile.dart';

import 'search_page.dart';

class HomePage extends ConsumerStatefulWidget {
  static const routeName = '/home-page';

  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  UserModel? user;
  TextEditingController groupName = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(userDataProvider).whenData((value) => user = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${user?.username}"),
        centerTitle: true,
        actions: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, SearchPage.routeName),
                  icon: const Icon(Icons.search)))
        ],
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
                "@${user?.username}",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                user!.email,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              const Divider(
                height: 2,
              ),
              ListTile(
                onTap: () => Navigator.pushReplacementNamed(
                    context, ProfilePage.routeName),
                leading: const Icon(Icons.account_circle_outlined),
                title: const Text("Profile"),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.group),
                title: const Text("Groups"),
                selected: true,
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            addGroup(context);
          },
          child: const Icon(Icons.add)),
    );
  }

  groupList() {
    return StreamBuilder<UserModel>(
        stream: ref.watch(groupControllerProvider).getGroups(),
        builder: (context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          return snapshot.data!.groups.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.groups.length,
                  itemBuilder: (content, index) {
                    int reverseIndex = snapshot.data!.groups.length - index - 1;
                    return StreamBuilder<GroupModel>(
                        stream: ref
                            .watch(groupControllerProvider)
                            .getGroupsName(snapshot.data!.groups[reverseIndex]),
                        builder:
                            (context, AsyncSnapshot<GroupModel> nameSnapshot) {
                          if (nameSnapshot.data != null) {
                            return GroupTile(
                                groupId: snapshot.data!.groups[reverseIndex],
                                groupName: nameSnapshot.data!.groupName,
                                username: snapshot.data!.username,
                                fullName: snapshot.data!.fullName);
                          }
                          return Container();
                        });
                  })
              : noGroupList();
        });
  }

  noGroupList() {
    return const Center(
      child: Text("No Groups Added"),
    );
  }

  addGroup(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Create Group"),
            content: SizedBox(
              height: 100,
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (value) {
                      groupName.text = value;
                    },
                  )
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (groupName.text != "") {
                    ref
                        .read(groupControllerProvider)
                        .createGroup(context, groupName.text);
                  }
                },
                child: const Text("Create"),
              )
            ],
          );
        });
  }
}
