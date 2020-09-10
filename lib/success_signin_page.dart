import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tryhard/all_pages.dart';
import 'package:tryhard/widgets/circular_indicator.dart';

import 'controller/user_controller.dart';
import 'controller/workout_controller.dart';
import 'models/workout.dart';

class SuccessSignInPage extends StatefulWidget {
  @override
  _SuccessSignInPageState createState() => _SuccessSignInPageState();
}

class _SuccessSignInPageState extends State<SuccessSignInPage> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    final UserController userController = Provider.of<UserController>(context);
    final WorkoutController workoutController = Provider.of<WorkoutController>(context);
    await workoutController.downloadUserWorkouts(user: userController.userProfile.value.data);
  }

  @override
  Widget build(BuildContext context) {
    print('SuccessSignInPage build --------------');
    final WorkoutController workoutController = Provider.of<WorkoutController>(context);
    return ValueListenableBuilder<AllUserWorkouts>(
        valueListenable: workoutController.allUserWorkouts,
        builder: (_, allWorkouts, __) {
          return allWorkouts != null ? AllPages() : MyCircularIndicatorWidget();
        });
  }
}


