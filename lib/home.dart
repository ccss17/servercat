import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';
import 'server.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_netdata/netdata-realtime/realtime-processes.dart';
import 'package:flutter_netdata/netdata-realtime/realtime-cpu.dart';
import 'package:flutter_netdata/netdata-realtime/realtime-ram.dart';
import 'netdata-charts/fetch-info.dart';

// https://sergiandreplace.com/planets-flutter-creating-a-planet-card/
// 여기에 가이드 나와있는 Stack 으로 구글 맵 해서 위도경도 표시해주고싶다
// 그리고 서버 CPU, RAM, NetworkIO 간단하게 밑에 표시해주고 싶다.

class HomePage extends StatefulWidget {
  final drawerItems = [
    DrawerItem("Add Server", LineIcons.plus),
    DrawerItem("Sign out", LineIcons.sign_out),
//    DrawerItem("test out", LineIcons.sign_out),
  ];
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class HomePageState extends State<HomePage> {
  bool desc = false;
  String selectedCategory = 'ALL';
  int _selectedDrawerIndex = 0;
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _pohang = const LatLng(36.018932, 129.342941);
  static const LatLng _yeosu = const LatLng(34.760372, 127.662224);
  static const LatLng _seoul = const LatLng(37.566536, 126.977966);
  static const LatLng _tokyo = const LatLng(35.689487, 139.691711);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onSelectItem(BuildContext context, int index) {
    setState(() {
      _selectedDrawerIndex = index;
    });
    Navigator.of(context).pop(); // close the drawer
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/add');
        break;
      case 1:
        authService.signOut();
        Navigator.of(context).pushNamed('/login');
        break;
      case 2:
        authService.signOut();
        Navigator.of(context).pushNamed('/map');
        break;
      default:
        break;
    }
  }

  Widget _getDrawer() {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(ListTile(
        leading: Icon(
          d.icon,
          color: Colors.white70,
        ),
        title: Text(
          d.title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(context, i),
      ));
    }
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color(0xff353848),
      ),
      child: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              child: DrawerHeader(
                  child: Center(
                      child: Text("Server Cat",
                          style: TextStyle(
                            fontSize: 39,
                            color: Colors.greenAccent,
                          )))),
              color: Color(0xff353848),
            ),
            Divider(
              color: Colors.grey,
            ),
            Column(
              children: drawerOptions,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getFloatBtn() {
    return FloatingActionButton(
//      backgroundColor: Color(0xff75d701),
      backgroundColor: Colors.red,
      onPressed: () {
        Navigator.of(context).pushNamed('/add');
      },
      child: Icon(
        Icons.add,
        size: 25,
      ),
    );
  }

  Widget _getAppbar() {
    return AppBar(
      backgroundColor: Color(0xff353848),
      brightness: Brightness.light,
      leading: Builder(
        builder: (context) => IconButton(
              icon: Icon(
                LineIcons.navicon,
                color: Colors.greenAccent,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
      ),
      title: Text(
        'Server List',
        style: TextStyle(color: Colors.greenAccent),
      ),
      centerTitle: true,
    );
  }

  _getBoxDeco() {
    return BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          )
        ]);
  }

  _getTopCard(Server server, LatLng loc) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 150,
                height: 100,
                child: Center(
                  child: _getMap(loc),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    server.label ?? "NULL",
                    style: TextStyle(fontSize: 30),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "NORMAL",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        server.domain,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        server.sshid,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'CPU',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Proc',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'RAM',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RealTimeCPU(
                    serv: server,
                    interval: 5000,
                  ),
                  RealTimeProcesses(
                    serv: server,
                    interval: 5000,
                  ),
                  RealTimeRAM(
                    serv: server,
                    interval: 5000,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _getSettingIcons(DocumentSnapshot data, Server serv) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            color: Colors.deepPurple,
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(('/edit'), arguments: serv);
            },
          ),
          IconButton(
//            color: Colors.deepOrange,
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Color(0xff353848),
//                      backgroundColor: Color(0xee6666b2),
                      title: Text(
                        "Delete Server",
                        style: TextStyle(color: Colors.greenAccent),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          color: Colors.blue,
                          child: Center(
                            child: Text(
                              "Delete",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            Firestore.instance
                                .runTransaction((transaction) async {
                              await transaction.delete(data.reference);
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            },
          ),
        ],
      ),
    );
  }

  Widget _getMap(LatLng loc) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: loc,
        zoom: 10.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: _getDrawer(),
        floatingActionButton: _getFloatBtn(),
        backgroundColor: Colors.white70,
        appBar: _getAppbar(),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('servers')
              .where('uid', isEqualTo: authService.getUid())
              .snapshots(),
          builder: (context, snapshot) {
            List<Widget> test = List<Widget>();
            for (int i = 0; i < snapshot.data.documents.length; i++) {
              final server = Server.fromSnapshot(snapshot.data.documents[i]);
              test.add(GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/charts', arguments: server);
                },
                child: Container(
//                          height: MediaQuery.of(context).size.width * 0.80,
                  height: MediaQuery.of(context).size.width * 0.65,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: _getBoxDeco(),
                  child: Column(
                    children: <Widget>[
                      _getTopCard(server, (i % 2 == 0) ? _seoul : _tokyo),
//                      _getTopCard(server, (i % 2 == 0) ? _y eosu : _pohang),
                      Divider(),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            FetchServerInfo(
                              serv: server,
                              interval: 5000,
                            ),
                          ],
                        ),
                      ),
                      _getSettingIcons(snapshot.data.documents[i], server)
                      // MapTest(),
                    ],
                  ),
                ),
              ));
            }
            return ListView(children: test);
          },
        ));
  }
}
