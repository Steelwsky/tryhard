import 'package:flutter/cupertino.dart';
import 'package:tryhard/models/gymnastics.dart';
import 'package:tryhard/models/user.dart';
import 'package:tryhard/models/workout.dart';

import 'firestore_database.dart';

typedef SaveAllUserWorkouts = Future<void> Function({@required AllUserWorkouts allUserWorkouts});

typedef SaveGymnastics = Future<void> Function({@required Gymnastics gymnastics, @required String userGuid});

typedef SaveWorkout = Future<void> Function({@required Workout workout, @required String userGuid});

typedef SaveUser = Future<void> Function({@required User user});

typedef SaveUserAgain = Future<void> Function({@required String guid});

abstract class CloudStorage {
  CloudStorage({
    @required this.saveGymnastics,
    @required this.saveWorkout,
    @required this.saveUser,
    @required this.saveAllUserWorkouts,
  });

  final SaveGymnastics saveGymnastics;
  final SaveWorkout saveWorkout;
  final SaveUser saveUser;
  final SaveAllUserWorkouts saveAllUserWorkouts;
}

class MyDatabase implements CloudStorage {
  FirestoreDatabase firestoreDatabase = FirestoreDatabase();

  @override
  SaveGymnastics get saveGymnastics => firestoreDatabase.saveGymnastics;

  @override
  SaveWorkout get saveWorkout => firestoreDatabase.saveWorkout;

  @override
  SaveUser get saveUser => firestoreDatabase.saveNotExistedUser;

  @override
  SaveAllUserWorkouts get saveAllUserWorkouts => firestoreDatabase.saveAllUserWorkouts;
}
