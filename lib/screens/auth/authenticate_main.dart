import 'package:flutter/material.dart';
import 'package:links/screens/auth/login.dart';
import 'package:links/screens/auth/register.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool _showSignIn = false;

  void switchAuth(){
    setState(() {
      _showSignIn = !_showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showSignIn ? SignIn (switchAuth) : Register(switchAuth);
  }
}
