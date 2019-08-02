// Event Page (Individual)

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'event.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
void showMessage(String message, [MaterialColor color = Colors.blue]) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
}

class EventPage extends StatelessWidget {

  final Event game;

  final DocumentSnapshot snapshot;

  EventPage({Key key, @required this.game, @required this.snapshot}) : super(key: key);

  // @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events > ${game.name}'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.delete), 
            onPressed: () => Firestore.instance.runTransaction((Transaction myTransaction) async {
              await myTransaction.delete(snapshot.reference);
              showMessage('Your event: ${game.name}, has been removed from your Events List', Colors.blue);
            }),
          )],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(game.notes),
      ),
    );
  }
}
