import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';
import 'server.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_netdata/netdata-realtime/realtime-processes.dart';
import 'package:flutter_netdata/netdata-realtime/realtime-ram.dart';
import 'netdata-charts/fetch-info.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          backgroundColor: Color(0xff353848),
          brightness: Brightness.light,
          title: Text('Remove Server'),
          centerTitle: true,
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          return StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('servers')
                .where('uid', isEqualTo: authService.getUid())
                .snapshots(),
            builder: (context, snapshot) {
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
                            height: MediaQuery.of(context).size.width * 0.60,
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10.0,
                                    offset: Offset(0.0, 10.0),
                                  )
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 70,
                                        height: 70,
                                        child: Text("GOOGLE\nMAP"),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                          Text(
                                            server.sshid,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
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
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    FetchServerInfo(
                                      serv: server,
                                      interval: 5000,
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
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
                                                              color:
                                                                  Colors.white),
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
                                    )
                                  ],
                                ),
                              ],
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
