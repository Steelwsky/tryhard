import 'package:flutter/material.dart';
import 'package:tryhard/firestore/cloud_storage.dart';
import 'package:tryhard/models/gymnastics.dart';
import 'package:tryhard/models/user.dart';
import 'package:tryhard/models/workout.dart';
import 'package:uuid/uuid.dart';

class WorkoutController {
  WorkoutController({this.myDatabase}) {
    print('workoutController');
  }

  ValueNotifier<AllUserWorkouts> allUserWorkouts =
      ValueNotifier(AllUserWorkouts(guid: '', userGuid: '', dayWorkouts: {}));

  ValueNotifier<List<Workout>> dayWorkouts = ValueNotifier([]);

  ValueNotifier<Workout> workout = ValueNotifier(Workout(time: null, gymnasticsList: []));

  final CloudStorage myDatabase;

  String _createNewUuid() => Uuid().v4();

  void linkUserToWorkouts(User user) {
    allUserWorkouts.value = AllUserWorkouts(
      guid: allUserWorkouts.value.guid,
      userGuid: user.uid,
      dayWorkouts: allUserWorkouts.value.dayWorkouts,
    );
  }

  DateTime _getDateFromWorkout(DateTime dt) {
    print('dt: ${DateTime(dt.year, dt.month, dt.day)}');
    return DateTime(dt.year, dt.month, dt.day);
  }

  void changeDayWorkoutList(DateTime day) {
    dayWorkouts.value = allUserWorkouts.value.dayWorkouts[_getDateFromWorkout(day)];
    if (dayWorkouts.value == null) {
      dayWorkouts.value = [];
    }
    print('day: $day');
  }

  void setWorkout(Workout wo) {
    print('setWorkout: guid is ${wo.guid}');
    workout.value = Workout(
      guid: wo.guid,
      time: wo.time,
      comment: wo.comment,
      gymnasticsList: wo.gymnasticsList,
    );
  }

  void createWorkout({DateTime dateTime}) {
    print('create: $dateTime');
    workout.value = Workout(
      guid: _createNewUuid(),
      time: DateTime(dateTime.year, dateTime.month, dateTime.day, 9, 0),
      comment: '',
      gymnasticsList: [],
    );
    print('guid is ${workout.value.guid}, workout: ${workout.value}');

    dayWorkouts.value.add(workout.value);
  }

  void createNewWorkoutToCalendar(DateTime date) {
    createWorkout(dateTime: date);
    _addWorkoutToADay();
  }

// creating new empty workout day and insert in in allUserWorkouts
  void _addWorkoutToADay() {
    _updateLocalAllUserWorkouts();
  }

  void saveTimeWorkoutBegins(DateTime time) {
    Workout _workout = workout.value;
    print('_workout guid: ${_workout.guid}');
    workout.value = Workout(
        guid: workout.value.guid,
        time: time,
        comment: workout.value.comment,
        gymnasticsList: workout.value.gymnasticsList);
    print('saveTimeWorkoutBegins: ${workout.value.time}, ${workout.value.guid}');

    _updateLocalDayWorkouts();
    _updateLocalAllUserWorkouts();
  }

  void saveComment({String comment}) {
    workout.value = Workout(
        guid: workout.value.guid,
        time: workout.value.time,
        comment: comment,
        gymnasticsList: workout.value.gymnasticsList);
    print('comment: ${workout.value.comment}');

    _updateLocalDayWorkouts();
    _updateLocalAllUserWorkouts();
  }

  void addGymnasticsToWorkout({Gymnastics gymnastics}) async {
    print(
        'addGymnasticsToWorkout: ${gymnastics.exercise} and ${gymnastics.comment} workoutGuid: ${gymnastics.workoutGuid}');
    final _gymnasticsList = workout.value.gymnasticsList;
    _gymnasticsList.add(gymnastics);
    workout.value = Workout(
        guid: workout.value.guid,
        comment: workout.value.comment,
        time: workout.value.time,
        gymnasticsList: _gymnasticsList);
    print(workout.value.gymnasticsList);

    _updateLocalDayWorkouts();
    _updateLocalAllUserWorkouts();
    _sortByTime();

    await myDatabase.saveGymnastics(gymnastics: gymnastics, userGuid: allUserWorkouts.value.userGuid);
    await myDatabase.saveWorkout(workout: workout.value, userGuid: allUserWorkouts.value.userGuid);
  }

  void updateExistedWorkoutByGymnastics({Gymnastics gymnastics}) async {
    print('overwriteExistedGymnastics. guid: ${gymnastics.guid}, workoutGuid: ${gymnastics.workoutGuid}');
    workout.value = Workout(
        guid: workout.value.guid,
        time: workout.value.time,
        gymnasticsList: workout.value.gymnasticsList.map((e) {
          if (e.guid == gymnastics.guid) {
            e = gymnastics;
          }
          return e;
        }).toList());
    print('overwriteExistedGymnastics. date: ${workout.value.time}');

    _updateLocalDayWorkouts();
    _sortByTime();

    await myDatabase.saveGymnastics(gymnastics: gymnastics, userGuid: allUserWorkouts.value.userGuid);
    await myDatabase.saveWorkout(workout: workout.value, userGuid: allUserWorkouts.value.userGuid);
  }

  void _updateLocalAllUserWorkouts() {
    final Map<DateTime, List<Workout>> _mapDaysWorkouts = allUserWorkouts.value.dayWorkouts;
    _mapDaysWorkouts[_getDateFromWorkout(workout.value.time)] = dayWorkouts.value;
    allUserWorkouts.value = AllUserWorkouts(
      guid: _createNewUuid(),
      userGuid: allUserWorkouts.value.userGuid,
      dayWorkouts: _mapDaysWorkouts,
    );
  }

  void _updateLocalDayWorkouts() {
    dayWorkouts.value = dayWorkouts.value.map((e) {
      if (e.guid == workout.value.guid) {
        return e = workout.value;
      }
      return e;
    }).toList();

    //todo save workouts list for map
  }


  //TODO
  void _sortByTime() {}
}
