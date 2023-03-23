
class GroupModel {
  final String admin;
  final String groupIcon;
  final String groupId;
  final String groupName;
  final List<String> members;
  final String recentMessage;
  final String recentMessageSender;
  final String recentMessageTime;
  GroupModel({
    required this.admin,
    required this.groupIcon,
    required this.groupId,
    required this.groupName,
    required this.members,
    required this.recentMessage,
    required this.recentMessageSender,
    required this.recentMessageTime,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'admin': admin});
    result.addAll({'groupIcon': groupIcon});
    result.addAll({'groupId': groupId});
    result.addAll({'groupName': groupName});
    result.addAll({'members': members});
    result.addAll({'recentMessage': recentMessage});
    result.addAll({'recentMessageSender': recentMessageSender});
    result.addAll({'recentMessageTime': recentMessageTime});

    return result;
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      admin: map['admin'].toString(),
      groupIcon: map['groupIcon'].toString(),
      groupId: map['groupId'].toString(),
      groupName: map['groupName'].toString(),
      members: List<String>.from(map['members']),
      recentMessage: map['recentMessage'].toString(),
      recentMessageSender: map['recentMessageSender'].toString(),
      recentMessageTime: map['recentMessageTime'].toString(),
    );
  }
}
