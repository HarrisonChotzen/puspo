// Event Class 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'eventPage.dart';

class Event {
  String name;
  DateTime dob;
  // Sport gameType;
  String notes = '';
  EventPage page;
  final DocumentReference reference;

  void updateData(selectedDoc, newValues) {
    Firestore.instance
        .collection('Event')
        .document(selectedDoc)
        .updateData(newValues)
        .catchError((e) {
      print(e);
    });
  }
 
  void deleteData(docId) {
    Firestore.instance
        .collection('Event')
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  Event.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);
  
  Event.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['name'] != null),
       name = map['name'];

  Event() 
    : reference = Firestore.instance.collection('Event').document();
}

