import 'package:flutter/material.dart';
import 'eventsList.dart';

void main() => runApp(new Puspo());

class Puspo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Puspo',
      theme: new ThemeData(
        primaryColor: Colors.red,
      ),
      home: new EventsList(),
    );
  }
}