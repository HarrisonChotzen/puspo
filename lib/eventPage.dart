// Event Page (Individual)
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'eventsList.dart';
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
  
  @override
  Widget build(BuildContext context) {
    void _popEventsList() {
      Navigator.of(context).pop(
        new MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return new EventsList();
          },
        ),
      );
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Events > ${game.name}'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.delete), 
            onPressed: () => Firestore.instance.runTransaction((Transaction myTransaction) async {
              showMessage('Your event ${game.name} has been removed from your Events List', Colors.red);
              await myTransaction.delete(snapshot.reference);
              _popEventsList();
            }),
          )],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            new Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: ListTile(
                    title: Text('Event Title: ${game.name}'),
                    ),
                  ),
                ),
            new Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ListTile(
                      title: Text('Notes: ${game.notes}'),
                      ),
                    ),
                ),
          ]),
        ),
     );
  }
}

