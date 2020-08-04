import 'package:flutter/material.dart';
import 'package:tryhard/models/gymnastics.dart';

//class DayUserWorkouts {
//  DayUserWorkouts({this.guid, this.dateTime, this.dayWorkouts});
//
//  final String guid;
//  final DateTime dateTime; //should be mm/dd/yyyy
//  final List<Workout> dayWorkouts;
//}

class Workout {
  Workout({this.guid, @required this.time, this.comment, @required this.gymnasticsList});

  final String guid;
  final DateTime time; // at the end it should the exact time, 10am, 3pm etc
  final String comment;
  final List<Gymnastics> gymnasticsList;

//  Workout copyWith({List<Gymnastics> gymnastics}) {
//    return Workout(dateTime: dateTime, gymnasticsList: gymnastics);
//  }
}

class AllUserWorkouts {
  AllUserWorkouts({@required this.dayWorkouts});

  final Map<DateTime, List<Workout>> dayWorkouts;
}
