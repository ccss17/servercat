import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';
import 'server.dart';
import 'package:line_icons/line_icons.dart';
import 'fetch-processes.dart';
import 'realtime.dart';

// https://sergiandreplace.com/planets-flutter-creating-a-planet-card/
// 여기에 가이드 나와있는 Stack 으로 구글 맵 해서 위도경도 표시해주고싶다
// 그리고 서버 CPU, RAM, NetworkIO 간단하게 밑에 표시해주고 싶다.

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  bool desc = false;
  String selectedCategory = 'ALL';

  @override
  Widget build(BuildContext context) {
    BuildContext _context = context;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff75d701),
          onPressed: () {
            Navigator.of(context).pushNamed('/add');
          },
          child: Icon(
            Icons.add,
            size: 25,
//            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white70,
//        backgroundColor: Color(0xff333366),
        appBar: AppBar(
          backgroundColor: Color(0xff353848),
          brightness: Brightness.light,
          leading: Builder(
            builder: (context) => IconButton(
                  icon: Icon(LineIcons.navicon),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/profile');
                  },
                ),
          ),
          title: Text('Main'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                authService.signOut();
                Navigator.of(context).pushNamed('/login');
              },
            ),
          ],
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          return StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('servers')
                .where('uid', isEqualTo: authService.getUid())
                .snapshots(),
            builder: (context, snapshot) {
//              print(snapshot.data.documents.length);
              return ListView(
                children: snapshot.data.documents != null
                    ? snapshot.data.documents.map((data) {
                        final server = Server.fromSnapshot(data);
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/charts', arguments: server);
                          },
                          child: Container(
                            height: 300.0,
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
//                                color: Color(0xee6666b2),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10.0,
                                    offset: Offset(0.0, 10.0),
                                  )
                                ]),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 40.0, vertical: 30.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: Text("GOOGLE\nMAP"),
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Text(
                                                  server.label ?? "NULL",
                                                  style: TextStyle(
//                                          color: Colors.white,
                                                      fontSize: 30),
                                                ),
                                                Text(
                                                  "SERVER STATE",
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        Color(0xee6666b2),
                                                    title: Text(
                                                      "Delete Server",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        color: Colors.blue,
                                                        child: Center(
                                                          child: Text(
                                                            "Delete",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Firestore.instance
                                                              .runTransaction(
                                                                  (transaction) async {
                                                            await transaction
                                                                .delete(data
                                                                    .reference);
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      SizedBox(width: 10),
                                                      FlatButton(
                                                        child: Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      )
                                                    ],
                                                  );
                                                });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 40.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text("Processes"),
                                              RealTimeProcesses(
                                                serv: server,
                                                interval: 5000,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList()
                    : Text("NULL"),
              );
            },
          );
        }));
  }
}
