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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['guid'] = this.guid;
    data['time'] = this.time;
    data['comment'] = this.comment;
    data['gymnasticsList'] = _getGymnasticsJson();
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
  AllUserWorkouts({@required this.dayWorkouts});

  final Map<DateTime, List<Workout>> dayWorkouts;
}

//Workout copyWith({String copyGuid, DateTime copyTime, String copyComment, List<Gymnastics> copyGymnastics}) {
//    if (guid != null) {
//      return Workout(guid: copyGuid, time: time, comment: comment, gymnasticsList: gymnasticsList);
//    }
//    if (time != null) {
//      return Workout(guid: guid, time: copyTime, comment: comment, gymnasticsList: gymnasticsList);
//    }
//    if (comment != null) {
//      return Workout(guid: guid, time: time, comment: copyComment, gymnasticsList: gymnasticsList);
//    } else
//      return Workout(guid: guid, time: time, comment: copyComment, gymnasticsList: copyGymnastics);
//  }