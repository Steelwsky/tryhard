import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tryhard/controller/page_controller.dart';

import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PageController pageController = PageController();

//  @override
//  void initState() {
//    pageController = PageController();
//    super.initState();
//  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<MyPageController>(
              create: (_) => MyPageController(pageController: pageController))
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: MyHomePage(),
        ));
  }
}
