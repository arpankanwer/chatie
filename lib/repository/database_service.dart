// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class DatabaseService {
//   // FirebaseAdmin admin = FirebaseAdmin();
//   final CollectionReference userCollection =
//       FirebaseFirestore.instance.collection("users");

//   final CollectionReference groupCollection =
//       FirebaseFirestore.instance.collection("groups");

//   // Future savingData(
//   //     String uid, String fullName, String username, String email) async {
//   //   return await userCollection.doc(uid).set({
//   //     "fullName": fullName,
//   //     "username": username,
//   //     "email": email,
//   //     "groups": [],
//   //     "profilePic": "",
//   //     "uid": uid
//   //   });
//   // }

//   // Future<bool> checkUsername(String username) async {
//   //   var result =
//   //       await userCollection.where("username", isEqualTo: username).get();
//   //   return result.docs.isNotEmpty;
//   // }

//   // Future getData(String uid, String email) async {
//   //   QuerySnapshot snapshot =
//   //       await userCollection.where("email", isEqualTo: email).get();
//   //   return snapshot;
//   // }

//   // Stream getGroups(String groupId) {
//   //   var name = groupCollection.where("groupId", isEqualTo: groupId).snapshots();
//   //   return name;
//   // }

//   Stream getNameFromId(String uid) {
//     return userCollection.where("uid", isEqualTo: uid).snapshots();
//   }

//   Future<String> getNameFromUid(String uid) async {
//     var name = await userCollection.where("uid", isEqualTo: uid).get();

//     return name.docs[0]['fullName'];
//   }

//   // Future toggleJoinGroup(String uid, String groupId) async {
//   //   DocumentReference userDocument = userCollection.doc(uid);
//   //   DocumentReference groupDocument = groupCollection.doc(groupId);

//   //   DocumentSnapshot userSnapshot = await userDocument.get();
//   //   DocumentSnapshot groupSnapshot = await groupDocument.get();

//   //   if ({groupSnapshot['members']}.toString().contains(uid)) {
//   //     await userCollection.doc(uid).set({
//   //       "groups": FieldValue.arrayRemove([groupId])
//   //     }, SetOptions(merge: true));
//   //     await groupCollection.doc(groupId).set({
//   //       "members": FieldValue.arrayRemove([uid])
//   //     }, SetOptions(merge: true));
//   //   } else {
//   //     await userCollection.doc(uid).set({
//   //       "groups": FieldValue.arrayUnion([groupId])
//   //     }, SetOptions(merge: true));
//   //     await groupCollection.doc(groupId).set({
//   //       "members": FieldValue.arrayUnion([uid])
//   //     }, SetOptions(merge: true));
//   //   }
//   // }

//   getMembers(String groupId) async {
//     return groupCollection.doc(groupId).snapshots();
//   }

//   getGroupsFromUser(String uid) async {
//     return userCollection.doc(uid).snapshots();
//   }

//   // getGroupsByName(String groupName) async {
//   //   // if (groupName != "") {
//   //   return groupCollection
//   //       .where("groupName", isGreaterThanOrEqualTo: groupName)
//   //       .where("groupName",
//   //           isLessThan: groupName.substring(0, groupName.length - 1) +
//   //               String.fromCharCode(
//   //                   groupName.codeUnitAt(groupName.length - 1) + 1))
//   //       // .startAt([groupName]).endAt(['$groupName\uf8ff'])
//   //       .snapshots();
//   //   // print(snapshot);
//   //   // return snapshot;
//   //   // }
//   // }

//   // Future createGroup(String uid, String groupName) async {
//   //   DocumentReference groupDocumentReference = await groupCollection.add({
//   //     "groupName": groupName,
//   //     "groupIcon": "",
//   //     "admin": uid,
//   //     "members": [],
//   //     "groupId": "",
//   //     "recentMessage": "",
//   //     "recentMessageSender": "",
//   //     "recentMessageTime": DateTime.now().millisecondsSinceEpoch
//   //   });
//   //   await groupCollection.doc(groupDocumentReference.id).set({
//   //     "groupId": groupDocumentReference.id,
//   //     "members": FieldValue.arrayUnion([uid])
//   //   }, SetOptions(merge: true));

//   //   await userCollection.doc(uid).set({
//   //     "groups": FieldValue.arrayUnion([groupDocumentReference.id])
//   //   }, SetOptions(merge: true));
//   // }

//   getMessages(String groupId) async {
//     return groupCollection
//         .doc(groupId)
//         .collection('messages')
//         .orderBy('time')
//         .snapshots();
//   }

//   Future sendMessage(String groupId, Map<String, dynamic> message) async {
//     groupCollection.doc(groupId).collection('messages').add(message);
//     groupCollection.doc(groupId).set({
//       "recentMessage": message['message'],
//       "recentMessageSender": message['sender'],
//       "recentMessageTime": message['time'].toString()
//     }, SetOptions(merge: true));
//   }
// }
