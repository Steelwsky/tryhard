//enum Exercises { hands, body, legs }

import 'package:flutter/cupertino.dart';

class Workout {
  Workout({@required this.dateTime, @required this.gymnasticsList});

  final DateTime dateTime;
  final List<Gymnastics> gymnasticsList;
}

class GymnasticsList {
  GymnasticsList({this.gymnasticsList});

  final List<Gymnastics> gymnasticsList;
}

class Gymnastics {
  Gymnastics({this.exercise, this.isPyramid, this.enteredWeightSetsRepeats, this.timeForRest, this.comment});

  final String exercise;
  final bool isPyramid;
  final Map<int, WeightSetsRepeats> enteredWeightSetsRepeats;
  final Duration timeForRest;
  final String comment;
}

class WeightSetsRepeats {
  WeightSetsRepeats({this.weight, this.sets, this.repeats});

  final String weight;
  final String sets;
  final String repeats;
}
