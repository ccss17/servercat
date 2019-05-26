import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';
import 'server.dart';
import 'post.dart';

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
          onPressed: () {
            Navigator.of(context).pushNamed('/add');
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Colors.grey,
          brightness: Brightness.light,
          leading: Builder(
            builder: (context) => IconButton(
                  icon: Icon(Icons.account_circle),
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
              print(snapshot.data.documents.length);
              return GridView.count(
                crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                childAspectRatio: 0.90,
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                children: snapshot.data.documents
                    .map((data) => _buildListItem(context, data))
                    .toList(),
              );
            },
          );
        }));
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final server = Server.fromSnapshot(data);

    return GestureDetector(
        onTap: () {
          List<String> args = [
            'http',
            '54.180.132.66',
            '19999',
            'system.processes'
          ];
          Navigator.of(context).pushNamed('/charts', arguments: args);
        },
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          elevation: 2.0,
          child: Column(
            children: <Widget>[
              Text(
                server.label ?? "NULL",
                style: Theme.of(context).textTheme.title,
              ),
              Text(
                server.domain,
                style: Theme.of(context).textTheme.title,
              ),
              Text(
                server.host,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ));
  }
}
