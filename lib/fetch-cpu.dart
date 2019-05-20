// import 'dart:async';
// import 'package:flutter_netdata/netdata-charts/cpu-chart.dart';

// import 'package:flutter/material.dart';
// import 'post.dart';

// class FetchCpu extends StatefulWidget {
//   final Future<Post> post;

//   FetchCpu({this.post});
//   @override
//   FetchCpuState createState() => FetchCpuState(post: this.post);
// }

// class FetchCpuState extends State<FetchCpu> {
//   Future<Post> post;
//   Timer _timer;

//   FetchCpuState({this.post});

//   _generateTrace(Timer t) {
//     setState(() {
//       post = fetchPost('system.cpu');
//     });
//   }

//   @override
//   initState() {
//     super.initState();
//     _timer = Timer.periodic(Duration(milliseconds: 2000), _generateTrace);
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Fetch Data Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Fetch Data Example'),
//           backgroundColor: Colors.black,
//         ),
//         body: Center(
//           child: FutureBuilder<Post>(
//             future: post,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return MaterialApp(
// //        theme: defaultConfig.theme,
// //        showPerformanceOverlay: _showPerformanceOverlay,
//                   home: ListView(
//                     padding: EdgeInsets.all(8.0),
//                     children: <Widget>[
//                       SizedBox(
//                         height: 250.0,
//                         child: CpuChart.withJson(snapshot.data),
//                       ),
//                     ],
//                   ),
//                 );
//               } else if (snapshot.hasError) {
//                 return Text("${snapshot.error}");
//               }
//               return CircularProgressIndicator();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
