import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertest/group/controller/group_controller.dart';
import 'package:fluttertest/repository/database_service.dart';
import 'package:fluttertest/widgets/widgets.dart';

class SearchPage extends ConsumerStatefulWidget {
  static const routeName = '/search-screen';

  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  bool userSearched = false;
  TextEditingController groupName = TextEditingController();
  Stream? groups;
  bool? isJoinedAlready;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Search"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          groupName.text = value;
                          userSearched = true;
                        });
                        groups = ref
                            .watch(groupControllerProvider)
                            .getGroupsByName(groupName.text);
                      } else {
                        setState(() {
                          userSearched = false;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "Search Groups",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Icon(
                  Icons.search,
                  color: Colors.white,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: groupList(),
          ),
          if (!userSearched) const Text("Enter Group Name to Search !"),
        ],
      ),
    );
  }

  groupList() {
    if (groupName.text.isNotEmpty) {
      return StreamBuilder(
          stream: groups,
          builder: (context, AsyncSnapshot snapshot) {
            ;
            if (snapshot.hasData) {
              if (snapshot.data.docs != null) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: DatabaseService()
                            .getNameFromUid(snapshot.data.docs[index]['admin']),
                        builder: (context, nameSnapshot) {
                          // print(snapshot.data.docs[index]['groupName']
                          //     .toString() +
                          // isJoinedAlready.toString());
                          if (nameSnapshot.hasData) {
                            isJoinedAlready = {
                              snapshot.data.docs[index]['members']
                            }.toString().contains(
                                FirebaseAuth.instance.currentUser!.uid);

                            return ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Text(
                                    snapshot.data.docs[index]['groupName']
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                title: Text(
                                  snapshot.data.docs[index]['groupName'] +
                                      " (" +
                                      snapshot
                                          .data.docs[index]['members'].length
                                          .toString() +
                                      ")",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "Admin: ${nameSnapshot.data}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                                trailing: ElevatedButton(
                                  style: isJoinedAlready!
                                      ? ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.green))
                                      : ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Theme.of(context)
                                                      .primaryColor)),
                                  onPressed: () async {
                                    await DatabaseService()
                                        .toggleJoinGroup(
                                            snapshot.data.docs[index]
                                                ['groupId'])
                                        .then((value) {
                                      // print(isJoinedAlready.toString() +
                                      //     "this user");
                                      if (!{
                                        snapshot.data.docs[index]['members']
                                      }.toString().contains(FirebaseAuth
                                          .instance.currentUser!.uid)) {
                                        // setState(() {
                                        isJoinedAlready = !isJoinedAlready!;
                                        // });
                                        showSnackBar(context, Colors.green,
                                            "You Joined ${snapshot.data.docs[index]['groupName']}");
                                      } else {
                                        // setState(() {
                                        isJoinedAlready = !isJoinedAlready!;
                                        // });
                                        showSnackBar(context, Colors.red,
                                            "You Left ${snapshot.data.docs[index]['groupName']}");
                                      }
                                    });
                                  },
                                  child: isJoinedAlready!
                                      ? const Text("Joined")
                                      : const Text("Join"),
                                ));
                          }
                          // isLoading = true;
                          return Container();
                        });
                  },
                );
              }
            }
            return Container();
          });
      //     : const Text("No groups found")
      // : Container();
    }
  }
}
