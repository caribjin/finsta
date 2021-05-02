import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  static const String routeName = '/feed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            child: Text('Feed'),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return Scaffold(
                  appBar: AppBar(title: Text('Hello')),
                  body: Center(child: Text('Hello')),
                );
              }));
            }),
      ),
    );
  }
}
