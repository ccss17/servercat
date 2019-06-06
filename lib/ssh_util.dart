import 'dart:async';
import 'cmdlog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:ssh/ssh.dart';
import 'auth.dart';

class SSHPage extends StatefulWidget {
  String host;
  String ssh_id;
  String ssh_pw;
  SSHPage({this.host, this.ssh_id, this.ssh_pw});
  @override
  SSHPageState createState() =>
      SSHPageState(this.host, this.ssh_id, this.ssh_pw);
}

class SSHPageState extends State<SSHPage> {
  String _result = '';
  var client;
  final _cmd = TextEditingController();

  SSHPageState(String host, String ssh_id, String ssh_pw) {
    client = SSHClient(
      host: host,
      port: 22,
      username: ssh_id,
      passwordOrKey: ssh_pw,
    );
  }

  Future<void> onClickCmd(String cmd) async {
    String result;
    try {
      result = await client.connect();
      if (result == "session_connected") result = await client.execute(cmd);
    } on PlatformException catch (e) {
      result = ('Error: ${e.code}\nError Message: ${e.message}');
    }

    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Container(
                padding: _result == ''
                    ? EdgeInsets.symmetric(vertical: 120, horizontal: 50)
                    : EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: _result == ''
                    ? Text(
                        'SSH\n'
                        'REMOTE\n'
                        'TERMINAL\n',
                        style: TextStyle(
                            fontSize: 60.0, color: Colors.greenAccent),
                      )
                    : Text(_result,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontStyle: FontStyle.normal,
                        )),
              ),
            )),
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('cmdlog')
              .document(authService.getUid())
              .collection('logs')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            List<DocumentSnapshot> tmp = List<DocumentSnapshot>();
            List<DocumentSnapshot> tmp2 = List<DocumentSnapshot>();
            for (int i = 0; i < snapshot.data.documents.length; i++) {
              if (i < 4)
                tmp.add(snapshot.data.documents[i]);
              else
                tmp2.add(snapshot.data.documents[i]);
            }
            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: tmp2.map((data) {
                    CmdLog cmdlog2 = CmdLog.fromSnapshot(data);
                    return Expanded(
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 5.0),
                          alignment: Alignment.center,
                          child: MaterialButton(
                            child: Text(
                              cmdlog2.cmd,
                              style: TextStyle(
                                  color: Colors.tealAccent, fontSize: 12),
                            ),
                            onPressed: () {
                              onClickCmd(cmdlog2.cmd);
                            },
                          )),
                    );
                  }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: tmp.map((data) {
                    CmdLog cmdlog = CmdLog.fromSnapshot(data);
                    return Expanded(
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 5.0),
                          alignment: Alignment.center,
                          child: MaterialButton(
                            child: Text(
                              cmdlog.cmd,
                              style: TextStyle(
                                color: Colors.tealAccent,
                              ),
                            ),
                            onPressed: () {
                              onClickCmd(cmdlog.cmd);
                            },
                          )),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
        Row(
          children: <Widget>[
            Flexible(
              child: SizedBox(
                height: 60,
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  controller: _cmd,
                  decoration: InputDecoration(
                    fillColor: Colors.black12,
                    // fillColor: Color(0xee6666b2),
                    labelStyle: TextStyle(color: Color(0xffababd3)),
                    helperStyle: TextStyle(color: Color(0xffababd3)),
                    filled: true,
                    labelText: 'command',
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (_cmd.text != null) {
                  onClickCmd(_cmd.text);

                  var cmdlog = Map<String, dynamic>();
                  var logs = Map<String, dynamic>();
                  cmdlog['uid'] = authService.getUid();
                  logs['cmd'] = _cmd.text;
                  logs['timestamp'] = DateTime.now().millisecondsSinceEpoch;
                  DocumentReference cmdlog_ref = Firestore.instance
                      .collection("cmdlog")
                      .document(cmdlog['uid']);
                  CollectionReference logs_col_ref =
                      cmdlog_ref.collection("logs");
                  var ordered =
                      logs_col_ref.orderBy('timestamp', descending: true);
                  DocumentReference logs_ref =
                      logs_col_ref.document(logs['cmd']);
                  Firestore.instance.runTransaction((transaction) async {
                    await transaction.set(cmdlog_ref, cmdlog);
                    await transaction.set(logs_ref, logs);
                    var qs = await ordered.getDocuments();
                    var qs_doc = qs.documents;
                    var flag = 0;
                    for (var i in qs_doc)
                      if (i.data['cmd'] == logs['cmd']) flag = 1;
                    var totallen = qs.documents.length;
                    print(totallen);
                    print(flag);
                    if (totallen > 7 && flag != 1)
                      await transaction.delete(qs_doc[totallen - 1].reference);
                  });
                  _cmd.text = '';
                }
              },
              child: Container(
                width: 80.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Center(
                  child: Text(
                    'EXECUTE',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  CupertinoButton getIOSSendButton() {
    return CupertinoButton(child: Text("Execute"), onPressed: () {});
  }

  IconButton getDefaultSendButton() {
    return IconButton(icon: Icon(Icons.send), onPressed: () {});
  }
}
