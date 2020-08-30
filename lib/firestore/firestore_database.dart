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

  Future<bool> _isObjectExists({@required dynamic obj, @required String userGuid}) async {
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

  Future<List<Workout>> loadUserWorkouts({@required String userGuid}) async {
    // DocumentReference documentReference = Firestore.instance.collection('users').document(userGuid);
    print('loadUserWorkouts: $userGuid');
    List<Workout> list = [];
    list = await databaseFirestore
        .collection('users')
        .document(userGuid)
        .collection('workouts')
        .getDocuments()
        .then((snapshot) => snapshot.documents
            .map((e) => Workout.fromJson(
                  json: e.data,
                  gymnasticsList: e.reference.collection('gymnastics').getDocuments().then(
                        (value) => value.documents.map((e) => Gymnastics.fromJson(e.data)).toList(),
                      ),
                ))
            .toList());
    print('after loadUserWorkouts');
    return list;
  }

//map((e) {
//              list.add(Workout.fromJson(e.data));
//            }).toList());

//  Future<AllUserWorkouts> loadUserWorkouts({@required String userGuid}) async {
//    DocumentReference documentReference = Firestore.instance.collection('users').document(userGuid);
//    print('loadUserWorkouts: $userGuid');
//    Future<AllUserWorkouts> allUserWorkouts = Future.value(AllUserWorkouts(userGuid: '', dayWorkouts: null));
//    List<String> list = [];
////    final Map<DateTime, List<Workout>> map = {};
//    list = await databaseFirestore
//        .collection('users')
//        .document(userGuid)
//        .collection('workouts')
//        .getDocuments()
//        .then((snapshot) => snapshot.documents.map((e) {
//      AllUserWorkouts(userGuid: d., dayWorkouts: null)
//    });
//        print('after loadUserWorkouts');
//    print(list);
//    return allUserWorkouts;
//  }
}

// Future<Map<String, int>> receivingParentsAndChildrenAmount() async {
//    var listOfParentsAndChildren = await retrieveParentsIds();
//    int amount;
//    Map<String, int> myMap = {};
//    for (var n in listOfParentsAndChildren) {
//      await databaseFirestore.collection('children').where('parentId', isEqualTo: n).getDocuments().then((event) {
//        amount = event.documents.length;
//        print(event.documents.length);
//        myMap[n] = amount;
//      });
//    }
//    return myMap;
//  }

// Future<List<String>> retrieveParentsIds() async {
//    final Iterable<String> myParentsList = await databaseFirestore
//        .collection('savedStaff')
//        .getDocuments()
//        .then((onValue) => onValue.documents)
//        .then((document) => document.map((d) => d.data['id']));
//    print(myParentsList.toList());
//    return myParentsList.toList();
//  }

// Stream<List<ChildModel>> getParentsChildren(String parentId) {
//    return databaseFirestore.collection('children').where('parentId', isEqualTo: parentId).snapshots().map((convert) =>
//        convert.documents
//            .map((item) => ChildModel(
//                id: item.data['id'],
//                parentId: item.data['parentId'],
//                lastName: item.data['lastName'],
//                firstName: item.data['firstName'],
//                middleName: item.data['middleName'],
//                birthDay: item.data['birthDay']))
//            .toList());
//  }
