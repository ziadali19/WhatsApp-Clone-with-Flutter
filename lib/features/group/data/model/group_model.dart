class GroupModel {
  final String senderId;
  final String name;
  final String lastMessage;
  final DateTime timeSent;
  final String groupId;
  final String groupPic;
  final List<String> usersUIDs;

  GroupModel(
      {required this.timeSent,
      required this.senderId,
      required this.name,
      required this.lastMessage,
      required this.groupId,
      required this.groupPic,
      required this.usersUIDs});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'senderId': senderId,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'name': name,
      'lastMessage': lastMessage,
      'groupId': groupId,
      'groupPic': groupPic,
      'usersUIDs': usersUIDs,
    };
  }

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
        senderId: json['senderId'] as String,
        name: json['name'] as String,
        lastMessage: json['lastMessage'] as String,
        groupId: json['groupId'] as String,
        groupPic: json['groupPic'] as String,
        usersUIDs: List.from(
          (json['usersUIDs'] as List),
        ),
        timeSent: DateTime.fromMillisecondsSinceEpoch(json['timeSent']));
  }
}
