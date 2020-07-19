import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:tryhard/controller/gymnastics_controller.dart';
import 'package:tryhard/models/gymnastics.dart';
import 'package:tryhard/style/colors.dart';

/* todo 1. подготовить ui элементы для создания простого упражнения.
            как минимум:
            1.1 текстовые поля
            1.2 пресеты из количества повторений х1 х5 х10 х15 х20 и свое значение
            1.3
        2. подготовить модель для упражнения
        3. отобразить упражнение в календаре
        4. хранение на стороне firestore
        5. по хорошему не забыть покрывать тестами

        //todo 1. сделать форму add 2. сделать список для всех упражнений одной тренировки.
           3 отобразить значки тренировки на календаре
* */

class AdditionPage extends StatefulWidget {
  AdditionPage({
    Key key,
  }) : super(key: key);

  @override
  _AdditionPage createState() => _AdditionPage();
}

class _AdditionPage extends State<AdditionPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List<Widget> setsAndRepeatsWidgetList = [WeightSetsAndRepeatsWidget(), WeightSetsAndRepeatsWidget()]; //todo rewrite
  final TextEditingController _exerciseEditingController = TextEditingController();
  final TextEditingController _commentEditingController = TextEditingController();
  bool f = false;

  @override
  Widget build(BuildContext context) {
    final GymnasticsController gymnasticsController = Provider.of<GymnasticsController>(context);
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FormBuilder(
              key: _fbKey,
              autovalidate: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: "Exercise"),
                    keyboardType: TextInputType.multiline,
                    maxLength: null,
                    maxLines: null,
                    controller: _exerciseEditingController,
                    onChanged: (exercise) {},
                  ),
                  _pyramidSwitcher(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Flexible(flex: 3, child: Text('Weight')),
                      Flexible(flex: 1, child: Container()),
                      Flexible(flex: 3, child: Text('Sets')),
                      Flexible(flex: 1, child: Container()),
                      Flexible(flex: 3, child: Text('Repeats')),
                    ],
                  ),
                  Divider(),
                  WeightSetsRepeatsBuilder(list: setsAndRepeatsWidgetList),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      setsAndRepeatsWidgetList.length <= 15 ? _addSetsAndRepeats() : Container(),
                      setsAndRepeatsWidgetList.length > 1 ? _deleteSetsAndRepeats() : Container(),
                    ],
                  ),
                  _restTimerSelection(),
                  TextField(
                    decoration: InputDecoration(labelText: "Comment"),
                    keyboardType: TextInputType.multiline,
                    maxLength: null,
                    maxLines: null,
                    controller: _commentEditingController,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                MaterialButton(
                  child: Text("Submit"),
                  onPressed: () {
                    if (_fbKey.currentState.saveAndValidate()) {
                      print(_fbKey.currentState.value);

                      // valueNotifier.value = _fbKey.currentState.value;
                    }
                  },
                ),
              ],
            )
          ],
        ),
      )
    ]);
  }

  Widget _restTimerSelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 32),
          child: Row(
            children: <Widget>[
              Text(
                'Rest time',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Container(
          height: 76,
          width: 270,
          child: CupertinoTimerPicker(
            alignment: Alignment.center,
            onTimerDurationChanged: (duration) {
              //todo write rest timer to a valueNotifier?

              print(duration);
            },
            minuteInterval: 1,
            secondInterval: 5,
            mode: CupertinoTimerPickerMode.ms,
          ),
        ),
      ],
    );
  }

  Widget _pyramidSwitcher() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Pyramid',
                style: TextStyle(fontSize: 16),
              ),
              CupertinoSwitch(
                value: f,
                activeColor: DARK_PURPLE,
                onChanged: (a) {
                  setState(() {
                    f = a;
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
      splashColor: Colors.white,
      highlightColor: ThemeData().scaffoldBackgroundColor,
      child: Text(
        'Add',
        style: TextStyle(fontSize: 12),
      ),
      onPressed: () {
        setState(() {
          setsAndRepeatsWidgetList.add(WeightSetsAndRepeatsWidget());
        });
      },
    );
  }

  Widget _deleteSetsAndRepeats() {
    return MaterialButton(
      splashColor: Colors.white,
      highlightColor: ThemeData().scaffoldBackgroundColor,
      child: Text(
        'Remove',
        style: TextStyle(fontSize: 12),
      ),
      onPressed: () {
        setState(() {
          setsAndRepeatsWidgetList.removeLast();
        });
      },
    );
  }
}

//todo peredelat vse je v builder.

class WeightSetsRepeatsBuilder extends StatefulWidget {
  WeightSetsRepeatsBuilder({@required this.list, this.data});

  final List<WeightSetsRepeats> data;
  final List<Widget> list;

  @override
  _WeightSetsRepeatsBuilderState createState() => _WeightSetsRepeatsBuilderState();
}

class _WeightSetsRepeatsBuilderState extends State<WeightSetsRepeatsBuilder> {

  final dummyData = WeightSetsRepeats();

  @override
  Widget build(BuildContext context) {
//    return Column(
//      children: widget.list,
//    );
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 1000, minHeight: 50.0),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.list.length,
          itemBuilder: (context, count) {
            return WeightSetsAndRepeatsWidget(
              weightSetsRepeats: widget.data == null ? dummyData : widget.data[count],
            );
          }),
    );
  }
}

class WeightSetsAndRepeatsWidget extends StatelessWidget {
  const WeightSetsAndRepeatsWidget({
    this.weightSetsRepeats,
    Key key,
  }) : super(key: key);

  final WeightSetsRepeats weightSetsRepeats;

  @override
  Widget build(BuildContext context) {
    final GymnasticsController gymnasticsController = Provider.of<GymnasticsController>(context);
    TextEditingController weightEditing =
        TextEditingController(text: weightSetsRepeats.weight == null ? '' : weightSetsRepeats.weight.toString());
    TextEditingController setsEditing =
        TextEditingController(text: weightSetsRepeats.sets == null ? '' : weightSetsRepeats.sets.toString());
    TextEditingController repeatsEditing =
        TextEditingController(text: weightSetsRepeats.repeats == null ? '' : weightSetsRepeats.repeats.toString());

    return Column(children: <Widget>[
      Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: TextField(
                  controller: weightEditing,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 16),
                    border: InputBorder.none,
                  ),
                  onChanged: (input) {},
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
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: TextField(
                  controller: setsEditing,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 16),
                    border: InputBorder.none,
                  ),
                  onChanged: (input) {
//                    gymnasticsController.gymnastics.value = Gymnastics(
//                        exercise: gymnasticsController.gymnastics.value.exercise,
//                        isPyramid: gymnasticsController.gymnastics.value.isPyramid,
//                        listSetsRepeats: gymnasticsController.gymnastics.value.listSetsRepeats
//                            .add(SetsRepeats(weight: 3, sets: 3, repeats: 3)) //todo ??????
//                    );
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
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: TextField(
                  controller: repeatsEditing,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 16),
                    border: InputBorder.none,
                  ),
                  onChanged: (input) {},
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
