import 'package:flutter/cupertino.dart';
import 'package:tryhard/firestore/cloud_storage.dart';
import 'package:tryhard/models/user.dart';

// TODO 1. when user logging first time, we should save him after creating first workout OR after logging via google
//      2. if existed user open app, we should auto download data from firestore by his uid


class UserController {
  UserController({this.saveUser}) {
    print('userController');
  }

  final SaveUser saveUser;

  // final User user;

  ValueNotifier<User> userNotifier = ValueNotifier(null);

  void saveNotExistedUserGuid({@required User user}) {
    saveUser(user: user);
  }

  //todo mb valueNotifier is too OP, but user data can be used in drawer
  void setUserValueNotifier({@required User user}) {
    print('setUserValueNotifier call');
    userNotifier.value = user;
  }
}
