import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tryhard/controller/gymnastics_controller.dart';
import 'package:tryhard/controller/workout_controller.dart';
import 'package:tryhard/models/gymnastics.dart';
import 'package:tryhard/style/colors.dart';

class GymnasticsSettingsForm extends StatefulWidget {
  GymnasticsSettingsForm(
    this.workoutGuid, {
    Key? key,
    this.gymnastics,
  }) : super(key: key);

  final Gymnastics? gymnastics;
  final String? workoutGuid;

  @override
  _GymnasticsSettingsForm createState() => _GymnasticsSettingsForm();
}

class _GymnasticsSettingsForm extends State<GymnasticsSettingsForm> {
  TextEditingController? _exerciseEditingController;
  TextEditingController? _commentEditingController;

  @override
  void initState() {
    super.initState();
    if (widget.gymnastics != null) {
      _exerciseEditingController =
          TextEditingController(text: widget.gymnastics!.exercise);
      _commentEditingController =
          TextEditingController(text: widget.gymnastics!.comment);
    } else {
      _exerciseEditingController = TextEditingController();
      _commentEditingController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    final GymnasticsController gymnasticsController = Provider.of<GymnasticsController>(context);
    final WorkoutController workoutController = Provider.of<WorkoutController>(context);
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Form(
              key: PageStorageKey('addition_page'),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: "Exercise"),
                    keyboardType: TextInputType.multiline,
                    maxLength: null,
                    maxLines: null,
                    controller: _exerciseEditingController,
                    onChanged: (exercise) {
                      gymnasticsController.cacheExerciseForGymnastics(exercise: exercise);
                    },
                  ),
                  _pyramidSwitcher(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Flexible(
                          flex: 3,
                          child: Text(
                            'Weight',
                          )),
                      Flexible(flex: 1, child: Container()),
                      Flexible(flex: 3, child: Text('Sets')),
                      Flexible(flex: 1, child: Container()),
                      Flexible(flex: 3, child: Text('Repeats')),
                    ],
                  ),
                  Divider(),
                  WeightSetsRepeatsBuilder(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      gymnasticsController.gymnastics.value
                                  .enteredWeightSetsRepeats!.mapWsr!.length >
                              1
                          ? _deleteSetsAndRepeats()
                          : Container(),
                      gymnasticsController.gymnastics.value
                                  .enteredWeightSetsRepeats!.mapWsr!.length <=
                              15
                          ? _addSetsAndRepeats()
                          : Container(),
                    ],
                  ),
                  _restTimerSelection(),
                  TextField(
                      decoration: InputDecoration(labelText: "Comment"),
                      keyboardType: TextInputType.multiline,
                      maxLength: null,
                      maxLines: null,
                      controller: _commentEditingController,
                      onChanged: (comment) => gymnasticsController.cacheCommentForGymnastics(
                          comment: comment.replaceAll("\\n", "\n"))),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: MaterialButton(
                    // highlightColor: ThemeData().scaffoldBackgroundColor,
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 18,
                          color: BTN_SECOND_ACTION
                      ),
                    ),
                    onPressed: () {
                      gymnasticsController.resetToDefaultGymnastics();
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: MaterialButton(
                    // highlightColor: ThemeData().scaffoldBackgroundColor,
                    child: Text(
                      "Submit",
                      style: TextStyle(fontSize: 18,
                        color: BTN_PRIMARY_ACTION,
                        fontWeight: FontWeight.bold,),
                    ),
                    onPressed: () {
                      gymnasticsController.linkWorkoutGuidToGymnastics(widget.workoutGuid);
                      if (widget.gymnastics != null) {
                        workoutController.updateExistedWorkoutByGymnastics(
                            gymnastics: gymnasticsController.gymnastics.value);
                      } else {
                        gymnasticsController.assignGuidToGymnastics();
                        workoutController.addGymnasticsToWorkout(
                            gymnastics: gymnasticsController.gymnastics.value);
                      }
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      )
    ]);
  }

  Widget _restTimerSelection() {
    final GymnasticsController gymnasticsController = Provider.of<GymnasticsController>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 32),
          child: Row(
            children: <Widget>[
              Text(
                'Rest time',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        Container(
          height: 76,
          width: 270,
          child: CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                pickerTextStyle: TextStyle(color: Colors.white),
              ),
            ),
            child: CupertinoTimerPicker(
              alignment: Alignment.center,
              initialTimerDuration:
                  gymnasticsController.gymnastics.value.restTime!,
              onTimerDurationChanged: (duration) {
                gymnasticsController.cacheRestTimeForGymnastics(
                    duration: duration);
                print(duration);
              },
              minuteInterval: 1,
              secondInterval: 5,
              mode: CupertinoTimerPickerMode.ms,
            ),
          ),
        ),
      ],
    );
  }

  Widget _pyramidSwitcher() {
    final GymnasticsController gymnasticsController = Provider.of<GymnasticsController>(context);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Pyramid',
                style: TextStyle(fontSize: 18),
              ),
              CupertinoSwitch(
                activeColor: DARK_PURPLE,
                value: gymnasticsController.gymnastics.value.isPyramid!,
                onChanged: (isPyramid) {
                  setState(() {
                    gymnasticsController.cacheIsPyramid(value: isPyramid);
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _addSetsAndRepeats() {
    final GymnasticsController gymnasticsController = Provider.of<GymnasticsController>(context);
    return MaterialButton(
      // highlightColor: ThemeData().scaffoldBackgroundColor,
      child: Text(
        'Add',
        style: TextStyle(
          fontSize: 14,
          color: BTN_PRIMARY_ACTION,
        ),
      ),
      onPressed: () {
        setState(() {
          gymnasticsController
                  .gymnastics.value.enteredWeightSetsRepeats!.mapWsr![
              gymnasticsController.gymnastics.value.enteredWeightSetsRepeats!
                  .mapWsr!.length] = WeightSetsRepeats();
        });
      },
    );
  }

  Widget _deleteSetsAndRepeats() {
    final GymnasticsController gymnasticsController = Provider.of<GymnasticsController>(context);
    return MaterialButton(
      splashColor: Colors.white,
      highlightColor: ThemeData().scaffoldBackgroundColor,
      child: Text(
        'Remove',
        style: TextStyle(
          fontSize: 14,
          color: BTN_DELETE_ACTION,
        ),
      ),
      onPressed: () {
        setState(() {
          gymnasticsController
              .gymnastics.value.enteredWeightSetsRepeats!.mapWsr!
              .remove(gymnasticsController.gymnastics.value
                      .enteredWeightSetsRepeats!.mapWsr!.length -
                  1);
        });
      },
    );
  }
}

class WeightSetsRepeatsBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gymnasticsController = Provider.of<GymnasticsController>(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 1000, minHeight: 50.0),
      child: ValueListenableBuilder<Gymnastics>(
          valueListenable: gymnasticsController.gymnastics,
          builder: (_, newGymnastics, __) {
            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount:
                    newGymnastics.enteredWeightSetsRepeats!.mapWsr!.length,
                itemBuilder: (context, count) {
                  return WeightSetsAndRepeatsWidget(
                      index: count,
                      weightSetsRepeats: newGymnastics
                          .enteredWeightSetsRepeats!.mapWsr![count]);
                });
          }),
    );
  }
}

