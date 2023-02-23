import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // FirebaseAdmin admin = FirebaseAdmin();
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  Future savingData(
      String uid, String fullName, String username, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "username": username,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid
    });
  }

  Future<bool> checkUsername(String username) async {
    var result =
        await userCollection.where("username", isEqualTo: username).get();
    return result.docs.isNotEmpty;
  }

  Future getData(String uid, String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  Stream getGroupNameFromId(String groupId) {
    return groupCollection.where("groupId", isEqualTo: groupId).snapshots();
  }

  Stream getNameFromId(String uid) {
    return userCollection.where("uid", isEqualTo: uid).snapshots();
  }

  getMembers(String groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  getGroups(String uid) async {
    return userCollection.doc(uid).snapshots();
  }

  Future getGroupsByName(String groupName) async {
    print((groupCollection.where("groupName", isEqualTo: groupName).get()));
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  Future createGroup(String uid, String userName, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": uid,
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    await groupCollection.doc(groupDocumentReference.id).set({
      "groupId": groupDocumentReference.id,
      "members": FieldValue.arrayUnion([uid])
    }, SetOptions(merge: true));

    await userCollection.doc(uid).set({
      "groups": FieldValue.arrayUnion([groupDocumentReference.id])
    }, SetOptions(merge: true));
  }
}
