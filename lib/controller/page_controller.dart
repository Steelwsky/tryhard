import 'package:flutter/material.dart';
import 'package:tryhard/models/nav_bar_items.dart';
import 'package:tryhard/screens/calendar_page.dart';
import 'package:tryhard/screens/profile_page.dart';

//enum Pages {home, add, , calendar }

const int INITIAL_PAGE = 0;

class MyPageController extends BottomNavBarItems {
  ValueNotifier<int> pageStateNotifier = ValueNotifier(INITIAL_PAGE);

  MyPageController() {
    print('pageController');
  }

  final List<Widget> pages = [
//    GymnasticsSettingsForm(),
    CalendarScreen(),
    ProfilePage(),
  ];

  void pageNavBarChange(int pageIndex) async {
    pageStateNotifier.value = pageIndex;
  }
}
