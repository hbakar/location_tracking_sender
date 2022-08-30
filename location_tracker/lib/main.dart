import 'package:flutter/material.dart';
import 'package:location_tracker/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Tracker',
      home: HomePage(),
    );
  }
}
