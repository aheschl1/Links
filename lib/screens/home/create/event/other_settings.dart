import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:links/constants/event.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/constants/tag.dart';
import 'package:links/services/database_service.dart';
import 'package:links/widgets/select_friends.dart';
import 'package:links/widgets/select_tags.dart';
import 'package:provider/provider.dart';

class OtherSettingsAndSave extends StatefulWidget {

  final Function save;
  final Event event;
  final bool group;

  OtherSettingsAndSave({this.save, this.event, this.group = false});

  @override
  _OtherSettingsAndSaveState createState() => _OtherSettingsAndSaveState();

}

class _OtherSettingsAndSaveState extends State<OtherSettingsAndSave> {

  bool public = true;
  bool groupchat = true;
  bool confirmation = true;
  List<FriendData> usersPermitted;
  String price = "1";
  bool free = true;

  List<Tag> tags = [];

  FirebaseAuth auth = FirebaseAuth.instance;

  void done() async {
    //cost
    if(free){
      price = "0";
    }
    widget.event.admissionPrice = price;
    //gc
    if(groupchat){
      String groupchatId = await DatabaseService().createGroupChat(auth.currentUser.uid);
      widget.event.groupChatEnabledID = groupchatId;
    }

    widget.event.private = !public;
    widget.event.requireConfirmation = confirmation;

    if(usersPermitted != null){
      List permitted = [];
      for(FriendData friend in usersPermitted){
        permitted.add(friend.userId);
      }
      widget.event.usersPermitted = permitted;
    }
    widget.event.tags = tags.map((e) => e.name).toList();

    widget.save(widget.event);

  }


  @override
  Widget build(BuildContext context) {

    print(widget.group);

    return FutureProvider<List<Tag>>(
      initialData: [],
      create: (data)=>  DatabaseService().getTags(),
      child: FutureProvider<List<FriendData>>(
        initialData: [],
        create: (data) => DatabaseService().getUserFriends(auth.currentUser.uid),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              widget.group ? SizedBox() : SwitchListTile(
                tileColor: Theme.of(context).cardColor,
                title: public ? Text("Public") : Text("Private"),
                secondary: public ? Icon(Icons.public) : Icon(Icons.public_off),
                value: public,
                onChanged: (val){
                  setState(() {
                    public = val;
                  });
                }
              ),
              widget.group ? SizedBox() : SelectFriends(hide: public, onChanged: (data){
                setState(() {
                  usersPermitted = data;
                });
              },),
              SizedBox(height: 8,),
             SwitchListTile(
                  tileColor: Theme.of(context).cardColor,
                  title: Text("Group Chat"),
                  subtitle: groupchat ? Text("Group Chat On") : Text("Group Chat Off"),
                  secondary: groupchat ? Icon(Icons.chat_bubble) : Icon(Icons.chat_bubble_outline),
                  value: groupchat,
                  onChanged: (val){
                    setState(() {
                      groupchat = val;
                    });
                  }
              ),
              SizedBox(height: 8,),
              SwitchListTile(
                  tileColor: Theme.of(context).cardColor,
                  title: Text("Confirmation"),
                  subtitle: confirmation ? Text("Confirmation required to join") : Text("Join without confirmation"),
                  secondary: confirmation ? Icon(Icons.check_circle_rounded) : Icon(Icons.check_circle_outline_outlined),
                  value: confirmation,
                  onChanged: (val){
                    setState(() {
                      confirmation = val;
                    });
                  }
              ),
              SizedBox(height: 8,),
              SwitchListTile(
                  tileColor: Theme.of(context).cardColor,
                  title: free ? Text("Free") : Text("Paid"),
                  subtitle: free ? Text("This event is free") : Text("It costs $price \$ to join"),
                  secondary: free ? Icon(Icons.money_off) : Icon(Icons.money),
                  value: free,
                  onChanged: (val){
                    setState(() {
                      free = val;
                    });
                  }
              ),
              SizedBox(height: 8,),
              Opacity(
                opacity: free ? 0 : 1,
                child: Slider(
                  min: 0.0,
                  max: 30.0,
                  divisions: 290,
                  onChanged: (double value) {
                    setState(() {
                      price = value.toStringAsFixed(1);
                    });
                  },
                  value: double.parse(price),
                ),
              ),
              SizedBox(height: 8,),
              widget.group ? SizedBox() : SelectTags(
                onChanged: (data){
                  setState(() {
                    tags = data;
                    print(tags.map((e) => e.name).toList());
                  });
                },
              ),
              SizedBox(height: 20,),
              ElevatedButton.icon(
                  onPressed: (){
                    done();
                  },
                  icon: Icon(Icons.navigate_next),
                  label: Text("Save")
              ),
            ],
          ),
        ),
      ),
    );
  }

}
