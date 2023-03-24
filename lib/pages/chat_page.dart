import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertest/group/controller/group_controller.dart';
import 'package:fluttertest/models/chat_model.dart';
import 'package:fluttertest/models/user_model.dart';
import 'package:fluttertest/pages/group_info.dart';
import 'package:fluttertest/repository/database_service.dart';

import '../controller/auth_controller.dart';
import '../widgets/message_tile.dart';

class ChatPage extends ConsumerStatefulWidget {
  static const routeName = '/chat-screen';

  final String groupId;
  final String groupName;
  const ChatPage({
    Key? key,
    required this.groupId,
    required this.groupName,
  }) : super(key: key);

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  UserModel? user;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(userDataProvider).whenData((value) => user = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        actions: [
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, GroupInfo.routeName, arguments: {
              "groupId": widget.groupId,
              "groupName": widget.groupName,
            }),
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
      Map<String, dynamic> message = {
        "message": messageController.text,
        "sender": user?.username,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      ref.read(groupControllerProvider).sendMessage(widget.groupId, message);
      messageController.clear();
    }
  }

  Widget messages() {
    return StreamBuilder<List<ChatModel>>(
      stream: ref.watch(groupControllerProvider).getMessages(widget.groupId),
      builder: (context, AsyncSnapshot<List<ChatModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data?.length,
          itemBuilder: (context, index) {
            return MessageTile(
                message: snapshot.data![index].message,
                sender: snapshot.data![index].sender,
                sentByMe: user?.username == snapshot.data![index].sender);
          },
        );
      },
    );
  }
}
