import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';
import 'server.dart';

class EditPage extends StatefulWidget {
  Server serv;
  EditPage({this.serv});

  @override
  State<StatefulWidget> createState() {
    return EditPageState(this.serv);
  }
}

class EditPageState extends State<EditPage> {
  var _label;
  var _domain;
  var _sshid;
  var _pw;
  var _protocol;
  var _port;

  bool _portValidate = false;
  bool _protocolValidate = false;
  bool _domainValidate = false;
  bool _pwValidate = false;
  bool _labelValidate = false;
  bool _hostValidate = false;
  String _uuid;
  EditPageState(Server serv) {
    this._label = TextEditingController(text: serv.label);
    this._domain = TextEditingController(text: serv.domain);
    this._sshid = TextEditingController(text: serv.sshid);
    this._pw = TextEditingController(text: serv.pw);
    this._protocol = TextEditingController(text: serv.protocol);
    this._port = TextEditingController(text: serv.port);
    this._uuid = serv.uuid;
  }

  bool allfilled() {
    return !_domainValidate &&
        !_hostValidate &&
        !_labelValidate &&
        !_pwValidate &&
        !_protocolValidate &&
        !_portValidate;
  }

  void checkAllTextController() {
    void _check(TextEditingController con, bool val) {
      con.text.isEmpty ? val = true : val = false;
    }

    _check(_domain, _domainValidate);
    _check(_sshid, _hostValidate);
    _check(_label, _labelValidate);
    _check(_pw, _pwValidate);
    _check(_port, _portValidate);
    _check(_protocol, _protocolValidate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white70,
      // backgroundColor: Color(0xff333366),
      backgroundColor: Color(0xffe2e2e2),
      appBar: AppBar(
        backgroundColor: Color(0xff353848),
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.greenAccent,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit',
          style: TextStyle(color: Colors.greenAccent),
        ),
        centerTitle: true,
        actions: <Widget>[
          MaterialButton(
            child: Text(
              "Save",
              style: TextStyle(color: Colors.greenAccent),
            ),
            onPressed: () async {
              setState(() {
                checkAllTextController();
              });
              if (allfilled()) {
                var data = Map<String, dynamic>();
                data['domain'] = _domain.text;
                data['sshid'] = _sshid.text;
                data['label'] = _label.text;
                data['pw'] = _pw.text;
                data['port'] = _port.text;
                data['uuid'] = _uuid;
                data['protocol'] = _protocol.text;
                data['uid'] = authService.getUid();
                Firestore.instance.runTransaction((transaction) async {
                  await transaction.set(
                      Firestore.instance
                          .collection("servers")
                          .document(data['uuid']),
                      data);
                });
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          getTextField(
              _label, 'Server label', 'Please Enter Domain Name', false,
              validate: _labelValidate),
          getTextField(_domain, 'Server IP or Domain',
              'Please Enter IP or Domain Name', false,
              help: "ex) 192.168.0.1 or www.example.com ",
              validate: _domainValidate),
          getTextField(_protocol, 'Netdata Protocol',
              'Please Enter Netdata Protocol', false,
              validate: _protocolValidate),
          getTextField(
              _port, 'Netdata Port', 'Please Enter Netdata Port', false,
              intType: true, validate: _portValidate),
          getTextField(_sshid, 'SSH ID', 'Please Enter SSH ID', false,
              validate: _hostValidate),
          getTextField(_pw, 'SSH Password', 'Please Enter SSH Password', true,
              validate: _pwValidate),
        ],
      ),
    );
  }

  Widget getTextField(TextEditingController _controller, String _label,
      String _error, bool obscure,
      {bool intType = false, String help = null, bool validate}) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: TextField(
        keyboardType: intType ? TextInputType.number : TextInputType.text,
        autofocus: true,
        controller: _controller,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          helperText: help, // "This is help message",
          labelText: _label,
          errorText: validate ? _error : null,
        ),
        obscureText: obscure,
      ),
    );
  }
}
