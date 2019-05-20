import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';
import 'server.dart';

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
              List<Widget> tmp = snapshot.data.documents
                  .map((data) => _buildListItem(context, data))
                  .toList();
              tmp.add(Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                elevation: 2.0,
                child: Column(
                  children: <Widget>[
                    Text(
                      "Connect your server!",
                      style: Theme.of(context).textTheme.title,
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/add');
                      },
                    ),
                  ],
                ),
              ));
              return GridView.count(
                crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                childAspectRatio: 0.90,
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                children: tmp,
                // snapshot.data.documents
                //     .map((data) => _buildListItem(context, data))
                //     .toList(),
              );
            },
          );
        }));
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final server = Server.fromSnapshot(data);

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      elevation: 2.0,
      child: Column(
        children: <Widget>[
          Text(
            server.domain ?? "TEST",
            style: Theme.of(context).textTheme.title,
          ),
          Text(
            server.host ?? "TEST",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
