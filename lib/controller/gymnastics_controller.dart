import 'package:flutter/material.dart';
import 'package:tryhard/models/gymnastics.dart';

class GymnasticsController {
  GymnasticsController() {
    gymnasticsList.value.add(Gymnastics(
      exercise: '111',
      isPyramid: false,
      enteredWeightSetsRepeats: {0: WeightSetsRepeats()},
      timeForRest: Duration(minutes: 0, seconds: 0),
      comment: '222',
    ));
  }

  ValueNotifier<List<Gymnastics>> gymnasticsList = ValueNotifier([]);

  ValueNotifier<Gymnastics> gymnastics = ValueNotifier(Gymnastics(
    exercise: '',
    isPyramid: false,
    enteredWeightSetsRepeats: {0: WeightSetsRepeats()},
    timeForRest: Duration(minutes: 0, seconds: 0),
    comment: '',
  ));

  void cacheExerciseForGymnastics({String exercise}) {
    gymnastics.value = Gymnastics(
      exercise: exercise,
      isPyramid: gymnastics.value.isPyramid,
      enteredWeightSetsRepeats: gymnastics.value.enteredWeightSetsRepeats,
      timeForRest: gymnastics.value.timeForRest,
      comment: gymnastics.value.comment,
    );
    print(gymnastics.value.exercise);
  }

  void cacheIsPyramid({bool value}) {
    gymnastics.value = Gymnastics(
      exercise: gymnastics.value.exercise,
      isPyramid: value,
      enteredWeightSetsRepeats: gymnastics.value.enteredWeightSetsRepeats,
      timeForRest: gymnastics.value.timeForRest,
      comment: gymnastics.value.comment,
    );
    print(gymnastics.value.isPyramid);
  }

  void cacheWeightForGymnastics({int index, String weight}) {
    Map<int, WeightSetsRepeats> _lineSetsMap = {
      index: WeightSetsRepeats(
        weight: weight,
        sets: gymnastics.value.enteredWeightSetsRepeats[index].sets,
        repeats: gymnastics.value.enteredWeightSetsRepeats[index].repeats,
      )
    };
    gymnastics.value.enteredWeightSetsRepeats.addAll(_lineSetsMap);

    print(gymnastics.value.enteredWeightSetsRepeats[index].weight);
  }

  void cacheSetsForGymnastics({int index, String sets}) {
    Map<int, WeightSetsRepeats> _lineSetsMap = {
      index: WeightSetsRepeats(
        weight: gymnastics.value.enteredWeightSetsRepeats[index].weight,
        sets: sets,
        repeats: gymnastics.value.enteredWeightSetsRepeats[index].repeats,
      )
    };
    gymnastics.value.enteredWeightSetsRepeats.addAll(_lineSetsMap);

    print(gymnastics.value.enteredWeightSetsRepeats[index].sets);
  }

  void cacheRepeatsForGymnastics({int index, String repeats}) {
    Map<int, WeightSetsRepeats> _lineSetsMap = {
      index: WeightSetsRepeats(
        weight: gymnastics.value.enteredWeightSetsRepeats[index].weight,
        sets: gymnastics.value.enteredWeightSetsRepeats[index].sets,
        repeats: repeats,
      )
    };
    gymnastics.value.enteredWeightSetsRepeats.addAll(_lineSetsMap);

    print(gymnastics.value.enteredWeightSetsRepeats[index].repeats);
  }

  void cacheRestTimeForGymnastics({Duration duration}) {
    gymnastics.value = Gymnastics(
      exercise: gymnastics.value.exercise,
      isPyramid: gymnastics.value.isPyramid,
      enteredWeightSetsRepeats: gymnastics.value.enteredWeightSetsRepeats,
      timeForRest: duration,
      comment: gymnastics.value.comment,
    );
    print(gymnastics.value.timeForRest);
  }

  void cacheCommentForGymnastics({String comment}) {
    gymnastics.value = Gymnastics(
      exercise: gymnastics.value.exercise,
      isPyramid: gymnastics.value.isPyramid,
      enteredWeightSetsRepeats: gymnastics.value.enteredWeightSetsRepeats,
      timeForRest: gymnastics.value.timeForRest,
      comment: comment,
    );
    print(gymnastics.value.comment);
  }

  void resetToDefaultGymnastics() {
    gymnastics.value = Gymnastics(
      exercise: '',
      isPyramid: false,
      enteredWeightSetsRepeats: {0: WeightSetsRepeats()},
      timeForRest: Duration(minutes: 0, seconds: 0),
      comment: '',
    );
  }

  void saveGymnastics() {
    //todo if line of WSR is empty, then remove this line and save
    print('hey: ${gymnasticsList.value.length}');

    List<Gymnastics> _finalList = [];
    _finalList.addAll(gymnasticsList.value);
    _finalList.add(gymnastics.value);
    gymnasticsList.value =
        _finalList; // gymnasticsList.value = [Gymnastics(), Gymnastics()]; -- gymnasticsList.value.add(gymnastics.value)
    print(gymnasticsList.value.length);
    resetToDefaultGymnastics();
  }
}
