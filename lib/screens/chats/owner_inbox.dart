
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:links/constants/decorations.dart';
import 'package:links/constants/event.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/constants/request.dart';
import 'package:links/screens/loading.dart';
import 'package:links/services/database_service.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class OwnerInbox extends StatefulWidget {
  @override
  _OwnerInboxState createState() => _OwnerInboxState();
}

class _OwnerInboxState extends State<OwnerInbox> {

  final key = GlobalKey<AnimatedListState>();

  Event event;
  List<FriendData> peopleInGroup = [];

  openMessage(FriendData data){
    Navigator.of(context).pushNamed('/private_message', arguments: {"event" : event, "to" : data.userId});
  }

  allowRequest(Request request, int index) async {
    String result = await DatabaseService().allowRequestStatus(event, request);
    if(result == "Event joined"){
      result = "Request permitted";
    }
    final snackBar = SnackBar(content: Text(result));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    key.currentState.removeItem(index, (context,animation)=>SizedBox());
  }

  denyRequest(Request request) async {
    String result = await DatabaseService().denyRequestStatus(event, request);
    final snackBar = SnackBar(content: Text(result));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  getAllUserForMessage()async{
    List<FriendData> people = await DatabaseService().getUsersInGroup(event);
    setState(() {
      peopleInGroup = people;
    });
  }

  showRequests(){
    showModalBottomSheet(
      context: context,
      builder: (context){
        return FutureBuilder<List<Request>>(
          future: DatabaseService().getRequests(event),
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
                    "No new requests",
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
                  child: Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.red[400],
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.not_interested_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction)=>denyRequest(requests[index]),
                    child: ListTile(
                      trailing: IconButton(
                        icon: Icon(Icons.check_circle_outline_outlined),
                        onPressed: ()=>allowRequest(requests[index], index),

                      ),
                      tileColor: Colors.white24,
                      title: Text(requests[index].userName),
                      subtitle: Text(requests[index].userEmail),
                    ),
                  ),
                );

              }
            );

          },
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    event = ModalRoute.of(context).settings.arguments as Event;

    if(peopleInGroup.isEmpty){
      getAllUserForMessage();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${event.title} inbox"),
        actions: event.requireConfirmation == false ? [] : [
          TextButton.icon(

              icon: Icon(Icons.all_inbox, color: Colors.white),
              onPressed: ()=>showRequests(),
              label: Text('Requests', style: TextStyle(color: Colors.white),)
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:  SearchableDropdown.single(
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

                //if error in testing remove second check

                if(snapshot.connectionState != ConnectionState.done && snapshot.data == null){
                  return Loading();
                }

                List<FriendData> friends = snapshot.data;

                return friends.length == 0 ?

                      TextButton.icon(label: Text("No messages"), icon: Icon(Icons.refresh), onPressed: (){setState(() {

                      });},)

                    : ListView.builder(
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

              },
            ),
          ),
        ],
      ),
    );

  }
}
