import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tryhard/models/workout.dart';

class FirestoreDatabase {
  FirestoreDatabase._();

  static final FirestoreDatabase _instance = FirestoreDatabase._();

  factory FirestoreDatabase() {
    return _instance;
  }

  final databaseFirestore = Firestore.instance;

  Future<void> saveUserWorkouts(AllUserWorkouts allUserWorkouts) async {
// todo if allUserWorkouts not found in firestore, then create new. if not, then update existed one
//    databaseFirestore.collection('allUserWorkouts').document().
  }

  Future<void> addNewUserWorkouts(AllUserWorkouts allUserWorkouts) async {
    databaseFirestore.collection('allUserWorkouts').document().setData({
      'id': allUserWorkouts,
    });
  }

//  Future<void> updateExistedUserWorkouts(AllUserWorkouts allUserWorkouts) async {
//    databaseFirestore.collection('allUserWorkouts').document().setData({
//      'id': allUserWorkouts,
//      'title': item.title,
//      'description': item.description,
//      'link': item.link,
//    });
}
