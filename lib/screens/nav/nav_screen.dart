import 'package:flutter/material.dart';
import 'package:finsta/screens/screens.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      pageBuilder: (_, __, ___) => NavScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Nav Screen'),
    );
  }
}
