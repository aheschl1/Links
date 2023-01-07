
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:links/constants/event.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/screens/loading.dart';
import 'package:links/services/database_service.dart';
import 'package:search_choices/search_choices.dart';

class OwnerInbox extends StatefulWidget {
  @override
  _OwnerInboxState createState() => _OwnerInboxState();
}

class _OwnerInboxState extends State<OwnerInbox> {

  final key = GlobalKey<AnimatedListState>();

  Event? event;
  List<FriendData> peopleInGroup = [];

  openMessage(FriendData data){
    Navigator.of(context).pushNamed('/private_message', arguments: {"event" : event, "to" : data.userId});
  }

  getAllUserForMessage()async{
    List<FriendData> people = await DatabaseService().getUsersInGroup(event!);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(()=>peopleInGroup = people);
    });
  }

  refresh(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { setState(() {});});
  }

  @override
  Widget build(BuildContext context) {

    event = ModalRoute.of(context)!.settings.arguments as Event;

    if(peopleInGroup.isEmpty){
      getAllUserForMessage();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${event!.title} inbox"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:  SearchChoices.single(
              icon: Icon(Icons.search),
              isExpanded: true,
              hint: "Start a conversation",
              items: peopleInGroup.map((item){
                return new DropdownMenuItem(
                  child: Text(item.name),
                  value: item,
                );
              }
              ).toList(),
              onChanged: (value){
                if(value != null){
                  openMessage(value);
                }
              }
            ),
          ),

          Expanded(
            child: FutureBuilder<List<FriendData>>(
              future: DatabaseService().getOwnerInbox(event),
              builder: (context, snapshot){

                if(snapshot.connectionState != ConnectionState.done){
                  return SpinKitFoldingCube(color: Colors.white,);
                }

                List<FriendData> friends = snapshot.data!;
                return Builder(builder: (context){
                  if(friends.length == 0){
                    return TextButton.icon(label: Text("No messages"), icon: Icon(Icons.refresh), onPressed:refresh());
                  }else{
                    return ListView.builder(
                        itemCount: friends.length,
                        itemBuilder: (context, index){
                          FriendData data = friends[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: InkWell(
                                onTap: ()=>openMessage(data),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          data.name,
                                          style: TextStyle(
                                              fontSize: 18
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 18, 0),
                                        child: Text(
                                          data.email,
                                          style: TextStyle(
                                              fontSize: 13
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.message,
                                        color: Theme.of(context).accentColor,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  }
                });
              },
            ),
          ),
        ],
      ),
    );

  }
}
