// Event Class 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'eventPage.dart';

class Event {
  String name;
  String notes;
  DateTime dob;
  EventPage page;
  final DocumentReference reference;

  Event.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);
  
  Event.fromMap(Map<String, dynamic> map, {this.reference}) 
     : assert(map['name'] != null, map['notes'] != null),
       name = map['name'], notes = map['notes'];
     

  Event() 
    : reference = Firestore.instance.collection('Event').document();
}



