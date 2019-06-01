import 'package:cloud_firestore/cloud_firestore.dart';

class CmdLog {
  String cmd;
  int timestamp;
  DocumentReference reference;

  CmdLog.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['cmd'] != null),
        assert(map['timestamp'] != null),
        cmd = map['cmd'],
        timestamp = map['timestamp'];

  CmdLog.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
