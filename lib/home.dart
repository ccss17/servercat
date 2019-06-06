import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';
import 'server.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_netdata/netdata-realtime/realtime-processes.dart';
import 'package:flutter_netdata/netdata-realtime/realtime-ram.dart';
import 'netdata-charts/fetch-info.dart';

const LatLng _center = const LatLng(36.018932, 129.342941);

// https://sergiandreplace.com/planets-flutter-creating-a-planet-card/
// 여기에 가이드 나와있는 Stack 으로 구글 맵 해서 위도경도 표시해주고싶다
// 그리고 서버 CPU, RAM, NetworkIO 간단하게 밑에 표시해주고 싶다.

class HomePage extends StatefulWidget {
  final drawerItems = [
    DrawerItem("Add Server", LineIcons.plus),
    DrawerItem("Sign out", LineIcons.sign_out),
    DrawerItem("test out", LineIcons.sign_out),
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

  static const LatLng _center = const LatLng(36.018932, 129.342941);

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
                      child: Text("Flutter\nNetdata",
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
      backgroundColor: Color(0xff75d701),
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
              icon: Icon(LineIcons.navicon),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
      ),
      title: Text('Server List'),
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

  _getTopCard(Server server) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: 70,
            height: 70,
            child: Center(
              child:
                  // test,
                  Text(
                "GOOGLE\nMAP\nPLACE",
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                server.label ?? "NULL",
                style: TextStyle(fontSize: 30),
              ),
              Text(
                "SERVER STATE",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              SizedBox(
                height: 10,
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
          Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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

  _getDeleteIcon(DocumentSnapshot data) {
    return Container(
      alignment: Alignment.center,
      child: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Color(0xee6666b2),
                  title: Text(
                    "Delete Server",
                    style: TextStyle(color: Colors.white),
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
                        Firestore.instance.runTransaction((transaction) async {
                          await transaction.delete(data.reference);
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: 10),
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
    );
  }

  Widget _getMap() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: SizedBox(
          width: 100.0,
          height: 100.0,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 15.0,
            ),
          ),
        ),
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
            return ListView(
              children: (false)
                  ? <Widget>[_getMap()]
                  : snapshot.data.documents.map((data) {
                      final server = Server.fromSnapshot(data);
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/charts', arguments: server);
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.80,
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: _getBoxDeco(),
                          child: Column(
                            children: <Widget>[
                              _getTopCard(server),
                              Divider(),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 14.0, vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    FetchServerInfo(
                                      serv: server,
                                      interval: 5000,
                                    ),
                                  ],
                                ),
                              ),
                              _getDeleteIcon(data)
                              // MapTest(),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
            );
          },
        ));
  }
}
