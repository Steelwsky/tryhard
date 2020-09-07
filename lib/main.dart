import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:tryhard/controller/user_controller.dart';
import 'package:tryhard/controller/workout_controller.dart';
import 'package:tryhard/pages/login_page.dart';
import 'package:tryhard/style/colors.dart';
import 'package:tryhard/success_signin_page.dart';

import 'controller/gymnastics_controller.dart';
import 'controller/page_controller.dart';
import 'firestore/cloud_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final CloudStorage myDatabase = MyDatabase();
  initializeDateFormatting().then((_) => runApp(MyApp(
        myDatabase: myDatabase,
      )));
}

class MyApp extends StatefulWidget {
  MyApp({this.myDatabase});

  final CloudStorage myDatabase;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //TODO replace those provider down to AllPages()+1 level
    return MultiProvider(
        providers: [
          Provider<UserController>(create: (_) => UserController(saveUser: widget.myDatabase.saveUser)),
          Provider<WorkoutController>(create: (_) => WorkoutController(myDatabase: widget.myDatabase)),
          Provider<GymnasticsController>(create: (_) => GymnasticsController()),
          Provider<MyPageController>(create: (_) => MyPageController()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryColor: SCAFFOLD_BLACK,
            accentColor: PURPLE,
            primaryColorBrightness: Brightness.dark,
            brightness: Brightness.dark,
            bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: NAVBAR_BLACK),
            scaffoldBackgroundColor: SCAFFOLD_BLACK,
            // textTheme: TextTheme(),
            floatingActionButtonTheme:
                FloatingActionButtonThemeData(foregroundColor: SCAFFOLD_BLACK, backgroundColor: PURPLE),
            indicatorColor: DARK_PURPLE,
            buttonTheme: ButtonThemeData(),
            buttonColor: DARK_PURPLE,
            // buttonBarTheme: ButtonBarThemeData(),
            cardColor: BACKGROUND_DARK_GREY,
          ),
          home: LoginPageWidget(),
          routes: {
            "/successSignIn": (_) => SuccessSignInPage(),
          },
        ));
  }
}
