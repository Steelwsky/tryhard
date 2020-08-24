import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tryhard/models/gymnastics.dart';
import 'package:tryhard/models/user.dart';
import 'package:tryhard/models/workout.dart';

class FirestoreDatabase {
  FirestoreDatabase._();

  static final FirestoreDatabase _instance = FirestoreDatabase._();

  factory FirestoreDatabase() {
    return _instance;
  }

  final databaseFirestore = Firestore.instance;

  Future<void> saveNotExistedUser({@required User user}) async {
    final bool userExists = (await databaseFirestore.collection('users').document(user.uid).get()).exists;

    if (!userExists) {
      databaseFirestore.collection('users').document(user.uid).setData({
        'firstName': user.firstName,
        'secondName': user.secondName,
        'email': user.email,
        'phoneNumber': user.phoneNumber,
        'photo': user.photo,
      });
      print('user is saved');
    } else
      print('already saved');
  }

  Future<void> saveAllUserWorkouts({@required AllUserWorkouts allUserWorkouts}) async {
//    final bool uwExists = (await databaseFirestore
//            .collection('users')
//            .document(allUserWorkouts.userGuid)
//            .collection('allWorkouts')
//            .document(allUserWorkouts.guid)
//            .get())
//        .exists;
//    if (!uwExists) {
//      _createAllUserWorkouts(allUserWorkouts);
//    } else {
//      _updateAllUserWorkouts(allUserWorkouts);
//    }
  }

  Future<void> _createAllUserWorkouts(AllUserWorkouts allUserWorkouts) async {
//    databaseFirestore.collection('allUserWorkouts').document(allUserWorkouts.guid).setData(allUserWorkouts.toJson());
    print('_createAllUserWorkouts');
  }

  Future<void> _updateAllUserWorkouts(AllUserWorkouts allUserWorkouts) async {
//    databaseFirestore.collection('allUserWorkouts').document(allUserWorkouts.guid).updateData(allUserWorkouts.toJson());
    print('_updateAllUserWorkouts');
  }

  Future<void> saveGymnastics({
    @required Gymnastics gymnastics,
    @required String userGuid,
  }) async {
    databaseFirestore
        .collection('users')
        .document(userGuid)
        .collection('workouts')
        .document(gymnastics.workoutGuid)
        .collection('gymnastics')
        .document('${gymnastics.guid}')
        .setData(gymnastics.toJson());
    print('saved');
  }

  Future<void> saveWorkout({
    @required Workout workout,
    @required String userGuid,
  }) async {
    final bool workoutExists = (await databaseFirestore
            .collection('users')
            .document(userGuid)
            .collection('workouts')
            .document(workout.guid)
            .get())
        .exists;

    if (!workoutExists) {
      databaseFirestore
          .collection('users')
          .document(userGuid)
          .collection('workouts')
          .document(workout.guid)
          .setData(workout.toJson());
    } else {
      _updateExistedWorkout(
        workout: workout,
        userGuid: userGuid,
      );
    }
  }

  //TODO bad function!
  Future<void> _updateExistedWorkout({
    @required Workout workout,
    @required String userGuid,
  }) async {
    databaseFirestore
        .collection('users')
        .document(userGuid)
        .collection('workouts')
        .document(workout.guid)
        .updateData(workout.toJson());
  }
}
