import 'package:flutter/material.dart';
import 'package:fluttertest/pages/group_info.dart';
import 'package:fluttertest/widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  final String username;
  final String groupId;
  final String groupName;
  final String fullName;
  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.fullName,
      required this.username})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        actions: [
          GestureDetector(
            onTap: () {
              nextScreen(
                  context,
                  GroupInfo(
                      groupId: widget.groupId,
                      groupName: widget.groupName,
                      fullName: widget.fullName,
                      username: widget.username));
            },
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.info),
            ),
          )
        ],
      ),
    );
  }
}
