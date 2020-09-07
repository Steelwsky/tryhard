import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tryhard/all_pages.dart';
import 'package:tryhard/style/colors.dart';

import 'controller/user_controller.dart';
import 'controller/workout_controller.dart';
import 'models/user.dart';
import 'models/workout.dart';

//TODO providers should be here, i think

class SuccessSignInPage extends StatefulWidget {
  @override
  _SuccessSignInPageState createState() => _SuccessSignInPageState();
}

class _SuccessSignInPageState extends State<SuccessSignInPage> {
  @override
  Widget build(BuildContext context) {
    print('SuccessSignInPage build --------------');
    final User argsUser = ModalRoute.of(context).settings.arguments;
    final UserController userController = Provider.of<UserController>(context);
    // final WorkoutController workoutController = Provider.of<WorkoutController>(context);
    userController.setUserValueNotifier(user: argsUser);
    userController.saveNotExistedUserGuid(user: argsUser);

    // print('STATUS isCompleted: $isCompleted');
    return DownloadDataWidget(user: userController.userNotifier.value);
  }
}

class DownloadDataWidget extends StatelessWidget {
  DownloadDataWidget({this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    print('DownloadDataWidget build #############');
    final WorkoutController workoutController = Provider.of<WorkoutController>(context);
    workoutController.downloadUserWorkouts(user: user);
    return ValueListenableBuilder<AllUserWorkouts>(
        valueListenable: workoutController.allUserWorkouts,
        builder: (_, allWorkouts, __) {
          return allWorkouts != null ? AllPages() : MyCircularIndicatorWidget();
          // return isCompleted ? AllPages() : CircularProgressIndicator();
        });
  }
}

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
