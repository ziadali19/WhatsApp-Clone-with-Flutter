class ChatContactModel {
  final String? name;
  final String? profilePic;
  final DateTime? timeSent;
  final String? lastMessage;
  final String? contactId;

  ChatContactModel(
      {required this.name,
      required this.profilePic,
      required this.timeSent,
      required this.lastMessage,
      required this.contactId});

  factory ChatContactModel.fromJson(json) {
    return ChatContactModel(
        name: json['name'],
        profilePic: json['profilePic'],
        timeSent: json['timeSent'],
        lastMessage: json['lastMessage'],
        contactId: json['contactId']);
  }

  toJson() {
    return {
      'name': name,
      'profilePic': profilePic,
      'timeSent': timeSent,
      'lastMessage': lastMessage,
      'contactId': contactId
    };
  }
}
