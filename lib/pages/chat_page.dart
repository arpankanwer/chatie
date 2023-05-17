import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatie/group/controller/group_controller.dart';
import 'package:chatie/models/chat_model.dart';
import 'package:chatie/models/user_model.dart';
import 'package:chatie/pages/group_info.dart';

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
    ref.read(authControllerProvider).getUserData().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
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
            child: Flexible(
                child: TextFormField(
              controller: messageController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Enter Message',
                label: const Text("Message"),
                prefixIcon: const Icon(Icons.emoji_emotions_rounded),
                suffixIcon: IconButton(
                    onPressed: sendMessage, icon: const Icon(Icons.send)),
                contentPadding: EdgeInsets.symmetric(
                    vertical: mediaQuery.height * 0.02,
                    horizontal: mediaQuery.width * 0.01),
              ),
              onFieldSubmitted: (value) {
                messageController.text = value;
                sendMessage();
              },
              onEditingComplete: () {
                
              },
            )),
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
        return Expanded(
          child: ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return MessageTile(
                  message: snapshot.data![index].message,
                  sender: snapshot.data![index].sender,
                  sentByMe: user?.username == snapshot.data![index].sender);
            },
          ),
        );
      },
    );
  }
}
