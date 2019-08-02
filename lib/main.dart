import 'package:flutter/material.dart';
import 'eventsList.dart';

void main() => runApp(new Avenue());

class Avenue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Avenue',
      theme: new ThemeData(
        primaryColor: Colors.red,
      ),
      home: new EventsList(),
    );
  }
}