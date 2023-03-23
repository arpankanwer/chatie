class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String profilePic;
  final String username;
  final String password;
  final bool isOnline;
  final List<String> groups;
  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.profilePic,
    required this.username,
    required this.password,
    required this.isOnline,
    required this.groups,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'uid': uid});
    result.addAll({'fullName': fullName});
    result.addAll({'email': email});
    result.addAll({'profilePic': profilePic});
    result.addAll({'username': username});
    result.addAll({'password': password});
    result.addAll({'isOnline': isOnline});
    result.addAll({'groups': groups});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      profilePic: map['profilePic'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      isOnline: map['isOnline'] ?? false,
      groups: List<String>.from(map['groups']),
      
    );
  }
}
