import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:links/screens/auth/authenticate_main.dart';
import 'package:links/screens/home/home.dart';
import 'package:links/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:links/screens/alternate/no_connection.dart';

class Wrapper extends StatefulWidget {

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  bool online = true;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  getPermissions()async {

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  void initState() {
    super.initState();
    getPermissions();

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result == ConnectivityResult.wifi || result == ConnectivityResult.mobile){
        setState(() {
          online = true;
        });
      }else{
        setState(() {
          online = false;
        });
      }
    });


  }

  messagingSetup() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if(token != null){
      DatabaseService().reconcileTokenSheet(token);
      FirebaseMessaging.instance.onTokenRefresh.listen((event) {
        DatabaseService().reconcileTokenSheet(event);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    if(online){
      final dynamic user = Provider.of<User?>(context);
      if(user == null){
        return Authenticate();
      }else{
        messagingSetup();
        return Home();
      }
    }else{
      Navigator.of(context).popUntil(ModalRoute.withName('/'));
      return NoConnection();
    }


  }

}