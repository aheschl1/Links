import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text("My Post"),
      ),
      body: StreamBuilder<Event>(
        stream: widget.event.liveUpdate,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: SpinKitFoldingCube(color: Colors.white,)
            );
          }
          Event event = snapshot.data;
          return Column(
            children: [
              WidgetMyPage(event),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.group),
                        label: Text("Group chat"),
                        onPressed: widget.event.groupChatEnabledID == null ? null : (){openGroupchat();},
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )
                            ),
                            backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                              return Colors.blueGrey;
                            },),
                          )
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.inbox),
                        label: Text("Group inbox"),
                        onPressed: (){openInbox();},
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )
                            ),
                            backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                              return Colors.blueAccent;
                            },),
                          )
                      ),
                    ),
                  ),
                ],
              ),
              ManageUsersInGroup(event: event, removeUser: removeUser, onTap: viewFriendProfile,)
            ],
          );
        }
      ),
    );
  }
}
