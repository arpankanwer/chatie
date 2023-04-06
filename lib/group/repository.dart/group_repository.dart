import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertest/models/chat_model.dart';
import 'package:fluttertest/models/group_model.dart';
import 'package:fluttertest/models/user_model.dart';

import '../../widgets/widgets.dart';

final groupRepositoryProvider = Provider((ref) => GroupRepository(
    firebaseAuth: FirebaseAuth.instance,
    firebaseFirestore: FirebaseFirestore.instance));

class GroupRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  GroupRepository({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });
  void createGroup(BuildContext context, String groupName) async {
    GroupModel group = GroupModel(
        admin: firebaseAuth.currentUser!.uid,
        groupIcon: '',
        groupId: '',
        groupName: groupName,
        members: [],
        recentMessage: '',
        recentMessageSender: '',
        recentMessageTime: DateTime.now().millisecondsSinceEpoch.toString());
    DocumentReference groupDocumentReference =
        await firebaseFirestore.collection('groups').add(group.toMap());
    firebaseFirestore.collection('groups').doc(groupDocumentReference.id).set({
      "groupId": groupDocumentReference.id,
      "members": FieldValue.arrayUnion([firebaseAuth.currentUser?.uid])
    }, SetOptions(merge: true));

    firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser?.uid)
        .set({
      "groups": FieldValue.arrayUnion([groupDocumentReference.id])
    }, SetOptions(merge: true));
    if (context.mounted) {
      Navigator.of(context).pop();
      showSnackBar(context, Colors.green, "Group created successfully.");
    }
  }

  Stream<GroupModel> getGroupsName(String groupId) {
    return firebaseFirestore
        .collection('groups')
        .doc(groupId)
        .snapshots()
        .map((event) {
      GroupModel groups = GroupModel.fromMap(event.data()!);
      return groups;
    });
  }

  Stream<List<GroupModel>> getGroupsByName(String groupName) {
    return firebaseFirestore
        .collection('groups')
        .where("groupName", isGreaterThanOrEqualTo: groupName)
        .where("groupName",
            isLessThan: groupName.substring(0, groupName.length - 1) +
                String.fromCharCode(
                    groupName.codeUnitAt(groupName.length - 1) + 1))
        .snapshots()
        .map((event) {
      List<GroupModel> groups = [];
      for (var i = 0; i < event.docs.length; i++) {
        GroupModel group = GroupModel.fromMap(event.docs[i].data());
        groups.add(group);
      }
      return groups;
    });
  }

  Stream<UserModel> getGroups() {
    return firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser?.uid)
        .snapshots()
        .map((event) {
      UserModel user = UserModel.fromMap(event.data()!);
      return user;
    });
  }

  Stream<List<ChatModel>> getMessages(String groupId) {
    return firebaseFirestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots()
        .map((event) {
      List<ChatModel> chats = [];
      for (var i = 0; i < event.docs.length; i++) {
        ChatModel chat = ChatModel.fromMap(event.docs[i].data());
        chats.add(chat);
      }
      return chats;
    });
  }

  Future sendMessage(String groupId, Map<String, dynamic> message) async {
    await firebaseFirestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .add(message);
    await firebaseFirestore.collection('groups').doc(groupId).set({
      "recentMessage": message['message'],
      "recentMessageSender": message['sender'],
      "recentMessageTime": message['time'].toString()
    }, SetOptions(merge: true));
  }

  Stream<UserModel> getUserDataFromId(String uid) {
    return firebaseFirestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((event) {
      UserModel user = UserModel.fromMap(event.data()!);
      return user;
    });
  }

  Future<String> getNameFromUid(String uid) async {
    var name = await firebaseFirestore
        .collection('users')
        .where("uid", isEqualTo: uid)
        .get();

    return name.docs[0]['fullName'];
  }

  Future toggleJoinGroup(String groupId) async {
    String? uid = firebaseAuth.currentUser?.uid;

    DocumentReference userDocument =
        firebaseFirestore.collection('users').doc(uid);
    DocumentReference groupDocument =
        firebaseFirestore.collection('groups').doc(groupId);

    DocumentSnapshot groupSnapshot = await groupDocument.get();

    if ({groupSnapshot['members']}.toString().contains(uid.toString())) {
      await userDocument.set({
        "groups": FieldValue.arrayRemove([groupId])
      }, SetOptions(merge: true));
      await groupDocument.set({
        "members": FieldValue.arrayRemove([uid])
      }, SetOptions(merge: true));
    } else {
      await userDocument.set({
        "groups": FieldValue.arrayUnion([groupId])
      }, SetOptions(merge: true));
      await groupDocument.set({
        "members": FieldValue.arrayUnion([uid])
      }, SetOptions(merge: true));
    }
  }
}
