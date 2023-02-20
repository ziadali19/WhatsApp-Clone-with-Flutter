import 'package:whatsapp_clone/core/common/enums/messgae_enum.dart';

class MessageModel {
  final String senderId;
  final String recieverId;
  final String text;
  final MessageEnum messageType;
  final String messageId;
  final bool isSeen;
  final DateTime timeSent;
  final String replyOn;
  final String replyOnUserName;
  final MessageEnum replyOnMessageType;
  MessageModel({
    required this.senderId,
    required this.recieverId,
    required this.text,
    required this.messageType,
    required this.messageId,
    required this.isSeen,
    required this.timeSent,
    required this.replyOn,
    required this.replyOnUserName,
    required this.replyOnMessageType,
  });
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['senderId'] as String,
      recieverId: json['recieverId'] as String,
      text: json['text'] as String,
      messageType: (json['messageType'] as String).toEnum(),
      messageId: json['messageId'] as String,
      isSeen: json['isSeen'] as bool,
      timeSent: DateTime.parse(json['timeSent']),
      replyOn: json['replyOn'] as String,
      replyOnMessageType: (json['replyOnMessageType'] as String).toEnum(),
      replyOnUserName: json['replyOnUserName'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'senderId': senderId,
      'recieverId': recieverId,
      'text': text,
      'messageType': messageType.type,
      'messageId': messageId,
      'isSeen': isSeen,
      'timeSent': timeSent.toString(),
      'replyOn': replyOn,
      'replyOnUserName': replyOnUserName,
      'replyOnMessageType': replyOnMessageType.type,
    };
  }
}
