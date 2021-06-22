import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:links/constants/event.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/services/database_service.dart';

class ManageUsersInGroup extends StatefulWidget {
  final Event event;
  final Function removeUser;
  final Function onTap;

  ManageUsersInGroup({this.event, this.removeUser, this.onTap});

  @override
  _ManageUsersInGroupState createState() => _ManageUsersInGroupState();
}

class _ManageUsersInGroupState extends State<ManageUsersInGroup> {
  @override
  Widget build(BuildContext context) {
     return ExpansionTile(
       title: Text("Manage Users"),
       children: [
         FutureBuilder<List<FriendData>>(
           future: DatabaseService().getUsersInGroup(widget.event),
           builder: (context, snapshot){
              if(snapshot.data != null){
                return SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: InkWell(
                            onTap: ()=>widget.onTap(snapshot.data[index]),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: [ 
                                  Text(snapshot.data[index].name),
                                  SizedBox(width: 18,),
                                  Flexible(
                                    child: Text(
                                      snapshot.data[index].email.substring(0, 15) + '...'
                                    )
                                  ),
                                  Spacer(),
                                  TextButton.icon(
                                      onPressed: (){widget.removeUser(snapshot.data[index]);},
                                      icon: Icon(Icons.person_remove),
                                      label: Text("Remove")
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                );
              }else{
                return SizedBox(
                    height: 300,
                    child: SpinKitCircle(
                        color:Colors.black
                    )
                );
              }
           }
         ),
       ],
     );
  }
}


class ViewUsersInGroup extends StatefulWidget {
  final Event event;
  final Function onTap;
  ViewUsersInGroup({this.event, this.onTap});

  @override
  _ViewUsersInGroupState createState() => _ViewUsersInGroupState();
}

class _ViewUsersInGroupState extends State<ViewUsersInGroup> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("View people attending"),
      children: [
        FutureBuilder<List<FriendData>>(
            future: DatabaseService().getUsersInGroup(widget.event),
            builder: (context, snapshot){
              if(snapshot.data != null){
                return SizedBox(
                  height: 300,
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: InkWell(
                              onTap: ()=>widget.onTap(snapshot.data[index]),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    Text(snapshot.data[index].name),
                                    SizedBox(width: 18,),
                                    Flexible(
                                        child: Text(
                                            snapshot.data[index].email.substring(0, 15) + '...'
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                );
              }else{
                return SizedBox(
                    height: 300,
                    child: SpinKitCircle(
                        color:Colors.black
                    )
                );
              }
            }
        ),
      ],
    );
  }
}
