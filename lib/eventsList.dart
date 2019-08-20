// Event List (All)
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'event.dart';
import 'eventPage.dart';
import 'eventForm.dart';

class UpdateDataFromFireStore extends StatefulWidget {
  final DocumentSnapshot docSnap;
  UpdateDataFromFireStore({Key key, @required this.docSnap}) : super(key: key);
  @override
  _UpdateDataFromFireStoreState createState() =>
      _UpdateDataFromFireStoreState(snap: docSnap);
}

class _UpdateDataFromFireStoreState extends State<UpdateDataFromFireStore> {
  DocumentSnapshot snap;
  _UpdateDataFromFireStoreState({@required this.snap});
  TextEditingController _controller = TextEditingController();
  DocumentSnapshot _currentDocument;

  _updateData() async {
    await db
        .collection('Event')
        .document(_currentDocument.documentID)
        .updateData({'name': _controller.text});
  }

  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Data from Firestore")),
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Enter Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text('Update'),
              color: Colors.red,
              onPressed: _updateData,
            ),
          ),
          SizedBox(height: 20.0),
          StreamBuilder<QuerySnapshot>(
              stream: db.collection('Event').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.documents.map((doc) {
                      return ListTile(
                        title: Text(doc.data['name'] ?? 'nil'),
                        trailing: RaisedButton(
                          child: Text("Edit"),
                          color: Colors.red,
                          onPressed: () async {
                            setState(() {
                              _currentDocument = doc;
                              _controller.text = doc.data['name'];
                            });
                          },
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return SizedBox();
                }
              }),
        ],
      ),
    );
  }
}

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
         trailing: IconButton(icon: Icon(Icons.edit), 
            onPressed: () { Navigator.push(context, MaterialPageRoute(
              builder: (context) => UpdateDataFromFireStore(docSnap: snapshot),
             ),
            );
           },
         ),
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







