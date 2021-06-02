//enum Exercises { hands, body, legs }

class GymnasticsList {
  GymnasticsList({this.gymnasticsList});

  final List<Gymnastics>? gymnasticsList;
}

class Gymnastics {
  Gymnastics(
      {this.workoutGuid,
      this.guid,
      this.exercise,
      this.isPyramid,
      this.enteredWeightSetsRepeats,
      this.restTime,
      this.comment});

  final String? workoutGuid;
  final String? guid;
  final String? exercise;
  final bool? isPyramid;
  final MapWSR? enteredWeightSetsRepeats;
  final Duration? restTime;
  final String? comment;

  Gymnastics.fromJson(Map<String, dynamic> json)
      : workoutGuid = json['workoutGuid'] != null ? json['workoutGuid'] : '',
        guid = json['guid'] != null ? json['guid'] : '',
        exercise = json['exercise'] != null ? json['exercise'] : '',
        isPyramid = json['isPyramid'],
        enteredWeightSetsRepeats = MapWSR.fromJson(json['enteredWSR']),
        restTime = Duration(milliseconds: int.parse(json['restTime'])),
        comment = json['comment'] != null ? json['comment'] : '';

  Map<String, dynamic> toJson() {
    return {
      'workoutGuid': workoutGuid,
      'guid': guid,
      'exercise': exercise,
      'isPyramid': isPyramid,
      'enteredWSR': enteredWeightSetsRepeats!.toJson(),
      'restTime': restTime!.inMilliseconds.toString(),
      'comment': comment,
    };
  }

  Gymnastics copyWith({
    final String? workoutGuid,
    final String? guid,
    final String? exercise,
    final bool? isPyramid,
    final MapWSR? enteredWeightSetsRepeats,
    final Duration? restTime,
    final String? comment,
  }) {
    return new Gymnastics(
      workoutGuid: workoutGuid ?? this.workoutGuid,
      guid: guid ?? this.guid,
      exercise: exercise ?? this.exercise,
      isPyramid: isPyramid ?? this.isPyramid,
      enteredWeightSetsRepeats:
          enteredWeightSetsRepeats ?? this.enteredWeightSetsRepeats,
      restTime: restTime ?? this.restTime,
      comment: comment ?? this.comment,
    );
  }
}

class WeightSetsRepeats {
  WeightSetsRepeats({this.weight, this.sets, this.repeats});

  final String? weight;
  final String? sets;
  final String? repeats;

  Map<String, dynamic> toJson() => {
        'weight': weight,
        'sets': sets,
        'repeats': repeats,
      };

  WeightSetsRepeats.fromJson(Map<String, dynamic> json)
      : weight = json['weight'] != null ? json['weight'] : '',
        sets = json['sets'] != null ? json['sets'] : '',
        repeats = json['repeats'] != null ? json['repeats'] : '';
}

class MapWSR {
  MapWSR({this.mapWsr});

  Map<int?, WeightSetsRepeats>? mapWsr;

  List<dynamic> toJson() => getValueWSR();

  MapWSR.fromJson(List<dynamic> json)
      : mapWsr =
            json.asMap().map((key, value) => MapEntry<int, WeightSetsRepeats>(
                  key,
                  WeightSetsRepeats.fromJson(value),
                ));

  List<Map<String, dynamic>> getValueWSR() {
    List<Map<String, dynamic>> _wsr = [];
    mapWsr!.forEach((key, value) {
      _wsr.add(value.toJson());
    });
    return _wsr;
  }
}
