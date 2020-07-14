import 'package:flutter/material.dart';

//enum Pages {home, add, , calendar }

const int INITIAL_PAGE = 0;

class MyPageController {
  ValueNotifier<int> pageStateNotifier = ValueNotifier(INITIAL_PAGE);

  MyPageController({this.pageController});

  final PageController pageController;

  void pageNavBarChange(int pageIndex) async {
    await pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 400),
      curve: Curves.decelerate,
    );
    pageController.jumpToPage(pageIndex);
    pageStateNotifier.value = pageIndex;
  }
}
