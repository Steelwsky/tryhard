import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tryhard/all_pages.dart';
import 'package:tryhard/controller/user_controller.dart';
import 'package:tryhard/models/user.dart';

class LoginPageWidget extends StatefulWidget {
  @override
  LoginPageWidgetState createState() => LoginPageWidgetState();
}

class LoginPageWidgetState extends State<LoginPageWidget> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isUserSignedIn = false;

//final googleController = GoogleSignInController();

  @override
  void initState() {
    super.initState();

    checkIfUserIsSignedIn();
  }

  void checkIfUserIsSignedIn() async {
//    var userSignedIn = await googleController.googleSignIn.isSignedIn();
    var userSignedIn = await _googleSignIn.isSignedIn();

    setState(() {
      isUserSignedIn = userSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.all(50),
            child: Align(
                alignment: Alignment.center,
                child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () {
                      onGoogleSignIn(context);
                    },
                    color: isUserSignedIn ? Colors.green : Colors.blueAccent,
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.account_circle, color: Colors.white),
                            SizedBox(width: 10),
                            Text(isUserSignedIn ? 'You\'re logged in with Google' : 'Login with Google',
                                style: TextStyle(color: Colors.white))
                          ],
                        ))))));
  }

  Future<FirebaseUser> _handleSignIn() async {
    FirebaseUser user;
    bool userSignedIn = await _googleSignIn.isSignedIn();

    setState(() {
      isUserSignedIn = userSignedIn;
    });

    if (isUserSignedIn) {
      user = await _auth.currentUser();
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      user = (await _auth.signInWithCredential(credential)).user;
      userSignedIn = await _googleSignIn.isSignedIn();
      setState(() {
        isUserSignedIn = userSignedIn;
      });
    }

    return user;
  }

  void onGoogleSignIn(BuildContext context) async {
    FirebaseUser user = await _handleSignIn();
    final UserController userController = UserController();

    userController.user.value = User(
        uid: user.uid,
        firstName: user.displayName,
        email: user.email,
        phoneNumber: user.phoneNumber,
        photo: user.photoUrl);

    var userSignedIn = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
//              WelcomeUserWidget(user, _googleSignIn)), //dMEe4zNXInesHhEJLmxhJy0fb1n1
              AllPages(userController.user.value)),
    );

    setState(() {
      isUserSignedIn = userSignedIn == null ? true : false;
    });
  }
}

//class WelcomeUserWidget extends StatelessWidget {
//  GoogleSignIn _googleSignIn;
//  FirebaseUser _user;
//
//  WelcomeUserWidget(FirebaseUser user, GoogleSignIn signIn) {
//    _user = user;
//    _googleSignIn = signIn;
//    print('**************************${_user.uid}');
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        appBar: AppBar(
//          backgroundColor: Colors.white,
//          iconTheme: IconThemeData(color: Colors.black),
//          elevation: 0,
//        ),
//        body: Container(
//            color: Colors.white,
//            padding: EdgeInsets.all(50),
//            child: Align(
//                alignment: Alignment.center,
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    ClipOval(child: Image.network(_user.photoUrl, width: 100, height: 100, fit: BoxFit.cover)),
//                    SizedBox(height: 20),
//                    Text('Welcome,', textAlign: TextAlign.center),
//                    Text(_user.displayName,
//                        textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
//                    SizedBox(height: 20),
//                    FlatButton(
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(20),
//                        ),
//                        onPressed: () {
//                          _googleSignIn.signOut();
//                          Navigator.pop(context, false);
//                        },
//                        color: Colors.redAccent,
//                        child: Padding(
//                            padding: EdgeInsets.all(10),
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              children: <Widget>[
//                                Icon(Icons.exit_to_app, color: Colors.white),
//                                SizedBox(width: 10),
//                                Text('Log out of Google', style: TextStyle(color: Colors.white))
//                              ],
//                            )))
//                  ],
//                ))));
//  }
//}
