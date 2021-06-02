import 'package:flutter/material.dart';
import 'package:tryhard/models/gymnastics.dart';
import 'package:uuid/uuid.dart';

class GymnasticsController {
  ValueNotifier<Gymnastics> gymnastics = ValueNotifier(Gymnastics(
    workoutGuid: '',
    guid: '',
    exercise: '',
    isPyramid: false,
    enteredWeightSetsRepeats: MapWSR(mapWsr: {0: WeightSetsRepeats()}),
    restTime: Duration(minutes: 0, seconds: 0),
    comment: '',
  ));

  String _getUuidFromHash(String hash) => Uuid().v5(hash, 'UUID');

  void assignGuidToGymnastics() {
    final currentGymnastics = gymnastics.value;
    gymnastics.value = currentGymnastics.copyWith(
        guid: _getUuidFromHash(gymnastics.value.hashCode.toString()));
  }

  void linkWorkoutGuidToGymnastics(String? workoutGuid) {
    final currentGymnastics = gymnastics.value;
    gymnastics.value = currentGymnastics.copyWith(workoutGuid: workoutGuid);
  }

  void cacheExerciseForGymnastics({String? exercise}) {
    final currentGymnastics = gymnastics.value;
    gymnastics.value = currentGymnastics.copyWith(exercise: exercise);
    print(gymnastics.value.exercise);
  }

  void cacheIsPyramid({bool? value}) {
    final currentGymnastics = gymnastics.value;
    gymnastics.value = currentGymnastics.copyWith(isPyramid: value);
    print(gymnastics.value.isPyramid);
  }

  void cacheWeightForGymnastics({int? index, String? weight}) {
    Map<int?, WeightSetsRepeats> _lineSetsMap = {
      index: WeightSetsRepeats(
        weight: weight,
        sets: gymnastics.value.enteredWeightSetsRepeats!.mapWsr![index]!.sets,
        repeats:
            gymnastics.value.enteredWeightSetsRepeats!.mapWsr![index]!.repeats,
      )
    };
    gymnastics.value.enteredWeightSetsRepeats!.mapWsr!.addAll(_lineSetsMap);

    print(gymnastics.value.enteredWeightSetsRepeats!.mapWsr![index]!.weight);
  }

  void cacheSetsForGymnastics({int? index, String? sets}) {
    Map<int?, WeightSetsRepeats> _lineSetsMap = {
      index: WeightSetsRepeats(
        weight:
            gymnastics.value.enteredWeightSetsRepeats!.mapWsr![index]!.weight,
        sets: sets,
        repeats:
            gymnastics.value.enteredWeightSetsRepeats!.mapWsr![index]!.repeats,
      )
    };
    gymnastics.value.enteredWeightSetsRepeats!.mapWsr!.addAll(_lineSetsMap);

    print(gymnastics.value.enteredWeightSetsRepeats!.mapWsr![index]!.sets);
  }

  void cacheRepeatsForGymnastics({int? index, String? repeats}) {
    Map<int?, WeightSetsRepeats> _lineSetsMap = {
      index: WeightSetsRepeats(
        weight:
            gymnastics.value.enteredWeightSetsRepeats!.mapWsr![index]!.weight,
        sets: gymnastics.value.enteredWeightSetsRepeats!.mapWsr![index]!.sets,
        repeats: repeats,
      )
    };
    gymnastics.value.enteredWeightSetsRepeats!.mapWsr!.addAll(_lineSetsMap);

    print(gymnastics.value.enteredWeightSetsRepeats!.mapWsr![index]!.repeats);
  }

  void cacheRestTimeForGymnastics({Duration? duration}) {
    final currentGymnastics = gymnastics.value;
    gymnastics.value = currentGymnastics.copyWith(restTime: duration);
    print(gymnastics.value.restTime);
  }

  void cacheCommentForGymnastics({String? comment}) {
    final currentGymnastics = gymnastics.value;
    gymnastics.value = currentGymnastics.copyWith(comment: comment);
    print(gymnastics.value.comment);
  }

  void resetToDefaultGymnastics() {
    gymnastics.value = Gymnastics(
      workoutGuid: '',
      exercise: '',
      isPyramid: false,
      enteredWeightSetsRepeats: MapWSR(mapWsr: {0: WeightSetsRepeats()}),
      restTime: Duration(minutes: 0, seconds: 0),
      comment: '',
    );
  }

  void setGymnasticsToNotifier({required Gymnastics inputGymnastics}) {
    gymnastics.value = inputGymnastics;
  }
}
