import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tryhard/controller/workout_controller.dart';
import 'package:tryhard/custom_calendar/flutter_clean_calendar.dart';
import 'package:tryhard/models/workout.dart';
import 'package:tryhard/pages/workout_gymnastics_list.dart';
import 'package:tryhard/style/colors.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();

    final WorkoutController workoutController = Provider.of<WorkoutController>(context);
    workoutController.changeDayWorkoutList(day: _selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    final WorkoutController workoutController = Provider.of<WorkoutController>(context);
    return ValueListenableBuilder<AllUserWorkouts>(
        valueListenable: workoutController.allUserWorkouts,
        builder: (_, allWorkouts, __) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: BACKGROUND_DARK_GREY,
                          // border: Border.all(color: PURPLE),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      key: PageStorageKey('calendar'),
                      child: Calendar(
                        startOnMonday: true,
                        weekDays: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                        events: allWorkouts.dayWorkouts,
                        onDateSelected: (date) {
                          setState(() {
                            _selectedDay = date;
                          });
                          workoutController.changeDayWorkoutList(day: _selectedDay);
                        },
                        isExpandable: false,
                        isExpanded: true,
                        hideBottomBar: false,
                        eventDoneColor: Colors.green,
                        selectedColor: GREY,
                        todayColor: PURPLE,
                        eventColor: Colors.grey,
                        dayOfWeekStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13),
                      ),
                    ),
                    AddWorkout(workoutDate: _selectedDay),
                    _buildEventList(),
                  ],
                ),
              ),
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
              : ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 50.0),
                  child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      key: PageStorageKey('gymnasticsList'),
                      children: dayWorkouts
                          .map((workout) => Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: ListTile(
                                  visualDensity: VisualDensity.compact,
                                  // dense: true,
                                  focusColor: Colors.grey,
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
                                      for (var item in workout.gymnasticsList)
                                        item != null ? Text('${item.exercise} ') : SizedBox.shrink()
                                    ],
                                  ),
                                  onTap: () {
                                    workoutController.setWorkout(w: workout);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              GymnasticsListForWorkout(workout: workout)),
                                    );
                                  },
                                ),
                              ))
                          .toList()),
                );
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
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        alignment: AlignmentDirectional.bottomEnd,
        child: FlatButton(
          child: Text(
            'Add workout',
            style: TextStyle(
              fontSize: 16,
              color: BTN_PRIMARY_ACTION,
            ),
          ),
          onPressed: () {
            workoutController.createNewWorkoutToCalendar(date: workoutDate);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    GymnasticsListForWorkout(
                      workout: workoutController.workout.value,
                    )));
          },
        ),
      ),
    );
  }
}
