import 'package:flutter/cupertino.dart';
import 'package:tryhard/models/user.dart';

// TODO 1. when user logging first time, we should save him after creating first workout OR after logging via google
//      2. if existed user open app, we should auto download data from firestore by his uid
//

class UserController {
  ValueNotifier<User> user = ValueNotifier(User());

  void setUserFromGoogle({
    String uid,
    String displayName,
    String email,
    String photoUrl,
    String phoneNumber,
  }) {
    user.value = User(
      uid: uid,
      firstName: displayName,
      email: email,
      photo: photoUrl,
      phoneNumber: phoneNumber,
    );
  }

  void saveUser() {
    //todo save to firestore
  }
}
