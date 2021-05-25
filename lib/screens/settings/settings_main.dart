import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/constants/user_data_save.dart';
import 'package:links/screens/alternate/manage_tags.dart';
import 'package:links/services/auth_service.dart';
import 'package:links/services/database_service.dart';

import 'add_friends.dart';
import 'edit_name_and_email.dart';

class Settings extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  FriendData me;
  UserData myData;

  void getMyData() async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    UserData data = await DatabaseService().getUserPreferences(uid);
    Map map = await DatabaseService().getUser(uid);
    setState(() {
      me = FriendData.fromMap(map);
      myData = data;
    });
  }

  void manageFriends(){
    Navigator.of(context).pushNamed('/friends');
  }

  @override
  void initState() {
    super.initState();
    getMyData();
  }

  @override
  Widget build(BuildContext context) {

    logout() async{
      AuthService authService = AuthService();
      var result = await authService.signOut();
      if(result is String){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
            duration: Duration(
                seconds: 5
            ),
          )
        );
      }
      else{Navigator.of(context).pop();}
    }

    addFriends(){
      var bottomSheetController = scaffoldKey.currentState.showBottomSheet(
        (context) => Container(
          height: 400,
          width: double.infinity,
          color: Colors.white,
          child: AddFriends()
        ),
      );

      bottomSheetController.closed.then((value) => getMyData());
    }

    editMyNameAndEmail(){
      var bottomSheetController = scaffoldKey.currentState.showBottomSheet(
          (context) => Container(
            height: 400,
            width: double.infinity,
            color: Colors.white,
            child: EditNameAndEmail(nameOg: me.name, bioOg: me.bio,)
          ),
      );

      bottomSheetController.closed.then((value) => getMyData());

    }

    manageTagNotifs(){
     showModalBottomSheet(
        context: context,
        builder: (context){
          return ManageTagSubs();
        }
      );
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("My Account"),
        actions: [
          TextButton.icon(
              onPressed: (){
                logout();
              },
              icon: Icon(Icons.logout, color: Colors.white,),
              label: Text("Sign Out", style: TextStyle(color: Colors.white),)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: 20,),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Text(
                        me != null ? me.name : "Name",
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 25
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        me != null ? me.email : "Email",
                        style: TextStyle(
                            letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Flexible(
                        flex: 0,
                        child: Text(
                          me != null ? me.bio : "Bio",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                      icon: Icon(Icons.edit),
                      iconSize: 20,
                      onPressed: ()=>editMyNameAndEmail()
                  ),
                )
              ],
            ),
            Divider(height: 30,),
            Card(
              child: InkWell(
                onTap: ()=>addFriends(),
                child: ListTile(
                  leading: Icon(Icons.person_add, color: Colors.blue, size: 30.0),
                  title: Text(
                    "You have ${myData!=null&&myData.following!=null?myData.following.length:0} ${myData!=null&&myData.following!=null && myData.following.length == 1 ? " friend" : " friends"}",
                    style: TextStyle(
                        fontSize: 15
                    ),
                  ),
                  subtitle: Text("Links is better with friends, add some!"),
                ),
              )
            ),
            TextButton.icon(
              onPressed: ()=>manageFriends(),
              label: Text("Or, manage your friends"),
              icon: Icon(Icons.people),
            ),
            SizedBox(height: 10,),
            Card(
                child: InkWell(
                  onTap: ()=>manageTagNotifs(),
                  child: ListTile(
                    leading: Icon(Icons.tag, color: Colors.blue, size: 30.0),
                    title: Text(
                      "Subscribe to tags",
                      style: TextStyle(
                          fontSize: 15
                      ),
                    ),
                    subtitle: Text("Get notified about new events"),
                  ),
                )
            ),

          ],
        ),
      ),
    );
  }
}
