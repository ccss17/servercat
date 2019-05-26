import 'package:cloud_firestore/cloud_firestore.dart';

class Server {
  String domain;
  String sshid;
  String uid;
  String label;
  String pw;
  String port;
  String protocol;
  DocumentReference reference;

  Server.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['domain'] != null),
        domain = map['domain'],
        uid = map['uid'],
        label = map['label'],
        pw = map['pw'],
        port = map['port'],
        protocol = map['protocol'],
        sshid = map['sshid'];

  Server.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
