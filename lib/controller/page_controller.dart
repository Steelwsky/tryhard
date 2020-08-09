import 'package:flutter/material.dart';
import 'package:tryhard/models/nav_bar_items.dart';
import 'package:tryhard/pages/calendar_page.dart';
import 'package:tryhard/pages/profile_page.dart';
import 'package:tryhard/widgets/gymnastics_settings_form.dart';

//enum Pages {home, add, , calendar }

const int INITIAL_PAGE = 1;

class MyPageController extends BottomNavBarItems {
  ValueNotifier<int> pageStateNotifier = ValueNotifier(INITIAL_PAGE);

  MyPageController();

  final List<Widget> pages = [
    GymnasticsSettingsForm(),
    CalendarScreen(),
    ProfilePage(),
  ];

  void pageNavBarChange(int pageIndex) async {
    pageStateNotifier.value = pageIndex;
  }
}
