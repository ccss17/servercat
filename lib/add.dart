import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';

class AddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddPageState();
  }
}

class AddPageState extends State<AddPage> {
  final _domain = TextEditingController();
  final _host = TextEditingController();
  bool _domainValidate = false;
  bool _hostValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey,
          brightness: Brightness.light,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Add'),
          centerTitle: true,
          actions: <Widget>[
            MaterialButton(
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                setState(() {
                  _domain.text.isEmpty
                      ? _domainValidate = true
                      : _domainValidate = false;
                  _host.text.isEmpty
                      ? _hostValidate = true
                      : _hostValidate = false;
                });
                if (!_domainValidate && !_hostValidate) {
                  var data = Map<String, dynamic>();
                  data['domain'] = _domain.text;
                  data['host'] = _host.text;
                  data['uid'] = authService.getUid();
                  Firestore.instance.runTransaction((transaction) async {
                    await transaction.set(
                        Firestore.instance
                            .collection("servers")
                            .document(data['uid']),
                        data);
                  });
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                TextField(
                  controller: _domain,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Domain',
                    errorText:
                        _domainValidate ? 'Please Enter Domain Name' : null,
                  ),
                ),
                TextField(
                  controller: _host,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Host',
                    errorText: _hostValidate ? 'Please Enter Host' : null,
                  ),
                ),
              ],
              // ),
            ),
          ],
        ));
  }
}
