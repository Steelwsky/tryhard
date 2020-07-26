import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tryhard/controller/gymnastics_controller.dart';
import 'package:tryhard/models/gymnastics.dart';
import 'package:tryhard/pages/gymnastics_settings_page.dart';
import 'package:tryhard/widgets/workout_begins_time_picker.dart';

class GymnasticsListForWorkout extends StatelessWidget {
  GymnasticsListForWorkout({Key key, this.dateTime}) : super(key: key);

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    final GymnasticsController gymnasticsController = Provider.of<GymnasticsController>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(dateTime == null
              ? DateFormat('yyyy-MM-dd').format(DateTime.now())
              : DateFormat('yyyy-MM-dd').format(dateTime))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: WorkoutTimePicker(),
//              child: WorkoutTimePicker(date: dateTime == null ? DateTime.now() : dateTime),
            ),
          ),
          Flexible(flex: 9, child: GymnasticsList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            print(gymnasticsController.gymnasticsList.value.length);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => GymnasticsSettingsPage(),
              ),
            );
          }),
    );
  }
}

class GymnasticsList extends StatelessWidget {
  const GymnasticsList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GymnasticsController gymnasticsController = Provider.of<GymnasticsController>(context);
    return ValueListenableBuilder<List<Gymnastics>>(
        valueListenable: gymnasticsController.gymnasticsList,
        builder: (_, freshGymnasticsList, __) {
          return ListView(
              key: PageStorageKey('gymnasticsList'),
              children: freshGymnasticsList
                  .map((gymnastics) => ListTile(
                        title: Text('${freshGymnasticsList.indexOf(gymnastics) + 1} ${gymnastics.exercise}'),
                        subtitle: Text(gymnastics.comment),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => GymnasticsSettingsPage(gymnastics: gymnastics),
                            ),
                          );
                        },
                      ))
                  .toList());
        });
  }
}
