import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  Stream getGroupsByName(String groupName) {
    return firebaseFirestore
        .collection('groups')
        .where("groupName", isGreaterThanOrEqualTo: groupName)
        .where("groupName",
            isLessThan: groupName.substring(0, groupName.length - 1) +
                String.fromCharCode(
                    groupName.codeUnitAt(groupName.length - 1) + 1))
        .snapshots();
  }

  Stream<UserModel> getGroups() {
    return firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
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

    // DocumentSnapshot userSnapshot = await userDocument.get();
    DocumentSnapshot groupSnapshot = await groupDocument.get();

    if ({groupSnapshot['members']}.toString().contains(uid.toString())) {
      await firebaseFirestore.collection('users').doc(uid).set({
        "groups": FieldValue.arrayRemove([groupId])
      }, SetOptions(merge: true));
      await firebaseFirestore.collection('groups').doc(groupId).set({
        "members": FieldValue.arrayRemove([uid])
      }, SetOptions(merge: true));
    } else {
      await firebaseFirestore.collection('users').doc(uid).set({
        "groups": FieldValue.arrayUnion([groupId])
      }, SetOptions(merge: true));
      await firebaseFirestore.collection('groups').doc(groupId).set({
        "members": FieldValue.arrayUnion([uid])
      }, SetOptions(merge: true));
    }
  }
}
