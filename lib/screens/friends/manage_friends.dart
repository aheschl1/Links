import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/services/database_service.dart';

class ManageFriends extends StatefulWidget {
  @override
  _ManageFriendsState createState() => _ManageFriendsState();
}

class _ManageFriendsState extends State<ManageFriends> {

  final key = GlobalKey<AnimatedListState>();

  removeFriend(FriendData friend) async {
    String result = await DatabaseService().removeFriend(friend.userId);

    final snackBar = SnackBar(
      content: Text(result),
      behavior: SnackBarBehavior.floating, // Add this line
    );
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar,

    );
  }

  viewFriendProfile(FriendData friendData){
    Navigator.of(context).pushNamed('/view_profile', arguments: friendData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Friends'),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: FutureBuilder<List<FriendData>>(
          future: DatabaseService().getUserFriends(FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){

              List<FriendData> friends = snapshot.data!;
              if(friends.isEmpty){
                return Center(
                  child: Text(
                    "Looks like you don't have any friends yet"
                  ),
                );
              }
              return AnimatedList(
                key: key,
                initialItemCount: friends.length,
                itemBuilder: (context, index, animation){

                  return InkWell(
                    onTap: ()=>viewFriendProfile(friends[index]),
                    child: Dismissible(
                      key: GlobalKey(),
                      onDismissed: (direction)=>removeFriend(friends[index]),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red[400],
                        margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Icon(
                            Icons.person_remove,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      confirmDismiss: (DismissDirection direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text("Are you sure you want to remove this friend?"),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text("Remove")
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text("Cancel"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Text(snapshot.data![index].name!),
                              SizedBox(width: 18,),
                              Text(snapshot.data![index].email!),
                              Spacer(),
                              TextButton.icon(
                                  onPressed: (){
                                    removeFriend(friends[index]);
                                    key.currentState!.removeItem(index, (context,animation)=>SizedBox());
                                  },
                                  icon: Icon(Icons.person_remove),
                                  label: Text("Remove")
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );

                },
              );

            }else{
              return SpinKitFoldingCube(
                color: Colors.white,
              );
            }
          },
        ),
      ),
    );
  }
}
