import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:links/constants/event.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/constants/request.dart';
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

  final key = GlobalKey<AnimatedListState>();
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

  allowRequest(Request request, int index) async {

    bool confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Do you want to permit this request?'),
          actions: <Widget>[
            new TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(false); // dismisses only the dialog and returns false
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(true);// dismisses only the dialog and returns true
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if(confirm){
      String result = await DatabaseService().allowRequestStatus(widget.event, request);
      if(result == "Event joined"){
        result = "Request permitted";
      }
      final snackBar = SnackBar(content: Text(result));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      key.currentState.removeItem(index, (context,animation)=>SizedBox());
      Navigator.of(context).pop();
    }
  }

  denyRequest(Request request) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Do you want to deny this request?'),
          actions: <Widget>[
            new TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(false); // dismisses only the dialog and returns false
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(true);// dismisses only the dialog and returns true
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if(confirm){
      String result = await DatabaseService().denyRequestStatus(widget.event, request);
      final snackBar = SnackBar(content: Text(result));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
    }

  }

  showRequests(){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return FutureBuilder<List<Request>>(
            future: DatabaseService().getRequests(widget.event),
            builder: (context, snapshot){
              if(snapshot.hasError || snapshot.connectionState == ConnectionState.waiting){
                return SpinKitFoldingCube(color: Colors.white,);
              }
              if(snapshot.data.length == 0){
                return SizedBox(
                  height: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "There are no new requests",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18
                      ),
                    ),
                  ),
                );
              }

              List<Request> requests = snapshot.data;

              return AnimatedList(
                  key: key,
                  initialItemCount: requests.length,
                  itemBuilder: (context, index, animation){

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(requests[index].userName),
                              SizedBox(width:10),
                              Text(requests[index].userEmail),
                              Spacer(),
                              IconButton(
                                color: Colors.green[700],
                                icon: Icon(Icons.check_circle_outline_outlined),
                                onPressed: ()=>allowRequest(requests[index], index),
                              ),
                              IconButton(
                                color: Colors.red[700],
                                icon: Icon(Icons.not_interested_outlined),
                                onPressed: ()=>denyRequest(requests[index]),
                              ),
                            ],
                          ),
                        )
                      ),
                    );

                  }
              );

            },
          );
        }
    );
  }

  editEvent(Event event){
    event.docId = widget.event.docId;
    Navigator.of(context).pushNamed('/edit_event', arguments:  event);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("My Post"),
        actions: widget.event.requireConfirmation == false ? [] : [
          TextButton.icon(
            icon: Icon(Icons.all_inbox, color: Colors.white),
            onPressed: ()=> showRequests(),
            label: Text('Requests', style: TextStyle(color: Colors.white),)
          )
        ],
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
              WidgetMyPage(event, (){editEvent(event);}),
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
