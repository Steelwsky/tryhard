import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tryhard/controller/page_controller.dart';

import 'widgets/custom_bottom_nav_bar.dart';

class AllPages extends StatelessWidget {
//  GoogleSignIn _googleSignIn; //todo create drawer and use it there. mb for logout function

  @override
  Widget build(BuildContext context) {
    final pageController = Provider.of<MyPageController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('TryHard'),
      ),
      body: ValueListenableBuilder(
          valueListenable: pageController.pageStateNotifier,
          builder: (_, page, __) {
            return pageController.pages.elementAt(pageController.pageStateNotifier.value);
          }),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
