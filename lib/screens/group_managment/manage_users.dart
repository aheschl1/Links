import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/constants/group.dart';
import 'package:links/services/database_service.dart';

class ManageUsers extends StatefulWidget {

  final Group group;
  final Function(FriendData) removeUser;
  final Function(FriendData) onTap;

  ManageUsers({required this.group, required this.removeUser, required this.onTap});

  @override
  _ManageUsersState createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:
        FutureBuilder<List<FriendData>>(
            future: DatabaseService().getUsersInGroupp(widget.group),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                if (snapshot.data!.length == 0) {
                  return SizedBox(height:300,child:
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Nobody is in this group yet",
                        style: TextStyle(fontSize: 20, ), textAlign: TextAlign.center,),
                    )
                    );
                } else {
                  return SizedBox(
                  height: 300,
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: InkWell(
                              onTap: ()=>widget.onTap(snapshot.data![index]),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Text(snapshot.data![index].name),
                                    SizedBox(width: 18,),
                                    Text(snapshot.data![index].email),
                                    Spacer(),
                                    TextButton.icon(
                                        onPressed: (){widget.removeUser(snapshot.data![index]);},
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
                }
              }else{
                return SizedBox(
                    height: 300,
                    child: SpinKitCircle(
                        color:Colors.white
                    )
                );
              }
            }
        ),
    );
  }
}
