import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tryhard/models/gymnastics.dart';
import 'package:tryhard/widgets/gymnastics_settings_form.dart';

/* todo 1. подготовить ui элементы для создания простого упражнения.
          как минимум:
            1.2 пресеты из количества повторений х1 х5 х10 х15 х20 и свое значение
        3. отобразить упражнение в календаре
        4. хранение на стороне firestore
        5. по хорошему не забыть покрывать тестами

        //todo 1. сделать форму add 2. сделать список для всех упражнений одной тренировки.
           3 отобразить значки тренировки на календаре
* */

class GymnasticsSettingsPage extends StatelessWidget {
  GymnasticsSettingsPage({Key key, this.gymnastics, this.workoutGuid}) : super(key: key);

  final String workoutGuid;
  final Gymnastics gymnastics;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: gymnastics == null
            ? Text('Creating')
            : Text(
                '${gymnastics.exercise}',
                maxLines: 1,
              ),
      ),
      body: GymnasticsSettingsForm(workoutGuid, gymnastics: gymnastics),
    );
  }
}
