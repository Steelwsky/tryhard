import 'package:flutter/material.dart';
import 'package:tryhard/models/gymnastics.dart';
import 'package:tryhard/utils/timestamp_helper.dart';

class Workout {
  Workout({this.guid, @required this.time, this.comment, @required this.gymnasticsList});

  final String guid;
  final DateTime time;
  final String comment;
  final List<Gymnastics> gymnasticsList;

  Workout.fromJson({@required Map<String, dynamic> json, List<Gymnastics> gymnasticsList})
      : guid = json['guid'] != null ? json['guid'] : '',
        time = json['time'] != null ? timestampHelper(timestamp: json['time']) : '',
        comment = json['comment'] != null ? json['comment'] : '',
        gymnasticsList = gymnasticsList != null ? gymnasticsList : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['guid'] = this.guid;
    data['time'] = this.time;
    data['comment'] = this.comment;
    return data;
  }

  List<Gymnastics> getListGymnastics(Future<List<Gymnastics>> gymnastics) {
    final List<Gymnastics> _list = [];
    gymnastics.then((value) => _list.addAll(value));
    return _list;
  }
}

class AllUserWorkouts {
  AllUserWorkouts({@required this.userGuid, @required this.dayWorkouts});

//  final String guid;      // TODO 27.08 -- seems useless
  final String userGuid;
  final Map<DateTime, List<Workout>> dayWorkouts;

  //// seems useless
  Map<String, dynamic> toJson() {
    print('userGuid: $userGuid');
//    print('guid: $guid, userGuid: $userGuid');
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    }
    return _list;
  }


}
