class UserModel {
  final String? name;
  final String? uID;
  final String? profilePic;
  final bool? isOnline;
  final String? phoneNumber;
  final List groupId;

  UserModel(
      {required this.name,
      required this.uID,
      required this.profilePic,
      required this.isOnline,
      required this.phoneNumber,
      required this.groupId});
  factory UserModel.fromJson(json) {
    return UserModel(
        name: json['name'],
        uID: json['uID'],
        profilePic: json['profilePic'],
        isOnline: json['isOnline'],
        phoneNumber: json['phoneNumber'],
        groupId: json['groupId']);
  }
  toJson() {
    return {
      'name': name,
      'uID': uID,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupId': groupId
    };
  }
}
