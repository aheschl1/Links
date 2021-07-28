import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/constants/level_types.dart';
import 'package:links/constants/user_data_save.dart';
import 'package:links/payments/screens/collect_payout.dart';
import 'package:links/screens/alternate/manage_tags.dart';
import 'package:links/services/auth_service.dart';
import 'package:links/services/database_service.dart';

import 'account_level.dart';
import 'add_friends.dart';

class Settings extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  FriendData me;
  UserData myData;
  AccountLevels accountLevelStatus;

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
    getAccountLevel();
  }

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
    showModalBottomSheet(
      context: context,
        builder: (context) => Container(
          height: 400,
          width: double.infinity,
          child: AddFriends()
      ),
    ).then((value) => getMyData());
  }

  editMyNameAndEmail() async {
    await Navigator.of(context).pushNamed('/edit_info', arguments: me);
    getMyData();
  }

  manageTagNotifs(){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return ManageTagSubs();
        }
    );
  }

  collectPayout() async {
    showModalBottomSheet(
      context: context,
      builder:(context) => CollectPayout()
    );
  }

  void getAccountLevel() async {
    var level = await DatabaseService().getAccountLevel();
    setState(() {
      accountLevelStatus = level;
    });
  }

  accountPrivalage(){

    showModalBottomSheet(
      context: context,
      builder: (context){
        return AccountLevel(accountLevelCurrent:accountLevelStatus);
      }
    );

  }

  @override
  Widget build(BuildContext context) {

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
                      TextButton.icon(
                        onPressed: ()=>manageFriends(),
                        label: Text("Manage your friends"),
                        icon: Icon(Icons.people),
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
            SizedBox(height: 10,),
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
            Card(
                child: InkWell(
                  onTap: ()=>collectPayout(),
                  child: ListTile(
                    leading: Icon(Icons.attach_money, color: Colors.blue, size: 30.0),
                    title: Text(
                      "Collect payout",
                      style: TextStyle(
                          fontSize: 15
                      ),
                    ),
                    subtitle: Text("Collect money that you have earned"),
                  ),
                )
            ),
            Spacer(),
            Card(
                color: Colors.purple[200],
                child: InkWell(
                  onTap: ()=>accountPrivalage(),
                  child: ListTile(
                    leading: Icon(Icons.lock_outline, color: Colors.blue, size: 30.0),
                    title: Text(
                      "Account level",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      accountLevelStatus != AccountLevels.BASIC ? (accountLevelStatus == null ? 'Loading' : (accountLevelStatus == AccountLevels.PRO ? 'Pro' : 'Advertiser')) : 'Basic'
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}

