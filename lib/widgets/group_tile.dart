import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/chat_page.dart';

class GroupTile extends ConsumerStatefulWidget {
  final String username;
  final String groupId;
  final String groupName;
  final String fullName;
  const GroupTile(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.fullName,
      required this.username})
      : super(key: key);

  @override
  ConsumerState<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends ConsumerState<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, ChatPage.routeName, arguments: {
        'groupId': widget.groupId,
        'groupName': widget.groupName,
      }),
      child: Container(
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
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Join the conversation as ${widget.fullName}",
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
