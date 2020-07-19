enum Exercises { hands, body, legs }

class Gymnastics {
  Gymnastics({this.exercise, this.isPyramid, this.listSetsRepeats, this.timeForRest, this.comment});

  final String exercise;
  final bool isPyramid;
  final List<WeightSetsRepeats> listSetsRepeats;
  final Duration timeForRest;
  final String comment;
}

class WeightSetsRepeats {
  WeightSetsRepeats({this.weight, this.sets, this.repeats});

  final double weight;
  final int sets;
  final int repeats;
}
