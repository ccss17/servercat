import 'package:flutter/material.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff353848),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                child: Text(
                  "Flutter",
                  style: TextStyle(fontSize: 70, color: Colors.white),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                child: Text(
                  "Netdata",
                  style: TextStyle(fontSize: 70, color: Colors.white),
                ),
              ),
            ),
//            Column(
//              children: <Widget>[
//                Image.network(
//                    'https://image.i-voce.jp/files/article/main/7Rt7xosL_1544077098.jpg'),
//              ],
//            ),
            SizedBox(
              height: 100,
            ),
            LoginButton(),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: authService.user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Navigator.pop(context);
            return MaterialButton(
              onPressed: () => {},
              color: Colors.black,
              textColor: Colors.white,
              child: Text('Already Singed In'),
            );
          } else {
            return MaterialButton(
              height: 50,
              minWidth: 100,
              onPressed: () => authService.googleSignIn(),
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Google'),
            );
          }
        });
  }
}
