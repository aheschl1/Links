import 'package:flutter/material.dart';
import 'package:links/screens/auth/login.dart';
import 'package:links/screens/auth/register.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool login = false;

  void changeState(){
      setState(() {
        login = !login;
      });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to Links"),
      ),
      body: login ? Login(
          signup: ()=>changeState
      ) :
      SignUp(
        login: ()=>changeState
      )
    );
  }

}
