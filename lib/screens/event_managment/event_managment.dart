import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:links/constants/event.dart';
import 'package:links/screens/event_managment/my_post_manage.dart';
import 'package:links/screens/event_managment/post_in_manage.dart';

class EventManagement extends StatefulWidget {
  @override
  _EventManagementState createState() => _EventManagementState();
}

class _EventManagementState extends State<EventManagement> {

  Event event;
  bool notif;
  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {

    event = ModalRoute.of(context).settings.arguments as Event;

    return event.owner == user.uid ? ManageMyPost(event: event) : ManageEventIn(event:event);

  }

}
