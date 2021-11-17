import 'package:flutter/material.dart';
import 'package:calendar/calendar.dart';


void main() {
  return runApp(MyApp());
}

/// The app which hosts the home page which contains the calendar on it.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Demo',
      home: Calendar(),
    );
  }
}
