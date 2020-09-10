import 'package:flutter/cupertino.dart';
import 'package:tryhard/models/gymnastics.dart';
import 'package:tryhard/models/user.dart';
import 'package:tryhard/models/workout.dart';

import 'firestore_database.dart';

typedef SaveGymnastics = Future<void> Function({@required Gymnastics gymnastics, @required String userGuid});

typedef SaveWorkout = Future<void> Function({@required Workout workout, @required String userGuid});

typedef PersistUser = Future<void> Function({@required User user});

typedef LoadUserWorkouts = Future<List<Workout>> Function({@required String userGuid});

abstract class CloudStorage {
  CloudStorage({
    @required this.saveGymnastics,
    @required this.saveWorkout,
    @required this.saveUser,
    @required this.loadUserWorkouts,
  });

  final SaveGymnastics saveGymnastics;
  final SaveWorkout saveWorkout;
  final PersistUser saveUser;
  final LoadUserWorkouts loadUserWorkouts;
}

class MyDatabase implements CloudStorage {
  FirestoreDatabase firestoreDatabase = FirestoreDatabase();

  @override
  SaveGymnastics get saveGymnastics => firestoreDatabase.saveGymnastics;

  @override
  SaveWorkout get saveWorkout => firestoreDatabase.saveWorkout;

  @override
  PersistUser get saveUser => firestoreDatabase.saveNotExistedUser;

  @override
  LoadUserWorkouts get loadUserWorkouts => firestoreDatabase.loadUserWorkouts;
}
