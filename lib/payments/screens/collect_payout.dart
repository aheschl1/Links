import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:links/constants/user_data_save.dart';
import 'package:links/services/database_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class CollectPayout extends StatefulWidget {
  const CollectPayout({Key key}) : super(key: key);

  @override
  _CollectPayoutState createState() => _CollectPayoutState();
}

class _CollectPayoutState extends State<CollectPayout> {

  var amountOwed;

  calculateAmountOwed() async {
    amountOwed = await DatabaseService().calculateAmountOwed();
  }


  @override
  void initState() {
    calculateAmountOwed();
    super.initState();
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

  initiatePayout() async {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                SizedBox(width: 18,),
                new Text("We're processing your payout"),
              ],
            ),
          ),
        );
      },
    );

    var resultHTTP = await http.post(
        Uri.parse("https://us-central1-links-170cf.cloudfunctions.net/requestUserPayout"),
        body: {
          'uid' : FirebaseAuth.instance.currentUser.uid,
        });

    Navigator.pop(context);
    Navigator.of(context).pop();
    final snackBar = SnackBar(
      content: Text(resultHTTP.body),
      behavior: SnackBarBehavior.floating, // Add this line
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  @override
  Widget build(BuildContext context) {
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
                      onPressed: amountOwed > 0 ? ()=>initiatePayout() : null,
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
}
