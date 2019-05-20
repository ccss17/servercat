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
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.network(
                    'https://image.i-voce.jp/files/article/main/7Rt7xosL_1544077098.jpg'),
              ],
            ),
            SizedBox(
              height: 10,
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
              minWidth: 300,
              onPressed: () => authService.googleSignIn(),
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Google'),
            );
          }
        });
  }
}
