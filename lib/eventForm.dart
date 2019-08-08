// New Event Form

import 'package:flutter/material.dart';
import 'event.dart';
import 'eventsList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
void showMessage(String message, [MaterialColor color = Colors.blue]) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
}

class EventForm extends StatefulWidget {
  EventForm({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EventFormState createState() => new _EventFormState();
}

class _EventFormState extends State<EventForm> {
  Event newGame = new Event();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _submitForm() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save(); //This invokes each call to onSaved
      print('Submitting to back end...');
      Firestore.instance.collection('Event').reference().add({'name': newGame.name, 'notes': newGame.notes})
        .then((value) => 
          showMessage('New event page created for ${newGame.name}', Colors.blue)
        );
    }
  }

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
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Title your game',
                      labelText: 'Game Title',
                    ),
                    validator: (value) => value.isEmpty ? 'Name is required' : null,
                    onSaved: (value) { newGame.name = value; },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.create),
                      hintText: 'Enter other details',
                      labelText: 'Notes',
                    ),
                    onSaved: (value) { newGame.notes = value; },
                  ),
                  new Container(
                      padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                      child: new RaisedButton(
                        child: const Text('Create Event'),
                        onPressed: () { _submitForm(); _popEventsList();
                        },
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                        elevation: 4.0,
                        highlightColor: Colors.lightBlue,
                        splashColor: Colors.blueGrey,
                      )),
                ],
              ))),
    );
  }

}