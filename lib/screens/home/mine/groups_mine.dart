import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/constants/group.dart';
import 'package:links/constants/request.dart';
import 'package:links/services/database_service.dart';
import 'package:links/widgets/group_widget.dart';
import 'package:links/widgets/request_view.dart';

class MineGroups extends StatefulWidget {
  @override
  _MineGroupsState createState() => _MineGroupsState();
}

class _MineGroupsState extends State<MineGroups> {
  GlobalKey<AnimatedListState> key = GlobalKey<AnimatedListState>();
  FriendData me;

  openGroup(Group group){
    Navigator.of(context).pushNamed('/view_group', arguments: group);
  }
  getMe()async{
    me = FriendData.fromMap(await DatabaseService().getUser(FirebaseAuth.instance.currentUser.uid));
  }

  deleteGroup(Group group) async {
    bool delete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Do you want to delete this group?'),
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
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if(delete){
      String result = await DatabaseService().deleteGroup(group);
      if(result == "Deleted successfully"){
        if(group.groupchatId != null){
          FirebaseMessaging.instance.unsubscribeFromTopic(group.groupchatId);
        }
      }
      final snackBar = SnackBar(
        content: Text(result),
        behavior: SnackBarBehavior.floating, // Add this line
      );      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {});
    }

  }
  leaveGroup(Group event) async {
    bool leave = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Do you want to leave this group?'),
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
              child: Text('Leave'),
            ),
          ],
        );
      },
    );

    if(leave){
      String result = await DatabaseService().leaveGroup(event.docId);
      final snackBar = SnackBar(
        content: Text(result),
        behavior: SnackBarBehavior.floating, // Add this line
      );      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {});
    }
  }

  notInterestedInGroup(Group group) async {
    String result = await DatabaseService().notInterestedInGroup(group);
    final snackBar = SnackBar(
      content: Text(result),
      behavior: SnackBarBehavior.floating, // Add this line
    );    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() {

    });
  }

  joinGroup(Group group) async {
    String result;


    if(!group.requireConfirmation){
      result = await DatabaseService().joinGroup(group);
    }else{
      Request request = Request(userId: FirebaseAuth.instance.currentUser.uid, decision: Request.PENDING, userEmail: me.email, userName: me.name);
      result = await DatabaseService().requestToJoinGroup(group, request);
    }

    final snackBar = SnackBar(
      content: Text(result),
      behavior: SnackBarBehavior.floating, // Add this line
    );      ScaffoldMessenger.of(context).showSnackBar(snackBar);



  }

  dismissRequest(Request request) async {
    String result = await DatabaseService().agknoledgeRequestDecisionGroup(request);
    final snackBar = SnackBar(
      content: Text(result),
      behavior: SnackBarBehavior.floating, // Add this line
    );    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {

    getMe();

    return Container(
      child: Column(
        children: [
          ExpansionTile(
            leading: Icon(Icons.person),
            title: Text("My Groups"),
            children: [
              FutureBuilder<List<Group>>(
                future: DatabaseService().getMyGroupsCreated(),
                builder: (context, snapshot){

                  List<Group> eventsToDisplay = [];
                  eventsToDisplay = snapshot.data;

                  if(snapshot.connectionState == ConnectionState.done){
                    return eventsToDisplay.length == 0 ?
                    TextButton.icon(label: Text("You have not created any groups yet"), icon: Icon(Icons.refresh), onPressed: (){setState(() {

                    });},)
                        : SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: eventsToDisplay.length,
                        itemBuilder: (context, int index){
                          Group group = eventsToDisplay[index];
                          return MyGroupWidget(
                            group: group,
                            deleteEvent: () => deleteGroup(group),
                            more: () => openGroup(group),
                          );
                        },
                      ),
                    );
                  }else{
                    return SizedBox(
                        height: 80,
                        child: SpinKitCircle(
                            color:Colors.black
                        )
                    );
                  }


                },
              ) //My Posts
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.group),
            title: Text("Groups In"),
            children: [
              FutureBuilder<List<Group>>(
                future: DatabaseService().getMyGroupsIn(),
                builder: (context, snapshot){

                  List<Group> eventsToDisplay = [];
                  eventsToDisplay = snapshot.data;

                  if(snapshot.connectionState == ConnectionState.done){
                    return eventsToDisplay.length == 0 ?
                    TextButton.icon(label: Text("You have not joined any groups yet"), icon: Icon(Icons.refresh), onPressed: (){setState(() {

                    });},)
                        : SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: eventsToDisplay.length,
                        itemBuilder: (context, int index){
                          Group group = eventsToDisplay[index];
                          return MyGroupIn(
                            group: group,
                            leaveGroup: () => leaveGroup(group),
                            more: () => openGroup(group),
                          );
                        },
                      ),
                    );
                  }else{
                    return SizedBox(
                        height: 80,
                        child: SpinKitCircle(
                            color:Colors.black
                        )
                    );
                  }


                },
              ) //My Posts
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.inbox_outlined),
            title: Text("My Invites"),
            children: [
              FutureBuilder<List<Group>>(
                future: DatabaseService().getPrivateGroupsToDisplay(15),
                builder: (context, snapshot){

                  List<Group> groupsToDisplay = [];

                  if(snapshot.connectionState == ConnectionState.done){
                    groupsToDisplay = snapshot.data;
                    return groupsToDisplay != null && groupsToDisplay.length == 0 ?
                    TextButton.icon(label: Text("No invites to show"), icon: Icon(Icons.refresh), onPressed: (){setState(() {

                    });},)
                        : SizedBox(
                      height: 300,
                      child:  AnimatedList(
                        initialItemCount: groupsToDisplay.length,
                        key: key,
                        itemBuilder: (context, int index, animation){
                          Group group = groupsToDisplay[index];
                          return Dismissible(

                            onDismissed: (direction){
                              if(direction == DismissDirection.endToStart){
                                notInterestedInGroup(group);
                              }else{
                                joinGroup(group);
                              }
                            },
                            direction: DismissDirection.horizontal,
                            key: UniqueKey(),

                            child: GroupWidget(
                              group: group,
                              join: (){
                                joinGroup(group);
                                snapshot.data.removeAt(index);
                                key.currentState.removeItem(index, (context,animation)=>SizedBox());
                              },
                              notInterested: () {
                                notInterestedInGroup(group);
                                snapshot.data.removeAt(index);
                                key.currentState.removeItem(index, (context,animation)=>SizedBox());
                              },
                            ),

                            background: Container(
                              color: Colors.green[400],
                              margin: EdgeInsets.fromLTRB(0, 12, 12, 12),
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Icon(
                                  Icons.event_available_sharp,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            secondaryBackground: Container(
                              color: Colors.red[400],
                              margin: EdgeInsets.fromLTRB(0, 12, 12, 12),
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Icon(
                                  Icons.event_busy_rounded,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                          );
                        },
                      ),
                    );
                  }else{
                    return SizedBox(
                        height: 300,
                        child:  SpinKitCircle(
                            color:Colors.black
                        )
                    );
                  }
                },
              ) //My Posts
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.timer),
            title: Text("Pending Requests"),
            children: [
              FutureBuilder<List<Request>>(
                future: DatabaseService().getRequestsPendingGroups(),
                builder: (context, snapshot){

                  List<Request> requestsToDisplay = [];

                  if(snapshot.connectionState == ConnectionState.done){

                    requestsToDisplay = snapshot.data;

                    return requestsToDisplay != null && requestsToDisplay.length == 0 ?
                    TextButton.icon(label: Text("No requests to show"), icon: Icon(Icons.refresh), onPressed: (){setState(() {

                    });},)
                        : SizedBox(
                      height: 300,
                      child:  AnimatedList(
                        initialItemCount: requestsToDisplay.length,
                        key: key,
                        itemBuilder: (context, int index, animation){
                          Request request = requestsToDisplay[index];
                          return ViewRequestGroup(request: request, ok: ()=>dismissRequest(request));
                        },
                      ),
                    );
                  }else{
                    return SizedBox(
                        height: 300,
                        child:  SpinKitCircle(
                            color:Colors.black
                        )
                    );
                  }
                },
              ) //My Posts
            ],
          ),
        ],
      ),
    );
  }
}
