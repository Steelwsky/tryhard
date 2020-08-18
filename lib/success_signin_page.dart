import 'package:flutter/material.dart';
import 'package:tryhard/all_pages.dart';

import 'models/user.dart';

//TODO providers should be here, i think

class SuccessSignInPage extends StatefulWidget {
  SuccessSignInPage(this.user);

  final User user;

  @override
  _SuccessSignPageState createState() => _SuccessSignPageState();
}

class _SuccessSignPageState extends State<SuccessSignInPage> {
  @override
  Widget build(BuildContext context) {
    return AllPages(widget.user);
  }
}
