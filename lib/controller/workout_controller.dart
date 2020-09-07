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
      ValueNotifier(AllUserWorkouts(userGuid: null, dayWorkouts: null));

  // ValueNotifier<AllUserWorkouts> allUserWorkouts =
  // ValueNotifier(AllUserWorkouts(userGuid: '', dayWorkouts: {}));

  ValueNotifier<List<Workout>> dayWorkouts = ValueNotifier([]);

  ValueNotifier<Workout> workout = ValueNotifier(Workout(time: null, gymnasticsList: []));

  final CloudStorage myDatabase;

  String _createNewUuid() => Uuid().v4();

  // helper. all input data converting to yyyy-mm-dd with time 00:00:00
  DateTime _getOnlyDate({@required DateTime date}) {
    return DateTime(date.year, date.month, date.day);
  }

  void changeDayWorkoutList({@required DateTime day}) {
    dayWorkouts.value = allUserWorkouts.value.dayWorkouts[_getOnlyDate(date: day)];
    if (dayWorkouts.value == null) {
      dayWorkouts.value = [];
    }
    print('day: $day');
  }

  void setWorkout({@required Workout w}) {
    print('setWorkout: guid is ${w.guid}');
    workout.value = Workout(
      guid: w.guid,
      time: w.time,
      comment: w.comment,
      gymnasticsList: w.gymnasticsList,
    );
  }

  void _createWorkout({@required DateTime dateTime}) {
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

  void createNewWorkoutToCalendar({@required DateTime date}) {
    _createWorkout(dateTime: date);
    _addWorkoutToADay();
  }

// creating new empty workout day and insert in in allUserWorkouts
  void _addWorkoutToADay() {
    _updateLocalAllUserWorkouts();
  }

  void saveTimeWorkoutBegins({@required DateTime time}) {
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
    print('addGymnasticsToWorkout: ${gymnastics.exercise} and '
        '${gymnastics.comment} workoutGuid: ${gymnastics.workoutGuid}');
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
    print('overwriteExistedGymnastics. guid: ${gymnastics.guid}, '
        'workoutGuid: ${gymnastics.workoutGuid}');
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
    _mapDaysWorkouts[_getOnlyDate(date: workout.value.time)] = dayWorkouts.value;
    allUserWorkouts.value = AllUserWorkouts(
//      guid: _createNewUuid(),
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
  }

  // after user identified via google, we need to link
  // that user and download all user's data from firestore.
  Future<void> downloadUserWorkouts({@required User user}) async {
    print('linkUserToWorkouts');
    await loadAndDeserializeData(userGuid: user.uid);
  }

  //TODO данные не всегда все показываются
  Future<void> loadAndDeserializeData({@required String userGuid}) async {
    print('loadAndDeserializeData, userGuid: $userGuid');
    final allWorkouts = await myDatabase.loadUserWorkouts(userGuid: userGuid);

    if (allWorkouts != null) {
      Map<DateTime, List<Workout>> _finalMap = _mappingAllWorkouts(originalList: allWorkouts);
      allUserWorkouts.value = AllUserWorkouts(userGuid: userGuid, dayWorkouts: _finalMap);
    }
  }

  // putting data from firestore to local notifiers
  Map<DateTime, List<Workout>> _mappingAllWorkouts({@required List<Workout> originalList}) {
    List<DateTime> _dateWorkoutsList = [];
    originalList.forEach((element) => _dateWorkoutsList.add(_getOnlyDate(date: element.time)));

    // converting to set and then back to the list. deleting copies of the same dates
    _dateWorkoutsList = [
      ...{..._dateWorkoutsList}
    ];

    //add to _map workouts via existing dates
    Map<DateTime, List<Workout>> _map = {
      for (var v in _dateWorkoutsList)
        v: originalList.where((element) => _getOnlyDate(date: element.time) == v).toList()
    };

    _map.forEach((key, value) {
      _map[key].forEach((element) {
        _printer(element);
      });
    });

    print('_mappingAllWorkouts done');
    return _map;
  }

  void _printer(Workout workout) {
    print('printer method, workouts gymnasticsList length: ${workout.gymnasticsList.length}');
    workout.gymnasticsList.forEach((element) {
      print(
          'GYMNASTICS::::::${element.guid}, ${element.restTime}, ${element.workoutGuid}, ${element
              .exercise} ');
      element.enteredWeightSetsRepeats.mapWsr.forEach((key, value) {
        print('KEY: $key, VALUE W: ${value.weight}, VALUE S: ${value.sets}, VALUE R: ${value.repeats}');
      });
    });
  }

  //TODO
  void _sortByTime() {
  }
}
