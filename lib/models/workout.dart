import 'package:flutter/material.dart';
import 'package:tryhard/models/gymnastics.dart';

class Workout {
  Workout({this.guid, @required this.time, this.comment, @required this.gymnasticsList});

  final String guid;
  final DateTime time; // at the end it should the exact time, 10am, 3pm etc
  final String comment;
  final List<Gymnastics> gymnasticsList;

//TODO
//  Workout.fromJson(Map<String, dynamic> json, this.guid, this.time, this.comment, this.gymnasticsList) {
//    guid = json['title'];
//    time = json['logo'];
//    comment = json['url'];
//    gymnasticsList = json['imageArray'].cast<String>();
//  }
//
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['guid'] = this.guid;
    data['time'] = this.time;
    data['comment'] = this.comment;
//    data['gymnasticsList'] = [];
    return data;
  }

  List<Map<String, dynamic>> _getGymnasticsJson() {
    List<Map<String, dynamic>> _list = [];
    gymnasticsList.forEach((element) {
      _list.add(element.toJson());
    });
    return _list;
  }
}

class AllUserWorkouts {
  AllUserWorkouts({this.guid, @required this.userGuid, @required this.dayWorkouts});

  final String guid; //todo implement
  final String userGuid;
  final Map<DateTime, List<Workout>> dayWorkouts;

  //// seems useless
  Map<String, dynamic> toJson() {
    print('guid: $guid, userGuid: $userGuid');
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['guid'] = guid;
    data['userGuid'] = userGuid;
    data['userWorkouts'] = _getDayWorkouts();
    return data;
  }

  List<Map<String, dynamic>> _getDayWorkouts() {
    final List<Map<String, dynamic>> _list = [];

    final Map<String, dynamic> jsonDayWorkouts = {};
    dayWorkouts.forEach((key, value) {
      jsonDayWorkouts['$key'] = _getWorkoutsGuid(key.toString());
      _list.add(jsonDayWorkouts);
    });
    return _list;
  }

  List<String> _getWorkoutsGuid(String key) {
    List<String> _list = [];
    if (dayWorkouts.containsKey(key)) {
      print('containsKey');
      dayWorkouts[key].forEach((element) {
        _list.add(element.guid);
      });
    } else {
      print('foooo');
    }
    return _list;
  }

//  Map<String, dynamic> _getDayWorkouts() {
//    Map<String, dynamic> _dayWorkouts = {};
//    List<Map<String, dynamic>> _list = [];
//    dayWorkouts.forEach((key, value) {
//      value.forEach((element) {
//        _list.add(element.toJson());
//      });
//      _dayWorkouts['$key'] = _list;
//    });
//    return _dayWorkouts;
//  }

}
