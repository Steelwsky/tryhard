import 'package:tryhard/models/gymnastics.dart';
import 'package:tryhard/models/workout.dart';

import 'firestore_database.dart';

typedef SaveGymnastics = Future<void> Function(Gymnastics gymnastics);
typedef SaveWorkout = Future<void> Function(Workout workout);
typedef UpdateExistedWorkout = Future<void> Function(Workout workout);
typedef SaveUser = Future<void> Function(String guid);

abstract class CloudStorage {
  CloudStorage({this.saveGymnastics, this.saveWorkout, this.updateExistedWorkout, this.saveUser});

  final SaveGymnastics saveGymnastics;
  final SaveWorkout saveWorkout;
  final UpdateExistedWorkout updateExistedWorkout;
  final SaveUser saveUser;
}

class MyDatabase implements CloudStorage {
  FirestoreDatabase firestoreDatabase = FirestoreDatabase();

  @override
  SaveGymnastics get saveGymnastics => firestoreDatabase.saveGymnastics;

  @override
  SaveWorkout get saveWorkout => firestoreDatabase.saveWorkout;

  @override
  UpdateExistedWorkout get updateExistedWorkout => firestoreDatabase.updateExistedWorkout;

  @override
  SaveUser get saveUser => firestoreDatabase.saveNotExistedUser;
}
