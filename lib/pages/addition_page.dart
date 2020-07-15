import 'package:flutter/material.dart';

import '../widgets/custom_bottom_nav_bar.dart';

class AdditionPage extends StatefulWidget {
  AdditionPage({
    Key key,
  }) : super(key: key);

  @override
  _AdditionPage createState() => _AdditionPage();
}

class _AdditionPage extends State<AdditionPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Addition',
          ),
        ],
      ),
    );
  }
}
