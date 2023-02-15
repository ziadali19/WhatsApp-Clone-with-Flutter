import 'package:intl/intl.dart';

class StatusModel {
  final String uID;
  final String userName;
  final String phoneNumber;
  final List<String> photoUrl;
  final DateTime createdAt;
  final String profilePic;
  final String statusId;
  final List<String> whoCanSee;
  StatusModel({
    required this.uID,
    required this.userName,
    required this.phoneNumber,
    required this.photoUrl,
    required this.createdAt,
    required this.profilePic,
    required this.statusId,
    required this.whoCanSee,
  });

  Map<String, dynamic> toMap() {
    return {
      'uID': uID,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'profilePic': profilePic,
      'statusId': statusId,
      'whoCanSee': whoCanSee,
    };
  }

  factory StatusModel.fromjson(json) {
    return StatusModel(
      uID: json['uID'] ?? '',
      userName: json['userName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      photoUrl: List<String>.from(json['photoUrl']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      profilePic: json['profilePic'] ?? '',
      statusId: json['statusId'] ?? '',
      whoCanSee: List<String>.from(json['whoCanSee']),
    );
  }
}
