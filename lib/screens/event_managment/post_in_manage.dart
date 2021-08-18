import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
      body: StreamBuilder<Event>(
        stream: widget.event.liveUpdate,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: SpinKitFoldingCube(color: Colors.white,),
            );
          }
          Event event = snapshot.data;
          return Column(
            children: [
              WidgetMyPage(event, null),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.group),
                        label: Text("Group chat"),
                        onPressed: event.groupChatEnabledID == null ? null : (){openGroupchat();},
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
                        icon: Icon(Icons.message),
                        label: Text("Message owner"),
                        onPressed: (){openOwnerChat();},
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
              ViewUsersInGroup(event: event, onTap: viewFriendProfile,),
            ],
          );
        }
      ),
    );
  }
}
