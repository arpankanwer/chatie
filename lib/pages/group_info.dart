import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/pages/home_page.dart';
import 'package:fluttertest/services/database_service.dart';
import 'package:fluttertest/widgets/widgets.dart';

class GroupInfo extends StatefulWidget {
  final String username;
  final String groupId;
  final String groupName;
  final String fullName;
  const GroupInfo(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.fullName,
      required this.username})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Group Info"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              icon: const Icon(Icons.login_outlined),
              onPressed: () {
                DatabaseService()
                    .toggleJoinGroup(
                        FirebaseAuth.instance.currentUser!.uid, widget.groupId)
                    .whenComplete(() {
                  nextScreenReplace(context, const HomePage());
                });
              },
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  widget.groupName.substring(0, 1).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
              title: Text(
                "Group: ${widget.groupName}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Admin: ${widget.fullName}",
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                )
              : membersList(),
        ],
      ),
    );
  }

  membersList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data['members'].length,
                itemBuilder: (context, index) {
                  return StreamBuilder(
                      stream: DatabaseService()
                          .getNameFromId(snapshot.data['members'][index]),
                      builder: (context, AsyncSnapshot nameSnapshot) {
                        if (nameSnapshot.hasData) {
                          isLoading = false;
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: nameSnapshot.data.docs.length,
                              itemBuilder: (context, nameIndex) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      child: Text(
                                        nameSnapshot
                                            .data.docs[nameIndex]['fullName']
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    title: Text(
                                      nameSnapshot.data.docs[nameIndex]
                                          ['fullName'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      "@${nameSnapshot.data.docs[nameIndex]['username']}",
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                );
                              });
                        }

                        isLoading = true;
                        return Container();
                      });
                },
              );
            }
            return noMemberList();
          }
          return noMemberList();
        }
        return Center(
          child:
              CircularProgressIndicator(color: Theme.of(context).primaryColor),
        );
      },
    );
  }

  noMemberList() {
    return const Center(
      child: Text("No Members"),
    );
  }

  getMembers() async {
    DatabaseService().getMembers(widget.groupId).then((value) {
      setState(() {
        members = value;
      });
    });
  }
}
