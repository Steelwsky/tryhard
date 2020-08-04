import 'package:flutter/material.dart';
import 'package:tryhard/models/gymnastics.dart';
import 'package:uuid/uuid.dart';

class GymnasticsController {
  ValueNotifier<Gymnastics> gymnastics = ValueNotifier(Gymnastics(
    guid: '',
    exercise: '',
    isPyramid: false,
    enteredWeightSetsRepeats: {0: WeightSetsRepeats()},
    timeForRest: Duration(minutes: 0, seconds: 0),
    comment: '',
  ));

  String _getUuidFromHash(String hash) => Uuid().v5(hash, 'UUID');

  void cacheExerciseForGymnastics({String exercise}) {
    gymnastics.value = currentGymnastics(exercise: exercise);
    print(gymnastics.value.exercise);
  }

  void cacheIsPyramid({bool value}) {
    gymnastics.value = currentGymnastics(value: value);
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
    gymnastics.value = currentGymnastics(duration: duration);
    print(gymnastics.value.timeForRest);
  }

  void cacheCommentForGymnastics({String comment}) {
    gymnastics.value = currentGymnastics(comment: comment);
    print(gymnastics.value.comment);
  }

  void assignGuidToGymnastics() {
    gymnastics.value = Gymnastics(
      guid: _getUuidFromHash(gymnastics.value.hashCode.toString()),
      exercise: gymnastics.value.exercise,
      isPyramid: gymnastics.value.isPyramid,
      enteredWeightSetsRepeats: gymnastics.value.enteredWeightSetsRepeats,
      timeForRest: gymnastics.value.timeForRest,
      comment: gymnastics.value.comment,
    );
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

  Gymnastics currentGymnastics({String guid, String exercise, bool value, Duration duration, String comment}) {
    if (guid != null) {
      return Gymnastics(
        guid: guid,
        exercise: gymnastics.value.exercise,
        isPyramid: gymnastics.value.isPyramid,
        enteredWeightSetsRepeats: gymnastics.value.enteredWeightSetsRepeats,
        timeForRest: gymnastics.value.timeForRest,
        comment: gymnastics.value.comment,
      );
    }
    if (exercise != null) {
      return Gymnastics(
        guid: gymnastics.value.guid,
        exercise: exercise,
        isPyramid: gymnastics.value.isPyramid,
        enteredWeightSetsRepeats: gymnastics.value.enteredWeightSetsRepeats,
        timeForRest: gymnastics.value.timeForRest,
        comment: gymnastics.value.comment,
      );
    }
    if (duration != null) {
      return Gymnastics(
        guid: gymnastics.value.guid,
        exercise: gymnastics.value.exercise,
        isPyramid: gymnastics.value.isPyramid,
        enteredWeightSetsRepeats: gymnastics.value.enteredWeightSetsRepeats,
        timeForRest: duration,
        comment: gymnastics.value.comment,
      );
    }
    if (comment != null) {
      return Gymnastics(
        guid: gymnastics.value.guid,
        exercise: gymnastics.value.exercise,
        isPyramid: gymnastics.value.isPyramid,
        enteredWeightSetsRepeats: gymnastics.value.enteredWeightSetsRepeats,
        timeForRest: gymnastics.value.timeForRest,
        comment: comment,
      );
    } else {
      return Gymnastics(
        guid: gymnastics.value.guid,
        exercise: gymnastics.value.exercise,
        isPyramid: value,
        enteredWeightSetsRepeats: gymnastics.value.enteredWeightSetsRepeats,
        timeForRest: gymnastics.value.timeForRest,
        comment: gymnastics.value.comment,
      );
    }
  }

//  void saveGymnastics() {
//    //todo if line of WSR is empty, then remove this line and save
//    print('hey: ${gymnasticsList.value.length}');
//
//    List<Gymnastics> _finalList = [];
//    _finalList.addAll(gymnasticsList.value);
//    _finalList.add(gymnastics.value);
//    gymnasticsList.value =
//        _finalList; // gymnasticsList.value = [Gymnastics(), Gymnastics()]; -- gymnasticsList.value.add(gymnastics.value)
//    print(gymnasticsList.value.length);
//  }
}