class WeightSetsAndRepeatsWidget extends StatefulWidget {
  const WeightSetsAndRepeatsWidget({
    this.index,
    this.weightSetsRepeats,
    Key? key,
  }) : super(key: key);

  final int? index;
  final WeightSetsRepeats? weightSetsRepeats;

  @override
  _WeightSetsAndRepeatsWidgetState createState() =>
      _WeightSetsAndRepeatsWidgetState();
}

class _WeightSetsAndRepeatsWidgetState extends State<WeightSetsAndRepeatsWidget> {
  TextEditingController? weightEditing;
  TextEditingController? setsEditing;
  TextEditingController? repeatsEditing;

  @override
  void initState() {
    super.initState();
    weightEditing =
        TextEditingController(text: widget.weightSetsRepeats!.weight);
    setsEditing = TextEditingController(text: widget.weightSetsRepeats!.sets);
    repeatsEditing =
        TextEditingController(text: widget.weightSetsRepeats!.repeats);
  }

  @override
  Widget build(BuildContext context) {
    final GymnasticsController gymnasticsController = Provider.of<GymnasticsController>(context);
    return Column(children: <Widget>[
      Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(
              key: ValueKey('weightFlex'),
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: TextField(
                  controller: weightEditing,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  onChanged: (_) {
                    gymnasticsController.cacheWeightForGymnastics(
                        index: widget.index, weight: weightEditing!.value.text);
                  },
                ),
              ),
            ),
            VerticalDivider(),
            Flexible(
              flex: 1,
              child: Container(
                  child: Text(
                    'x',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  )),
            ),
            VerticalDivider(),
            Flexible(
              key: ValueKey('setsFlex'),
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: TextField(
                  controller: setsEditing,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  onChanged: (input) {
                    gymnasticsController.cacheSetsForGymnastics(
                        index: widget.index, sets: setsEditing!.value.text);
                  },
                ),
              ),
            ),
            VerticalDivider(),
            Flexible(
              flex: 1,
              child: Container(
                  child: Text(
                    'x',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  )),
            ),
            VerticalDivider(),
            Flexible(
              key: ValueKey('RepeatsFlex'),
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: TextField(
                  controller: repeatsEditing,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  onChanged: (input) {
                    gymnasticsController.cacheRepeatsForGymnastics(
                        index: widget.index,
                        repeats: repeatsEditing!.value.text);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      Divider(),
    ]);
  }
}
