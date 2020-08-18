import 'package:flutter/cupertino.dart';
import 'package:tryhard/firestore/cloud_storage.dart';
import 'package:tryhard/models/user.dart';

// TODO 1. when user logging first time, we should save him after creating first workout OR after logging via google
//      2. if existed user open app, we should auto download data from firestore by his uid


class UserController {
  UserController({this.myDatabase, this.user}) {
    print('userController');
  }

  final CloudStorage myDatabase;
  final User user;

  ValueNotifier<User> userNotifier = ValueNotifier(User());

//  void setUserFromGoogle({
//    String uid,
//    String displayName,
//    String email,
//    String photoUrl,
//    String phoneNumber,
//  }) {
//    userNotifier.value = User(
//      uid: uid,
//      firstName: displayName,
//      email: email,
//      photo: photoUrl,
//      phoneNumber: phoneNumber,
//    );
//  }

  void saveNotExistedUserGuid(String uid) {
    myDatabase.saveUser(uid);
  }

  //todo mb valueNotifier is too OP, but user data can be used in drawer
  void setUserValueNotifier(User user) {
    userNotifier.value = user;
  }
}
