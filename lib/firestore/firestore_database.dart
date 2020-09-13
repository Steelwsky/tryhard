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
    final bool userExists = await _isObjectExists(obj: user, userGuid: user.uid);

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
      print('user is already saved');
  }

  Future<void> saveGymnastics({
    @required Gymnastics gymnastics,
    @required String userGuid,
  }) async {
    final bool gymnasticsExists = await _isObjectExists(obj: gymnastics, userGuid: userGuid);

    if (!gymnasticsExists) {
      _createGymnastics(gymnastics: gymnastics, userGuid: userGuid);
    } else {
      _updateExistedGymnastics(gymnastics: gymnastics, userGuid: userGuid);
    }
  }

  void _createGymnastics({
    @required Gymnastics gymnastics,
    @required String userGuid,
  }) {
    databaseFirestore
        .collection('users')
        .document(userGuid)
        .collection('workouts')
        .document(gymnastics.workoutGuid)
        .collection('gymnastics')
        .document('${gymnastics.guid}')
        .setData(gymnastics.toJson());
    print('saved gymnastics to firestore');
  }

  Future<void> saveWorkout({
    @required Workout workout,
    @required String userGuid,
  }) async {
    final bool workoutExists = await _isObjectExists(obj: workout, userGuid: userGuid);

    if (!workoutExists) {
      _createWorkout(workout: workout, userGuid: userGuid);
    } else {
      _updateExistedWorkout(
        workout: workout,
        userGuid: userGuid,
      );
    }
  }

  void _createWorkout({
    @required Workout workout,
    @required String userGuid,
  }) {
    databaseFirestore
        .collection('users')
        .document(userGuid)
        .collection('workouts')
        .document(workout.guid)
        .setData(workout.toJson());
  }

  Future<void> _updateExistedGymnastics({
    @required Gymnastics gymnastics,
    @required String userGuid,
  }) async {
    databaseFirestore
        .collection('users')
        .document(userGuid)
        .collection('workouts')
        .document(gymnastics.workoutGuid)
        .collection('gymnastics')
        .document(gymnastics.guid)
        .setData(gymnastics.toJson());
  }

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

  Future<bool> _isObjectExists({dynamic obj, @required String userGuid}) async {
    bool isExists = false;
    if (obj is Workout) {
      isExists = (await databaseFirestore
              .collection('users')
              .document(userGuid)
              .collection('workouts')
              .document(obj.guid)
              .get())
          .exists;
      return isExists;
    } else if (obj is Gymnastics) {
      isExists = (await databaseFirestore
              .collection('users')
              .document(userGuid)
              .collection('workouts')
              .document(obj.workoutGuid)
              .collection('gymnastics')
              .document(obj.guid)
              .get())
          .exists;
      return isExists;
    } else if (obj is User) {
      isExists = (await databaseFirestore.collection('users').document(userGuid).get()).exists;
      return isExists;
    }
    return isExists;
  }

  //TODO gymnastics in some cases are not downloaded!
  Future<List<Workout>> loadUserWorkouts({@required String userGuid}) async {
    print('loadUserWorkouts: $userGuid');
    List<Workout> _listWorkouts = [];
    List<Gymnastics> _listGymnastics = [];

    final bool userExists = await _isObjectExists(userGuid: userGuid);

    if (userExists) {
      _listGymnastics = await _loadAllUserGymnastics(userGuid: userGuid);
      _listWorkouts =
      await Future.delayed(Duration(seconds: 1)).then((value) =>
          _loadAllUserWorkouts(
            userGuid: userGuid,
            listGymnastics: _listGymnastics,
          ));
    }
    //MUST BE 13

    return _listWorkouts;
  }

  Future<List<Gymnastics>> _loadAllUserGymnastics({@required String userGuid}) async {
    print('##_loadAllUserGymnastics call');
    final List<Gymnastics> _listGymnastics = [];

    await databaseFirestore
        .collection('users')
        .document(userGuid)
        .collection('workouts')
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((e) async {
        await e.reference.collection('gymnastics').getDocuments().then((value) {
          value.documents.forEach((element) {
            // print('GYMNASTICS::::${element.data}');
            _listGymnastics.add(Gymnastics.fromJson(element.data));
          });
          print('_loadAllUserGymnastics()####, forEach(element), '
              'listGymnastics length: ${_listGymnastics.length}');
        });
      });
    });
    return _listGymnastics;
  }

  Future<List<Workout>> _loadAllUserWorkouts({
    @required String userGuid,
    @required List<Gymnastics> listGymnastics,
  }) async {
    List<Workout> _listWorkouts = [];
    print('##_loadAllUserWorkouts call');
    print('_loadAllUserWorkouts, listGymnastics length: ${listGymnastics.length}');
    _listWorkouts = await databaseFirestore
        .collection('users')
        .document(userGuid)
        .collection('workouts')
        .getDocuments()
        .then((snapshot) => snapshot.documents.map((e) {
              print('_loadAllUserWorkouts()////, listGymnastics.length: ${listGymnastics.length}');
              return Workout.fromJson(
                json: e.data,
                gymnasticsList: listGymnastics
                    .where((element) => element.workoutGuid == e.data['guid'])
                    .toList(),
              );
            }).toList());
    return _listWorkouts;
  }
}
