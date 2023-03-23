import 'package:flutter/material.dart';
import 'package:fluttertest/pages/chat_page.dart';
import 'package:fluttertest/widgets/widgets.dart';

class GroupTile extends StatefulWidget {
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
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, ChatPage.routeName)
      // nextScreen(
      //     context,
      //     ChatPage(
      //       groupId: widget.groupId,
      //       groupName: widget.groupName,
      //       username: widget.username,
      //       fullName: widget.fullName,
      //     ));
      ,
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
