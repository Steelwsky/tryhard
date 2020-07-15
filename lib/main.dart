import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tryhard/all_pages.dart';
import 'package:tryhard/controller/page_controller.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tryhard/style/colors.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [Provider<MyPageController>(create: (_) => MyPageController())],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
//              primarySwatch: Colors.deepPurple,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              primaryColor: DARK_PURPLE),
          home: AllPages(),
        ));
  }
}
