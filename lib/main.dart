import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:tryhard/controller/page_controller.dart';
import 'package:tryhard/controller/workout_controller.dart';
import 'package:tryhard/models/gymnastics.dart';
import 'package:tryhard/models/workout.dart';
import 'package:tryhard/pages/login_page.dart';
import 'package:tryhard/style/colors.dart';

import 'controller/gymnastics_controller.dart';
import 'firestore/firestore_database.dart';
import 'models/user.dart';

typedef SaveGymnastics = Future<void> Function(Gymnastics gymnastics, User user);
typedef SaveWorkout = Future<void> Function(Workout workout);

abstract class CloudStorage {
  CloudStorage({this.saveGymnastics, this.saveWorkout});

  final SaveGymnastics saveGymnastics;
  final SaveWorkout saveWorkout;
}

class MyDatabase implements CloudStorage {
  FirestoreDatabase firestoreDatabase = FirestoreDatabase();

  @override
  SaveGymnastics get saveGymnastics => firestoreDatabase.saveGymnastics;

  @override
  SaveWorkout get saveWorkout => firestoreDatabase.saveWorkout;
}

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
          Provider<WorkoutController>(create: (_) => WorkoutController(myDatabase: widget.myDatabase)),
          Provider<GymnasticsController>(create: (_) => GymnasticsController()),
          Provider<MyPageController>(create: (_) => MyPageController()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
//              primarySwatch: Colors.deepPurple,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              primaryColor: DARK_PURPLE),
          home: LoginPageWidget(),
        ));
  }
}
