import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:ssh/ssh.dart';
import 'package:path_provider/path_provider.dart';

class SSHDemo extends StatefulWidget {
  String host;
  String ssh_id;
  String ssh_pw;
  SSHDemo({this.host, this.ssh_id, this.ssh_pw});
  @override
  SSHDemoState createState() =>
      new SSHDemoState(this.host, this.ssh_id, this.ssh_pw);
}

class SSHDemoState extends State<SSHDemo> {
  String _result = '';
  List _array;
  var client;
  final _domain = TextEditingController();
  bool _domainValidate = false;

  SSHDemoState(String host, String ssh_id, String ssh_pw) {
    client = new SSHClient(
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
      _array = null;
    });
  }

  Future<void> onClickShell() async {
    setState(() {
      _result = "";
      _array = null;
    });

    try {
      String result = await client.connect();
      if (result == "session_connected") {
        result = await client.startShell(
            ptyType: "xterm",
            callback: (dynamic res) {
              setState(() {
                _result += res;
              });
            });

        if (result == "shell_started") {
          print(await client.writeToShell("echo hello > world\n"));
          print(await client.writeToShell("cat world\n"));
          new Future.delayed(
            const Duration(seconds: 5),
            () async => await client.closeShell(),
          );
        }
      }
    } on PlatformException catch (e) {
      print('Error: ${e.code}\nError Message: ${e.message}');
    }
  }

  Future<void> onClickSFTP() async {
    try {
      String result = await client.connect();
      if (result == "session_connected") {
        result = await client.connectSFTP();
        if (result == "sftp_connected") {
          var array = await client.sftpLs();
          setState(() {
            _result = result;
            _array = array;
          });

          print(await client.sftpMkdir("testsftp"));
          print(await client.sftpRename(
            oldPath: "testsftp",
            newPath: "testsftprename",
          ));
          print(await client.sftpRmdir("testsftprename"));

          Directory tempDir = await getTemporaryDirectory();
          String tempPath = tempDir.path;
          var filePath = await client.sftpDownload(
            path: "testupload",
            toPath: tempPath,
            callback: (progress) async {
              print(progress);
              // if (progress == 20) await client.sftpCancelDownload();
            },
          );

          print(await client.sftpRm("testupload"));

          print(await client.sftpUpload(
            path: filePath,
            toPath: ".",
            callback: (progress) async {
              print(progress);
              // if (progress == 30) await client.sftpCancelUpload();
            },
          ));

          print(await client.disconnectSFTP());

          print(await client.disconnect());
        }
      }
    } on PlatformException catch (e) {
      print('Error: ${e.code}\nError Message: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ButtonTheme(
          padding: EdgeInsets.all(5.0),
          child: ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text(
                  'Test command',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  (_domain.text != null)
                      ? onClickCmd(_domain.text)
                      : print(_domain.text);
                },
                color: Colors.blue,
              ),
              FlatButton(
                child: Text(
                  'Test shell',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: onClickShell,
                color: Colors.blue,
              ),
              FlatButton(
                child: Text(
                  'Test SFTP',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: onClickSFTP,
                color: Colors.blue,
              ),
            ],
          ),
        ),
        TextField(
          controller: _domain,
          decoration: InputDecoration(
            filled: true,
            labelText: 'Domain',
            errorText: _domainValidate ? 'Please Enter Domain Name' : null,
          ),
        ),
        Text(
          _result ?? "NULL",
          style: Theme.of(context).textTheme.body1,
        ),
      ],
    );
    //   ),
    // );
  }
}
