import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tryhard/all_pages.dart';

import 'controller/user_controller.dart';
import 'controller/workout_controller.dart';

//TODO providers should be here, i think

class SuccessSignInPage extends StatefulWidget {
  @override
  _SuccessSignPageState createState() => _SuccessSignPageState();
}

class _SuccessSignPageState extends State<SuccessSignInPage> {
  @override
  Widget build(BuildContext context) {
    final UserController userController = Provider.of<UserController>(context);
    Provider.of<WorkoutController>(context).linkUserToWorkouts(userController.userNotifier.value);
    return AllPages();
  }
}
