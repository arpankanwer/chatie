import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatie/group/controller/group_controller.dart';
import 'package:chatie/models/group_model.dart';

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
    ref.read(authControllerProvider).getUserData().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Welcome, ${user?.username}", overflow: TextOverflow.fade),
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
                user?.email ?? "",
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
            addGroup(context, mediaQuery);
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
          if (snapshot.data!.groups.isNotEmpty) {
            return ListView.builder(
                // padding: const EdgeInsets.only(top: 10),
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
                });
          } else {
            return noGroupList();
          }
        });
  }

  noGroupList() {
    return const Center(
      child: Text("No Groups Added"),
    );
  }

  addGroup(BuildContext context, mediaQuery) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text(
              'Create new group',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            content: SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    onChanged: (value) {
                      groupName.text = value;
                    },
                    onEditingComplete: () {
                      if (groupName.text != "") {
                        ref
                            .read(groupControllerProvider)
                            .createGroup(context, groupName.text);
                        groupName.clear();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Create Group',
                      label: const Text("Create Group"),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: mediaQuery.height * 0.02,
                          horizontal: mediaQuery.width * 0.02),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
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
                    groupName.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text("Create"),
              )
            ],
          );
        });
  }
}
