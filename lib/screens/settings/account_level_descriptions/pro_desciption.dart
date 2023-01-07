
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:http/http.dart' as http;
import 'package:links/constants/payment_constants.dart';

class ProDescription extends StatelessWidget {

  const ProDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    startPayment(String amount, int level, Function(String) paymentSuccess, Function(String) paymentFailure) async {
      final request = BraintreeDropInRequest(
        tokenizationKey: BraintreeConstants.getTokenizationKey(),
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
                  new Text("Account upgrade in progress"),
                ],
              ),
            ),
          );
        },
      );

      BraintreeDropInResult? result = await BraintreeDropIn.start(request);

      if (result != null) {
        var resultHTTP = await http.post(
            Uri.parse("https://us-central1-links-170cf.cloudfunctions.net/upgradeAccount"),
            body: {
              'payment_method_nonce': result.paymentMethodNonce.toString(),
              'ammount': amount,
              'device_data': result.deviceData,
              'userID': FirebaseAuth.instance.currentUser!.uid,
              'upgradeLevel' : level.toString()
            });
        Navigator.pop(context);
        if (resultHTTP.body != "Error") {
          paymentSuccess(resultHTTP.body);
        }else{
          paymentFailure(resultHTTP.body);
        }
      } else {
        Navigator.pop(context);
      }
    }

    upgrade(){
      startPayment('2', 1, (String data){
        Navigator.of(context).pop(true);
      },(String data){
        Navigator.of(context).pop(false);
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Pro Account',
                style: TextStyle(
                    fontSize: 30
                ),
              ),
              SizedBox(height: 10, width: double.infinity,),
              Text(
                'Pro accounts give you access to all features, not including advertisement abilities. A pro account is great for people who want to post paid events, and have access to any future pro features!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(10),
                  children: [
                    ListTile(
                      title: Text('Create free events and groups'),
                      trailing: Icon(Icons.check),
                      tileColor:Colors.black26,
                    ),
                    SizedBox(height: 10,),
                    ListTile(
                      title: Text('Join events and groups'),
                      trailing: Icon(Icons.check),
                      tileColor:Colors.black26,
                    ),
                    SizedBox(height: 10,),
                    ListTile(
                      title: Text('Subscribe to notifications'),
                      trailing: Icon(Icons.check),
                      tileColor:Colors.black26,
                    ),
                    SizedBox(height: 10,),
                    ListTile(
                      title: Text('Use social features'),
                      trailing: Icon(Icons.check),
                      tileColor:Colors.black26,
                    ),
                    SizedBox(height: 10,),
                    ListTile(
                      title: Text('Create paid events'),
                      trailing: Icon(Icons.check),
                      tileColor:Colors.black26,
                    ),
                    SizedBox(height: 10,),
                    ListTile(
                      title: Text('Ad free'),
                      trailing: Icon(Icons.check),
                      tileColor:Colors.black26,
                    ),
                    SizedBox(height: 10,),
                    ListTile(
                      title: Text('Business tools'),
                      trailing: Icon(Icons.not_interested),
                      tileColor:Colors.black26,
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListTile(
            onTap: ()=>upgrade(),
            title: Text('Upgrade'),
            subtitle: Text('Upgrade your account to pro!'),
            tileColor: Colors.purple[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            trailing: Icon(Icons.star)
        ),
      ),
    );
  }
}
