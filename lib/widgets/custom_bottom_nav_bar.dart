import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tryhard/controller/page_controller.dart';
import 'package:tryhard/models/nav_bar_items.dart';
import 'package:tryhard/style/colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final BottomNavBarItems myBottomNavBarItems = BottomNavBarItems();

  @override
  Widget build(BuildContext context) {
    final myPageController = Provider.of<MyPageController>(context);
    return ValueListenableBuilder<int>(
        valueListenable: myPageController.pageStateNotifier,
        builder: (_, pageState, __) {
          return BottomNavigationBar(
              selectedItemColor: BTN_PRIMARY_ACTION,
              items: [
                ...myBottomNavBarItems.tabs.map((tab) => BottomNavigationBarItem(
                      title: Text(tab.name),
                      icon: tab.icon,
                    )),
              ],
              currentIndex: pageState,
              onTap: (index) {
                myPageController.pageNavBarChange(index);
              });
        });
  }
}
