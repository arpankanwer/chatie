import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/auth/login_page.dart';
import 'package:fluttertest/helper/helper_function.dart';
import 'package:fluttertest/pages/profile_page.dart';
import 'package:fluttertest/pages/search_page.dart';
import 'package:fluttertest/services/auth_service.dart';
import 'package:fluttertest/services/database_service.dart';
import 'package:fluttertest/widgets/group_tile.dart';
import 'package:fluttertest/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  DatabaseService databaseService = DatabaseService();
  String userName = "";
  String email = "";
  Stream? groups;
  bool isLoading = false;
  TextEditingController groupName = TextEditingController();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserName().then((value) {
      setState(() {
        userName = value!;
      });
    });
    await HelperFunctions.getEmail().then((value) {
      setState(() {
        email = value!;
      });
    });
    await databaseService
        .getGroups(FirebaseAuth.instance.currentUser!.uid)
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        centerTitle: true,
        actions: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                  onPressed: () {
                    nextScreen(context, const SearchPage());
                  },
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
                "@$userName",
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
                onTap: () {
                  nextScreenReplace(context, ProfilePage(userName, email));
                },
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : groupList(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            addGroup(context);
          },
          child: const Icon(Icons.add)),
    );
  }

  groupList() {
    return StreamBuilder(
        stream: groups,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null) {
              if (snapshot.data['groups'].length != 0) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data['groups'].length,
                    itemBuilder: (content, index) {
                      int reverseIndex =
                          snapshot.data['groups'].length - index - 1;
                      return StreamBuilder(
                          stream: databaseService.getGroupNameFromId(
                              snapshot.data['groups'][reverseIndex]),
                          builder: (context, AsyncSnapshot nameSnapshot) {
                            if (nameSnapshot.hasData) {
                              isLoading = false;
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: nameSnapshot.data.docs.length,
                                  itemBuilder: (context, index1) {
                                    return GroupTile(
                                        groupId: snapshot.data['groups']
                                            [reverseIndex],
                                        groupName: nameSnapshot
                                            .data.docs[index1]['groupName'],
                                        username: snapshot.data['username'],
                                        fullName: snapshot.data['fullName']);
                                  });
                            }

                            isLoading = true;
                            return Container();
                          });
                    });
              }
              return noGroupList();
            }
            return noGroupList();
          }
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        });
  }

  noGroupList() {
    return const Center(
      child: Text("No Groups Added"),
    );
  }

  addGroup(BuildContext context) {
    showDialog(
        // barrierDismissible: false,
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
                      setState(() {
                        groupName.text = value;
                      });
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
                onPressed: () async {
                  if (groupName.text != "") {
                    databaseService.createGroup(
                        FirebaseAuth.instance.currentUser!.uid,
                        userName,
                        groupName.text);

                    Navigator.of(context).pop();
                    showSnackbar(
                        context, Colors.green, "Group created successfully.");
                  }
                },
                child: const Text("Create"),
              )
            ],
          );
        });
  }
}
