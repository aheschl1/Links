import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/constants/user_data_save.dart';
import 'package:links/screens/alternate/manage_tags.dart';
import 'package:links/services/auth_service.dart';
import 'package:links/services/database_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

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
  var amountOwed;

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
    calculateAmountOwed();
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

  editMyNameAndEmail(){
    showModalBottomSheet(
      context: context,
      builder: (context) => EditNameAndEmail(nameOg: me.name, bioOg: me.bio,),
    ).then((value) => getMyData());

  }

  manageTagNotifs(){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return ManageTagSubs();
        }
    );
  }

  calculateAmountOwed() async {
    amountOwed = await DatabaseService().calculateAmountOwed();
  }

  collectPayout() async {
    showModalBottomSheet(
      context: context,
      builder:(context) {

        return Container(
          child: FutureBuilder<UserData>(
            future: DatabaseService().getUserPreferences(FirebaseAuth.instance.currentUser.uid),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){

                UserData myData = snapshot.data;

                if(myData.paypalKey == null || myData.paypalKey.length == 0){
                  return Column(
                    children: [
                      SizedBox(height: 10,),
                      Text(
                        'You need to connect to PayPal',
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Links uses PayPal to send payouts. We do not save any of your PayPal information.",
                        style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 12,
                            color: Colors.white54
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Expanded(
                          child:Center(
                              child:  amountOwed == null ? SpinKitFoldingCube(color: Colors.white,) :
                              Card(
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    amountOwed > 0 ? "You have $amountOwed dollars waiting for you!" : "You do not have any money to collect",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              )
                          ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ))),
                            onPressed: () => loginWithPaypal(),
                            icon: Icon(Icons.login),
                            label: Text("Connect to PayPal")
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    SizedBox(height: 10,),
                    Text(
                      'You\'re all setup',
                      style: TextStyle(
                        fontSize: 20
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      "Your balance will be sent to your PayPal account.",
                      style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 12,
                          color: Colors.white54
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextButton.icon(
                      label: Text('Change PayPal accounts'),
                      icon: Icon(Icons.logout),
                      onPressed: ()=>loginWithPaypal(),
                    ),
                    Expanded(
                      child: Center(
                          child:  amountOwed == null ? SpinKitFoldingCube(color: Colors.white,) :
                          Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                amountOwed > 0 ? "You have $amountOwed dollars waiting for you!" : "You do not have any money to collect",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ))),
                          onPressed: ()=>initiatePayout(),
                          icon: Icon(Icons.attach_money),
                          label: Text("Collect a payout!")
                      ),
                    ),
                  ],
                );

              }else{
                return SpinKitFoldingCube(color: Colors.white,);
              }
            },
          ),
        );

      }
    );
  }

  initiatePayout() async {
    var resultHTTP = await http.post(
        Uri.parse("https://us-central1-links-170cf.cloudfunctions.net/requestUserPayout"),
        body: {
          'uid' : FirebaseAuth.instance.currentUser.uid,
        });

    Navigator.of(context).pop();
    final snackBar = SnackBar(
      content: Text(resultHTTP.body),
      behavior: SnackBarBehavior.floating, // Add this line
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  loginWithPaypal() async {

    final Uri uri = Uri.https(
        'links-170cf.firebaseapp.com',
        '/paypal_auth.html',
        {
          'uid' : FirebaseAuth.instance.currentUser.uid
        }
    );
    await canLaunch(uri.toString()) ? await launch(uri.toString()) : throw 'Something went wrong';
    Navigator.of(context).pop();
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
          ],
        ),
      ),
    );
  }
}

