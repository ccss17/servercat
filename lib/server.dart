import 'package:cloud_firestore/cloud_firestore.dart';

class Server {
  String domain;
  String host;
  String uid;
  String label;
  DocumentReference reference;

  Server.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['domain'] != null),
        assert(map['host'] != null),
        // assert(map['uid'] != null),
        domain = map['domain'],
        uid = map['uid'],
        host = map['host'];

  Server.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
