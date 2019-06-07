import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../auth.dart';

class ShadowText extends StatelessWidget {
  ShadowText(this.data, {this.style}) : assert(data != null);

  final String data;
  final TextStyle style;

  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          Positioned(
            top: 2.0,
            left: 2.0,
            child: Text(
              data,
              style: style.copyWith(color: Colors.black.withOpacity(1.0)),
            ),
          ),
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
            child: Text(data, style: style),
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff353848),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/bg.PNG'))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: SizedBox(
                    child: ShadowText(
                  "Server Cat",
                  style: TextStyle(fontSize: 70, color: Colors.white),
                )),
              ),
              LoginButton(),
            ],
          ),
        ));
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
              height: MediaQuery.of(context).size.height * 0.05,
              minWidth: MediaQuery.of(context).size.width * 0.825,
              onPressed: () => {},
              color: Colors.black,
              textColor: Colors.white,
              child: Text('Already Singed In'),
            );
          } else {
            return MaterialButton(
              height: MediaQuery.of(context).size.height * 0.05,
              minWidth: MediaQuery.of(context).size.width * 0.825,
              onPressed: () => authService.googleSignIn(),
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Google Login'),
            );
          }
        });
  }
}
