enum Exercises { hands, body, legs }

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
