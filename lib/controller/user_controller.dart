import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tryhard/firestore/cloud_storage.dart';
import 'package:tryhard/models/user.dart';

class UserController {
  UserController({
    @required PersistUser persistUser,
    @required LoginProvider loginProvider,
    @required UserLoggedInState userLoggedInState,
  })  : _persistUser = persistUser,
        _loginProvider = loginProvider,
        _userLoggedInState = userLoggedInState;

  final PersistUser _persistUser;
  final LoginProvider _loginProvider;
  final UserLoggedInState _userLoggedInState;

  ValueNotifier<AsyncSnapshot<User>> userProfile = ValueNotifier(null);

  void saveNotExistedUserGuid({@required User user}) {
    _persistUser(user: user);
  }

  Future<void> onSignIn() async {
    print('onSignIn call ******************');

    try {
      final User user = await _loginProvider.signIn();
      print('user: ${user.uid}');
      userProfile.value = AsyncSnapshot.withData(ConnectionState.done, user);
      print('userProfile.value: ${userProfile.value.data.uid}');
      saveNotExistedUserGuid(user: userProfile.value.data);
      _userLoggedInState.isLoggedIn.value = true;
    } catch (e) {
      print('ERROR: $e');
      userProfile.value =
          AsyncSnapshot.withError(ConnectionState.done, Exception('no user found!'));
      _userLoggedInState.isLoggedIn.value = false;
    }
  }

  Future<bool> isSignIn() async {
    return await _loginProvider.isSignIn();
  }
}

abstract class LoginProvider {
  Future<User> signIn();

  Future<bool> isSignIn();
// Future<void> signOut(); //todo for my drawer signOut func
}

class FirebaseGoogleLoginProvider implements LoginProvider {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<User> signIn() async {
    bool userSignedIn = await isSignIn();
    if (userSignedIn) {
      FirebaseUser user = await _auth.currentUser();
      return user._mapToUser();
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      print('GoogleSignInAccount: ${googleUser.id}');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final AuthResult authResult = await _auth.signInWithCredential(credential);
      return authResult.user._mapToUser();
    }
  }

  @override
  Future<bool> isSignIn() async {
    return await _googleSignIn.isSignedIn();
  }
}

extension on FirebaseUser {
  User _mapToUser() => User(
        uid: uid,
        firstName: displayName,
        email: email,
        phoneNumber: phoneNumber,
        photo: photoUrl,
      );
}

class UserLoggedInState {
  ValueNotifier<bool> isLoggedIn = ValueNotifier(false); //todo
}
