import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatie/controller/auth_controller.dart';
import 'package:chatie/group/controller/group_controller.dart';
import 'package:chatie/models/group_model.dart';
import 'package:chatie/models/user_model.dart';
import '../commom/loader.dart';
import 'home_page.dart';

class GroupInfo extends ConsumerStatefulWidget {
  static const routeName = '/group-info';
  final String groupId;
  final String groupName;
  const GroupInfo({
    Key? key,
    required this.groupId,
    required this.groupName,
  }) : super(key: key);

  @override
  ConsumerState<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends ConsumerState<GroupInfo> {
  UserModel? user;
  
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
                ref
                    .read(groupControllerProvider)
                    .toggleJoinGroup(widget.groupId)
                    .whenComplete(() {
                  Navigator.pushReplacementNamed(context, HomePage.routeName);
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
                "Admin: ${user?.fullName}",
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
          membersList(),
        ],
      ),
    );
  }

  membersList() {
    return StreamBuilder<GroupModel>(
      stream: ref.watch(groupControllerProvider).getGroupsName(widget.groupId),
      builder: (context, AsyncSnapshot<GroupModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        if (snapshot.hasData) {
          if (snapshot.data!.members.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data?.members.length,
              itemBuilder: (context, index) {
                return StreamBuilder<UserModel>(
                    stream: ref
                        .watch(groupControllerProvider)
                        .getUserDataFromId(snapshot.data!.members[index]),
                    builder: (context, AsyncSnapshot<UserModel> nameSnapshot) {
                      if (nameSnapshot.data.toString() != "null") {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 5),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                nameSnapshot.data!.fullName
                                    .substring(0, 1)
                                    .toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            title: Text(
                              nameSnapshot.data!.fullName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "@${nameSnapshot.data!.username}",
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        );
                      }

                      return Container();
                    });
              },
            );
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
}
