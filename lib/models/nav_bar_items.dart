import 'dart:collection';

import 'package:flutter/material.dart';

class BottomNavBarItemModel {
  BottomNavBarItemModel({this.name, this.icon});

  final String name;
  final Icon icon;
}

class BottomNavBarItems {
  List<BottomNavBarItemModel> _tabs;

  BottomNavBarItems() {
    _tabs = [
      BottomNavBarItemModel(
          name: 'Home',
          icon: Icon(
            Icons.home,
          )),
      BottomNavBarItemModel(
          name: 'Add',
          icon: Icon(
            Icons.add,
          )),
      BottomNavBarItemModel(
          name: 'Calendar',
          icon: Icon(
            Icons.calendar_today,
          )),
    ];
  }

  UnmodifiableListView<BottomNavBarItemModel> get tabs =>
      UnmodifiableListView(_tabs);
}
