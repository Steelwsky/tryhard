//enum Exercises { hands, body, legs }

class GymnasticsList {
  GymnasticsList({this.gymnasticsList});

  final List<Gymnastics> gymnasticsList;

  GymnasticsList copyWith({List<Gymnastics> gymnasticsList}) {
    return GymnasticsList(gymnasticsList: gymnasticsList);
  }
}

class Gymnastics {
  Gymnastics({this.guid, this.exercise, this.isPyramid, this.enteredWeightSetsRepeats, this.timeForRest, this.comment});

  final String guid;
  final String exercise;
  final bool isPyramid;
  final Map<int, WeightSetsRepeats> enteredWeightSetsRepeats;
  final Duration timeForRest;
  final String comment;

//  Gymnastics copyWith({
//    String guid,
//    String exercise,
//    bool isPyramid,
//    Map<int, WeightSetsRepeats> enteredWeightSetsRepeats,
//    Duration timeForRest,
//    String comment,
//  }) {
//    return Gymnastics(
//      exercise: exercise,
//      isPyramid: isPyramid,
//      enteredWeightSetsRepeats: enteredWeightSetsRepeats,
//      timeForRest: timeForRest,
//      comment: comment,
//    );
//  }
}

class WeightSetsRepeats {
  WeightSetsRepeats({this.weight, this.sets, this.repeats});

  final String weight;
  final String sets;
  final String repeats;
}
