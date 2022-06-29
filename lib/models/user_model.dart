class UserModel {
  String userName;
  String userEmail;
  String userImage;
  String phoneNumber;
  String userUid;
  UserModel({
    this.userEmail,
    this.userImage,
    this.userName,
    this.phoneNumber,
    this.userUid,
  });

  Map<dynamic, dynamic> toJson() => {
        'userUid': userUid,
        'userImage': userImage,
        'userName': userName,
        'phoneNumber': phoneNumber,
        'userEmail': userEmail
      };
}
