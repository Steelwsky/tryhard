import 'package:flutter/material.dart';
import 'package:tryhard/pages/addition_page.dart';
import 'package:tryhard/pages/home_page.dart';
import 'package:tryhard/pages/new_calendar_page.dart';

//enum Pages {home, add, , calendar }

const int INITIAL_PAGE = 2;

class MyPageController {
  ValueNotifier<int> pageStateNotifier = ValueNotifier(INITIAL_PAGE);

  MyPageController();

  final List<Widget> pages = [MyHomePage(), AdditionPage(), CalendarScreen()];

  void pageNavBarChange(int pageIndex) async {
    pageStateNotifier.value = pageIndex;
  }
}
