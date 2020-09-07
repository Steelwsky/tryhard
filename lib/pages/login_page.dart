import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tryhard/models/user.dart';
import 'package:tryhard/style/colors.dart';
import 'package:tryhard/success_signin_page.dart';

class LoginPageWidget extends StatefulWidget {
  @override
  LoginPageWidgetState createState() => LoginPageWidgetState();
}

class LoginPageWidgetState extends State<LoginPageWidget> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isUserSignedIn = false;

  @override
  void initState() {
    super.initState();

    checkIfUserIsSignedIn();
  }

  void checkIfUserIsSignedIn() async {
    final userSignedIn = await _googleSignIn.isSignedIn();

    setState(() {
      isUserSignedIn = userSignedIn;
    });

    if (userSignedIn) {
      onGoogleSignIn(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isUserSignedIn
        ? MyCircularIndicatorWidget()
        : Scaffold(
            body: Container(
              padding: EdgeInsets.all(50),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Text(
                          'TRYHARD',
                          style: TextStyle(
                            fontSize: 32,
                            color: DARK_PURPLE,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        onGoogleSignIn(context);
                      },
                      color: DARK_PURPLE,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.account_circle, color: Colors.white),
                            SizedBox(width: 10),
                            Text('Login with Google', style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
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
    print('onGoogleSignIn call ******************');
    FirebaseUser firebaseUser = await _handleSignIn();

    final User user = User(
        uid: firebaseUser.uid,
        firstName: firebaseUser.displayName,
        email: firebaseUser.email,
        phoneNumber: firebaseUser.phoneNumber,
        photo: firebaseUser.photoUrl);

    //TODO line 112 builds the widget twice!!!!
    await Navigator.pushReplacementNamed(context, "/successSignIn", arguments: user, result: true);
    // await Navigator.popAndPushNamed(context, "/successSignIn", arguments: user, result: true);
  }
}
