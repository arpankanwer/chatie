import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatie/group/controller/group_controller.dart';
import 'package:chatie/models/group_model.dart';

import '../widgets/widgets.dart';

class SearchPage extends ConsumerStatefulWidget {
  static const routeName = '/search-screen';

  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  bool userSearched = false;
  TextEditingController groupName = TextEditingController();
  Stream<List<GroupModel>>? groups;
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
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                    style: const TextStyle(color: Colors.black),
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
      return StreamBuilder<List<GroupModel>>(
          stream: groups,
          builder: (context, AsyncSnapshot<List<GroupModel>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: ref
                            .watch(groupControllerProvider)
                            .getNameFromUid(snapshot.data![index].admin),
                        builder: (context, nameSnapshot) {
                          if (nameSnapshot.hasData) {
                            isJoinedAlready = {snapshot.data![index].members}
                                .toString()
                                .contains(
                                    FirebaseAuth.instance.currentUser!.uid);

                            return ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Text(
                                    snapshot.data![index].groupName
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                title: Text(
                                  "${snapshot.data![index].groupName} (${snapshot.data![index].members.length})",
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
                                    await ref
                                        .read(groupControllerProvider)
                                        .toggleJoinGroup(
                                            snapshot.data![index].groupId)
                                        .then((value) {
                                      if (!{snapshot.data![index].members}
                                          .toString()
                                          .contains(FirebaseAuth
                                              .instance.currentUser!.uid)) {
                                        isJoinedAlready = !isJoinedAlready!;

                                        showSnackBar(context, Colors.green,
                                            "You Joined ${snapshot.data![index].groupName}");
                                      } else {
                                        isJoinedAlready = !isJoinedAlready!;

                                        showSnackBar(context, Colors.red,
                                            "You Left ${snapshot.data![index].groupName}");
                                      }
                                    });
                                  },
                                  child: isJoinedAlready!
                                      ? const Text("Joined")
                                      : const Text("Join"),
                                ));
                          }
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
