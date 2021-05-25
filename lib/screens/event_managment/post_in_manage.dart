import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:links/constants/event.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/widgets/event_widget.dart';
import 'package:links/widgets/user_in_group.dart';

class ManageEventIn extends StatefulWidget {

  final Event event;

  ManageEventIn({this.event});

  @override
  _ManageEventInState createState() => _ManageEventInState();
}

class _ManageEventInState extends State<ManageEventIn> {

  openGroupchat(){
    Navigator.of(context).pushNamed('/groupchat', arguments: widget.event);
  }

  openOwnerChat(){
    Navigator.of(context).pushNamed('/private_message', arguments: {'event' : widget.event});
  }

  viewFriendProfile(FriendData friendData){
    Navigator.of(context).pushNamed('/view_profile', arguments: friendData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Link"),
      ),
      body: Column(
        children: [
          WidgetMyPage(widget.event),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.group),
                  label: Text("Group chat"),
                  onPressed: widget.event.groupChatEnabledID == null ? null : (){openGroupchat();},
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          )
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                        return Colors.blueGrey;
                      },),
                    )

                ),
              ),
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.message),
                  label: Text("Message owner"),
                  onPressed: (){openOwnerChat();},
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          )
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                        return Colors.blueAccent;
                      },),
                    )
                ),
              ),
            ],
          ),
          ViewUsersInGroup(event: widget.event, onTap: viewFriendProfile,),
        ],
      ),
    );
  }
}
