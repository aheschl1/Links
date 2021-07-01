import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:links/constants/level_types.dart';
import 'package:links/screens/settings/account_level_descriptions/basic_description.dart';
import 'package:links/services/database_service.dart';
import 'package:http/http.dart' as http;

class AccountLevel extends StatefulWidget {
  const AccountLevel({Key key}) : super(key: key);

  @override
  _AccountLevelState createState() => _AccountLevelState();
}

class _AccountLevelState extends State<AccountLevel> {

  AccountLevels accountLevelStatus;

  startPayment(String amount, int level, Function paymentSuccess) async {
    final request = BraintreeDropInRequest(
      tokenizationKey: 'sandbox_q7zgyn9g_fr7wvkwvcn3mw39z',
      collectDeviceData: true,
      googlePaymentRequest: BraintreeGooglePaymentRequest(
        totalPrice: amount,
        currencyCode: 'CAD',
        billingAddressRequired: false,
      ),
      paypalRequest: BraintreePayPalRequest(
        amount: amount,
        displayName: 'Links',
      ),
    );

    BraintreeDropInResult result = await BraintreeDropIn.start(request);

    if (result != null) {
      var resultHTTP = await http.post(
          Uri.parse("https://us-central1-links-170cf.cloudfunctions.net/upgradeAccount"),
          body: {
            'payment_method_nonce': result.paymentMethodNonce.toString(),
            'ammount': amount,
            'device_data': result.deviceData,
            'userID': FirebaseAuth.instance.currentUser.uid,
            'upgradeLevel' : level.toString()
          });

      if (resultHTTP.body != "Error") {
        paymentSuccess(resultHTTP.body);
      }
    } else {
      print('Selection was canceled.');
    }
  }

  void basicLevelClicked(){
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_)=>BasicDescription()
        )
    );
  }

  void proLevelClicked(){
    startPayment('2', 1, (String data){
      Navigator.of(context).pop();
      final snackBar = SnackBar(
        content: Text('You have successfully been upgraded to a pro account'),
        behavior: SnackBarBehavior.floating, // Add this line
      );
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar,
      );
    });
  }

  void advertiserLevelClicked(){

  }

  void getAccountLevel() async {
    var level = await DatabaseService().getAccountLevel();
    setState(() {
      accountLevelStatus = level;
    });
  }

  @override
  void initState() {
    super.initState();
    getAccountLevel();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            onTap: ()=>basicLevelClicked(),
            title: Text('Basic'),
            subtitle: Text('Free access to most features.'),
            tileColor: accountLevelStatus == AccountLevels.BASIC ? Colors.purple[200] : Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            trailing: accountLevelStatus == AccountLevels.BASIC ? Icon(Icons.star) : null,
          ),
          SizedBox(height: 10,),
          ListTile(
            onTap: ()=>proLevelClicked(),
            title: Text('Pro'),
            subtitle: Text('Access to all pro features. This includes creating paid events.'),
            isThreeLine: true,
            tileColor: accountLevelStatus == AccountLevels.PRO ? Colors.purple[200] : Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            trailing: accountLevelStatus == AccountLevels.PRO ? Icon(Icons.star) : null,
          ),
          SizedBox(height: 10,),
          ListTile(
            onTap: ()=>advertiserLevelClicked(),
            title: Text('Advertiser (Not yet available)'),
            subtitle: Text('Advertise your business on other peoples posts!'),
            tileColor: accountLevelStatus == AccountLevels.ADVERTISER ? Colors.purple[200] : Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            trailing: accountLevelStatus == AccountLevels.ADVERTISER ? Icon(Icons.star) : null,
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'All account levels over basic remove ads',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54
              ),
            ),
          ),
        ],
      ),
    );
  }
}
