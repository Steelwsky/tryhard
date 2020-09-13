import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:tryhard/controller/user_controller.dart';
import 'package:tryhard/controller/workout_controller.dart';
import 'package:tryhard/pages/login_page.dart';
import 'package:tryhard/style/theme.dart';
import 'pages/success_signin_page.dart';

import 'controller/gymnastics_controller.dart';
import 'controller/page_controller.dart';
import 'firestore/cloud_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final CloudStorage myDatabase = MyDatabase();
  final LoginProvider loginProvider = FirebaseGoogleLoginProvider();
  initializeDateFormatting().then((_) => runApp(MyApp(
        myDatabase: myDatabase,
        loginProvider: loginProvider,
      )));
}

//firebase remote config, google it just FMI

class MyApp extends StatefulWidget {
  MyApp({
    this.myDatabase,
    this.loginProvider,
  });

  final CloudStorage myDatabase;
  final LoginProvider loginProvider;
  final UserLoggedInState userLoggedInState = UserLoggedInState();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
// // comment we can init firebase, analytics,
//   }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<UserController>(
            create: (_) =>
                UserController(
                  persistUser: widget.myDatabase.saveUser,
                  loginProvider: widget.loginProvider,
                  userLoggedInState: widget.userLoggedInState,
                ),
          ),
          Provider<WorkoutController>(
            create: (_) =>
                WorkoutController(
                  myDatabase: widget.myDatabase,
                  userLoggedInState: widget.userLoggedInState,
                ),
            dispose: (context, controller) {
              controller.unsubscribe();
            },
          ),
          Provider<GymnasticsController>(create: (_) => GymnasticsController()),
          Provider<MyPageController>(create: (_) => MyPageController()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: myTheme,
          home: LoginPage(),
          routes: {
            "/successSignIn": (_) => SuccessSignInPage(),
          },
        ));
  }
}

