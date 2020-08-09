import 'package:flutter/material.dart';
import 'package:tryhard/models/gymnastics.dart';

class Workout {
  Workout({this.guid, @required this.time, this.comment, @required this.gymnasticsList});

  final String guid;
  final DateTime time; // at the end it should the exact time, 10am, 3pm etc
  final String comment;
  final List<Gymnastics> gymnasticsList;

  Workout copyWith({String copyGuid, DateTime copyTime, String copyComment, List<Gymnastics> copyGymnastics}) {
    if (guid != null) {
      return Workout(guid: copyGuid, time: time, comment: comment, gymnasticsList: gymnasticsList);
    }
    if (time != null) {
      return Workout(guid: guid, time: copyTime, comment: comment, gymnasticsList: gymnasticsList);
    }
    if (comment != null) {
      return Workout(guid: guid, time: time, comment: copyComment, gymnasticsList: gymnasticsList);
    } else
      return Workout(guid: guid, time: time, comment: copyComment, gymnasticsList: copyGymnastics);
  }
}

class AllUserWorkouts {
  AllUserWorkouts({@required this.dayWorkouts});

  final Map<DateTime, List<Workout>> dayWorkouts;
}

