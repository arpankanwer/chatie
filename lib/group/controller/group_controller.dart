import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertest/models/chat_model.dart';
import 'package:fluttertest/models/user_model.dart';

import '../../models/group_model.dart';
import '../repository.dart/group_repository.dart';

final groupControllerProvider = Provider((ref) {
  final groupRepository = ref.watch(groupRepositoryProvider);
  return GroupController(groupRepository: groupRepository);
});

class GroupController {
  final GroupRepository groupRepository;
  GroupController({required this.groupRepository});

  void createGroup(BuildContext context, String groupName) {
    groupRepository.createGroup(context, groupName);
  }

  Stream<UserModel> getGroups() {
    return groupRepository.getGroups();
  }

  Stream<GroupModel> getGroupsName(String groupId) {
    return groupRepository.getGroupsName(groupId);
  }

  Stream getGroupsByName(String groupId) {
    return groupRepository.getGroupsByName(groupId);
  }

  Future sendMessage(String groupId, Map<String, dynamic> message) {
    return groupRepository.sendMessage(groupId, message);
  }

  Stream<List<ChatModel>> getMessages(String groupId) {
    return groupRepository.getMessages(groupId);
  }

  Future toggleJoinGroup(String groupId) {
    return groupRepository.toggleJoinGroup(groupId);
  }

  Stream<UserModel> getUserDataFromId(String userId) {
    return groupRepository.getUserDataFromId(userId);
  }
}
