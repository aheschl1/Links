import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:links/constants/event.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/constants/user_data_save.dart';
import 'package:links/services/database_service.dart';
import 'package:links/widgets/event_widget.dart';
import 'package:links/constants/request.dart';

class ViewFriend extends StatefulWidget {

  @override
  _ViewFriendState createState() => _ViewFriendState();
}

class _ViewFriendState extends State<ViewFriend> {
  FriendData? friendData;
  FriendData? me;
  bool friends = false;

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
      );
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar,

      );

    }

  }

  notInterestedInEvent(Event event) async{
    String result = await DatabaseService().notInterested(event);
    final snackBar = SnackBar(
      content: Text(result),
      behavior: SnackBarBehavior.floating, // Add this line
    );    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }


  getFriendsAlready()async{
    UserData? userDate = await DatabaseService().getUserPreferences(FirebaseAuth.instance.currentUser!.uid);

    if(userDate!.following!.contains(friendData!.userId)){
      setState(() {
        friends = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFriendsAlready();
  }

  getMe()async{
    me = await DatabaseService().getUser(FirebaseAuth.instance.currentUser!.uid);
  }

  followPerson(FriendData friendData) async {
    String result = await DatabaseService().addFriend(friendData.userId);
    final snackBar = SnackBar(content: Text(result),  behavior: SnackBarBehavior.floating,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    if(result != "Something went wrong"){
      setState(() {
        friends = true;
      });
    }
  }

  removeFriend(FriendData friend) async {
    String result = await DatabaseService().removeFriend(friend.userId);

    final snackBar = SnackBar(
      content: Text(result),
      behavior: SnackBarBehavior.floating, // Add this line
    );
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar,
    );

    if(result != "Something went wrong"){
      setState(() {
        friends = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    friendData = ModalRoute.of(context)!.settings.arguments as FriendData;

    getMe();

    List<Event> eventsToDisplay = [];
    final key = GlobalKey<AnimatedListState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(friendData!.name),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    friendData!.name,
                    style: TextStyle(
                        letterSpacing: 1,
                        fontSize: 25
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    friendData!.email,
                    style: TextStyle(
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              IconButton(
                color: friends ? Theme.of(context).errorColor : Theme.of(context).buttonColor,
                icon: friends ? Icon(Icons.person_remove) : Icon(Icons.person_add),
                onPressed: friends ? ()=>removeFriend(friendData!) : ()=>followPerson(friendData!),
              )
            ],
          ),
          Divider(height: 30, indent: 100, endIndent: 120, color: Colors.white,),
          Flexible(
            flex: 0,
            child: Text(
              friendData!.bio!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                letterSpacing: 1,
              ),
            ),
          ),
          Divider(height: 30,),
          Expanded(
            child: FutureBuilder<List<Event>>(
                future: DatabaseService().getUserEventsCreated(friendData!.userId!),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.done){
                    eventsToDisplay = snapshot.data!;
                    return Container(
                      padding: EdgeInsets.fromLTRB(8, 15, 8, 8),
                      child:
                      eventsToDisplay.length == 0 ?  TextButton.icon(label: Text("This user has no public events posted"), icon: Icon(Icons.refresh), onPressed: (){setState(() {

                      });},) :
                      AnimatedList(
                        initialItemCount: eventsToDisplay.length,
                        key: key,
                        itemBuilder: (context, int index, animation){
                          Event event = eventsToDisplay[index];
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
                              margin: EdgeInsets.fromLTRB(0, 12, 0, 12),
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
                              margin: EdgeInsets.fromLTRB(0, 12, 0, 12),
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
                    return SpinKitFoldingCube(color: Colors.white);
                  }
                }
            ),
          ),

        ],
      )
    );
  }
}
