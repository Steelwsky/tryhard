import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tryhard/controller/user_controller.dart';
import 'package:tryhard/models/user.dart';
import 'package:tryhard/style/colors.dart';
import 'success_signin_page.dart';
import 'package:tryhard/widgets/circular_indicator.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    this.userController,
  });

  final UserController userController;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogged = false;
  User user;

  UserController userController;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    final UserController currentUserController = Provider.of<UserController>(context);
    if (currentUserController != userController) {
      userController = currentUserController;
      print('userController = currentUserController');
      if (await userController.isSignIn()) {
        print('await userController.isSignIn() --- TRUE');
        userController.onSignIn();
      }
    }
  } //google asyncSnapshot sign in.  AsyncSnapshot use it frequently!!!

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AsyncSnapshot<User>>(
      valueListenable: userController.userProfile,
      builder: (_, snapshot, __) {
        if (snapshot == null) {
          print('snapshot == null || !snapshot.hasData');
          return Login();
        } else if (snapshot.hasError) {
          return RetryLogin();
        } else if (snapshot.hasData && snapshot.data != null) {
          print('snapshot.hasData && snapshot.data != null: ${snapshot.data.uid}');
          return SuccessSignInPage();
        } else
          // return Login();
          return MyCircularIndicatorWidget();
      },
    );
  }
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserController userController = Provider.of<UserController>(context);
    return ValueListenableBuilder<AsyncSnapshot<User>>(
        valueListenable: userController.userProfile,
        builder: (_, snapshot, __) {
          return Scaffold(
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
                        userController.onSignIn();
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
        });
  }
}

class RetryLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserController userController = Provider.of<UserController>(context);
    return Scaffold(
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
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Text(
                    'Oops, something went wrong... \nPlease try again',
                    style: TextStyle(
                      fontSize: 18,
                      color: WHITE,
                    ),
                  ),
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  userController.onSignIn();
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
}
