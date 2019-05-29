import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:ssh/ssh.dart';

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
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text(_result ?? "NULL",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontStyle: FontStyle.normal,
              )),
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
                    fillColor: Color(0xee6666b2),
                    labelStyle: TextStyle(color: Color(0xffababd3)),
                    helperStyle: TextStyle(color: Color(0xffababd3)),
                    filled: true,
                    labelText: 'command',
                  ),
                ),
              ),
            ),
            MaterialButton(
              height: 60,
              child: Text(
                'Execute',
                style: TextStyle(color: Colors.black87),
              ),
              onPressed: () {
                (_cmd.text != null) ? onClickCmd(_cmd.text) : print(_cmd.text);
              },
              color: Colors.greenAccent,
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
