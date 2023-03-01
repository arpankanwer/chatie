import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/services/database_service.dart';
import 'package:fluttertest/widgets/widgets.dart';

import 'package:async/async.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isLoading = false;
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
                      userSearched = true;
                      if (value.isNotEmpty) {
                        groupName.text = value;
                        getGroups();
                      }
                    },
                    // controller: groupName,
                    decoration: const InputDecoration(
                      hintText: "Search Groups",
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.search))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : groupList(),
          ),
          if (!userSearched) const Text("Enter Group Name to Search !"),
        ],
      ),
    );
  }

  getGroups() async {
    if (groupName.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService().getGroupsByName(groupName.text).then((value) {
        setState(() {
          isLoading = false;
          // print(value);
          groups = value;
        });
      });
    }
  }

  groupList() {
    // return groups?.docs.length != null
    //     ? groups!.docs.isNotEmpty
    // ?

    if (groupName.text.isNotEmpty) {
      return StreamBuilder(
          stream: groups,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs != null) {
                // print("${(snapshot.data.docs[0]['members'].toString())}print");

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
                            isLoading = false;
                            isJoinedAlready = {
                              snapshot.data.docs[index]['members']
                            }.toString().contains(
                                FirebaseAuth.instance.currentUser!.uid);

                            // print("built" + index.toString());
                            // print(snapshot.data.docs.length);
                            // print(isJoinedAlready);
                            // print(snapshot.data.docs[index]['members']);
                            // print(FirebaseAuth.instance.currentUser!.uid);
                            // setState(() {

                            // });
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
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            snapshot.data.docs[index]
                                                ['groupId'])
                                        .then((value) {
                                      // print(isJoinedAlready.toString() +
                                      //     "this user");
                                      if (!{snapshot.data.docs[index]['members']}
                                          .toString()
                                          .contains(FirebaseAuth
                                              .instance.currentUser!.uid)) {
                                        // setState(() {
                                        isJoinedAlready = !isJoinedAlready!;
                                        // });
                                        showSnackbar(context, Colors.green,
                                            "You Joined ${snapshot.data.docs[index]['groupName']}");
                                      } else {
                                        // setState(() {
                                        isJoinedAlready = !isJoinedAlready!;
                                        // });
                                        showSnackbar(context, Colors.red,
                                            "You Left ${snapshot.data.docs[index]['groupName']}");
                                      }
                                    });
                                  },
                                  child: isJoinedAlready!
                                      ? const Text("Joined")
                                      : const Text("Join"),
                                ));
                          }
                          isLoading = true;
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
