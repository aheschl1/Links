import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:links/constants/event.dart';
import 'package:links/constants/group.dart';
import 'package:links/screens/home/create/event/title_description.dart';
import 'package:links/services/database_service.dart';

import 'location_date.dart';
import 'other_settings.dart';


class Create extends StatefulWidget {

  final Function changeIndex;
  final Group group;

  Create({this.changeIndex, this.group});

  @override
  _CreateState createState() => _CreateState();

}

class _CreateState extends State<Create> {

  int currentScreen = 0;

  Event futureEvent = Event();

  startNextStage(Event event){

    setState(() {
      futureEvent = event;
      currentScreen ++;
    });

  }

  saveEvent(Event event) async {
    futureEvent = event;
    futureEvent.owner = FirebaseAuth.instance.currentUser.uid;

    if(widget.group == null){
      String result = await DatabaseService().addEvent(event);
      final snackBar = SnackBar(
        content: Text(result != null ? "Event posted" : "Something went wrong"),
        behavior: SnackBarBehavior.floating, // Add this line
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      print(result);
      print(event.groupChatEnabledID);

      await FirebaseMessaging.instance.subscribeToTopic(result);
      if(event.groupChatEnabledID != null){
        FirebaseMessaging.instance.subscribeToTopic(event.groupChatEnabledID);
      }

      widget.changeIndex(0);

    }else{
      String result = await DatabaseService().addEventToGroup(event, widget.group);
      final snackBar = SnackBar(
        content: Text(result != null ? "Event posted" : "Something went wrong"),
        behavior: SnackBarBehavior.floating, // Add this line
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      print(result);
      print(event.groupChatEnabledID);

      await FirebaseMessaging.instance.subscribeToTopic(result);
      if(event.groupChatEnabledID != null){
        FirebaseMessaging.instance.subscribeToTopic(event.groupChatEnabledID);
      }

      Navigator.of(context).pop();

    }


  }

  @override
  Widget build(BuildContext context) {

    List<Widget> createStages = [
      EnterTitleAndDescription(finished: startNextStage, event: futureEvent),
      EnterLocationAndDate(finished: startNextStage, event:  futureEvent),
      OtherSettingsAndSave(save: saveEvent, event: futureEvent, group:widget.group == null ? false : true),
    ];

    return createStages[currentScreen];
  }
}
