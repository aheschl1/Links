import 'package:flutter/material.dart';
import 'package:links/constants/event.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/services/database_service.dart';
import 'package:links/widgets/event_widget.dart';
import 'package:links/widgets/user_in_group.dart';

class ManageMyPost extends StatefulWidget {

  final Event event;

  ManageMyPost({this.event});

  @override
  _ManageMyPostState createState() => _ManageMyPostState();
}

class _ManageMyPostState extends State<ManageMyPost> {

  Event eventNew;

  openGroupchat(){
    Navigator.of(context).pushNamed('/groupchat', arguments: eventNew == null ? widget.event : eventNew);
  }

  openInbox(){
    Navigator.of(context).pushNamed('/inbox', arguments: eventNew == null ? widget.event : eventNew);
  }

  removeUser(FriendData user) async
  {
    String result = await DatabaseService().kickFromEvent(userId: user.userId, eventId: widget.event.docId);
    final snackBar = SnackBar(content: Text(result));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    eventNew = await DatabaseService().getOneTimeEvent(widget.event.docId);
    setState((){});
  }


  viewFriendProfile(FriendData friendData){
    Navigator.of(context).pushNamed('/view_profile', arguments: friendData);
  }

  @override
  Widget build(BuildContext context) {

    Event eventUse = eventNew == null ? widget.event : eventNew;

    return Scaffold(
      appBar: AppBar(
        title: Text("My Post"),
      ),
      body: Column(
        children: [
          WidgetMyPage(eventUse),
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
                  icon: Icon(Icons.inbox),
                  label: Text("Group inbox"),
                  onPressed: (){openInbox();},
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
          ManageUsersInGroup(event: eventUse, removeUser: removeUser, onTap: viewFriendProfile,)
        ],
      ),
    );
  }
}
