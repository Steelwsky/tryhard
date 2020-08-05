import 'package:flutter/material.dart';
import 'package:tryhard/models/gymnastics.dart';
import 'package:tryhard/models/workout.dart';
import 'package:uuid/uuid.dart';

class WorkoutController {
  ValueNotifier<AllUserWorkouts> allUserWorkouts = ValueNotifier(AllUserWorkouts(dayWorkouts: {}));

  ValueNotifier<List<Workout>> dayWorkouts = ValueNotifier([]); //TODO USE IT

  ValueNotifier<Workout> workout = ValueNotifier(Workout(time: null, gymnasticsList: []));

  String _getUuidFromHash() => Uuid().v4();

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
      guid: _getUuidFromHash(),
      time: DateTime(dateTime.year, dateTime.month, dateTime.day, 9, 0),
      comment: '',
      gymnasticsList: [],
    );
    print('guid is ${workout.value.guid}, workout: ${workout.value}');

    dayWorkouts.value.add(workout.value);
  }

  void createAndAddNewWorkoutToCalendar(DateTime date) {
    createWorkout(dateTime: date);
    _addWorkoutToADay(date);
  }

// creating new empty workout day and insert in in allUserWorkouts
  void _addWorkoutToADay(DateTime date) {
    _updateAllUserWorkouts();
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

    _updateDayWorkouts();
    _updateAllUserWorkouts();
  }

  void saveComment({String comment}) {
    workout.value = Workout(
        guid: workout.value.guid,
        time: workout.value.time,
        comment: comment,
        gymnasticsList: workout.value.gymnasticsList);
    print('comment: ${workout.value.comment}');

    _updateDayWorkouts();
    _updateAllUserWorkouts();
  }

  void addGymnasticsToWorkout({Gymnastics gymnastics}) {
    print('addGymnasticsToWorkout: ${gymnastics.exercise} and ${gymnastics.comment}');
    final _gymnasticsList = workout.value.gymnasticsList;
    _gymnasticsList.add(gymnastics);
    workout.value = Workout(guid: workout.value.guid, time: workout.value.time, gymnasticsList: _gymnasticsList);
    print(workout.value.gymnasticsList);
  }

  void overwriteExistedGymnastics({Gymnastics gymnastics}) {
    print('overwriteExistedGymnastics. hash: ${gymnastics.guid}');
    workout.value = Workout(
        guid: workout.value.guid,
        time: workout.value.time,
        gymnasticsList: workout.value.gymnasticsList.map((e) {
          if (e.guid == gymnastics.guid) {
            e = gymnastics;
          }
          return e;
        }).toList());
  }

  void _updateAllUserWorkouts() {
    final Map<DateTime, List<Workout>> _mapDaysWorkouts = allUserWorkouts.value.dayWorkouts;
    _mapDaysWorkouts[_getDateFromWorkout(workout.value.time)] = dayWorkouts.value;
    allUserWorkouts.value = AllUserWorkouts(dayWorkouts: _mapDaysWorkouts);
  }

  void _updateDayWorkouts() {
    dayWorkouts.value = dayWorkouts.value.map((e) {
      if (e.guid == workout.value.guid) {
        return e = workout.value;
      }
      return e;
    }).toList();
  }
}
