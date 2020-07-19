import 'package:flutter/material.dart';
import 'package:tryhard/models/gymnastics.dart';

class GymnasticsController {
  ValueNotifier<Gymnastics> gymnastics = ValueNotifier(Gymnastics(
    exercise: '',
    isPyramid: false,
    listSetsRepeats: [],
    timeForRest: Duration(minutes: 0, seconds: 0),
    comment: '',
  ));

  void saveGymnastics() {}

  void addLineSetsRepeats() {}
}
