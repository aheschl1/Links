
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:links/constants/event.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/constants/request.dart';
import 'package:links/services/database_service.dart';
import 'package:links/widgets/event_widget.dart';
import 'package:links/widgets/request_view.dart';

class Mine extends StatefulWidget {

  Mine();

  @override
  _MineState createState() => _MineState();
}

class _MineState extends State<Mine> {

  bool expansionOpen = false;
  GlobalKey<AnimatedListState> key = GlobalKey<AnimatedListState>();
  FriendData? me;

  deleteEvent(Event event) async {
    bool delete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Do you want to delete this event?'),
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
      String result = await DatabaseService().deleteEvent(event);
      if(result == "Deleted successfully"){
        if(event.groupChatEnabledID != null){
          FirebaseMessaging.instance.unsubscribeFromTopic(event.groupChatEnabledID!);
        }
      }
      final snackBar = SnackBar(
        content: Text(result),
        behavior: SnackBarBehavior.floating, // Add this line
      );      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {});
    }

  }
  leaveEvent(Event event) async {
    bool leave = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Do you want to leave this event?'),
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
      String result = await DatabaseService().leaveEvent(event.docId!);
      final snackBar = SnackBar(
        content: Text(result),
        behavior: SnackBarBehavior.floating, // Add this line
      );      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {});
    }
  }
  openEvent(Event event){
    Navigator.of(context).pushNamed("/view_event", arguments:  event);
  }

  joinEvent(Event event) async {
    String result;

    if(double.parse(event.admissionPrice!) > 0){
      Navigator.of(context).pushNamed("/payments", arguments: event);
    }else{
      if(event.requireConfirmation == null || !event.requireConfirmation!){
        result = await DatabaseService().joinEvent(event);
      }else{
        Request request = Request(userId: FirebaseAuth.instance.currentUser!.uid, decision: Request.PENDING, userEmail: me!.email, userName: me!.name);
        result = await DatabaseService().requestToJoin(event, request);
      }

      final snackBar = SnackBar(
        content: Text(result),
        behavior: SnackBarBehavior.floating, // Add this line
      );      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }

  }

  notInterestedInEvent(Event event) async {
    String result = await DatabaseService().notInterested(event);
    final snackBar = SnackBar(
      content: Text(result),
      behavior: SnackBarBehavior.floating, // Add this line
    );    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() {

    });
  }

  getMe()async{
    me = FriendData.fromMap(await DatabaseService().getUser(FirebaseAuth.instance.currentUser!.uid));
  }

  dismissRequest(Request request) async {
    String result = await DatabaseService().agknoledgeRequestDecision(request);
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

    return  Container(
      child: ListView(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        children: [
          ExpansionTile(
            leading: Icon(Icons.person),
            title: Text("My Posts"),
            children: [
              FutureBuilder<List<Event>>(
                future: DatabaseService().getMyEventsCreated(),
                builder: (context, snapshot){

                  if(snapshot.connectionState == ConnectionState.done){
                    List<Event> eventsToDisplay = [];
                    eventsToDisplay = snapshot.data!;
                    return eventsToDisplay.length == 0 ?
                    TextButton.icon(label: Text("You have not posted any events yet"), icon: Icon(Icons.refresh), onPressed: (){setState(() {

                    });},)
                        : SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: eventsToDisplay.length,
                        itemBuilder: (context, int index){
                          Event event = eventsToDisplay[index];
                          return MyEventWidget(
                            event: event,
                            deleteEvent: () => deleteEvent(event),
                            more: () => openEvent(event),
                          );
                        },
                      ),
                    );
                  }else{
                    return SizedBox(
                      height: 80,
                        child: SpinKitFoldingCube(
                            color:Colors.black
                        )
                    );
                  }


                },
              ) //My Posts
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.calendar_today_outlined),
            title: Text("My Events"),
            children: [
              FutureBuilder<List<Event>>(
                future: DatabaseService().getMyEventsIn(),
                builder: (context, snapshot){

                  List<Event> eventsToDisplay = [];

                  if(snapshot.connectionState == ConnectionState.done){
                    eventsToDisplay = snapshot.data!;
                    return eventsToDisplay.length == 0 ?
                    TextButton.icon(label: Text("You have not joined any links"), icon: Icon(Icons.refresh), onPressed: (){setState(() {

                    });},)
                        : SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: eventsToDisplay.length,
                        itemBuilder: (context, int index){
                          Event event = eventsToDisplay[index];
                          return MyEventIn(
                            event: event,
                            leaveEvent: () => leaveEvent(event),
                            more: (){openEvent(event);},
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
            leading: Icon(Icons.inbox_outlined),
            title: Text("My Invites"),
            children: [
              FutureBuilder<List<Event>>(
                future: DatabaseService().getPrivateEventsToDisplay(15),
                builder: (context, snapshot){

                  List<Event>? eventsToDisplay = [];

                  if(snapshot.connectionState == ConnectionState.done){
                    eventsToDisplay = snapshot.data;
                    return eventsToDisplay != null && eventsToDisplay.length == 0 ?
                    TextButton.icon(label: Text("No invites to show"), icon: Icon(Icons.refresh), onPressed: (){setState(() {

                    });},)
                        : SizedBox(
                      height: 300,
                      child:  AnimatedList(
                        initialItemCount: eventsToDisplay!.length,
                        key: key,
                        itemBuilder: (context, int index, animation){
                          Event event = eventsToDisplay![index];
                          return Dismissible(

                            onDismissed: (direction){
                              if(direction == DismissDirection.endToStart){
                                notInterestedInEvent(event);
                              }else{
                                joinEvent(event);
                              }
                            },
                            direction: DismissDirection.horizontal,
                            key: UniqueKey(),

                            child: EventWidget(
                              event: event,
                              join: (){
                                joinEvent(event);
                                snapshot.data!.removeAt(index);
                                key.currentState!.removeItem(index, (context,animation)=>SizedBox());
                              },
                              notInterested: () {
                                notInterestedInEvent(event);
                                snapshot.data!.removeAt(index);
                                key.currentState!.removeItem(index, (context,animation)=>SizedBox());
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
                future: DatabaseService().getRequestsPending(),
                builder: (context, snapshot){

                  List<Request>? requestsToDisplay = [];

                  if(snapshot.connectionState == ConnectionState.done){

                   requestsToDisplay = snapshot.data;

                    return requestsToDisplay != null && requestsToDisplay.length == 0 ?
                    TextButton.icon(label: Text("No requests to show"), icon: Icon(Icons.refresh), onPressed: (){setState(() {

                    });},)
                        : SizedBox(
                      height: 300,
                      child:  AnimatedList(
                        initialItemCount: requestsToDisplay!.length,
                        key: key,
                        itemBuilder: (context, int index, animation){
                          Request request = requestsToDisplay![index];
                          return ViewRequest(request: request, ok: ()=>dismissRequest(request));
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
