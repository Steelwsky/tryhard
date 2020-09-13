import 'package:flutter_test/flutter_test.dart';
import 'package:tryhard/firestore/cloud_storage.dart';
import 'package:tryhard/models/workout.dart';

void main() {
  group('Loading data from firestore', () {
    test('data successfully received', () async {});

    test('data ', () async {});
  });
}

class FakeDatabase implements CloudStorage {
  final Future<List<Workout>> fakeWorkoutList = Future.value([]);

  @override
  get loadUserWorkouts => ({String userGuid}) => fakeWorkoutList;

  @override
  get saveGymnastics => throw UnimplementedError();

  @override
  get saveUser => throw UnimplementedError();

  @override
  get saveWorkout => throw UnimplementedError();
}
