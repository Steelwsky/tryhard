import 'package:cloud_firestore/cloud_firestore.dart';
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

/* TODO i need to separately save data to firestore
    my data:
        1. Users (guid)
        2.
        3. Map<DateTime, List<Workout>> (String, guidWorkout) ???.
        4. Workout (guid, comment, guidGymnastics)
        5. Gymnastics(guid, exercise, isPyramid, Map<int, WSR>, comment)
        6.

 */

  Map<int, WeightSetsRepeats> _mapWSR(Gymnastics gymnastics) {}

  Future<void> saveGymnastics(Gymnastics gymnastics, User user) async {
    databaseFirestore.collection('gymnastics').document('${gymnastics.guid}').setData(gymnastics.toJson());
    print('saved');
  }

  Future<void> saveWorkout(Workout workout) async {
    databaseFirestore.collection('workouts').document('${workout.guid}').setData(workout.toJson());
  }

//Map toJson(){
//  return {
//    "name" : name,
//    "materie" : materie
//  };
//}

//final String guid;
//  final String exercise;
//  final bool isPyramid;
//  final Map<int, WeightSetsRepeats> enteredWeightSetsRepeats;
//  final Duration timeForRest;
//  final String comment;

//  Future<void> addNewUserWorkouts(AllUserWorkouts allUserWorkouts, User user) async {
//    databaseFirestore.collection('allUserWorkouts').document().setData({
//      'id': allUserWorkouts,
//
//    });
//  }

//  Future<void> updateExistedUserWorkouts(AllUserWorkouts allUserWorkouts) async {
//    databaseFirestore.collection('allUserWorkouts').document().setData({
//      'id': allUserWorkouts,
//      'title': item.title,
//      'description': item.description,
//      'link': item.link,
//    });
}

//databaseFirestore.collection('usersAndWorkouts').document().setData({
//      'user': user.uid,
//      'allUserWorkouts': {
//        'date': allUserWorkouts.dayWorkouts.keys.first,
//        'workouts' : [ Workout(guid:'222', comment: 'comment', time: null, gymnasticsList: null)]
//      }
//
//    });

//    databaseFirestore.collection('gymnastics').document().setData({
//      'guid': gymnastics.guid,
//      'isPyramid': gymnastics.isPyramid,
//      'wsr': {
//        'index': 1,
//        'wsr' : {
//
//          'w': gymnastics.enteredWeightSetsRepeats[0].weight,
//          's': gymnastics.enteredWeightSetsRepeats[0].sets,
//          'r': gymnastics.enteredWeightSetsRepeats[0].repeats,
//        },
//      },
//      'time': gymnastics.restTime.toString(),
//      'comment': gymnastics.comment
//    });
