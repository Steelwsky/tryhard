import 'package:flutter/material.dart';
import 'package:tryhard/style/colors.dart';

class MyCircularIndicatorWidget extends StatefulWidget {
  @override
  _MyCircularIndicatorWidgetState createState() => _MyCircularIndicatorWidgetState();
}

class _MyCircularIndicatorWidgetState extends State<MyCircularIndicatorWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        color: SCAFFOLD_BLACK,
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            backgroundColor: DARK_PURPLE,
            valueColor: AlwaysStoppedAnimation(PURPLE),
          ),
        ));
  }
}
