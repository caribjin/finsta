import 'package:flutter/material.dart';
import 'package:finsta/screens/screens.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      pageBuilder: (_, __, ___) => LoginScreen(),
    );

    // return MaterialPageRoute(
    //   settings: const RouteSettings(name: routeName),
    //   builder: (_) => LoginScreen(),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Login Screen'),
    );
  }
}
