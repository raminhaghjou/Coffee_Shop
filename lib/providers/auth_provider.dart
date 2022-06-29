import 'dart:io';

import 'package:coffee_shop_app/models/user_model.dart';
import 'package:coffee_shop_app/service/base_auth.dart';
import 'package:coffee_shop_app/util/getfilename.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class AuthProvider with ChangeNotifier implements BaseAuth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference databaseReference;
  String authError = '';
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  Reference storageReference;
  String uid = '';
  bool isLoading = false;
  final _facebooklogin = FacebookLogin();
  final dio = Dio();
  String verificationId;

  @override
  Future logOutUser() async {
    // TODO: implement logOutUser
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<void> forgotPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendCodeToPhoneNumber(String phone) async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential user) {
      print(user);
      notifyListeners();
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print(authException.message);
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      print("code sent to " + phone);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      print("time out");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void changePassword(String password) async {
    //Create an instance of the current user.
    User user = await FirebaseAuth.instance.currentUser;
    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_) {
      print("Succesfull changed password");
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }

  @override
  Future loginUser(String email, String password) async {
    isLoading = true;
    try {
      UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      uid = authResult.user.uid;
      return authResult.user != null;
    } catch (error) {
      authError = error.code;
      PlatformException(code: authError);
    }
    isLoading = false;
    notifyListeners();
  }

  @override
  Future registerUser(String email, String password, String phoneNumber,
      String userName, File urlImage) async {
    isLoading = true;

    UserCredential authResult = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    String uid = authResult.user.uid;
    databaseReference = firebaseDatabase.reference().child('User').child(uid);

    String fileName = await getFileName.getFileNameWithExtension(urlImage);

    storageReference =
        FirebaseStorage.instance.ref().child('user').child(fileName);
    // UploadTask storageUploadTask = storageReference.putFile(urlImage);
    // TaskSnapshot snapshot = await storageUploadTask.onComplete;
    // String dowloadURL = await snapshot.ref.getDownloadURL();
    await storageReference.putFile(urlImage);
    String dowloadURL = await storageReference.getDownloadURL();

    UserModel user = UserModel(
        userUid: uid,
        userName: userName,
        phoneNumber: phoneNumber,
        userImage: dowloadURL,
        userEmail: authResult.user.email);
    databaseReference.set(user.toJson());

    isLoading = false;

    notifyListeners();
  }

  void isLoadingg(bool status) {
    isLoading = status;
    notifyListeners();
  }

  @override
  Future loginFB() async {
    _facebooklogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    // final FacebookLoginResult _facebooklogin = await facebookLogin.logIn(['email', 'public_profile']);
    final result = await _facebooklogin.logIn(['email']);
    final token = result.accessToken.token;

    final graqh = await dio.get(
        'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${token}');
    final profile = graqh.data;

//    Map<String,dynamic> abc  = graqh.data;
//    print(abc.keys);
//    print(graqh.data);

    if (result.status == FacebookLoginStatus.loggedIn) {
      AuthCredential credential = FacebookAuthProvider.credential(token);
      await firebaseAuth.signInWithCredential(credential);
    }
  }
}
