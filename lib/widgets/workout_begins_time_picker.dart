import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tryhard/controller/workout_controller.dart';

class WorkoutTimePicker extends StatefulWidget {
  const WorkoutTimePicker({
    Key key,
  }) : super(key: key);

  @override
  _WorkoutTimePickerState createState() => _WorkoutTimePickerState();
}

//TODO change picker's minutes from 1,2,3,4,5 to 1,5,10,15

class _WorkoutTimePickerState extends State<WorkoutTimePicker> {
  //using it just for rebuilding time
  DateTime _time = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 9, 0);

  @override
  Widget build(BuildContext context) {
    final WorkoutController workoutController = Provider.of<WorkoutController>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            'Workout begins:',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 16, right: 16),
          child: Text(
            DateFormat('HH:mm').format(workoutController.workout.value.time),
            style: TextStyle(fontSize: 18),
          ),
        ),
        MaterialButton(
//            color: Colors.grey,
            child: Text(
              'change',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            onPressed: () {
              DatePicker.showTimePicker(context, showTitleActions: true, showSecondsColumn: false, onConfirm: (time) {
                //todo save to workout
                workoutController.saveTimeWorkoutBegins(time);
                setState(() {
                  _time = time;
                });
              }, currentTime: workoutController.workout.value.time, locale: LocaleType.en);
            })
      ],
    );
  }
}
