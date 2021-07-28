import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter/material.dart';
import 'package:links/constants/event.dart';
import 'package:links/constants/friend_data.dart';
import 'package:links/constants/request.dart';
import 'package:links/services/database_service.dart';
import 'package:links/widgets/event_widget.dart';

import 'package:http/http.dart' as http;
import 'package:links/widgets/user_in_group.dart';

class PaymentMainPage extends StatefulWidget {
  @override
  _PaymentMainPageState createState() => _PaymentMainPageState();
}

class _PaymentMainPageState extends State<PaymentMainPage> {
  Event event;
  FriendData me;

  startPayment() async {

    final request = BraintreeDropInRequest(
      tokenizationKey: 'sandbox_q7zgyn9g_fr7wvkwvcn3mw39z',
      collectDeviceData: true,
      googlePaymentRequest: BraintreeGooglePaymentRequest(
        totalPrice: event.admissionPrice,
        currencyCode: 'CAD',
        billingAddressRequired: false,
      ),
      paypalRequest: BraintreePayPalRequest(
        amount: event.admissionPrice,
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
                new Text("Awaiting payment completion..."),
              ],
            ),
          ),
        );
      },
    );

    BraintreeDropInResult result = await BraintreeDropIn.start(request);

    if (result != null) {
      var resultHTTP = await http.post(
          Uri.parse("https://us-central1-links-170cf.cloudfunctions.net/paypalPayment"),
          body: {
            'payment_method_nonce': result.paymentMethodNonce.toString(),
            'ammount': event.admissionPrice,
            'device_data': result.deviceData,
            'userID': FirebaseAuth.instance.currentUser.uid,
            'eventId': event.docId,
            'paymentRecipient': event.owner
          });

      Navigator.pop(context);

      if (resultHTTP.body != "Error") {
        paymentSuccess(resultHTTP.body);
      }
    } else {
      Navigator.pop(context);
      print('Selection was canceled.');
    }
  }

  void paymentSuccess(String body) {
    joinEvent(event);
  }

  joinEvent(Event event) async {
    String result;


    if(!event.requireConfirmation){
      result = await DatabaseService().joinEvent(event);
    }else{
      Request request = Request(userId: FirebaseAuth.instance.currentUser.uid, decision: Request.PENDING, userEmail: me.email, userName: me.name);
      result = await DatabaseService().requestToJoin(event, request);
    }
    final snackBar = SnackBar(
      content: Text(result),
      behavior: SnackBarBehavior.floating, // Add this line
    );
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar,
    );

    if(!event.requireConfirmation){
      Navigator.of(context).pushReplacementNamed("/view_event", arguments:  event);
    }else{
      Navigator.of(context).pop();
    }

  }
  getMe()async{
    me = FriendData.fromMap(await DatabaseService().getUser(FirebaseAuth.instance.currentUser.uid));
  }

  viewFriendProfile(FriendData friendData){
    Navigator.of(context).pushNamed('/view_profile', arguments: friendData);
  }

  @override
  Widget build(BuildContext context) {
    event = ModalRoute.of(context).settings.arguments as Event;
    event.location = 'Location hidden until you pay';
    getMe();
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment to join"),
      ),
      body: Column(
        children: [
          WidgetMyPage(event),
          SizedBox(height: 10,),
          ViewUsersInGroup(event: event, onTap: viewFriendProfile,),
          Spacer(),
          Text(
            '8% of this payment will be collected as a transaction fee. If refunded, you will receive 92% back.',
            style: TextStyle(
              color: Colors.white24,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8,),
          Container(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ))),
                onPressed: () => startPayment(),
                icon: Icon(Icons.payment),
                label: Text("Pay and join")),
          )
        ],
      ),
    );
  }

}
