import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tryhard/controller/gymnastics_controller.dart';
import 'package:tryhard/controller/workout_controller.dart';
import 'package:tryhard/models/workout.dart';
import 'package:tryhard/pages/gymnastics_settings_page.dart';
import 'package:tryhard/widgets/workout_begins_time_picker.dart';

class GymnasticsListForWorkout extends StatefulWidget {
  GymnasticsListForWorkout({Key key, this.workout}) : super(key: key);

  final Workout workout;

  @override
  _GymnasticsListForWorkoutState createState() => _GymnasticsListForWorkoutState();
}

class _GymnasticsListForWorkoutState extends State<GymnasticsListForWorkout> {
  TextEditingController _workoutCommentEditingController;

  @override
  void initState() {
    super.initState();
    _workoutCommentEditingController = TextEditingController(text: widget.workout.comment);
  }

  @override
  Widget build(BuildContext context) {
    final WorkoutController workoutController = Provider.of<WorkoutController>(context);
    final GymnasticsController gymnasticsController = Provider.of<GymnasticsController>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text(widget.workout.time == null
              ? DateFormat('dd/MM/yyyy').format(DateTime.now())
              : DateFormat('dd/MM/yyyy').format(widget.workout.time))),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: WorkoutTimePicker(),
            ),
            Flexible(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: TextField(
                  decoration: InputDecoration(labelText: "Comment"),
                  keyboardType: TextInputType.multiline,
                  maxLength: null,
                  maxLines: null,
                  controller: _workoutCommentEditingController,
                  onChanged: (comment) {
                    workoutController.saveComment(comment: comment);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Divider(),
            Flexible(
              flex: 8,
              child: GymnasticsList(),
            )
//          Flexible(flex: 8, child: GymnasticsList(workoutGymnastics: workout.gymnasticsList)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            gymnasticsController.resetToDefaultGymnastics();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => GymnasticsSettingsPage()),
            );
          }),
    );
  }
}

class GymnasticsList extends StatelessWidget {
  const GymnasticsList({
    Key key,
  }) : super(key: key);


  //todo sort by time of workouts
  @override
  Widget build(BuildContext context) {
    final WorkoutController workoutController = Provider.of<WorkoutController>(context);
    return ValueListenableBuilder<Workout>(
        valueListenable: workoutController.workout,
        builder: (_, currentWorkout, __) {
          return ListView(
              key: PageStorageKey('gymnasticsList'),
              children: currentWorkout.gymnasticsList
                  .map((gymnastics) => ListTile(
                        leading: Text(
                          '${currentWorkout.gymnasticsList.indexOf(gymnastics) + 1}',
                          style: TextStyle(fontSize: 18),
                        ),
                        title: Text(
                          '${gymnastics.exercise}',
                          maxLines: 3,
                        ),
                        subtitle: Text(
                          gymnastics.comment,
                          maxLines: 3,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => GymnasticsSettingsPage(gymnastics: gymnastics)),
                          );
                          print(gymnastics.guid);
                        },
                      ))
                  .toList());
        });
  }
}
