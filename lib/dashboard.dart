import 'package:flutter/material.dart';
import 'package:flutter_netdata/ssh_util.dart';
import 'directory.dart';
import 'ssh_util.dart';
import 'server.dart';
import 'package:flutter_netdata/netdata-charts/fetch-processes.dart';
import 'package:flutter_netdata/netdata-charts/fetch-ram.dart';
import 'package:flutter_netdata/netdata-charts/fetch-cpu.dart';
import 'package:line_icons/line_icons.dart';

class Dashboard extends StatelessWidget {
  final Server serv;

  getChartContainer(Widget chart) {
    return Container(
      height: 300.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
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
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: chart,
      ),
    );
  }

  Dashboard({this.serv});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          // backgroundColor: Color(0xff333366),
          backgroundColor: Colors.white70,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.greenAccent,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Color(0xff353848),
            brightness: Brightness.light,
            title: Text(
              serv.label,
              style: TextStyle(color: Colors.greenAccent),
            ),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                    icon: Icon(
                  LineIcons.line_chart,
                  color: Colors.greenAccent,
                )),
                Tab(
                    icon: Icon(
                  LineIcons.keyboard_o,
                  color: Colors.greenAccent,
                )),
                Tab(
                    icon: Icon(
                  LineIcons.files_o,
                  color: Colors.greenAccent,
                )),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              ListView(
                padding: EdgeInsets.all(8.0),
                children: <Widget>[
                  getChartContainer(FetchCPU(
                    serv: serv,
                    interval: 1000,
                  )),
                  getChartContainer(FetchProcesses(
                    serv: serv,
                    interval: 1000,
                  )),
                  getChartContainer(FetchRAM(
                    serv: serv,
                    interval: 1000,
                  )),
                ],
              ),
              Container(
                height: 300.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                decoration: BoxDecoration(
                    color: Colors.black87,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 10.0),
                      )
                    ]),
                child: SSHPage(
                    host: serv.domain, ssh_id: serv.sshid, ssh_pw: serv.pw),
              ),
              Container(
                height: 300.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 10.0),
                      )
                    ]),
                child: DirectoryView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
