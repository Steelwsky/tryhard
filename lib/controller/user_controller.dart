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

  //TODO bug: if user didn't login before - google's pop up auto showing
  Future<void> onSignIn() async {
    print('onSignIn call ******************');

    try {
      final User user = await _loginProvider.signIn();
      userProfile.value = AsyncSnapshot.withData(ConnectionState.done, user);
      saveNotExistedUserGuid(user: userProfile.value.data);
      _userLoggedInState.isLoggedIn.value = true;
    } catch (e) {
      userProfile.value =
          AsyncSnapshot.withError(ConnectionState.done, Exception('no user found! $e'));
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
      return user.mapToUser();
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      print('GoogleSignInAccount: ${googleUser.id}');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final AuthResult authResult = await _auth.signInWithCredential(credential);
      return authResult.user.mapToUser();
    }
  }

  @override
  Future<bool> isSignIn() async {
    return await _googleSignIn.isSignedIn();
  }
}

extension on FirebaseUser {
  User mapToUser() => User(
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
