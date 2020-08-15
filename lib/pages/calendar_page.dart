import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tryhard/controller/workout_controller.dart';
import 'package:tryhard/custom_calendar/flutter_clean_calendar.dart';
import 'package:tryhard/models/workout.dart';
import 'package:tryhard/pages/workout_gymnastics_list.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  }

  @override
  Widget build(BuildContext context) {
    final WorkoutController workoutController = Provider.of<WorkoutController>(context);
    return ValueListenableBuilder<AllUserWorkouts>(
        valueListenable: workoutController.allUserWorkouts,
        builder: (_, allWorkouts, __) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  flex: 6,
                  child: Container(
                    key: PageStorageKey('calendar'),
                    child: Calendar(
                      startOnMonday: true,
                      weekDays: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                      events: allWorkouts.dayWorkouts,
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDay = date;
                        });
                        workoutController.changeDayWorkoutList(_selectedDay);
                      },
                      isExpandable: false,
                      isExpanded: true,
                      hideBottomBar: false,
                      eventDoneColor: Colors.green,
                      selectedColor: Colors.blue,
                      todayColor: Colors.blue,
                      eventColor: Colors.grey,
                      dayOfWeekStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13),
                    ),
                  ),
                ),
                Flexible(flex: 1, child: AddWorkout(workoutDate: _selectedDay)),
                Flexible(
                  flex: 3,
                  child: _buildEventList(),
                )
              ],
            ),
          );
        });
  }

  Widget _buildEventList() {
    final WorkoutController workoutController = Provider.of<WorkoutController>(context);
    return ValueListenableBuilder<List<Workout>>(
        valueListenable: workoutController.dayWorkouts,
        builder: (_, dayWorkouts, __) {
          return dayWorkouts.length == 0
              ? Container()
              : ListView(
                  key: PageStorageKey('gymnasticsList'),
                  children: dayWorkouts
                      .map((workout) => ListTile(
                            leading: Text(
                              DateFormat('HH:mm').format(workout.time),
                              style: TextStyle(fontSize: 18),
                            ),
                            title: Text(
                              '${workout.comment}',
                              maxLines: 3,
                              style: TextStyle(fontSize: 18),
                            ),
                            subtitle: Row(
                              children: [
                                for (var item in workout.gymnasticsList) Text('${item.exercise} '),
                              ],
                            ),
                            onTap: () {
                              workoutController.setWorkout(workout);
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => GymnasticsListForWorkout(workout: workout)),
                              );
                            },
                          ))
                      .toList());
        });
  }
}

class AddWorkout extends StatelessWidget {
  AddWorkout({Key key, this.workoutDate}) : super(key: key);

  final DateTime workoutDate;

  @override
  Widget build(BuildContext context) {
    final WorkoutController workoutController = Provider.of<WorkoutController>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 4, right: 16),
      child: Column(
        children: <Widget>[
          FlatButton(
            highlightColor: ThemeData().scaffoldBackgroundColor,
            splashColor: Colors.white,
            child: Text(
              'Add workout',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
              ),
            ),
            onPressed: () {
              workoutController.createAndAddNewWorkoutToCalendar(workoutDate);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      GymnasticsListForWorkout(
                        workout: workoutController.workout.value,
                      )));
            },
          ),
        ],
      ),
    );
  }
}
