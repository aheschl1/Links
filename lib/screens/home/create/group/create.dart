import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:links/constants/group.dart';
import 'package:links/screens/home/create/group/name_description.dart';
import 'package:links/screens/home/create/group/other_settings.dart';
import 'package:links/services/database_service.dart';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();

  final Function changeIndex;

  CreateGroup({this.changeIndex});

}

class _CreateGroupState extends State<CreateGroup> {

  int currentScreen = 0;
  Group futureGroup = Group();

  startNextStage(Group group){
    setState(() {
      futureGroup = group;
      currentScreen ++;
    });

  }

  saveGroup(Group group) async {
    futureGroup = group;
    futureGroup.owner = FirebaseAuth.instance.currentUser.uid;

    String result = await DatabaseService().addGroup(group);
    final snackBar = SnackBar(
      content: Text(result != null ? "Group created" : "Something went wrong"),
      behavior: SnackBarBehavior.floating, // Add this line
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    print(result);

    await FirebaseMessaging.instance.subscribeToTopic(result);
    FirebaseMessaging.instance.subscribeToTopic(group.groupchatId);

    widget.changeIndex(0);

  }

  @override
  Widget build(BuildContext context) {

    List<Widget> createStages = [
      EnterNameAndDescription(finished: startNextStage, group: futureGroup),
      OtherSettingsAndSave(save: saveGroup, group: futureGroup),
    ];

    return createStages[currentScreen];
  }
}
