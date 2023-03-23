import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertest/pages/group_info.dart';
import 'package:fluttertest/repository/database_service.dart';

import '../widgets/message_tile.dart';

class ChatPage extends ConsumerStatefulWidget {
  static const routeName = '/chat-screen';

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
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  Stream? chats;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // initMessages();
  }

  // initMessages() {
  //   DatabaseService().getMessages(widget.groupId).then((val) {
  //     setState(() {
  //       chats = val;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, GroupInfo.routeName),
            // nextScreen(
            //     context,
            //     GroupInfo(
            //         groupId: widget.groupId,
            //         groupName: widget.groupName,
            //         fullName: widget.fullName,
            //         username: widget.username));

            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.info),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          messages(),
          Container(
            color: Colors.grey[700],
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Flexible(
                    child: TextFormField(
                  controller: messageController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Message',
                    label: Text("Message"),
                  ),
                  onFieldSubmitted: (value) {
                    setState(() {
                      messageController.text = value;
                    });
                  },
                )),
                ElevatedButton(
                    onPressed: () {
                      sendMessage();
                    },
                    child: const Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      // print(widget.username);
      Map<String, dynamic> message = {
        "message": messageController.text,
        "sender": widget.username,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, message);
      setState(() {
        messageController.clear();
      });
    }
  }

  Widget messages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  // return Text(snapshot.data.docs[index]['message'].toString());
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentByMe: widget.username ==
                          snapshot.data.docs[index]['sender']);
                },
              )
            : Container();
      },
    );
  }
}
