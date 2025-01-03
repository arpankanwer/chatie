import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../group/controller/group_controller.dart';
import '../pages/chat_page.dart';

class GroupTile extends ConsumerStatefulWidget {
  final String username;
  final String groupId;
  final String groupName;
  final String fullName;
  const GroupTile(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.fullName,
      required this.username});

  @override
  ConsumerState<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends ConsumerState<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Dismissible(
          key: UniqueKey(),
          confirmDismiss: (direction) {
            return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    content: const Text(
                        "Are you sure you want to leave this group?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text("No")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text("Yes")),
                    ],
                  );
                });
          },
          direction: DismissDirection.endToStart,
          background: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.centerRight,
              color: Colors.red,
              child: const Icon(Icons.delete)),
          onDismissed: (direction) {
            ref.read(groupControllerProvider).toggleJoinGroup(widget.groupId);
          },
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            child: GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, ChatPage.routeName, arguments: {
                'groupId': widget.groupId,
                'groupName': widget.groupName,
              }),
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
                  widget.groupName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Join the conversation as ${widget.fullName}",
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          ),
        ),
        Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.black, width: 0.2))))
      ],
    );
  }
}
