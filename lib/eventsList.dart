// Event List (All)

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'event.dart';
import 'eventPage.dart';
import 'eventForm.dart';


class EventsList extends StatefulWidget {
  @override
  EventsListState createState() => new EventsListState();
}

class EventsListState extends State<EventsList> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Events', style: TextStyle(fontSize: 25.0)),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.settings), onPressed: null),
        ],
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new ListTile(
          title: new IconButton(icon: const Icon(Icons.add), onPressed: _pushNewEvent),  
          subtitle: _buildEventsList(context),
        ),
      ),
    );
  }

  Widget _buildEventsList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Event').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      }
    );
  }

  Widget _buildList(context, List<DocumentSnapshot> snapshot) { 
    return ListView(
     padding: const EdgeInsets.only(top: 20.0),
     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
   );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
   final game = Event.fromSnapshot(snapshot);
  
   return Padding(
     key: ValueKey(game.name),
     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
     child: Container(
       decoration: BoxDecoration(
         border: Border.all(color: Colors.grey),
         borderRadius: BorderRadius.circular(5.0),
       ),
       child: ListTile(
         title: Text(game.name),
         onTap: () { Navigator.push(
           context,
           MaterialPageRoute(
             builder: (context) => EventPage(game: game, snapshot: snapshot),
           )
          );
         },
        ),
       ),
    );
  }

  void _pushNewEvent() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return new EventForm(title: "Add Event");
        },
      ),
    );
  }

}







