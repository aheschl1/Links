import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/constants/group.dart';
import 'package:links/constants/tag.dart';
import 'package:links/services/database_service.dart';
import 'package:links/widgets/select_friends.dart';
import 'package:provider/provider.dart';

class OtherSettingsAndSave extends StatefulWidget {

  final Function(Group) save;
  final Group? group;

  OtherSettingsAndSave({required this.save, this.group});

  @override
  _OtherSettingsAndSaveState createState() => _OtherSettingsAndSaveState();

}

class _OtherSettingsAndSaveState extends State<OtherSettingsAndSave> {

  bool public = true;
  bool confirmation = true;
  bool anyoneCanPost = true;

  List<FriendData>? usersPermitted;

  List<Tag> tags = [];

  FirebaseAuth auth = FirebaseAuth.instance;

  void done() async {
    //cost
    //gc
    String groupchatId = await DatabaseService().createGroupChat(auth.currentUser!.uid);
    widget.group!.groupchatId = groupchatId;

    widget.group!.private = !public;
    widget.group!.requireConfirmation = confirmation;
    widget.group!.anyoneCanPost = anyoneCanPost;

    if(usersPermitted != null){
      List permitted = [];
      for(FriendData friend in usersPermitted!){
        permitted.add(friend.userId);
      }
      widget.group!.usersPermitted = permitted;
    }

    widget.save(widget.group!);

  }


  @override
  Widget build(BuildContext context) {
    return FutureProvider<List<Tag>>(
      initialData: [],
      create: (data)=>  DatabaseService().getTags(),
      child: FutureProvider<List<FriendData>>(
        initialData: [],
        create: (data) => DatabaseService().getUserFriends(auth.currentUser!.uid),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SwitchListTile(
                  tileColor: Theme.of(context).cardColor,
                  title: public ? Text("Public") : Text("Private"),
                  secondary: public ? Icon(Icons.public) : Icon(Icons.public_off),
                  value: public,
                  onChanged: (val){
                    setState(() {
                      public = val;
                    });
                  }
              ),
              SelectFriends(hide: public, onChanged: (data){
                setState(() {
                  usersPermitted = data;
                });
              },),
              SizedBox(height: 8,),
              SwitchListTile(
                  tileColor: Theme.of(context).cardColor,
                  title: Text("Confirmation"),
                  subtitle: confirmation ? Text("Confirmation required to join") : Text("Join without confirmation"),
                  secondary: confirmation ? Icon(Icons.check_circle_rounded) : Icon(Icons.check_circle_outline_outlined),
                  value: confirmation,
                  onChanged: (val){
                    setState(() {
                      confirmation = val;
                    });
                  }
              ),
              SizedBox(height: 8,),
              SwitchListTile(
                  tileColor: Theme.of(context).cardColor,
                  title: Text("Posts"),
                  subtitle:  anyoneCanPost ? Text("Anyone can post content") : Text("Only you can post content"),
                  secondary: anyoneCanPost ? Icon(Icons.lock_open) : Icon(Icons.lock_outline),
                  value: anyoneCanPost,
                  onChanged: (val){
                    setState(() {
                      anyoneCanPost = val;
                    });
                  }
              ),
              SizedBox(height: 20,),
              ElevatedButton.icon(
                  onPressed: (){
                    done();
                  },
                  icon: Icon(Icons.navigate_next),
                  label: Text("Save")
              ),
            ],
          ),
        ),
      ),
    );
  }

}
