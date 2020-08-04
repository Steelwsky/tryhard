import 'package:flutter/material.dart';
import 'package:tryhard/models/gymnastics.dart';
import 'package:tryhard/models/workout.dart';
import 'package:uuid/uuid.dart';

class WorkoutController {
  WorkoutController() {
//    dayWorkouts.value = allUserWorkouts.value.dayWorkouts[_getDateFromWorkout(DateTime.now())];
  }

  ValueNotifier<AllUserWorkouts> allUserWorkouts = ValueNotifier(AllUserWorkouts(dayWorkouts: {}));

  ValueNotifier<List<Workout>> dayWorkouts = ValueNotifier([]); //TODO USE IT

  ValueNotifier<Workout> workout = ValueNotifier(Workout(time: null, gymnasticsList: []));

  String _getUuidFromHash() => Uuid().v4();

  DateTime _getDateFromWorkout(DateTime dt) {
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

  void addNewOrInsertToExistedWorkoutDay(DateTime date) {
    createWorkout(dateTime: date);
    allUserWorkouts.value.dayWorkouts.containsKey(date) ? _insertToExistedWorkoutDay(date) : _addNewWorkoutDay(date);
  }

// creating new empty workout day and insert in in allUserWorkouts
  void _addNewWorkoutDay(DateTime date) {
    print('add');
    final Map<DateTime, List<Workout>> _mapDaysWorkouts = allUserWorkouts.value.dayWorkouts;
    _mapDaysWorkouts[date] = dayWorkouts.value;
    allUserWorkouts.value = AllUserWorkouts(dayWorkouts: _mapDaysWorkouts);
  }

  void _insertToExistedWorkoutDay(DateTime date) {
    print('insert');
    final Map<DateTime, List<Workout>> _mapDaysWorkouts = allUserWorkouts.value.dayWorkouts;
    _mapDaysWorkouts[date] = dayWorkouts.value;

//    _mapDaysWorkouts.update(date, (value) {
////      value.add(workout.value);
//    dayWorkouts.value.add(value)
//      return value;
//    });

    allUserWorkouts.value = AllUserWorkouts(dayWorkouts: _mapDaysWorkouts);
  }

  // TODO
  void saveTimeWorkoutBegins(DateTime time) {
    workout.value = Workout(
        guid: workout.value.guid,
        time: time,
        comment: workout.value.comment,
        gymnasticsList: workout.value.gymnasticsList);
    print('saveTimeWorkoutBegins: ${workout.value.time}, ${workout.value.guid}');

//    allUserWorkouts.value = AllUserWorkouts(dayWorkouts: allUserWorkouts.value.dayWorkouts);

    final Map<DateTime, List<Workout>> _mapDaysWorkouts = allUserWorkouts.value.dayWorkouts;
    _mapDaysWorkouts[_getDateFromWorkout(workout.value.time)].forEach((element) {
      if (element.guid == workout.value.guid) {
        print('found');
        element = workout.value;
      }
    });
    allUserWorkouts.value = AllUserWorkouts(dayWorkouts: _mapDaysWorkouts);
  }

  // TODO
  void saveComment({String comment}) {
    workout.value = Workout(
        guid: workout.value.guid,
        time: workout.value.time,
        comment: comment,
        gymnasticsList: workout.value.gymnasticsList);
    print('comment: ${workout.value.comment}');
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

//    workoutList.value[8].gymnasticsList[2] = gymnastics; //todo how to find [8] and [2]
  }
}

// Future<void> addToHistory({RssItem item}) async {
//    if (await isNewsInHistory(uuid: item.guid) == false) {
//      myDatabase.addItem(item);
//      historyIdsNotifier.value = myDatabase.retrieveViewedItemIds();
//      preparedRssFeedNotifier.value = preparedRssFeedNotifier.value.toList().map((f) {
//        if (f.item.guid == item.guid) {
//          return f.copyWith(isViewed: true);
//        }
//        return f;
//      });
//    }
//  }
