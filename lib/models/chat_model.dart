class ChatModel {
  final String message;
  final String sender;
  final String time;
  ChatModel({
    required this.message,
    required this.sender,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'message': message});
    result.addAll({'sender': sender});
    result.addAll({'time': time});

    return result;
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      message: map['message'].toString(),
      sender: map['sender'].toString(),
      time: map['time'].toString(),
    );
  }
}
